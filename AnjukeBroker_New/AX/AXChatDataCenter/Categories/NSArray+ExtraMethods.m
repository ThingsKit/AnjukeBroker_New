//
//  NSArray+ExtraMethods.m
//  Anjuke2
//
//  Created by casa on 14-2-27.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "NSArray+ExtraMethods.h"

@implementation NSArray (ExtraMethods)

- (NSArray *)reverseSelf
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[self count]];
    NSEnumerator *reversedEnumerator = [self reverseObjectEnumerator];
    for (id element in reversedEnumerator) {
        [result addObject:element];
    }
    return result;
}

@end
