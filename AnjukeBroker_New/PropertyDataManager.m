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
        arr = [NSArray arrayWithObjects:@"小区",@"户型",@"产证面积",@"价格",@"装修",@"朝向",@"楼层",@"房源标题",@"房源描述", nil];
    }
    else { //好租房源描述title
        arr = [NSArray arrayWithObjects:@"小区",@"户型",@"产证面积",@"价格",@"装修",@"朝向",@"楼层",@"房源标题",@"房源描述", nil];
    }
    return arr;
}

+ (NSMutableArray *)getPropertyHuxingArray_Shi {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 11; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d室", i];
        [arr addObject:str];
    }
    return arr;
}

+ (NSMutableArray *)getPropertyHuxingArray_Ting {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 11; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d厅", i];
        [arr addObject:str];
    }
    return arr;
}

+ (NSMutableArray *)getPropertyHuxingArray_Wei {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 11; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d卫", i];
        [arr addObject:str];
    }
    return arr;
}

@end

