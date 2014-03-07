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
//#import "MemberUtil.h"

//managerCenter manager
#import "AXMessageCenterSendMessageManager.h"
#import "AXMessageCenterReceiveMessageManager.h"
#import "AXMessageCenterFriendListManager.h"
#import "AXMessageCenterDeleteFriendManager.h"
#import "AXMessageCenterAddFriendManager.h"
#import "AXMessageCenterSearchBrokerManager.h"
#import "AXMessageCenterGetUserOldMessageManager.h"
#import "AXMessageCenterModifyFriendInfoManager.h"
#import "AXMessageCenterGetFriendInfoManager.h"
#import "AXMessageCenterUserToPublicServiceManager.h"
#import "AXMessageCenterAppGetAllMessageManager.h"
#import "AXMessageCenterUserGetPublicServiceInfoManager.h"

static NSString * const kMessageCenterReceiveMessageTypeText = @"1";
static NSString * const kMessageCenterReceiveMessageTypeProperty = @"2";
static NSString * const ImageServeAddress = @"http://upd1.ajkimg.com/upload";

@interface AXChatMessageCenter ()<AIFMessageManagerDelegate,RTAPIManagerApiCallBackDelegate,RTAPIManagerInterceptorProtocal, AXChatDataCenterDelegate>
@property (nonatomic, strong) AXMessageManager *messageManager;
@property (nonatomic, strong) ASIHTTPRequest *QRCodeRequest;
@property (nonatomic, strong) AXChatDataCenter *dataCenter;
@property (nonatomic, strong) NSOperationQueue *imageMessageOperation;
@property (nonatomic, strong) NSMutableArray *messsageIdentity;
@property (nonatomic, strong) NSMutableDictionary *blockDictionary;
@property (nonatomic, strong) NSMutableArray *sendImageArray;
@property (nonatomic, strong) NSMutableArray *imageMessageArray;


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
@property (nonatomic, strong) AXMessageCenterGetFriendInfoManager *getFriendInfoManager;
@property (nonatomic, strong) AXMessageCenterUserToPublicServiceManager *sendMessageToPublic;
@property (nonatomic, strong) AXMessageCenterAppGetAllMessageManager *appGetAllNewMessage;
@property (nonatomic, strong) AXMessageCenterUserGetPublicServiceInfoManager *userGetServiceInfo;

@property (nonatomic ,strong) void (^fetchedChatList)(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend);
@property (nonatomic, strong) void (^finishSendMessageBlock)(AXMappedMessage *message,AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType);
@property (nonatomic, strong) void (^friendListBlock)(NSArray *friendList,BOOL whetherSuccess);
@property (nonatomic, strong) void (^searchBrokerBlock)(AXMappedPerson *brokerInfo);
@property (nonatomic, strong) void (^getUserOldMessageBlock)(NSArray *messageArray);
@property (nonatomic, strong) void (^getFriendInfoBlock)(NSArray *friendInfo);
@property (nonatomic, strong) void (^addFriendByQRCode)(AXMappedPerson *person);
@property (nonatomic, strong) void (^personInfoBlock)(AXMappedPerson *person);
@property (nonatomic, strong) void (^updateUserInfo)(BOOL isSuccess);
@property (nonatomic, strong) void (^addFriendBlock)(BOOL isSuccess);
@property (nonatomic, strong) void (^deleteFriendBlock)(BOOL isSuccess);


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
        
        self.imageMessageOperation = [[NSOperationQueue alloc] init];
        self.imageMessageOperation.maxConcurrentOperationCount = 1;
        
        self.messsageIdentity = [[NSMutableArray alloc] init];
        self.sendImageArray = [[NSMutableArray alloc] init];
        self.blockDictionary = [[NSMutableDictionary alloc] init];
        self.imageMessageArray = [[NSMutableArray alloc] init];
        
        self.linkStatus = AXMessageCenterLinkStatusNoLink;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectToServer) name:@"LOGIN_NOTIFICATION" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOut) name:@"LOGOUT_NOTIFICATION" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoChanged) name:@"USERINFO_CHANGED_NOTIFICATION" object:nil];

    }
    return self;
}

- (void)userInfoChanged
{
    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
    self.dataCenter = [[AXChatDataCenter alloc] initWithUID:loginResult[@"user_info"][@"user_id"]];
    AXMappedPerson *mySelf = [[AXMappedPerson alloc] init];
    mySelf.uid = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"user_id"]];
    mySelf.phone = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"phone"]];
    mySelf.markName = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name"]];
    mySelf.iconUrl = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"icon"]];
    mySelf.markNamePinyin = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name_pinyin"]];
    mySelf.userType = [loginResult[@"user_info"][@"user_type"] integerValue];
    [self.dataCenter updatePerson:mySelf];
}

