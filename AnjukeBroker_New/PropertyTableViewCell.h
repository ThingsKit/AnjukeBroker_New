//
//  FangYuanTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@class PropertyModel;
@interface PropertyTableViewCell : UITableViewCell <RTLabelDelegate>

@property (nonatomic, retain) PropertyModel* propertyModel; //房源数据对象

@end
