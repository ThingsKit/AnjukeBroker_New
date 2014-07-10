//
//  UIView+ChainViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-15.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "UIView+ChainViewController.h"

@implementation UIView (ChainViewController)

- (UIViewController*)viewController {
    
    UIResponder* responder = [self nextResponder];
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)responder;
        }
        
        responder = [responder nextResponder];
    } while (responder != nil);
    
    return nil;
}

@end
