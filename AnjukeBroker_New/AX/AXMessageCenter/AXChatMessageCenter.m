//
//  AJKChatMessageCenter.m
//  Anjuke2
//
//  Created by 杨 志豪 on 14-2-17.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "AXChatMessageCenter.h"
#import "AXMessageAPILongLinkManager.h"
#import "AXChatDataCenter.h"
//#import "MemberUtil.h"
#import "Reachability.h"
#import "LoginManager.h"
#import "BrokerChatViewController.h"


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
#import "AXMessageCenterAddFriendByQRCodeManager.h"
#import "AXMessageCenterPublicServiceActionEventManager.h"
#import "AXMessageCenterSendPropManager.h"

//record
#import "KKAudioComponent.h"
#import "AXDownLoadModule.h"

static NSString * const kMessageCenterReceiveMessageTypeText = @"1";
static NSString * const kMessageCenterReceiveMessageTypeProperty = @"2";
static NSString * const ImageServeAddress = @"http://upd1.ajkimg.com/upload";

#ifdef DEBUG
    static NSString * const kLastVersionApiSite = @"http://chatapi.dev.anjuke.com";
#else
    static NSString * const kLastVersionApiSite = @"http://api.anjuke.com/weiliao";
#endif

@interface AXChatMessageCenter ()<AXMessageAPILongLinkDelegate,RTAPIManagerApiCallBackDelegate,RTAPIManagerInterceptorProtocal, AXChatDataCenterDelegate>
@property (nonatomic, strong) AXMessageAPILongLinkManager *longLinkManager;
@property (nonatomic, strong) AXChatDataCenter *dataCenter;
@property (nonatomic, strong) NSOperationQueue *imageMessageOperation;
@property (nonatomic, strong) NSMutableArray *messsageIdentity;
@property (nonatomic, strong) NSMutableDictionary *blockDictionary;
@property (nonatomic, strong) NSMutableArray *sendMessageArray;
@property (nonatomic, strong) NSMutableArray *imageMessageArray;
@property (nonatomic, strong) NSDate *currentTime;
@property (nonatomic, strong) NSTimer *downLoadFailedMessageTimer;

@property (nonatomic, strong) NSString *messageIdentify;

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
@property (nonatomic, strong) AXMessageCenterAddFriendByQRCodeManager *addFriendByQRCodeManager;
@property (nonatomic, strong) AXMessageCenterPublicServiceActionEventManager *publickServiiceEventManager;
@property (nonatomic, strong) AXMessageCenterSendPropManager *sendPropManager;

@property (nonatomic ,strong) void (^fetchedChatList)(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend);
@property (nonatomic, strong) void (^finishSendMessageBlock)(NSArray *array,AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType);
@property (nonatomic, strong) void (^friendListBlock)(NSArray *friendList,BOOL whetherSuccess);
@property (nonatomic, strong) void (^searchBrokerBlock)(AXMappedPerson *brokerInfo, BOOL success);
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
        _sendMessageToPublic.interceotorDelegate = self;
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

- (AXMessageCenterAddFriendByQRCodeManager *)addFriendByQRCodeManager
{
    if (!_addFriendByQRCodeManager) {
        _addFriendByQRCodeManager = [[AXMessageCenterAddFriendByQRCodeManager alloc] init];
        _addFriendByQRCodeManager.delegate = self;
        _addFriendByQRCodeManager.validator = _addFriendByQRCodeManager;
        _addFriendByQRCodeManager.paramSource = _addFriendByQRCodeManager;
    }
    return _addFriendByQRCodeManager;
}

- (AXMessageCenterPublicServiceActionEventManager *)publickServiiceEventManager
{
    if (!_publickServiiceEventManager) {
        _publickServiiceEventManager = [[AXMessageCenterPublicServiceActionEventManager alloc] init];
        _publickServiiceEventManager.delegate = self;
        _publickServiiceEventManager.validator = _publickServiiceEventManager;
        _publickServiiceEventManager.paramSource = _publickServiiceEventManager;
    }
    return _publickServiiceEventManager;
}

-(AXMessageCenterSendPropManager *)sendPropManager
{
    if (!_sendPropManager) {
        _sendPropManager = [[AXMessageCenterSendPropManager alloc] init];
        _sendPropManager.delegate = self;
        _sendPropManager.validator = _sendPropManager;
        _sendPropManager.paramSource = _sendPropManager;
    }
    return _sendPropManager;
}
- (AXMappedPerson *)currentPerson
{
    if (_currentPerson == nil) {
        _currentPerson = [self.dataCenter fetchCurrentPerson];
    }
    return _currentPerson;
}

- (AXMessageAPILongLinkManager *)longLinkManager
{
    if (_longLinkManager == nil) {
        _longLinkManager = [[AXMessageAPILongLinkManager alloc] init];
        _longLinkManager.shouldKeepAtLeastOneLink = NO;
        _longLinkManager.delegate = self;
    }
    return _longLinkManager;
}

- (NSOperationQueue *)imageMessageOperation
{
    if (_imageMessageOperation == nil) {
        _imageMessageOperation = [[NSOperationQueue alloc] init];
        _imageMessageOperation.maxConcurrentOperationCount = 1;
    }
    return _imageMessageOperation;
}

