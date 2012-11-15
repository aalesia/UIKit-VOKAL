//
//  VITextView.m
//  VokalUI
//
//  Created by Anthony Alesia on 11/15/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import "VITextView.h"

@interface VITextView ()

@property (strong, nonatomic) UILabel *placeholderLabel;
@property (strong, nonatomic) UIImageView *backgroundImageView;

- (void)registerWithDefaultNotifcationCenter;
- (void)didBeginEditingText:(NSNotification *)notification;
- (void)didChangeText:(NSNotification *)notification;
- (void)didEndEditingText:(NSNotification *)notification;

@end

@implementation VITextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerWithDefaultNotifcationCenter];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerWithDefaultNotifcationCenter];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerWithDefaultNotifcationCenter
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(didBeginEditingText:) name:UITextViewTextDidBeginEditingNotification object:self];
    [defaultCenter addObserver:self selector:@selector(didChangeText:) name:UITextViewTextDidChangeNotification object:self];
    [defaultCenter addObserver:self selector:@selector(didEndEditingText:) name:UITextViewTextDidEndEditingNotification object:self];
}

- (void)didBeginEditingText:(NSNotification *)notification
{
    self.placeholderLabel.hidden = self.hasText;
    self.backgroundImageView.highlighted = YES;
}

- (void)didChangeText:(NSNotification *)notification
{
    self.placeholderLabel.hidden = self.hasText;
}

- (void)didEndEditingText:(NSNotification *)notification
{
    self.placeholderLabel.hidden = self.hasText;
    self.backgroundImageView.highlighted = NO;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    [self setNeedsLayout];
}

- (void)setBackground:(UIImage *)background
{
    _background = background;
    [self setNeedsLayout];
}

- (void)setActiveBackgroundView:(UIImage *)activeBackground
{
    _activeBackground = activeBackground;
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    if (!self.placeholderLabel) {
        CGRect frame = CGRectMake(8.0, 8.0, 0.0, 0.0);
        self.placeholderLabel = [[UILabel alloc] initWithFrame:frame];
        [self addSubview:self.placeholderLabel];
        [self sendSubviewToBack:self.placeholderLabel];
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
        self.placeholderLabel.backgroundColor = [UIColor clearColor];
    }
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.font = self.font;
    [self.placeholderLabel sizeToFit];
    
    if (!self.backgroundImageView) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.backgroundImageView];
        [self sendSubviewToBack:self.backgroundImageView];
    }
    [self.backgroundImageView setImage:_background];
    [self.backgroundImageView setHighlightedImage:_activeBackground];
    if (!_activeBackground && _background) {
    	[self.backgroundImageView setHighlightedImage:_background];
    }
    self.backgroundImageView.frame = CGRectMake(0, self.contentOffset.y, self.frame.size.width, self.frame.size.height);
}

@end
