//
//  NSString+XChat.m
//  X
//
//  Created by Gin on 2/20/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "NSString+AXChatMessage.h"

@implementation NSString (AXChatMessage)

- (CGSize)rtSizeWithFont:(UIFont *)font
{
    
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7.0) {
        return [self sizeWithAttributes:@{NSFontAttributeName:font}];
    } else {
        return [self sizeWithFont:font];
    }
}

- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7.0) {
        return [self boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:size];
    }
}

- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7.0) {
        return [self boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:@{NSFontAttributeName:font}
                                  context:nil].size;
    } else {
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
    }
}

+ (Boolean)checkEmptyOrNull:(NSString *)str
{
    if (!str) {
        return true;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

@end
