//
//  PublishDataModel.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishDataModel.h"
#import "ConfigPlistManager.h"

@implementation PublishDataModel

+ (NSArray *)getPropertyTitleArrayForHaozu:(BOOL)isHZ {
    NSArray *arr = nil;
    if (!isHZ) { //安居客房源描述title
        arr = [NSArray arrayWithObjects:@"价格",@"产证面积",@"房型",@"楼层",@"装修",@"房源标题",@"房源描述", nil];
    }
    else { //好租房源描述title
        arr = [NSArray arrayWithObjects:@"价格",@"出租面积",@"房型",@"楼层",@"装修",@"出租方式",@"房源标题",@"房源描述", nil];
    }
    return arr;
}

+ (Property *)getNewPropertyObject {
    Property *ep = [[Property alloc] initWithEntity:[NSEntityDescription entityForName:@"Property" inManagedObjectContext:[[RTCoreDataManager sharedInstance] managedObjectContext]] insertIntoManagedObjectContext:nil];
    ep.rentType = @"";
    ep.comm_id = @"";
    ep.area = @"";
    ep.desc = @"";
    ep.exposure = @"";
    ep.fileNo = @"";
    ep.fitment = @"";
    ep.floor = @"";
    ep.imageJson = @"";
    ep.price = @"";
    ep.rooms = @"";
    ep.title = @"";
    
    return ep;
}

#pragma mark - 户型-室
//得到室array
+ (NSMutableArray *)getPropertyHouseTypeArray_room {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyHouseType" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Shi"];
    
    //    for (int i = 0; i < 11; i ++) {
    //        NSString *str = [NSString stringWithFormat:@"%d室", i];
    //        [arr addObject:str];
    //    }
    
    return arr;
}

//室
+ (int)getRoomIndexWithValue:(NSString *)value{
    NSArray *arr = [self getPropertyHouseTypeArray_room];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([value isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"room--index [%d]", index);
    
    return index;
}

//title-室
+ (int)getRoomIndexWithTitle:(NSString *)title{
    NSArray *arr = [self getPropertyHouseTypeArray_room];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([title isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Title"]]) {
            index = i;
        }
    }
    
    DLog(@"room--index [%d]", index);
    
    return index;
}

+ (NSString *)getRoomValueWithIndex:(int)index{
    NSArray *arr = [self getPropertyHouseTypeArray_room];
    
    NSString *str = [[arr objectAtIndex:index] objectForKey:@"Value"];
    return str;
}

+ (NSString *)getRoomTitleWithIndex:(int)index{
    NSArray *arr = [self getPropertyHouseTypeArray_room];
    
    NSString *str = [[arr objectAtIndex:index] objectForKey:@"Title"];
    return str;
}

#pragma mark - 户型-厅
//得到厅array
+ (NSMutableArray *)getPropertyHouseTypeArray_hall {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyHouseType" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Ting"];
    
    //    for (int i = 0; i < 11; i ++) {
    //        NSString *str = [NSString stringWithFormat:@"%d厅", i];
    //        [arr addObject:str];
    //    }
    
    return arr;
}

//厅
+ (int)getHallIndexWithValue:(NSString *)value{
    NSArray *arr = [self getPropertyHouseTypeArray_hall];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([value isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"hall--index [%d]", index);
    
    return index;
}

+ (NSString *)getHallTitleWithIndex:(int)index{
    NSArray *arr = [self getPropertyHouseTypeArray_hall];
    
    NSString *str = [[arr objectAtIndex:index] objectForKey:@"Title"];
    return str;
}

#pragma mark - 户型-卫
+ (NSMutableArray *)getPropertyHouseTypeArray_toilet {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyHouseType" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    NSMutableArray *arr = [dic objectForKey:@"Wei"];
    
    //    for (int i = 0; i < 11; i ++) {
    //        NSString *str = [NSString stringWithFormat:@"%d卫", i];
    //        [arr addObject:str];
    //    }
    
    return arr;
}

//卫
+ (int)getToiletIndexWithValue:(NSString *)value{
    NSArray *arr = [self getPropertyHouseTypeArray_toilet];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([value isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"toilet--index [%d]", index);
    
    return index;
}

+ (NSString *)getToiletTitleWithIndex:(int)index{
    NSArray *arr = [self getPropertyHouseTypeArray_toilet];
    
    NSString *str = [[arr objectAtIndex:index] objectForKey:@"Title"];
    return str;
}

#pragma mark - 楼层-楼
+ (NSMutableArray *)getPropertyFloor {
    //    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyFloor" ofType:@"plist"];
    //    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    //    NSMutableArray *arr = [dic objectForKey:@"Lou"];
    
    int totalCount = 3+99; //-3,-2,-1,1~99
    int initIndex = -3;
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < totalCount; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d楼", initIndex];
        NSString *numStr = [NSString stringWithFormat:@"%d", initIndex];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:str, @"Title",numStr , @"Value", nil];
        [arr addObject:dic];
        
        if (i == 2) { //0楼不保存，换为一楼
            initIndex = initIndex +2;
        }
        else {
            initIndex ++;
        }
    }
    
    return arr;
}

#pragma mark - 楼层-层
+ (NSMutableArray *)getPropertyProFloor {
    //    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyFloor" ofType:@"plist"];
    //    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:strPlistPath];
    //    NSMutableArray *arr = [dic objectForKey:@"Ceng"];
    
    int totalCount = 99; //1~99
    int initIndex = 1;
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < totalCount; i ++) {
        NSString *str = [NSString stringWithFormat:@"共%d层", initIndex];
        NSString *numStr = [NSString stringWithFormat:@"%d", initIndex];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:str, @"Title",numStr , @"Value", nil];
        [arr addObject:dic];
        
        initIndex ++;
    }
    
    return arr;
}

#pragma mark - 装修
+ (NSArray *)getPropertyFitmentForHaozu:(BOOL)isHZ {
    
    NSArray *arr = [NSArray array];
    if (isHZ) {
        arr = [ConfigPlistManager getArrayPlistWithName:HZ_FITMENT_PLIST];
    }
    else {
        arr = [ConfigPlistManager getArrayPlistWithName:AJK_FITMENT_PLIST];
    }
    
    if (arr == nil || arr.count == 0) {
        NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyFitment" ofType:@"plist"];
        arr = [NSMutableArray arrayWithContentsOfFile:strPlistPath];
    }
    
    return arr;
}


#pragma mark - 房型-朝向
+ (NSArray *)getPropertyExposure {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyDirection" ofType:@"plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:strPlistPath];
    
    return arr;
}

//朝向，通过title得到index
+ (int)getExposureIndexWithTitle:(NSString *)title {
    NSArray *arr = [self getPropertyExposure];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([title isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Title"]]) {
            index = i;
        }
    }
    
    DLog(@"ex--index [%d]", index);
    
    return index;
}

//朝向仅租房需要，二手房直接返回朝向title
+ (NSString *)getExposureTitleWithValue:(NSString *)value{
    NSArray *arr = [self getPropertyExposure];
    
    NSString *str = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if ([value isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            str = [[arr objectAtIndex:i] objectForKey:@"Title"];
        }
    }
    
    DLog(@"edit--string [%@]", str);
    
    return str;
}

#pragma mark - 出租方式
+ (NSArray *)getPropertyRentType {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyRentTypeList" ofType:@"plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:strPlistPath];
    
    return arr;
}

@end
