//
//  BigImageViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyBigImageViewController.h"
#import "Util_UI.h"

@interface PropertyBigImageViewController ()

@end

@implementation PropertyBigImageViewController
@synthesize contentImgView;
@synthesize btnDelegate;
@synthesize isOnlineImg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.backType = RTSelectorBackTypeDismiss;
    }
    return self;
}

- (void)dealloc {
    DLog(@"dealloc PropertyBigImageViewController");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleViewWithString:@"查看大图"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initModel {
    
}

- (void)initDisplay {
   WebImageView *img = [[WebImageView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight])];
    img.backgroundColor = SYSTEM_BLACK;
    img.contentMode = UIViewContentModeScaleAspectFit;
//    img.layer.borderColor = [UIColor blackColor].CGColor;
//    img.layer.borderWidth = 1;
    [img setUserInteractionEnabled:YES];
    self.contentImgView = img;
    [self.view addSubview:img];

    self.backType = RTSelectorBackTypeDismiss;
    
    UIBarButtonItem *deleteItem = [UIBarButtonItem getBarButtonItemWithString:@"删除" taget:self action:@selector(doDelete)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [self.navigationItem setRightBarButtonItem:deleteItem];
    }else{//fix ios7 10像素偏离
        UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:-10.0];
        [self.navigationItem setRightBarButtonItems:@[spacer, deleteItem]];
    }
}

- (void)doBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doDelete {
    if ([self.btnDelegate respondsToSelector:@selector(deletebtnClickForOnlineImg:)]) {
        [self.btnDelegate deletebtnClickForOnlineImg:self.isOnlineImg];
    }
    
    [self doBack];
}

@end
