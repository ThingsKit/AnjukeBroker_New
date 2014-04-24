//
//  ClientDetailPublicViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientDetailPublicViewController.h"
#import "Util_UI.h"
#import "WebImageView.h"
#import "BrokerChatViewController.h"

@interface ClientDetailPublicViewController ()

@end

@implementation ClientDetailPublicViewController
@synthesize person;

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
    
    [self setTitleViewWithString:@"详细资料"];
    self.view.backgroundColor = SYSTEM_LIGHT_GRAY_BG2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initDisplay {
    CGFloat imgW = 60;
    WebImageView *icon = [[WebImageView alloc] initWithFrame:CGRectMake(20, 52/2, imgW, imgW)];
    icon.backgroundColor = [UIColor clearColor];
    icon.layer.borderColor = [UIColor whiteColor].CGColor;
    icon.layer.borderWidth = 0.5;
    icon.layer.cornerRadius = 5;
    if (self.person.isIconDownloaded) {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        icon.image = [[UIImage alloc] initWithContentsOfFile:[libraryPath stringByAppendingPathComponent:self.person.iconPath]];
    }
    else
        icon.imageUrl = self.person.iconUrl;
    [self.view addSubview:icon];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(20 + icon.frame.size.width + 20, icon.frame.origin.y, 200, 25)];
    nameLb.backgroundColor = [UIColor clearColor];
    nameLb.text = self.person.name;
    nameLb.textColor = SYSTEM_BLACK;
    nameLb.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:nameLb];
    
    
    CGSize size = [Util_UI sizeOfString:self.person.markDesc maxWidth:200 withFontSize:12];
    UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(nameLb.frame.origin.x, nameLb.frame.origin.y+ nameLb.frame.size.height +5, 200, size.height)];
    tipLb.backgroundColor = [UIColor clearColor];
    tipLb.text = self.person.markDesc;
    tipLb.textColor = SYSTEM_LIGHT_GRAY;
    tipLb.font = [UIFont systemFontOfSize:12];
    tipLb.numberOfLines = 0;
    [self.view addSubview:tipLb];

    CGFloat btnW = 300;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(([self windowWidth] - btnW )/2, 200, btnW, 84/2);
    [btn setTitle:@"微聊" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startChart) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_bluebutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_bluebutton1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    
}

- (void)startChart {
    BrokerChatViewController *bc = [[BrokerChatViewController alloc] init];
    bc.isBroker = YES;
    bc.uid = self.person.uid;
    [self.navigationController pushViewController:bc animated:YES];
}


@end
