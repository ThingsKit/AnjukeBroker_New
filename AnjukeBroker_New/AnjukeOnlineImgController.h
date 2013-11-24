//
//  AnjukeOnlineImgController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/21/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "Property.h"

@protocol OnlineImgSelectDelegate <NSObject>

- (void)onlineImgDidSelect:(NSDictionary *)imgDic;

@end

@interface AnjukeOnlineImgController : RTViewController <UIScrollViewDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) Property *property;
@property (nonatomic, assign) id <OnlineImgSelectDelegate> imageSelectDelegate;

@end
