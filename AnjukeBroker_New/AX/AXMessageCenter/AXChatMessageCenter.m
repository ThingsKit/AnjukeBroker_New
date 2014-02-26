//
//  AJKChatMessageCenter.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-17.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXChatMessageCenter.h"
#import "AXMessageManager.h"
#import "AXChatDataCenter.h"

//managerCenter manager
#import "AXMessageCenterSendMessageManager.h"
#import "AXMessageCenterReceiveMessageManager.h"
#import "AXMessageCenterFriendListManager.h"
#import "AXMessageCenterDeleteFriendManager.h"
#import "AXMessageCenterAddFriendManager.h"
#import "AXMessageCenterSearchBrokerManager.h"
#import "AXMessageCenterGetUserOldMessageManager.h"
#import "AXMessageCenterModifyFriendInfoManager.h"

static NSString * const kMessageCenterReceiveMessageTypeText = @"1";
static NSString * const kMessageCenterReceiveMessageTypeProperty = @"2";
static NSString * const UID = @"234234234";
static NSString * const ImageServeAddress = @"http://upd1.ajkimg.com/upload";

@interface AXChatMessageCenter ()<AIFMessageManagerDelegate,AIFMessageSenderDelegate,RTAPIManagerApiCallBackDelegate,RTAPIManagerInterceptorProtocal, AXChatDataCenterDelegate>
@property (nonatomic, strong) AXMessageManager *messageManager;
@property (nonatomic, strong) ASIHTTPRequest *QRCodeRequest;
@property (nonatomic, strong) AXChatDataCenter *dataCenter;
@property (nonatomic, strong) NSOperationQueue *imageMessageOperation;
@property (nonatomic, strong) NSMutableArray *messsageIdentity;
@property (nonatomic, strong) NSMutableDictionary *blockDictionary;
@property (nonatomic, strong) AXMappedMessage *imageMessage;

//property
@property (nonatomic, strong) NSString *addFriendByID;

//manager
@property (nonatomic, strong) AXMessageCenterSendMessageManager *sendMessageManager;
@property (nonatomic, strong) AXMessageCenterReceiveMessageManager *receiveMessageManager;
@property (nonatomic, strong) AXMessageCenterFriendListManager *friendListManager;
@property (nonatomic, strong) AXMessageCenterDeleteFriendManager *deleteFriendManager;
@property (nonatomic, strong) AXMessageCenterAddFriendManager *addFriendManager;
@property (nonatomic, strong) AXMessageCenterSearchBrokerManager *searchBrokerManager;
@property (nonatomic, strong) AXMessageCenterGetUserOldMessageManager *getOldMessageManager;
@property (nonatomic, strong) AXMessageCenterModifyFriendInfoManager *modifyFriendInfoManager;


@property (nonatomic, strong) void (^finishSendMessageBlock)(AXMappedMessage *message,AXMessageCenterSendMessageStatus status);
@property (nonatomic, strong) void (^addFriendByQRCode)(BOOL whetherSuccess);
@property (nonatomic, strong) void (^personInfoBlock)(AXMappedPerson *person);
@property (nonatomic, strong) void (^friendListBlock)(NSArray *friendList,BOOL whetherSuccess);
@property (nonatomic ,strong) void (^fetchedChatList)(NSArray *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend);
@property (nonatomic, strong) void (^updateUserInfo)(BOOL isSuccess);
@property (nonatomic, strong) void (^addFriendBlock)(BOOL isSuccess);
@property (nonatomic, strong) void (^deleteFriendBlock)(BOOL isSuccess);
@property (nonatomic, strong) void (^searchBrokerBlock)(AXMappedPerson *brokerInfo);

@property (nonatomic, strong) AXMappedPerson *currentPerson;
@end

@implementation AXChatMessageCenter

- (AXMappedPerson *)currentPerson
{
    if (_currentPerson == nil) {
        _currentPerson = [self.dataCenter fetchCurrentPerson];
    }
    return _currentPerson;
}

