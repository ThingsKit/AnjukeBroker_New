//
//  PPCSelectedListViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-2.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCSelectedListViewController.h"
#import "RTListCell.h"
#import "PPCSelectedListCell.h"

@interface PPCSelectedListViewController ()
@property(nonatomic, strong) NSMutableArray *tableData;
@property(nonatomic, strong) NSMutableArray *onSpreadListData;
@property(nonatomic, strong) NSMutableArray *onQueueListData;
@property(nonatomic, assign) NSInteger overNum;
@property(nonatomic, assign) BOOL isLoading;
@end

@implementation PPCSelectedListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tableData = [[NSMutableArray alloc] init];
        self.onSpreadListData = [[NSMutableArray alloc] init];
        self.onQueueListData = [[NSMutableArray alloc] init];
        self.overNum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleViewWithString:@"精选推广"];

    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableList];
    
    [self autoPullDown];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableData.count == 0) {
        return 0;
    }
    return self.tableData.count + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }else if (indexPath.row == self.tableData.count + 2){
        return 45;
    }else if (indexPath.row == self.tableData.count + 1){
        return 15;
    }
    return 95;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }else if (section == 1){
        return @"推广中";
    }else if (section == 1){
        return @"排队中";
    }else if (section == 1){
        return @"推广结束";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify1 = @"cell1";
    static NSString *identify2 = @"cell1";
    
    if (indexPath.row == 0 || indexPath.row == self.tableData.count + 1 || indexPath.row == self.tableData.count + 2) {
        RTListCell *cell = (RTListCell *)[tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 40)];
            lab.textAlignment = NSTextAlignmentLeft;
            lab.textColor = [UIColor brokerMiddleGrayColor];
            lab.font = [UIFont ajkH3Font];
            lab.text = @"精选房源提升8被效果";
            lab.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lab];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(185, 0, 120, 40);
            [btn setTitle:@"什么是精选房源?" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor brokerBlueColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor brokerBlueGrayColor] forState:UIControlStateHighlighted];
            [cell.contentView addSubview:btn];
        }else if (indexPath.row == self.tableData.count + 1){
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.row == self.tableData.count + 2){
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            [cell showTopLine];
            cell.textLabel.text = [NSString stringWithFormat:@"推广结束(%@)",@"3"];
            cell.textLabel.textColor = [UIColor brokerBlackColor];
            [cell showBottonLineWithCellHeight:45];
        }
        return cell;
    }else{
        PPCSelectedListCell *cell = (PPCSelectedListCell *)[tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[PPCSelectedListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        
        [cell configureCell:nil withIndex:indexPath.row];
        
        return cell;
    }
    
    return nil;
}

- (void)doRequest{
    self.isLoading = YES;
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (self.isHaozu) {
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId", nil];

        method = [NSString stringWithFormat:@"zufang/choice/props/"];
    }else{
        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken],@"token",[LoginManager getUserID],@"brokerId",@"1",@"demon", nil];
        
        method = [NSString stringWithFormat:@"anjuke/choice/summary/"];
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}
- (void)onRequestFinished:(RTNetworkResponse *)response{
    self.isLoading = NO;
    DLog(@"response---->>%@",[response content]);
    if([[response content] count] == 0){
        [self donePullDown];
        [self.tableList setTableStatus:STATUSFORNODATAFORPRICINGLIST];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        
        self.tableData = nil;
        [self.tableList reloadData];
        
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        DLog(@"message--->>%@",[[response content] objectForKey:@"message"]);
        
        [self.tableList setTableStatus:STATUSFORNETWORKERROR];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGus:)];
        tapGes.delegate                = self;
        tapGes.numberOfTouchesRequired = 1;
        tapGes.numberOfTapsRequired    = 1;
        [self.tableList.tableHeaderView addGestureRecognizer:tapGes];
        
        
        self.tableData = nil;
        [self.tableList reloadData];
        
        [self donePullDown];
        return;
    }
    [self donePullDown];

    
    
    
}

- (void)tapGus:(UITapGestureRecognizer *)tap{
    [self autoPullDown];
}
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.tableData || self.navigationController.view.frame.origin.x > 0) {
        return;
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
