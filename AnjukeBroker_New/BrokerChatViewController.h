//
//  BrokerChatViewController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 2/24/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "AXChatViewController.h"
#import "AXChatMessageCenter.h"
#import "HouseSelectNavigationController.h"

#import "MapViewController.h"

@interface BrokerChatViewController : AXChatViewController <SelectedHouseWithDicDelegate, UIActionSheetDelegate, UITableViewDelegate>

@property (nonatomic, assign)BOOL     isSayHello;//是否是打招呼页面
@property (nonatomic, strong)NSString *userNickName;//用户名字
@property (nonatomic, strong)NSString *deviceID;//设备的id

- (void)sayHelloHttpRequest:(NSDictionary *)reponseDict;

+ (void)setBrokerSelf:(BrokerChatViewController *)sender;
+ (BrokerChatViewController *)getBrokerSelf;

@end