+ (instancetype)defaultMessageCenter
{
    static AXChatMessageCenter *messageCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageCenter = [[AXChatMessageCenter alloc] init];
    });
    return messageCenter;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.messageManager = [[AXMessageManager alloc] init];
        self.messageManager.delegate = self;
        self.messageManager.MessageSenderDelegate = self;
        
        self.imageMessageOperation = [[NSOperationQueue alloc] init];
        self.imageMessageOperation.maxConcurrentOperationCount = 1;
        
        self.messsageIdentity = [[NSMutableArray alloc] init];
        self.blockDictionary = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectToServer) name:@"REFRESH_MENU_TABLE" object:nil];
        
    }
    return self;
}
- (void)connectToServer
{
    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
    
    self.dataCenter = [[AXChatDataCenter alloc] initWithUID:loginResult[@"user_info"][@"user_id"]];
    AXMappedPerson *mySelf = [[AXMappedPerson alloc] init];
    mySelf.uid = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"user_id"]];
    mySelf.phone = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"phone"]];
    mySelf.markName = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name"]];
    mySelf.iconUrl = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"icon"]];
    mySelf.markNamePinyin = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name_pinyin"]];
    mySelf.userType = [NSNumber numberWithInt:[loginResult[@"user_info"][@"user_type"] integerValue]];
    
    [self.dataCenter updatePerson:mySelf];
    
    self.dataCenter.delegate = self;
    self.currentPerson = mySelf;
    [self.messageManager bindServerHost:kAXMessageCenterLinkParamHost port:kAXMessageCenterLinkParamPort appName:kAXMessageCenterLinkAppName timeout:350];
    [self.messageManager registerDevices:[[UIDevice currentDevice] udid] userId:self.currentPerson.uid];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidInitedDataCenter object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID
{
    return [self.dataCenter fetchConversationListItemWithFriendUID:friendUID];
}

- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID
{
    [self.dataCenter saveDraft:content friendUID:friendUID];
}

#pragma mark -  setters and getters
- (AXMessageCenterSendMessageManager *)sendMessageManager
{
    if (!_sendMessageManager) {
        _sendMessageManager = [[AXMessageCenterSendMessageManager alloc] init];
        _sendMessageManager.delegate = self;
        _sendMessageManager.validator = _sendMessageManager;
        _sendMessageManager.paramSource = _sendMessageManager;
        _sendMessageManager.interceotorDelegate = self;
    }
    return _sendMessageManager;
}

- (AXMessageCenterReceiveMessageManager *)receiveMessageManager
{
    if (!_receiveMessageManager) {
        _receiveMessageManager = [[AXMessageCenterReceiveMessageManager alloc] init];
        _receiveMessageManager.delegate = self;
        _receiveMessageManager.validator = _receiveMessageManager;
        _receiveMessageManager.paramSource = _receiveMessageManager;
    }
    return _receiveMessageManager;
}

- (AXMessageCenterFriendListManager *)friendListManager
{
    if (!_friendListManager) {
        _friendListManager  = [[AXMessageCenterFriendListManager alloc] init];
        _friendListManager.delegate = self;
        _friendListManager.validator = _friendListManager;
        _friendListManager.paramSource = _friendListManager;
    }
    return _friendListManager;
}

- (AXMessageCenterDeleteFriendManager *)deleteFriendManager
{
    if (!_deleteFriendManager) {
        _deleteFriendManager = [[AXMessageCenterDeleteFriendManager alloc] init];
        _deleteFriendManager.delegate = self;
        _deleteFriendManager.paramSource = _deleteFriendManager;
        _deleteFriendManager.validator = _deleteFriendManager;
    }
    return _deleteFriendManager;
}

- (AXMessageCenterAddFriendManager *)addFriendManager
{
    if (!_addFriendManager) {
        _addFriendManager = [[AXMessageCenterAddFriendManager alloc] init];
        _addFriendManager.delegate = self;
        _addFriendManager.validator = _addFriendManager;
        _addFriendManager.paramSource = _addFriendManager;
    }
    return _addFriendManager;
}