- (void)userLoginOut
{
    self.linkStatus = AXMessageCenterLinkStatusNoLink;
    [self breakLink];
}

- (void)connect
{
    [self connectToServer];
}
- (void)breakLink
{
    self.linkStatus = AXMessageCenterLinkStatusNoLink;
    self.messageManager.isLinking = NO;
    [self.messageManager cancelKeepAlivingConnection];
}

/*
 UID不用来区分设备登录或用户登录，使用link status来进行区分。当需要用户登录的时候，uid也可以为0，但是link status必须为用户登录状态。
 */
- (void)buildLongLinkWithUserId:(NSString *)uid
{
    return;
    //如果链接已经建立，则退出函数
    if (self.linkStatus == AXMessageCenterLinkStatusLinkedAsDevice) {
        return;
    }
    self.linkStatus = AXMessageCenterLinkStatusWillLinkAsDevice;
    self.dataCenter = [[AXChatDataCenter alloc] initWithUID:uid];
    self.dataCenter.delegate = self;
    self.currentPerson = [self.dataCenter fetchPersonWithUID:uid];
    if (self.currentPerson == nil) {
        self.currentPerson = [[AXMappedPerson alloc] init];
    }
    self.currentPerson.uid = uid;
    [self.dataCenter updatePerson:self.currentPerson];

    
    // 建立长链接
    self.messageManager.isLinking = YES;
    self.messageManager.registerStatus = AIF_MESSAGE_REQUEST_REGISTER_FINISHED;
    [self.messageManager bindServerHost:kAXMessageCenterLinkParamHost port:kAXMessageCenterLinkParamPort appName:kAXMessageCenterLinkAppName timeout:350];
    [self.messageManager registerDevices:[[UIDevice currentDevice] udid] userId:self.currentPerson.uid];
    
    // 注册推送
    NSString *notificationToken = [[NSUserDefaults standardUserDefaults] objectForKey:REMOTE_NOTIFCATION_TOKEN];
    NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
    [bodys setValue:Code_AppName forKey:@"appName"];
    [bodys setValue:[[UIDevice currentDevice] uuid] forKey:@"uuid"];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [bodys setValue:@"" forKey:@"macAddress"];
    } else {
        [bodys setValue:[[UIDevice currentDevice] macaddress] forKey:@"macAddress"];
    }
    [bodys setValue:self.currentPerson.uid forKey:@"userId"];
    [[RTRequestProxy sharedInstance] asyncRESTNotificationWithBodys:bodys token:notificationToken target:self action:@selector(registerNotificationFinish:)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status": @(AIFMessageCenterStatusConnecting)}];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidInitedDataCenter object:nil];
}