- (NSMutableArray *)messsageIdentity
{
    if (_messsageIdentity == nil) {
        _messsageIdentity = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _messsageIdentity;
}

- (NSMutableArray *)sendMessageArray
{
    if (_sendMessageArray == nil) {
        _sendMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _sendMessageArray;
}

- (NSMutableDictionary *)blockDictionary
{
    if (_blockDictionary == nil) {
        _blockDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _blockDictionary;
}

- (NSMutableArray *)imageMessageArray
{
    if (_imageMessageArray == nil) {
        _imageMessageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _imageMessageArray;
}

- (AXChatDataCenter *)dataCenter
{
    if (_dataCenter == nil) {
        _dataCenter = [[AXChatDataCenter alloc] initWithUID:@"0"];
        _dataCenter.delegate = self;
    }
    return _dataCenter;
}


#pragma mark - life cycle
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
        self.currentTime = [[NSDate alloc] initWithTimeInterval:-60-1 sinceDate:[NSDate date]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerRemoteNotification) name:@"REGISTER_REMOTE_NOTICATION_SUCCESS" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationUserDidLogin) name:@"LOGIN_NOTIFICATION" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationUserLoginOut) name:@"LOGOUT_NOTIFICATION" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationUserInfoChanged) name:@"USERINFO_CHANGED_NOTIFICATION" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.downLoadFailedMessageTimer invalidate];
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
    __block NSDictionary *deleteDic = [[NSDictionary alloc] init];
    [self.messsageIdentity enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *dic = (NSDictionary *)obj;
        if (requestID == [dic[@"requestID"] integerValue]) {
            NSString *identify = dic[@"uniqid"];
            AXMappedMessage *mappedMessage = [self.dataCenter fetchMessageWithIdentifier:identify];
            if (!mappedMessage) {
                return ;
            }
            if (response.status == RTNetworkResponseStatusSuccess) {
                if (response.content[@"status"] && [response.content[@"status"] isEqualToString:@"OK"]) {
                    [self finishSendMessageWithSendStatus:AXMessageCenterSendMessageStatusSuccessful messageID:[NSNumber numberWithInt:[response.content[@"result"] integerValue]] failOrSuccess:YES message:mappedMessage errorCodeType:AXMessageCenterSendMessageErrorTypeCodeNone];
                } else if (response.content[@"status"] && [response.content[@"status"] isEqualToString:@"ERROR"]){
                    mappedMessage.messageId = [NSNumber numberWithInt:[response.content[@"result"] integerValue]];
                    if (response.content[@"errorCode"] && [response.content[@"errorCode"] isEqualToString:@"100016"] ) {
                        //xiao fengdeng you know that, it should be failed not success!!!!
                        [self finishSendMessageWithSendStatus:AXMessageCenterSendMessageStatusSuccessful messageID:nil failOrSuccess:NO message:mappedMessage errorCodeType:AXMessageCenterSendMessageErrorTypeCodeNotFriend];
                    }else
                    {
                        [self finishSendMessageWithSendStatus:AXMessageCenterSendMessageStatusFailed messageID:nil failOrSuccess:NO message:mappedMessage errorCodeType:AXMessageCenterSendMessageErrorTypeCodeNone];
                    }
                }
            }else if (response.status == RTNetworkResponseStatusFailed || response.status == RTNetworkResponseStatusJsonError) {
                [self finishSendMessageWithSendStatus:AXMessageCenterSendMessageStatusFailed messageID:nil failOrSuccess:NO message:mappedMessage errorCodeType:AXMessageCenterSendMessageErrorTypeCodeFailed];
            }
            deleteDic = dic;
        }
    }];
    [self.messsageIdentity removeObject:deleteDic];
    
}

- (void)finishSendMessageWithSendStatus:(AXMessageCenterSendMessageStatus )status messageID:(NSNumber *)messageID failOrSuccess:(BOOL)IsFailed message:(AXMappedMessage *)message errorCodeType:(AXMessageCenterSendMessageErrorTypeCode)errorCodeType
{
    message.sendStatus  = @(status);
    if (!IsFailed) {
        [self.dataCenter didFailSendMessageWithIdentifier:message.identifier];
    }else{
        message.messageId = messageID;
        [self.dataCenter didSuccessSendMessageWithIdentifier:message.identifier messageId:[NSString stringWithFormat:@"%@",messageID]];
    }
    _finishSendMessageBlock = self.blockDictionary[message.identifier];
    if (_finishSendMessageBlock) {
        _finishSendMessageBlock(@[message],status,errorCodeType);
        [self.blockDictionary removeObjectForKey:message.identifier];
    }
    
}

- (void)manager:(RTAPIBaseManager *)manager afterPerformSuccessWithResponse:(RTNetworkResponse *)response
{
    [self sendMessageCallBackWithResonpe:response];
}

