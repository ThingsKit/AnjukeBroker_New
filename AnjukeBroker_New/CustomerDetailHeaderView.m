//
//  CustomerDetailHeaderView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
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
    _userName.textColor = [UIColor brokerBlackColor];
    [self addSubview:_userName];
    
    _propertyCount = [[UILabel alloc] initWithFrame:CGRectZero];
    _propertyCount.font = [UIFont ajkH4Font];
    _propertyCount.textColor = [UIColor brokerBlackColor];
    [self addSubview:_propertyCount];
   
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _userIcon.frame = CGRectMake(15, 12, 56, 56);
    if (self.customerDetailModel.userIcon) {
        [_userIcon setImageWithURL:[NSURL URLWithString:self.customerDetailModel.userIcon] placeholderImage:[UIImage imageNamed:@"anjuke_icon_headpic"]];
    }else{
        _userIcon.image = [UIImage imageNamed:@"anjuke_icon_headpic"];
    }
    
    _userName.frame = CGRectMake(_userIcon.right + 15, 12, 100, 20);
    _userName.text = self.customerDetailModel.userName;
    [_userName sizeToFit];
    
    
    _propertyCount.frame = CGRectMake(_userIcon.right + 15, _userName.bottom + 3, 100, 20);
    _propertyCount.text = [NSString stringWithFormat:@"浏览了%@套房源", self.customerDetailModel.propertyCount];
    [_propertyCount sizeToFit];
 
}

@end
