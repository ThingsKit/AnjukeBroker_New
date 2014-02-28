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

#import "AXBigIMGSViewController.h"
#import "AXChatWebViewController.h"

#import "AXPhotoManager.h"

//输入框和发送按钮栏的高度
static CGFloat const AXInputBackViewHeight = 51.701996f;
//键盘高度
static CGFloat const AXMoreBackViewHeight = 217.0f;

//输入框的宽度
static CGFloat const AXInputTextWidth = 260.0f;
static CGFloat const AXInputTextLeft = 12.0f;
static CGFloat const AXInputTextHeight = 30.0f;
static CGFloat const AXTextCellMoreHeight = 60.0f;

#ifdef DEBUG
static NSInteger const AXMessagePageSize = 5;
#else
static NSInteger const AXMessagePageSize = 15;
#endif

@interface AXChatViewController ()<UITableViewDelegate, UITableViewDataSource, OHAttributedLabelDelegate, AXPullToRefreshViewDelegate, UIAlertViewDelegate, AXChatMessageRootCellDelegate, JSDismissiveTextViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITableViewCell *selectedCell;
@property (nonatomic) BOOL isMenuVisible;

@property (nonatomic, strong) AXPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) AXMappedMessage *lastMessage;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIControl *keyboardControl;

@property (nonatomic, strong) AXMappedPerson *currentPerson;
@property (nonatomic, strong) AXMappedPerson *friendPerson;

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
    [self scrollToBottomAnimated:NO];
    
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
    if (self.conversationListItem) {
        if (!self.previousTextViewContentHeight) {
            self.previousTextViewContentHeight = self.messageInputView.textView.contentSize.height;
        }
        self.messageInputView.textView.text = self.conversationListItem.draftContent;
    }

    [self scrollToBottomAnimated:YES];
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
#warning TODO 设置双方的头像
    self.currentPerson = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson];
    self.friendPerson = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[self checkFriendUid]];
    DLog(@"%@, %@, %@, %@", self.currentPerson.iconPath, self.currentPerson.iconUrl, self.friendPerson.iconPath, self.friendPerson.iconUrl);
    self.currentPerson.iconUrl = @"http://pic1.ajkimg.com/display/anjuke/87b74e3d0ca79ac40d7e8d8648c20c91/675x896x0x1/100x133.jpg";
    self.friendPerson.iconUrl = @"http://pic1.ajkimg.com/display/anjuke/1ea9949285cd5519008452853d7b813c/503x669x0x1/100x133.jpg";
    
    self.cellData = [NSMutableArray array];
    self.identifierData = [NSMutableArray array];
    AXMappedMessage *lastMessage = [[AXMappedMessage alloc] init];
    lastMessage.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];
    lastMessage.from = self.currentPerson.uid;
    lastMessage.to  = [self checkFriendUid];
    
    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:lastMessage pageSize:AXMessagePageSize callBack:^(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        if ([chatList count] > 0) {
            self.lastMessage = chatList[0];
            for (AXMappedMessage *mappedMessage in chatList) {
                NSMutableDictionary *dict = [self mapAXMappedMessage:mappedMessage];
                if ([mappedMessage.from isEqualToString:[self checkFriendUid]]) {
                    dict[@"messageSource"] = [NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming];
                }
                
                [self.cellData addObject:dict];
                [self.identifierData addObject:mappedMessage.identifier];
            }
            [self.myTableView reloadData];
        }
        [self addMessageNotifycation];
    }];
    
    // 发消息的block
    @autoreleasepool {
        __weak AXChatViewController *blockSelf = self;

        self.finishSendMessageBlock = ^ (AXMappedMessage *message, AXMessageCenterSendMessageStatus status) {
        NSMutableDictionary *textData = [NSMutableDictionary dictionary];
            textData = [blockSelf mapAXMappedMessage:message];
            if (status == AXMessageCenterSendMessageStatusSending) {
                textData[@"status"] = [NSNumber numberWithInteger:AXMessageCenterSendMessageStatusSending];
                textData[AXCellIdentifyTag] = message.identifier;
                [blockSelf appendCellData:textData];
            } else if (status == AXMessageCenterSendMessageStatusFailed) {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellData[index][@"status"] = [NSNumber numberWithInteger:AXMessageCenterSendMessageStatusFailed];
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellData[index][@"status"] = [NSNumber numberWithInteger:AXMessageCenterSendMessageStatusSuccessful];
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        };
    }
    
    [self addPullToRefresh];
}

