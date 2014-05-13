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
@synthesize cellViewType;

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
- (void)configurCell:(id)dataModel withIndex:(int)index cellType:(CHECKOUTCELLTYPE)cellType;{
    if (index == 0) {
        self.textLabel.text = @"今日签到展示位得主:";
    }else if (index == 4){
        self.textLabel.text = @"了解签到规则";
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (cellType == CHECKOUTCELLWITHNOCHECK) {
        if (index == 1) {
            self.textLabel.text = @"10:00  签到前3位有展示位哦~";
        }else if (index == 2){
            self.textLabel.text = @"15:00  签到前3位有展示位哦~";
        }else if (index == 3){
            self.textLabel.text = @"21:00  签到前3位有展示位哦~";
        }
    }else if (cellType == CHECKOUTCELLWITHCHCK){
        if (index == 1) {
            self.textLabel.text = @"10:00";
        }else if (index == 2){
            self.textLabel.text = @"15:00";
        }else if (index == 3){
            self.textLabel.text = @"21:00";
        }
        for (int i = 0; i < 3; i++) {
            WebImageView *checkUserAvatar = [[WebImageView alloc] initWithFrame:CGRectMake(i*80+80, 10, 60, 60)];
            checkUserAvatar.imageUrl = [LoginManager getUse_photo_url];
            checkUserAvatar.contentMode = UIViewContentModeScaleAspectFill;
            checkUserAvatar.layer.masksToBounds = YES;
            checkUserAvatar.layer.cornerRadius = 30;
            [self.contentView addSubview:checkUserAvatar];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(i*80+80, checkUserAvatar.frame.size.height + checkUserAvatar.frame.origin.y+5, 60, 20)];
            lab.text = @"江小明";
            lab.backgroundColor = [UIColor clearColor];
            lab.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lab];
        }
    }
    
}
@end
