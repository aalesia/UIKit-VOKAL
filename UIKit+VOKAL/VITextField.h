//
//  VITextField.h
//  VokalUI
//
//  Created by Anthony Alesia on 11/15/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VITextField : UITextField

@property (nonatomic, strong) UIImage *activeBackgroundImage;
@property (nonatomic, strong) UIImage *defaultBackgroundImage;
@property (nonatomic, assign) CGSize sizeOffset;
@property (nonatomic, assign) CGPoint contentOffest;

@end
