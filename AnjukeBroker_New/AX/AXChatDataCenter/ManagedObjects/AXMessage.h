//
//  AXMessage.h
//  Anjuke2
//
//  Created by casa on 14-2-24.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class AXMappedMessage;

@interface AXMessage : NSManagedObject

@property (nonatomic, retain) NSString * accountType;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * imgPath;
@property (nonatomic, retain) NSString * imgUrl;
@property (nonatomic, retain) NSNumber * isImgDownloaded;
@property (nonatomic, retain) NSNumber * isRead;
@property (nonatomic, retain) NSNumber * isRemoved;
@property (nonatomic, retain) NSNumber * messageId;
@property (nonatomic, retain) NSNumber * messageType;
@property (nonatomic, retain) NSNumber * sendStatus;
@property (nonatomic, retain) NSDate * sendTime;
@property (nonatomic, retain) NSString * thumbnailImgPath;
@property (nonatomic, retain) NSString * thumbnailImgUrl;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSNumber * isUploaded;
@property (nonatomic, retain) NSNumber * orderNumber;

- (void)assignPropertiesFromMappedObject:(AXMappedMessage *)mappedMessage;
- (AXMappedMessage *)convertToMappedObject;

@end
