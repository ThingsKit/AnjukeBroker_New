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
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doBack)];
    self.navigationItem.leftBarButtonItem = rButton;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight])];
    img.backgroundColor = [UIColor whiteColor];
    img.contentMode = UIViewContentModeScaleAspectFit;
//    img.layer.borderColor = [UIColor blackColor].CGColor;
//    img.layer.borderWidth = 1;
    [img setUserInteractionEnabled:YES];
    self.contentImgView = img;
    [self.view addSubview:img];
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(doDelete)];
    self.navigationItem.rightBarButtonItem = deleteItem;
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
