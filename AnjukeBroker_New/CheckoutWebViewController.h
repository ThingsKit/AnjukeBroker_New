//
//  CheckoutRuleViewController.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"

@interface CheckoutWebViewController : RTViewController<UIWebViewDelegate>
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *webTitle;

@end
