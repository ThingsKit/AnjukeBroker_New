//
//  AXMappedPerson.h
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AXConversationListItem;

typedef NS_ENUM(NSUInteger, AXPersonType)
{
    AXPersonTypeUser,
    AXPersonTypeBroker,
    AXPersonTypeServer,
    AXPersonTypePublic
};

@interface AXMappedPerson : NSObject

@property (nonatomic, strong) NSDate * created;
@property (nonatomic, strong) NSString * iconPath;
@property (nonatomic, strong) NSString * iconUrl;
@property (nonatomic, strong) NSNumber * isIconDownloaded;
@property (nonatomic, strong) NSDate * lastActiveTime;
@property (nonatomic, strong) NSDate * lastUpdate;
@property (nonatomic, strong) NSString * markName;
@property (nonatomic, strong) NSString * markNamePinyin;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * namePinyin;
@property (nonatomic, strong) NSNumber * isRemoved;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * uid;
@property (nonatomic, strong) NSString * company;
@property (nonatomic, strong) NSNumber * userType;
@property (nonatomic, strong) NSNumber * isStar;
@property (nonatomic, strong) NSNumber * isPending;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
