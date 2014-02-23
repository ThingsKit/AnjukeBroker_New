//
//  AXMappedConversationListItem.h
//  XCoreData
//
//  Created by casa on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXMappedPerson.h"

@interface AXMappedConversationListItem : NSObject

@property (nonatomic, strong) NSNumber * count;
@property (nonatomic, strong) NSDate * createTime;
@property (nonatomic, strong) NSString * from;
@property (nonatomic, strong) NSDate * lastUpdateTime;
@property (nonatomic, strong) NSString * messageTip;
@property (nonatomic, strong) NSString * to;
@property (nonatomic, strong) AXMappedPerson *fromPerson;
@property (nonatomic, strong) AXMappedPerson *toPerson;

@end
