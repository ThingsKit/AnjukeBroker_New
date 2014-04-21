//
//  NSArray+AXChatMessage.m
//  Anjuke2
//
//  Created by Gin on 4/14/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "NSArray+AXChatMessage.h"

@implementation NSArray (AXChatMessage)

+ (NSArray *)axTTTImageBricksArray
{
    static NSArray *imageBricksArrayArray;
    if (!imageBricksArrayArray)
    {
        imageBricksArrayArray = @[@{@"name":@"西瓜", @"width":@"18", @"ascent":@"16", @"descent":@"2", @"image":@"Expression_57.png"}];
    }
    return imageBricksArrayArray;
}

@end