#pragma mark - API Call back
- (void)managerCallAPIDidSuccess:(RTAPIBaseManager *)manager
{
    if ([manager isKindOfClass:[AXMessageCenterSendPropManager class]])
    {
        NSDictionary *dic = [manager  fetchDataWithReformer:nil];
        NSDictionary *dic2 = [dic[@"data"] objectForKey:@"data"];
        
        int me = [[[dic2 objectForKey:@"house"] objectForKey:@"msg_id"] intValue];
        NSNumber *messID = [NSNumber numberWithInt:me];
        AXMappedMessage *mappedMessage = [self.dataCenter fetchMessageWithIdentifier:_messageIdentify];
        
        NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dic];
        [newDict setValue:_messageIdentify forKeyPath:@"unid"];
        [[BrokerChatViewController getBrokerSelf] sayHelloHttpRequest:newDict];
        
        AXMessageCenterSendMessageStatus sendStatus = AXMessageCenterSendMessageStatusSuccessful;
        if ([[dic2 objectForKey:@"status"] isEqualToString:@"1"])
        {
            sendStatus = AXMessageCenterSendMessageStatusSuccessful;
        }else
        {
            sendStatus = AXMessageCenterSendMessageStatusFailed;
        }
        [self finishSendMessageWithSendStatus:sendStatus messageID:messID failOrSuccess:YES message:mappedMessage errorCodeType:AXMessageCenterSendMessageErrorTypeCodeNone];
        
    }
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
                NSArray *arr = [NSArray arrayWithArray:friendList[0][@"friends"]];
                DLog(@"arr--->>%d/%@",arr.count,arr);
                NSArray *friendListFromDataCenter = [self.dataCenter saveFriendListWithPersonArray:arr];
                if (_friendListBlock) {
                    _friendListBlock(friendListFromDataCenter,YES);
                }
            }
        } else {
            if (_friendListBlock) {
                 _friendListBlock(nil,NO);
            }
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
                    _searchBrokerBlock(person,YES);
                }else{
                    _searchBrokerBlock(nil,YES);
                }
            }else {
                AXMappedPerson *person = [[AXMappedPerson alloc] initWithDictionary:dic[@"result"]];
                _searchBrokerBlock(person,YES);
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
            _deleteFriendBlock(NO);
        }
    }
    if ([manager isKindOfClass:[AXMessageCenterGetUserOldMessageManager class]]) {
        // do nothing
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
    
    if ([manager isKindOfClass:[AXMessageCenterAddFriendByQRCodeManager class]]) {
        NSDictionary *personData = [manager fetchDataWithReformer:nil];
        if (personData[@"status"] && [personData[@"status"] isEqualToString:@"OK"]) {
            AXMappedPerson *person = [[AXMappedPerson alloc] initWithDictionary:personData[@"result"]];
            _addFriendByQRCode(person);
        }else {
            _addFriendByQRCode(nil);
        }
    }
    
    //公众号获取actionEvent
    if ([manager isKindOfClass:[AXMessageCenterPublicServiceActionEventManager class]]) {
        
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
        NSLog(@"search broker info failed");
        _searchBrokerBlock(nil,NO);
    }
    if ([manager isKindOfClass:[AXMessageCenterDeleteFriendManager class]]) {
        _deleteFriendBlock(NO);
        NSLog(@"DELETE FRIEND FAILED");
    }
    if ([manager isKindOfClass:[AXMessageCenterGetUserOldMessageManager class]]) {
        NSLog(@"get user old message failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterGetFriendInfoManager class]]) {
        NSLog(@"get friend info failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterFriendListManager class]]) {
        NSLog(@"get friendlist message failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterUserGetPublicServiceInfoManager class]]) {
        NSLog(@"get public service info failed");
    }
    if ([manager isKindOfClass:[AXMessageCenterAddFriendByQRCodeManager class]]) {
        _addFriendByQRCode(nil);
    }
    //公众号获取actionEvent
    if ([manager isKindOfClass:[AXMessageCenterPublicServiceActionEventManager class]]) {
        DLog(@"fail");
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

- (void)deleteConversationItem:(AXConversationListItem *)conversationItem
{
    return [self.dataCenter deleteConversationItem:conversationItem];
}

- (void)didLeaveChattingListWithFriendUID:(NSString *)friendUID
{
    [self.dataCenter didLeaveChattingListWithFriendUID:friendUID];
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

- (void)updateMessageWithIdentifier:(NSString *)identifier keyValues:(NSDictionary *)keyValues
{
    [self.dataCenter updateMessageWithIdentifier:identifier keyValues:keyValues];
}

- (BOOL)isFriendWithFriendUid:(NSString *)friendUid
{
    return [self.dataCenter isFriendWithFriendUid:friendUid];
}

- (void)chatListWillAppearWithFriendUid:(NSString *)friendUid
{
    [self.dataCenter chatListWillAppearWithFriendUid:friendUid];
}

#pragma mark - selfMethod
- (void)switchDataCenterWithUid:(NSString *)uid
{
    if (![uid isEqualToString:self.dataCenter.uid]) {
        [self.dataCenter switchToUID:uid];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidInitedDataCenter object:nil];
        });
    }
}

- (NSDictionary *)sendMessage:(AXMappedMessage *)message sayHello:(BOOL)sayHello willSendMessage:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock
{
    if(sayHello)
    {
        [self.dataCenter willAddFriendWithUid:message.to isSayHello:YES];
    }
    
    NSArray *messageList = [self.dataCenter willSendMessage:message];
    AXMappedMessage *dataMessage = [messageList lastObject];
    sendMessageBlock(messageList, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageManager isReachable]) {
        sendMessageBlock(messageList, AXMessageCenterSendMessageStatusFailed, AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return NULL;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    if (!sayHello)
    {
        params[@"phone"] = self.currentPerson.phone;
    }
    _messageIdentify = dataMessage.identifier;

    params[@"to_uid"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    if ([dataMessage.messageType integerValue] == AXMessageTypePic) {
        params[@"body"] = dataMessage.imgUrl;
    }else if ([dataMessage.messageType integerValue] == AXMessageTypeVoice){
        params[@"body"] = dataMessage.content;
    }else{
        params[@"body"] = dataMessage.content;
    }
    
    if (sayHello)
    {
        
        [params setValue:@"1" forKey:@"force_send"];
        
        NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
        NSDictionary *modelDict = [params mutableCopy];
        [modelDict setValue:@"1" forKey:@"msg_type"];
        [modelDict setValue:@"推荐的房源成功，请等待客户联系你" forKey:@"body"];
        
        NSMutableDictionary *postDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        [postDict setValue:dataMessage.to forKey:@"device_id"];
        [postDict setValue:dataMessage.from forKey:@"broker_id"];
        [postDict setValue:modelDict forKey:@"model_body" ];
        [postDict setValue:params forKey:@"house_body"];
        [postDict setValue:loginResult[@"auth_token"] forKey:@"auth_token"];
        [postDict setValue:[LoginManager getToken] forKey:@"token"];

        self.sendPropManager.apiParams = postDict;
        [self.sendPropManager loadData];
    }else
    {
        self.sendMessageManager.apiParams = params;
    }
    
    NSMutableDictionary *sendDict = NULL;
    if (sayHello)
    {
        sendDict = [NSMutableDictionary dictionaryWithDictionary:params];
        [sendDict removeObjectForKey:@"phone"];
    }else
    {
        [self.sendMessageManager loadData];
    }
    
    return sendDict;

}

- (void)sendMessage:(AXMappedMessage *)message willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus ,AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    [self sendMessage:message sayHello:NO willSendMessage:sendMessageBlock];
}

- (void)sendMessageToPublic:(AXMappedMessage *)message willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    NSArray *messageList = [self.dataCenter willSendMessage:message];
    AXMappedMessage *dataMessage = [messageList lastObject];
    sendMessageBlock(messageList, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageToPublic isReachable]) {
        sendMessageBlock(messageList,AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return ;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = dataMessage.messageType;
    params[@"phone"] = self.currentPerson.phone;
    params[@"to_service_id"] = dataMessage.to;
    params[@"uniqid"] = dataMessage.identifier;
    if ([dataMessage.messageType integerValue] == AXMessageTypePic) {
        params[@"body"] = dataMessage.imgUrl;
    }else if ([dataMessage.messageType integerValue] == AXMessageTypeVoice){
        params[@"body"] = dataMessage.content;
    }else{
        params[@"body"] = dataMessage.content;
    }
    
    self.sendMessageToPublic.apiParams = params;
    [self.sendMessageToPublic loadData];
}

- (void)sendImageToPublic:(AXMappedMessage *)message willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    [self newImageMessageUploadWithMessage:message withSendMessageBlock:sendMessageBlock];
}

- (void)sendVoiceToPublic:(AXMappedMessage *)message willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    [self newVoiceMessageUploadWithMessage:message withSendMessageBlock:sendMessageBlock];
}

- (void)newImageMessageUploadWithMessage:(AXMappedMessage *)message withSendMessageBlock:(void(^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock

{
    NSArray *messageList = [self.dataCenter willSendMessage:message];
    AXMappedMessage *dataMessage = [messageList lastObject];
    sendMessageBlock(messageList, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageManager isReachable]) {
        sendMessageBlock(messageList, AXMessageCenterSendMessageStatusFailed, AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return ;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    [self.sendMessageArray addObject:dataMessage];
    [[AXDownLoadModule shareInstance] upLoadWithUrlString:[NSURL URLWithString:ImageServeAddress] postData:dataMessage.imgPath identify:dataMessage.identifier callBack:@"uploadCallBack:" target:self type:AJKDownLoadModuleUpLoadTypeImage];
}

- (void)uploadCallBack:(AXDownLoadRequestResponse *)response
{
    __block AXMappedMessage *deleteMessage;
    [self.sendMessageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AXMappedMessage *dataMessage = (AXMappedMessage *)obj;
        if ([dataMessage.identifier isEqualToString:response.identify]) {
            deleteMessage = dataMessage;
            if (response.status == AXDownLoadRequestResponseStatusSuccessful) {
                [self uploadSuccessfull:response withMessage:dataMessage];
            }else{
                [self uploadFailed:response withMessage:dataMessage];
            }
        }
    }];
    [self.sendMessageArray removeObject:deleteMessage];
}

- (void)uploadSuccessfull:(AXDownLoadRequestResponse *)response withMessage:(AXMappedMessage *)message
{
    __autoreleasing NSError *error;
    NSDictionary *callBackDic = [NSJSONSerialization JSONObjectWithData:response.responseData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return;
    }
    AXMappedPerson *toPerson = [self.dataCenter fetchPersonWithUID:message.to];
    if ([message.messageType intValue] == AXMessageTypePic) {
        [self uploadSuccessAndSendPicWithMessage:message responseDic:callBackDic withToPersonType:toPerson.userType];
    }
    if ([message.messageType intValue] == AXMessageTypeVoice) {
        [self uploadSuccessAndSendVoiceWithMessage:message responseDic:callBackDic withToPersonType:toPerson.userType];
    }
}

- (void)uploadSuccessAndSendPicWithMessage:(AXMappedMessage *)dataMessage responseDic:(NSDictionary *)receiveDic withToPersonType:(AXPersonType )userType
{
    NSString *imageUrl;
    if (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"ok"]) {
        NSDictionary *image = receiveDic[@"image"];
        imageUrl = [NSString stringWithFormat:@"http://pic%@.ajkimg.com/m/%@/%@x%@.jpg",image[@"host"],image[@"id"],image[@"width"],image[@"height"]];
    }else if (receiveDic == nil || [receiveDic[@"status"] isEqualToString:@"ERROR"]){
        [self didFailedSendMessage:dataMessage];
        return ;
    }
    
    dataMessage.imgUrl = imageUrl;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = [NSString stringWithFormat:@"%@",dataMessage.messageType];
    params[@"phone"] = self.currentPerson.phone;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = imageUrl;
    
    [self.dataCenter updateMessage:dataMessage];
    [self sendMessageToUserType:userType params:params message:dataMessage];
}

- (void)uploadSuccessAndSendVoiceWithMessage:(AXMappedMessage *)dataMessage responseDic:(NSDictionary *)receiveDic withToPersonType:(AXPersonType )userType
{
    NSString *voiceID;
    if (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"OK"] && receiveDic[@"result"] && receiveDic[@"result"][@"file_id"]) {
        voiceID = receiveDic[@"result"][@"file_id"];
    }else if (receiveDic == nil || (receiveDic[@"status"] && [receiveDic[@"status"] isEqualToString:@"ERROR"])){
        [self didFailedSendMessage:dataMessage];
        return ;
    }
    NSData *data = [dataMessage.content dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError *error;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (dic[@"length"]) {
        dic[@"file_id"] = voiceID;
    }
    dataMessage.content = [dic RTJSONRepresentation];
    dataMessage.imgUrl = voiceID;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"msg_type"] = [NSString stringWithFormat:@"%@",dataMessage.messageType];
    params[@"phone"] = self.currentPerson.phone;
    params[@"uniqid"] = dataMessage.identifier;
    params[@"body"] = dataMessage.content;
    
    [self.dataCenter updateMessage:dataMessage];
    [self sendMessageToUserType:userType params:params message:dataMessage];
}

- (void)uploadFailed:(AXDownLoadRequestResponse *)response withMessage:(AXMappedMessage *)message
{
    [self.dataCenter didFailSendMessageWithIdentifier:message.identifier];
    [self.sendMessageArray removeObject:message];
    if (self.blockDictionary[message.identifier]) {
        [self.blockDictionary removeObjectForKey:message.identifier];
    }
}

- (void)sendMessageToUserType:(AXPersonType )userType params:(NSMutableDictionary *)params message:(AXMappedMessage *)dataMessage
{
    if (userType == AXPersonTypePublic) {
        params[@"to_service_id"] = dataMessage.to;
        self.sendMessageToPublic.apiParams = params;
        [self.sendMessageToPublic loadData];
    }else {
        params[@"to_uid"] = dataMessage.to;
        self.sendMessageManager.apiParams = params;
        [self.sendMessageManager loadData];
    }
}

- (void)newVoiceMessageUploadWithMessage:(AXMappedMessage *)message withSendMessageBlock:(void(^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    NSArray *messageList = [self.dataCenter willSendMessage:message];
    AXMappedMessage *dataMessage = [messageList lastObject];
    sendMessageBlock(messageList, AXMessageCenterSendMessageStatusSending,AXMessageCenterSendMessageErrorTypeCodeNone);
    if (![self.sendMessageManager isReachable]) {
        sendMessageBlock(messageList, AXMessageCenterSendMessageStatusFailed, AXMessageCenterSendMessageErrorTypeCodeNone);
        [self.dataCenter didFailSendMessageWithIdentifier:dataMessage.identifier];
        return ;
    }
    self.blockDictionary[dataMessage.identifier] = sendMessageBlock;
    [self.sendMessageArray addObject:dataMessage];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *amrPath = [KKAudioComponent wavToAmrWithWavFilePath:dataMessage.imgPath];
        NSMutableData *voiceMutableData = [[NSMutableData alloc] initWithContentsOfFile:amrPath];
        [[AXDownLoadModule shareInstance] upLoadWithHostAddress:kLastVersionApiSite postData:voiceMutableData methodName:@"common/uploadFile" isCheck:YES identify:dataMessage.identifier callBack:@"uploadCallBack:" target:self type:AJKDownLoadModuleUpLoadTypeVoice];
    });

}
- (void)sendImage:(AXMappedMessage *)message withCompeletionBlock:(void(^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    [self newImageMessageUploadWithMessage:message withSendMessageBlock:sendMessageBlock];
}

- (void)sendVoice:(AXMappedMessage *)message withCompeletionBlock:(void (^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    [self newVoiceMessageUploadWithMessage:message withSendMessageBlock:sendMessageBlock];
}

#pragma mark - ResendMessage Method
- (void)reSendMessage:(NSString *)identifier willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus,AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identifier];
    [self sendMessage:dataMessage willSendMessage:sendMessageBlock];
}

- (void)reSendMessageToPublic:(NSString *)identifier willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identifier];
    [self sendMessageToPublic:dataMessage willSendMessage:sendMessageBlock];
}

