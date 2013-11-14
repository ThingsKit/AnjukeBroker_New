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
    if (index == AJK_T_AREA || index == AJK_T_PRICE || index == AJK_T_TITLE || index == AJK_T_DESC) {
        return YES;
    }
    
    return NO;
}



@end