- (AXMessageCenterSearchBrokerManager *)searchBrokerManager
{
    if (!_searchBrokerManager) {
        _searchBrokerManager = [[AXMessageCenterSearchBrokerManager alloc] init];
        _searchBrokerManager.delegate = self;
        _searchBrokerManager.validator = _searchBrokerManager;
        _searchBrokerManager.paramSource = _searchBrokerManager;
    }
    return _searchBrokerManager;
}

- (AXMessageCenterGetUserOldMessageManager *)getOldMessageManager
{
    if (!_getOldMessageManager) {
        _getOldMessageManager = [[AXMessageCenterGetUserOldMessageManager alloc] init];
        _getOldMessageManager.validator = _getOldMessageManager;
        _getOldMessageManager.paramSource = _getOldMessageManager;
        _getOldMessageManager.delegate = self;
    }
    return _getOldMessageManager;
}

- (AXMessageCenterModifyFriendInfoManager *)modifyFriendInfoManager
{
    if (!_modifyFriendInfoManager) {
        _modifyFriendInfoManager = [[AXMessageCenterModifyFriendInfoManager alloc] init];
        _modifyFriendInfoManager.validator = _modifyFriendInfoManager;
        _modifyFriendInfoManager.paramSource = _modifyFriendInfoManager;
        _modifyFriendInfoManager.delegate = self;
    }
    
    return _modifyFriendInfoManager;
}
#pragma mark - RTAPIManagerInterceptorProtocal    //call back for sendMessage
- (void)manager:(RTAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params
{
    if (params[kRTAPIBaseManagerRequestID] && params[@"uniqid"]) {
        NSDictionary *IDandIdentify = @{@"requestID":params[kRTAPIBaseManagerRequestID],@"uniqid":params[@"uniqid"]};
        [self.messsageIdentity addObject:IDandIdentify];
    }else
    {
        DLog(@"message error!!! or RTRequstID Is something error");
    }
}

- (void)manager:(RTAPIBaseManager *)manager beforePerformFailWithResponse:(RTNetworkResponse *)response
{
    [self sendMessageCallBackWithResonpe:response];
}
- (void)sendMessageCallBackWithResonpe:(RTNetworkResponse *)response
{
    int requestID = response.requestID;
    [self.messsageIdentity enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        if (requestID == [dic[@"requestID"] integerValue]) {
            NSString *identify = dic[@"uniqid"];
            AXMappedMessage *mappedMessage = [self.dataCenter fetchMessageWithIdentifier:identify];
            if (response.status == RTNetworkResponseStatusSuccess) {
                if (response.content[@"status"] && [response.content[@"status"] isEqualToString:@"OK"]) {
                    if (self.blockDictionary[identify]) {
                        _finishSendMessageBlock = self.blockDictionary[identify];
                        mappedMessage.sendStatus = @(AXMessageCenterSendMessageStatusSuccessful);
                        mappedMessage.messageId = [NSNumber numberWithInt:[response.content[@"result"] integerValue]];
                        [self.dataCenter didSuccessSendMessageWithIdentifier:identify messageId:[NSString stringWithFormat:@"%@",mappedMessage.messageId]];
                        _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusSuccessful);
                        [self.blockDictionary removeObjectForKey:identify];
                    }
                }
            }else if (response.status == RTNetworkResponseStatusFailed) {
                if (self.blockDictionary[identify]) {
                    mappedMessage.sendStatus = @(AXMessageCenterSendMessageStatusFailed);
                    [self.dataCenter didFailSendMessageWithIdentifier:[NSString stringWithFormat:@"%@",mappedMessage.messageId]];
                    _finishSendMessageBlock = self.blockDictionary[identify];
                    _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusFailed);
                    [self.blockDictionary removeObjectForKey:identify];
                }
            } else if (response.status == RTNetworkResponseStatusJsonError){
                if (self.blockDictionary[identify]) {
                    mappedMessage.sendStatus = @(AXMessageCenterSendMessageStatusFailed);
                    [self.dataCenter didFailSendMessageWithIdentifier:[NSString stringWithFormat:@"%@",mappedMessage.messageId]];
                    _finishSendMessageBlock = self.blockDictionary[identify];
                    _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusFailed);
                    [self.blockDictionary removeObjectForKey:identify];
                }
            }
        }
    }];

}
- (void)manager:(RTAPIBaseManager *)manager afterPerformSuccessWithResponse:(RTNetworkResponse *)response
{
    [self sendMessageCallBackWithResonpe:response];
}

