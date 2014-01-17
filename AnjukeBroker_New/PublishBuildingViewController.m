//
//  PublishBuildingViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBuildingViewController.h"

@interface PublishBuildingViewController ()

@end

@implementation PublishBuildingViewController
@synthesize isHaozu;
@synthesize mainScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *titleStr = @"发布二手房";
    if (self.isHaozu) {
        titleStr = @"发布租房";
    }
    [self setTitleViewWithString:titleStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init Method

- (void)initModel {
    
}

- (void)initDisplay {
    //init main sv
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:FRAME_WITH_NAV];
    sv.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    sv.delegate = self;
    self.mainScrollView = sv;
    [self.view addSubview:sv];
    
}



@end
