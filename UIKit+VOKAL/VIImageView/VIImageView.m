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
{
    BOOL* cancelledPtr;
}

@end

@implementation VIImageOperation

static NSOperationQueue *_queue = nil;

+ (NSOperationQueue *)getQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return _queue;
}

- (void)fetchImageFromURL:(NSString *)uniquePath completion:(void (^)(UIImage *image, BOOL isFromCache))completion
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:uniquePath]
                                                  cachePolicy:NSURLCacheStorageAllowed
                                              timeoutInterval:5.0];
    
    if ([[NSURLCache sharedURLCache] cachedResponseForRequest:request]) {
        [[VIImageOperation getQueue] addOperationWithBlock:^{
            NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
            NSData *data = response.data;
            __block UIImage *image = [self imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(image, YES);
            });
        }];
    } else {
        __block BOOL cancelled = NO;
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[VIImageOperation getQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                    __block UIImage *image = [self imageWithData:data];
                                   
                                   if (!cancelled) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           completion(image, NO);
                                       });
                                   }
                               }];
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
    if (cancelledPtr) {
        *cancelledPtr = YES;
    }
}

@end
