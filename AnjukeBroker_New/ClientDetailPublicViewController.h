//
//  ClientDetailPublicViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "AXMappedPerson.h"

typedef NS_ENUM(NSInteger, AXPersonPublicComeFromeType) {
    AXPersonPublicComeFromeTypeNormal = 0,
    AXPersonPublicComeFromeTypeChatView = 1,
};


@interface ClientDetailPublicViewController : RTViewController

@property (nonatomic, strong) AXMappedPerson *person;
@property (nonatomic, assign) AXPersonPublicComeFromeType publicComeFromeType;


@end
