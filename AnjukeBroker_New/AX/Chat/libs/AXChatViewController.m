//
//  ViewController.m
//  X
//
//  Created by 杨 志豪 on 2/12/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatViewController.h"
#import "AXChatMessageRoomSourceCell.h"
#import "AXChatMessageImageCell.h"
#import "AXChatMessagePublicCardCell.h"
#import "AXChatMessageTextCell.h"
#import "AXChatMessageNameCardCell.h"
#import "AXChatMessageSystemTimeCell.h"
#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>
#import "NSString+XChat.h"
#import "AXBigIMGSViewController.h"
#import "AXChatMessageCenter.h"
#import "AXMappedMessage.h"
#import "AXPullToRefreshContentView.h"
#import "AXChatWebViewController.h"
#import "UIColor+AXChatMessage.h"

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

@interface AXChatViewController ()<UITableViewDelegate, UITableViewDataSource, OHAttributedLabelDelegate, AXPullToRefreshViewDelegate, UIAlertViewDelegate, AXChatMessageRootCellDelegate>
{
    CGFloat offset;//键盘的高度
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UITableViewCell *selectedCell;
@property (nonatomic) BOOL isMenuVisible;

@property (nonatomic, strong) AXPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) AXMappedMessage *lastMessage;
@property (nonatomic, strong) UILabel *sendLabel;

@property (nonatomic, strong) void (^finishSendMessageBlock)(AXMappedMessage *message,AXMessageCenterSendMessageStatus status);

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
    self.pullToRefreshView.delegate = nil;
    self.pullToRefreshView = nil;
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    self.myTableView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
#warning TODO 设置双方的头像
    
    self.cellData = [NSMutableArray array];
    self.identifierData = [NSMutableArray array];
    [self addKeyboardNotifycation];

    AXMappedMessage *lastMessage = [[AXMappedMessage alloc] init];
    lastMessage.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];
    lastMessage.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    lastMessage.from = @"2";
//    lastMessage.to  = [self checkFriendUid];
    lastMessage.to = @"1";
    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:lastMessage pageSize:AXMessagePageSize callBack:^(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        if ([chatList count] > 0) {
            self.lastMessage = chatList[0];
            for (AXMappedMessage *mappedMessage in chatList) {
                NSDictionary *dict = [self mapAXMappedMessage:mappedMessage];
                [self.cellData addObject:dict];
                [self.identifierData addObject:mappedMessage.identifier];
            }
            [self.myTableView reloadData];
        }
        [self addMessageNotifycation];
    }];
    
    // 发消息的block
    __weak AXChatViewController *blockSelf = self;
    self.finishSendMessageBlock = ^ (AXMappedMessage *message, AXMessageCenterSendMessageStatus status) {
        NSMutableDictionary *textData = [NSMutableDictionary dictionary];
            textData = [blockSelf mapAXMappedMessage:message];
//        if (status != AXMessageCenterSendMessageStatusSending) {
//            status = AXMessageCenterSendMessageStatusFailed;
//        }
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
    
#ifdef DEBUG
    UIButton *getMessageBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    getMessageBtn.frame = CGRectMake(10, 10, 25, 25);
    [getMessageBtn addTarget:self action:@selector(getNewMessage) forControlEvents:UIControlEventTouchUpInside];
    getMessageBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:getMessageBtn];
    
    UIButton *sendMessageBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    sendMessageBtn.frame = CGRectMake(10, 35, 25, 25);
    [sendMessageBtn addTarget:self action:@selector(sendNewMessage) forControlEvents:UIControlEventTouchUpInside];
    sendMessageBtn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:sendMessageBtn];
    
#endif
    
    [self addPullToRefresh];
}

- (void)getNewMessage
{
    [[AXChatMessageCenter defaultMessageCenter] receiveMessage];
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
        mappedMessageProp.isRead = [NSNumber numberWithBool:YES];
        mappedMessageProp.isRemoved = [NSNumber numberWithBool:NO];
        mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadMytableView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideInputBackView];
}

