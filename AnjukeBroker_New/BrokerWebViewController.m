//
//  BrokerWebViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-3-5.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BrokerWebViewController.h"
#import "Util_UI.h"

@interface BrokerWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BrokerWebViewController
@synthesize webView;
@synthesize loadingUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDisplay {
    UIWebView *wv = [[UIWebView alloc] initWithFrame:FRAME_WITH_NAV];
    self.webView = wv;
    wv.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    wv.delegate = self;
    [self.view addSubview:wv];
    
    NSURL *url = [NSURL URLWithString:self.loadingUrl];
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL:url];
    [wv loadRequest:requestUrl];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showLoadingActivity:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadWithAnimated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideLoadWithAnimated:YES];
}

@end
