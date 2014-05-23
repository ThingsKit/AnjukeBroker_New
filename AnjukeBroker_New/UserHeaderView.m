//
//  MoreHeaderView.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "UserHeaderView.h"
#import "BrokerLineView.h"
#import "BK_WebImageView.h"
#import "LoginManager.h"
#import "Util_UI.h"
#import "UIFont+RT.h"
#import "UIColor+BrokerRT.h"
#import "BrokerLogger.h"

@interface UserHeaderView () {
    
}
@property(nonatomic, strong) UIView *bannerView;
@property(nonatomic, strong) UIImageView *bannerImg;
@property(nonatomic, strong) UIActivityIndicatorView *activityView;
@property(nonatomic, strong) UIView *wchatView;
@property(nonatomic, strong) UILabel *propertyLab;
@property(nonatomic, strong) UILabel *responseTimeLab;
@property(nonatomic, strong) UILabel *totalCustomNumLab;
@property(nonatomic, strong) UILabel *totalLoginNumLab;
@property(nonatomic, strong) UILabel *propertyUnitLab;
@property(nonatomic, strong) UILabel *responseTimeUnitLab;
@property(nonatomic, strong) UILabel *totalCustomNumUnitLab;
@property(nonatomic, strong) UILabel *totalLoginNumUnitLab;
@property(nonatomic, strong) UIView *userHeaderView;
@property(nonatomic ,strong) UILabel *userName;
@property(nonatomic ,strong) UIButton *userLevelBtn;

@end

