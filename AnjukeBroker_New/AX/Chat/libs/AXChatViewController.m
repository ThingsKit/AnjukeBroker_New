//
//  ViewController.m
//  X
//
//  Created by 杨 志豪 on 2/12/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatViewController.h"

#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

// Cell
#import "AXChatMessageRoomSourceCell.h"
#import "AXChatMessageImageCell.h"
#import "AXChatMessagePublicCardCell.h"
#import "AXChatMessageTextCell.h"
#import "AXChatMessageNameCardCell.h"
#import "AXChatMessageSystemTimeCell.h"

#import "NSString+AXChatMessage.h"
#import "UIColor+AXChatMessage.h"
#import "NSString+JSMessagesView.h"

#import "AXChatMessageCenter.h"

#import "AXPullToRefreshContentView.h"
#import "JSMessageInputView.h"

// Controller
#import "AXBigIMGSViewController.h"
#import "AXChatWebViewController.h"
//#import "AJKBrokerInfoViewController.h"

#import "AXPhotoManager.h"
#import "AXCellFactory.h"


//输入框和发送按钮栏的高度
static CGFloat const AXInputBackViewHeight = 49;
//键盘高度
static CGFloat const AXMoreBackViewHeight = 217.0f;

//输入框的宽度
static CGFloat const AXInputTextWidth = 260.0f;
static CGFloat const AXInputTextLeft = 12.0f;
static CGFloat const AXInputTextHeight = 30.0f;
static CGFloat const AXTextCellMoreHeight = 60.0f;

#ifdef DEBUG
static NSInteger const AXMessagePageSize = 15;
#else
static NSInteger const AXMessagePageSize = 15;
#endif

@interface AXChatViewController ()<UITableViewDelegate, UITableViewDataSource, OHAttributedLabelDelegate, AXPullToRefreshViewDelegate, UIAlertViewDelegate, AXChatBaseCellDelegate, JSDismissiveTextViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITableViewCell *selectedCell;
@property (nonatomic) BOOL isMenuVisible;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) CGFloat tableViewBottom;

@property (nonatomic, strong) AXPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) AXMappedMessage *lastMessage;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIControl *keyboardControl;

@property (nonatomic, strong) AXMappedPerson *currentPerson;
//@property (nonatomic, strong) AXMappedPerson *friendPerson;

// JSMessage
@property (nonatomic, strong) UIView *inputBackView;
@property (nonatomic) CGFloat previousTextViewContentHeight;
@property (nonatomic) BOOL isUserScrolling;
@property (nonatomic, strong) JSMessageInputView *messageInputView;

//Debug
@property (nonatomic, strong) NSString *testUid;
@property (nonatomic, strong) NSNotification *preNotification;

@end

@implementation AXChatViewController
@synthesize myTableView;

#pragma mark - lifeCyle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBroker = YES;
        _isMenuVisible = YES;
        _isFinished = NO;
    }
    return self;
}

