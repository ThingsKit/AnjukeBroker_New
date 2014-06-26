//
//  AXMappedMessage.m
//  XCoreData
//
//  Created by ; on 14-2-18.
//  Copyright (c) 2014年 casa. All rights reserved.
//

#import "AXMappedMessage.h"


@implementation AXMappedMessage

- (AXMessage *)mappedMeessageToAxMessage
{
    AXMessage *mess = [[AXMessage alloc] init];
    mess.accountType = self.accountType;
    mess.content = self.content;
    mess.from = self.from;
    mess.identifier = self.identifier;
    mess.imgPath = self.imgPath;
    mess.imgUrl = self.imgUrl;
    mess.isImgDownloaded = [NSNumber numberWithBool:self.isImgDownloaded];
    mess.isRead = [NSNumber numberWithBool:self.isRead];
    mess.isRemoved = [NSNumber numberWithBool:self.isRemoved];
    mess.messageId = self.messageId;
    mess.messageType = self.messageType;
    mess.sendStatus = self.sendStatus;
    mess.sendTime = self.sendTime;
    mess.thumbnailImgPath = self.thumbnailImgPath;
    mess.thumbnailImgUrl = self.thumbnailImgUrl;
    mess.to = self.to;
    mess.isUploaded = [NSNumber numberWithBool:self.isUploaded];
    mess.orderNumber = [NSNumber numberWithBool:self.orderNumber];
    
    return mess;
    
}
@end
