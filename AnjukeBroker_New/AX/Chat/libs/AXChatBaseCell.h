//
//  AXChatBaseCell.h
//  Anjuke2
//
//  Created by Gin on 3/2/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXMappedMessage.h"
#import "AXMappedPerson.h"

typedef NS_ENUM(NSInteger, AXChatMessageSourceDestination)
{
    AXChatMessageSourceDestinationIncoming,
    AXChatMessageSourceDestinationOutPut
};

typedef NS_ENUM(NSUInteger,AXChatCellViewType )
{
    AXChatCellViewTypePhoneAlert,
    AXChatCellViewTypePhoneAction,
    AXChatCellViewTypeRetry
};

@class AXChatBaseCell;

@protocol AXChatBaseCellDelegate <NSObject>

@optional
- (void)deleteAXCell:(AXChatBaseCell *)axCell;
- (void)didMessageRetry:(AXChatBaseCell *)axCell;
- (void)didOpenAXWebView:(NSString *)url;
- (void)didClickAvatar:(BOOL)isCurrentPerson;
- (void)didClickSystemButton:(AXMessageType)messageType;

@end

@interface AXChatBaseCell : UITableViewCell


@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic) BOOL isBroker;
@property (nonatomic, weak) id<AXChatBaseCellDelegate> delegate;
@property (nonatomic) AXChatMessageSourceDestination messageSource;
@property (nonatomic) AXMessageCenterSendMessageStatus messageStatus;

- (void)configAvatar:(AXMappedPerson *)person;
- (void)configWithData:(NSDictionary *)data;
- (void)configWithIndexPath:(NSIndexPath *)indexPath;

@end
