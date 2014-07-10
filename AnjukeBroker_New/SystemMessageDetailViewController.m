//
//  SystemMessageDetailViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "SystemMessageDetailViewController.h"
#import "Util_UI.h"

@interface SystemMessageDetailViewController ()

@end

@implementation SystemMessageDetailViewController
@synthesize contentTextView;

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
    
    [self setTitleViewWithString:@"系统公告详情"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDisplay {
}

- (void)drawTextWithContent:(NSString *)contentStr {
    UITextView *content = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, [self windowWidth]- 15*2, [self currentViewHeight])];
    content.backgroundColor = [UIColor clearColor];
    content.dataDetectorTypes = UIDataDetectorTypeAll;
    content.editable = NO;
    content.font = [UIFont systemFontOfSize:16];
    content.textColor = SYSTEM_BLACK;
    content.scrollEnabled = YES;
    content.text = contentStr;
    self.contentTextView = content;
    [self.view addSubview:content];
}

@end