- (void)addMessageNotifycation
{
    [[NSNotificationCenter defaultCenter] addObserverForName:MessageCenterDidReceiveNewMessage object:nil queue:nil usingBlock: ^(NSNotification *note) {
        // 接受消息
        if ([note.object isKindOfClass:[NSArray class]]) {
            NSArray *list = (NSArray *)note.object;
            for (AXMappedMessage *mappedMessage in list) {
                NSMutableDictionary *dict = [self mapAXMappedMessage:mappedMessage];
                dict[AXCellIdentifyTag] = mappedMessage.identifier;
                [self appendCellData:dict];
            }
        }
    }];
}

#pragma mark - DataSouce Method
- (NSString *)checkFriendUid
{
    if (self.conversationListItem) {
        return self.conversationListItem.friendUid;
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
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self scrollToBottomAnimated:YES];
}

- (void)insertCellData:(NSDictionary *)msgData atIndex:(NSUInteger)index
{
    [self.cellData insertObject:msgData atIndex:index];
    [self.identifierData insertObject:msgData[AXCellIdentifyTag] atIndex:index];
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:index inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
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
        return 156;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeText]]) {
        CGSize sz = [dic[@"mas"] sizeConstrainedToSize:CGSizeMake(kLabelWidth, CGFLOAT_MAX)];
        CGFloat rowHeight = sz.height + 2*kLabelVMargin + 40;
        return rowHeight;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePic]]) {
        return [AXChatMessageImageCell sizeOFImg:dic[@"content"]].size.height+30;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePublicCard]]) {
        return 100;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeSystemTime]]) {
        return 35;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePublicCard]]) {
        return 210;
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
        [roomSourceCell configWithData:dic];
        return roomSourceCell;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypeText]]) {
        static NSString* const kCellIdentifier = @"AJKChatMessageTextCell";
        AXChatMessageTextCell* textCell = [[AXChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        textCell.messageSource = [self messageSource:dic];
        textCell.messageStatus = AXMessageCenterSendMessageStatusSending;
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
        [cardCell configWithIndexPath:indexPath];
        [cardCell configWithData:dic];
        return cardCell;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePublicCard]]) {
        static NSString *nameCardIdentity = @"nameCardIdentity";
        AXChatMessageNameCardCell *nameCard = [tableView dequeueReusableCellWithIdentifier:nameCardIdentity];
        if (nameCard == nil) {
            nameCard = [[AXChatMessageNameCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nameCardIdentity];
            nameCard.isBroker = self.isBroker;
        }
        nameCard.cellData = dic;
        nameCard.messageSource = [self messageSource:dic];
        [nameCard configWithData:dic];
        return nameCard;
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

- (void)addKeyboardNotifycation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)initUI {
    [self.view setBackgroundColor:[UIColor axChatBGColor:self.isBroker]];

    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AXWINDOWWHIDTH, AXWINDOWHEIGHT - AXInputBackViewHeight) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myTableView];
    
    self.inputBackView = [[UIView alloc] initWithFrame:CGRectMake(0, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXInputBackViewHeight, AXWINDOWWHIDTH, AXInputBackViewHeight)];
    self.inputBackView.backgroundColor = [UIColor colorWithHex:0xF6F6F6 alpha:1];
    [self.view addSubview:self.inputBackView];
    
    self.inputText = [[UITextView alloc] initWithFrame:CGRectMake(AXInputTextLeft, 10.0f, AXInputTextWidth, AXInputTextHeight)];
    self.inputText.backgroundColor = [UIColor whiteColor];
    self.inputText.delegate = self;
    self.inputText.font = [UIFont systemFontOfSize:14];
    self.inputText.keyboardAppearance = UIKeyboardAppearanceDefault;
    self.inputText.keyboardType = UIKeyboardTypeDefault;
    self.inputText.returnKeyType = UIReturnKeySend;
    self.inputText.layer.masksToBounds = YES;
    self.inputText.text = @"broker";
    self.inputText.layer.borderWidth = 1.0f;
    self.inputText.layer.borderColor = [UIColor colorWithHex:0xCCCCCC alpha:1].CGColor;
    self.inputText.layer.cornerRadius = 3.0f;
    
    [self.inputBackView addSubview:self.inputText];
    
    if (self.isBroker) {
        self.sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBut.frame = CGRectMake(270.0f, 5.0f, 40.0f, 30.0f);
        self.sendBut.imageView.image = [UIImage imageNamed:@""];
        self.sendBut.backgroundColor = [UIColor grayColor];
    } else {
        self.sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBut.frame = CGRectMake(275.0f, 10.0f, 40.0f, 30.0f);
        self.sendBut.layer.masksToBounds = YES;
        self.sendBut.layer.borderWidth = 1.0f;
        self.sendBut.layer.borderColor = [UIColor colorWithHex:0xCCCCCC alpha:1].CGColor;
        self.sendBut.layer.cornerRadius = 3.0f;
        self.sendBut.imageView.image = [UIImage imageNamed:@"xproject_dialogue_greybutton.png"];
        self.sendLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 0, 36, 30)];
        self.sendLabel.text = @"发送";
        self.sendLabel.textColor = [UIColor colorWithHex:0x60a410 alpha:1];
        self.sendLabel.font = [UIFont systemFontOfSize:16];
        [self.sendBut addSubview:self.sendLabel];
    }
    
    [self.sendBut addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.inputBackView addSubview:self.sendBut];
    
    self.moreBackView = [[UIView alloc] init];
    self.moreBackView.frame = CGRectMake(0, self.inputBackView.frame.origin.y + AXInputBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);
    self.moreBackView.backgroundColor = [UIColor lightGrayColor];
    //    CGRectMake(0, self.keyboardBack.frame.origin.y - INPUTBACKVIEWHIGHT, [self windowWidth], MOREBACKVIEWHIGHT)
    [self.view addSubview:self.moreBackView];
    
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
    NSDictionary *imageData = @{@"messageType":[NSNumber numberWithInteger:AXMessageTypePic],@"content":[UIImage imageNamed:@"demo-avatar-jobs.png"],@"messageSource":@"incoming"};
    [self.cellData addObject:imageData];
    [self reloadMytableView];
}

