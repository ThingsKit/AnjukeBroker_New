//
//  AJK_HomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "HomeViewController.h"
#import "AnjukeEditPropertyViewController.h"
#import "SystemMessageViewController.h"
#import "Util_UI.h"
#import "BrokerLineView.h"
#import "RTNavigationController.h"

#define cellHeight 50
#define headerHeight (200+150)/2

@interface HomeViewController ()
@property (nonatomic, strong) NSArray *taskArray;
@property (nonatomic, strong) UITableView *tvList;
@end

@implementation HomeViewController
@synthesize taskArray;
@synthesize tvList;

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
    self.view.backgroundColor = [UIColor clearColor];
    [self setTitleViewWithString:@"我的安居客"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)initModel {
    self.taskArray = [NSArray arrayWithObjects:@"发布二手房", @"发布租房", @"系统消息", nil];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
//    tv.layer.borderColor = [UIColor blackColor].CGColor;
//    tv.layer.borderWidth = 1;
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], headerHeight)];
    headerView.backgroundColor = [UIColor clearColor];
    tv.tableHeaderView = headerView;
    [self drawHeaderWithBG:headerView];
}

- (void)drawHeaderWithBG:(UIView *)BG_View {
    //part 1
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 100)];
    view1.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    [BG_View addSubview:view1];
    
    //photo /name...
    CGFloat photoW = 124/2;
    UIImageView *photo = [[UIImageView alloc] initWithFrame:CGRectMake(52/2, (view1.frame.size.height - photoW)/2, photoW, photoW)];
    photo.backgroundColor = [UIColor whiteColor];
    [view1 addSubview:photo];
    
    //name
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(photo.frame.origin.x*2 +photo.frame.size.width, 17, 100, 20)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:15];
    lb.textColor = SYSTEM_BLACK;
    lb.text = @"梁伟平";
    [view1 addSubview:lb];
    
    //photo number
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y+ lb.frame.size.height+3, lb.frame.size.width, lb.frame.size.height)];
    lb2.backgroundColor = [UIColor clearColor];
    lb2.font = [UIFont systemFontOfSize:15];
    lb2.textColor = SYSTEM_BLACK;
    lb2.text = @"13888888888";
    [view1 addSubview:lb2];
    
    //account info
    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(lb.frame.origin.x, lb2.frame.origin.y+ lb2.frame.size.height+3, 70, lb.frame.size.height)];
    lb3.backgroundColor = [UIColor clearColor];
    lb3.font = [UIFont systemFontOfSize:15];
    lb3.textColor = SYSTEM_LIGHT_GRAY;
    lb3.text = @"账户余额:";
    [view1 addSubview:lb3];
    
    UILabel *lb4 = [[UILabel alloc] initWithFrame:CGRectMake(lb3.frame.origin.x+ lb3.frame.size.width, lb3.frame.origin.y, 80, lb.frame.size.height)];
    lb4.backgroundColor = [UIColor clearColor];
    lb4.font = [UIFont systemFontOfSize:15];
    lb4.textColor = SYSTEM_ORANGE;
    lb4.textAlignment = NSTextAlignmentCenter;
    lb4.text = @"1000.00";
    [view1 addSubview:lb4];
    
    UILabel *yuanLb = [[UILabel alloc] initWithFrame:CGRectMake(lb4.frame.origin.x+ lb4.frame.size.width, lb3.frame.origin.y, 20, lb.frame.size.height)];
    yuanLb.backgroundColor = [UIColor clearColor];
    yuanLb.font = [UIFont systemFontOfSize:15];
    yuanLb.textColor = SYSTEM_LIGHT_GRAY;
    yuanLb.text = @"元";
    [view1 addSubview:yuanLb];
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, view1.frame.size.height - 1, [self windowWidth], 1)];
    [view1 addSubview:line];
    
    //part 2
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 100, [self windowWidth], 75)];
    view2.backgroundColor = [UIColor clearColor];
    [BG_View addSubview:view2];
    
    CGFloat lbW_ = 100;
    NSString *titleStr = [NSString string];
    for (int i = 0; i < 3; i ++) {
        //number label
        UILabel *numLb = [[UILabel alloc] initWithFrame:CGRectMake(10+i *lbW_, 10, lbW_, 25)];
        numLb.backgroundColor = [UIColor clearColor];
        numLb.font = [UIFont systemFontOfSize:20];
        numLb.textColor = SYSTEM_BLACK;
        numLb.text = @"88"; //for test
        numLb.textAlignment = NSTextAlignmentCenter;
        [view2 addSubview:numLb];
        
        switch (i) {
            case 0:
                titleStr = @"在线房源";
                break;
            case 1:
                titleStr = @"今日花费(元)";
                break;
            case 2:
                titleStr = @"今日点击";
                break;
                
            default:
                break;
        }
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10+i *lbW_, numLb.frame.origin.y + numLb.frame.size.height+5, lbW_, 25)];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = [UIFont systemFontOfSize:14];
        titleLb.textColor = SYSTEM_LIGHT_GRAY;
        titleLb.text = titleStr;
        titleLb.textAlignment = NSTextAlignmentCenter;
        [view2 addSubview:titleLb];

    }
    
    BrokerLineView *line2 = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, view2.frame.size.height - 1, [self windowWidth], 1)];
    [view2 addSubview:line2];
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        
    }
    
    cell.textLabel.text = [self.taskArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
//            AnjukeEditPropertyViewController *ae = [[AnjukeEditPropertyViewController alloc] init];
//            [ae setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:ae animated:YES];
            
            //模态弹出
            AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            nav.navigationBar.translucent = NO;
            [self presentViewController:nav animated:YES completion:nil];

        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            SystemMessageViewController *ae = [[SystemMessageViewController alloc] init];
            [ae setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:ae animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
