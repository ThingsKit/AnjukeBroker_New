//
//  MessageListViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-18.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "MessageListViewController.h"
#import "MessageListCell.h"
#import "BrokerChatViewController.h"
#import "AXConversationListItem.h"
#import "ClientListViewController.h"
#import "BrokerChatViewController.h"
#import "AppManager.h"
#import "AppDelegate.h"
#import "BrokerLineView.h"

@interface MessageListViewController ()

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@property (nonatomic, strong) NSFetchedResultsController *sessionFetchedResultsController;
@property (strong, nonatomic) NSDate *lastReloadDate;

@property (nonatomic, strong) UIView *networkErrorView;

@end

@implementation MessageListViewController

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
    
    [self setTitleViewWithString:@"微聊"];
    
    self.lastReloadDate = [NSDate date];
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCenterDidInitedDataCenter:) name:MessageCenterDidInitedDataCenter object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resetMessageValue];
    [self checkForReloadTVWithDate];
    
    [self checkWillShowNetwork];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:MESSAGE_LIST_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:MESSAGE_LIST_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - init Method

- (NSFetchedResultsController *)sessionFetchedResultsController
{
    if (!_sessionFetchedResultsController) {
        _sessionFetchedResultsController = [[AXChatMessageCenter defaultMessageCenter] conversationListFetchedResultController];
        _sessionFetchedResultsController.delegate = self;
        
        __autoreleasing NSError *error;
        if (![_sessionFetchedResultsController performFetch:&error]) {
            DLog(@"%@",error);
        }
        
        [self resetMessageValue];
    }
    return _sessionFetchedResultsController;
}

#pragma mark - init Method

- (void)initModel {
    self.listDataArray = [NSMutableArray array];
    
    //test
    for (int i = 0; i < 10 ; i ++) {
        [self.listDataArray addObject:@"aaa"];
    }
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.tableViewList = tv;
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    

    UIBarButtonItem *rightItem = [UIBarButtonItem getBarButtonItemWithImage:[UIImage imageNamed:@"anjuke_icon_add_.png"] highLihtedImg:[UIImage imageNamed:@"anjuke_icon_add_press"] taget:self action:@selector(rightButtonAction:)];

    UIBarButtonItem *spacer = [UIBarButtonItem getBarSpaceMore];
    [self.navigationItem setRightBarButtonItems:@[spacer, rightItem]];

//    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {//fix ios7以下 10像素偏离
//    }else{
//        self.navigationItem.rightBarButtonItem = rightItem;
//    }
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self drawNetworkView];
}

- (void)rightButtonAction:(id)sender {
    if ([LoginManager getChatID].length > 0 && [LoginManager getPhone].length > 0) {
        [[BrokerLogger sharedInstance] logWithActionCode:MESSAGE_LIST_003 note:nil];
        
        ClientListViewController *ml = [[ClientListViewController alloc] init];
        ml.isForMessageList = YES;
        [ml setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:ml animated:YES];
    }
    else {
        
    }
}

- (void)drawNetworkView {
    //问题网络checkout
    UIView *netView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 46)];
    netView.backgroundColor = [Util_UI colorWithHexString:@"ffeeee"];
    self.networkErrorView = netView;

    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_nonet_attention.png"]];
    icon.frame = CGRectMake(16, (netView.frame.size.height - 26)/2, 26, 26);
    [netView addSubview:icon];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 10, 5, 200, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.textColor = SYSTEM_BLACK;
    titleLb.font = [UIFont systemFontOfSize:14];
    titleLb.text = @"当前网络不可用";
    [netView addSubview:titleLb];
    
    UILabel *titleLb2 = [[UILabel alloc] initWithFrame:CGRectMake(titleLb.frame.origin.x, titleLb.frame.origin.y+20+1, 200, 20)];
    titleLb2.backgroundColor = [UIColor clearColor];
    titleLb2.textColor = SYSTEM_LIGHT_GRAY;
    titleLb2.font = [UIFont systemFontOfSize:10];
    titleLb2.text = @"请检查你的网络设置";
    [netView addSubview:titleLb2];
    
    BrokerLineView *bl = [[BrokerLineView alloc] initWithFrame:CGRectMake(15, netView.frame.size.height - 0.5, [self windowWidth] - 15, 0.5)];
    [netView addSubview:bl];
}

