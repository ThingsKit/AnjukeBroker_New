//
//  CheckInfoWithCommunity.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckInfoWithCommunity : NSObject

@property(nonatomic, assign) NSNumber *countDown;
@property(nonatomic, assign) NSNumber *signAble;
@property(nonatomic, assign) NSNumber *signCount;
@property(nonatomic, strong) NSArray *signList;

- (CheckInfoWithCommunity *)convertToMappedObject:(NSDictionary *)dic;
@end
