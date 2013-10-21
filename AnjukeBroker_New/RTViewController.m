//
//  AJK_RTViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-16.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@interface RTViewController ()

@end

@implementation RTViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initModel];
    [self initDisplay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)setTitleViewWithString:(NSString *)titleStr { //设置标题栏
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:21];
    lb.text = titleStr;
    lb.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = lb;
}

- (void)initModel {
    
}

- (void)initDisplay {
    
}

- (NSInteger)windowHeight {
    //扣除状态栏20像素
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;

}

- (NSInteger)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}

@end
