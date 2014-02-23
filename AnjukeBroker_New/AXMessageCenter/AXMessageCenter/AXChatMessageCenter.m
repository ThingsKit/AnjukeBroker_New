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
#import "AXMessageCenterUpdataUserInformationManager.h"
#import "AXMessageCenterUpdataPasswordManager.h"
#import "AXMessageCenterDeleteFriendManager.h"
#import "AXMessageCenterAddFriendManager.h"
#import "AXMessageCenterSearchBrokerManager.h"
#import "AXMessageCenterGetUserOldMessageManager.h"
#import "AXMessageCenterModifyFriendInfoManager.h"

static NSString * const kMessageCenterReceiveMessageTypeText = @"1";
static NSString * const kMessageCenterReceiveMessageTypeProperty = @"2";
static NSString * const UID = @"234234234";
static NSUInteger imageRequestID = 4;

@interface AXChatMessageCenter ()<AIFMessageManagerDelegate,AIFMessageSenderDelegate,RTAPIManagerApiCallBackDelegate,RTAPIManagerInterceptorProtocal, AXChatDataCenterDelegate>
@property (nonatomic, strong) AXMessageManager *messageManager;
@property (nonatomic, strong) ASIHTTPRequest *QRCodeRequest;
@property (nonatomic, strong) AXChatDataCenter *dataCenter;
@property (nonatomic, strong) NSOperationQueue *imageMessageOperation;
@property (nonatomic, strong) NSMutableArray *messsageIdentity;
@property (nonatomic, strong) NSMutableDictionary *blockDictionary;

//property
@property (nonatomic, strong) NSString *addFriendByID;

//manager
@property (nonatomic, strong) AXMessageCenterSendMessageManager *sendMessageManager;
@property (nonatomic, strong) AXMessageCenterReceiveMessageManager *receiveMessageManager;
@property (nonatomic, strong) AXMessageCenterFriendListManager *friendListManager;
@property (nonatomic, strong) AXMessageCenterUpdataUserInformationManager *updateUserInfoManager;
@property (nonatomic, strong) AXMessageCenterUpdataPasswordManager *updatePasswordManager;
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
@property (nonatomic, strong) void (^updatePWDBlock)(BOOL isSuccess);
@property (nonatomic, strong) void (^updateUserInfo)(BOOL isSuccess);
@property (nonatomic, strong) void (^addFriendBlock)(BOOL isSuccess);
@property (nonatomic, strong) void(^deleteFriendBlock)(BOOL isSuccess);

@property (nonatomic, strong) AXMappedPerson *currentPerson;
@end

@implementation AXChatMessageCenter

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
        [self.messageManager bindServerHost:kAXMessageCenterLinkParamHost port:kAXMessageCenterLinkParamPort appName:kAXMessageCenterLinkAppName timeout:2.0f];
//        [self.messageManager registerDevices:[[UIDevice currentDevice] udid] userId:@""];
        
        self.imageMessageOperation = [[NSOperationQueue alloc] init];
        self.imageMessageOperation.maxConcurrentOperationCount = 1;
        
        self.messsageIdentity = [[NSMutableArray alloc] init];
        self.blockDictionary = [[NSMutableDictionary alloc] init];
        
        self.dataCenter = [[AXChatDataCenter alloc] initWithUID:@"1"];
        self.dataCenter.delegate = self;
        self.currentPerson = [self.dataCenter fetchCurrentPerson];
        
    }
    return self;
}

#pragma test method
- (void)receiveMessage
{
    dispatch_async(dispatch_get_main_queue(),^{
        CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef strRef = CFUUIDCreateString(kCFAllocatorDefault, uuidObj);
        NSString *uuidString = [NSString stringWithString:(NSString*)CFBridgingRelease(strRef)];
        
        CFUUIDRef uuidObj2 = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef strRef2 = CFUUIDCreateString(kCFAllocatorDefault, uuidObj2);
        NSString *uuidString2 = [NSString stringWithString:(NSString*)CFBridgingRelease(strRef2)];

        AXMappedMessage *message = [[AXMappedMessage alloc] init];
        message.accountType = @"1";
        message.from = @"11";
        message.identifier = uuidString;
        message.messageType = AXMessageTypeText;
        message.content = @"add 1";
        
        AXMappedMessage *message2 = [[AXMappedMessage alloc] init];
        message2.accountType = @"1";
        message2.from = @"11";
        message2.identifier = uuidString2;
        message2.messageType = AXMessageTypeText;
        message2.content = @"add 2";
        CFRelease(uuidObj);
        CFRelease(uuidObj2);

        NSArray *array = @[message,message2];
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:array];
    });

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

