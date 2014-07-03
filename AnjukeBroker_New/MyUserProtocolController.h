//
//  AboutController_iPhone.h
//  Anjuke
//
//  Created by zhengpeng on 7/20/11.
//  Modified by Yi Qi on 2014/04/28.
//  Copyright 2011 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTViewController.h"

@interface MyUserProtocolController : RTViewController <UIWebViewDelegate>{
    UIWebView *_webView;
}

@property (nonatomic, strong) UIWebView *webView;

@end
