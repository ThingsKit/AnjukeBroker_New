//
//  BigImageViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-30.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyBigImageViewController.h"

@interface PropertyBigImageViewController ()

@end

@implementation PropertyBigImageViewController
@synthesize contentImgView;
@synthesize btnDelegate;

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
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ITEM_BTN_FRAME;
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = rButton;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight])];
    img.backgroundColor = [UIColor whiteColor];
    img.contentMode = UIViewContentModeScaleAspectFit;
//    img.layer.borderColor = [UIColor blackColor].CGColor;
//    img.layer.borderWidth = 1;
    [img setUserInteractionEnabled:YES];
    self.contentImgView = img;
    [self.view addSubview:img];
    
    CGFloat btnW = 30;
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake([self windowWidth] - btnW*3, btnW, btnW*2, btnW);
    deleteBtn.layer.cornerRadius = 5;
    deleteBtn.backgroundColor = [UIColor lightGrayColor];
    [deleteBtn setTitle:@"删" forState:UIControlStateNormal];
//    deleteBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    deleteBtn.layer.borderWidth = 1;
    [deleteBtn addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
    [img addSubview:deleteBtn];
}

- (void)doBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doDelete {
    if ([self.btnDelegate respondsToSelector:@selector(deletebtnClick)]) {
        [self.btnDelegate deletebtnClick];
    }
    
    [self doBack];
}

@end
