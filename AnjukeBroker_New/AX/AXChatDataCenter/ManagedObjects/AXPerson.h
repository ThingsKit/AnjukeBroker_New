//
//  AXPerson.h
//  Anjuke2
//
//  Created by casa on 14-2-24.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AXMappedPerson.h"

@interface AXPerson : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSString * iconPath;
@property (nonatomic, retain) NSString * iconUrl;
@property (nonatomic, retain) NSNumber * isIconDownloaded;
@property (nonatomic, retain) NSNumber * isPendingForAdd;
@property (nonatomic, retain) NSNumber * isPendingForRemove;
@property (nonatomic, retain) NSNumber * isStar;
@property (nonatomic, retain) NSDate * lastActiveTime;
@property (nonatomic, retain) NSDate * lastUpdate;
@property (nonatomic, retain) NSString * markName;
@property (nonatomic, retain) NSString * markNamePinyin;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * namePinyin;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSNumber * userType;

- (void)assignPropertiesFromMappedObject:(AXMappedPerson *)person;
- (AXMappedPerson *)convertToMappedPerson;

@end
