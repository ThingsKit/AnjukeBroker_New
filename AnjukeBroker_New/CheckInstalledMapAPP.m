//
//  CheckInstalledMapAPP.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckInstalledMapAPP.h"

@implementation CheckInstalledMapAPP
//taobao://item.taobao.com/item.htm?id=12688928896
@synthesize mapSchemeArr;


-(id)init{
    self = [super init];
    if (self) {
        self.mapSchemeArr = @[@"baidumapsdk://mapsdk.baidu.com"];
    }
    return self;
}


-(BOOL)isInstalledApp:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"urlStr"]];
    // 判断当前系统是否有安装淘宝客户端
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        // 如果已经安装淘宝客户端，就使用客户端打开链接
//        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

@end