- (AXMessageCenterUpdataUserInformationManager *)updateUserInfoManager
{
    if (!_updateUserInfoManager) {
        _updateUserInfoManager = [[AXMessageCenterUpdataUserInformationManager alloc] init];
        _updateUserInfoManager.delegate = self;
    }
    return _updateUserInfoManager;
}

- (AXMessageCenterUpdataPasswordManager *)updatePasswordManager
{
    if (!_updatePasswordManager ) {
        _updatePasswordManager = [[AXMessageCenterUpdataPasswordManager alloc] init];
        _updatePasswordManager.delegate = self;
        _updatePasswordManager.validator = _updatePasswordManager;
        _updatePasswordManager.paramSource = _updatePasswordManager;
    }
    return _updatePasswordManager;
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
    }
    return _searchBrokerManager;
}

- (AXMessageCenterGetUserOldMessageManager *)getOldMessageManager
{
    if (!_getOldMessageManager) {
        _getOldMessageManager = [[AXMessageCenterGetUserOldMessageManager alloc] init];
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
                        [self.dataCenter updateMessage:mappedMessage];
                        _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusSuccessful);
                    }
                }
            }else if (response.status == RTNetworkResponseStatusFailed) {
                if (self.blockDictionary[identify]) {
                    mappedMessage.sendStatus = @(AXMessageCenterSendMessageStatusFailed);
                    [self.dataCenter updateMessage:mappedMessage];
                    _finishSendMessageBlock = self.blockDictionary[identify];
                    _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusFailed);
                }
            } else if (response.status == RTNetworkResponseStatusJsonError){
                if (self.blockDictionary[identify]) {
                    mappedMessage.sendStatus = @(AXMessageCenterSendMessageStatusFailed);
                    [self.dataCenter updateMessage:mappedMessage];
                    _finishSendMessageBlock = self.blockDictionary[identify];
                    _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusFailed);
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
        dispatch_async(dispatch_get_main_queue(),^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:dic];
            AXMappedMessage *receiveMessage = [[AXMappedMessage alloc] initWithDictionary:dic];
            [self.dataCenter updateMessage:receiveMessage];
        });
    }
    if ([manager isKindOfClass:[AXMessageCenterFriendListManager class]]) {
        NSArray *friendList = [manager fetchDataWithReformer:nil];
        [self.dataCenter saveFriendListWithPersonArray:friendList];
        if (_friendListBlock) {
            _friendListBlock(friendList,YES);
        }
        
    }
    if ([manager isKindOfClass:[AXMessageCenterUpdataPasswordManager class]]) {
        _updatePWDBlock(YES);
    }
    if ([manager isKindOfClass:[AXMessageCenterUpdataUserInformationManager class]]) {

    }
    if ([manager isKindOfClass:[AXMessageCenterAddFriendManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
#warning todo 如果成功，则需要添加成功的好友的uid
        NSString *uid = @"1";
        AXMappedPerson *mappedPerson = [self.dataCenter fetchPersonWithUID:uid];
        mappedPerson.isPending = @(NO);
        [self.dataCenter updatePerson:mappedPerson];
        if (dic[@"result"] && [dic[@"result"] isEqualToString:@"true"]) {
            
        }

    }
}
- (void)managerCallAPIDidFailed:(RTAPIBaseManager *)manager
{
    if ([manager isKindOfClass:[AXMessageCenterUpdataPasswordManager class]]) {
        _updatePWDBlock(NO);
    }
    if ([manager isKindOfClass:[AXMessageCenterUpdataUserInformationManager class]]) {
        _updateUserInfo(NO);
    }
    if ([manager isKindOfClass:[AXMessageCenterAddFriendManager class]]) {
        _addFriendBlock(NO);
    }

}

#pragma mark - selfMethod
- (void)closeKeepAlivingConnect
{
    
}

- (void)cancelAllRequest
{
    [[RTApiRequestProxy sharedInstance] cancelAllRequest];
}

- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter addMessage:message];
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_uid"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    
//    params[@"msg_type"] = @"1";
//    params[@"phone"] = @"13333333333";
//    params[@"to_uid"] = @"30";
//    params[@"uniqid"] = @"sdfsdfsdfg";
//    params[@"body"] = @"34f34f34f34sdfr4f";
    
    self.sendMessageManager.apiParams = params;
    [self.sendMessageManager loadData];
}

