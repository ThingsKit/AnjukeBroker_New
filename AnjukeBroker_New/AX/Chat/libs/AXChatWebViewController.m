//
//  AXChatWebViewController.m
//  Anjuke2
//
//  Created by Gin on 2/23/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXChatWebViewController.h"

@interface AXChatWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AXChatWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSURL *url;
    if (self.webUrl) {
        url = [NSURL URLWithString:self.webUrl];
    } else {
        return;
    }
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
