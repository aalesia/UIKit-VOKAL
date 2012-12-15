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
#import "VITableView.h"
#import "VIImageCell.h"

@interface VIViewController ()
@property (weak, nonatomic) IBOutlet VITextField *textField;
@property (weak, nonatomic) IBOutlet VITextView *textView;
@property (weak, nonatomic) IBOutlet VITableView *tableView;

@property (strong, nonatomic) NSArray *images;

@end

@implementation VIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.images = [self imagesArray];
    
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
    
    [_tableView addPullToRefreshWithTask:^{
        [_tableView performSelector:@selector(endRefresh)
                         withObject:nil
                         afterDelay:2.0];
    }];
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdent = @"VIImageCell";
    
    VIImageCell *cell = (VIImageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdent];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VIImageCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib lastObject];
    }
    
    [cell.imageView setImageUrl:[self urlForCurrentIndex:indexPath.row]
                   defaultImage:nil
                       animated:YES];
    
    return cell;
}

#pragma mark - Image URLS

- (NSArray *)imagesArray
{
    return [NSArray arrayWithObjects:
            [NSNumber numberWithInt:2943],
            [NSNumber numberWithInt:3770],
            [NSNumber numberWithInt:3634],
            [NSNumber numberWithInt:3468],
            [NSNumber numberWithInt:3124],
            [NSNumber numberWithInt:3111],
            [NSNumber numberWithInt:2945],
            [NSNumber numberWithInt:2894],
            [NSNumber numberWithInt:2602],
            [NSNumber numberWithInt:2585],
            [NSNumber numberWithInt:1731],
            [NSNumber numberWithInt:2300],
            [NSNumber numberWithInt:1951],
            [NSNumber numberWithInt:1944],
            [NSNumber numberWithInt:3773],
            [NSNumber numberWithInt:3812],
            [NSNumber numberWithInt:3772],
            [NSNumber numberWithInt:3771],
            [NSNumber numberWithInt:844],
            [NSNumber numberWithInt:3713],
            [NSNumber numberWithInt:2588],
            [NSNumber numberWithInt:2954],
            [NSNumber numberWithInt:2966],
            [NSNumber numberWithInt:2260],
            [NSNumber numberWithInt:2347],
            [NSNumber numberWithInt:2985],
            [NSNumber numberWithInt:3257],
            [NSNumber numberWithInt:3121],
            [NSNumber numberWithInt:2059],
            [NSNumber numberWithInt:2253], nil];
}

- (NSString *)urlForCurrentIndex:(NSInteger)index
{
    int imageIndex = index % [_images count];
    
    return [NSString stringWithFormat:@"http://media.threadless.com//imgs/products/%@/636x460design_01.jpg", [[_images objectAtIndex:imageIndex] stringValue]];
}

- (NSString *)urlForRandomIndex
{
    int index = arc4random() % [_images count];
    
    return [NSString stringWithFormat:@"http://media.threadless.com//imgs/products/%@/636x460design_01.jpg", [[_images objectAtIndex:index] stringValue]];
}

@end
