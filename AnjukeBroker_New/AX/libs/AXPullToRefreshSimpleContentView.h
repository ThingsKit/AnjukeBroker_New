//
//  AXPullToRefreshSimpleContentView.h
//  X
//
//  Created by Gin on 2/20/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSPullToRefreshView.h"

@interface AXPullToRefreshSimpleContentView : UIView <SSPullToRefreshContentView>

@property (nonatomic, readonly) UILabel *statusLabel;
@property (nonatomic, readonly) UIActivityIndicatorView *activityIndicatorView;

@end
