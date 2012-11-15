//
//  VITableView.h
//  VokalUI
//
//  Created by Anthony Alesia on 11/15/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//
//  Requires SVPullToRefresh

#import <UIKit/UIKit.h>

@interface VITableView : UITableView

@property (strong, nonatomic) UIColor *arrowColor;
@property (strong, nonatomic) UIColor *textColor;

- (void)addPullToRefreshWithTask:(void (^)(void))task;
- (void)refreshView;
- (void)endRefresh;

@end
