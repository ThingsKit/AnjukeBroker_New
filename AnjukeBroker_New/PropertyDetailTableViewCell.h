//
//  PropertyDetailTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

@class PropertyDetailCellModel;
@interface PropertyDetailTableViewCell : RTListCell

@property (nonatomic, strong) PropertyDetailCellModel* propertyDetailTableViewCellModel;
@property (nonatomic, assign) BOOL isHaozu;

@end
