//
//  AJKChatMessageBaseCell.h
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXChatDataCenter.h"
#import "UIView+AXChatMessage.h"
#import "UIColor+AXChatMessage.h"
#import "UIImage+AXChatMessage.h"
#import "UIFont+AXChatMessage.h"

typedef NS_ENUM(NSInteger, AXChatMessageSourceDestination)
{
    AXChatMessageSourceDestinationIncoming,
    AXChatMessageSourceDestinationOutPut
};

extern NSString * const AXCellIdentifyTag;
extern CGFloat const axTagMarginTop;
extern CGFloat const kJSAvatarSize;
extern CGFloat const kAvatarMargin;

@class AXChatMessageRootCell;

@protocol AXChatMessageRootCellDelegate <NSObject>

@optional
- (void)deleteAXCell:(AXChatMessageRootCell *)axCell;
- (void)didMessageRetry:(AXChatMessageRootCell *)axCell;
- (void)didOpenAXWebView:(NSString *)url;
- (void)didClickAvatar:(BOOL)isCurrentPerson;

@end

@interface AXChatMessageRootCell : UITableViewCell

@property (nonatomic) AXMessageCenterSendMessageStatus messageStatus;
@property (nonatomic, readonly) AXMessageType messageType;
@property (nonatomic) AXChatMessageSourceDestination messageSource;
@property (nonatomic, strong) NSString *identifyString;
@property (nonatomic, strong) UIImageView *userImage;
@property (strong, nonatomic) UIImageView *bubbleIMG;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic) BOOL isBroker;
// config的数据
@property (nonatomic, strong) NSDictionary *rowData;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UIButton *errorButton;
@property (nonatomic, strong) AXMappedPerson *person;

@property (nonatomic, weak) id<AXChatMessageRootCellDelegate> delegate;

- (void)configWithIndexPath:(NSIndexPath *)indexPath;
- (void)configWithData:(NSDictionary *)data;
- (void)configAvatar:(AXMappedPerson *)person;
- (void)initUI;
- (void)configWithStatus;
- (void)axDelete:(id)sender;
- (void)axCopy:(id)sender;
@end
