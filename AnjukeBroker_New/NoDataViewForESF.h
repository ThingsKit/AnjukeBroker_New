//
//  NoDataViewForESF.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataViewForESF : UIView

@property (nonatomic, strong) UIImageView *noNetworkView;
@property (nonatomic, strong) UIImageView *noDataCenterIMG;
@property (nonatomic, strong) UIImageView *noDataPointIMG;
@property (nonatomic, strong) UILabel *title;
- (void)showNoDataView;
- (void)showNoNetwork;

@end
