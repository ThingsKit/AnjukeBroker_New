//
//  SaleNoPlanListManager.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/6/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SalePropertyObject.h"

@interface SaleNoPlanListManager : NSObject

+(SalePropertyObject *)propertyFromJSONDic:(NSDictionary *) dic;
+(NSMutableArray *)propertyObjectArrayFromDicArray:(NSArray *)dicArray;
@end
