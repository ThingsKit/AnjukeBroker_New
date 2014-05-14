//
//  QiangFangYuanWeiTuoViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RushPropertyViewController.h"
#import "UIViewExt.h"
#import "NetworkRequest.h"
#import "PropertyModel.h"
#import "MyPropertyModel.h"


@interface RushPropertyViewController ()

@property (nonatomic, strong) PropertyTableView* tableView;

@end

@implementation RushPropertyViewController

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
    [self initUI]; //初始化 self.navigationItem.titleView
    
    self.tableView = [[PropertyTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.eventDelegate = self;
    
    [self autoRefresh]; //自动刷新
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
#pragma mark - BaseTableViewDelegate

- (void)pullDown:(BaseTableView *)tableView {
    self.tableView.isPullUp = NO;
    
//    [NetworkRequest requestWithURL:@"<#string#>" params:params httpMethod:@"GET" requestDidFinishBlock:^(id result) {
//        
//    }];
    
//    "status": "ok",
//    "data": [
//             {
//                 "commName": "新中苑",
//                 "type": "2",
//                 "room": "2",
//                 "hall": "2",
//                 "toilet": "2",
//                 "area": "50",
//                 "price": "2000",
//                 "priceUnit": "元/月",
//                 "publishTime": "2014-05-01 06:03:07",
//                 "rushable": "1",
//                 "rushed": "0"
//             },
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"新中源",@"commName",
                         @"2",@"type",
                         @"2",@"room",
                         @"2",@"hall",
                         @"2",@"toilet",
                         @"50",@"area",
                         @"2000",@"price",
                         @"元/月",@"priceUnit",
                         @"2014-05-01 06:03:07",@"publishTime",
                         @"0",@"rushable",
                         @"1",@"rushed",
                         nil];
    NSDictionary* dic2 = @{@"commName": @"张江汤臣豪园",
                          @"type":@"2",
                          @"room":@"2",
                          @"hall":@"1",
                          @"toilet":@"1",
                          @"area":@"300",
                          @"price":@"200",
                          @"priceUnit":@"万",
                          @"publishTime":@"2014-05-01 06:03:07",
                          @"rushable":@"1",
                          @"rushed":@"0"
                          };
    PropertyModel* property = [[PropertyModel alloc] initWithDataDic:dic];
    PropertyModel* property2 = [[PropertyModel alloc] initWithDataDic:dic2];
    
    NSArray* list = @[property, property2];
    self.tableView.data = list;
    
    [self.tableView reloadData];

}

- (void)pullUp:(BaseTableView *)tableView {
    self.tableView.isPullUp = YES;
    
}

- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (void) autoRefresh {
    
    self.tableView.hidden = NO;
    [self.tableView autoPullDownRefresh]; //自动下拉
    //加载数据
    [self pullDown:nil];
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
