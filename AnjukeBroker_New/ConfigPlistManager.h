//
//  DocPlistManager.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-20.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AJK_ALL_PLIST @"SalePropertyConfig.plist" //二手房总配置信息
#define HZ_ALL_PLIST @"RentPropertyConfig.plist" //租房总配置信息

#define AJK_FITMENT_PLIST @"AJK_PropertyFitment.plist" //二手房装修情况
#define HZ_FITMENT_PLIST @"HZ_PropertyFitment.plist" //好租装修情况

@interface ConfigPlistManager : NSObject

+ (void)savePlistWithDic:(NSDictionary *)dic withName:(NSString *)name; //将数据存入沙箱
+ (void)savePlistWithArr:(NSArray *)arr withName:(NSString *)name;

+ (NSDictionary *)getDictionaryPlistWithName:(NSString *)name;
+ (NSArray *)getArrayPlistWithName:(NSString *)name;

+ (void)setAnjukeDataPlistWithDic:(NSDictionary *)dic; //根据总配置信息得到所有发房配置信息
+ (void)setHaozuDataPlistWithDic:(NSDictionary *)dic; //

@end
