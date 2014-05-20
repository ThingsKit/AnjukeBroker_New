//
//  MyPropertyTableViewCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MyPropertyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "MyPropertyModel.h"
#import "UIViewExt.h"
#import "Util_UI.h"

@interface MyPropertyTableViewCell ()

@property (nonatomic, retain) UIImageView* icon;
@property (nonatomic, retain) UILabel* commName;   //小区名字
@property (nonatomic, retain) UILabel* houseType;
@property (nonatomic, retain) UILabel* area;
@property (nonatomic, retain) UILabel* price;
@property (nonatomic, retain) UILabel* ownerName;      //业主
@property (nonatomic, retain) UILabel* ownerPhone; //业主电话
@property (nonatomic, retain) UILabel* statusInfo; //状态信息
@property (nonatomic, retain) UIButton* button; //右侧的按钮

@end


@implementation MyPropertyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCell];
    }
    return self;
}

- (void)initCell {
    //小区名称
    self.commName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.commName.backgroundColor = [UIColor clearColor];
    self.commName.font = [UIFont boldSystemFontOfSize:15.0];
    [self.commName setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.commName];
    
    //租售icon
    self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.icon.backgroundColor = [UIColor clearColor];
    self.icon.layer.cornerRadius = 1.0;
    self.icon.layer.masksToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    //户型
    self.houseType = [[UILabel alloc] initWithFrame:CGRectZero];
    self.houseType.backgroundColor = [UIColor clearColor];
    self.houseType.font = [UIFont systemFontOfSize:12.0];
    [self.houseType setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.houseType];
    
    //面积
    self.area = [[UILabel alloc] initWithFrame:CGRectZero];
    self.area.backgroundColor = [UIColor clearColor];
    self.area.font = [UIFont systemFontOfSize:12.0];
    [self.area setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.area];
    
    //租金或售价
    self.price = [[UILabel alloc] initWithFrame:CGRectZero];
    self.price.backgroundColor = [UIColor clearColor];
    self.price.font = [UIFont systemFontOfSize:12.0];
    [self.price setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.price];
    
    //业主
    self.ownerName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.ownerName.backgroundColor = [UIColor clearColor];
    self.ownerName.font = [UIFont systemFontOfSize:12.0];
    [self.ownerName setTextColor:[Util_UI colorWithHexString:@"#B2B2B2"]];
    [self.contentView addSubview:self.ownerName];
    
    
    //业主电话
    self.ownerPhone = [[UILabel alloc] initWithFrame:CGRectZero];
    self.ownerPhone.backgroundColor = [UIColor clearColor];
    self.ownerPhone.font = [UIFont systemFontOfSize:12.0];
    [self.ownerPhone setTextColor:[Util_UI colorWithHexString:@"#B2B2B2"]];
    [self.contentView addSubview:self.ownerPhone];
    
    //状态信息
    self.statusInfo = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusInfo.backgroundColor = [UIColor clearColor];
    self.statusInfo.font = [UIFont systemFontOfSize:12.0];
    [self.statusInfo setTextColor:[Util_UI colorWithHexString:@"#B2B2B2"]];
    [self.contentView addSubview:self.statusInfo];
    
    
    //右侧的按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.cornerRadius = 2.0f;
    self.button.layer.masksToBounds = YES;
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
    
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    self.selectedBackgroundView = backgroundView;
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    //小区名称
    self.commName.frame = CGRectMake(10, 15, ScreenWidth/2, 25);
    self.commName.text = self.myPropertyModel.commName;
    [self.commName sizeToFit]; //自适应文字大小
    
    //租售icon
    self.icon.frame = CGRectMake(self.commName.right, 15, 16, 16);
    if ([self.myPropertyModel.type isEqualToString:@"1"]) {
        self.icon.image = [UIImage imageNamed:@"anjuke_icon_weituo_esf"]; //售
    }else{
        self.icon.image = [UIImage imageNamed:@"anjuke_icon_weituo_zf"]; //租
    }
    
    //户型
    self.houseType.frame = CGRectMake(10, self.commName.bottom, 100, 20);
    self.houseType.text = [NSString stringWithFormat:@"%@室%@厅%@卫", self.myPropertyModel.room, self.myPropertyModel.hall, self.myPropertyModel.toilet];
    [self.houseType sizeToFit];
    
    //面积
    self.area.frame = CGRectMake(self.houseType.right+10, self.commName.bottom, 60, 20);
    self.area.text = [NSString stringWithFormat:@"%@平", self.myPropertyModel.area];
    [self.area sizeToFit];
    
    //租金或售价
    self.price.frame = CGRectMake(self.area.right+10, self.commName.bottom, 60, 20);
    self.price.text = [NSString stringWithFormat:@"%@%@", self.myPropertyModel.price, self.myPropertyModel.priceUnit];
    [self.price sizeToFit];
    
    if ([self.myPropertyModel.callable isEqualToString:@"1"]) {
        //业主
        self.ownerName.frame = CGRectMake(10, self.houseType.bottom, 60, 20);
        self.ownerName.text = self.myPropertyModel.ownerName;
        [self.ownerName sizeToFit];
        self.ownerName.hidden = NO;
        
        //业主电话
        self.ownerPhone.frame = CGRectMake(self.ownerName.right + 20, self.houseType.bottom, 100, 20);
        self.ownerPhone.text = self.myPropertyModel.ownerPhone;
        [self.ownerPhone sizeToFit];
        self.ownerPhone.hidden = NO;
        
        //隐藏状态信息
        self.statusInfo.hidden = YES;
        
        //右侧的电话按钮
        self.button.frame = CGRectMake(ScreenWidth-56/2-20, 30, 30, 30);
        [self.button setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_weituo_call"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_weituo_call_press"] forState:UIControlStateHighlighted];
        self.button.hidden = NO;
        
    }else{
        //隐藏其他label
        self.ownerName.hidden = YES;
        self.ownerPhone.hidden = YES;
        self.button.hidden = YES;
        
        //状态信息
        self.statusInfo.frame = CGRectMake(10, self.houseType.bottom, 100, 20);
        self.statusInfo.text = self.myPropertyModel.statusInfo;
        [self.statusInfo sizeToFit];
        self.statusInfo.hidden = NO;
    }
    
    
}

//右侧按钮点击事件
- (void)buttonClicked:(UIButton*)button{
    
    NSLog(@"拨打电话-->%@", self.myPropertyModel.ownerPhone);
    
    if (![@"iPhone" isEqualToString:[UIDevice currentDevice].model]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"设备不支持电话功能" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"拨打房东电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确认" otherButtonTitles:nil];
    [sheet showInView:self.window];
    
//    if (self.myPropertyModel.ownerPhone) {
//        NSString* phoneNumber = [@"tel://" stringByAppendingString:self.myPropertyModel.ownerPhone];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
//    }else{
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"该房东没有电话" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//        [alert show];
//    }
    
    
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"确认拨打电话");
        if (self.myPropertyModel.ownerPhone) {
            NSString* phoneNumber = [@"telprompt://" stringByAppendingString:self.myPropertyModel.ownerPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"该房东没有电话" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
    }else{
        
    }
    
}


@end
