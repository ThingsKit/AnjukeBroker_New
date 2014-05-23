//
//  FangYuanTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTListCell.h"

@class PropertyModel;
@interface PropertyTableViewCell : RTListCell

@property (nonatomic, retain) PropertyModel* propertyModel; //房源数据对象

@end
