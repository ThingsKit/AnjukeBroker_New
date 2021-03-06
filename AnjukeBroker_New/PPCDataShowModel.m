//
//  PPCDataPricingModel.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "PPCDataShowModel.h"

@implementation PPCDataShowModel

+ (PPCDataShowModel *)convertToMappedObject:(NSDictionary *)dic{
    PPCDataShowModel *model = [[PPCDataShowModel alloc] init];
    
    model.todayClickNum = [NSNumber numberWithInteger:[dic[@"todayClicks"] intValue]];
    model.todayCostFee = dic[@"todayConsume"];
    
    NSString *str = dic[@"totalProps"] ? dic[@"totalProps"] : dic[@"propNum"];
    model.houseNum = [NSNumber numberWithInt:[str intValue]];
    
    return model;
}

@end

