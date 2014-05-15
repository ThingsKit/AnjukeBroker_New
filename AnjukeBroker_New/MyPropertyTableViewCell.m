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
@property (nonatomic, retain) RTLabel* commName;   //小区名字
@property (nonatomic, retain) UILabel* houseType;
@property (nonatomic, retain) UILabel* area;
@property (nonatomic, retain) UILabel* price;
@property (nonatomic, retain) UILabel* owner;      //业主
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
    self.commName = [[RTLabel alloc] initWithFrame:CGRectZero];
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
    self.owner = [[UILabel alloc] initWithFrame:CGRectZero];
    self.owner.backgroundColor = [UIColor clearColor];
    self.owner.font = [UIFont systemFontOfSize:12.0];
    [self.owner setTextColor:[Util_UI colorWithHexString:@"#B2B2B2"]];
    [self.contentView addSubview:self.owner];
    
    
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
    [self.button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
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
        self.icon.image = [UIImage imageNamed:@"anjuke_icon_weituo_esf"];
    }else{
        self.icon.image = [UIImage imageNamed:@"anjuke_icon_weituo_zf"];
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
        self.owner.frame = CGRectMake(10, self.houseType.bottom, 60, 20);
        self.owner.text = self.myPropertyModel.ownerName;
        [self.owner sizeToFit];
        
        //业主电话
        self.ownerPhone.frame = CGRectMake(self.owner.right + 20, self.houseType.bottom, 100, 20);
        self.ownerPhone.text = self.myPropertyModel.ownerPhone;
        [self.ownerPhone sizeToFit];
        
        //右侧的电话按钮
        self.button.frame = CGRectMake(ScreenWidth-80, 30, 30, 30);
        [self.button setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_callphone"] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_callphone_press"] forState:UIControlStateHighlighted];
        
    }else{
        //状态信息
        self.statusInfo.frame = CGRectMake(10, self.houseType.bottom, 100, 20);
        self.statusInfo.text = self.myPropertyModel.statusInfo;
        [self.statusInfo sizeToFit];
    }
    
    
}

//右侧按钮点击事件
- (void)buttonClicked{
    NSLog(@"电话打起来");
}

#pragma mark -
#pragma mark RTLabelDelegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url{
    //    NSString* urlString = [url absoluteString];
}

@end