- (void)getNewMessage
{
    [self.messageInputView.textView resignFirstResponder];
}

- (void)addUserBtn
{
    AXMappedPerson *person = [[AXMappedPerson alloc] init];
    person.uid = self.messageInputView.textView.text;
    self.uid = self.messageInputView.textView.text;
    
    [[AXChatMessageCenter defaultMessageCenter] addFriendWithMyPhone:person block:^(BOOL isSuccess) {
        
    }];
    
}

- (void)sendNewMessage
{
    // 如果第一次发消息，发送房源信息
    if (self.propDict) {
        AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
        mappedMessageProp.accountType = @"1";
        mappedMessageProp.content = [self.propDict JSONRepresentation];
        mappedMessageProp.to = [self checkFriendUid];
        mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
        mappedMessageProp.isRead = YES;
        mappedMessageProp.isRemoved = NO;
        mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}

- (void)addMessageNotifycation
{
    [[NSNotificationCenter defaultCenter] addObserverForName:MessageCenterDidReceiveNewMessage object:nil queue:nil usingBlock: ^(NSNotification *note) {
        // 接受消息
        if ([note.object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)note.object;
            if (dict[[self checkFriendUid]]) {
                for (AXMappedMessage *mappedMessage in dict[[self checkFriendUid]]) {
                    self.lastMessage = mappedMessage;
                    NSMutableDictionary *dict = [self mapAXMappedMessage:mappedMessage];
                    dict[@"messageSource"] = [NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming];
                    dict[AXCellIdentifyTag] = mappedMessage.identifier;
                    [self appendCellData:dict];
                }
            }
        }
    }];
}

#pragma mark - DataSouce Method
- (NSString *)checkFriendUid
{
    if (self.uid) {
        return self.uid;
    }
    return @"";
}

- (NSMutableDictionary *)mapAXMappedMessage:(AXMappedMessage *)mappedMessage
{
    NSNumber *messageSource = [NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming];
    if (![mappedMessage.to isEqualToString:[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid]) {
        messageSource = [NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut];
    } else {
        messageSource = [NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming];
    }
    NSMutableDictionary *textData;

    switch ([mappedMessage.messageType integerValue]) {
        case AXMessageTypeText:
        {
             textData = [self configTextCellData:[NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeText], @"content":mappedMessage.content, @"messageSource":messageSource}]];
        }
            break;
        case AXMessageTypePic:
        {
            UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:mappedMessage.imgUrl]];
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypePic], @"content":img, @"messageSource":messageSource}];
        }
            break;
            
        case AXMessageTypeProperty:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeProperty],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];
        }
            break;
        
        case AXMessageTypePublicCard:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypePublicCard],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];
        }
            break;
            
        case AXMessageTypeSystemTime:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeSystemTime],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];
        }
            break;
            
        case AXMessageTypeSystemForbid:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeSystemForbid],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];

        }
            break;
        case AXMessageTypeSettingNotifycation:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeSettingNotifycation],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming]}];
        }
            break;
            
        case AXMessageTypeAddNuckName:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeAddNuckName],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];
        }
            break;
        case AXMessageTypeAddNote:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeAddNote],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];
        }
            break;
        case AXMessageTypeSendProperty:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeSendProperty],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];
        }
            break;
        case AXMessageTypeSafeMessage:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":[NSNumber numberWithInteger:AXMessageTypeSafeMessage],@"content":mappedMessage.content,@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]}];
        }
            break;
        default:
            break;
    }

    return textData;
}

