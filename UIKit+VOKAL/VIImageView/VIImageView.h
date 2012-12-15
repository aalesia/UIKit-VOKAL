//
//  VIImageView.h
//  VokalUI
//
//  Created by Anthony Alesia on 12/14/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface VIImageView : UIView

@property (nonatomic, strong) UIImage *image;

- (void)setImageUrl:(NSString *)imageUrl defaultImage:(UIImage *)defaultImage animated:(BOOL)animated;
- (void)cancelOperation;

@end

@interface VIImageOperation : NSObject

- (void)fetchImageForImageView:(VIImageView *)imageView fromURL:(NSString *)uniquePath completion:(void (^)(UIImage *image, BOOL isFromCache))completion;
- (void)cancel;

@end