- (void)reSendVoiceToPublic:(NSString *)identifier willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identifier];
    if (dataMessage.content) {
        __autoreleasing NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[dataMessage.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (dic[@"file_id"] && ![dic[@"file_id"] isEqualToString:@""]) {
            [self sendMessageToPublic:dataMessage willSendMessage:sendMessageBlock];
        }else {
            [self sendVoiceToPublic:dataMessage willSendMessage:sendMessageBlock];
        }
    }
}

- (void)reSendImageToPublic:(NSString *)identifier willSendMessage:(void (^)(NSArray *, AXMessageCenterSendMessageStatus, AXMessageCenterSendMessageErrorTypeCode))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identifier];
    if (dataMessage.imgUrl && ![dataMessage.imgUrl isEqualToString:@""]) {
        [self sendMessageToPublic:dataMessage willSendMessage:sendMessageBlock];
    }else {
        [self sendImageToPublic:dataMessage willSendMessage:sendMessageBlock];
    }
}

- (void)reSendImage:(NSString *)identify withCompeletionBlock:(void(^)(NSArray *, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identify];
    if (dataMessage.imgUrl && ![dataMessage.imgUrl isEqualToString:@""] && [self checkoutWetherIsHttpUrlByImageUrl:dataMessage.imgUrl]) {
        [self sendMessage:dataMessage willSendMessage:sendMessageBlock];
        return;
    }
    [self sendImage:dataMessage withCompeletionBlock:sendMessageBlock];
}
- (void)reSendVoice:(NSString *)identify withCompeletionBlock:(void(^)(NSArray *message, AXMessageCenterSendMessageStatus status ,AXMessageCenterSendMessageErrorTypeCode errorType))sendMessageBlock
{
    AXMappedMessage *dataMessage = [self.dataCenter fetchMessageWithIdentifier:identify];
    NSData *data = [dataMessage.content dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError *error;
    NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (contentDic && contentDic[@"file_id"]) {
        [self sendMessage:dataMessage willSendMessage:sendMessageBlock];
        return;
    }
    [self sendVoice:dataMessage withCompeletionBlock:sendMessageBlock];
}
- (void)userReceiveAlivingConnectionWithUniqId:(NSString *)uniqLongLinkId
{
    //uniqLongLinkId为nil的时候表示是主动去拉取的，不是长链接通知的。
    //关于last_max_msgid：其实是需要一个队列来下载消息的，现在暂时设置成0.在datacenter里面可以取到lastMsgId，现在先不采取这个方式。
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = self.currentPerson.phone;
    params[@"last_max_msgid"] = @"0";
    self.receiveMessageManager.apiParams = params;
    self.receiveMessageManager.uniqLongLinkId = uniqLongLinkId;
    [self.receiveMessageManager loadData];
}

- (void)appReceiveAlivingConnectionWithUniqId:(NSString *)uniqLongLinkId
{
    //uniqLongLinkId为nil的时候表示是主动去拉取的，不是长链接通知的。
    //关于last_max_msg_id：其实是需要一个队列来下载消息的，现在暂时设置成0. 在datacenter里面可以取到lastServiceMsgId，现在先不采取这个方式。
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"to_device_id"] = [[UIDevice currentDevice] udid];
    params[@"to_app_name"] = kAXConnectManagerLinkAppName;
    params[@"last_max_msg_id"] = @"0";
    self.appGetAllNewMessage.apiParams = params;
    self.appGetAllNewMessage.uniqLongLinkId = uniqLongLinkId;
    [self.appGetAllNewMessage loadData];
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
    NSString *brokerID = [self checkAndSearchBrokerUserID:urlString];
    if (!brokerID) {
        NSLog(@"broker ID is error!!");
    }
    self.addFriendByQRCodeManager.apiParams = @{@"brokerInfo": brokerID};
    [self.addFriendByQRCodeManager loadData];
}

