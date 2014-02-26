//
//  NSString+XChat.h
//  X
//
//  Created by Gin on 2/20/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (XChat)

- (CGSize)rtSizeWithFont:(UIFont *)font;
- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)rtSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (Boolean)checkEmptyOrNull:(NSString *)str;

@end
