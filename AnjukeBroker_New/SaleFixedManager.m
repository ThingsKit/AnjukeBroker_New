//
//  SaleFixedManager.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/7/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleFixedManager.h"


@implementation SaleFixedManager

+(SaleFixedGroupObject *)propertyFromJSONDic:(NSDictionary *) dic{
    SaleFixedGroupObject *group = [[SaleFixedGroupObject alloc] init];
    return [group setValueFromDictionary:dic];
}

+(NSMutableArray *)propertyObjectArrayFromDicArray:(NSArray *)dicArray{
    NSMutableArray *noPlanList = [[NSMutableArray alloc] init];
    
    for (id tempDic in dicArray)
        [noPlanList addObject:[self propertyFromJSONDic:(NSDictionary *)tempDic]];
    
    if ([noPlanList count] == 0)
        return nil;
    else
        return noPlanList;
    
    return nil;
}
+(FixedObject *)fixedPlanObjectFromDic:(NSDictionary *) dic{
    FixedObject *fixed = [[FixedObject alloc] init];
    [fixed setValueFromDictionary:dic];
    return fixed;
}

+(SalePropertyObject *)salePropertyFromJSONDic:(NSDictionary *) dic{
    SalePropertyObject *property = [[SalePropertyObject alloc] init];
    return [property setValueFromDictionary:dic];
}

+(NSMutableArray *)salePropertyObjectArrayFromDicArray:(NSArray *)dicArray{
    NSMutableArray *noPlanList = [[NSMutableArray alloc] init];
    
    for (id tempDic in dicArray)
        [noPlanList addObject:[self propertyFromJSONDic:(NSDictionary *)tempDic]];
    
    if ([noPlanList count] == 0)
        return nil;
    else
        return noPlanList;
    
    return nil;
}

@end