- (void)dealloc
{
    [self.messageInputView.textView removeObserver:self forKeyPath:@"contentSize"];
    self.messageInputView = nil;
    self.pullToRefreshView.delegate = nil;
    self.pullToRefreshView = nil;
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    self.myTableView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboardNotification:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboardNotification:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.isFinished) {
        self.isFinished = YES;
        if (self.conversationListItem) {
            if (!self.previousTextViewContentHeight) {
                self.previousTextViewContentHeight = self.messageInputView.textView.contentSize.height;
            }
            self.messageInputView.textView.text = self.conversationListItem.draftContent;
        }
        [self.myTableView reloadData];
        [self scrollToBottomAnimated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //草稿
    if (self.messageInputView) {
        [[AXChatMessageCenter defaultMessageCenter] saveDraft:self.messageInputView.textView.text friendUID:[self checkFriendUid]];
    }

    [self.messageInputView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[AXChatMessageCenter defaultMessageCenter] didLeaveChattingList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.conversationListItem = [[AXChatMessageCenter defaultMessageCenter] fetchConversationListItemWithFriendUID:[self checkFriendUid]];
    [self initUI];
    self.currentPerson = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson];
    self.friendPerson = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[self checkFriendUid]];
    
    self.title = self.currentPerson.name;
    self.cellData = [NSMutableArray array];
    self.identifierData = [NSMutableArray array];
    AXMappedMessage *lastMessage = [[AXMappedMessage alloc] init];
    lastMessage.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];
    lastMessage.from = self.currentPerson.uid;
    lastMessage.to  = [self checkFriendUid];
    
    __weak AXChatViewController *blockSelf = self;
    
    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:lastMessage pageSize:AXMessagePageSize callBack:^(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        if ([chatList count] > 0) {
            blockSelf.lastMessage = chatList[0];
            for (AXMappedMessage *mappedMessage in chatList) {
                NSMutableDictionary *dict = [blockSelf mapAXMappedMessage:mappedMessage];
                if (!dict) {
                    continue;
                }
                if ([mappedMessage.from isEqualToString:[blockSelf checkFriendUid]]) {
                    dict[@"messageSource"] = @(AXChatMessageSourceDestinationIncoming);
                }
                
                [blockSelf.cellData addObject:dict];
                [blockSelf.identifierData addObject:mappedMessage.identifier];
            }
            [blockSelf.myTableView reloadData];
            [blockSelf scrollToBottomAnimated:YES];
        } else {
            if (blockSelf.propDict && [blockSelf.cellData count] == 0) {
                [blockSelf sendSystemMessage:AXMessageTypeSendProperty];
            }
        }
        
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            [blockSelf sendSystemMessage:AXMessageTypeSettingNotifycation];
        }

        [blockSelf addMessageNotifycation];
    }];
    
    // 发消息的block
    @autoreleasepool {

        self.finishReSendMessageBlock = ^ (AXMappedMessage *message, AXMessageCenterSendMessageStatus status) {
        NSMutableDictionary *textData = [NSMutableDictionary dictionary];
            textData = [blockSelf mapAXMappedMessage:message];
            if (textData) {
//                if (status != AXMessageCenterSendMessageStatusSending) {
//                    status = AXMessageCenterSendMessageStatusFailed;
//                }
                if (status == AXMessageCenterSendMessageStatusSending) {
                    textData[@"status"] = @(AXMessageCenterSendMessageStatusSending);
                    textData[AXCellIdentifyTag] = message.identifier;
                    [blockSelf appendCellData:textData];
                } else if (status == AXMessageCenterSendMessageStatusFailed) {
                    NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                    blockSelf.cellData[index][@"status"] = @(AXMessageCenterSendMessageStatusFailed);
                    [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                    NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                    blockSelf.cellData[index][@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                    [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        };
        
        self.finishSendMessageBlock = ^ (AXMappedMessage *message, AXMessageCenterSendMessageStatus status) {
            NSMutableDictionary *textData = [NSMutableDictionary dictionary];
            textData = [blockSelf mapAXMappedMessage:message];
            if (textData) {
//                if (status != AXMessageCenterSendMessageStatusSending) {
//                    status = AXMessageCenterSendMessageStatusFailed;
//                }
                if (status == AXMessageCenterSendMessageStatusSending) {
                    textData[@"status"] = @(AXMessageCenterSendMessageStatusSending);
                    textData[AXCellIdentifyTag] = message.identifier;
                    [blockSelf axAddCellData:textData];
                } else if (status == AXMessageCenterSendMessageStatusFailed) {
                    NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                    blockSelf.cellData[index][@"status"] = @(AXMessageCenterSendMessageStatusFailed);
                    [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                    NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                    blockSelf.cellData[index][@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                    [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        };
    }
    
    [self addPullToRefresh];
    
    
    // TEST
    /*
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = @"1";
    mappedMessage.content = @"速度";
    mappedMessage.to = @"30";
    mappedMessage.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypeText];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage willSendMessage:self.finishSendMessageBlock];
    
    AXMappedMessage *mappedMessage2 = [[AXMappedMessage alloc] init];
    mappedMessage2.accountType = @"1";
    mappedMessage2.content = @"你已关闭消息提醒。打开消息提醒能够及时得到经纪人的反馈。";
    mappedMessage2.to = @"30";
    mappedMessage2.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage2.isRead = YES;
    mappedMessage2.isRemoved = NO;
    mappedMessage2.messageType = [NSNumber numberWithInteger:AXMessageTypeSettingNotifycation];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage2 willSendMessage:self.finishSendMessageBlock];
    
    AXMappedMessage *mappedMessage3 = [[AXMappedMessage alloc] init];
    mappedMessage3.accountType = @"1";
    mappedMessage3.content = @"对方已拒收了你的消息";
    mappedMessage3.to = @"30";
    mappedMessage3.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage3.isRead = YES;
    mappedMessage3.isRemoved = NO;
    mappedMessage3.messageType = [NSNumber numberWithInteger:AXMessageTypeSystemForbid];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage3 willSendMessage:self.finishSendMessageBlock];
    
    AXMappedMessage *mappedMessage4 = [[AXMappedMessage alloc] init];
    mappedMessage4.accountType = @"1";
    mappedMessage4.content = @"12月20日";
    mappedMessage4.to = @"30";
    mappedMessage4.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage4.isRead = YES;
    mappedMessage4.isRemoved = NO;
    mappedMessage4.messageType = [NSNumber numberWithInteger:AXMessageTypeSystemTime];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage4 willSendMessage:self.finishSendMessageBlock];
    
    AXMappedMessage *mappedMessage5 = [[AXMappedMessage alloc] init];
    mappedMessage5.accountType = @"1";
    mappedMessage5.content = @"对方已拒收了你的消息";
    mappedMessage5.to = @"30";
    mappedMessage5.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage5.isRead = YES;
    mappedMessage5.isRemoved = NO;
    mappedMessage5.messageType = [NSNumber numberWithInteger:AXMessageTypeSendProperty];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage5 willSendMessage:self.finishSendMessageBlock];
    
    AXMappedMessage *mappedMessage6 = [[AXMappedMessage alloc] init];
    mappedMessage6.accountType = @"1";
    mappedMessage6.content = @"对方已拒收了你的消息";
    mappedMessage6.to = @"30";
    mappedMessage6.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage6.isRead = YES;
    mappedMessage6.isRemoved = NO;
    mappedMessage6.messageType = [NSNumber numberWithInteger:AXMessageTypeAddNuckName];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage6 willSendMessage:self.finishSendMessageBlock];
    
    AXMappedMessage *mappedMessage7 = [[AXMappedMessage alloc] init];
    mappedMessage7.accountType = @"1";
    mappedMessage7.content = @"对方已拒收了你的消息";
    mappedMessage7.to = @"30";
    mappedMessage7.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage7.isRead = YES;
    mappedMessage7.isRemoved = NO;
    mappedMessage7.messageType = [NSNumber numberWithInteger:AXMessageTypeSafeMessage];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage7 willSendMessage:self.finishSendMessageBlock];
    
     */
    
}

- (void)sendPropMessage
{
    // 如果第一次发消息，发送房源信息
    if (self.propDict) {
        AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
        mappedMessageProp.accountType = [self checkAccountType];
        mappedMessageProp.content = [self.propDict JSONRepresentation];
        mappedMessageProp.to = [self checkFriendUid];
        mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
        mappedMessageProp.isRead = YES;
        mappedMessageProp.isRemoved = NO;
        mappedMessageProp.messageType = @(AXMessageTypeProperty);
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}

- (void)addMessageNotifycation
{
    __weak AXChatViewController *blockSelf = self;

    [[NSNotificationCenter defaultCenter] addObserverForName:MessageCenterDidReceiveNewMessage object:nil queue:nil usingBlock: ^(NSNotification *note) {
        // 接受消息
        if ([note.object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)note.object;
            if (dict[[blockSelf checkFriendUid]]) {
                for (AXMappedMessage *mappedMessage in dict[[blockSelf checkFriendUid]]) {
                    blockSelf.lastMessage = mappedMessage;
                    NSMutableDictionary *dict = [blockSelf mapAXMappedMessage:mappedMessage];
                    if (dict) {
                        dict[@"messageSource"] = @(AXChatMessageSourceDestinationIncoming);
                        dict[AXCellIdentifyTag] = mappedMessage.identifier;
                        [blockSelf appendCellData:dict];
                        [blockSelf scrollToBottomAnimated:YES];
                    }
                }
            }
        }
    }];
}

- (void)sendSystemMessage:(AXMessageType)type
{
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = [self checkAccountType];
    mappedMessageProp.content = @"";
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = @(type);
    
    NSMutableDictionary *textData = [NSMutableDictionary dictionary];
    textData = [self mapAXMappedMessage:mappedMessageProp];
    if (textData) {
        textData[@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
        textData[AXCellIdentifyTag] = @"SystemMessage";
        [self appendCellData:textData];
    }
}

#pragma mark - DataSouce Method
- (NSString *)checkFriendUid
{
    if (self.uid) {
        return self.uid;
    }
    return @"";
}

- (NSString *)checkAccountType
{
    if (self.isBroker) {
        return @"2";
    } else {
        return @"1";
    }
}

- (NSMutableDictionary *)mapAXMappedMessage:(AXMappedMessage *)mappedMessage
{
    NSNumber *messageSource = @(AXChatMessageSourceDestinationIncoming);
    if (![mappedMessage.to isEqualToString:[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid]) {
        messageSource = @(AXChatMessageSourceDestinationOutPut);
    } else {
        messageSource = @(AXChatMessageSourceDestinationIncoming);
    }
    NSMutableDictionary *textData;

    switch ([mappedMessage.messageType integerValue]) {
        case AXMessageTypeText:
        {
             textData = [self configTextCellData:[NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeText), @"content":mappedMessage.content, @"messageSource":messageSource}]];
        }
            break;
        case AXMessageTypePic:
        {
            NSData *imgData = [NSData dataWithContentsOfFile:mappedMessage.thumbnailImgPath];
            if (!imgData) {
                return nil;
            }
            UIImage *img = [UIImage imageWithData:imgData];
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypePic), @"content":img, @"messageSource":messageSource}];
        }
            break;
            
        case AXMessageTypeProperty:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeProperty),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        
        case AXMessageTypePublicCard:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypePublicCard),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
            
        case AXMessageTypeSystemTime:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSystemTime),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
            
        case AXMessageTypeSystemForbid:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSystemForbid),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];

        }
            break;
        case AXMessageTypeSettingNotifycation:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSettingNotifycation),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationIncoming)}];
        }
            break;
            
        case AXMessageTypeAddNuckName:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeAddNuckName),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeAddNote:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeAddNote),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeSendProperty:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSendProperty),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeSafeMessage:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSafeMessage),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        default:
            break;
    }
    
    if (mappedMessage.identifier) {
        textData[AXCellIdentifyTag] = mappedMessage.identifier;
    }
    if (mappedMessage.sendStatus) {
        textData[@"status"] = mappedMessage.sendStatus;
    }

    return textData;
}