#pragma mark - API Call back
- (void)managerCallAPIDidSuccess:(RTAPIBaseManager *)manager
{
    if ([manager isKindOfClass:[AXMessageCenterReceiveMessageManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        NSArray *receiveArray =[self.dataCenter didReceiveWithMessageDataArray:dic[@"result"]];
        dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:receiveArray];
         
        });
    }
    if ([manager isKindOfClass:[AXMessageCenterFriendListManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if (dic[@"status"] && [dic[@"status"] isEqualToString:@"OK"]) {
            NSArray *friendList = dic[@"result"];
            if ([friendList count] > 0) {
                NSArray *friendListFromDataCenter = [self.dataCenter saveFriendListWithPersonArray:friendList[0][@"friends"]];
                if (_friendListBlock) {
                    _friendListBlock(friendListFromDataCenter,YES);
                }
            }
        } else {
            _friendListBlock(nil,NO);
        }
    }
    if ([manager isKindOfClass:[AXMessageCenterAddFriendManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if (dic[@"result"] && [dic[@"status"] isEqualToString:@"OK"] && dic[@"result"][@"user_info"]) {
            [self.dataCenter didAddFriendWithFriendData:dic[@"result"][@"user_info"]];
            _addFriendBlock(YES);
        }
    }
    if ([manager isKindOfClass:[AXMessageCenterSearchBrokerManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if (dic[@"status"] && [dic[@"status"] isEqualToString:@"OK"]) {
            AXMappedPerson *newBroker = [[AXMappedPerson alloc] initWithDictionary:dic[@"result"]];
            _searchBrokerBlock(newBroker);
        }
    }
}
- (void)managerCallAPIDidFailed:(RTAPIBaseManager *)manager
{
    if ([manager isKindOfClass:[AXMessageCenterAddFriendManager class]]) {
        _addFriendBlock(NO);
    }
    if ([manager isKindOfClass:[AXMessageCenterReceiveMessageManager class]]) {
        NSLog(@"receive message failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterSearchBrokerManager class]]) {
        _searchBrokerBlock(nil);
    }

}

#pragma mark - selfMethod
- (void)closeKeepAlivingConnect
{
    [self.messageManager cancelRegisterRequest];
}

- (void)cancelAllRequest
{
    [[RTApiRequestProxy sharedInstance] cancelAllRequest];
}

- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter willSendMessage:message];
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_uid"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    
    self.sendMessageManager.apiParams = params;
    [self.sendMessageManager loadData];
}

- (void)reSendMessage:(NSString *)identifier willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identifier];
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_uid"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    
    self.sendMessageManager.apiParams = params;
    [self.sendMessageManager loadData];
}

- (void)sendImage:(AXMappedMessage *)message withCompeletionBlock:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter willSendMessage:message];
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending);
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    
    self.imageMessage = dataMessage;
    NSString *photoUrl = message.imgUrl;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:ImageServeAddress]];
    [request addFile:photoUrl forKey:@"file"];
    [request setDelegate:self];
    request.tag = AXMessageCenterHttpRequestTypeUploadImage;
    [self.imageMessageOperation addOperation:request];
}

