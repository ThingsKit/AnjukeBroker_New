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

#import "AXPhotoManager.h"
#import "AXCellFactory.h"
#import "AXChatContentValidator.h"
#import "AXUtil_UI.h"

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
static CGFloat const AXScrollContentOffsetY = 250;

static NSString * const AXChatJsonVersion = @"1";

@interface AXChatViewController ()<UITableViewDelegate, UITableViewDataSource, OHAttributedLabelDelegate, AXPullToRefreshViewDelegate, UIAlertViewDelegate, AXChatBaseCellDelegate, JSDismissiveTextViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITableViewCell *selectedCell;
@property (nonatomic) BOOL isMenuVisible;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) CGFloat tableViewBottom;
@property (nonatomic) BOOL hasMore;

@property (nonatomic, strong) AXPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) AXMappedMessage *lastMessage;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIControl *keyboardControl;
@property (nonatomic, strong) AXChatContentValidator *contentValidator;

@property (nonatomic, strong) AXMappedPerson *currentPerson;


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
        _needSendProp = NO;
        _hasMore = NO;
        _contentValidator = [[AXChatContentValidator alloc] init];
    }
    return self;
}

- (void)dealloc
{
    DLog(@"AXChatViewController dealloc");
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
    
    // init Data
    self.conversationListItem = [[AXChatMessageCenter defaultMessageCenter] fetchConversationListItemWithFriendUID:[self checkFriendUid]];
    self.currentPerson = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson];
    self.friendPerson = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[self checkFriendUid]];
    self.cellDict = [NSMutableDictionary dictionary];
    self.identifierData = [NSMutableArray array];
    
    // init UI
    [self initUI];
    
    [self fetchLastChatList];
    
    [self initBlock];
    
    [self initPullToRefresh];
}

#pragma mark - Private Method


- (void)initUI {
    self.title = self.currentPerson.name;
    [self.view setBackgroundColor:[UIColor axChatBGColor:self.isBroker]];
    
    NSInteger viewHeight = 20;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        viewHeight = 0;
    }
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AXWINDOWWHIDTH, AXWINDOWHEIGHT - AXInputBackViewHeight - viewHeight) style:UITableViewStylePlain];
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
    self.moreBackView.backgroundColor = [UIColor axChatBGColor:self.isBroker];
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
//    pickIMG.backgroundColor = [UIColor grayColor];
//    [pickIMG setTitle:@"相册" forState:UIControlStateNormal];
    pickIMG.frame = CGRectMake(17.0f, 16.0f, 46, 46);
    [pickIMG setImage:[UIImage imageNamed:@"anjuke_icon_add_pic4.png"] forState:UIControlStateNormal];
    [pickIMG addTarget:self action:@selector(pickIMG:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickIMG];
    CGRect imgRect = pickIMG.frame;
    UILabel *imgLab = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    imgLab.backgroundColor = [UIColor clearColor];
    imgLab.font = [UIFont systemFontOfSize:14];
    imgLab.text = @"相册";
    imgLab.textAlignment = NSTextAlignmentCenter;
    imgLab.textColor = [UIColor axChatSystemBGColor:self.isBroker];
    [self.moreBackView addSubview:imgLab];
    
    
    UIButton *takePic = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePic setImage:[UIImage imageNamed:@"anjuke_icon_add_takephoto4.png"] forState:UIControlStateNormal];
