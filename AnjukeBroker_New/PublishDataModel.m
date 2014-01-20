//
//  PublishDataModel.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishDataModel.h"

@implementation PublishDataModel

+ (NSArray *)getPropertyTitleArrayForHaozu:(BOOL)isHZ {
    NSArray *arr = nil;
    if (!isHZ) { //安居客房源描述title
        arr = [NSArray arrayWithObjects:@"价格",@"产证面积",@"房型",@"装修",@"楼层",@"房源标题",@"房源描述", nil];
    }
    else { //好租房源描述title
        arr = [NSArray arrayWithObjects:@"价格",@"产证面积",@"出租方式",@"房型",@"装修",@"楼层",@"房源标题",@"房源描述", nil];
    }
    return arr;
}

@end
