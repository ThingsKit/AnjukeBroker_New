//
//  FangYuanTableViewCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIUtils.h"
#import "PropertyModel.h"
#import "UIViewExt.h"

@interface PropertyTableViewCell ()

@property (nonatomic, retain) UIImageView* icon;
@property (nonatomic, retain) RTLabel* communityName;
@property (nonatomic, retain) UILabel* houseType;
@property (nonatomic, retain) UILabel* area;
@property (nonatomic, retain) UILabel* rent;
@property (nonatomic, retain) UILabel* publishTime;
@property (nonatomic, assign) BOOL hasButton;
@property (nonatomic, retain) UIButton* button;

@end


@implementation PropertyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initCell {
    //小区名称
    self.communityName = [[RTLabel alloc] initWithFrame:CGRectZero];
    self.communityName.backgroundColor = [UIColor clearColor];
    self.communityName.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.communityName];
    
    //租售icon
    self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.icon.backgroundColor = [UIColor clearColor];
    self.icon.layer.cornerRadius = 1.0;
    self.icon.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.icon.layer.borderWidth = .5;
    self.icon.layer.masksToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    //户型
    self.houseType = [[UILabel alloc] initWithFrame:CGRectZero];
    self.houseType.backgroundColor = [UIColor clearColor];
    self.houseType.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.houseType];
    
    //面积
    self.area = [[UILabel alloc] initWithFrame:CGRectZero];
    self.area.backgroundColor = [UIColor clearColor];
    self.area.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.area];
    
    //租金或售价
    self.rent = [[UILabel alloc] initWithFrame:CGRectZero];
    self.rent.backgroundColor = [UIColor clearColor];
    self.rent.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.rent];
    
    //发布时间
    self.publishTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self.publishTime.backgroundColor = [UIColor clearColor];
    self.publishTime.font = [UIFont systemFontOfSize:12.0];
    [self.contentView addSubview:self.publishTime];
    
    //右侧的按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.hasButton = YES;
    
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    self.selectedBackgroundView = backgroundView;
    
}

//{"status":"ok"，"data":{"name":"小区名称","type":"租售状态(1:出租 2:出售)","rooms":"房型","area":"面积","price":"151222222","phone":"151222222","time":"发布时间"}}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    //小区名称
    self.communityName.frame = CGRectMake(5, 5, 100, 20);
    self.communityName.text = self.propertyModel.community.name;
    
    //租售icon
    self.icon.frame = CGRectMake(self.communityName.right, 5, 20, 20);
    self.icon.image = [UIImage imageNamed:@"anjuke_icon_feedback"];
    
    //户型
    self.houseType.frame = CGRectMake(5, self.communityName.bottom, 50, 20);
    self.houseType.text = self.propertyModel.community.type;
    
    //面积
    self.area.frame = CGRectMake(self.houseType.right, self.communityName.bottom, 30, 20);
    self.area.text = self.propertyModel.community.area;
    
    //租金或售价
    self.rent.frame = CGRectMake(self.area.right, self.communityName.bottom, 30, 20);
    self.rent.text = self.propertyModel.community.price;
    
    //发布时间
    self.publishTime.frame = CGRectMake(5, self.houseType.bottom, 100, 20);
    self.publishTime.text = self.propertyModel.community.time;
    
    //右侧的按钮
    if (self.hasButton) {
        self.button.hidden = NO;
        self.button.frame = CGRectMake(self.rent.right + 50, 30, 50, 30);
        [self.button setBackgroundColor:[UIColor colorWithRed:79.0/255 green:164.0/255 blue:236.0/255 alpha:1]];
        [self.button setTitle:@"抢委托" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
        self.button.hidden = YES;
    }
    
}

//右侧按钮点击事件
- (void)buttonClicked{
    NSLog(@"抢委托逻辑走起啦");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
