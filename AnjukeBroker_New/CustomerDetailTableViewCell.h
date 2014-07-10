//
//  CustomerDetailTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

@class CustomerDetailModel;
@interface CustomerDetailTableViewCell : RTListCell

@property (nonatomic, strong) CustomerDetailModel* customerDetailModel;

@end
