//
//  FootCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "FootCell.h"

@implementation FootCell
//@synthesize cellStatus;
@synthesize tipsLab;
@synthesize activeRefresh;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}

- (UIActivityIndicatorView *)activeRefresh{
    if (activeRefresh == nil) {
        self.activeRefresh = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activeRefresh.frame = CGRectMake(50, 15, 30, 30);
    }
    return activeRefresh;
}

- (void)initUI{
    self.tipsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    self.tipsLab.backgroundColor = [UIColor clearColor];
    self.tipsLab.font = [UIFont ajkH3Font];
    self.tipsLab.textAlignment = NSTextAlignmentCenter;
    self.tipsLab.textColor = [UIColor brokerLightGrayColor];
    [self.contentView addSubview:self.tipsLab];
}

- (void)setCellStatus:(FootCellStatus)cellStatus{
    [self.activeRefresh stopAnimating];
    self.activeRefresh = nil;
    
    if (cellStatus == FootCellStatusForRefresh) {
        [self.contentView addSubview:self.activeRefresh];
        [self.activeRefresh startAnimating];

        self.tipsLab.text = @"正在加载中...";
    }else if (cellStatus == FootCellStatusForLoadSuc){
        self.tipsLab.text = @"加载成功";
    }else if (cellStatus == FootCellStatusForNetWorkError){
        self.tipsLab.text = @"网络不畅，稍候重试";
    }else if (cellStatus == FootCellStatusForLoadFail){
        self.tipsLab.text = @"加载失败,请重新上拉加载";
    }else{
        self.tipsLab.text = @"上拉加载数据";
    }
}

@end
