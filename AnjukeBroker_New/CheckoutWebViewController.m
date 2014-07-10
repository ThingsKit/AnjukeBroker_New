//
//  CheckoutRuleViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-13.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "CheckoutWebViewController.h"

@interface CheckoutWebViewController ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CheckoutWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.webView = [[UIWebView alloc] init];
        self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
        self.webView.delegate = self;
        [self.view addSubview:self.webView];

    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if (self.webTitle) {
        [self setTitleViewWithString:self.webTitle];
    }
    NSURL *url;
    if (self.webUrl) {
        url = [NSURL URLWithString:self.webUrl];
    } else {
        return;
    }
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    if (!self.webTitle) {
//        [self setTitleViewWithString:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
//    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
