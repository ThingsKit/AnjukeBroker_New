//
//  ClientEditViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientEditViewController.h"
#import "Broker_InputEditView.h"
#import "Util_UI.h"

@interface ClientEditViewController ()

@end

@implementation ClientEditViewController

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
    
    [self setTitleViewWithString:@"备注"];
    [self.view setBackgroundColor:SYSTEM_LIGHT_GRAY_BG2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    
}

- (void)initDisplay {
    NSArray *titleArr = [NSArray arrayWithObjects:@"备注名", @"电话号码", @"备注信息", nil];
    
    for (int i = 0; i < titleArr.count; i ++) {
        Broker_InputEditView *bi = [[Broker_InputEditView alloc] initWithFrame:CGRectMake(0, 10 + INPUT_EDIT_VIEW_H* i, [self windowWidth], INPUT_EDIT_VIEW_H)];
        bi.backgroundColor = [UIColor whiteColor];
        bi.displayStyle = DisplayStyle_ForTextField;
        bi.titleLb.text = [titleArr objectAtIndex:i];
        [bi addLineViewWithOriginY:INPUT_EDIT_VIEW_H-0.5]; //bottom line
        if (i == 0) {
            [bi addLineViewWithOriginY:-0.5]; //top line
        }
        [self.view addSubview:bi];
    }
    
}

#pragma mark - Private Method



@end
