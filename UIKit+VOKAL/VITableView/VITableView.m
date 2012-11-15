//
//  VITableView.m
//  VokalUI
//
//  Created by Anthony Alesia on 11/15/12.
//  Copyright (c) 2012 VOKAL Interactive. All rights reserved.
//

#import "VITableView.h"
#import "SVPullToRefresh.h"

@interface VITableView ()
@property (strong, nonatomic) UIRefreshControl *refresh;
@property (strong, nonatomic) void (^task)(void);
@end

@implementation VITableView

- (void)setArrowColor:(UIColor *)arrowColor
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        self.pullToRefreshView.arrowColor = _arrowColor;
    } else {
        _refresh.tintColor = _arrowColor;
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        self.pullToRefreshView.textColor = _textColor;
    }
}

- (void)addPullToRefreshWithTask:(void (^)(void))task
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        [self addPullToRefreshWithActionHandler:task];
        self.pullToRefreshView.textColor = _textColor;
        self.pullToRefreshView.arrowColor = _arrowColor;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        self.pullToRefreshView.dateFormatter = formatter;
    } else {
        _task = [task copy];
        
        _refresh = [[UIRefreshControl alloc] init];
        _refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
        _refresh.tintColor = _arrowColor;
        [_refresh addTarget:self
                     action:@selector(refreshView:)
           forControlEvents:UIControlEventValueChanged];
        [self addSubview:_refresh];
    }
}

- (void)refreshView
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        [self.pullToRefreshView triggerRefresh];
    } else {
        [self refreshView:_refresh];
    }
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    _task();
}

- (void)endRefresh
{
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 6.0) {
        self.pullToRefreshView.lastUpdatedDate = [NSDate date];
        [self.pullToRefreshView stopAnimating];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
        _refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
        [_refresh endRefreshing];
    }
}

@end
