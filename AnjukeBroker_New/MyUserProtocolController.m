    //
//  AboutController_iPhone.m
//  Anjuke
//
//  Created by zhengpeng on 7/20/11.
//  Copyright 2011 anjuke. All rights reserved.
//

#import "MyUserProtocolController.h"
//#import "AJKUtilUI.h"


@implementation MyUserProtocolController

@synthesize webView = _webView;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
//- (void)loadView {
//    self.view = [self setupBackgroundView];
//    
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] init];
    self.webView = webView;
    self.webView.delegate = self;
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_webView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_webView)]];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"protocol" ofType:@"html"];
    NSString *imagePath = [bundle pathForResource:@"anjukelogo" ofType:@"png"];
    
    NSString *html = [NSString stringWithFormat:[NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:nil],imagePath];
    [self.webView loadHTMLString:html baseURL:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [self setTitleViewWithString:@"用户服务协议"];
//    [self setTitleNavigation:@"用户服务协议"];
    
    // set right button of nav
    self.navigationItem.leftBarButtonItem = nil;
    UIImage *image = [UIImage imageNamed:@"comm_icon_close.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, 44);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button setImage:[UIImage imageNamed:@"comm_icon_close.png"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"comm_icon_close_slt"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

//-(void) rightBarButtonAction:(id)sender
//{
//    [self backButtonClick];
//}

- (void)doBack:(id)sender {
    [self backButtonClick];
}

- (void)backButtonClick {
    if (self.presentingViewController) {
//        [self sendReturnLog];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