- (void)updataUserInformation:(AXMappedPerson *)newInformation compeletionBlock:(void (^)(BOOL))updateUserInfo
{
    _updateUserInfo = updateUserInfo;
    [self.dataCenter updatePerson:newInformation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.currentPerson.phone;
    params[@"mark_name"] = newInformation.markName;
    params[@"to_uid"] = newInformation.uid;
    params[@"is_star"] = newInformation.isStar;
    params[@"relation_cate_id"] = @"0";
    
    self.modifyFriendInfoManager.apiParams = params;
    [self.modifyFriendInfoManager loadData];
}

- (void)addFriendByQRCode:(NSString *)urlString compeletionBlock:(void (^)(BOOL))addFriendCompeletionBlock
{
    _addFriendByQRCode = addFriendCompeletionBlock;
    NSURL *QRCodeUrl = [NSURL URLWithString:urlString];
    self.QRCodeRequest = [[ASIHTTPRequest alloc] init];
    self.QRCodeRequest.delegate = self;
    self.QRCodeRequest.tag = AXMessageCenterHttpRequestTypeQRCode;
    [self.QRCodeRequest setURL:QRCodeUrl];
    [self.QRCodeRequest startAsynchronous];
}

- (void)addFriendWithMyPhone:(AXMappedPerson *)person block:(void (^)(BOOL))addFriendBlock
{
    _addFriendBlock = addFriendBlock;
    [self.dataCenter willAddFriendWithUid:person.uid];
    self.addFriendManager.apiParams = @{
                                      @"phone":self.currentPerson.phone,
                                        @"touid":person.uid
                                        };
    [self.addFriendManager loadData];
}

- (void)removeFriendWithMyPhone:(NSString *)phone deleteUid:(NSArray *)deleteUid compeletionBlock:(void (^)(BOOL))deleteFriendBlock
{
    NSString *deleteAarray = [deleteUid JSONRepresentation];
    NSURL *deleteUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://chatapi.dev.anjuke.com/user/removeFriends/13333333333"]];
    ASIFormDataRequest *deleteFriend = [[ASIFormDataRequest alloc] initWithURL:deleteUrl];
    deleteFriend.tag = AXMessageCenterHttpRequestTypeDeleteFriend;
    NSMutableData *deleteFriendData = [[deleteAarray dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [deleteFriend setPostBody:deleteFriendData];
    [deleteFriend addRequestHeader:@"Content-Type" value:@"application/json"];
    [deleteFriend addRequestHeader:@"Cache-Control" value:@"no-cache"];
    [deleteFriend setRequestMethod:@"POST"];
    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
    if (loginResult[@"auth_token"]) {
        [deleteFriend addRequestHeader:@"AuthToken" value:loginResult[@"auth_token"]];
    }
    [self.dataCenter willDeleteFriendWithUidList:deleteUid];
    deleteFriend.delegate = self;
    NSLog(@"====delete url  %@",deleteUrl);
    [deleteFriend startAsynchronous];
}

- (void)fetchedPersonWithUID:(NSString *)uid withBlock:(void (^)(AXMappedPerson *))personInfoBlock
{
    _personInfoBlock = personInfoBlock;
    AXMappedPerson *person = [self.dataCenter fetchPersonWithUID:uid];
    personInfoBlock(person);
#warning waiting to finish get user info api
}

- (void)deleteMessageByIdentifier:(NSString *)identifier
{
    [self.dataCenter deleteMessageByIdentifier:identifier];
}

- (NSFetchedResultsController *)conversationListFetchedResultController
{
    return [self.dataCenter conversationListFetchedResultController];
}

- (NSString *)theLastMessageIDinCoreData
{
    return [self.dataCenter lastMsgId];
}
- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid
{
    return  [self.dataCenter fetchPersonWithUID:uid];
}

- (void)searchBrokerByBrokerPhone:(NSString *)brokerPhone compeletionBlock:(void (^)(AXMappedPerson *))searchBrokerBlock
{
    _searchBrokerBlock = searchBrokerBlock;
    self.searchBrokerManager.apiParams = @{@"brokerPhone":brokerPhone};
    [self.searchBrokerManager loadData];
}
- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void (^)(NSArray *, AXMappedMessage *, AXMappedPerson *))fetchedChatList
{
    _fetchedChatList = fetchedChatList;
    [self.dataCenter fetchChatListByLastMessage:lastMessage pageSize:pageSize];
    
}

- (AXMappedPerson *)fetchCurrentPerson
{
    return [self.dataCenter fetchCurrentPerson];
}

#pragma mark - AXChatDataCenterDelegate
- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchChatList:(NSArray *)chatList withFriend:(AXMappedPerson *)person lastMessage:(AXMappedMessage *)message
{
    _fetchedChatList(chatList,message,person);
}

- (void)friendListWithPersonWithCompeletionBlock:(void (^)(NSArray *, BOOL))friendListBlock
{
    _friendListBlock = friendListBlock;
    NSArray *friendListArray = [self.dataCenter fetchFriendList];
    _friendListBlock(friendListArray,YES);
    NSDictionary *params = @{@"phone": self.currentPerson.phone};
    self.friendListManager.apiParams = params;
    [self.friendListManager loadData];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
        
    }
    if (request.tag == AXMessageCenterHttpRequestTypeDeleteFriend) {
        
    }
    if (request.tag == AXMessageCenterHttpRequestTypeUploadImage) {
        
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
        _addFriendByQRCode(YES);
    }
    if (request.tag == AXMessageCenterHttpRequestTypeDeleteFriend) {
        
    }
    if (request.tag == AXMessageCenterHttpRequestTypeUploadImage) {
        
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeDeleteFriend) {
        
    }
    if (request.tag == AXMessageCenterHttpRequestTypeUploadImage) {
        
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
//        _addFriendByQRCode(NO);
    }
    if (request.tag == AXMessageCenterHttpRequestTypeDeleteFriend) {
        __autoreleasing NSError *error;
        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"OK"]) {
            if ([receiveDic[@"result"] isKindOfClass:[NSArray class]]) {
                [self.dataCenter didDeleteFriendWithUidList:receiveDic[@"result"]];
            }
            if (receiveDic[@"result"] && [receiveDic[@"result"] isKindOfClass:[NSString class]]) {
                NSArray *array = @[receiveDic[@"result"]];
                [self.dataCenter didDeleteFriendWithUidList:array];
            }
        }
    }
    if (request.tag == AXMessageCenterHttpRequestTypeUploadImage) {
        __autoreleasing NSError *error;
        NSString *imageUrl;
        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"ok"]) {
            NSDictionary *image = receiveDic[@"image"];
            imageUrl = [NSString stringWithFormat:@"http://pic%@.ajkimg.com/display/%@/133x100.jpg",image[@"host"],image[@"id"]];
        }
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"msg_type"] = [NSString stringWithFormat:@"%@",self.imageMessage.messageType];
        params[@"phone"] = self.currentPerson.phone;
        params[@"to_uid"] = self.imageMessage.to;
        params[@"uniqid"] = self.imageMessage.identifier;
        params[@"body"] = imageUrl;
        
        self.sendMessageManager.apiParams = params;
        [self.sendMessageManager loadData];

        
    }
}
#pragma mark - ASIProgressDelegate

