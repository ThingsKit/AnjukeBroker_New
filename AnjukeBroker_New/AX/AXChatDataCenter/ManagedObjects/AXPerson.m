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
@dynamic firstPinYin;
@dynamic markDesc;
@dynamic markPhone;

- (AXMappedPerson *)convertToMappedPerson
{
    AXMappedPerson *person = [[AXMappedPerson alloc] init];
    person.created = self.created;
    person.iconPath = self.iconPath;
    person.iconUrl = self.iconUrl;
    person.isIconDownloaded = [self.isIconDownloaded boolValue];
    person.lastActiveTime = self.lastActiveTime;
    person.lastUpdate = self.lastUpdate;
    person.markName = self.markName;
    person.markNamePinyin = self.markNamePinyin;
    person.name = self.name;
    person.namePinyin = self.namePinyin;
    person.isPendingForAdd = [self.isPendingForAdd boolValue];
    person.phone = self.phone;
    person.uid = self.uid;
    person.userType = [self.userType integerValue];
    person.isStar = [self.isStar boolValue];
    person.isPendingForRemove = [self.isPendingForRemove boolValue];
    person.company = self.company;
    person.markPhone = self.markPhone;
    person.markDesc = self.markDesc;
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
    self.markPhone = person.markPhone;
    self.markDesc = person.markDesc;
}

- (void)awakeFromInsert
{
    self.isPendingForRemove = [NSNumber numberWithBool:NO];
}

- (void)willSave
{
    [super willSave];
    
    unichar firstPinYin = '#';
    if ([self.markNamePinyin length] > 0) {
        firstPinYin = [[self.markNamePinyin uppercaseString] characterAtIndex:0];
    } else {
        if ([self.namePinyin length] > 0) {
            firstPinYin = [[self.namePinyin uppercaseString] characterAtIndex:0];
        }
    }
    if (firstPinYin < 'A' && firstPinYin > 'Z') {
        [self setPrimitiveValue:@"#" forKey:@"firstPinYin"];
    } else {
        [self setPrimitiveValue:[NSString stringWithCharacters:&firstPinYin length:1] forKey:@"firstPinYin"];
    }
}

@end
