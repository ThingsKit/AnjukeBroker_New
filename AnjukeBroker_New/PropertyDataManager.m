//
//  PropertyDataManager.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyDataManager.h"
#import "ConfigPlistManager.h"

@implementation PropertyDataManager

+ (NSArray *)getPropertyTitleArrayForHaozu:(BOOL)isHZ {
    NSArray *arr = nil;
    if (!isHZ) { //安居客房源描述title
        arr = [NSArray arrayWithObjects:@"小区",@"户型",@"产证面积",@"价格",@"装修",@"朝向",@"楼层",@"房源标题",@"房源描述", nil];
    }
    else { //好租房源描述title
        arr = [NSArray arrayWithObjects:@"小区",@"户型",@"产证面积",@"租金", @"出租方式", @"装修",@"朝向",@"楼层",@"房源标题",@"房源描述", nil];
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

+ (NSArray *)getPropertyChaoXiang {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyDirection" ofType:@"plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:strPlistPath];
    
    return arr;
}

+ (NSMutableArray *)getPropertyLou_Number {
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

+ (NSMutableArray *)getPropertyCeng_Number {
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

+ (NSArray *)getPropertyRentType {
    NSString *strPlistPath = [[NSBundle mainBundle] pathForResource:@"PropertyRentTypeList" ofType:@"plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:strPlistPath];
    
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

#pragma mark - Edit Property Method

//室
+ (int)getRoomIndexWithNum:(NSString *)num{
    NSArray *arr = [self getPropertyHuxingArray_Shi];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"room--index [%d]", index);
    
    return index;
}

//title-室
+ (int)getRoomIndexWithTitle:(NSString *)title{
    NSArray *arr = [self getPropertyHuxingArray_Shi];
    
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
    NSArray *arr = [self getPropertyHuxingArray_Shi];
    
    NSString *str = [[arr objectAtIndex:index] objectForKey:@"Value"];
    return str;
}

//厅
+ (int)getHallIndexWithNum:(NSString *)num{
    NSArray *arr = [self getPropertyHuxingArray_Ting];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"hall--index [%d]", index);
    
    return index;
}

//卫
+ (int)getToiletIndexWithNum:(NSString *)num{
    NSArray *arr = [self getPropertyHuxingArray_Wei];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"toilet--index [%d]", index);
    
    return index;
}

//出租方式
+ (int)getRentTypeIndexWithNum:(NSString *)num{
    NSArray *arr = [self getPropertyRentType];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"rent--index [%d]", index);
    
    return index;
}

+ (NSString *)getRentTypeTitleWithNum:(NSString *)num{
    NSArray *arr = [self getPropertyRentType];
    
    NSString *str = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            str = [[arr objectAtIndex:i] objectForKey:@"Title"];
        }
    }
    
    DLog(@"rent--string [%@]", str);
    
    return str;
}

//装修，二手房传title，租房传id
+ (int)getFitmentIndexWithString:(NSString *)string forHaozu:(BOOL)isHaozu{
    NSArray *arr = [self getPropertyFitmentForHaozu:isHaozu];
    int index = 0;
    
    if (isHaozu) {
        for (int i = 0; i < arr.count; i ++) {
            if ([string isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
                index = i;
            }
        }
    }
    else {
        for (int i = 0; i < arr.count; i ++) {
            if ([string isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Title"]]) {
                index = i;
            }
        }
    }
    
    DLog(@"fitment--index [%d]", index);
    
    return index;
}

+ (NSString *)getFitmentTitleWithNum:(NSString *)num forHaozu:(BOOL)isHaozu{
    NSArray *arr = [self getPropertyFitmentForHaozu:isHaozu];
    
    NSString *str = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            str = [[arr objectAtIndex:i] objectForKey:@"Title"];
        }
    }
    
    DLog(@"fitment--string [%@]", str);
    
    return str;
}

//二手房装修情况_通过title得到Value
+ (NSString *)getFitmentVauleWithTitle:(NSString *)title forHaozu:(BOOL)isHaozu{
    NSArray *arr = [self getPropertyFitmentForHaozu:isHaozu];
    
    NSString *str = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if ([title isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Title"]]) {
            str = [[arr objectAtIndex:i] objectForKey:@"Value"];
        }
    }
    
    DLog(@"fitment--string [%@]", str);
    
    return str;
}

//朝向，通过title得到index
+ (int)getExposureIndexWithTitle:(NSString *)title {
    NSArray *arr = [self getPropertyChaoXiang];
    
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
+ (NSString *)getExposureTitleWithNum:(NSString *)num{
    NSArray *arr = [self getPropertyChaoXiang];
    
    NSString *str = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            str = [[arr objectAtIndex:i] objectForKey:@"Title"];
        }
    }
    
    DLog(@"edit--string [%@]", str);
    
    return str;
}

+ (NSString *)getExposureValueWithTitle:(NSString *)title {
    NSArray *arr = [self getPropertyChaoXiang];
    NSString *str = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if ([title isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Title"]]) {
            str = [[arr objectAtIndex:i] objectForKey:@"Value"];
        }
    }
    
    DLog(@"edit--string [%@]", str);
    
    return str;
}

//楼层-第几层
+ (int)getFloorIndexWithNum:(NSString *)num {
    NSArray *arr = [self getPropertyCeng_Number];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"floor--index [%d]", index);
    
    return index;
}

//楼层title-第几层
+ (int)getFloorIndexWithTitle:(NSString *)title {
    NSArray *arr = [self getPropertyCeng_Number];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([title isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Title"]]) {
            index = i;
        }
    }
    
    DLog(@"floor--index [%d]", index);
    
    return index;
}

//楼层Value-第几层Index
+ (int)getFloorIndexWithValue:(NSString *)value {
    NSArray *arr = [self getPropertyCeng_Number];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([value isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"floor--index [%d]", index);
    
    return index;
}

//楼层Index-第几层Value
+ (NSString *)getFloorValueWithIndex:(int)index {
    NSArray *arr = [self getPropertyLou_Number];
    
    NSString *value = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if (i == index) {
            value = [[arr objectAtIndex:i] objectForKey:@"Value"];
        }
    }
    
    return value;
}

//楼层-共几楼
+ (int)getProFloorIndexWithNum:(NSString *)num {
    NSArray *arr = [self getPropertyLou_Number];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([num isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"pro_floor--index [%d]", index);
    
    return index;
}

//楼层title-共几楼
+ (int)getProFloorIndexWithTitle:(NSString *)title {
    NSArray *arr = [self getPropertyLou_Number];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([title isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Title"]]) {
            index = i;
        }
    }
    
    DLog(@"pro_floor--index [%d]", index);
    
    return index;
}

//总楼层Value-第几层Index
+ (int)getProFloorIndexWithValue:(NSString *)value {
    NSArray *arr = [self getPropertyLou_Number];
    
    int index = 0;
    
    for (int i = 0; i < arr.count; i ++) {
        if ([value isEqualToString:[[arr objectAtIndex:i] objectForKey:@"Value"]]) {
            index = i;
        }
    }
    
    DLog(@"floor--index [%d]", index);
    
    return index;
}

//总楼层Index-总楼层Value
+ (NSString *)getProFloorValueWithIndex:(int)index {
    NSArray *arr = [self getPropertyCeng_Number];
    
    NSString *value = [NSString string];
    
    for (int i = 0; i < arr.count; i ++) {
        if (i == index) {
            value = [[arr objectAtIndex:i] objectForKey:@"Value"];
        }
    }
    
    return value;
}


@end