- (void)takePic:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
    NSDictionary *imageData = @{@"messageType":[NSNumber numberWithInteger:AXMessageTypePic],@"content":[UIImage imageNamed:@"demo-avatar-jobs.png"],@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming]};
    [self.cellData addObject:imageData];
    [self reloadMytableView];
}

- (void)pickAJK:(id)sender {
    
    NSDictionary *roomSource = @{@"title": @"中房二期花园，地理位置好",@"price":@"12000",@"roomType":@"3房两厅",@"area":@"200",@"floor":@"13/14",@"year":@"2005",@"messageType":[NSNumber numberWithInteger:AXMessageTypeProperty],@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming]};
    [self.cellData addObject:roomSource];
    [self reloadMytableView];
}

- (void)pickHZ:(id)sender {
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];

    mappedMessageProp.to = @"1";
    mappedMessageProp.from = @"2";
    mappedMessageProp.sendTime = nil;
    mappedMessageProp.content = nil;
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    
//    NSDictionary *roomSource = @{@"title": @"中房二期花园，地理位置好",@"price":@"12000",@"roomType":@"3房两厅",@"area":@"200",@"floor":@"13/14",@"year":@"2005",@"messageType":[NSNumber numberWithInteger:AXMessageTypeProperty],@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationOutPut]};
//    [self.cellData addObject:roomSource];
//    [self reloadMytableView];
    
}