- (void)axAddCellData:(NSDictionary *)msgData
{
    [self.cellData addObject:msgData];
    [self.identifierData addObject:msgData[AXCellIdentifyTag]];
    [self.myTableView reloadInputViews];
    [self scrollToBottomAnimated:YES];
}

- (void)appendCellData:(NSDictionary *)msgData
{
    [self.myTableView beginUpdates];
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationBottom;
    if ([self.identifierData containsObject:msgData[AXCellIdentifyTag]]) {
        NSInteger row = [self.identifierData indexOfObject:msgData[AXCellIdentifyTag]];
        [self.identifierData removeObjectAtIndex:row];
        [self.cellData removeObjectAtIndex:row];
        [self.myTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
        insertAnimation = UITableViewRowAnimationNone;
    }
    [self.cellData addObject:msgData];
    [self.identifierData addObject:msgData[AXCellIdentifyTag]];
    
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:[self.cellData count] - 1 inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:insertAnimation];
    [self.myTableView endUpdates];
}

- (void)insertCellData:(NSDictionary *)msgData atIndex:(NSUInteger)index
{
    [self.cellData insertObject:msgData atIndex:index];
    [self.identifierData insertObject:msgData[AXCellIdentifyTag] atIndex:index];
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:index inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.myTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

#pragma mark - SSPullToRefresh
- (void)addPullToRefresh
{
    self.pullToRefreshView = [[AXPullToRefreshView alloc] initWithScrollView:self.myTableView delegate:self];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = (self.cellData)[[indexPath row]];
    if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeProperty)]) {
        // 房源
        return 105 + 20;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeText)]) {
        CGSize sz = [dic[@"mas"] sizeConstrainedToSize:CGSizeMake(kLabelWidth, CGFLOAT_MAX)];
        CGFloat rowHeight = sz.height + 2*kLabelVMargin + 20;
        return rowHeight;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypePic)]) {
        if ([AXChatMessageImageCell sizeOFImg:dic[@"content"]].size.height < 30.0f) {
            return 65.0f;
        }
        return [AXChatMessageImageCell sizeOFImg:dic[@"content"]].size.height + 35.0f;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)]) {
        return 25;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypePublicCard)]) {
        return 290 + 40;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemForbid)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeAddNuckName)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSettingNotifycation)]) {
        return 60;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeAddNote)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSendProperty)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSafeMessage)]) {
        return 60;
    } else {
        return 70;
    }
}

