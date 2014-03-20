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
#import "AXChatMessageCenter.h"
#import "MapViewController.h"

#define AXWINDOWWHIDTH [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width
#define AXWINDOWHEIGHT [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height

static NSInteger const AXNavBarHeight = 44.0f;
static NSInteger const AXStatuBarHeight = 20.0f;
static NSString * const AXPhotoFolderName = @"AXCaht_AJK_Broker";

@interface AXChatViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, AXChatMessageSystemCellDelegate, AXELCImagePickerControllerDelegate, UIImagePickerControllerDelegate>

// 禁止直接修改celldata和identifierData
@property (nonatomic, strong) NSMutableDictionary *cellDict;
@property (nonatomic, strong) NSMutableArray *identifierData;
@property (nonatomic, strong) UIButton *backBtn;

@property (strong, nonatomic) UIButton *sendBut;
@property (strong, nonatomic) UIButton *voiceBut;
@property (strong, nonatomic) UIView *moreBackView;// 更多操作
@property BOOL isBroker;
@property (nonatomic, strong) NSDictionary *propDict;
@property (nonatomic) BOOL needSendProp;
@property (nonatomic, strong) AXMappedConversationListItem *conversationListItem;
@property (nonatomic, strong) void (^finishSendMessageBlock)(NSArray *messages,AXMessageCenterSendMessageStatus status,AXMessageCenterSendMessageErrorTypeCode errorCode);
@property (nonatomic, strong) void (^finishReSendMessageBlock)(NSArray *messages,AXMessageCenterSendMessageStatus status,AXMessageCenterSendMessageErrorTypeCode errorCode);

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *brokerName;
@property (nonatomic, strong) AXMappedPerson *friendPerson;



- (BOOL)checkUserLogin;
- (NSString *)checkFriendUid;
- (void)didClickSystemButton:(AXMessageType)messageType;
- (void)afterSendMessage;
- (void)sendPropMessage;
- (void)goBrokerPage:(id)sender;
- (void)sendSystemMessage:(AXMessageType)type;
- (void)reloadUnReadNum:(NSInteger)num;
- (NSDate *)formatterDate:(NSDate *)date;
// applog
- (void)sendMessageAppLog;
- (void)clickRightNavButtonAppLog;
- (void)clickLeftAvatarAppLog;
- (void)clickInputViewAppLog;
- (void)didMoreBackView:(UIButton *)sender;


@end