#pragma mark - AIFMessageManagerDelegate
- (void)manager:(AXMessageManager *)manager didRegisterDevice:(NSString *)deviceId userId:(NSString *)userId receivedData:(NSData *)data
{
    __autoreleasing NSError *error;
    
    NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"receiveDic  ===== %@",receiveDic);
    
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"INITED"]) {
        NSLog(@"INITED");
    }
    
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"BYE"]) {
        NSLog(@"BYE");
    }
    
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"TIMEOUT"]) {
        NSLog(@"TIMEOUT");
    
    }
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"QUIT"]) {
        NSLog(@"QUIT");

    }
    
    if ([receiveDic[@"result"] isKindOfClass:[NSDictionary class]] && [receiveDic[@"result"][@"msgType"] isEqualToString:@"chat"]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"] = self.currentPerson.phone;
        params[@"last_max_msgid"] =[self theLastMessageIDinCoreData];
        self.receiveMessageManager.apiParams = params;
        [self.receiveMessageManager loadData];
    }
}

- (void)manager:(AXMessageManager *)manager didHeartBeatWithDevice:(NSString *)deviceId userId:(NSString *)userId receivedData:(NSData *)data
{
    
}

#pragma mark - AIFMessageSenderDelegate
- (void)manager:(AXMessageManager *)manager didSendMessage:(NSString *)message toUserId:(NSString *)userId receivedData:(NSData *)data
{
    
}
@end
