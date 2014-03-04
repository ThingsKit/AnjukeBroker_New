//
//  AXChatContentValidator.h
//  Anjuke2
//
//  Created by Gin on 3/4/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXChatContentValidator : NSObject

- (BOOL)checkPropertyCard:(NSString *)content;
- (BOOL)checkPublicCard:(NSString *)content;

@end
