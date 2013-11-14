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
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyHouseType" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Shi"];
    
//    for (int i = 0; i < 11; i ++) {
//        NSString *str = [NSString stringWithFormat:@"%d室", i];
//        [arr addObject:str];
//    }
    
    return arr;
}

+ (NSMutableArray *)getPropertyHuxingArray_Ting {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyHouseType" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Ting"];
    
//    for (int i = 0; i < 11; i ++) {
//        NSString *str = [NSString stringWithFormat:@"%d厅", i];
//        [arr addObject:str];
//    }
    
    return arr;
}

+ (NSMutableArray *)getPropertyHuxingArray_Wei {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyHouseType" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Wei"];
    
//    for (int i = 0; i < 11; i ++) {
//        NSString *str = [NSString stringWithFormat:@"%d卫", i];
//        [arr addObject:str];
//    }
    
    return arr;
}

+ (NSArray *)getPropertyZhuangxiu {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyFitment" ofType:@"plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:strPlistPath];
    
    return arr;
}

+ (NSArray *)getPropertyChaoXiang {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyDirection" ofType:@"plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:strPlistPath];
    
    return arr;
}

+ (NSMutableArray *)getPropertyLou_Number {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyFloor" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Lou"];
    
//    for (int i = 0; i < 103; i ++) {
//        NSString *str = [NSString stringWithFormat:@"%d楼", i-3];
//        if (i - 3 != 0) { //0楼不保存
//            [arr addObject:str];
//        }
//    }
    
    return arr;
}

+ (NSMutableArray *)getPropertyCeng_Number {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyFloor" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Ceng"];
    
//    for (int i = 0; i < 100; i ++) {
//        NSString *str = [NSString stringWithFormat:@"共%d层", i+1];
//        [arr addObject:str];
//    }
    
    return arr;
}

+ (Property *)getNewPropertyObject {
    Property *ep = [[Property alloc] initWithEntity:[NSEntityDescription entityForName:@"Property" inManagedObjectContext:[[RTCoreDataManager sharedInstance] managedObjectContext]] insertIntoManagedObjectContext:nil];
    
    return ep;
}

@end

