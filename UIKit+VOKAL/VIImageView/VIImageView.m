//
//  VIImageView.m
//  VokalUI
//
//  Created by Anthony Alesia on 12/14/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import "VIImageView.h"

@interface VIImageView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) VIImageOperation *operation;

@end

@implementation VIImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:self.imageView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithCoder:aDecoder];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = self.frame;
    self.imageView.autoresizingMask = self.autoresizingMask;
    self.imageView.contentMode = self.contentMode;
    self.imageView.clipsToBounds = self.clipsToBounds;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = image;
}

- (void)setImageUrl:(NSString *)imageUrl defaultImage:(UIImage *)defaultImage animated:(BOOL)animated
{
    [self cancelOperation];
    
    if (defaultImage != nil) {
        self.defaultImage = defaultImage;
    }
    
    self.operation = [[VIImageOperation alloc] init];
    
    [_operation fetchImageForImageView:self
                               fromURL:imageUrl
                            completion:^(UIImage *image, BOOL isFromCache) {
                                if (image != nil) {
                                    self.image = image;
                                    
                                    if (animated && !isFromCache) {
                                        CATransition *animation = [CATransition animation];
                                        [animation setDuration:0.2];
                                        [animation setType:kCATransitionFade];
                                        [animation setSubtype:kCATransitionFade];
                                        
                                        [[self layer] addAnimation:animation forKey:@"DisplayView"];
                                        
                                        self.image = image;
                                        
                                        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width+1, self.frame.size.height+1);
                                        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width-1, self.frame.size.height-1);
                                    }
                                } else if (self.defaultImage != nil) {
                                    self.image = defaultImage;
                                } else {
                                    self.image = nil;
                                }
                            }];
}

- (void)cancelOperation
{
    if (_operation != nil) {
        [self.operation cancel];
        [self setOperation:nil];
    }
}

@end

@interface VIImageOperation ()
@property (strong, nonatomic) __block NSBlockOperation *operation;
@end

@implementation VIImageOperation

#define MAX_CACHE   30

static NSOperationQueue *_queue = nil;
static NSMutableArray *_localCache = nil;

+ (NSOperationQueue *)getQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return _queue;
}

+ (NSMutableArray *)getLocalCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _localCache = [[NSMutableArray alloc] init];
    });
    
    return _localCache;
}

- (void)fetchImageForImageView:(VIImageView *)imageView fromURL:(NSString *)uniquePath completion:(void (^)(UIImage *image, BOOL isFromCache))completion
{
    UIImage *localImage = [self imageFromCache:uniquePath];
    
    if (localImage != nil) {
        completion(localImage, YES);
        return;
    }
    
    if (imageView.defaultImage != nil) {
        imageView.image = imageView.defaultImage;
    } else {
        imageView.image = nil;
    }
    
    self.operation = [NSBlockOperation blockOperationWithBlock:^{
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:uniquePath]
                                                      cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                  timeoutInterval:5.0];
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        
        UIImage *image = [UIImage imageWithData:data scale:2.0];
        [self addToCache:uniquePath image:image];
        
        if (![self.operation isCancelled]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image, YES);
            });
        }
    }];
    
    [[VIImageOperation getQueue] addOperation:self.operation];
}

- (void)cancel
{
    [self.operation cancel];
}

#pragma mark - Local Cache

- (UIImage *)imageFromCache:(NSString *)imageUrl
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(image_url == %@)", imageUrl];
    NSArray *matchingDicts = [[[VIImageOperation getLocalCache] copy] filteredArrayUsingPredicate:predicate];
    
    if ([matchingDicts count] > 0) {
        return [[matchingDicts lastObject] valueForKey:@"image"];
    }
    
    return nil;
}

- (void)addToCache:(NSString *)imageUrl image:(UIImage *)image
{
    if (MAX_CACHE == 0) {
        return;
    }
    
    NSDictionary *dictionary = @{@"image" : image, @"image_url" : imageUrl};
    
    [[VIImageOperation getLocalCache] addObject:dictionary];
    
    if ([[VIImageOperation getLocalCache] count] > MAX_CACHE) {
        [[VIImageOperation getLocalCache] removeObjectAtIndex:0];
    }
}

@end
