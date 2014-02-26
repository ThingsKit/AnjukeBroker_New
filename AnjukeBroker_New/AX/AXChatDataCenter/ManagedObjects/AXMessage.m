//
//  AXMessage.m
//  Anjuke2
//
//  Created by casa on 14-2-24.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXMessage.h"


@implementation AXMessage

@dynamic accountType;
@dynamic content;
@dynamic from;
@dynamic identifier;
@dynamic imgPath;
@dynamic imgUrl;
@dynamic isImgDownloaded;
@dynamic isRead;
@dynamic isRemoved;
@dynamic messageId;
@dynamic messageType;
@dynamic sendStatus;
@dynamic sendTime;
@dynamic thumbnailImgPath;
@dynamic thumbnailImgUrl;
@dynamic to;

- (AXMappedMessage *)convertToMappedObject
{
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = self.accountType;
    mappedMessage.content = self.content;
    mappedMessage.from = self.from;
    mappedMessage.identifier = self.identifier;
    mappedMessage.imgPath = self.imgPath;
    mappedMessage.imgUrl = self.imgUrl;
    mappedMessage.isImgDownloaded = self.isImgDownloaded;
    mappedMessage.isRead = self.isRead;
    mappedMessage.isRemoved = self.isRemoved;
    mappedMessage.messageId = self.messageId;
    mappedMessage.messageType = self.messageType;
    mappedMessage.sendStatus = self.sendStatus;
    mappedMessage.sendTime = self.sendTime;
    mappedMessage.thumbnailImgPath = self.thumbnailImgPath;
    mappedMessage.thumbnailImgUrl = self.thumbnailImgUrl;
    mappedMessage.to = self.to;
    return mappedMessage;
}

- (void)assignPropertiesFromMappedObject:(AXMappedMessage *)mappedMessage
{
    self.accountType = mappedMessage.accountType;
    self.content = mappedMessage.content;
    self.from = mappedMessage.from;
    self.imgPath = mappedMessage.imgPath;
    self.imgUrl = mappedMessage.imgUrl;
    self.isImgDownloaded = mappedMessage.isImgDownloaded;
    self.isRead = mappedMessage.isRead;
    self.isRemoved = mappedMessage.isRemoved;
    self.messageId = mappedMessage.messageId;
    self.messageType = mappedMessage.messageType;
    self.sendStatus = mappedMessage.sendStatus;
    self.sendTime = mappedMessage.sendTime;
    self.thumbnailImgPath = mappedMessage.thumbnailImgPath;
    self.thumbnailImgUrl = mappedMessage.thumbnailImgUrl;
    self.to = mappedMessage.to;
}

- (void)awakeFromInsert
{
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
    NSString *uuidString = [NSString stringWithString:(NSString*)CFBridgingRelease(strRef)];
    self.identifier = uuidString;
    self.messageId = @(0);
    self.isRead = [NSNumber numberWithBool:NO];
    self.isRemoved = [NSNumber numberWithBool:NO];
    self.isImgDownloaded = [NSNumber numberWithBool:NO];
    CFRelease(uuidObj);
}

@end
