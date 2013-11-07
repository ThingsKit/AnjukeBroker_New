//
//  SaleFixedManager.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/7/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaleFixedGroupObject.h"

@interface SaleFixedManager : NSObject

+(SaleFixedGroupObject *)propertyFromJSONDic:(NSDictionary *) dic;
+(NSMutableArray *)propertyObjectArrayFromDicArray:(NSArray *)dicArray;

@end
