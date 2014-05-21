//
//  CheckoutCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutCell.h"
#import "WebImageView.h"
#import "LoginManager.h"
#import <QuartzCore/QuartzCore.h>
#import "CheckInfoWithCommunity.h"
#import "UIFont+RT.h"
#import "UIColor+BrokerRT.h"

#define CELLHEIGHT_NOFMAL 36
#define CELLHEIGHT_NOCHECK 55
#define CELLHEIGHT_CHECK 105

@implementation CheckoutCell
@synthesize detailLab;
@synthesize checkerInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)configurCell:(id)dataModel withIndex:(int)index cellType:(CHECKOUTCELLTYPE)cellType{
//    for (UIView *view in self.contentView.subviews) {
//        [view removeFromSuperview];
//    }
    
    NSString *timeSection;
    NSArray *checkPersion;
    if (dataModel == nil) {
        NSArray *timeAreaArr = [[NSArray alloc] initWithArray:[LoginManager getCheckTimeArr]];
        if (timeAreaArr.count == 0) {
            timeAreaArr = @[@"10:00",@"11:00",@"12:00"];            
        }
        DLog(@"timeAreaArr-->>%@",timeAreaArr);
        if (index > 0 && index < 4) {
            timeSection =  [timeAreaArr objectAtIndex:index-1];
        }
    }else{
        CheckInfoWithCommunity *checkInfoModel = (CheckInfoWithCommunity *)dataModel;
        checkPersion = [[NSArray alloc] initWithArray:checkInfoModel.signList];

        if (index > 0 && index < 4) {
            timeSection = [[checkPersion objectAtIndex:index-1] objectForKey:@"hour"];
        }
    }
    self.textLabel.textColor = [UIColor brokerMiddleGrayColor];

    if (cellType == CHECKOUTCELLWITHELSE) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        if (index == 0) {
            self.textLabel.text = @"今日签到展示位得主：";
            self.textLabel.font = [UIFont ajkH5Font];
        }else if(index == 4){
            self.textLabel.text = @"了解签到规则";
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            self.textLabel.font = [UIFont ajkH5Font];
        }
    }
    
    if (cellType == CHECKOUTCELLWITHNOCHECK) {
        self.textLabel.text = [NSString stringWithFormat:@"%@",timeSection];
        self.textLabel.font = [UIFont ajkH3Font_B];
        
        if (!self.detailLab) {
            self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 55)];
            self.detailLab.textColor = [UIColor brokerMiddleGrayColor];
            self.detailLab.font = [UIFont ajkH3Font];
            self.detailLab.text = @"签到前3位有展示位哦~";
            self.detailLab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:self.detailLab];
        }
    }
    if (cellType == CHECKOUTCELLWITHCHCK) {
        if (self.detailLab) {
            [self.detailLab removeFromSuperview];
        }

        self.textLabel.text = [NSString stringWithFormat:@"%@",timeSection];
        self.textLabel.font = [UIFont ajkH3Font_B];
        NSArray *checkSectionArr = [[NSArray alloc] initWithArray:[[checkPersion objectAtIndex:index-1] objectForKey:@"brokers"]];
        if (self.checkerInfo) {
            [self.checkerInfo removeFromSuperview];
        }
        self.checkerInfo = [[UIView alloc] initWithFrame:CGRectMake(70, 0, 250, CELLHEIGHT_CHECK)];
        self.checkerInfo.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.checkerInfo];
        
        for (int i = 0; i < checkSectionArr.count; i++) {
            WebImageView *checkAvatar = [[WebImageView alloc] initWithFrame:CGRectMake(70*i, 15, 50, 50)];
            checkAvatar.imageUrl = [[checkSectionArr objectAtIndex:i] objectForKey:@"brokerPhoto"];
            checkAvatar.contentMode = UIViewContentModeScaleAspectFill;
            checkAvatar.layer.masksToBounds = YES;
            checkAvatar.layer.cornerRadius = 25;
            checkAvatar.layer.borderWidth = 0.5;
            checkAvatar.layer.borderColor = [UIColor brokerLineColor].CGColor;
            [self.checkerInfo addSubview:checkAvatar];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(70*i, checkAvatar.frame.origin.y+checkAvatar.frame.size.height+10, 50, 20)];
            lab.text = [[checkSectionArr objectAtIndex:i] objectForKey:@"brokerTrueName"];
            lab.font = [UIFont systemFontOfSize:12];
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor = [UIColor brokerMiddleGrayColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [self.checkerInfo addSubview:lab];
        }
    }
    
    //分割线绘制
    if (index == 0) {
        [self showTopLine];
    }else if (index == 1){
        [self showTopLine];
        if (cellType == CHECKOUTCELLWITHNOCHECK) {
            [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
        }else{
            [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
        }
    }else if (index == 2){
        if (cellType == CHECKOUTCELLWITHNOCHECK) {
            [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
        }else{
            [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
        }
    }else if (index == 3){
        if (cellType == CHECKOUTCELLWITHNOCHECK) {
            [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK];
        }else{
            [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK];
        }
    }else if (index == 4){
        [self showBottonLineWithCellHeight:CELLHEIGHT_NOFMAL];
    }
}
@end