#pragma mark - Private Method

- (void)resetMessageValue {
    //得到所有的消息提醒数
    NSInteger count = [[AXChatMessageCenter defaultMessageCenter] totalUnreadMessageCount];
    [[AppDelegate sharedAppDelegate] showMessageValueWithStr:count];
}

- (void)checkForReloadTVWithDate {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    });
    NSDate *messageDate = self.lastReloadDate;
    NSDateComponents *nowComponent = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSDateComponents *messageComponent = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:messageDate];
    if (nowComponent.year == messageComponent.year && nowComponent.month == messageComponent.month && nowComponent.day == messageComponent.day) {
        
    } else {
        [self.tableViewList reloadData];
        self.lastReloadDate = [NSDate date];
    }
}

- (void)removeDataArrAtIndex:(int)index {
    if (index >= self.listDataArray.count) {
        return;
    }
    
    if (self.listDataArray.count == 0) {
        return;
    }
    
    [self.listDataArray removeObjectAtIndex:index];
}

- (void)checkWillShowNetwork {
    if (![LoginManager isLogin]) {
        return;
    }
    
    if ([[self.sessionFetchedResultsController fetchedObjects] count] <= 0) {
        self.tableViewList.tableHeaderView = nil;
        return;
    }
    
    //check network
    if (self.networkErrorView) {
        if (![self isNetworkOkay]) {
            self.tableViewList.tableHeaderView = self.networkErrorView;
        }
        else
            self.tableViewList.tableHeaderView = nil;
    }
}

#pragma mark - Request Method

- (void)addMessageNotifycation
{
    [[NSNotificationCenter defaultCenter] addObserverForName:MessageCenterDidReceiveNewMessage object:nil queue:nil usingBlock: ^(NSNotification *note) {
        // 接受消息
        if ([note.object isKindOfClass:[NSArray class]]) {
//            NSArray *list = (NSArray *)note.object;
//            DLog(@"------Message_list [%@]", list);
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.listDataArray.count; //for test
    return [[self.sessionFetchedResultsController fetchedObjects] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MESSAGE_LIST_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    else {
        
    }
    AXConversationListItem *item = [self.sessionFetchedResultsController fetchedObjects][indexPath.row];
    [cell configureCell:item];
    [cell showBottonLineWithCellHeight:MESSAGE_LIST_HEIGHT andOffsetX:CELL_MESSAGELIST_OFFSETX];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [[BrokerLogger sharedInstance] logWithActionCode:MESSAGE_LIST_005 note:nil];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[AXChatMessageCenter defaultMessageCenter] deleteConversationItem:[self.sessionFetchedResultsController fetchedObjects][indexPath.row]];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[BrokerLogger sharedInstance] logWithActionCode:MESSAGE_LIST_004 note:nil];
    
    AXConversationListItem *item = [self.sessionFetchedResultsController objectAtIndexPath:indexPath];

    BrokerChatViewController *controller = [[BrokerChatViewController alloc] init];
    controller.isBroker = YES;
    controller.uid = item.friendUid;
    [controller setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:controller animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    //check network
    [self checkWillShowNetwork];
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableViewList insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableViewList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
            break;
        case NSFetchedResultsChangeMove:
        {
            [self.tableViewList moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            
            AXConversationListItem *item = [self.sessionFetchedResultsController fetchedObjects][newIndexPath.row];
            MessageListCell *cell = (MessageListCell *)[self.tableViewList cellForRowAtIndexPath:indexPath];
            [cell configureCell:item];
        }
            break;
        case NSFetchedResultsChangeDelete:
        {
            
            [self.tableViewList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        default:
            break;
    }
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self showLoadingActivity:YES];
    [self.tableViewList beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableViewList endUpdates];
    [self hideLoadWithAnimated:YES];
    
    [self resetMessageValue];
}

#pragma mark - notification receive
- (void)messageCenterDidInitedDataCenter:(NSNotification *)notification
{
    self.sessionFetchedResultsController = nil;
    [self.tableViewList reloadData];
}

@end