- (void)connectToServer
{
#warning rebuild
    if (self.linkStatus == AXMessageCenterLinkStatusLinkedAsUser) {
        return;
    }
    self.linkStatus = AXMessageCenterLinkStatusWillLinkAsUser;
    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
    self.dataCenter = [[AXChatDataCenter alloc] initWithUID:loginResult[@"user_info"][@"user_id"]];
    AXMappedPerson *mySelf = [[AXMappedPerson alloc] init];
    mySelf.uid = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"user_id"]];
    mySelf.phone = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"phone"]];
    mySelf.markName = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name"]];
    mySelf.iconUrl = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"icon"]];
    mySelf.markNamePinyin = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name_pinyin"]];
    mySelf.userType = [loginResult[@"user_info"][@"user_type"] integerValue];
    
    [self.dataCenter updatePerson:mySelf];
    
    self.dataCenter.delegate = self;
    self.currentPerson = mySelf;
    self.messageManager.isLinking = YES;
    self.messageManager.registerStatus = AIF_MESSAGE_REQUEST_REGISTER_FINISHED;
    [self.messageManager bindServerHost:kAXMessageCenterLinkParamHost port:kAXMessageCenterLinkParamPort appName:kAXMessageCenterLinkAppName timeout:350];
    [self.messageManager registerDevices:[[UIDevice currentDevice] udid] userId:self.currentPerson.uid];
    
    // 注册推送
    NSString *notificationToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"AJKNotificationToken"];
    NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
    [bodys setValue:Code_AppName forKey:@"appName"];
    [bodys setValue:[[UIDevice currentDevice] uuid] forKey:@"uuid"];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [bodys setValue:@"" forKey:@"macAddress"];
    } else {
        [bodys setValue:[[UIDevice currentDevice] macaddress] forKey:@"macAddress"];
    }
    [bodys setValue:mySelf.uid forKey:@"userId"];
    [[RTRequestProxy sharedInstance] asyncRESTNotificationWithBodys:bodys token:notificationToken target:self action:@selector(registerNotificationFinish:)];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status": @(AIFMessageCenterStatusConnecting)}];
    });

    [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidInitedDataCenter object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (AXMessageCenterGetFriendInfoManager *)getFriendInfoManager
{
    if (!_getFriendInfoManager) {
        _getFriendInfoManager = [[AXMessageCenterGetFriendInfoManager alloc] init];
        _getFriendInfoManager.paramSource = _getFriendInfoManager;
        _getFriendInfoManager.validator = _getFriendInfoManager;
        _getFriendInfoManager.delegate = self;
    }
    return _getFriendInfoManager;
}

- (AXMessageCenterUserToPublicServiceManager *)sendMessageToPublic
{
    if (!_sendMessageToPublic) {
        _sendMessageToPublic = [[AXMessageCenterUserToPublicServiceManager alloc] init];
        _sendMessageToPublic.validator = _sendMessageToPublic;
        _sendMessageToPublic.paramSource = _sendMessageToPublic;
        _sendMessageToPublic.delegate = self;
    }
    return _sendMessageToPublic;
}

- (AXMessageCenterAppGetAllMessageManager *)appGetAllNewMessage
{
    if (!_appGetAllNewMessage) {
        _appGetAllNewMessage = [[AXMessageCenterAppGetAllMessageManager alloc] init];
        _appGetAllNewMessage.delegate = self;
        _appGetAllNewMessage.paramSource = _appGetAllNewMessage;
        _appGetAllNewMessage.validator = _appGetAllNewMessage;
    }
    
    return _appGetAllNewMessage;
}

- (AXMessageCenterUserGetPublicServiceInfoManager *)userGetServiceInfo
{
    if (!_userGetServiceInfo) {
        _userGetServiceInfo = [[AXMessageCenterUserGetPublicServiceInfoManager alloc] init];
        _userGetServiceInfo.validator = _userGetServiceInfo;
        _userGetServiceInfo.delegate = self;
        _userGetServiceInfo.paramSource = _userGetServiceInfo;
    }
    
    return _userGetServiceInfo;
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
                        _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusSuccessful,AXMessageCenterSendMessageErrorTypeCodeNone);
                        [self.blockDictionary removeObjectForKey:identify];
                    }
                } else if (response.content[@"status"] && [response.content[@"status"] isEqualToString:@"ERROR"]){
                    if (response.content[@"errorCode"] && [response.content[@"errorCode"] isEqualToString:@"100016"] ) {
                        _finishSendMessageBlock = self.blockDictionary[identify];
                        //xiao fengdeng you know that, it should be failed not success!!!!
                        mappedMessage.sendStatus = @(AXMessageCenterSendMessageStatusSuccessful);
                        mappedMessage.messageId = [NSNumber numberWithInt:[response.content[@"result"] integerValue]];
                        [self.dataCenter didFailSendMessageWithIdentifier:[NSString stringWithFormat:@"%@",mappedMessage.messageId]];
                        _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeNotFriend);
                        [self.blockDictionary removeObjectForKey:identify];
                    }
                }
            }else if (response.status == RTNetworkResponseStatusFailed || response.status == RTNetworkResponseStatusJsonError) {
                if (self.blockDictionary[identify]) {
                    mappedMessage.sendStatus = @(AXMessageCenterSendMessageStatusFailed);
                    [self.dataCenter didFailSendMessageWithIdentifier:[NSString stringWithFormat:@"%@",mappedMessage.messageId]];
                    _finishSendMessageBlock = self.blockDictionary[identify];
                    _finishSendMessageBlock(mappedMessage,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeFailed);
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
        [self.dataCenter didReceiveWithMessageDataArray:dic[@"result"]];
    }
    
    if ([manager isKindOfClass:[AXMessageCenterAppGetAllMessageManager class]]) {
        NSDictionary *dic  = [manager fetchDataWithReformer:nil];
        [self.dataCenter didReceiveWithMessageDataArray:dic[@"result"]];
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
            if ([dic[@"result"] isKindOfClass:[NSArray class]]) {
                NSArray *array = dic[@"result"];
                if ([array count] >= 1) {
                    AXMappedPerson *person = [[AXMappedPerson alloc] initWithDictionary:[array firstObject]];
                    _searchBrokerBlock(person);
                }else{
                    _searchBrokerBlock(nil);
                }
            }else {
                AXMappedPerson *person = [[AXMappedPerson alloc] initWithDictionary:dic[@"result"]];
                _searchBrokerBlock(person);
            }
        }
    }
    if ([manager isKindOfClass:[AXMessageCenterGetFriendInfoManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if (dic[@"status"] && [dic[@"status"] isEqualToString:@"OK"] && dic[@"result"] && [dic[@"result"] isKindOfClass:[NSArray class]]) {
            
            NSMutableArray *persons = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *personData in dic[@"result"]) {
                AXMappedPerson *person = [[AXMappedPerson alloc] initWithDictionary:personData];
                [self.dataCenter updatePerson:person];
                [persons addObject:person];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidUpdataFriendInformationNotication object:persons];
            });
            
            if (_getFriendInfoBlock) {
                _getFriendInfoBlock(persons);
                _getFriendInfoBlock = nil;
            }
        }
    }
    
    if ([manager isKindOfClass:[AXMessageCenterDeleteFriendManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if (dic[@"status"] && [dic[@"status"] isEqualToString:@"OK"]) {
            NSArray *array = dic[@"result"];
            [self.dataCenter didDeleteFriendWithUidList:array];
            _deleteFriendBlock(YES);
        } else {
#warning crash here, when delete a public service id
            _deleteFriendBlock(NO);
        }
    }
    if ([manager isKindOfClass:[AXMessageCenterGetUserOldMessageManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil];
        if (dic[@"status"] && [dic[@"status"] isEqualToString:@"OK"]) {
            NSArray *array = dic[@"result"];
#warning wating for master casa to finish it
        }
    }
    if ([manager isKindOfClass:[AXMessageCenterUserGetPublicServiceInfoManager class]]) {
        NSDictionary *dic = [manager fetchDataWithReformer:nil][@"result"];
        AXMappedPerson *person = [[AXMappedPerson alloc] init];
        person.uid = dic[@"user_id"];
        person.markDesc = dic[@"desc"];
        person.iconUrl = dic[@"icon"];
        person.isIconDownloaded = NO;
        person.name = dic[@"nick_name"];
        person.userType = [dic[@"user_type"] integerValue];
        [self.dataCenter updatePerson:person];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidUpdataFriendInformationNotication object:@[person]];
    });
    }
}

