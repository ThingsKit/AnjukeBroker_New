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

- (void)configurCell:(NSDictionary *)dataModel withIndex:(int)index cellType:(CHECKOUTCELLTYPE)cellType{
    NSString *timeArea;
    NSMutableDictionary *checkDic;
    if (dataModel == nil) {
        NSArray *timeAreaArr = [[NSArray alloc] initWithArray:[LoginManager getCheckTimeArr]];
        if (index > 0 && index < 4) {
            timeArea =  [timeAreaArr objectAtIndex:index-1];
        }
    }else{
        checkDic = [[NSMutableDictionary alloc] initWithDictionary:dataModel];
        DLog(@"checkDic--->>%@",checkDic);
        if (index > 0 && index < 4) {
            timeArea = [checkDic.allKeys objectAtIndex:index-1];
        }
    }

    if (cellType == CHECKOUTCELLWITHELSE) {
        if (index == 0) {
            self.textLabel.text = @"今日签到展示位得主：";
        }else if(index == 4){
            self.textLabel.text = @"了解签到规则";
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            self.selectionStyle = UITableViewCellSelectionStyleGray;
        }
    }
    
    if (cellType == CHECKOUTCELLWITHNOCHECK) {
        self.textLabel.text = [NSString stringWithFormat:@"%@  签到前3位有展示位哦~",timeArea];
    }
    if (cellType == CHECKOUTCELLWITHCHCK) {
        self.textLabel.text = [NSString stringWithFormat:@"%@",timeArea];
        NSArray *checkArr = [[NSArray alloc] initWithArray:checkDic[timeArea]];
        for (int i = 0; i < checkArr.count; i++) {
            WebImageView *checkAvatar = [[WebImageView alloc] initWithFrame:CGRectMake(80*i+70, 10, 60, 60)];
            checkAvatar.imageUrl = [[checkArr objectAtIndex:i] objectForKey:@"brokerPhoto"];
            checkAvatar.contentMode = UIViewContentModeScaleAspectFill;
            checkAvatar.layer.masksToBounds = YES;
            checkAvatar.layer.cornerRadius = 30;
            [self.contentView addSubview:checkAvatar];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(80*i+70, checkAvatar.frame.origin.y+checkAvatar.frame.size.height+5, 60, 20)];
            lab.text = [[checkArr objectAtIndex:i] objectForKey:@"brokerTrueName"];
            lab.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lab];
        }
    }
}
@end
