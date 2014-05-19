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
#import "RTNavigationController.h"

@interface DiscoverViewController ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation DiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.propertyBadgeNumber = 2; //测试用
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
    return 4;
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
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"抢房源委托";
        cell.imageView.image = [UIImage imageNamed:@"anjuke_icon_esf1"];
        
        if (self.badgeView == nil) {
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                self.badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(140, 10, 25, 25)];
            }else{
                self.badgeView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 10, 25, 25)];
            }
            //        badgeView.image = [UIImage imageNamed:@"anjuke_icon_now_position"];
            self.badgeView.backgroundColor = [UIColor redColor];
            self.badgeView.layer.cornerRadius = 12.5f;
            self.badgeView.layer.masksToBounds = YES;
            
            self.badgeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, 20, 20)];
            [self.badgeNumberLabel setTextColor:[UIColor whiteColor]];
            self.badgeNumberLabel.backgroundColor = [UIColor clearColor];
            [self.badgeView addSubview:self.badgeNumberLabel];
            
            if (self.propertyBadgeNumber == 0) {
                self.badgeView.hidden = YES;
            }else{
                self.badgeNumberLabel.text = [NSString stringWithFormat:@"%d", self.propertyBadgeNumber];
                self.badgeView.hidden = NO;
            }
            [cell.contentView addSubview:self.badgeView];
        }
        
        
    }else if(indexPath.row == 3){
        cell.textLabel.text = @"模态Property";
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
    }else if(indexPath.row == 2){
        NSLog(@"抢房源委托");
        self.badgeView.hidden = YES; //消除badge
        
        RushPropertyViewController* viewController = [[RushPropertyViewController alloc] init];
        [viewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if(indexPath.row == 3){
        NSLog(@"模态视图");
        RushPropertyViewController* viewController = [[RushPropertyViewController alloc] init];
        viewController.isModalCancelItemDisplay = YES; //设置为模态视图
        [viewController setHidesBottomBarWhenPushed:YES];
        RTNavigationController* navi = [[RTNavigationController alloc] initWithRootViewController:viewController];
        [self.view.window.rootViewController presentViewController:navi animated:YES completion:nil];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [self.tableView reloadData];
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