#pragma mark - AJKChatMessageTextCell
- (NSMutableDictionary *)configTextCellData:(NSMutableDictionary *)textData
{
    CGFloat maxWidth = 0;
    CGFloat maxHeight = 0;
    CGSize strSize;
    NSMutableAttributedString* mas = [self configAttributedString:textData[@"content"]];
    strSize = [textData[@"content"] rtSizeWithFont:[UIFont systemFontOfSize:16]];
    if (strSize.width > kLabelWidth) {
        maxWidth = kLabelWidth;
        CGSize sz = [mas sizeConstrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)];
        maxHeight = sz.height;
    } else {
        maxWidth = strSize.width;
        maxHeight = strSize.height;
    }
    textData[@"mas"] = mas;
    textData[@"rowHeight"] = [NSString stringWithFormat:@"%f", maxHeight];
    textData[@"rowWidth"] = [NSString stringWithFormat:@"%f", maxWidth];
    return textData;
}

- (NSMutableAttributedString *)configAttributedString:(NSString *)text
{
    NSMutableAttributedString* mas = [NSMutableAttributedString attributedStringWithString:text];
    [mas setFont:[UIFont systemFontOfSize:16]];
    [mas setTextColor:[UIColor blackColor]];
    [mas setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
    [OHASBasicMarkupParser processMarkupInAttributedString:mas];
    return mas;
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((self.cellData)[indexPath.row] && [(self.cellData)[indexPath.row][@"messageType"] isEqualToNumber:@(AXMessageTypePic)]) {
        AXBigIMGSViewController *controller = [[AXBigIMGSViewController alloc] init];
        controller.img = (self.cellData)[indexPath.row][@"content"];
        [self.navigationController pushViewController:controller animated:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = (self.cellData)[[indexPath row]];
    
    AXChatBaseCell *cell = [AXCellFactory cellForTableView:tableView atIndexPath:indexPath withObject:dic withIdentity:[NSString stringWithFormat:@"AXChatCell%@", dic[@"messageType"]]];
    [UIView setAnimationsEnabled:NO];

    cell.delegate = self;
    cell.isBroker = self.isBroker;
    cell.messageSource = [self messageSource:dic];
    cell.messageStatus = AXMessageCenterSendMessageStatusSending;
    if ([dic[@"messageSource"] isEqualToNumber:@(AXChatMessageSourceDestinationOutPut)]) {
        [cell configAvatar:self.currentPerson];
    } else {
        [cell configAvatar:self.friendPerson];
    }
    [cell configWithData:dic];
    [cell configWithIndexPath:indexPath];
    [UIView setAnimationsEnabled:YES];

    return cell;
}

#pragma mark - AJKChatMessageSystemCellDelegate
- (void)didClickSystemButton:(AXMessageType)messageType {
    
}

- (AXChatMessageSourceDestination)messageSource:(NSDictionary *)dic
{
    if (dic[@"messageSource"] && [dic[@"messageSource"] isEqualToNumber:@(AXChatMessageSourceDestinationIncoming)]) {
        return AXChatMessageSourceDestinationIncoming;
    } else {
        return AXChatMessageSourceDestinationOutPut;
    }
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor axChatBGColor:self.isBroker]];
    
    UIButton *brokerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    brokerButton.frame = CGRectMake(0, 0, 44, 44);
    [brokerButton setImage:[UIImage imageNamed:@"xproject_dialogue_agentdetail.png"] forState:UIControlStateNormal];
    [brokerButton setImage:[UIImage imageNamed:@"xproject_dialogue_agentdetail_selected.png"] forState:UIControlStateHighlighted];
    [brokerButton addTarget:self action:@selector(goBrokerPage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItems = [[UIBarButtonItem alloc] initWithCustomView:brokerButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? -16.0f : -6.0f;
    [self.navigationItem setRightBarButtonItems:@[spacer, buttonItems]];

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AXWINDOWWHIDTH, AXWINDOWHEIGHT - AXInputBackViewHeight) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myTableView];
    
    self.keyboardControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.width, 10)];
    self.keyboardControl.backgroundColor = [UIColor clearColor];
    [self.keyboardControl addTarget:self action:@selector(didClickKeyboardControl) forControlEvents:UIControlEventTouchUpInside];
    self.keyboardControl.hidden = YES;
    [self.view addSubview:self.keyboardControl];
    
    
    self.moreBackView = [[UIView alloc] init];
    self.moreBackView.frame = CGRectMake(0, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXMoreBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);
    self.moreBackView.backgroundColor = [UIColor lightGrayColor];
    self.moreBackView.hidden = YES;
    [self.view addSubview:self.moreBackView];

    CGSize size = self.view.frame.size;
    CGFloat inputViewHeight = 49;
    UIPanGestureRecognizer *pan = self.myTableView.panGestureRecognizer;
    CGRect inputFrame = CGRectMake(0.0f,
                                   size.height - inputViewHeight,
                                   size.width,
                                   inputViewHeight);

    JSMessageInputView *inputView = [[JSMessageInputView alloc] initWithFrame:inputFrame
                                                                        style:JSMessageInputViewStyleFlat
                                                                     delegate:self
                                                         panGestureRecognizer:pan isBroker:self.isBroker];
    [self.view addSubview:inputView];
    self.messageInputView = inputView;
    [self.messageInputView.textView addObserver:self
                                 forKeyPath:@"contentSize"
                                    options:NSKeyValueObservingOptionNew
                                    context:nil];

    if (!self.isBroker) {
        inputView.sendButton.enabled = NO;
        [inputView.sendButton addTarget:self
                                 action:@selector(sendPressed:)
                       forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBut.frame = CGRectMake(270.0f + 12.0f, 12.0f, 20.0f, 20.0f);
        [self.sendBut addTarget:self action:@selector(didMoreBackView:) forControlEvents:UIControlEventTouchUpInside];
        [self.sendBut setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_add_more.png"] forState:UIControlStateNormal];
        [self.sendBut setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_add_more.png"] forState:UIControlStateHighlighted];
        [self.messageInputView addSubview:self.sendBut];
    }
    
    UIButton *pickIMG = [UIButton buttonWithType:UIButtonTypeCustom];
    pickIMG.backgroundColor = [UIColor grayColor];
    [pickIMG setTitle:@"相册" forState:UIControlStateNormal];
    pickIMG.frame = CGRectMake(10, 78, 60, 60);
    [pickIMG addTarget:self action:@selector(pickIMG:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickIMG];
    
    UIButton *takePic = [UIButton buttonWithType:UIButtonTypeCustom];
    takePic.backgroundColor = [UIColor grayColor];
    [takePic setTitle:@"拍照" forState:UIControlStateNormal];
    takePic.frame = CGRectMake(90, 78, 60, 60);
    [takePic addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:takePic];

    UIButton *pickAJK = [UIButton buttonWithType:UIButtonTypeCustom];
    pickAJK.backgroundColor = [UIColor grayColor];
    [pickAJK setTitle:@"二手房" forState:UIControlStateNormal];
    pickAJK.frame = CGRectMake(170, 78, 60, 60);
    [pickAJK addTarget:self action:@selector(pickAJK:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickAJK];
    
    UIButton *pickHZ = [UIButton buttonWithType:UIButtonTypeCustom];
    pickHZ.backgroundColor = [UIColor grayColor];
    [pickHZ setTitle:@"租房" forState:UIControlStateNormal];
    pickHZ.frame = CGRectMake(250, 78, 60, 60);
    [pickHZ addTarget:self action:@selector(pickHZ:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickHZ];
    
}

- (void)pickIMG:(id)sender {
    AXELCImagePickerController *elcPicker = [[AXELCImagePickerController alloc] init];
    
    elcPicker.maximumImagesCount = 5; //(maxCount - self.roomImageArray.count);
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)takePic:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];

}

- (void)pickAJK:(id)sender {
    
//    NSDictionary *roomSource = @{@"title": @"中房二期花园，地理位置好",@"price":@"12000",@"roomType":@"3房两厅",@"area":@"200",@"floor":@"13/14",@"year":@"2005",@"messageType":[NSNumber numberWithInteger:AXMessageTypeProperty],@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming]};
//    [self.cellData addObject:roomSource];
//    [self reloadMytableView];
}

- (void)pickHZ:(id)sender {
//    NSDictionary *roomSource = @{@"title": @"中房二期花园，地理位置好",@"price":@"12000",@"roomType":@"3房两厅",@"area":@"200",@"floor":@"13/14",@"year":@"2005",@"messageType":[NSNumber numberWithInteger:AXMessageTypeProperty],@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]};
//    [self.cellData addObject:roomSource];
//    [self reloadMytableView];
    
}

- (void)sendMessage:(id)sender {
    if ([self.messageInputView.textView.text isEqualToString:@""]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发空消息" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [view show];
        return;
    }
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = [self checkAccountType];
    mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = @(AXMessageTypeText);
        
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage willSendMessage:self.finishSendMessageBlock];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

#pragma mark - NSNotificationCenter UIMenu
- (void)willHideEditMenu:(NSNotification *)notification
{
    if (self.selectedCell) {
        if (((AXChatMessageRootCell *)self.selectedCell).messageSource == AXChatMessageSourceDestinationIncoming) {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        } else {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        }
    }
}

- (void)willShowEditMenu:(NSNotification *)notification
{
    if (self.selectedCell) {
        if (((AXChatMessageRootCell *)self.selectedCell).messageSource == AXChatMessageSourceDestinationIncoming) {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:YES] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        } else {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:YES] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        }
    }
}

- (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(UIFont *)fontSize {
    return [string rtSizeWithFont:fontSize constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:NSLineBreakByCharWrapping];
}

#pragma mark - SSPullToRefreshViewDelegate
- (void)pullToRefreshViewDidStartLoading:(AXPullToRefreshView *)view {
    if (!self.lastMessage) {
#warning TODO floyd 判断是否有历史消息
        return;
    }
    [self.pullToRefreshView startLoading];
    [self refresh];
}

- (void)refresh {
    [self.pullToRefreshView finishLoading];
}

- (void)pullToRefreshViewDidFinishLoading:(AXPullToRefreshView *)view
{
    __weak AXChatViewController *blockSelf = self;

    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:self.lastMessage pageSize:AXMessagePageSize callBack:^(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        if ([chatList count] > 0) {
            blockSelf.lastMessage = chatList[0];
            NSInteger num = 0;
            CGFloat cellHeight = 0;
            CGPoint newContentOffset = blockSelf.myTableView.contentOffset;
            NSMutableArray *newIndexPaths = [NSMutableArray array];
            
            for (AXMappedMessage *mappedMessage in chatList) {
                NSDictionary *dict = [blockSelf mapAXMappedMessage:mappedMessage];
                if (dict) {
                    [blockSelf.cellData insertObject:dict atIndex:num];
                    [blockSelf.identifierData insertObject:mappedMessage.identifier atIndex:num];
                    cellHeight += [blockSelf tableView:blockSelf.myTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:0 inSection:0];
                    [insertIndexPaths addObject:newPath];
                    num++;
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:num inSection:0]];
                }
            }
            [blockSelf.myTableView reloadData];
            for (NSIndexPath *indexPath in newIndexPaths) {
                newContentOffset.y += [blockSelf tableView:blockSelf.myTableView heightForRowAtIndexPath:indexPath];
            }
//            newContentOffset.y -= 30;
            DLog(@"newContentOffset.y:%f", newContentOffset.y);
            [blockSelf.myTableView setContentOffset:newContentOffset animated:NO];

        }
    }];

}
#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(AXELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    if ([info count] == 0) {
        return;
    }
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    for (NSDictionary *dict in info) {
        
        UIImage *image = dict[UIImagePickerControllerOriginalImage];
        CGSize size = image.size;
        NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
        NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
        NSString *url = [AXPhotoManager getLibrary:path];
        
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = [self checkAccountType];
        //        mappedMessage.content = self.messageInputView.textView.text;
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = @(AXMessageTypePic);
        mappedMessage.imgUrl = url;
        [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(AXELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CGSize size = image.size;
    NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
    NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
    NSString *url = [AXPhotoManager getLibrary:path];
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = [self checkAccountType];
    //        mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = @(AXMessageTypePic);
    mappedMessage.imgUrl = url;
    [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
    
    //        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
    //        NSDictionary *imageData = @{@"messageType":@"image",@"content":image,@"messageSource":@"incoming"};
    //        [self.cellData addObject:imageData];
    //        [self reloadMytableView];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - AXChatMessageRootCellDelegate
- (void)deleteAXCell:(AXChatMessageRootCell *)axCell
{
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:axCell];
    [self.cellData removeObjectAtIndex:indexPath.row];
    [self.identifierData removeObjectAtIndex:indexPath.row];
    [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    [[AXChatMessageCenter defaultMessageCenter] deleteMessageByIdentifier:axCell.identifyString];
}

- (void)didOpenAXWebView:(NSString *)url
{
    AXChatWebViewController *chatWebViewController = [[AXChatWebViewController alloc] init];
    chatWebViewController.webUrl = url;
    [self.navigationController pushViewController:chatWebViewController animated:YES];
}

- (void)didMessageRetry:(AXChatMessageRootCell *)axCell
{
    [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
}

#pragma mark - Layout message input view

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    
    BOOL isShrinking = textView.contentSize.height < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textView.contentSize.height - self.previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             [self setTableViewInsetsWithBottomValue:self.myTableView.contentInset.bottom + changeInHeight];
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if (!isShrinking) {
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textView.contentSize.height, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, textView.contentSize.height - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.myTableView.contentInset = insets;
    self.myTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.messageInputView.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    self.moreBackView.hidden = YES;
    [self keyboardWillShowHide:notification];
    self.keyboardControl.hidden = NO;
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    if (!self.moreBackView.hidden) {
        self.preNotification = notification;
        return;
    }
    [self keyboardWillShowHide:notification];
    self.keyboardControl.hidden = YES;
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
    CGRect inputViewFrame = self.messageInputView.frame;
    CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
    
    // for ipad modal form presentations
    CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
    if (inputViewFrameY > messageViewFrameBottom)
        inputViewFrameY = messageViewFrameBottom;
    
    self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                             inputViewFrameY,
                                             inputViewFrame.size.width,
                                             inputViewFrame.size.height);
    
    [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
     - self.messageInputView.frame.origin.y
     - inputViewFrame.size.height ];
    self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                            - self.messageInputView.frame.origin.y
                                            - inputViewFrame.size.height);
    [UIView commitAnimations];
}

#pragma mark - Dismissive text view delegate

- (void)keyboardDidScrollToPoint:(CGPoint)point
{
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.messageInputView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)point
{
    if (!self.tabBarController.tabBar.hidden){
        return;
    }
	
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

#pragma mark - Utilities

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

#pragma mark - Actions

- (void)didClickKeyboardControl
{
    if (self.moreBackView && !self.moreBackView.hidden) {
        self.moreBackView.hidden = YES;
        if (self.preNotification) {
            [self keyboardWillShowHide:self.preNotification];
        }
    } else {
        [self.messageInputView.textView resignFirstResponder];
    }
}

- (void)didMoreBackView:(UIButton *)sender
{
    self.moreBackView.hidden = NO;
    [self.messageInputView.textView resignFirstResponder];
}

- (void)sendPressed:(UIButton *)sender
{
    [self sendMessage:self.messageInputView.textView];
}

- (void)finishSend
{
    self.messageInputView.textView.text = @"";
    [self textViewDidChange:self.messageInputView.textView];
    [self.myTableView reloadData];
}

- (void)goBrokerPage:(id)sender
{
//    AJKBrokerInfoViewController *controller = [[AJKBrokerInfoViewController alloc] init];
//#warning TODO chat UID
//    [self.navigationController pushRTViewController:controller animated:YES];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.isUserScrolling = YES;
    [self.messageInputView.textView resignFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isUserScrolling = NO;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.myTableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:animated];
    }
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if (!self.previousTextViewContentHeight) {
		self.previousTextViewContentHeight = textView.contentSize.height;
    }
    [self scrollToBottomAnimated:YES];
    if (![self.messageInputView.textView.text isEqualToString:@""]) {
        self.messageInputView.sendButton.enabled = YES;
    } else {
        self.messageInputView.sendButton.enabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self sendMessage:textView.text];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (!self.isBroker) {
        self.messageInputView.sendButton.enabled = ([[textView.text js_stringByTrimingWhitespace] length] > 0);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    self.messageInputView.sendButton.enabled = NO;
}

@end
