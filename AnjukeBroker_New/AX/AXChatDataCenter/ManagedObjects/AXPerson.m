//
//  AXPerson.m
//  Anjuke2
//
//  Created by casa on 14-2-24.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXPerson.h"


@implementation AXPerson

@dynamic created;
@dynamic iconPath;
@dynamic iconUrl;
@dynamic isIconDownloaded;
@dynamic isPendingForAdd;
@dynamic isPendingForRemove;
@dynamic isStar;
@dynamic lastActiveTime;
@dynamic lastUpdate;
@dynamic markName;
@dynamic markNamePinyin;
@dynamic name;
@dynamic namePinyin;
@dynamic phone;
@dynamic uid;
@dynamic userType;
@dynamic company;

- (AXMappedPerson *)convertToMappedPerson
{
    AXMappedPerson *person = [[AXMappedPerson alloc] init];
    person.created = self.created;
    person.iconPath = self.iconPath;
    person.iconUrl = self.iconUrl;
    person.isIconDownloaded = self.isIconDownloaded;
    person.lastActiveTime = self.lastActiveTime;
    person.lastUpdate = self.lastUpdate;
    person.markName = self.markName;
    person.markNamePinyin = self.markNamePinyin;
    person.name = self.name;
    person.namePinyin = self.namePinyin;
    person.isPendingForAdd = self.isPendingForAdd;
    person.phone = self.phone;
    person.uid = self.uid;
    person.userType = self.userType;
    person.isStar = self.isStar;
    person.isPendingForRemove = self.isPendingForRemove;
    person.company = self.company;
    return person;
}

- (void)assignPropertiesFromMappedObject:(AXMappedPerson *)person
{
    self.created = person.created;
    self.iconPath = person.iconPath;
    self.iconUrl = person.iconUrl;
    self.isIconDownloaded = [NSNumber numberWithBool:person.isIconDownloaded];;
    self.lastActiveTime = person.lastActiveTime;
    self.lastUpdate = person.lastUpdate;
    self.markName = person.markName;
    self.markNamePinyin = person.markNamePinyin;
    self.name = person.name;
    self.namePinyin = person.namePinyin;
    self.isPendingForRemove = [NSNumber numberWithBool:person.isPendingForRemove];
    self.phone = person.phone;
    self.uid = person.uid;
    self.userType = @(person.userType);
    self.isStar = [NSNumber numberWithBool:person.isStar];
    self.isPendingForAdd = [NSNumber numberWithBool:person.isPendingForAdd];
    self.company = person.company;
}

- (void)awakeFromInsert
{
    self.isPendingForRemove = [NSNumber numberWithBool:NO];
}

@end
