//
//  AXPublicLoading.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXPublicLoading.h"

@implementation AXPublicLoading

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    UIView * loadingMessageView = [[UIView alloc] initWithFrame:CGRectMake(110, ScreenHeight-20-44-32-49-10, 100, 32)];
    loadingMessageView.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
    bgView.backgroundColor = [UIColor colorWithHex:0x707070 alpha:1];
    bgView.alpha = 9;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 4;
    [loadingMessageView addSubview:bgView];
    
    UIActivityIndicatorView * activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.frame = CGRectMake(11, 3, 26, 26);
    [loadingMessageView addSubview:activityIndicatorView];
    
    [activityIndicatorView startAnimating];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(activityIndicatorView.frame.origin.x + activityIndicatorView.frame.size.width + 3, 4, 55, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"收取中";
    [loadingMessageView addSubview:label];

    [self addSubview:loadingMessageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
