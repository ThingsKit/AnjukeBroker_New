//
//  RentSelectNoPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/20/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "RentSelectNoPlanController.h"
#import "SaleFixedDetailController.h"
#import "BaseNoPlanListCell.h"
#import "SaleNoPlanListCell.h"
#import "SaleNoPlanListManager.h"
#import "LoginManager.h"

@interface RentSelectNoPlanController ()

@end

@implementation RentSelectNoPlanController
@synthesize fixedObj;

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
    [self addRightButton:@"确定" andPossibleTitle:nil];
    self.myTable.frame = FRAME_WITH_NAV;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];
}

#pragma mark - Request 未推广列表
-(void)doRequest{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/prop/getfixprops/" params:params target:self action:@selector(onGetSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
- (void)onGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    //    NSMutableArray *result = [SaleNoPlanListManager propertyObjectArrayFromDicArray:[resultFromAPI objectForKey:@"propertyList"]];
    //    [self.myArray removeAllObjects];
    //    [self.myArray addObjectsFromArray:result];
    //    [self.myTable reloadData];
    //    [self hideLoadWithAnimated:YES];
    //    self.isLoading = NO;
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return ;
    }
    //    NSMutableDictionary *dicPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"plan"]];
    [self.myArray removeAllObjects];
    //    [self.myArray addObject:[SaleFixedManager fixedPlanObjectFromDic:dicPlan]];
    [self.myArray addObjectsFromArray:[SaleNoPlanListManager propertyObjectArrayFromDicArray:[resultFromAPI objectForKey:@"propertyList"]]];
    
    [self.myTable reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - Request 定价推广
-(void)doFixed{
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    //    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  @"187275101", @"proIds", @"388666", @"planId", nil];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  [self getStringFromArray:self.selectedArray], @"propIds", self.fixedObj.fixedId, @"planId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/addpropstoplan/" params:params target:self action:@selector(onFixedSuccess:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onFixedSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSString *)getStringFromArray:(NSArray *) array{
    NSMutableString *tempStr = [NSMutableString string];
    for (int i=0;i<[array count];i++) {
        SalePropertyObject *pro = (SalePropertyObject *)[array objectAtIndex:i];
        if(tempStr.length == 0){
            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
        }else{
            [tempStr appendString:@","];
            [tempStr appendString:[NSString stringWithFormat:@"%@",pro.propertyId]];
        }
    }
    
    DLog(@"====%@",tempStr);
    return tempStr;
}

#pragma mark - tableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    SaleNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[SaleNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
    }
    [cell configureCell:[self.myArray objectAtIndex:indexPath.row] withIndex:indexPath.row];
    if([self.selectedArray containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_selected@2x.png"];
    }else{
        cell.btnImage.image = [UIImage imageNamed:@"anjuke_icon06_select@2x.png"];
    }
    [cell.mutableBtn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchDown];
    cell.mutableBtn.tag = [indexPath row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:[indexPath row]]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:[indexPath row]]];
        
    }
    [self.myTable reloadData];
}

#pragma mark - PrivateMethod
-(void)rightButtonAction:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_SELECT_003 note:nil];
    if(self.isLoading){
        return ;
    }
    [self doFixed];
    //    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickButton:(id) sender{
    UIButton *but = (UIButton *)sender;
    if(![self.selectedArray containsObject:[self.myArray objectAtIndex:but.tag]]){
        [self.selectedArray addObject:[self.myArray objectAtIndex:but.tag]];
        
    }else{
        [self.selectedArray removeObject:[self.myArray objectAtIndex:but.tag]];
    }
    [self.myTable reloadData];
}
- (void)doBack:(id)sender{
    [super doBack:self];
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_SELECT_004 note:nil];
}
@end
