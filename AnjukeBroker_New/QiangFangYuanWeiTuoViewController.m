//
//  QiangFangYuanWeiTuoViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "QiangFangYuanWeiTuoViewController.h"
#import "UIViewExt.h"

@interface QiangFangYuanWeiTuoViewController ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation QiangFangYuanWeiTuoViewController

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
    [self initUI];
    
}


#pragma mark -
#pragma mark TabButton Action
- (void)leftTabButtonClicked{
    NSLog(@"left clicked");
}

- (void)rightTabButtonClicked{
    NSLog(@"right clicked");
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identify = @"QiangFangYuanWeiTuoViewControllerCellIdentifier";
    
    
    return nil;
}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"市场分析");
    }else if(indexPath.row == 1){
        NSLog(@"小区签到");
    }else{
        NSLog(@"抢房源委托");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


#pragma mark -
#pragma mark Memory Managment

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark init UI
- (void)initUI{
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    headView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    headView.layer.borderWidth = 2.0f;
    headView.layer.cornerRadius = 3.0f;
    headView.layer.masksToBounds = YES;
    
    UIButton* leftTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton* rightTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftTabButton.frame = CGRectMake(0, 0, headView.width/2, headView.height);
    rightTabButton.frame = CGRectMake(headView.width/2, 0, headView.width/2, headView.height);
    [leftTabButton setTitle:@"抢委托" forState:UIControlStateNormal];
    [rightTabButton setTitle:@"我的委托" forState:UIControlStateNormal];
    [leftTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightTabButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftTabButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightTabButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [leftTabButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [rightTabButton setBackgroundColor:[UIColor blackColor]];
    leftTabButton.highlighted = YES;
    
    [leftTabButton addTarget:self action:@selector(leftTabButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightTabButton addTarget:self action:@selector(rightTabButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:leftTabButton];
    [headView addSubview:rightTabButton];
    
    
    
    UIBezierPath* leftPath = [UIBezierPath bezierPathWithRoundedRect:leftTabButton.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headView.bounds;
    maskLayer.path = leftPath.CGPath;
    leftTabButton.layer.mask = maskLayer;
    
    UIBezierPath* rightPath = [UIBezierPath bezierPathWithRoundedRect:rightTabButton.bounds
                                                    byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                                          cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = headView.bounds;
    maskLayer2.path = rightPath.CGPath;
    rightTabButton.layer.mask = maskLayer2;
    
    
    headView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = headView;
    
}

@end