- (void)managerCallAPIDidFailed:(RTAPIBaseManager *)manager
{
    if ([manager isKindOfClass:[AXMessageCenterAddFriendManager class]]) {
        _addFriendBlock(NO);
    }
    if ([manager isKindOfClass:[AXMessageCenterReceiveMessageManager class]]) {
        DLog(@"receive message failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterSearchBrokerManager class]]) {
        DLog(@"search broker info failed");
        _searchBrokerBlock(nil);
    }
    if ([manager isKindOfClass:[AXMessageCenterDeleteFriendManager class]]) {
        _deleteFriendBlock(NO);
        DLog(@"DELETE FRIEND FAILED");
    }
    if ([manager isKindOfClass:[AXMessageCenterGetUserOldMessageManager class]]) {
        DLog(@"get user old message failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterGetFriendInfoManager class]]) {
        DLog(@"get friend info failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterFriendListManager class]]) {
        DLog(@"get friendlist message failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterUserGetPublicServiceInfoManager class]]) {
        DLog(@"get public service info failed");
    }
}

#pragma mark - CoreData Method
- (AXMappedConversationListItem *)fetchConversationListItemWithFriendUID:(NSString *)friendUID
{
    return [self.dataCenter fetchConversationListItemWithFriendUID:friendUID];
}

- (void)saveDraft:(NSString *)content friendUID:(NSString *)friendUID
{
    [self.dataCenter saveDraft:content friendUID:friendUID];
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

- (NSInteger)totalUnreadMessageCount
{
    return [self.dataCenter totalUnreadMessageCount];
}

- (AXMappedPerson *)fetchCurrentPerson
{
    return [self.dataCenter fetchCurrentPerson];
}

- (void)deleteConversationItem:(AXMappedConversationListItem *)conversationItem
{
    return [self.dataCenter deleteConversationItem:conversationItem];
}

- (void)didLeaveChattingList
{
    [self.dataCenter didLeaveChattingList];
}

- (NSFetchedResultsController *)friendListFetchedResultController
{
    return [self.dataCenter friendListFetchedResultController];
}

- (void)updatePerson:(AXMappedPerson *)person
{
    [self.dataCenter updatePerson:person];
}

- (NSArray *)picMessageArrayWithFriendUid:(NSString *)friendUid
{
    return [self.dataCenter picMessageArrayWithFriendUid:friendUid];
}

- (void)updateMessage:(AXMappedMessage *)message
{
    [self.dataCenter updateMessage:message];
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

- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus ,AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter willSendMessage:message];
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageManager isReachable]) {
        sendMessageBlock(dataMessage,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return ;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_uid"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    

    self.sendMessageManager.apiParams = params;
    [self.sendMessageManager loadData];
}

- (void)reSendMessage:(NSString *)identifier willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus,AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identifier];
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageManager isReachable]) {
        sendMessageBlock(dataMessage,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return ;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_uid"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    
    self.sendMessageManager.apiParams = params;
    [self.sendMessageManager loadData];
}

- (void)sendMessageToPublic:(AXMappedMessage *)message willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter willSendMessage:message];
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageToPublic isReachable]) {
        sendMessageBlock(dataMessage,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return ;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_service_id"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    
    self.sendMessageToPublic.apiParams = params;
    [self.sendMessageToPublic loadData];
}

- (void)userReceiveAlivingConnection
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.currentPerson.phone;
    params[@"last_max_msgid"] =[self theLastMessageIDinCoreData];
    self.receiveMessageManager.apiParams = params;
    [self.receiveMessageManager loadData];
}
- (void)appReceiveAlivingConnection
{
    NSMutableDictionary *params =[NSMutableDictionary dictionary];
    params[@"to_device_id"] = [[UIDevice currentDevice] udid];
    params[@"to_app_name"] = kAXMessageCenterLinkAppName;
    params[@"last_max_msg_id"] = [self.dataCenter lastServiceMsgId];
    self.appGetAllNewMessage.apiParams = params;
    [self.appGetAllNewMessage loadData];
}

