//
//  AppTestModeSettingViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-28.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "AppTestModeSettingViewController.h"
#import "LocationSpecifyViewController.h"
#import "BK_RTNavigationController.h"

@interface AppTestModeSettingViewController ()

@end

@implementation AppTestModeSettingViewController

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
    [self setTitleViewWithString:@"AppTest Setting"];
    
    // Do any additional setup after loading the view.
    UITableView *tableList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableList.dataSource = self;
    tableList.delegate = self;
    tableList.backgroundColor = [UIColor brokerBgPageColor];;
    tableList.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableList];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    //创建cell
    if (indexPath.row == 0) {
        cell.textLabel.text = @"位置漂移";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"applog alert";

        
        UISwitch * appLogSw = [[UISwitch alloc] initWithFrame:CGRectMake(250, 15, 30, 20)];
        [appLogSw addTarget:self action:@selector(changeSw:) forControlEvents:UIControlEventValueChanged];
        appLogSw.on = NO;
        appLogSw.tag = 100;
        [cell.contentView addSubview:appLogSw];
        
        cell.accessoryView = appLogSw;
    }else if (indexPath.row == 2){
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 12)];
        lab.text = @"Device Token";
        lab.font = [UIFont ajkH5Font];
        [cell.contentView addSubview:lab];
        
        UILabel *tokenLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 290, 30)];
        tokenLab.font = [UIFont ajkH5Font];
        tokenLab.numberOfLines = 0;
        tokenLab.lineBreakMode = UILineBreakModeWordWrap;
        NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_KEY_DEVICE_TOKEN];
        if (token.length > 0 && ![token isKindOfClass:[NSNull class]]) {
            tokenLab.text = token;
        }
        [cell.contentView addSubview:tokenLab];
    }
    
    return cell;

}
- (void)changeSw:(id)sender{
    UISwitch * ws = (UISwitch *)[self.view viewWithTag:100];
    if (ws.on) {
        NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"logShowMode", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QACommandChangeLogShowMode" object:nil userInfo:dic];
    }else{
        NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],@"logShowMode", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QACommandChangeLogShowMode" object:nil userInfo:dic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        LocationSpecifyViewController* viewController = [[LocationSpecifyViewController alloc] init];

        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 1){
    }
}
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
