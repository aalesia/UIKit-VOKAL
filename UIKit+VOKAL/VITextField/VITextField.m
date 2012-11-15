//
//  VITextField.m
//  VokalUI
//
//  Created by Anthony Alesia on 11/15/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import "VITextField.h"

@interface VITextField ()

@end

@implementation VITextField

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _defaultBackgroundImage = self.background;
    }
    
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self updateRectForBounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self updateRectForBounds:bounds];
}

- (CGRect)updateRectForBounds:(CGRect)bounds
{
    if (self.editing && _activeBackgroundImage != nil) {
        [self setBackground:_activeBackgroundImage];
    } else if (_defaultBackgroundImage != nil) {
        [self setBackground:_defaultBackgroundImage];
    }
    
    CGFloat insetWidth = bounds.size.width + _sizeOffset.width;
    
    if (self.editing &&
        (self.clearButtonMode == UITextFieldViewModeWhileEditing ||
         self.clearButtonMode == UITextFieldViewModeAlways)) {
            insetWidth = insetWidth - 18;
        }
    
    CGRect inset = CGRectMake(bounds.origin.x + _contentOffest.x, bounds.origin.y + _contentOffest.y, insetWidth, bounds.size.height + _sizeOffset.height);
    return inset;
}

- (void)setBackground:(UIImage *)background
{
    if (_defaultBackgroundImage == nil) {
        _defaultBackgroundImage = background;
    }
    
    [super setBackground:background];
}

@end
