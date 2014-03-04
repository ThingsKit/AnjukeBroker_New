//
//  AXChatPhotoActionSheet.h
//  Anjuke2
//
//  Created by Gin on 3/4/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXChatPhotoActionSheet : UIView

- (void)showWithBlock:(void (^)(NSUInteger))block;

@end