- (NSString *)checkAndSearchBrokerUserID:(NSString *)urlString
{
    NSRange range = [urlString rangeOfString:@"http://api.anjuke.com/weiliao/user/getBrokerInfo/"];
    if (range.location == NSNotFound) {
        DLog(@"url is wrong");
        return nil;
    }
    NSArray *array = [urlString componentsSeparatedByString:@"/"];
    if ([array lastObject] &&[[array lastObject] isKindOfClass:[NSString class]]) {
        return [array lastObject];
    }else{
        return nil;
    }
}

- (void)addFriendWithStangerPerson:(NSString *)deviceID
{
    [self.dataCenter willAddFriendWithUid:deviceID isSayHello:YES];
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

- (void)searchBrokerByBrokerPhone:(NSString *)brokerPhone compeletionBlock:(void (^)(AXMappedPerson *,BOOL success))searchBrokerBlock
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
    if ([self checkoutShouleCallFriendListApi]) {
        [self fetchFriendList];
    }
}

- (void)fetchFriendList
{
//    return;
    if (self.currentPerson == nil || self.currentPerson.phone == nil) {
        return;
    }
    NSDictionary *params = @{@"phone": self.currentPerson.phone};
    
    self.friendListManager.apiParams = params;
    [self.friendListManager loadData];
}