- (void)reSendMessageToPublic:(NSString *)identifier willSendMessage:(void (^)(AXMappedMessage *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identifier];
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageToPublic isReachable]) {
        sendMessageBlock(dataMessage,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return ;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_service_id"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    
    self.sendMessageToPublic.apiParams = params;
    [self.sendMessageToPublic loadData];
}

- (void)sendImage:(AXMappedMessage *)message withCompeletionBlock:(void(^)(AXMappedMessage *message, AXMessageCenterSendMessageStatus status,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter willSendMessage:message];
    sendMessageBlock(dataMessage, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    
    [self.sendImageArray addObject:dataMessage];
    NSString *photoUrl = dataMessage.imgPath;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:ImageServeAddress]];
    [request addFile:photoUrl forKey:@"file"];
    [request setUserInfo:@{@"identify": dataMessage.identifier}];
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
    params[@"is_star"] = @(newInformation.isStar);
    params[@"relation_cate_id"] = @"0";
    
    self.modifyFriendInfoManager.apiParams = params;
    [self.modifyFriendInfoManager loadData];
}

- (void)addFriendByQRCode:(NSString *)urlString compeletionBlock:(void (^)(AXMappedPerson *))addFriendByQRCompeletionBlock
{
    _addFriendByQRCode = addFriendByQRCompeletionBlock;
    NSURL *QRCodeUrl = [NSURL URLWithString:urlString];
    self.QRCodeRequest = [[ASIHTTPRequest alloc] initWithURL:QRCodeUrl];
    self.QRCodeRequest.delegate = self;
    self.QRCodeRequest.tag = AXMessageCenterHttpRequestTypeQRCode;
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

- (void)removeFriendBydeleteUid:(NSArray *)deleteUid compeletionBlock:(void(^)(BOOL isSuccess))deleteFriendBlock
{
    _deleteFriendBlock = deleteFriendBlock;
    NSDictionary *params = @{@"phone":self.currentPerson.phone,
                             @"uids":deleteUid
                             };
    self.deleteFriendManager.apiParams = params;
    [self.deleteFriendManager loadData];
    [self.dataCenter willDeleteFriendWithUidList:deleteUid];
}

- (void)getUserOldMessageWithFriendUid:(NSString *)friendUid TopMinMsgId:(NSString *)TopMinMsgId messageIdArray:(NSArray *)messageIdArray compeletionBlock:(void(^)(NSArray *messageArray))getUserOldMessageBlock
{
    _getUserOldMessageBlock = getUserOldMessageBlock;
    NSDictionary *params = @{@"phone": self.currentPerson.phone,
                             @"from_uid":friendUid,
                             @"top_min_msg_id":TopMinMsgId,
                             @"msg_ids":messageIdArray
                             };
    self.getOldMessageManager.apiParams = params;
    [self.getOldMessageManager loadData];
}

- (void)getFriendInfoWithFriendUid:(NSArray *)personUids compeletionBlock:(void (^)(NSArray *))getFriendInfoBlock
{
    self.getFriendInfoManager.apiParams = @{
                                            @"phone":self.currentPerson.phone,
                                            @"to_uids":personUids
                                            };
    _getFriendInfoBlock = getFriendInfoBlock;
    NSMutableArray *personArray =[NSMutableArray array];
    [personUids enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *uid = (NSString *)obj;
        AXMappedPerson *person = [self.dataCenter fetchPersonWithUID:uid];
        [personArray addObject:person];
    }];
    getFriendInfoBlock(personArray);
    [self.getFriendInfoManager loadData];
}

