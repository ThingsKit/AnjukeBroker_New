//
//  CustomerDetailTableViewCell.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

@class FavoritePropertyModel;
@interface FavoritePropertyTableViewCell : RTListCell

@property (nonatomic, strong) FavoritePropertyModel* favoritePropertyModel;

@end
