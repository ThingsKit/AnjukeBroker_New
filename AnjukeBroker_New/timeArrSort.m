//
//  timeArrSort.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-15.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "timeArrSort.h"

@implementation timeArrSort
+ (NSArray *)arrSort:(NSArray *)arr{
    NSMutableArray *sortArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++) {
        [sortArr addObject:[[arr objectAtIndex:i] substringToIndex:2]];
    }

    NSArray *sorteArray = [sortArr sortedArrayUsingComparator:^(id obj1, id obj2){
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    for (int j = 0; j < sorteArray.count; j++) {
        NSMutableString *str = [[NSMutableString alloc] initWithString:[sorteArray objectAtIndex:j]];
        [str appendString:@":00"];
        [sortArr replaceObjectAtIndex:j withObject:str];
    }
    return sortArr;
}

@end
