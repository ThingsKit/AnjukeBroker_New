//
//  ClientDetailViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientDetailViewController.h"
#import "ClientDetailCell.h"

#define DETAIL_HEADER_H 52+40

@interface ClientDetailViewController ()

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@end

@implementation ClientDetailViewController
@synthesize tableViewList;
@synthesize listDataArray;

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
    
    [self setTitleViewWithString:@"客户资料"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    self.listDataArray = [NSMutableArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.tableViewList = tv;
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = SYSTEM_LIGHT_GRAY_BG2;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    
    //draw header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], DETAIL_HEADER_H)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.tableViewList setTableHeaderView:headerView];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, 52/2, 40, 40)];
    icon.backgroundColor = [UIColor clearColor];
    icon.layer.borderColor = SYSTEM_BLACK.CGColor;
    icon.layer.borderWidth = 0.5;
    icon.layer.cornerRadius = 5;
    [headerView addSubview:icon];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE + icon.frame.size.width + CELL_OFFSET_TITLE, icon.frame.origin.y, 200, 25)];
    nameLb.backgroundColor = [UIColor clearColor];
    nameLb.text = @"基米莱库宁";
    nameLb.textColor = SYSTEM_BLACK;
    nameLb.font = [UIFont systemFontOfSize:19];
    [headerView addSubview:nameLb];
    
    UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(nameLb.frame.origin.x, nameLb.frame.origin.y+ nameLb.frame.size.height +5, 200, 15)];
    tipLb.backgroundColor = [UIColor clearColor];
    tipLb.text = @"W.D.C";
    tipLb.textColor = SYSTEM_LIGHT_GRAY;
    tipLb.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:tipLb];
    
    //draw footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 50)];
    footerView.backgroundColor = [UIColor clearColor];
    [self.tableViewList setTableFooterView:footerView];
    
    CGFloat btnW = 200;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(([self windowWidth] - btnW )/2, 23, btnW, 75/2);
    [btn setTitle:@"微聊" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startChart) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_bluebutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(77/2-1, 5, 77/2+1, 52/2-5)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_bluebutton1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(77/2-1, 5, 77/2+1, 52/2-5)resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
    [footerView addSubview:btn];
    
}

#pragma mark - Private Method

- (void)startChart {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return CLIENT_DETAIL_TEL_HEIGHT;
    }
    return CLIENT_DETAIL_MESSAGE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    ClientDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ClientDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    else {
        
    }
    [cell configureCell:nil withIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