@implementation UserHeaderView
@synthesize sdxDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}
- (void)createView{
    _bannerView = [[UIView alloc] initWithFrame:self.bounds];
    _bannerView.clipsToBounds = YES;
    
    _bannerImg = [[UIImageView alloc] initWithFrame:_bannerView.frame];
    _bannerImg.contentMode = UIViewContentModeScaleToFill;
    [_bannerView addSubview:self.bannerImg];
    
    [self addSubview:self.bannerView];
    
    self.userHeaderView = [[UIView alloc] initWithFrame:CGRectMake(50, 52, 200, 80)];
    self.userHeaderView.backgroundColor = [UIColor clearColor];
    [_bannerView addSubview:self.userHeaderView];
    
    BK_WebImageView *userAvatar = [[BK_WebImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    userAvatar.imageUrl = [LoginManager getUse_photo_url];
    userAvatar.contentMode = UIViewContentModeScaleAspectFill;
    userAvatar.layer.masksToBounds = YES;
    userAvatar.layer.cornerRadius = 5;
    userAvatar.layer.borderWidth = 2.5;
    userAvatar.layer.borderColor = [UIColor brokerBgPageColor].CGColor;
    [self.userHeaderView addSubview:userAvatar];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(userAvatar.frame.origin.x+userAvatar.frame.size.width + 10, 8, 100, 20)];
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.text = @"";
    self.userName.layer.shadowColor = [UIColor brokerWhiteColor].CGColor;
    self.userName.layer.shadowOffset = CGSizeMake(3, 3);
    self.userName.font = [UIFont ajkH1Font];
    self.userName.textColor = [UIColor whiteColor];
    [self.userHeaderView addSubview:self.userName];
    
    self.userLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userLevelBtn.frame = CGRectMake(userAvatar.frame.origin.x+userAvatar.frame.size.width + 10, self.userName.frame.origin.y + self.userName.frame.size.height +6, 75, 20);
    [self.userLevelBtn setBackgroundImage:[UIImage imageNamed:@"user_noTalent"] forState:UIControlStateNormal];
    [self.userLevelBtn addTarget:self action:@selector(goSDX:) forControlEvents:UIControlEventTouchUpInside];
    [self.userHeaderView addSubview:self.userLevelBtn];
    
    self.wchatView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_bannerView.frame) - 50, [self windowWidth], 50)];
    self.wchatView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.3];
    [self addSubview:self.wchatView];
    
    NSArray *desStrArr = @[@"5分钟回复率",@"平均响应",@"累计客户",@"累计登录"];
    NSArray *widthArr = @[@"88",@"78",@"78",@"78"];
    
    for (int i = 0; i < 4; i++) {
        int originX = 0;
        int labOriginX = 0;
        for (int j = 0 ; j < i; j++) {
            originX += [[widthArr objectAtIndex:j] intValue];
        }
        if (i == 0) {
            labOriginX = 10;
        }else{
            labOriginX = 15;
        }
        
        BrokerLineView *line = [[BrokerLineView alloc] init];
        line.horizontalLine = NO;
        
        if (i != 0) {
            line.frame = CGRectMake(1+originX, 10, 1, 33);
            [self.wchatView addSubview:line];
        }

        UILabel *dataLab = [[UILabel alloc] initWithFrame:CGRectMake(labOriginX+originX, 10, 10, 15)];
        dataLab.backgroundColor = [UIColor clearColor];
        dataLab.textColor = [UIColor brokerWhiteColor];
        dataLab.font = [UIFont boldSystemFontOfSize:17];
        
        UILabel *unitLab = [[UILabel alloc] initWithFrame:CGRectMake(labOriginX+originX+10, 10, 35, 15)];
        unitLab.backgroundColor = [UIColor clearColor];
        unitLab.font = [UIFont systemFontOfSize:12];
        unitLab.textColor = [UIColor brokerWhiteColor];
        
        if (i == 0) {
            self.propertyLab = dataLab;
            self.propertyLab.text = @"-";
            
            self.propertyUnitLab = unitLab;
            self.propertyUnitLab.text = @"%";
        }else if (i == 1){
            self.responseTimeLab = dataLab;
            self.responseTimeLab.text = @"-";

            self.responseTimeUnitLab = unitLab;
            self.responseTimeUnitLab.text = @"分钟";
        }else if (i == 2){
            self.totalCustomNumLab = dataLab;
            self.totalCustomNumLab.text = @"-";
            
            self.totalCustomNumUnitLab = unitLab;
            self.totalCustomNumUnitLab.text = @"个";
        }else if (i == 3){
            self.totalLoginNumLab = dataLab;
            self.totalLoginNumLab.text = @"-";
            
            self.totalLoginNumUnitLab = unitLab;
            self.totalLoginNumUnitLab.text = @"天";
        }
        [self.wchatView addSubview:dataLab];
        [self.wchatView addSubview:unitLab];

        
        UILabel *dataDesLab = [[UILabel alloc] init];
        if (i == 0) {
            dataDesLab = [[UILabel alloc] initWithFrame:CGRectMake(labOriginX+originX, 28, 75, 20)];
        }else{
            dataDesLab = [[UILabel alloc] initWithFrame:CGRectMake(labOriginX+originX, 28, 60, 20)];
        }
        dataDesLab.backgroundColor = [UIColor clearColor];
        dataDesLab.font = [UIFont systemFontOfSize:12];
        dataDesLab.textColor = [UIColor whiteColor];
        dataDesLab.text = [desStrArr objectAtIndex:i];
        [self.wchatView addSubview:dataDesLab];
    }
}
- (void)goSDX:(id)sender{
    [sdxDelegate goSDX];
}
- (void)setImageView:(UIImage *)img{
    [_bannerImg setImage:img];
}
#pragma mark - 数据更新
- (void)updateUserHeaderInfo:(NSString *)name{
    self.userName.text = name;
}
- (void)updateWchatData:(UserCenterModel *)model{
    CGSize size1 = [Util_UI sizeOfBoldString:[NSString stringWithFormat:@"%d",[model.replyRate intValue]] maxWidth:50 widthBoldFontSize:17];
    CGSize size2 = [Util_UI sizeOfBoldString:[NSString stringWithFormat:@"%d",[model.responseTime intValue]] maxWidth:50 widthBoldFontSize:17];
    CGSize size3 = [Util_UI sizeOfBoldString:[NSString stringWithFormat:@"%d",[model.customNum intValue]] maxWidth:50 widthBoldFontSize:17];
    CGSize size4 = [Util_UI sizeOfBoldString:[NSString stringWithFormat:@"%d",[model.loginDays intValue]] maxWidth:50 widthBoldFontSize:17];

    CGRect frame1 = self.propertyLab.frame;
    frame1.size.width = size1.width;
    CGRect frame2 = self.responseTimeLab.frame;
    frame2.size.width = size2.width;
    CGRect frame3 = self.totalCustomNumLab.frame;
    frame3.size.width = size3.width;
    CGRect frame4 = self.totalLoginNumLab.frame;
    frame4.size.width = size4.width;
    
    self.propertyLab.text = [NSString stringWithFormat:@"%d",[model.replyRate intValue]];
    self.responseTimeLab.text = [NSString stringWithFormat:@"%d",[model.responseTime intValue]];
    self.totalCustomNumLab.text = [NSString stringWithFormat:@"%d",[model.customNum intValue]];
    self.totalLoginNumLab.text = [NSString stringWithFormat:@"%d",[model.loginDays intValue]];
    
    self.propertyLab.frame = frame1;
    self.responseTimeLab.frame = frame2;
    self.totalCustomNumLab.frame = frame3;
    self.totalLoginNumLab.frame = frame4;
    
    self.propertyUnitLab.frame = CGRectMake(self.propertyLab.frame.origin.x+self.propertyLab.frame.size.width, 10, 35, 15);
    self.responseTimeUnitLab.frame = CGRectMake(self.responseTimeLab.frame.origin.x+self.responseTimeLab.frame.size.width, 10, 35, 15);;
    self.totalCustomNumUnitLab.frame = CGRectMake(self.totalCustomNumLab.frame.origin.x+self.totalCustomNumLab.frame.size.width, 10, 35, 15);;
    self.totalLoginNumUnitLab.frame = CGRectMake(self.totalLoginNumLab.frame.origin.x+self.totalLoginNumLab.frame.size.width, 10, 35, 15);;
    
    if ([model.isTalent intValue] == 1) {
        [self.userLevelBtn setBackgroundImage:[UIImage imageNamed:@"user_talent"] forState:UIControlStateNormal];
    }else{
        [self.userLevelBtn setBackgroundImage:[UIImage imageNamed:@"user_noTalent"] forState:UIControlStateNormal];
    }
}

- (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}
@end
