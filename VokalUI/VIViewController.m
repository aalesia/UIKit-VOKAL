//
//  VIViewController.m
//  VokalUI
//
//  Created by Anthony Alesia on 11/15/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import "VIViewController.h"
#import "VITextField.h"
#import "VITextView.h"

@interface VIViewController ()
@property (weak, nonatomic) IBOutlet VITextField *textField;
@property (weak, nonatomic) IBOutlet VITextView *textView;

@end

@implementation VIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_textField setBackground:[[UIImage imageNamed:@"txt_field_bg_normal.png"]
                         resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)]];
    [_textField setDisabledBackground:[[UIImage imageNamed:@"txt_field_bg_disabled.png"]
                                 resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)]];
    [_textField setActiveBackgroundImage:[[UIImage imageNamed:@"txt_field_bg_focused.png"]
                          resizableImageWithCapInsets:UIEdgeInsetsMake(12, 12, 12, 12)]];
    
    _textField.contentOffest = CGPointMake(8.0, 0.0);
    _textField.sizeOffset = CGSizeMake(-20.0, 0.0);
    _textField.placeholder = @"Placeholder";
    
    _textView.background = [[UIImage imageNamed:@"txt_field_bg_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 4, 21, 4)];
    _textView.activeBackground = [[UIImage imageNamed:@"txt_field_bg_focused.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(12, 4, 21, 4)];
    _textView.placeholder = @"Placeholder";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
