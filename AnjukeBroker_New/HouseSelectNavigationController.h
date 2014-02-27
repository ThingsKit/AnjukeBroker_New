//
//  houseSelectNavigationController.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTNavigationController.h"

@protocol SelectedHouseWithDicDelegate<NSObject>

-(void)returnSelectedHouseDic:(NSDictionary *)dic houseType:(BOOL)houseType;

@end

@interface HouseSelectNavigationController : RTNavigationController

@property(nonatomic,assign) id<SelectedHouseWithDicDelegate> selectedHouseDelgate;
@end
