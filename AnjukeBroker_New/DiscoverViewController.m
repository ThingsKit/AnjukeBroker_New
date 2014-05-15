//
//  DiscoverViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "DiscoverViewController.h"
#import "UIViewExt.h"
#import "CheckoutCommunityViewController.h"
#import "FindHomeViewController.h"
#import "RushPropertyViewController.h"


@interface DiscoverViewController ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation DiscoverViewController

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
    [self setTitleViewWithString:@"发现"];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
//    headView.backgroundColor = [UIColor yellowColor];
    self.tableView.tableHeaderView = headView;
    
}


#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* identify = @"DiscoverViewControllerCellIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"市场分析";
        cell.imageView.image = [UIImage imageNamed:@"anjuke_icon_esf1"];
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"小区签到";
        cell.imageView.image = [UIImage imageNamed:@"anjuke_icon_esf1"];
    }else{
        cell.textLabel.text = @"抢房源委托";
        cell.imageView.image = [UIImage imageNamed:@"anjuke_icon_esf1"];
        
        UIImageView* badgeView;
        if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
            badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 6, 30, 30)];
        }else{
            badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 6, 30, 30)];
        }
        badgeView.image = [UIImage imageNamed:@"anjuke_icon_now_position"];
        
        UILabel* badgeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, 25, 25)];
        badgeNumberLabel.text = @"2";
        [badgeNumberLabel sizeToFit];
        badgeNumberLabel.backgroundColor = [UIColor clearColor];
        [badgeView addSubview:badgeNumberLabel];
        
        [cell.contentView addSubview:badgeView];
        
    }
    
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSLog(@"市场分析");
        FindHomeViewController *ae = [[FindHomeViewController alloc] init];
        [ae setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ae animated:YES];
    }else if(indexPath.row == 1){
        NSLog(@"小区签到");
        CheckoutCommunityViewController *communityVC = [[CheckoutCommunityViewController alloc] init];
        [communityVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:communityVC animated:YES];
    }else{
        NSLog(@"抢房源委托");
        RushPropertyViewController* viewController = [[RushPropertyViewController alloc] init];
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}





#pragma mark -
#pragma Memory Management
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

@end