- (void)getServiceInfoByServiceID:(NSString *)serviceId
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"service_id"] = serviceId;
    self.userGetServiceInfo.apiParams = dic;
    [self.userGetServiceInfo loadData];
}
- (void)getFriendInfoWithFriendUid:(NSArray *)personUids
{
    self.getFriendInfoManager.apiParams = @{@"phone":self.currentPerson.phone,@"to_uids":personUids};
    [self.getFriendInfoManager loadData];
}

- (void)searchBrokerByBrokerPhone:(NSString *)brokerPhone compeletionBlock:(void (^)(AXMappedPerson *))searchBrokerBlock
{
    _searchBrokerBlock = searchBrokerBlock;
    self.searchBrokerManager.apiParams = @{@"brokerPhone":brokerPhone};
    [self.searchBrokerManager loadData];
}

- (void)fetchChatListWithLastMessage:(AXMappedMessage *)lastMessage pageSize:(NSUInteger)pageSize callBack:(void (^)(NSDictionary *, AXMappedMessage *, AXMappedPerson *))fetchedChatList
{
    _fetchedChatList = fetchedChatList;
    [self.dataCenter fetchChatListByLastMessage:lastMessage pageSize:pageSize];
    
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

#pragma mark - save image in app method
- (void)downLoadImageInOperationQueueWithMessage:(AXMappedMessage *)message
{
    NSString *imageString = [NSString stringWithFormat:@"%@",message.imgUrl];
    NSArray *array = [imageString componentsSeparatedByString:@"/"];
    NSString *sizeString = [array lastObject];
    NSArray *array2 = [sizeString componentsSeparatedByString:@"."];
    NSString *size = [array2 firstObject];
    NSString *sizeWith = [[size componentsSeparatedByString:@"x"] firstObject];
    NSString *sizeHeigh = [[size componentsSeparatedByString:@"x"] lastObject];
    
    NSUInteger setSizeOfWidth;
    NSUInteger setSizeOfHeigh;

    if ([sizeWith integerValue] > 240) {
        setSizeOfWidth = 240;
    }else
    {
        setSizeOfWidth = [sizeWith integerValue];
    }
    if ([sizeHeigh integerValue] > 240) {
        setSizeOfHeigh= 240;
    }else
    {
        setSizeOfHeigh = [sizeHeigh integerValue];
    }
    NSString *finishString = [[NSString alloc] init];
    for (int i = 0; i <= 4; i++) {
        finishString = [finishString stringByAppendingFormat:@"%@/",array[i]];
    }
    finishString = [finishString stringByAppendingFormat:@"%dx%d.jpg",setSizeOfWidth,setSizeOfHeigh];
    
    
    
    NSURL *imageUrl = [[NSURL alloc] initWithString:finishString];
    ASIHTTPRequest *imageDownLoadRequest = [[ASIHTTPRequest alloc] initWithURL:imageUrl];
    [imageDownLoadRequest setCacheStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
    imageDownLoadRequest.tag = [message.messageId integerValue];
    imageDownLoadRequest.delegate = self;
    [self.imageMessageOperation addOperation:imageDownLoadRequest];
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jgp"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"image is not jpg");
    }
}

#pragma mark - AXChatDataCenterDelegate
- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchChatList:(NSDictionary *)chatList withFriend:(AXMappedPerson *)person lastMessage:(AXMappedMessage *)message
{
    _fetchedChatList(chatList,message,person);
    _fetchedChatList = nil;
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter didReceiveMessages:(NSDictionary *)messages
{
    NSArray *allKeyArray = [messages allKeys];
    NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
    NSMutableArray *messageArray = [[NSMutableArray alloc] init];
    NSMutableArray *picArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *picDic = [[NSMutableDictionary alloc] init];
    [allKeyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = (NSString *)obj;
        if (messages[key][@"other"] && [messages[key][@"other"] isKindOfClass:[NSArray class]]) {
            NSArray *array = messages[key][@"other"];
            if ([array count] >= 1) {
                [messageArray addObjectsFromArray:array];
            }
        }
        if (messages[key][@"pic"] && [messages[key][@"pic"] isKindOfClass:[NSArray class]]) {
            NSArray *array = messages[key][@"pic"];
            if ([array count] >= 1) {
                [picArray addObjectsFromArray:array];
                [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    AXMappedMessage *message = (AXMappedMessage *)obj;
                    [self downLoadImageInOperationQueueWithMessage:message];
                }];
            }
        }
        if ([messageArray count] > 0) {
            messageDic[key] = messageArray;
        }
        if ([picArray count] > 0) {
            picDic[key] = picArray;
        };
    }];
    if (![picDic isEqual:@{}]) {
        [self.imageMessageArray addObject:picDic];
    }
    NSDictionary *userInfo = @{@"unreadCount":@([self.dataCenter totalUnreadMessageCount])};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:messageDic userInfo:userInfo];
    });
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchFriendList:(NSArray *)chatList
{
#warning todo
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter fetchPersonInfoWithUid:(NSArray *)uid
{
    [self getFriendInfoWithFriendUid:uid];
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter fetchPublicInfoWithUid:(NSArray *)uid
{
    self.userGetServiceInfo.apiParams = @{@"service_id":uid[0]};
    [self.userGetServiceInfo loadData];
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
        
    }
    if (request.tag == AXMessageCenterHttpRequestTypeDeleteFriend) {
        
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode ) {
        __autoreleasing NSError *error;
        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
        if (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"OK"]) {
            AXMappedPerson *person = [[AXMappedPerson alloc] initWithDictionary:receiveDic[@"result"]];
            _addFriendByQRCode(person);
        }
    }
    //sendimage
    if (request.tag == AXMessageCenterHttpRequestTypeUploadImage) {
        [self.sendImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AXMappedMessage *dataMessage = (AXMappedMessage *)obj;
            NSDictionary *userInfo = [request userInfo];
            if ([dataMessage.identifier isEqualToString:userInfo[@"identify"]]) {
                NSString *imageUrl;
                __autoreleasing NSError *error;
                NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:NSJSONReadingMutableContainers error:&error];
                if (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"ok"]) {
                    NSDictionary *image = receiveDic[@"image"];
                    imageUrl = [NSString stringWithFormat:@"http://pic%@.ajkimg.com/m/%@/%@x%@.jpg",image[@"host"],image[@"id"],image[@"width"],image[@"height"]];
                }
                
                dataMessage.imgUrl = imageUrl;
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                params[@"msg_type"] = [NSString stringWithFormat:@"%@",dataMessage.messageType];
                params[@"phone"] = self.currentPerson.phone;
                params[@"to_uid"] = dataMessage.to;
                params[@"uniqid"] = dataMessage.identifier;
                params[@"body"] = imageUrl;
                
                [self.dataCenter updateMessage:dataMessage];
                
                self.sendMessageManager.apiParams = params;
                [self.sendMessageManager loadData];
            }
        }];
        
    }
    [self.imageMessageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *fromUid = (NSDictionary *)obj;
        NSArray *allKeys =[fromUid allKeys];
        NSArray *messageArray = fromUid[[allKeys objectAtIndex:0]];
        [messageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AXMappedMessage *imageMessage = (AXMappedMessage *)obj;
            if ([imageMessage.messageId integerValue] == request.tag) {
                NSError *error = [request error];
                if (error) {
                    imageMessage.isImgDownloaded = NO;
                    [self.dataCenter updateMessage:imageMessage];
                }else{
                    NSData *imageData = [request responseData];
                    UIImage *image = [[UIImage alloc] initWithData:imageData];
                    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                    [self saveImage:image withFileName:imageMessage.identifier ofType:@"jpg" inDirectory:documentsDirectoryPath];
                    NSString *imageString = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",imageMessage.identifier]];
                    imageMessage.thumbnailImgPath = imageString;
                    [self.dataCenter updateMessage:imageMessage];
                    NSDictionary *dic = @{allKeys[0]: @[imageMessage]};
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:dic];
                    });
                }
            }
        }];
    }];

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (request.tag == AXMessageCenterHttpRequestTypeDeleteFriend) {
        
    }
    if (request.tag == AXMessageCenterHttpRequestTypeUploadImage) {
        NSDictionary *userInfo = [request userInfo];
        [self.sendImageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            AXMappedMessage *dataMessage = (AXMappedMessage *)obj;
            if ([dataMessage.identifier isEqualToString:userInfo[@"identify"]]) {
                _finishSendMessageBlock = self.blockDictionary[dataMessage.identifier];
                _finishSendMessageBlock(dataMessage,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeFailed);
            }
        }];
    }
    if (request.tag == AXMessageCenterHttpRequestTypeDownLoadImage) {
        
    }
    if (request.tag == AXMessageCenterHttpRequestTypeQRCode) {
        _addFriendByQRCode(nil);
    }
}

