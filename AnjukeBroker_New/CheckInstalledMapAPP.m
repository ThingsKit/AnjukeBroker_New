//
//  CheckInstalledMapAPP.m
//  AnjukeBroker_New
//
//  Created by shan xu on 14-3-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckInstalledMapAPP.h"

@implementation CheckInstalledMapAPP


-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

+(NSArray *)checkHasOwnApp{
    NSArray *mapSchemeArr = @[@"comgooglemaps://",@"iosamap://navi",@"baidumap://map/"];

    NSMutableArray *appListArr = [[NSMutableArray alloc] initWithObjects:@"apple地图", nil];
    
    for (int i = 0; i < [mapSchemeArr count]; i++) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]]]) {
            [appListArr addObject:[NSString stringWithFormat:@"%@",[mapSchemeArr objectAtIndex:i]]];
        }
    }
    
    [appListArr addObject:@"显示路线"];
    
    return appListArr;
}
@end
