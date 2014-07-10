//
//  NoDataViewForESF.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-26.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "NoDataViewForESF.h"
#import "UIView+AF.h"

@implementation NoDataViewForESF

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        // Initialization code
    }
    return self;
}

- (void)initUI {
    //    [self setBackgroundColor:[UIColor redColor]];
    self.noNetworkView = [[UIImageView alloc] init];
    [self addSubview:self.noNetworkView];
    
    self.noDataCenterIMG = [[UIImageView alloc] init];
    [self addSubview:self.noDataCenterIMG];
    
    self.noDataPointIMG = [[UIImageView alloc] init];
    [self addSubview:self.noDataPointIMG];
    
    self.title = [[UILabel alloc] init];
    self.title.numberOfLines = 0;
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor brokerLightGrayColor];
    self.title.lineBreakMode = NSLineBreakByCharWrapping;
    self.title.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.title];
    
    [self setImgForImageViews];
}

- (void)setImgForImageViews {
    
    self.noNetworkView.image = [UIImage imageNamed:@"check_no_wifi.png"];
    self.noNetworkView.frame = CGRectMake(104.0f, 135.0f, 112.0f, 80.0f);
    self.noDataCenterIMG.image = [UIImage imageNamed:@"pic_3.4_01.png"];
    self.noDataCenterIMG.frame = CGRectMake(104.0f, 135.0f, 112.0f, 80.0f);
    self.noDataPointIMG.image = [UIImage imageNamed: @"pic_3.4_02.png"];
    self.noDataPointIMG.frame = CGRectMake(255.0f, 15.0f, 35.0f, 64.0f);
}

- (void)showNoDataView {
    self.title.frame = CGRectMake(120, self.noDataCenterIMG.bottom + 15, 80, 40);
    self.noNetworkView.hidden = YES;
    self.title.text = @"  暂无房源 快去发布吧";
    self.noDataCenterIMG.hidden = NO;
    self.noDataPointIMG.hidden = NO;
}

- (void)showNoNetwork {
    self.title.frame = CGRectMake(110, self.noNetworkView.bottom + 15, 100, 40);
    self.noNetworkView.hidden = NO;
    self.title.text = @"网络连接失败";
    self.noDataCenterIMG.hidden = YES;
    self.noDataPointIMG.hidden = YES;
}

@end