- (void)sendMessage:(id)sender {
    if ([self.inputText.text isEqualToString:@""]) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发空消息" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [view show];
        return;
    }
    if ([self.inputText.text isEqualToString:@"broker"]) {
        [self.inputText resignFirstResponder];
        CGSize size = [self sizeOfString:self.inputText.text maxWidth:AXInputTextWidth withFontSize:self.inputText.font];
        self.inputText.frame = CGRectMake(AXInputTextLeft, 10.0f, AXInputTextWidth, 15.0f + size.height);
        
        self.inputBackView.frame = CGRectMake(0.0f, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXInputBackViewHeight - AXMoreBackViewHeight , AXWINDOWWHIDTH, AXInputBackViewHeight);

        self.moreBackView.frame = CGRectMake(0, AXWINDOWHEIGHT - AXStatuBarHeight - AXNavBarHeight - AXMoreBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);
        
        self.myTableView.frame = CGRectMake(0, 0, AXWINDOWWHIDTH, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXMoreBackViewHeight - AXInputBackViewHeight);
        
        [self reloadMytableView];
        return;
    } else {
        [self resetInputBackView];
        
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = @"1";
        mappedMessage.content = self.inputText.text;
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
        mappedMessage.isRead = [NSNumber numberWithBool:YES];
        mappedMessage.isRemoved = [NSNumber numberWithBool:NO];
        mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypeText];
        
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage willSendMessage:self.finishSendMessageBlock];
        self.inputText.text = @"";
    }
}
//隐藏键盘和更多
- (void)hideInputBackView {
    [self.inputText resignFirstResponder];
    [UIView animateWithDuration:0.24 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGSize size = self.inputBackView.frame.size;
        self.inputBackView.frame = CGRectMake(0.0f, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - size.height, AXWINDOWWHIDTH, size.height);
        CGRect tableRect = self.myTableView.frame;
        self.myTableView.frame = CGRectMake(tableRect.origin.x, tableRect.origin.y , tableRect.size.width, AXWINDOWHEIGHT - AXInputBackViewHeight - AXNavBarHeight - AXStatuBarHeight);
        if (self.isBroker) {
            CGRect rect = self.inputBackView.frame;
            self.moreBackView.frame = CGRectMake(0, rect.origin.y + rect.size.height, AXWINDOWWHIDTH, AXMoreBackViewHeight);
        }
    } completion:^(BOOL finished) {
    }];
//        [self reloadMytableView];
}
//重置到键盘第一次出现的状态
- (void)resetInputBackView {
    self.inputText.frame = CGRectMake(AXInputTextLeft, 10.0f, AXInputTextWidth, AXInputTextHeight);
    self.inputBackView.frame = CGRectMake(0.0f, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXInputBackViewHeight - offset, AXWINDOWWHIDTH, AXInputBackViewHeight);
    CGRect tableRect = self.myTableView.frame;
    self.myTableView.frame = CGRectMake(tableRect.origin.x, tableRect.origin.y , AXWINDOWWHIDTH, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - offset - AXInputBackViewHeight);
    [self reloadMytableView];

}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [[AXChatMessageCenter defaultMessageCenter] receiveMessage];
    CGRect inputbackViewRect = self.inputBackView.frame;
    CGSize size = [self sizeOfString:textView.text maxWidth:AXInputTextWidth withFontSize:textView.font];
    CGRect tableRect = self.myTableView.frame;
    if (size.height > 70) {
        self.inputText.frame = CGRectMake(AXInputTextLeft, 10.0f, AXInputTextWidth, 70.0f);
        self.inputBackView.frame = CGRectMake(0.0f, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXInputBackViewHeight - offset - 40.0f, AXWINDOWWHIDTH, AXInputBackViewHeight + 40);
    }else {
        self.inputText.frame = CGRectMake(AXInputTextLeft, 10.0f, AXInputTextWidth, 15.0f + size.height);
        self.inputBackView.frame = CGRectMake(0.0f, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXInputBackViewHeight - offset - size.height + 15.0f, AXWINDOWWHIDTH, AXInputBackViewHeight + size.height - 15.0f);
        self.myTableView.frame = CGRectMake(tableRect.origin.x, tableRect.origin.y , tableRect.size.width, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - size.height - offset);
    }
    if (inputbackViewRect.size.height != self.inputBackView.frame.size.height) {
        NSLog(@"%f====%f", inputbackViewRect.size.height,self.inputBackView.frame.size.height);
        self.myTableView.frame = CGRectMake(tableRect.origin.x, tableRect.origin.y , tableRect.size.width, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - self.inputBackView.frame.size.height - offset);
        [self reloadMytableView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView.text isEqualToString:@"broker"]) {
        self.isBroker = YES;
//        return NO;
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

#pragma mark - keyBoardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    offset = kbSize.height;
    [self dealKeyboardWillShow];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    offset = kbSize.height;
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    [self dealWithHideKeyboard];
    
}

