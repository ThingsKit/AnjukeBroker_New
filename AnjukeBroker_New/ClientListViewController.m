//
//  ClientListViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientListViewController.h"
#import "ClientDetailViewController.h"
#import "ClientDetailPublicViewController.h"
#import "Util_UI.h"
#import "AXChatMessageCenter.h"
#import "AXMappedPerson.h"
#import "BrokerChatViewController.h"

@interface ClientListViewController ()

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@property (nonatomic, strong) NSMutableArray *publicDataArr; //公共账号列表
@property (nonatomic, strong) NSMutableArray *starDataArr; //星标客户列表
@property (nonatomic, strong) NSMutableArray *allDataArr; //所有客户列表

@property (nonatomic, strong) NSArray *testArr;

@end

@implementation ClientListViewController
@synthesize publicDataArr, starDataArr, allDataArr;
@synthesize tableViewList, listDataArray;


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
    
    [self setTitleViewWithString:@"我的客户"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showLoadingActivity:YES];
    [self getFriendList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFriendList {
    [[AXChatMessageCenter defaultMessageCenter] friendListWithPersonWithCompeletionBlock:^(NSArray *friendList, BOOL whetherSuccess) {
        if (whetherSuccess) {
            [self hideLoadWithAnimated:YES];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.testArr = [NSArray arrayWithArray:friendList];
                [self redrawList];
            });
        }
    }];
}

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_LIST_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_LIST_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - init Method

- (void)initModel {
    self.publicDataArr = [NSMutableArray array];
    self.starDataArr = [NSMutableArray array];
    self.allDataArr = [NSMutableArray array];
    self.listDataArray = [NSMutableArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.tableViewList = tv;
    tv.delegate = self;
    tv.dataSource = self;
//    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    
    if (self.isForMessageList) {
        self.tableViewList.frame = FRAME_WITH_NAV;
    }
}

- (void)redrawList {
    self.listDataArray = [NSMutableArray array];
    [self.publicDataArr removeAllObjects];
    [self.starDataArr removeAllObjects];
    [self.allDataArr removeAllObjects];
    
    //reset 3 list arr ...
    //获取公共账号
    for (int i = 0; i < self.testArr.count; i++) {
        AXMappedPerson *item = [self.testArr objectAtIndex:i];
        if (item.userType == AXPersonTypePublic) {
//            DLog(@"public item [%@]", item);
            [self.publicDataArr addObject:item];
        }
        else
            [self.allDataArr addObject:item];
    }
    
    //非公共账号处理
    NSArray *star_arr = [NSArray arrayWithArray:self.testArr];
    
    for (int i = 0; i < star_arr.count; i ++) {
        if ([(AXMappedPerson *)[star_arr objectAtIndex:i] userType] == AXPersonTypeUser) {
            if ([(AXMappedPerson *)[star_arr objectAtIndex:i] isStar] == YES) {
                
//                DLog(@"star item [%@]", [star_arr objectAtIndex:i]);
                [self.starDataArr addObject:[star_arr objectAtIndex:i]]; //星标用户
            }
        }
    }
    
    //所有用户
//    self.allDataArr = [NSMutableArray arrayWithArray:self.testArr];
    
    //add 3 arr to list data att
    [self.listDataArray addObject:self.publicDataArr];
    [self.listDataArray addObject:self.starDataArr];
    [self.listDataArray addObject:self.allDataArr];
    
    [self.tableViewList reloadData];
    
    [self checkToAlert];
}

- (void)checkToAlert {
    NSArray *arr = [LoginManager getClientCountAlertArray];
    
    for (int i = 0; i < arr.count; i ++) {
        NSString *count = [arr objectAtIndex:i];
        if (self.allDataArr.count >= [count intValue]) {
            //公众号上限提醒
            NSMutableDictionary *params = nil;
            NSString *method = nil;
            
            //for test
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getChatID], @"toChatId", [LoginManager getUserID], @"brokerId", @"overFriend", @"msgType", count, @"msg", nil];
            method = @"msg/sendpublicmsg/";
            
            [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onAlertFinished:)];
            
            break;
        }
    }
}

- (void)onAlertFinished:(RTNetworkResponse *)response {
    DLog(@"。。。Alert response [%@]", [response content]);
}

#pragma mark - private Method

- (NSArray *)rightButtonsIsStar:(BOOL)isStar
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray array];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor whiteColor] icon:[self getImageIsStar:isStar]];
    
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     SYSTEM_ZZ_RED icon:[UIImage imageNamed:@"anjuke_icon_delete_.png"]];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:SYSTEM_RED title:@"删除"];
    
    return rightUtilityButtons;
}