- (void)appendCellData:(NSDictionary *)msgData
{
    [self.cellData addObject:msgData];
    [self.identifierData addObject:msgData[AXCellIdentifyTag]];
    
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:[self.cellData count] - 1 inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self scrollToBottomAnimated:YES];
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
    if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeProperty]]) {
        // 房源
        return 105 + 40;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeText]]) {
        CGSize sz = [dic[@"mas"] sizeConstrainedToSize:CGSizeMake(kLabelWidth, CGFLOAT_MAX)];
        CGFloat rowHeight = sz.height + 2*kLabelVMargin + 40;
        return rowHeight;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePic]]) {
        if ([AXChatMessageImageCell sizeOFImg:dic[@"content"]].size.height < 30.0f) {
            return 65.0f;
        }
        return [AXChatMessageImageCell sizeOFImg:dic[@"content"]].size.height+35.0f;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSystemTime]]) {
        return 35;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePublicCard]]) {
        return 290 + 40;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSystemForbid]]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeAddNuckName]]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSettingNotifycation]]) {
        return 60;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeAddNote]]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSendProperty]]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSafeMessage]]) {
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

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.myTableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cellData objectAtIndex:indexPath.row] && [[[self.cellData objectAtIndex:indexPath.row] objectForKey:@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePic]]) {
        AXBigIMGSViewController *controller = [[AXBigIMGSViewController alloc] init];
        controller.img = [[self.cellData objectAtIndex:indexPath.row] objectForKey:@"content"];
        [self.navigationController pushViewController:controller animated:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = (self.cellData)[[indexPath row]];
    if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeProperty]]) {
        static NSString *roomSourceIdentity = @"RoomSourceCell";
        AXChatMessageRoomSourceCell *roomSourceCell = [tableView dequeueReusableCellWithIdentifier:roomSourceIdentity];
        if (roomSourceCell == nil) {
            roomSourceCell = [[AXChatMessageRoomSourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:roomSourceIdentity];
            roomSourceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            roomSourceCell.delegate = self;
            roomSourceCell.isBroker = self.isBroker;
        }
        roomSourceCell.messageSource = [self messageSource:dic];
        if ([dic[@"messageSource"] isEqualToNumber:[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]]) {
            [roomSourceCell configAvatar:self.currentPerson];
        } else {
            [roomSourceCell configAvatar:self.friendPerson];
        }
        [roomSourceCell configWithData:dic];
        return roomSourceCell;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeText]]) {
        static NSString* const kCellIdentifier = @"AJKChatMessageTextCell";
        AXChatMessageTextCell* textCell = [[AXChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        textCell.messageSource = [self messageSource:dic];
        textCell.messageStatus = AXMessageCenterSendMessageStatusSending;
        if ([dic[@"messageSource"] isEqualToNumber:[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]]) {
            [textCell configAvatar:self.currentPerson];
        } else {
            [textCell configAvatar:self.friendPerson];
        }
        [textCell configWithIndexPath:indexPath];
        [textCell configWithData:dic];
        textCell.delegate = self;
        textCell.isBroker = self.isBroker;
        return textCell;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePublicCard]]) {
        static NSString *cardCellIdentity = @"cardCellIdentity";
        AXChatMessagePublicCardCell *cardCell = [tableView dequeueReusableCellWithIdentifier:cardCellIdentity];
        if (cardCell == nil) {
            cardCell = [[AXChatMessagePublicCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardCellIdentity];
            cardCell.isBroker = self.isBroker;
        }
        cardCell.messageSource = [self messageSource:dic];
        if ([dic[@"messageSource"] isEqualToNumber:[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]]) {
            [cardCell configAvatar:self.currentPerson];
        } else {
            [cardCell configAvatar:self.friendPerson];
        }
        [cardCell configWithIndexPath:indexPath];
        [cardCell configWithData:dic];
        return cardCell;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSystemTime]]) {
        static NSString *systemTimeIdent = @"systemTime";
        AXChatMessageSystemTimeCell *systemTime = [tableView dequeueReusableCellWithIdentifier:systemTimeIdent];
        if (systemTime == nil) {
            systemTime = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemTimeIdent];
            systemTime.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [systemTime configWithData:(self.cellData)[indexPath.row]];
        [systemTime configWithIndexPath:indexPath];
        return systemTime;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSystemForbid]]) {
        static NSString *systemTimeIdent = @"systemForbid";
        AXChatMessageSystemTimeCell *systemForbid = [tableView dequeueReusableCellWithIdentifier:systemTimeIdent];
        if (systemForbid == nil) {
            systemForbid = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemTimeIdent];
            systemForbid.selectionStyle = UITableViewCellSelectionStyleNone;
            systemForbid.isBroker = self.isBroker;
        }
        [systemForbid configWithData:(self.cellData)[indexPath.row]];
        [systemForbid configWithIndexPath:indexPath];
        return systemForbid;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeAddNuckName]]) {
        static NSString *systemTimeIdent = @"addNuckName";
        AXChatMessageSystemTimeCell *addNuckName = [tableView dequeueReusableCellWithIdentifier:systemTimeIdent];
        if (addNuckName == nil) {
            addNuckName = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemTimeIdent];
            addNuckName.selectionStyle = UITableViewCellSelectionStyleNone;
            addNuckName.isBroker = self.isBroker;
        }
        [addNuckName configWithData:(self.cellData)[indexPath.row]];
        [addNuckName configWithIndexPath:indexPath];
        addNuckName.systemCellDelegate = self;
        return addNuckName;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSettingNotifycation]]) {
        static NSString *systemTimeIdent = @"settingNotifycation";
        AXChatMessageSystemTimeCell *settingNotifycation = [tableView dequeueReusableCellWithIdentifier:systemTimeIdent];
        if (settingNotifycation == nil) {
            settingNotifycation = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemTimeIdent];
            settingNotifycation.selectionStyle = UITableViewCellSelectionStyleNone;
            settingNotifycation.isBroker = self.isBroker;
        }
        [settingNotifycation configWithData:(self.cellData)[indexPath.row]];
        [settingNotifycation configWithIndexPath:indexPath];
        settingNotifycation.systemCellDelegate = self;
        return settingNotifycation;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeAddNote]]) {
        static NSString *systemTimeIdent = @"addNote";
        AXChatMessageSystemTimeCell *systemCell = [tableView dequeueReusableCellWithIdentifier:systemTimeIdent];
        if (systemCell == nil) {
            systemCell = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemTimeIdent];
            systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            systemCell.isBroker = self.isBroker;
        }
        [systemCell configWithData:(self.cellData)[indexPath.row]];
        [systemCell configWithIndexPath:indexPath];
        systemCell.systemCellDelegate = self;
        return systemCell;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSendProperty]]) {
        static NSString *systemTimeIdent = @"sendProperty";
        AXChatMessageSystemTimeCell *systemCell = [tableView dequeueReusableCellWithIdentifier:systemTimeIdent];
        if (systemCell == nil) {
            systemCell = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemTimeIdent];
            systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            systemCell.isBroker = self.isBroker;
        }
        [systemCell configWithData:(self.cellData)[indexPath.row]];
        [systemCell configWithIndexPath:indexPath];
        systemCell.systemCellDelegate = self;
        return systemCell;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSafeMessage]]) {
        static NSString *systemTimeIdent = @"safeMessage";
        AXChatMessageSystemTimeCell *systemCell = [tableView dequeueReusableCellWithIdentifier:systemTimeIdent];
        if (systemCell == nil) {
            systemCell = [[AXChatMessageSystemTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:systemTimeIdent];
            systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
            systemCell.isBroker = self.isBroker;
        }
        [systemCell configWithData:(self.cellData)[indexPath.row]];
        [systemCell configWithIndexPath:indexPath];
        systemCell.systemCellDelegate = self;
        return systemCell;
    } else {
        static NSString *imageCellidentity = @"imageCellidentity";
        AXChatMessageImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:imageCellidentity];
        if (imageCell == nil) {
            imageCell = [[AXChatMessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellidentity];
            imageCell.selectionStyle = UITableViewCellSelectionStyleNone;
            imageCell.delegate = self;
            imageCell.isBroker = self.isBroker;
        }
        imageCell.messageSource = [self messageSource:dic];
        if ([dic[@"messageSource"] isEqualToNumber:[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]]) {
            [imageCell configAvatar:self.currentPerson];
        } else {
            [imageCell configAvatar:self.friendPerson];
        }
        [imageCell configWithData:dic];
        return imageCell;
    }
}

