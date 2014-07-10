//
//  CheckoutCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
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
    NSString *timeSection;
    NSArray *checkPersion;
    NSArray *timeAreaArr = [[NSArray alloc] initWithArray:[LoginManager getCheckTimeArr]];

    if (dataModel == nil) {
        if (index > 0 && index < timeAreaArr.count + 1) {
            timeSection =  [timeAreaArr objectAtIndex:index-1];
        }
    }else{
        CheckInfoWithCommunity *checkInfoModel = (CheckInfoWithCommunity *)dataModel;
        checkPersion = [[NSArray alloc] initWithArray:checkInfoModel.signList];
        
        if (index > 0 && index <= timeAreaArr.count) {
            timeSection = [[checkPersion objectAtIndex:index-1] objectForKey:@"hour"];
        }
    }



    self.textLabel.textColor = [UIColor brokerMiddleGrayColor];

    if (cellType == CHECKOUTCELLWITHELSE) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        if (index == 0) {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(15, 18, 150, 12)];
            lab.text = @"今日签到展示位得主：";
            lab.textColor = [UIColor brokerMiddleGrayColor];
            lab.font = [UIFont ajkH5Font];
            lab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:lab];
        
        }else if(index == timeAreaArr.count+1){
            UILabel *lab = [[UILabel alloc] initWithFrame:self.frame];
            lab.text = @"了解签到规则";
            lab.font = [UIFont ajkH4Font];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:lab];
        }
    }
    
    if (cellType == CHECKOUTCELLWITHNOCHECK) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
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
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
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
            NSString *imgUrl = [[checkSectionArr objectAtIndex:i] objectForKey:@"brokerPhoto"];
            
            if (!imgUrl || imgUrl.length == 0) {
                [checkAvatar setImage:[UIImage imageNamed:@"anjuke_icon_headpic"]];
            }else{
                checkAvatar.imageUrl = [[checkSectionArr objectAtIndex:i] objectForKey:@"brokerPhoto"];
            }
            checkAvatar.contentMode = UIViewContentModeScaleAspectFill;
            checkAvatar.layer.masksToBounds = YES;
            checkAvatar.layer.cornerRadius = 25;
            checkAvatar.layer.borderWidth = 0.5;
            checkAvatar.layer.borderColor = [UIColor brokerLineColor].CGColor;
            [self.checkerInfo addSubview:checkAvatar];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(70*i, checkAvatar.frame.origin.y+checkAvatar.frame.size.height+10, 50, 20)];
            lab.text = [[checkSectionArr objectAtIndex:i] objectForKey:@"brokerTrueName"];
            lab.font = [UIFont systemFontOfSize:10];
            lab.backgroundColor = [UIColor clearColor];
            lab.textColor = [UIColor brokerMiddleGrayColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [self.checkerInfo addSubview:lab];
        }
    }
    
    //分割线绘制
    if (index == 0) {
        [self showTopLine];
        self.backgroundColor = [UIColor clearColor];
    }else if (index == timeAreaArr.count + 1){
        self.backgroundColor = [UIColor clearColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        
        if (index == 1){
            [self showTopLine];
            if (index != timeAreaArr.count) {
                if (cellType == CHECKOUTCELLWITHNOCHECK) {
                    [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
                }else{
                    [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
                }
            }
        }else if (index == timeAreaArr.count) {
            if (cellType == CHECKOUTCELLWITHNOCHECK) {
                [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK];
            }else{
                [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK];
            }
        }else{
            if (cellType == CHECKOUTCELLWITHNOCHECK) {
                [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
            }else{
                [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
            }
        }
    }
    
//    else if (index == 1){
//        self.backgroundColor = [UIColor whiteColor];
//        [self showTopLine];
//        if (cellType == CHECKOUTCELLWITHNOCHECK) {
//            [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
//        }else{
//            [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
//        }
//    }else if (index == 2){
//        self.backgroundColor = [UIColor whiteColor];
//        if (cellType == CHECKOUTCELLWITHNOCHECK) {
//            [self showBottonLineWithCellHeight:CELLHEIGHT_NOCHECK andOffsetX:15];
//        }else{
//            [self showBottonLineWithCellHeight:CELLHEIGHT_CHECK andOffsetX:15];
//        }
//    }else if (index == 3){
//        self.backgroundColor = [UIColor whiteColor];
//
//    }
}
@end