- (UIImage *)getImageIsStar:(BOOL)isStar {
    UIImage *img = [UIImage imageNamed:@"anjuke_icon_noxingbiao_.png"];
    if (isStar) {
        img = [UIImage imageNamed:@"anjuke_icon_xingbiao_.png"];
    }
    
    return img;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray array];
    
    return leftUtilityButtons;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.listDataArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CLIENT_LIST_HEIGHT;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"★星标客户";
            break;
        case 2:
            return @"全部客户";
            break;
            
        default:
            break;
    }
    
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClientListCell *cell = (ClientListCell *)[tableView dequeueReusableCellWithIdentifier:nil];
    
    NSArray *rightBtnarr = [NSArray array];
    AXMappedPerson *item = nil;
    
    if (indexPath.section == 0) {
        item = [self.publicDataArr objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 1) {
        item = [self.starDataArr objectAtIndex:indexPath.row];
        rightBtnarr = [self rightButtonsIsStar:YES];
    }
    else if (indexPath.section == 2) {
        item = [self.allDataArr objectAtIndex:indexPath.row];
        rightBtnarr = [self rightButtonsIsStar:item.isStar];
    }
    
    if (cell == nil) {
        cell = [[ClientListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:nil
                                  containingTableView:tableView // Used for row height and selection
                                   leftUtilityButtons:[self leftButtons]
                                  rightUtilityButtons:rightBtnarr];
        cell.delegate = self;
    }
    
    [cell setCellHeight:CLIENT_LIST_HEIGHT];
    [cell configureCellWithData:item]; //for test
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    else if (section == 1) {
        if (self.starDataArr.count > 0) {
            return 20;
        }
        else
            return 0;
    }
    else if (section == 2) {
        if (self.allDataArr.count > 0) {
            return 20;
        }
        else
            return 0;
    }
    
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_LIST_003 note:nil];
    
    DLog(@"section- [%d]", indexPath.section);
    AXMappedPerson *item = nil;
    
    if (indexPath.section == 0) { //公共账号显示
        item = [self.publicDataArr objectAtIndex:indexPath.row];
        
        if (self.isForMessageList) {
            BrokerChatViewController *controller = [[BrokerChatViewController alloc] init];
            controller.isBroker = YES;
            controller.uid = item.uid;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            ClientDetailPublicViewController *cd = [[ClientDetailPublicViewController alloc] init];
            cd.person = item;
            [cd setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:cd animated:YES];
        }
    }
    if (indexPath.section > 0) {
        if (indexPath.section == 1) { //星标用户
            item = [self.starDataArr objectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 2) //全部用户
            item = [self.allDataArr objectAtIndex:indexPath.row];
        
        if (self.isForMessageList) {
            BrokerChatViewController *controller = [[BrokerChatViewController alloc] init];
            controller.isBroker = YES;
            controller.uid = item.uid;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
            cd.person = item;
            [cd setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:cd animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *cellIndexPath = [self.tableViewList indexPathForCell:cell];
    AXMappedPerson *item = [[self.listDataArray objectAtIndex:cellIndexPath.section] objectAtIndex:cellIndexPath.row];
    
    [self showLoadingActivity:YES];
    
    switch (index) {
        case 0:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_LIST_004 note:nil];
            
            DLog(@"isStar--section[%d],row-[%d]", cellIndexPath.section, cellIndexPath.row);
            
            item.isStar = !item.isStar;
            [[AXChatMessageCenter defaultMessageCenter] updatePerson:item];
            [[[cell rightUtilityButtons] objectAtIndex:0] setImage:[self getImageIsStar:!item.isStar] forState:UIControlStateNormal];
            
            [self getFriendList];
            [self hideLoadWithAnimated:YES];
            break;
        }
        case 1:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_LIST_006 note:nil];
            
            DLog(@"delete--section[%d],row-[%d]", cellIndexPath.section, cellIndexPath.row);
            
            //delete from database
            [[AXChatMessageCenter defaultMessageCenter] removeFriendBydeleteUid:[NSArray arrayWithObject:item.uid] compeletionBlock:^(BOOL isSuccess){
                if (isSuccess) {
                    [self getFriendList];
                    [self hideLoadWithAnimated:YES];
                }
                else
                    [self showInfo:@"删除客户失败，请再试一次"];
            }];
            break;
        }
        default:
            break;
    }
    
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

@end
