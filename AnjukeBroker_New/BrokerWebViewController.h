//
//  BrokerWebViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-3-5.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"

@interface BrokerWebViewController : RTViewController <UIWebViewDelegate>

@property (nonatomic, copy) NSString *loadingUrl;

@end
