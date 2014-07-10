//
//  CustomerDetailHeaderView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "CustomerDetailHeaderView.h"
#import "CustomerDetailModel.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"

@interface CustomerDetailHeaderView ()

@property (nonatomic, strong) UIImageView* userIcon;
@property (nonatomic, strong) UILabel* userName;
@property (nonatomic, strong) UILabel* propertyCount;

@end

@implementation CustomerDetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark -
#pragma mark UI相关
-(void) initUI{
    
    _userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _userIcon.layer.cornerRadius = 4.0f;
    _userIcon.layer.masksToBounds = YES;
    [self addSubview:_userIcon];
    
    _userName = [[UILabel alloc] initWithFrame:CGRectZero];
    _userName.font = [UIFont ajkH2Font];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.textColor = [UIColor brokerBlackColor];
    [self addSubview:_userName];
    
    _propertyCount = [[UILabel alloc] initWithFrame:CGRectZero];
    _propertyCount.font = [UIFont ajkH4Font];
    _propertyCount.backgroundColor = [UIColor clearColor];
    _propertyCount.textColor = [UIColor brokerBlackColor];
    [self addSubview:_propertyCount];
    
    self.backgroundColor = [UIColor brokerBgPageColor];
//    self.backgroundColor = [UIColor redColor];
   
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _userIcon.frame = CGRectMake(15, 12, 56, 56);
    if (self.customerDetailModel.user_portrait && self.customerDetailModel.user_portrait.length > 0) {
        [_userIcon setImageWithURL:[NSURL URLWithString:self.customerDetailModel.user_portrait] placeholderImage:[UIImage imageNamed:@"anjuke_icon_headpic"]];
    }else{
        _userIcon.image = [UIImage imageNamed:@"anjuke_icon_headpic"];
    }
    
    _userName.frame = CGRectMake(_userIcon.right + 15, 15, 100, 20);
    _userName.text = self.customerDetailModel.user_name;
    [_userName sizeToFit];
    
    
    _propertyCount.frame = CGRectMake(_userIcon.right + 15, _userName.bottom + 10, 100, 20);
    _propertyCount.text = [NSString stringWithFormat:@"浏览了%@套房源", self.customerDetailModel.view_prop_num];
    [_propertyCount sizeToFit];
 
}

@end
