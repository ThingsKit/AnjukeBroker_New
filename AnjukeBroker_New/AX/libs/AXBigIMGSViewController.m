//
//  BigIMGSViewController.m
//  X
//
//  Created by jianzhongliu on 2/20/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXBigIMGSViewController.h"
#import "AXChatViewController.h"

@interface AXBigIMGSViewController ()

@property (strong, nonatomic) UIScrollView *scrollview;
@property (strong, nonatomic) UIPageControl *controller;

@end

@implementation AXBigIMGSViewController
@synthesize img;
@synthesize imgView;
@synthesize myIMGArray;

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
    [self initModel];
    [self initUI];
    
	// Do any additional setup after loading the view.
}
- (void)initModel {
    self.myIMGArray = [NSMutableArray array];
    [self.myIMGArray addObject:self.img];
    [self.myIMGArray addObject:[UIImage imageNamed:@"demo-avatar-woz.png"]];
    [self.myIMGArray addObject:self.img];
    [self.myIMGArray addObject:self.img];
    [self.myIMGArray addObject:self.img];
    //    self.myIMGArray add
    
}
- (void)initUI {
    self.scrollview = [[UIScrollView alloc] init];
    self.scrollview.backgroundColor = [UIColor blackColor];
    self.scrollview.frame = CGRectMake(0, 0, AXWINDOWWHIDTH, AXWINDOWHEIGHT);
    self.scrollview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollview.contentSize = CGSizeMake(AXWINDOWWHIDTH * 1, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight);  //scrollview的滚动范围
    //    self.scrollview.backgroundColor = [UIColor clearColor];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.contentOffset = CGPointMake(0 * AXWINDOWWHIDTH, 0);
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
    self.scrollview.scrollEnabled = YES;
    self.scrollview.pagingEnabled = YES;
    self.scrollview.bounces = NO;
    self.controller = [[UIPageControl alloc] initWithFrame:CGRectMake(150, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight, 20, 20)];
    self.controller.numberOfPages = 1;
    self.controller.currentPage = 0;
    [self.controller addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.scrollview];
    [self.view addSubview:self.controller];
    
    self.imgView = [[UIImageView alloc] initWithImage:self.img];
    self.imgView.backgroundColor = [UIColor redColor];
    self.imgView.image = [myIMGArray objectAtIndex:0];
    CGRect rect = [self sizeOFImg:self.imgView.image];
    self.imgView.frame = CGRectMake((AXWINDOWWHIDTH - rect.size.width) / 2.0f, (AXWINDOWHEIGHT - rect.size.height - AXNavBarHeight - AXStatuBarHeight) / 2.0f, rect.size.width, rect.size.height);
    //    self.imgView.frame = CGRectMake(0, 0, WINDOWWHIDTH, WINDOWHEIGHT);
    [self.scrollview addSubview:self.imgView];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int page = self.scrollview.contentOffset.x / 320;
    self.controller.currentPage = page;
    //    self.imgView.image = [myIMGArray objectAtIndex:page];
    
    CGRect rect = [self sizeOFImg:self.imgView.image];
    self.imgView.frame = CGRectMake((AXWINDOWWHIDTH - rect.size.width) / 2.0f + page * 320, (AXWINDOWHEIGHT - rect.size.height - AXNavBarHeight - AXStatuBarHeight) / 2.0f, rect.size.width, rect.size.height);
    
}

- (void)changePage:(id)sender {
    
    int page = self.controller.currentPage;
    [self.scrollview setContentOffset:CGPointMake(320 * page, 0)];
    
}

#pragma mark -
- (UIImageView *)dequeueReusablePhotoView {
    return  [[UIImageView alloc] init];
}

- (CGRect)sizeOFImg:(UIImage *)image {
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    
    if (rect.size.height > (AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight) * 2) {
        rect.size.height = (AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight) * 2;
        rect.size.width = AXWINDOWWHIDTH * (AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight) / rect.size.height * 2;
    }
    
    if (rect.size.width > AXWINDOWWHIDTH * 2) {
        rect.size.width = AXWINDOWWHIDTH * 2;
        rect.size.height = AXWINDOWWHIDTH/ rect.size.width * rect.size.height * 2;
    }
    
    rect.size.height = rect.size.height / 2.0f;
    rect.size.width = rect.size.width / 2.0f;
    return rect;
}

@end
