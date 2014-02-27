//
//  ClientDetailPublicViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientDetailPublicViewController.h"
#import "Util_UI.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initDisplay {
    CGFloat imgW = 60;
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 52/2, imgW, imgW)];
    icon.backgroundColor = [UIColor clearColor];
    icon.layer.borderColor = SYSTEM_BLACK.CGColor;
    icon.layer.borderWidth = 0.5;
    icon.layer.cornerRadius = 5;
    [self.view addSubview:icon];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(20 + icon.frame.size.width + 20, icon.frame.origin.y, 200, 25)];
    nameLb.backgroundColor = [UIColor clearColor];
    nameLb.text = self.person.name;//@"基米莱库宁";
    nameLb.textColor = SYSTEM_BLACK;
    nameLb.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:nameLb];
    
    UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(nameLb.frame.origin.x, nameLb.frame.origin.y+ nameLb.frame.size.height +5, 200, 38)];
    tipLb.backgroundColor = [UIColor clearColor];
    tipLb.text = self.person.company;//@"W.D.C";
    tipLb.textColor = SYSTEM_LIGHT_GRAY;
    tipLb.font = [UIFont systemFontOfSize:12];
    tipLb.numberOfLines = 0;
    [self.view addSubview:tipLb];

}

@end