#pragma mark - AJKChatMessageSystemCellDelegate
- (void)didClickSystemButton:(AXMessageType)messageType {
    
    
//    if ([(self.cellData)[indexPath.row][@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeAddNuckName]]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加备注名" message:nil delegate:nil
//                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }   else if ([(self.cellData)[indexPath.row][@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSettingNotifycation]]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置消息推送开关" message:nil delegate:nil
//                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alert show];
//    }
//    NSLog(@"%d", indexPath.row);
}

- (AXChatMessageSourceDestination)messageSource:(NSDictionary *)dic
{
    if (dic[@"messageSource"] && [dic[@"messageSource"] isEqualToNumber:[NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming]]) {
        return AXChatMessageSourceDestinationIncoming;
    } else {
        return AXChatMessageSourceDestinationOutPut;
    }
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor axChatBGColor:self.isBroker]];

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AXWINDOWWHIDTH, AXWINDOWHEIGHT - AXInputBackViewHeight) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
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
    if ([self.messageInputView.textView.text isEqualToString:@"broker"]) {
        [self.messageInputView.textView resignFirstResponder];
        [self reloadMytableView];
        return;
    } else {
        [self sendNewMessage];
        
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = @"1";
        mappedMessage.content = self.messageInputView.textView.text;
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypeText];
        
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage willSendMessage:self.finishSendMessageBlock];
        self.messageInputView.textView.text = @"";
    }
}

