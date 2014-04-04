//
//  NSManagedObject+ExtraMethods.m
//  Anjuke2
//
//  Created by casa on 14-4-4.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "NSManagedObject+ExtraMethods.h"

@implementation NSManagedObject (ExtraMethods)

- (NSInteger)autoIncreamentPK
{
    NSString *urlString = self.objectID.URIRepresentation.absoluteString;
    NSString *lastSegment = [[urlString componentsSeparatedByString:@"/"] lastObject];
    NSString *numberPart = [lastSegment stringByReplacingOccurrencesOfString:@"p" withString:@""];
    NSInteger autoIncreamentPK = [numberPart integerValue];
    return autoIncreamentPK;
}

@end
