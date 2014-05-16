//
//  AXChatContentValidator.h
//  Anjuke2
//
//  Created by Gin on 3/4/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXChatContentValidator : NSObject
- (BOOL)checkText:(NSString *)content;
- (BOOL)checkLocation:(NSString *)content;
- (BOOL)checkPropertyCard:(NSString *)content;
- (BOOL)checkPublicCard:(NSString *)content;
- (BOOL)checkPublicCard2:(NSString *)content;
- (BOOL)checkPublicCard3:(NSString *)content;
- (BOOL)checkVoice:(NSString *)content;

- (BOOL)checkIsJinpuCard:(NSNumber *)tradeType;
@end
