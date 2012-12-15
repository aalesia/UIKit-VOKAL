//
//  VIImageView.m
//  VokalUI
//
//  Created by Anthony Alesia on 12/14/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import "VIImageView.h"

@interface VIImageView ()

@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) VIImageOperation *operation;

@end

@implementation VIImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl defaultImage:(UIImage *)defaultImage animated:(BOOL)animated
{
    [self cancelOperation];
    
    if (defaultImage != nil) {
        self.defaultImage = defaultImage;
        self.image = self.defaultImage;
    }
    
    self.operation = [[VIImageOperation alloc] init];
    
    [_operation fetchImageFromURL:imageUrl
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

- (void)fetchImageFromURL:(NSString *)uniquePath completion:(void (^)(UIImage *image, BOOL isFromCache))completion
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:uniquePath]
                                                  cachePolicy:NSURLCacheStorageAllowed
                                              timeoutInterval:5.0];
    
    if ([[NSURLCache sharedURLCache] cachedResponseForRequest:request]) {
        NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        NSData *data = response.data;
        UIImage *image = [self imageWithData:data];
        
        if (![self.operation isCancelled]) {
            completion(image, YES);
        } else {
            NSLog(@"cancelled");
        }
    } else {
        self.operation = [NSBlockOperation blockOperationWithBlock:^{
            NSError *error = nil;
            NSHTTPURLResponse *response = nil;
            
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            UIImage *image = [self imageWithData:data];
            
            if (![self.operation isCancelled]) {
                completion(image, NO);
            } else {
                NSLog(@"cancelled");
            }
        }];
        
        [[VIImageOperation getQueue] addOperation:self.operation];
    }
}

- (UIImage *)imageWithData:(NSData *)data
{
    UIImage* image = [[UIImage alloc] initWithData: data];
    image = [UIImage imageWithCGImage:[image CGImage] scale:2.0 orientation:UIImageOrientationUp];

    return image;
}

- (void)cancel
{
    [self.operation cancel];
}

@end