//publicMenuApiEvent 事件请求
- (void)publicServiceSendActionByServiceId:(NSString *)serviceID actionID:(NSString *)actionID cityID:(NSString *)cityID userID:(NSString *)userID
{
    if (!(serviceID && actionID && cityID && userID)) {
        return;
    }
    NSDictionary *dic = @{@"city_id":cityID,@"user_id":userID};
    self.publickServiiceEventManager.apiParams = @{@"servive_id":serviceID,@"action_id":actionID};
    [self.publickServiiceEventManager loadDataWithParams:dic];
}

#pragma mark - save image in app method
- (BOOL)checkoutShouleCallFriendListApi
{
    NSDate *time = [[NSDate alloc] initWithTimeInterval:60 sinceDate:self.currentTime];
    if ([time compare:[NSDate date]] == NSOrderedAscending) {
        self.currentTime = [NSDate date];
        return YES;
    }else {
        return NO;
    }
}
- (BOOL)checkoutWetherIsHttpUrlByImageUrl:(NSString *)imageUrl
{
    NSRange httpString = [imageUrl rangeOfString:@"http://pic"];
    if (httpString.location == NSNotFound) {
        return NO;
    }
    NSRange ajkString = [imageUrl rangeOfString:@".ajkimg.com/m/"];
    if (ajkString.location == NSNotFound) {
        return NO;
    }else {
        return YES;
    }
}

- (void)downLoadVoiceInOperationQueueWithMessage:(AXMappedMessage *)message
{
    __autoreleasing NSError *error;
    NSData *contentData = [message.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingMutableContainers error:&error];
    if (!dic[@"file_id"]) {
        DLog(@"receive voice message content is error!!");
        return ;
    }
    NSString *identify = [NSString stringWithFormat:@"%@",message.messageId];
    [[AXDownLoadModule shareInstance] downLoadWithHostAddress:kLastVersionApiSite methodName:[NSString stringWithFormat:@"common/downloadFile/%@",dic[@"file_id"]] isCheck:YES identify:identify callBack:@"downloadCallBack:" target:self type:AJKDownLoadModuleDownLoadTypeVoice];
}

- (void)downloadCallBack:(AXDownLoadRequestResponse *)response
{
    __block AXMappedMessage *deleteMessage;
    [self.imageMessageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AXMappedMessage *message = obj;
        if ([message.messageId integerValue] == [response.identify integerValue]) {
            deleteMessage = message;
            if (response.status == AJKDownLoadModuleDownLoadStatusSuccessful) {
                [self downLoadSuccessfulWithMessage:message responseData:response.responseData userID:message.from];
            }else if (response.status == AJKDownLoadModuleDownLoadStatusFailed){
                [self downLoadFailedWithMessage:message];
            }
        }
    }];
    [self.imageMessageArray removeObject:deleteMessage];
}

- (void)downLoadSuccessfulWithMessage:(AXMappedMessage *)imageMessage responseData:(NSData *)responseData userID:(NSString *)userID
{
    if ([imageMessage.messageType integerValue] == AXMessageTypePic) {
        [self saveImageWithMessage:imageMessage userID:userID responseData:responseData];
    }else if ([imageMessage.messageType integerValue] == AXMessageTypeVoice){
        [self saveVoiceWithMessage:imageMessage userID:userID responseData:responseData];
    }
}

- (void)downLoadFailedWithMessage:(AXMappedMessage *)imageMessage
{
    imageMessage.isImgDownloaded = NO;
    [self.dataCenter updateMessage:imageMessage];
}

- (void)downLoadImageInOperationQueueWithMessage:(AXMappedMessage *)message
{
    if ([message.messageType  isEqual: @(AXMessageTypePic)]) {
        if (![self checkoutWetherIsHttpUrlByImageUrl:message.imgUrl]) {
            DLog(@"===receive message is error!!");
            return;
        }
    }
    NSString *finishString = [self restructImageUrlToFitSmallImageByOriginUrl:message.imgUrl];
    [[AXDownLoadModule shareInstance] downLoadWithUrlString:[NSURL URLWithString:finishString] identify:[NSString stringWithFormat:@"%@",message.messageId] callBack:@"downloadCallBack:" target:self type:AJKDownLoadModuleDownLoadTypeImage];
}

