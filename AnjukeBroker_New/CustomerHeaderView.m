//
//  CustomerHeaderView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CustomerHeaderView.h"

@interface CustomerHeaderView ()

@property (nonatomic, strong) UILabel* sectionHeaderLabel;

@end

@implementation CustomerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        self.backgroundColor = [UIColor brokerBgPageColor];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}


#pragma mark -
#pragma mark UI相关
-(void) initUI{
    _sectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _sectionHeaderLabel.font = [UIFont ajkH4Font];
    _sectionHeaderLabel.textColor = [UIColor brokerLightGrayColor];
    _sectionHeaderLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_sectionHeaderLabel];
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _sectionHeaderLabel.frame = self.bounds;
    _sectionHeaderLabel.text = [NSString stringWithFormat:@"%d个客户正在找你熟悉的小区房源 | 可抢人数: %d", _customerCount, _propertyRushableCount];
    
}

@end