//    takePic.backgroundColor = [UIColor grayColor];
//    [takePic setTitle:@"拍照" forState:UIControlStateNormal];
    takePic.frame = CGRectMake(97.0f, 16.0f, 46, 46);
    [takePic addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:takePic];
    UILabel *picLab = [[UILabel alloc] initWithFrame:CGRectMake(97.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    picLab.backgroundColor = [UIColor clearColor];
    picLab.font = [UIFont systemFontOfSize:14];
    picLab.text = @"拍照";
    picLab.textAlignment = NSTextAlignmentCenter;
    picLab.textColor = [UIColor axChatSystemBGColor:self.isBroker];
    [self.moreBackView addSubview:picLab];
    
    UIButton *pickAJK = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickAJK setImage:[UIImage imageNamed:@"anjuke_icon_add_esf.png"] forState:UIControlStateNormal];
//    pickAJK.backgroundColor = [UIColor grayColor];
//    [pickAJK setTitle:@"二手房" forState:UIControlStateNormal];
    pickAJK.frame = CGRectMake(177.0f, 16.0f, 46, 46);
    [pickAJK addTarget:self action:@selector(pickAJK:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickAJK];
    UILabel *ajkLab = [[UILabel alloc] initWithFrame:CGRectMake(177.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    ajkLab.backgroundColor = [UIColor clearColor];
    ajkLab.font = [UIFont systemFontOfSize:14];
    ajkLab.text = @"二手房";
    ajkLab.textAlignment = NSTextAlignmentCenter;
    ajkLab.textColor = [UIColor axChatSystemBGColor:self.isBroker];
    [self.moreBackView addSubview:ajkLab];
    
    UIButton *pickHZ = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickHZ setImage:[UIImage imageNamed:@"anjuke_icon_add_zf.png"] forState:UIControlStateNormal];
//    pickHZ.backgroundColor = [UIColor grayColor];
//    [pickHZ setTitle:@"租房" forState:UIControlStateNormal];
    pickHZ.frame = CGRectMake(257.0f, 16.0f, 46, 46);
    [pickHZ addTarget:self action:@selector(pickHZ:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickHZ];
    UILabel *hzLab = [[UILabel alloc] initWithFrame:CGRectMake(257.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    hzLab.backgroundColor = [UIColor clearColor];
    hzLab.font = [UIFont systemFontOfSize:14];
    hzLab.text = @"租房";
    hzLab.textAlignment = NSTextAlignmentCenter;
    hzLab.textColor = [UIColor axChatSystemBGColor:self.isBroker];
    [self.moreBackView addSubview:hzLab];
    
}

- (void)initBlock
{
    __weak AXChatViewController *blockSelf = self;
    // 发消息的block
    self.finishReSendMessageBlock = ^ (AXMappedMessage *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorCode) {
        NSMutableDictionary *textData = [NSMutableDictionary dictionary];
        textData = [blockSelf mapAXMappedMessage:message];
        if (textData) {
            if (status == AXMessageCenterSendMessageStatusSending) {
                textData[@"status"] = @(AXMessageCenterSendMessageStatusSending);
                textData[AXCellIdentifyTag] = message.identifier;
                [blockSelf appendCellData:textData];
            } else if (status == AXMessageCenterSendMessageStatusFailed) {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusFailed);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            if (errorCode == AXMessageCenterSendMessageErrorTypeCodeNotFriend && blockSelf.isBroker) {
                [blockSelf sendSystemMessage:AXMessageTypeSystemForbid];
            }
        }
    };
    
    self.finishSendMessageBlock = ^ (AXMappedMessage *message, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorCode) {
        NSMutableDictionary *textData = [NSMutableDictionary dictionary];
        textData = [blockSelf mapAXMappedMessage:message];
        if (textData) {
            if (status == AXMessageCenterSendMessageStatusSending) {
                textData[@"status"] = @(AXMessageCenterSendMessageStatusSending);
                textData[AXCellIdentifyTag] = message.identifier;
                [blockSelf axAddCellData:textData];
            } else if (status == AXMessageCenterSendMessageStatusFailed) {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusFailed);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            if (errorCode == AXMessageCenterSendMessageErrorTypeCodeNotFriend && blockSelf.isBroker) {
                [blockSelf sendSystemMessage:AXMessageTypeSystemForbid];
            }
        }
    };
}

- (void)fetchLastChatList
{
    AXMappedMessage *lastMessage = [[AXMappedMessage alloc] init];
    lastMessage.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];
    lastMessage.from = self.currentPerson.uid;
    lastMessage.to  = [self checkFriendUid];
    
    __weak AXChatViewController *blockSelf = self;
    
    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:lastMessage pageSize:AXMessagePageSize callBack:^(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        blockSelf.hasMore = [chatList[@"hasMore"] boolValue];
        if (blockSelf.hasMore) {
            self.pullToRefreshView.delegate = self;
        } else {
            self.pullToRefreshView.delegate = nil;
        }
        NSArray *chatArray = chatList[@"messages"];
        if ([chatArray isKindOfClass:[NSArray class]] && [chatArray count] > 0) {
            blockSelf.lastMessage = chatArray[0];
            for (AXMappedMessage *mappedMessage in chatArray) {
                NSMutableDictionary *dict = [blockSelf mapAXMappedMessage:mappedMessage];
                if (!dict) {
                    continue;
                }
                if ([mappedMessage.from isEqualToString:[blockSelf checkFriendUid]]) {
                    dict[@"messageSource"] = @(AXChatMessageSourceDestinationIncoming);
                }
                
                [blockSelf.identifierData addObject:mappedMessage.identifier];
                blockSelf.cellDict[mappedMessage.identifier] = dict;
            }
            [blockSelf.myTableView reloadData];
            [blockSelf scrollToBottomAnimated:YES];
        } else {
            if (blockSelf.propDict && [blockSelf.identifierData count] == 0) {
                [blockSelf sendSystemMessage:AXMessageTypeSendProperty];
            }
        }
        
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            [blockSelf sendSystemMessage:AXMessageTypeSettingNotifycation];
        }
        
        [blockSelf addMessageNotifycation];
        [self.myTableView reloadData];
    }];
}

- (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(UIFont *)fontSize {
    return [string rtSizeWithFont:fontSize constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:NSLineBreakByCharWrapping];
}

- (void)sendPropMessage
{
    // 如果第一次发消息，发送房源信息
    if (self.propDict && self.needSendProp) {
        NSMutableDictionary *propDict = [NSMutableDictionary dictionaryWithDictionary:self.propDict];
        propDict[@"jsonVersion"] = AXChatJsonVersion;
        self.needSendProp = NO;
        AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
        mappedMessageProp.accountType = [self checkAccountType];
        mappedMessageProp.content = [propDict JSONRepresentation];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStatusDidChangeNotification:) name:MessageCenterConnectionStatusNotication object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:MessageCenterDidReceiveNewMessage object:nil];
}


#pragma mark - Public Method
- (BOOL)checkUserLogin
{
    return YES;
}

- (void)sendSystemMessage:(AXMessageType)type
{
    self.needSendProp = YES;
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
        NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
        textData[@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
        textData[AXCellIdentifyTag] = [NSString stringWithFormat:@"SystemMessage%@", identifier];
        [self appendCellData:textData];
        [self scrollToBottomAnimated:YES];
    }
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

#pragma mark - Public Method
- (void)reloadUnReadNum:(NSInteger)num
{
    // do nothing
}

- (void)sendMessageAppLog
{
    // do nothing
}

- (void)clickRightNavButtonAppLog
{
    // do nothing
}

- (void)clickLeftAvatarAppLog
{
    // do nothing
}

- (void)clickInputViewAppLog
{
    // do nothing
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
            NSData *imgData = nil;
            if (self.isBroker) {
                imgData = [NSData dataWithContentsOfFile:mappedMessage.imgPath];
            }else {
                imgData = [NSData dataWithContentsOfFile:mappedMessage.thumbnailImgPath];
            }
            
            if (!imgData) {
                return nil;
            }
            UIImage *img = [UIImage imageWithData:imgData];
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypePic), @"content":img, @"messageSource":messageSource, @"identifier":mappedMessage.identifier}];
        }
            break;
            
        case AXMessageTypeProperty:
        {
            if (![self.contentValidator checkPropertyCard:mappedMessage.content]) {
                return nil;
            }
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeProperty),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        
        case AXMessageTypePublicCard:
        {
            if (![self.contentValidator checkPublicCard:mappedMessage.content]) {
                return nil;
            }
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
    [self.identifierData addObject:msgData[AXCellIdentifyTag]];
    self.cellDict[msgData[AXCellIdentifyTag]] = msgData;
    [self.myTableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)appendCellData:(NSDictionary *)msgData
{
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationBottom;
    if ([self.identifierData containsObject:msgData[AXCellIdentifyTag]]) {
        NSInteger row = [self.identifierData indexOfObject:msgData[AXCellIdentifyTag]];
        [self.identifierData removeObjectAtIndex:row];
        [self.cellDict removeObjectForKey:msgData[AXCellIdentifyTag]];
        [self.myTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
        insertAnimation = UITableViewRowAnimationNone;
    }
    [self.identifierData addObject:msgData[AXCellIdentifyTag]];
    self.cellDict[msgData[AXCellIdentifyTag]] = msgData;
    
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:[self.identifierData count] - 1 inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:insertAnimation];
}

- (void)insertCellData:(NSDictionary *)msgData atIndex:(NSUInteger)index
{
    [self.identifierData insertObject:msgData[AXCellIdentifyTag] atIndex:index];
    self.cellDict[msgData[AXCellIdentifyTag]] = msgData;
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:index inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.myTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
}

#pragma mark - SSPullToRefresh
- (void)initPullToRefresh
{
    self.pullToRefreshView = [[AXPullToRefreshView alloc] initWithScrollView:self.myTableView delegate:self];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.identifierData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = (self.identifierData)[[indexPath row]];
    NSDictionary *dic = self.cellDict[identifier];
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

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = (self.identifierData)[[indexPath row]];
    NSDictionary *dic = self.cellDict[identifier];

    if ([dic[@"messageType"] isEqualToNumber:@(AXMessageTypePic)]) {
        AXBigIMGSViewController *controller = [[AXBigIMGSViewController alloc] init];
        controller.img = dic[@"content"];
        [self.navigationController pushViewController:controller animated:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = (self.identifierData)[[indexPath row]];
    NSDictionary *dic = self.cellDict[identifier];
    
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

- (void)afterSendMessage
{
    
}

#pragma mark - NSNotificationCenter
- (void)didReceiveNewMessage:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)notification.object;
        
        if (notification.userInfo[@"unreadCount"] && [notification.userInfo[@"unreadCount"] integerValue] > 0) {
            [self reloadUnReadNum:[notification.userInfo[@"unreadCount"] integerValue]];
        }
        
        if (dict[[self checkFriendUid]]) {
            for (AXMappedMessage *mappedMessage in dict[[self checkFriendUid]]) {
                self.lastMessage = mappedMessage;
                NSMutableDictionary *dict = [self mapAXMappedMessage:mappedMessage];
                if (dict) {
                    dict[@"messageSource"] = @(AXChatMessageSourceDestinationIncoming);
                    dict[AXCellIdentifyTag] = mappedMessage.identifier;
                    [self appendCellData:dict];
                    // 判断是否需要滑动到底部
                    if (AXScrollContentOffsetY + self.myTableView.contentOffset.y + self.myTableView.height < self.myTableView.contentSize.height) {
                        [self scrollToBottomAnimated:YES];
                    }
                }
            }
        }
    }
}

- (void)connectionStatusDidChangeNotification:(NSNotification *)notification
{
    if ([notification.userInfo[@"status"] integerValue] == AIFMessageCenterStatusUserLoginOut) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

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


#pragma mark - SSPullToRefreshViewDelegate
- (void)pullToRefreshViewDidStartLoading:(AXPullToRefreshView *)view {
    if (!self.lastMessage || !self.hasMore) {
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

    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:self.lastMessage pageSize:AXMessagePageSize callBack:^(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        blockSelf.hasMore = [chatList[@"hasMore"] boolValue];
        if (blockSelf.hasMore) {
            self.pullToRefreshView.delegate = self;
        } else {
            self.pullToRefreshView.delegate = nil;
        }
        NSArray *chatArray = chatList[@"messages"];
        if ([chatArray isKindOfClass:[NSArray class]] && [chatArray count] > 0) {
            blockSelf.lastMessage = chatArray[0];
            NSInteger num = 0;
            CGFloat cellHeight = 0;
            CGPoint newContentOffset = blockSelf.myTableView.contentOffset;
            NSMutableArray *newIndexPaths = [NSMutableArray array];
            
            for (AXMappedMessage *mappedMessage in chatArray) {
                NSDictionary *dict = [blockSelf mapAXMappedMessage:mappedMessage];
                if (dict) {
                    [blockSelf.identifierData insertObject:mappedMessage.identifier atIndex:num];
                    blockSelf.cellDict[mappedMessage.identifier] = dict;
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
    UIImage *newSizeImage = nil;
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //压缩图片
    if (image.size.width > 600 || image.size.height > 600) {
        CGSize coreSize;
        if (image.size.width > image.size.height) {
            coreSize = CGSizeMake(600, 600*(image.size.height /image.size.width));
        }
        else if (image.size.width < image.size.height){
            coreSize = CGSizeMake(600 *(image.size.width /image.size.height), 600);
        }
        else {
            coreSize = CGSizeMake(600, 600);
        }
        
        UIGraphicsBeginImageContext(coreSize);
        [image drawInRect:[AXUtil_UI frameSize:image.size inSize:coreSize]];
        newSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    CGSize size = newSizeImage.size;
    NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
    NSString *path = [AXPhotoManager saveImageFile:newSizeImage toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
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
    NSInteger preRow = indexPath.row - 1;
    NSInteger nextRow = indexPath.row + 1;
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:preRow inSection:0];
    NSArray *indexPaths = @[indexPath];
    NSInteger index = 0;
    // 判断是否需要删除系统时间cell
    if (preRow >= 0 && nextRow < [self.identifierData count]) {
        NSString *preIdentifier = self.identifierData[preRow];
        NSString *nextIdentifier = self.identifierData[preRow];
        NSDictionary *preData = self.cellDict[preIdentifier];
        NSDictionary *nextData = self.cellDict[nextIdentifier];
        if ([preData[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)] &&
            [nextData[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)]) {
            indexPaths = @[preIndexPath, indexPath];
            [self.cellDict removeObjectForKey:preIdentifier];
            [self.identifierData removeObjectAtIndex:preRow];
            index = 1;
            [[AXChatMessageCenter defaultMessageCenter] deleteMessageByIdentifier:preData[AXCellIdentifyTag]];
        }
    }
    NSString *identifier = self.identifierData[indexPath.row - index];
    [self.cellDict removeObjectForKey:identifier];
    [self.identifierData removeObjectAtIndex:indexPath.row - index];

    [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
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
    [self scrollToBottomAnimated:YES];
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
        }else {
            if (self.isBroker) {
                //            CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.27f];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationBeginsFromCurrentState:YES];
                CGFloat keyboardY = AXMoreBackViewHeight;
                CGRect inputViewFrame = self.messageInputView.frame;
                CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                
                // for ipad modal form presentations
                CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
                if (inputViewFrameY > messageViewFrameBottom)
                    inputViewFrameY = messageViewFrameBottom;
                
                self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                         AXWINDOWHEIGHT -AXNavBarHeight -AXStatuBarHeight - inputViewFrame.size.height,
                                                         inputViewFrame.size.width,
                                                         inputViewFrame.size.height);
                
                [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
                 - self.messageInputView.frame.origin.y
                 - inputViewFrame.size.height + 60];
                self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                                        - self.messageInputView.frame.origin.y
                                                        - inputViewFrame.size.height + 60);
                self.keyboardControl.hidden = YES;
                [UIView commitAnimations];
            }
        }
    } else {
        [self.messageInputView.textView resignFirstResponder];
    }
}


- (void)didMoreBackView:(UIButton *)sender
{
    CGRect moreRect = CGRectMake(0, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXMoreBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);
    self.moreBackView.frame = CGRectMake(moreRect.origin.x, moreRect.origin.y + AXMoreBackViewHeight, moreRect.size.width, moreRect.size.height);
    if (self.moreBackView.hidden) {//当more为消失状态时
        self.moreBackView.hidden = !self.moreBackView.hidden;
        [self.messageInputView.textView resignFirstResponder];
        
        [UIView animateWithDuration:0.270f animations:^{
            self.moreBackView.frame = moreRect;
            
            CGRect inputViewFrame = self.messageInputView.frame;
            CGFloat inputViewFrameY = AXWINDOWHEIGHT -AXNavBarHeight -AXStatuBarHeight - AXMoreBackViewHeight - inputViewFrame.size.height;
            self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                                    - AXMoreBackViewHeight
                                                    - inputViewFrame.size.height + 60);
            self.keyboardControl.hidden = NO;
            self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                     inputViewFrameY,
                                                     inputViewFrame.size.width,
                                                     inputViewFrame.size.height);
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - AXMoreBackViewHeight
             - inputViewFrame.size.height];
            [self scrollToBottomAnimated:YES];
        } completion:nil];
    }else {
        self.moreBackView.hidden = !self.moreBackView.hidden;
        [self.messageInputView.textView becomeFirstResponder];
    }
    
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
    [self afterSendMessage];
    [self sendPropMessage];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.isBroker) {
        // 检查用户是否登陆
        if (![self checkUserLogin]) {
            return NO;
        }
    }
    [self clickInputViewAppLog];
    return YES;
}

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
    NSString *text = [textView.text js_stringByTrimingWhitespace];
    NSData *data = [text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *asciiString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (!self.isBroker && [text length] > 0 && ![text isEqualToString:@""] && (![asciiString isEqualToString:@"\\ufffc"] || [asciiString length] == 0)) {
        self.messageInputView.sendButton.enabled = YES;
    } else {
        self.messageInputView.sendButton.enabled = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    self.messageInputView.sendButton.enabled = NO;
}

@end
