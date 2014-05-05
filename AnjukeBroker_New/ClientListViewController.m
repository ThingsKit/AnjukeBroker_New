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
#import "AccountManager.h"
#import "AppDelegate.h"
#import "IMGDowloaderManager.h"

@interface ClientListViewController ()

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@property (nonatomic, strong) NSMutableArray *publicDataArr; //公共账号列表
@property (nonatomic, strong) NSMutableArray *starDataArr; //星标客户列表
@property (nonatomic, strong) NSMutableArray *allDataArr; //所有客户列表

@property (nonatomic, strong) NSArray *testArr;
@property (nonatomic, strong) NSMutableDictionary *contactsDictionary;
@property (nonatomic, strong) NSMutableArray *contactKeyArr;

@property (nonatomic, strong) NSMutableArray *sectionTitleArr;
@property (nonatomic, strong) IMGDowloaderManager *downloader;

@end

@implementation ClientListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IMGDowloaderManager *)downloader {
    if (_downloader == nil) {
        _downloader = [[IMGDowloaderManager alloc] init];
    }
    return _downloader;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleViewWithString:@"我的客户"];
    if (self.isForMessageList) {
        [self setTitleViewWithString:@"选择客户"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([LoginManager getChatID].length > 0 && [LoginManager getPhone].length > 0 && [[AppDelegate sharedAppDelegate] checkHomeVCHasLongLinked] == YES) {
        [self showLoadingActivity:YES];
        [self getFriendList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getFriendList {
    [[AXChatMessageCenter defaultMessageCenter] friendListWithPersonWithCompeletionBlock:^(NSArray *friendList, BOOL whetherSuccess) {
        if (whetherSuccess) {
//            [self hideLoadWithAnimated:YES];
            [self dowloadFriendsIcon:friendList];
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                if ([self.testArr count] == 0) {
                    self.testArr = [NSArray arrayWithArray:friendList];
                    [self redrawList];
//                }else {
//                    [self hideLoadWithAnimated:YES];
//                }
            });
        }
    }];
}

- (void)dowloadFriendsIcon:(NSArray *)friendsArray {
    for (AXMappedPerson *person in friendsArray) {
        if (person.iconUrl && person.isIconDownloaded == NO) {
            [self.downloader dowloadIMGWithImgURLToLibrary:person.iconUrl identify:person.uid successBlock:^(BrokerResponder *response) {
                if (response.statusCode == 2) {
                    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:response.identify];
                    //                person.iconUrl = [LoginManager getUse_photo_url];
                    person.iconPath = [[response.imgPath componentsSeparatedByString:@"/"] lastObject];
                    person.isIconDownloaded = YES;
                    [[AXChatMessageCenter defaultMessageCenter] updatePerson:person];
                }
            } fialedBlock:^(BrokerResponder *response) {
                
            }];
        }
    }
}

#pragma mark - log
- (void)sendAppearLog {
    if (self.isForMessageList) {
        [[BrokerLogger sharedInstance] logWithActionCode:CUSTOM_CHOOSE_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
    else
        [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_LIST_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    if (self.isForMessageList) {
        [[BrokerLogger sharedInstance] logWithActionCode:CUSTOM_CHOOSE_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
    }
    else
        [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_LIST_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - init Method

- (void)initModel {
    self.publicDataArr = [NSMutableArray array];
    self.starDataArr = [NSMutableArray array];
    self.allDataArr = [NSMutableArray array];
    
    self.listDataArray = [NSMutableArray array];
    self.contactKeyArr = [NSMutableArray array];
    
    self.sectionTitleArr = [NSMutableArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.tableViewList = tv;
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    
    //改变索引的颜色
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        tv.sectionIndexColor = SYSTEM_TABBAR_SELECTCOLOR_DARK;
    }
    
    if (self.isForMessageList) {
        self.tableViewList.frame = FRAME_WITH_NAV;
        
        //add additional header
        UIView *headerBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], CLIENT_LIST_HEIGHT)];
        headerBG.backgroundColor = [UIColor whiteColor];
        
        UILabel *headLb = [[UILabel alloc] initWithFrame:CGRectMake(15, (CLIENT_LIST_HEIGHT - 20)/2, 250, 20)];
        headLb.backgroundColor = [UIColor clearColor];
        headLb.text = @"选择一个客户发起微聊";
        headLb.textColor = SYSTEM_BLACK;
        headLb.font = [UIFont systemFontOfSize:16];
        [headerBG addSubview:headLb];
        
        [self.tableViewList setTableHeaderView:headerBG];
    }
}

- (void)redrawList {
    self.listDataArray = [NSMutableArray array];
    [self.publicDataArr removeAllObjects];
    [self.starDataArr removeAllObjects];
    [self.allDataArr removeAllObjects];
    [self.contactKeyArr removeAllObjects];
    [self.sectionTitleArr removeAllObjects];
    
    //reset 3 list arr ...
    //获取公共账号
    for (int i = 0; i < self.testArr.count; i++) {
        AXMappedPerson *item = [self.testArr objectAtIndex:i];
        if (item.userType == AXPersonTypePublic) {
            [self.publicDataArr addObject:item];
        }
        else
            [self.allDataArr addObject:item];
    }
    
    //非公共账号处理
    //遍历并字母排序联系人数据
    self.contactsDictionary = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < self.allDataArr.count; i ++) {
        AXMappedPerson *person = [self.allDataArr objectAtIndex:i];
        unichar begin;
        if (person.markNamePinyin.length > 0) {
            begin = [person.markNamePinyin characterAtIndex:0];
            
            if (begin >= 'A' && begin <= 'Z') {
                NSString *beginString = [person.markNamePinyin substringToIndex:1];
                [self insertPerson:person withPinyinBeginWithLetter:beginString intoDictionary:self.contactsDictionary];
            } else if (begin >= 'a' && begin <= 'z') {
                NSString *beginString = [person.markNamePinyin substringToIndex:1];
                [self insertPerson:person withPinyinBeginWithLetter:[beginString uppercaseString] intoDictionary:self.contactsDictionary];
            } else {
                [self insertPerson:person withPinyinBeginWithLetter:@"#" intoDictionary:self.contactsDictionary];
            }
        }
        else  if (person.namePinyin.length > 0) {
            begin = [person.namePinyin characterAtIndex:0];
            
            if (begin >= 'A' && begin <= 'Z') {
                NSString *beginString = [person.namePinyin substringToIndex:1];
                [self insertPerson:person withPinyinBeginWithLetter:beginString intoDictionary:self.contactsDictionary];
            } else if (begin >= 'a' && begin <= 'z') {
                NSString *beginString = [person.namePinyin substringToIndex:1];
                [self insertPerson:person withPinyinBeginWithLetter:[beginString uppercaseString] intoDictionary:self.contactsDictionary];
            } else {
                [self insertPerson:person withPinyinBeginWithLetter:@"#" intoDictionary:self.contactsDictionary];
            }
        }
        else
            [self insertPerson:person withPinyinBeginWithLetter:@"#" intoDictionary:self.contactsDictionary];
    }
    
    NSArray *keys = [[self.contactsDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 isEqualToString:@"#"]) {
            return NSOrderedDescending;
        }
        if ([obj2 isEqualToString:@"#"]) {
            return NSOrderedAscending;
        }
        return [obj1 compare:obj2];
    }];
    for (NSString *key in keys) {
        [self.contactKeyArr addObject:@{@"key":key,@"objects":self.contactsDictionary[key]}];
    }
    DLog(@"---contactsDictionary---[%@]", self.contactKeyArr);
    
    //标星数据排序
    for (int i = 0; i < self.contactKeyArr.count; i++) {
        NSArray *objectArr = [[self.contactKeyArr objectAtIndex:i] objectForKey:@"objects"];
        for (int j = 0; j < objectArr.count; j++) {
            if ([(AXMappedPerson *)[objectArr objectAtIndex:j] isStar] == YES) {
                [self.starDataArr addObject:[objectArr objectAtIndex:j]];
            }
        }
    }
    //add 3 arr to list data att
    [self.listDataArray addObject:self.publicDataArr];
    [self.listDataArray addObject:self.starDataArr];

    //get section title
    [self.sectionTitleArr addObject:@""]; //公共section
    if (self.starDataArr.count > 0) {
        [self.sectionTitleArr addObject:@"★"];
    }
    for (int i = 0; i < self.contactKeyArr.count; i ++) {
        [self.sectionTitleArr addObject:[self.contactKeyArr[i] objectForKey:@"key"]];
    }
    
    [self.tableViewList reloadData];
    
    [self checkToAlert];
    [self hideLoadWithAnimated:YES];
}

- (void)insertPerson:(AXMappedPerson *)person withPinyinBeginWithLetter:(NSString *)letterStr intoDictionary:(NSMutableDictionary *)dic {
    NSMutableArray *arr = nil;
    if (!dic[letterStr]) {
        arr = [NSMutableArray array];
    }else {
        arr = dic[letterStr];
    }
    [arr addObject:person];
    dic[letterStr] = arr;
}

- (void)checkToAlert {
    NSArray *arr = [LoginManager getClientCountAlertArray];
        
    for (int i = 0; i < arr.count; i ++) {
        NSString *count = [arr objectAtIndex:i];
        
        if (self.allDataArr.count >= [count intValue]) {
            if ([[AccountManager sharedInstance] didMaxClientAlertWithCount:[count intValue]] == NO) {
                //公众号上限提醒
                NSMutableDictionary *params = nil;
                NSString *method = nil;
                
                //for test
                params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getChatID], @"toChatId", [LoginManager getUserID], @"brokerId", @"overFriend", @"msgType", count, @"msg", [LoginManager getToken], @"token", nil];
                method = @"msg/sendpublicmsg/";
                
                [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onAlertFinished:)];
                break;
            }
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
    
    if (!self.isForMessageList) {
        [rightUtilityButtons sw_addUtilityButtonWithColor:
         [UIColor whiteColor] icon:[self getImageIsStar:isStar]];
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:SYSTEM_RED title:@"删除"];
    }
    
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

- (void)doBack:(id)sender {
    if (self.isForMessageList) {
        [[BrokerLogger sharedInstance] logWithActionCode:CUSTOM_CHOOSE_004 note:nil];
    }
    
    [super doBack:self];
}

#pragma mark - Request Method

- (void)requestUpdateWithPerson:(AXMappedPerson *)person {
    if (![self isNetworkOkay]) {
        return;
    }
    
    NSString *isStar = @"0";
    if (person.isStar == YES) {
        isStar = @"1";
    }
    DLog(@"--- is Star [%d]", person.isStar);
    
    NSString *methodName = [NSString stringWithFormat:@"user/modifyFriendInfo/%@",[LoginManager getPhone]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: person.uid ,@"to_uid" , isStar, @"is_star", @"0" ,@"relation_cate_id", person.markName?person.markName:@"" ,@"mark_name", person.markPhone?person.markPhone:@"", @"mark_phone", person.markDesc?person.markDesc:@"", @"mark_desc",  nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTAnjukeXRESTServiceID methodName:methodName params:params target:self action:@selector(onGetData:)];
}

- (void)onGetData:(RTNetworkResponse *) response {
    //check network and response
    if (![self isNetworkOkay])
        return;
    
    if ([response status] == RTNetworkResponseStatusFailed || ([[[response content] objectForKey:@"status"] isEqualToString:@"error"]))
        return;
    
    DLog(@"更新标星后:%@--msg[%@]", [response content], [response content][@"errorMessage"]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDataArray.count + self.contactKeyArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0 && self.isForMessageList) {
        return 0; //此时不显示公共账号
    }
    
    if (section <= 1) {
        return [(NSArray *)[self.listDataArray objectAtIndex:section] count];
    }
    
    return [(NSArray *)[self.contactKeyArr[section -2] objectForKey:@"objects"] count];
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
        
        default:
            break;
    }
    
    if (section >= 2) {
        return [[self.contactKeyArr objectAtIndex:section -2] objectForKey:@"key"];
    }
    
    return @"";
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionTitleArr;
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
    else if (indexPath.section >= 2) {
        item = [[self.contactKeyArr[indexPath.section -2] objectForKey:@"objects"] objectAtIndex:indexPath.row];
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
    [cell configureCellWithData:item];
    
    if (indexPath.section == 0) {
        if (indexPath.row < self.publicDataArr.count - 1) {
            [cell showBottonLineWithCellHeight:CLIENT_LIST_HEIGHT andOffsetX:15];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row < self.starDataArr.count - 1) {
            [cell showBottonLineWithCellHeight:CLIENT_LIST_HEIGHT andOffsetX:15];
        }
    }
    else if (indexPath.section >= 2) {
        if (indexPath.row < [(NSArray *)self.contactKeyArr[indexPath.section - 2][@"objects"] count]-1) {
            [cell showBottonLineWithCellHeight:CLIENT_LIST_HEIGHT andOffsetX:15];
        }
    }
    
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
    if (self.isForMessageList) {
        [[BrokerLogger sharedInstance] logWithActionCode:CUSTOM_CHOOSE_003 note:nil];
    }
    else
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
        else if (indexPath.section >= 2) //全部用户
            item = [[self.contactKeyArr[indexPath.section -2] objectForKey:@"objects"] objectAtIndex:indexPath.row];
        
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
    
    AXMappedPerson *item = nil;
    if (cellIndexPath.section <= 1) {
        item = [[self.listDataArray objectAtIndex:cellIndexPath.section] objectAtIndex:cellIndexPath.row];
    }
    else if (cellIndexPath.section >=2) {
        item = [[self.contactKeyArr[cellIndexPath.section -2] objectForKey:@"objects"] objectAtIndex:cellIndexPath.row];
    }
    
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
            [self requestUpdateWithPerson:item]; //call API to update person
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
