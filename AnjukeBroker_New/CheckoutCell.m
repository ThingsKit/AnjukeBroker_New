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
- (void)configurCell:(id)dataModel withIndex:(int)index cellType:(CHECKOUTCELLTYPE)cellType{
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
        if (index == 1) {
            self.textLabel.text = @"10:00  签到前3位有展示位哦~";
        }else if (index == 2){
            self.textLabel.text = @"15:00  签到前3位有展示位哦~";
        }else if (index == 3){
            self.textLabel.text = @"21:00  签到前3位有展示位哦~";
        }
    }
    if (cellType == CHECKOUTCELLWITHCHCK) {
        if (index == 1) {
            self.textLabel.text = @"10:00";
        }else if (index == 2){
            self.textLabel.text = @"15:00";
        }else if (index == 3){
            self.textLabel.text = @"21:00";
        }
        
        for (int i = 0; i < 3; i++) {
            WebImageView *checkAvatar = [[WebImageView alloc] initWithFrame:CGRectMake(80*i+70, 10, 60, 60)];
            checkAvatar.imageUrl = [LoginManager getUse_photo_url];
            checkAvatar.contentMode = UIViewContentModeScaleAspectFill;
            checkAvatar.layer.masksToBounds = YES;
            checkAvatar.layer.cornerRadius = 30;
            [self.contentView addSubview:checkAvatar];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(80*i+70, checkAvatar.frame.origin.y+checkAvatar.frame.size.height+5, 60, 20)];
            lab.text = @"江小明";
            lab.textAlignment = NSTextAlignmentCenter;
            [self.contentView addSubview:lab];
        }
    }
}
@end
