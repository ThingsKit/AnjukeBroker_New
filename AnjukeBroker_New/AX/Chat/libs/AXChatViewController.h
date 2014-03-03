//
//  ViewController.h
//  X
//
//  Created by 杨 志豪 on 2/12/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXChatMessageSystemTimeCell.h"
#import "AXELCImagePickerController.h"
#import "AXConversationListItem.h"

#define AXWINDOWWHIDTH [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width
#define AXWINDOWHEIGHT [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height

static NSInteger const AXNavBarHeight = 44.0f;
static NSInteger const AXStatuBarHeight = 20.0f;
static NSString * const AXPhotoFolderName = @"AXCaht_AJK_Broker";

@interface AXChatViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, AXChatMessageSystemCellDelegate, AXELCImagePickerControllerDelegate, UIImagePickerControllerDelegate>

// 禁止直接修改celldata和identifierData
@property (nonatomic, strong) NSMutableArray *cellData;
@property (nonatomic, strong) NSMutableArray *identifierData;

@property (strong, nonatomic) UIButton *sendBut;
@property (strong, nonatomic) UIView *moreBackView;// 更多操作
@property BOOL isBroker;
@property (nonatomic, strong) NSDictionary *propDict;
@property (nonatomic, strong) AXMappedConversationListItem *conversationListItem;
@property (nonatomic, strong) void (^finishSendMessageBlock)(AXMappedMessage *message,AXMessageCenterSendMessageStatus status);
@property (nonatomic, strong) void (^finishReSendMessageBlock)(AXMappedMessage *message,AXMessageCenterSendMessageStatus status);

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) AXMappedPerson *friendPerson;

- (void)didClickSystemButton:(AXMessageType)messageType;
- (void)sendPropMessage;

@end
