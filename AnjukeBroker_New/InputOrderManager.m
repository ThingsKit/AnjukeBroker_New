//
//  InputOrderManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-22.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "InputOrderManager.h"
#import "PropertyDataManager.h"

@implementation InputOrderManager

//检查当前输入是否需要弹出键盘
+ (BOOL)isKeyBoardInputWithIndex:(int)index {
    if (index == 2 || index == 3 || index == 7 || index == 8) {
        return YES;
    }
    
    return NO;
}



@end
