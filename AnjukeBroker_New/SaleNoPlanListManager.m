//
//  SaleNoPlanListManager.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/6/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleNoPlanListManager.h"
#import "SaleNoPlanListCell.h"

@implementation SaleNoPlanListManager
+(SalePropertyObject *)propertyFromJSONDic:(NSDictionary *) dic{
    SalePropertyObject *property = [[SalePropertyObject alloc] init];
    return [property setValueFromDictionary:dic];
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

@end
