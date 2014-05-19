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
#import "timeArrSort.h"
#import "CheckInfoWithCommunity.h"
#import "UIFont+RT.h"

@implementation CheckoutCell

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
    self.textLabel.textColor = [UIColor ajkMiddleGrayColor];

    if (cellType == CHECKOUTCELLWITHELSE) {
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
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 200, 55)];
        lab.textColor = [UIColor ajkMiddleGrayColor];
        lab.font = [UIFont ajkH3Font];
        lab.text = @"签到前3位有展示位哦~";
        [self.contentView addSubview:lab];
        
        self.textLabel.font = [UIFont ajkH3Font];
    }
    if (cellType == CHECKOUTCELLWITHCHCK) {
        self.textLabel.text = [NSString stringWithFormat:@"%@",timeSection];
        self.textLabel.font = [UIFont ajkH3Font_B];
        NSArray *checkSectionArr = [[NSArray alloc] initWithArray:[[checkPersion objectAtIndex:index-1] objectForKey:@"brokers"]];
        for (int i = 0; i < checkSectionArr.count; i++) {
            WebImageView *checkAvatar = [[WebImageView alloc] initWithFrame:CGRectMake(70*i+70, 15, 50, 50)];
            checkAvatar.imageUrl = [[checkSectionArr objectAtIndex:i] objectForKey:@"brokerPhoto"];
            checkAvatar.contentMode = UIViewContentModeScaleAspectFill;
            checkAvatar.layer.masksToBounds = YES;
            checkAvatar.layer.cornerRadius = 25;
            checkAvatar.layer.borderWidth = 0.5;
            checkAvatar.layer.borderColor = [UIColor ajkLineColor].CGColor;
            [self.contentView addSubview:checkAvatar];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(70*i+70, checkAvatar.frame.origin.y+checkAvatar.frame.size.height+10, 50, 20)];
            lab.text = [[checkSectionArr objectAtIndex:i] objectForKey:@"brokerTrueName"];
            lab.font = [UIFont systemFontOfSize:12];
            lab.textColor = [UIColor ajkMiddleGrayColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lab];
        }
    }
}
@end