- (NSString *)restructImageUrlToFitSmallImageByOriginUrl:(NSString *)imageUrl
{
    NSString *imageString = [NSString stringWithFormat:@"%@",imageUrl];
    NSArray *array = [imageString componentsSeparatedByString:@"/"];
    NSString *sizeString = [array lastObject];
    NSArray *array2 = [sizeString componentsSeparatedByString:@"."];
    
    NSString *size = [array2 firstObject];
    NSString *imageFormat = [array2 lastObject];
    NSString *sizeWith = [[size componentsSeparatedByString:@"x"] firstObject];
    NSString *sizeHeigh = [[size componentsSeparatedByString:@"x"] lastObject];
    
    NSUInteger setSizeOfWidth;
    NSUInteger setSizeOfHeigh;
    
    if ([sizeWith integerValue] > 240) {
        setSizeOfWidth = 240;
    }else{
        setSizeOfWidth = [sizeWith integerValue];
    }
    if ([sizeHeigh integerValue] > 240) {
        setSizeOfHeigh= 240;
    }else{
        setSizeOfHeigh = [sizeHeigh integerValue];
    }
    NSString *finishString = [[NSString alloc] init];
    for (int i = 0; i <= 4; i++) {
        finishString = [finishString stringByAppendingFormat:@"%@/",array[i]];
    }
    finishString = [finishString stringByAppendingFormat:@"%lux%lu.%@",(unsigned long)setSizeOfWidth,(unsigned long)setSizeOfHeigh,imageFormat];
    
    return finishString;
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

- (void)downLoadVoiceAndImageWithDictionary:(NSDictionary *)messages
{
    if ([messages isEqualToDictionary:@{}]) {
        return;
    }
    __block NSArray *messageArray;
    NSMutableDictionary *messageDic = [[NSMutableDictionary alloc] init];
    NSArray *allKeyArray = [messages allKeys];
    [allKeyArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *key = obj;
        if (messages[key][@"other"] && [messages[key][@"other"] isKindOfClass:[NSArray class]]) {
            NSArray *array = messages[key][@"other"];
            if ([array count] >= 1) {
                messageArray = array;
            }
        }
        if (messages[key][@"pic"] && [messages[key][@"pic"] isKindOfClass:[NSArray class]]) {
            NSArray *array = messages[key][@"pic"];
            if ([array count] >= 1) {
                for (AXMappedMessage *message in array) {
                    [self downLoadImageInOperationQueueWithMessage:message];
                    [self.imageMessageArray addObject:message];
                }
            }
        }
        if (messages[key][@"voice"] && [messages[key][@"voice"] isKindOfClass:[NSArray class]]) {
            NSArray *array = messages[key][@"voice"];
            if ([array count] >= 1) {
                for (AXMappedMessage *message in array) {
                    [self downLoadVoiceInOperationQueueWithMessage:message];
                    [self.imageMessageArray addObject:message];
                }
            }
        }
        if ([messageArray count] > 0) {
            messageDic[key] = messageArray;
        }
    }];
    NSDictionary *userInfo = @{@"unreadCount":@([self.dataCenter totalUnreadMessageCount])};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:messageDic userInfo:userInfo];
    });
    
}
#pragma mark - AXChatDataCenterDelegate
- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchChatList:(NSDictionary *)chatList withFriend:(AXMappedPerson *)person lastMessage:(AXMappedMessage *)message
{
    if (_fetchedChatList) {
        _fetchedChatList(chatList,message,person);
        _fetchedChatList = nil;
    }
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter didReceiveMessages:(NSDictionary *)messages
{
    [self downLoadVoiceAndImageWithDictionary:messages];
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter didFetchFriendList:(NSArray *)chatList
{
//todo
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter fetchPersonInfoWithUid:(NSArray *)uid
{
    [self getFriendInfoWithFriendUid:uid];
}

- (void)dataCenter:(AXChatDataCenter *)dataCenter fetchPublicInfoWithUid:(NSArray *)uid
{
    [self getServiceInfoByServiceID:uid[0]];
}

#pragma mark - ASIHTTPRequestDelegate
- (void)didFailedSendMessage:(AXMappedMessage *)failedMessage
{
    [self.dataCenter didFailSendMessageWithIdentifier:failedMessage.identifier];
    _finishSendMessageBlock = self.blockDictionary[failedMessage.identifier];
    if (_finishSendMessageBlock) {
        _finishSendMessageBlock(@[failedMessage],AXMessageCenterSendMessageStatusFailed,AXMessageCenterSendMessageErrorTypeCodeFailed);
    }
    [self.blockDictionary removeObjectForKey:failedMessage.identifier];

}

- (void)saveImageWithMessage:(AXMappedMessage *)message userID:(NSString *)userID responseData:(NSData *)data
{
    UIImage *image = [[UIImage alloc] initWithData:data];
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    [self saveImage:image withFileName:message.identifier ofType:@"jpg" inDirectory:documentsDirectoryPath];
    NSString *imageString = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",message.identifier]];
    message.thumbnailImgPath = imageString;
    message.isImgDownloaded = YES;
    [self.dataCenter updateMessage:message];
    NSDictionary *dic = @{userID: @[message]};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:dic];
    });

}

- (void)saveVoiceWithMessage:(AXMappedMessage *)message userID:(NSString *)userID responseData:(NSData *)data
{
    NSData *voiceData = data;
    NSString *receiveVoicePath = [KKAudioComponent amrToWavWithNSData:voiceData];
    message.imgPath = receiveVoicePath;
    message.isImgDownloaded = YES;
    [self.dataCenter updateMessage:message];
    NSDictionary *dic = @{userID: @[message]};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterDidReceiveNewMessage object:dic];
    });
    
    
}

#pragma mark - AXMessageAPILongLinkDelegate
- (void)manager:(AXMessageAPILongLinkManager *)manager willConnectToServerAsUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId
{
}

- (void)manager:(AXMessageAPILongLinkManager *)manager didReceiveSignal:(AXMessageAPILongLinkSignal)signal userType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    if (signal == AXMessageAPILongLinkSignalQuit) {
        [self longLinkUserDidQuitWithUserType:userType userId:userId userInfo:userInfo];
    }
    if (signal == AXMessageAPILongLinkSignalTimeOut) {
        [self longLinkDidTimeoutWithUserType:userType userId:userId userInfo:userInfo];
    }
    if (signal == AXMessageAPILongLinkSignalHasNewMessage) {
        [self longLinkDidHasNewMessageWithUserType:userType userId:userId userInfo:userInfo];
    }
    if (signal == AXMessageAPILongLinkSignalDuplicateQuit) {
        [self longLinkDidDuplicateQuitWithUserType:userType userId:userId userInfo:userInfo];
    }
    if (signal == AXMessageAPILongLinkSignalSelfClose) {
        [self longLinkDidSelfCloseWithUserType:userType userId:userId userInfo:userInfo];
    }
    if (signal == AXMessageAPILongLinkSignalBye) {
        [self longLinkDidByeWithUserType:userType userId:userId userInfo:userInfo];
    }
    if (signal == AXMessageAPILongLinkSignalInited) {
        [self longLinkDidInitedWithUserType:userType userId:userId userInfo:userInfo];
    }
    if (signal == AXMessageAPILongLinkSignalHasNewPush) {
        [self longLinkDidHasNewPushWithUserType:userType userId:userId userInfo:userInfo];
    }
}

#pragma mark - long link signal response private methods
- (void)longLinkDidInitedWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    [self postConnectionStatusNotificationWithStatus:AXMessageCenterStatusConnected];
}

