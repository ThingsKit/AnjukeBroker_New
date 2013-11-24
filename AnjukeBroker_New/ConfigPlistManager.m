//
//  DocPlistManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-20.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "ConfigPlistManager.h"

@implementation ConfigPlistManager

#pragma mark - Standard Method

+ (NSDictionary *)getDictionaryPlistWithName:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:name];
    NSDictionary* configData = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    DLog(@"confingData [%@]", configData);
    
    return configData;
}

+ (NSArray *)getArrayPlistWithName:(NSString *)name {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:name];
    NSArray* configData = [NSArray arrayWithContentsOfFile:filename];
    
    DLog(@"confingData [%@]", configData);
    
    return configData;
}

+ (void)savePlistWithDic:(NSDictionary *)dic withName:(NSString *)name { //将数据存入沙箱
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:name];   //获取路径
    
    [dic writeToFile:filename atomically:YES];
}

+ (void)savePlistWithArr:(NSArray *)arr withName:(NSString *)name { //将数据存入沙箱
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:name];   //获取路径
    
    [arr writeToFile:filename atomically:YES];
}

+ (void)setAnjukeDataPlistWithDic:(NSDictionary *)dic {
    //装修方式
    NSArray *fitmentsData = [[dic objectForKey:@"fitments"] objectForKey:@"allValue"];
    
    NSMutableArray *valueArr = [NSMutableArray array];
    for (int i = 0; i < fitmentsData.count; i ++) {
        [valueArr addObject:[[fitmentsData objectAtIndex:i] objectForKey:@"index"]]; //get index for value
    }
    
    NSMutableArray *titleArr = [NSMutableArray array];
    for (int i = 0; i < fitmentsData.count; i ++) {
        [titleArr addObject:[[fitmentsData objectAtIndex:i] objectForKey:@"value"]]; //get value for title
    }
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < fitmentsData.count; i ++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[valueArr objectAtIndex:i], @"Value", [titleArr objectAtIndex:i], @"Title", nil];
        [resultArr addObject:dic];
    }
    
    DLog(@"resultArr [%@]", resultArr);
    
    [self savePlistWithArr:resultArr withName:AJK_FITMENT_PLIST];
    
    //保存二手房播种城市
    if ([[dic objectForKey:@"isSeed"] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isSeed_AJK"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isSeed_AJK"];
    }
}

+ (void)setHaozuDataPlistWithDic:(NSDictionary *)dic {
    //装修方式
    NSDictionary *fitmentDic = [dic objectForKey:@"fitment"];
    NSArray *valueArr = [fitmentDic allKeys];
    NSArray *titleArr = [fitmentDic allValues];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    for (int i = 0; i < valueArr.count; i ++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[valueArr objectAtIndex:i], @"Value", [titleArr objectAtIndex:i], @"Title", nil];
        [resultArr addObject:dic];
    }
    
    DLog(@"resultArr");
    
    [self savePlistWithArr:resultArr withName:HZ_FITMENT_PLIST];
    
    //保存二手房播种城市
    if ([[dic objectForKey:@"isSeed"] intValue] == 1) {
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isSeed_HZ"];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"isSeed_HZ"];
    }
}

@end
