//
//  NoDataAndNoNetworkView.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 5/22/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataAndNoNetworkView : UIView

@property (nonatomic, strong) UIImageView *noNetworkView;
@property (nonatomic, strong) UIImageView *noDataCenterIMG;
@property (nonatomic, strong) UIImageView *noDataPointIMG;
@property (nonatomic, strong) UILabel *title;
- (void)showNoDataView;
- (void)showNoNetwork;

@end