- (void)longLinkDidByeWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    //服务器主动断开，宋说这个可以忽略，那就不做任何事情。
}

- (void)longLinkDidSelfCloseWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    //只有在主动发送断开连接的请求的时候才会收到SELF_CLOSE
    //在切换用户的时候是不会发送主动断开连接的请求的
    //因此进入这个函数只有应用切入后台这一种情况
    //所以这种情况下也不需要做任何事情
}

- (void)longLinkDidDuplicateQuitWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    //自己把自己T出了，这个情况不管。
}

- (void)longLinkUserDidQuitWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    //被人T掉了，但是用户app还是需要一直保持连接的。
//    [self connectAsDevice];
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *lertview = [[UIAlertView alloc] initWithTitle:@"您的账号已被他人登陆，您已被下线" message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
//        [lertview show];
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterUserDidQuit object:nil userInfo:@{@"status": @(AXMessageCenterStatusUserLoginOut)}];
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterUserDidQuitToAllReceiveNotication object:nil];
        [self switchDataCenterWithUid:kAXMessageManagerLongLinkDeviceUserId];
    });
}

- (void)longLinkDidTimeoutWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    //服务器很久没有收到心跳包了，此时长连接正在后台重连，所以通知到外面就好了。
    [self postConnectionStatusNotificationWithStatus:AXMessageCenterStatusConnecting];
}

- (void)longLinkDidHasNewMessageWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    //长连接告诉你收到新消息了。
    if (userType == AXMessageAPILongLinkUserTypeUser) {
        [self userReceiveAlivingConnectionWithUniqId:userInfo[@"guid"]];
    } else {
        [self appReceiveAlivingConnectionWithUniqId:userInfo[@"guid"]];
    }
}

- (void)longLinkDidHasNewPushWithUserType:(AXMessageAPILongLinkUserType)userType userId:(NSString *)userId userInfo:(NSDictionary *)userInfo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kMessageCenterReceiveNewPush object:nil userInfo:userInfo];
    });
}
- (void)postConnectionStatusNotificationWithStatus:(AXMessageCenterStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:MessageCenterConnectionStatusNotication object:nil userInfo:@{@"status":@(status)}];
    });
}

#pragma mark - long link related methods
- (void)connect
{
    [self connectAsUser];
    [self userReceiveAlivingConnectionWithUniqId:nil];
}

- (void)breakLink
{
    //通过这个函数断开的连接是不会重试的，重试机制会自动关闭。通过connectAsUser或者ConnectAsDevice建立的连接会自动激活重试机制。
    [self.longLinkManager breakLink];
}

- (void)connectAsDevice
{
    [self switchDataCenterToDevice];
    [self registerRemoteNotification];
    [self.longLinkManager connectAsDevice];
    [self postConnectionStatusNotificationWithStatus:AXMessageCenterStatusConnecting];
}

- (void)connectAsUser
{
    [self switchDataCenterToUser];
    [self userReceiveAlivingConnectionWithUniqId:nil];
    [self registerRemoteNotification];
    [self.longLinkManager connectAsUserWithUserid:self.currentPerson.uid];
    [self postConnectionStatusNotificationWithStatus:AXMessageCenterStatusConnecting];
}

- (void)switchDataCenterToUser
{
    NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
    [self switchDataCenterWithUid:loginResult[@"user_info"][@"user_id"]];
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
}

- (void)switchDataCenterToDevice
{
    [self switchDataCenterWithUid:kAXMessageManagerLongLinkDeviceUserId];
    self.currentPerson = [self.dataCenter fetchPersonWithUID:kAXMessageManagerLongLinkDeviceUserId];
    if (self.currentPerson == nil) {
        self.currentPerson = [[AXMappedPerson alloc] init];
    }
    self.currentPerson.uid = kAXMessageManagerLongLinkDeviceUserId;
    [self.dataCenter updatePerson:self.currentPerson];
}

#pragma mark - remote register related methods
- (void)registerRemoteNotification
{
    NSString *notificationToken = [[NSUserDefaults standardUserDefaults] objectForKey:REMOTE_NOTIFCATION_TOKEN];
    if (!notificationToken) {
        return;
    }
    NSMutableDictionary *bodys = [NSMutableDictionary dictionary];
    [bodys setValue:Code_AppName forKey:@"appName"];
    [bodys setValue:[[UIDevice currentDevice] uuid] forKey:@"uuid"];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [bodys setValue:@"" forKey:@"macAddress"];
    } else {
        [bodys setValue:[[UIDevice currentDevice] macaddress] forKey:@"macAddress"];
    }
    [bodys setValue:self.currentPerson.uid forKey:@"userId"];
    [[RTRequestProxy sharedInstance] asyncRESTNotificationWithBodys:bodys token:notificationToken target:self action:@selector(receiveNotificationRegisterFinish:)];
}

#pragma mark - notification response
- (void)receiveNotificationRegisterFinish:(RTNetworkResponse *)response {
    DLog(@"response %@", response.content);
}

- (void)receiveNotificationUserDidLogin
{
    [self connectAsUser];
    [self fetchFriendList];
}

- (void)receiveNoticationNetWorkChange
{
    if (![self.sendMessageManager isReachable]) {
        return ;
    }
    if ([self.imageMessageOperation operationCount] > 0) {
        return;
    }
    NSDictionary *failedMessage = [self.dataCenter messageToDownload];
    [self downLoadVoiceAndImageWithDictionary:failedMessage];
    

}
- (void)receiveNotificationUserLoginOut
{
//    [self connectAsDevice];
}

- (void)receiveNotificationUserInfoChanged
{
    if (self.dataCenter) {
        NSDictionary *loginResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"anjuke_chat_login_info"];
        AXMappedPerson *mySelf = [[AXMappedPerson alloc] init];
        mySelf.uid = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"user_id"]];
        mySelf.phone = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"phone"]];
        mySelf.markName = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name"]];
        mySelf.iconUrl = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"icon"]];
        mySelf.markNamePinyin = [NSString stringWithFormat:@"%@",loginResult[@"user_info"][@"nick_name_pinyin"]];
        mySelf.userType = [loginResult[@"user_info"][@"user_type"] integerValue];
        [self.dataCenter updatePerson:mySelf];
    }
}

@end
