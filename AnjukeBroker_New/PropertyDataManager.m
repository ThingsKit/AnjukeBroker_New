//
//  PropertyDataManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyDataManager.h"

@implementation PropertyDataManager

+ (NSArray *)getPropertyTitleArrayForAnjuke:(BOOL)isAnjuke {
    NSArray *arr = nil;
    if (isAnjuke) { //安居客房源描述title
        arr = [NSArray arrayWithObjects:@"备案号",@"小区",@"户型",@"产证面积",@"价格",@"装修",@"朝向",@"楼层",@"房源标题",@"房源描述", nil];
    }
    else { //好租房源描述title
        arr = [NSArray arrayWithObjects:@"备案号",@"小区",@"户型",@"产证面积",@"价格",@"装修",@"朝向",@"楼层",@"房源标题",@"房源描述", nil];
    }
    return arr;
}

@end

