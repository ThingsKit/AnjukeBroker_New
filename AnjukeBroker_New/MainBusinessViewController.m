//
//  FirstViewController.m
//  Tel
//
//  Created by xubing on 13-12-20.
//  Copyright (c) 2013年 xubing. All rights reserved.
//

#import "MainBusinessViewController.h"
#import "AJKListTableViewCell.h"
#import "BrokerRegisterInfoViewController.h"

@interface MainBusinessViewController ()

@property (nonatomic, strong) NSArray *cellTitleArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MainBusinessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentIndex = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"主营业务"];
    self.cellTitleArray = [[NSArray alloc] init];
    self.tag = 2;

}

- (void)viewWillAppear:(BOOL)animated{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self callAPI];
}

-(void)callAPI
{
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:@"common/main-business/" params:@{@"cityId":self.cityId} target:self action:@selector(onGetCellInfo:)];
}

- (void)onGetCellInfo:(RTNetworkResponse *)response {
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    DLog(@"------response [%@]", [response content]);
    self.cellTitleArray = response.content[@"data"][@"business"];
    
    if([self.cellTitleArray count] == 0) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"亲，不好意思暂时没有数据~"];
        return;
    }
    else
        [self.tableView reloadData];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.cellTitleArray count];
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    view.backgroundColor = [UIColor lightTextColor];

    if ([self.cellTitleArray count] != 1 ) {
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        bottomLineView.backgroundColor = [UIColor lightGrayColor];
        [view addSubview:bottomLineView];
    }
    
    return view ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifierCell";
    AJKListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AJKListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *business = [self.cellTitleArray objectAtIndex:indexPath.row];
    NSString *cellString = [business valueForKey:@"businessName"];
    NSDictionary *celldata = @{@"title":cellString};
    int sectionTotalRow = [self.cellTitleArray count];
    
    [cell drawLineWithIndexPath:indexPath sectionTotalRow:sectionTotalRow];
    [cell configWithData:celldata];
    if ([business.allKeys[0] isEqualToString: self.selectCellInfo.allKeys[0]] && [[business valueForKey:business.allKeys[0]] isEqualToString: [self.selectCellInfo valueForKey:self.selectCellInfo.allKeys[0]]]) {
        self.currentIndex = indexPath;
        [cell didSelected:YES];
    } else {
        [cell didSelected:NO];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSMutableArray *)HandleSelectedItemInfoWithDictionary:(NSDictionary *)dic index:(NSIndexPath *)indexPath{
    
    NSString *name = [dic valueForKey:dic.allKeys[0]];
    NSString *ID = dic.allKeys[0];
    NSMutableArray *info = [[NSMutableArray alloc]initWithObjects:name, ID, nil];
    return info;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJKListTableViewCell *oldCell = (AJKListTableViewCell *)[tableView cellForRowAtIndexPath:self.currentIndex];
    [oldCell didSelected:NO];
    AJKListTableViewCell *newCell = (AJKListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [newCell didSelected:YES];
    self.currentIndex = indexPath;
    self.tag = 1;
    [self doBack:self];

}

- (void)doBack:(id)sender{
    [super doBack:sender];
    if (self.tag == 1){
        NSDictionary * selectedCellInfo = [[NSDictionary alloc] init];
        selectedCellInfo = [self.cellTitleArray objectAtIndex:self.currentIndex.row];
        NSLog(@"business%@",selectedCellInfo);
        if ([self.delegate respondsToSelector:@selector(processMainBusinessNameWithDic:)]) {
            [self.delegate processMainBusinessNameWithDic:selectedCellInfo];
        }
    }
    DLog(@"tag %i", self.tag);

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AJKListTableViewCell *newCell = (AJKListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [newCell didSelected:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
