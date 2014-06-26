//
//  ViewController.h
//  X
//
//  Created by 杨 志豪 on 2/12/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXChatMessageSystemTimeCell.h"
#import "BK_ELCImagePickerController.h"
#import "BK_ELCAlbumPickerController.h"
#import "AXConversationListItem.h"
#import "AXChatMessageCenter.h"
#import "MapViewController.h"
#import "RTViewController.h"
#import "JSMessageInputView.h"
#import "FaceScrollView.h"
#import "AppDelegate.h"

#define AXWINDOWWHIDTH [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width
#define AXWINDOWHEIGHT [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height

static NSInteger const AXNavBarHeight = 44.0f;
static NSInteger const AXStatuBarHeight = 20.0f;
static NSString * const AXPhotoFolderName = @"AXCaht_AJK_Broker";

//微聊单页buttonkey（存在buttonDict）
static NSString *AXBTKEYPIC      = @"AxbtkeyPic";       //照片
static NSString *AXBTKEYTAKE     = @"AxbtkeyTake";      //拍照
static NSString *AXBTKEYER       = @"Axbtkeyer";        //二手房
static NSString *AXBTKEYZU       = @"Axbtkeyzu";        //租房
static NSString *AXBTKEYLOCAL    = @"Axbtkeylocal";     //位置
static NSString *AXBTKEYTALL     = @"Axbtkeytall";      //语音
static NSString *AXBTKEYEMIJE    = @"Axbtkeyemije";     //表情
static NSString *AXBTKEYMORE     = @"Axbtkeymore";      //更多
static NSString *AXBTKEYPEOPLE   = @"Axbtkeypeople";    //个人资料
static NSString *AXUITEXVIEWEDIT = @"AxuitextviewEdit"; //输入框

@interface AXChatViewController : RTViewController <UITextViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate, AXChatMessageSystemCellDelegate, ELCImagePickerControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UITableView *myTableView;
// 禁止直接修改celldata和identifierData
@property (nonatomic, strong) NSMutableDictionary *cellDict;
@property (nonatomic, strong) NSMutableArray *identifierData;
@property (nonatomic, strong) UIButton *backBtn;

@property (strong, nonatomic) UIButton *sendBut;
@property (strong, nonatomic) UIButton *voiceBut;
@property (strong, nonatomic) UIView *moreBackView;// 更多操作
@property (nonatomic, strong) JSMessageInputView *messageInputView;
@property BOOL isBroker;
@property (nonatomic, strong) NSDictionary *propDict;
@property (nonatomic) BOOL needSendProp;
@property (nonatomic, strong) AXMappedConversationListItem *conversationListItem;
@property (nonatomic, strong) void (^finishSendMessageBlock)(NSArray *messages,AXMessageCenterSendMessageStatus status,AXMessageCenterSendMessageErrorTypeCode errorCode);
@property (nonatomic, strong) void (^finishReSendMessageBlock)(NSArray *messages,AXMessageCenterSendMessageStatus status,AXMessageCenterSendMessageErrorTypeCode errorCode);

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *brokerName;
@property (nonatomic, strong) AXMappedPerson *friendPerson;
@property (nonatomic, strong) NSMutableArray *locationArray;
@property (nonatomic, strong) NSMutableDictionary *buttonDict;//微聊单页buttonarr
@property BOOL isVoiceInput;
//表情相关
@property (nonatomic, strong) FaceScrollView* emojiScrollView;
@property (nonatomic, strong) UIButton* emojiBut;

//公众账号菜单
@property (nonatomic, assign) BOOL isHavPublicMenu; //是否有菜单

- (BOOL)checkUserLogin;
- (NSString *)checkFriendUid;
- (void)didClickSystemButton:(AXMessageType)messageType;
- (void)afterSendMessage;
- (void)sendPropMessage;
- (void)goBrokerPage:(id)sender;
- (AXMappedMessage *)sendSystemMessage:(AXMessageType)type content:(NSString *)con messageId:(NSString *)messId;
- (void)sendSystemMessage:(AXMessageType)type;
- (void)reloadUnReadNum:(NSInteger)num;
- (NSDate *)formatterDate:(NSDate *)date;

- (void)didEmojiButClick;
- (void)speeking;
- (void)restoreDraftContent;

// applog
- (void)sendMessageAppLog;
- (void)clickRightNavButtonAppLog;
- (void)clickLeftAvatarAppLog;
- (void)clickInputViewAppLog;
- (void)didMoreBackView:(UIButton *)sender;
- (void)clickLocationLog;
- (void)switchToVoiceLog;
- (void)switchToTextLog;
- (void)pressForVoiceLog;
- (void)cancelSendingVoiceLog;
- (void)didClickKeyboardControl;

//初始化learnview的bt
- (void)initButtonInLearnView;

//uitableviewdelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
