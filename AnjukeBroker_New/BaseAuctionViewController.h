//
//  BaseAuctionViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-18.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "BrokerLineView.h"
#import "Util_UI.h"
#import "LoginManager.h"

#define TITLE_OFFSETX 15
#define INPUT_VIEW_HEIGHT 45

@interface BaseAuctionViewController : RTViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField_1;
@property (nonatomic, strong) UITextField *textField_2;
@property (nonatomic, strong) UILabel *rangLabel;

- (void)checkRank;
- (void)doCheckRankWithPropID:(NSString *)propID commID:(NSString *)commID; //此两方法配合用于请求估算排名

@end
