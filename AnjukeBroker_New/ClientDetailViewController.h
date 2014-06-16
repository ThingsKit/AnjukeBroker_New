//
//  ClientDetailViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "AXMappedPerson.h"
#import "ClientEditViewController.h"

typedef NS_ENUM(NSInteger, AXPersonComeFromeType) {
    AXPersonComeFromeTypeNormal = 0,
    AXPersonComeFromeTypeChatView = 1,
};


@interface ClientDetailViewController : RTViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, ClientEditPopDelegate>


@property (nonatomic, strong) AXMappedPerson *person;
@property (nonatomic, assign) AXPersonComeFromeType comeFromeType;
@end