-(void)dealWithHideKeyboard {
    offset = 0;
}

-(void)dealKeyboardWillShow{
    [UIView animateWithDuration:0.30 delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGSize size = self.inputBackView.frame.size;
        self.inputBackView.frame = CGRectMake(0.0f, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - size.height - offset, AXWINDOWWHIDTH, size.height);
        CGRect tableRect = self.myTableView.frame;
        self.myTableView.frame = CGRectMake(tableRect.origin.x, tableRect.origin.y , tableRect.size.width, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - size.height - offset);

        [self scrollToBottomAnimated:YES];
        if (self.isBroker) {
            CGRect rect = self.inputBackView.frame;
            self.moreBackView.frame = CGRectMake(0, rect.origin.y + rect.size.height, AXWINDOWWHIDTH, AXMoreBackViewHeight);
        }
    } completion:^(BOOL finished) {
    }];
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
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage imageNamed:@"anjuke_icon_chat1.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        } else {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage imageNamed:@"anjuke_icon_chat3.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        }
    }
}

- (void)willShowEditMenu:(NSNotification *)notification
{
    if (self.selectedCell) {
        if (((AXChatMessageRootCell *)self.selectedCell).messageSource == AXChatMessageSourceDestinationIncoming) {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage imageNamed:@"anjuke_icon_chat2.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        } else {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage imageNamed:@"anjuke_icon_chat4.png"] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        }
    }
}

- (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(UIFont *)fontSize {
    return [string rtSizeWithFont:fontSize constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:UILineBreakModeWordWrap];
}

#pragma mark - SSPullToRefreshViewDelegate
- (void)pullToRefreshViewDidStartLoading:(AXPullToRefreshView *)view {
    [self refresh];
}

- (void)refresh {
    if (!self.lastMessage) {
        return;
    }
    
    [self.pullToRefreshView startLoading];

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
    int count = [info count];
    
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        NSDictionary *imageData = @{@"messageType":@"image",@"content":image,@"messageSource":@"incoming"};
        [self.cellData addObject:imageData];
        [self reloadMytableView];
        //保存原始图片、得到url
        //        E_Photo *ep = [PhotoManager getNewE_Photo];
        //        NSString *path = [PhotoManager saveImageFile:image toFolder:PHOTO_FOLDER_NAME];
        //        NSString *url = [PhotoManager getDocumentPath:path];
        //        ep.photoURL = url;
        //
        //        UIImage *newSizeImage = nil;
        //        //压缩图片
        //        if (image.size.width > IMAGE_MAXSIZE_WIDTH || image.size.height > IMAGE_MAXSIZE_WIDTH || self.isTakePhoto) {
        //            CGSize coreSize;
        //            if (image.size.width > image.size.height) {
        //                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH*(image.size.height /image.size.width));
        //            }
        //            else if (image.size.width < image.size.height){
        //                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH *(image.size.width /image.size.height), IMAGE_MAXSIZE_WIDTH);
        //            }
        //            else {
        //                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH);
        //            }
        //
        //            UIGraphicsBeginImageContext(coreSize);
        //            [image drawInRect:[Util_UI frameSize:image.size inSize:coreSize]];
        //            newSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        //            UIGraphicsEndImageContext();
        //
        //            path = [PhotoManager saveImageFile:newSizeImage toFolder:PHOTO_FOLDER_NAME];
        //            url = [PhotoManager getDocumentPath:path];
        //            ep.smallPhotoUrl = url;
        //
        //        }
        //        else {
        //            ep.smallPhotoUrl = url;
        //        }
        //
        //        [self.houseTypeImageArr addObject:ep];
	}
    //
    //    DLog(@"相册添加室内图:count[%d]", self.houseTypeImageArr.count);
    //
    //    //redraw footer img view
    //    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(AXELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSDictionary *imageData = @{@"messageType":@"image",@"content":(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage],@"messageSource":@"incoming"};
    [self.cellData addObject:imageData];
    [self reloadMytableView];
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
    
@end
