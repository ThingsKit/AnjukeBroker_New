//
//  PPCPriceingListModel.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPCPriceingListModel : NSObject

@property(nonatomic, strong) NSString *propId;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *commId;
@property(nonatomic, strong) NSString *commName;
@property(nonatomic, strong) NSString *roomNum;
@property(nonatomic, strong) NSString *hallNum;
@property(nonatomic, strong) NSString *toiletNum;
@property(nonatomic, strong) NSString *area;
@property(nonatomic, strong) NSString *price;
@property(nonatomic, strong) NSString *priceUnit;
@property(nonatomic, strong) NSString *totalClicks;
@property(nonatomic, strong) NSString *isBid;
@property(nonatomic, strong) NSString *isChoice;
@property(nonatomic, strong) NSString *isMoreImg;
@property(nonatomic, strong) NSString *isVisible;
@property(nonatomic, strong) NSString *isPhonePub;
@property(nonatomic, strong) NSString *createTime;
@property(nonatomic, strong) NSString *imgURL;

+ (PPCPriceingListModel *)convertToMappedObject:(NSDictionary *)dic;
@end
