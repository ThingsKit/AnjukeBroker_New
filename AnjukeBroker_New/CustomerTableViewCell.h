//
//  CustomerTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

@class CustomerModel;
@interface CustomerTableViewCell : RTListCell

@property (nonatomic, strong) CustomerModel* customerModel; //客户数据对象

@end
