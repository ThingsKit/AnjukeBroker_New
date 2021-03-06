//
//  UserCenterHeaderCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-6.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "UserCenterHeaderCell.h"
#import "BK_WebImageView.h"
#import "LoginManager.h"
#import "Util_UI.h"


@implementation UserCenterHeaderCell
@synthesize userLevelBtn;
@synthesize userLeftMoney;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 84)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    
    BK_WebImageView * userAvatar = [[BK_WebImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)];
    if (![LoginManager getUse_photo_url] || [LoginManager getUse_photo_url].length == 0) {
        [userAvatar setImage:[UIImage imageNamed:@"anjuke_icon_headpic"]];
    }else{
        if (![[RTApiRequestProxy sharedInstance] isInternetAvailiable]) {
            [userAvatar setImage:[UIImage imageNamed:@"anjuke_icon_headpic"]];
        }else{
            userAvatar.imageUrl = [LoginManager getUse_photo_url];
        }
    }
    userAvatar.contentMode = UIViewContentModeScaleAspectFill;
    userAvatar.layer.masksToBounds = YES;
    userAvatar.layer.cornerRadius = 5;
    userAvatar.layer.borderWidth = 2.5;
    userAvatar.layer.borderColor = [UIColor clearColor].CGColor;
    [self.contentView addSubview:userAvatar];

    CGSize size = [Util_UI sizeOfString:[LoginManager getRealName] maxWidth:150 withFontSize:19];
    
    UILabel * userName = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.frame.origin.x+userAvatar.frame.size.width + 10, 12, size.width, 20)];
    userName.backgroundColor = [UIColor clearColor];
    userName.text = [LoginManager getRealName];
    userName.layer.shadowColor = [UIColor brokerWhiteColor].CGColor;
    userName.layer.shadowOffset = CGSizeMake(3, 3);
    userName.font = [UIFont ajkH1Font];
    userName.textColor = [UIColor brokerBlackColor];
    userName.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:userName];
    
    self.userLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userLevelBtn.frame = CGRectMake(userName.frame.origin.x+userName.frame.size.width + 10, 15, 56, 18);
    [self.userLevelBtn setBackgroundImage:[UIImage imageNamed:@"broker_my_icon_freshman"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.userLevelBtn];
    
    self.userLeftMoney = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.frame.origin.x + userAvatar.frame.size.width + 10, userName.frame.origin.y + userName.frame.size.height + 10, 180, 20)];
    self.userLeftMoney.text = @"我的账户: - 元";
    self.userLeftMoney.font = [UIFont ajkH3Font];
    self.userLeftMoney.textColor = [UIColor brokerBlackColor];
    self.userLeftMoney.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.userLeftMoney];
}

- (void)updateUserHeaderInfo:(BOOL)isSDX leftMoney:(NSString *)leftMoney
{
    if (isSDX) {
        [self.userLevelBtn setBackgroundImage:[UIImage imageNamed:@"broker_my_icon_freshman"] forState:UIControlStateNormal];
    }else{
        [self.userLevelBtn setBackgroundImage:[UIImage imageNamed:@"broker_my_icon_nofreshman"] forState:UIControlStateNormal];
    }
    
    self.userLeftMoney.text = [NSString stringWithFormat:@"我的账户: %@ 元",leftMoney];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
