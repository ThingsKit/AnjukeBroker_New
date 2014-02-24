//
//  SSPullToRefreshSimpleContentView.h
//  SSPullToRefresh
//
//  Created by Sam Soffes on 5/17/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "AXPullToRefreshView.h"

@interface AXPullToRefreshContentView : UIView <AXPullToRefreshContentView>

@property (nonatomic, strong, readonly) UILabel *statusLabel;
@property (nonatomic, strong, readonly) UIImageView *arrowImageView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *activityIndicatorView;

@end
