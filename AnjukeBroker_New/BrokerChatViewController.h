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

@interface BrokerChatViewController : AXChatViewController <SelectedHouseWithDicDelegate, UIActionSheetDelegate>

@property (nonatomic, assign)BOOL isSayHello;

@end
