//
//  AJK_MoreViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreListCell.h"
#import "AppManager.h"

#define CALL_ANJUKE_NUMBER @"400-620-9008"
#define CALL_ANJUKE_ROW 5

@interface MoreViewController ()
@property (nonatomic, strong) NSArray *taskArray;
@property (nonatomic, strong) UITableView *tvList;
@end

@implementation MoreViewController
@synthesize taskArray, tvList;

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
    [self setTitleViewWithString:@"更多"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)initModel {
    self.taskArray = [NSArray arrayWithObjects:@"账户信息", @"提醒设置", @"检查更新", @"关于网络经纪人", @"联系客户主任", @"客服热线", nil];
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
    
}

#pragma mark - private method

- (void)messageSw: (id)sender {
    UISwitch *sw = (UISwitch *)sender;
    
    if (sw.on) {
        DLog(@"推送打开");
    }
    else {
        DLog(@"推送关闭");
    }
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.taskArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MORE_CELL_H;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    MoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[MoreListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
        
    }
    
    [cell configureCell:self.taskArray withIndex:indexPath.row];
    
    if (indexPath.row == 1) {
        //显示消息提醒
        [cell showSwitch];
        [cell.messageSwtich addTarget:self action:@selector(messageSw:) forControlEvents:UIControlEventValueChanged];
    }
    else if (indexPath.row == 4) {
        [cell setDetailText:@"测试"];
    }
    else if (indexPath.row == CALL_ANJUKE_ROW) {
        [cell setDetailText:CALL_ANJUKE_NUMBER];
    }
    
    if (indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case CALL_ANJUKE_ROW:
        {
            //make call
            if (![AppManager checkPhoneFunction]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请检测是否支持电话功能" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                [alertView show];
                return;
            }
            else {
                NSString *call_url = [[NSString alloc] initWithFormat:@"tel://%@",CALL_ANJUKE_NUMBER];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:call_url]];
            }
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
