//
//  ImmediatePromotionCell.h
//  AnjukeBroker_New
//
//  Created by jason on 7/2/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@interface ImmediatePromotionCell : RTListCell

@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *priceUnit;

- (void)addImediatePromotionButtonTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end
