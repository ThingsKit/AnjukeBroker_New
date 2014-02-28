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

@interface ClientDetailViewController : RTViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, ClientEditPopDelegate>


@property (nonatomic, strong) AXMappedPerson *person;

@end