- (void)sendImage:(NSDictionary *)message withCompeletionBlock:(void (^)(AXMappedMessage *, BOOL))sendImageBlock
{
    NSURL *upLoadUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://upd1.ajkimg.com/upload"]];
    
    ASIFormDataRequest *imageRequest = [[ASIFormDataRequest alloc] initWithURL:upLoadUrl];
    imageRequest.tag = imageRequestID;
    [imageRequest setPostValue:message[@"image"] forKey:@"image"];
    imageRequest.delegate = self;
    
    [self.imageMessageOperation addOperation:imageRequest];
    
    
}

- (void)updataUserPassword:(NSString *)newPassWord compeletionBlock:(void (^)(BOOL))updatePWDBlock
{
    _updatePWDBlock = updatePWDBlock;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = UID;
    params[@"password"] = newPassWord;
    self.updatePasswordManager.apiParams = params;
    [self.updatePasswordManager loadData];
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
    
//    person.isPending = @(YES);
//    [self.dataCenter addFriend:person];
    
    self.addFriendManager.apiParams = @{
                                        @"phone":@"13333333333",
                                        @"touid":@"30"
                                        };
    [self.addFriendManager loadData];
}

- (void)removeFriendWithMyPhone:(NSString *)phone deleteUid:(NSString *)phone2 compeletionBlock:(void (^)(BOOL))deleteFriendBlock
{
    _deleteFriendBlock = deleteFriendBlock;
    self.deleteFriendManager.apiParams = @{@"phone": @"13333333333"};
    self.deleteFriendManager.deleteList = @[@"2342342342",@"4323423423"];
    [self.deleteFriendManager loadData];
    
    
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

- (AXMappedPerson *)fetchPersonWithUID:(NSString *)uid
{
    return  [self.dataCenter fetchPersonWithUID:uid];
}

- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void (^)(NSArray *, AXMappedMessage *, AXMappedPerson *))fetchedChatList
{
    _fetchedChatList = fetchedChatList;
    [self.dataCenter fetchChatListByLastMessage:lastMessage pageSize:pageSize];
    
}
#pragma mark - AXChatDataCenterDelegate
- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchChatList:(NSArray *)chatList withFriend:(AXMappedPerson *)person lastMessage:(AXMappedMessage *)message
{
    _fetchedChatList(chatList,message,person);
}

- (void)friendListWithPerson:(AXMappedPerson *)person compeletionBlock:(void (^)(NSArray *, BOOL))friendListBlock
{
    _friendListBlock = friendListBlock;
    NSArray *friendListArray = [self.dataCenter fetchFriendList];
    _friendListBlock(friendListArray,YES);
    NSDictionary *params = @{@"phone": person.phone};
    self.friendListManager.apiParams = params;
    [self.friendListManager loadData];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
        
    }
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
        _addFriendByQRCode(YES);
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
        _addFriendByQRCode(NO);
#warning waint for api back data and add to datacenter;
    }
    if (request.tag == imageRequestID) {
#warning waiting for finished
    }
}
#pragma mark - ASIProgressDelegate

#pragma mark - AIFMessageManagerDelegate
- (void)manager:(AXMessageManager *)manager didRegisterDevice:(NSString *)deviceId userId:(NSString *)userId receivedData:(NSData *)data
{
    __autoreleasing NSError *error;
    NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@" receive data is error %@",error);
    }
    if (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"OK"]) {
//        if (receiveDic[@"result"] && [receiveDic[@"result"][@"msgType"] isEqualToString:@"chat"]) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
#warning hope login success share a global method to return current user iphone
            params[@"phone"] = UID;
            self.receiveMessageManager.apiParams = params;
            [self.receiveMessageManager loadData];
//        }
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
