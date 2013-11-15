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
+ (BOOL)isKeyBoardInputWithIndex:(int)index isHaozu:(BOOL)isHZ {
    if (isHZ) { //好租
        if (index == HZ_T_AREA || index == HZ_T_PRICE || index == HZ_T_TITLE || index == HZ_T_DESC) {
            return YES;
        }
        else
            return NO;
    }
    else { //二手房
        if (index == AJK_T_AREA || index == AJK_T_PRICE || index == AJK_T_TITLE || index == AJK_T_DESC) {
            return YES;
        }
        else
            return NO;
    }
    
    return NO;
}



@end