#pragma mark - AIFMessageManagerDelegate
- (void)manager:(AXMessageManager *)manager didRegisterDevice:(NSString *)deviceId userId:(NSString *)userId receivedData:(NSData *)data
{
#warning rebuild
    __autoreleasing NSError *error;
    
    NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"receiveDic  ===== %@",receiveDic);
    
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"INITED"]) {
        NSLog(@"INITED");
        if (self.linkStatus ==  AXMessageCenterLinkStatusWillLinkAsDevice) {
            self.linkStatus = AXMessageCenterLinkStatusLinkedAsDevice;
        }
        if (self.linkStatus ==  AXMessageCenterLinkStatusWillLinkAsUser) {
            self.linkStatus = AXMessageCenterLinkStatusLinkedAsUser;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status": @(AIFMessageCenterStatusConnected)}];
        });
    }
    
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"BYE"]) {
        NSLog(@"BYE");
        self.linkStatus = AXMessageCenterLinkStatusNoLink;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status": @(AIFMessageCenterStatusDisconnected)}];
        });
    }
    
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"SELF_CLOSE"]) {
        NSLog(@"SELF_CLOSE");
        if (self.linkStatus == AXMessageCenterLinkStatusWillCloseDevice) {
            self.linkStatus = AXMessageCenterLinkStatusWillLinkAsUser;
        }
        if (self.linkStatus == AXMessageCenterLinkStatusWillCloseUser) {
            self.linkStatus = AXMessageCenterLinkStatusWillLinkAsDevice;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status": @(AIFMessageCenterStatusUserLoginOut)}];
            });
        }

        if (self.linkStatus == AXMessageCenterLinkStatusWillLinkAsUser) {
            [self connectToServer];
        }
        
        if (self.linkStatus == AXMessageCenterLinkStatusWillLinkAsDevice) {
            [self buildLongLinkWithUserId:@"0"];
        }
        
        if (self.linkStatus == AXMessageCenterLinkStatusNoLink) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status": @(AIFMessageCenterStatusDisconnected)}];
            });
        }
    }

    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"TIMEOUT"]) {
        NSLog(@"TIMEOUT");
        if (self.linkStatus ==  AXMessageCenterLinkStatusLinkedAsDevice) {
            self.linkStatus = AXMessageCenterLinkStatusWillLinkAsDevice;
        }
        if (self.linkStatus == AXMessageCenterLinkStatusLinkedAsUser) {
            self.linkStatus = AXMessageCenterLinkStatusWillLinkAsUser;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status": @(AIFMessageCenterStatusConnecting)}];
        });
        self.messageManager.registerStatus = AIF_MESSAGE_REQUEST_REGISTER_FAILED;
        [self.messageManager registerDevices:[[UIDevice currentDevice] udid] userId:self.currentPerson.uid];
    }
    
    if ([receiveDic[@"result"] isKindOfClass:[NSString class]] && [receiveDic[@"result"] isEqualToString:@"QUIT"]) {
        NSLog(@"QUIT");
        self.linkStatus = AXMessageCenterLinkStatusNoLink;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *lertview = [[UIAlertView alloc] initWithTitle:@"您的账号已被他人登陆，您已被下线" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [lertview show];
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterUserDidQuit object:nil userInfo:@{@"status": @(AIFMessageCenterStatusUserLoginOut)}];
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterUserDidQuitToAllReceiveNotication object:nil];
        });
    }
    
    if ([receiveDic[@"result"] isKindOfClass:[NSDictionary class]] && [receiveDic[@"result"][@"msgType"] isEqualToString:@"chat"]) {
        [self userReceiveAlivingConnection];
    }
}

- (void)manager:(AXMessageManager *)manager didHeartBeatWithDevice:(NSString *)deviceId userId:(NSString *)userId receivedData:(NSData *)data
{
    
#warning rebuild
}

#pragma mark - AIFMessageSenderDelegate
- (void)manager:(AXMessageManager *)manager didSendMessage:(NSString *)message toUserId:(NSString *)userId receivedData:(NSData *)data
{
    
}

#pragma mark - CallBack
- (void)registerNotificationFinish:(RTNetworkResponse *)response {
    DLog(@"response %@", response.content);
}

@end
