//
//  PPCPriceingListModel.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCPriceingListModel.h"

@implementation PPCPriceingListModel

+ (PPCPriceingListModel *)convertToMappedObject:(NSDictionary *)dic{
    PPCPriceingListModel *model = [[PPCPriceingListModel alloc] init];
    model.propId = dic[@"propId"] ? dic[@"propId"] : @"";
    model.title = dic[@"title"] ? dic[@"title"] : @"";
    model.commId = dic[@"commId"] ? dic[@"commId"] : @"";
    model.commName = dic[@"commName"] ? dic[@"commName"] : @"";
    model.roomNum = dic[@"roomNum"] ? dic[@"roomNum"] : @"";
    model.hallNum = dic[@"hallNum"] ? dic[@"hallNum"] : @"";
    model.toiletNum = dic[@"toiletNum"] ? dic[@"toiletNum"] : @"";
    model.area = dic[@"area"] ? dic[@"area"] : @"";
    model.price = dic[@"price"] ? dic[@"price"] : @"";
    model.priceUnit = dic[@"priceUnit"] ? dic[@"priceUnit"] : @"";
    model.fixClickNum = dic[@"fixClickNum"] ? dic[@"fixClickNum"] : @"";
    model.isBid = dic[@"isBid"] ? dic[@"isBid"] : @"";
    model.isChoice = dic[@"isChoice"] ? dic[@"isChoice"] : @"";
    model.isMoreImg = dic[@"isMoreImg"] ? dic[@"isMoreImg"] : @"";
    model.isVisible = dic[@"isVisible"] ? dic[@"isVisible"] : @"";
    model.isPhonePub = dic[@"isPhonePub"] ? dic[@"isPhonePub"] : [NSString stringWithFormat:@"%@",dic[@"isFromMobile"] ? dic[@"isFromMobile"] : @""];
    model.createTime = dic[@"createTime"] ? dic[@"createTime"] : @"";
    model.imgURL = dic[@"imgURL"] ? dic[@"imgURL"] : [NSString stringWithFormat:@"%@",dic[@"imgUrl"] ? dic[@"imgUrl"] : @""];

    return model;
}

@end