- (void)reloadMytableView {
    
    [self.myTableView reloadData];
    if ([self.cellData count] > 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.cellData count] -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
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
    return [string rtSizeWithFont:fontSize constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:UILineBreakModeWordWrap];
}

#pragma mark - SSPullToRefreshViewDelegate
- (void)pullToRefreshViewDidStartLoading:(AXPullToRefreshView *)view {
    [self.pullToRefreshView startLoading];
    [self refresh];
}

- (void)refresh {
    if (!self.lastMessage) {
        [self.pullToRefreshView finishLoading];
        return;
    }
    
    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:self.lastMessage pageSize:AXMessagePageSize callBack:^(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        if ([chatList count] > 0) {
            self.lastMessage = chatList[0];
            NSInteger num = 0;
            for (AXMappedMessage *mappedMessage in chatList) {
                NSDictionary *dict = [self mapAXMappedMessage:mappedMessage];
                [self.cellData insertObject:dict atIndex:num];
                [self.identifierData insertObject:mappedMessage.identifier atIndex:num];
                num++;
            }
            [self.myTableView reloadData];
        }
    }];
    [self.pullToRefreshView finishLoading];

}
#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(AXELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    if ([info count] == 0) {
        return;
    }
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        CGSize size = image.size;
        NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
        NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
        NSString *url = [AXPhotoManager getLibrary:path];
        
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = @"1";
        //        mappedMessage.content = self.messageInputView.textView.text;
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypePic];
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
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize size = image.size;
    NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
    NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
    NSString *url = [AXPhotoManager getLibrary:path];
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = @"1";
    //        mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypePic];
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
    [self.myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

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
    [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishSendMessageBlock];
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
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
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
     - inputViewFrame.size.height + 60];
    self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                            - self.messageInputView.frame.origin.y
                                            - inputViewFrame.size.height + 60);
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
    [self finishSend];
}

- (void)finishSend
{
    [self.messageInputView.textView setText:nil];
    [self textViewDidChange:self.messageInputView.textView];
    [self.myTableView reloadData];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.isUserScrolling = YES;
    [self.messageInputView.textView resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isUserScrolling = NO;
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //    [self hideInputBackView];
    [textView becomeFirstResponder];
	
    if (!self.previousTextViewContentHeight) {
		self.previousTextViewContentHeight = textView.contentSize.height;
    }
    [self scrollToBottomAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:@"broker"]) {
        self.isBroker = YES;
    }
    if ([textView.text isEqualToString:@"anjuke"]) {
        self.isBroker = NO;
        self.moreBackView.frame = CGRectMake(320, 0, 0, 0);
    }
    
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
}

@end
