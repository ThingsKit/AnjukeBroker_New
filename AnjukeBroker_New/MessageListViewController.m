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
#import "AXMappedConversationListItem.h"

#import "BrokerChatViewController.h"
#import "AppManager.h"

@interface MessageListViewController ()

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@property (nonatomic, strong) NSFetchedResultsController *sessionFetchedResultsController;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    
    //设置按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_add.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
    if (![AppManager isIOS6]) {
        rightItem.tintColor = SYSTEM_NAVIBAR_COLOR;
    }
    self.navigationItem.rightBarButtonItem = rightItem;
}

//test
- (void)rightButtonAction:(id)sender {
//    BrokerChatViewController *av = [[BrokerChatViewController alloc] init];
//    av.isBroker = YES;
//    av.uid = [LoginManager getChatID];
//    [av setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:av animated:YES];
}

#pragma mark - Private Method

- (void)removeDataArrAtIndex:(int)index {
    if (index >= self.listDataArray.count) {
        return;
    }
    
    if (self.listDataArray.count == 0) {
        return;
    }
    
    [self.listDataArray removeObjectAtIndex:index];
}

#pragma mark - Request Method

- (void)addMessageNotifycation
{
    [[NSNotificationCenter defaultCenter] addObserverForName:MessageCenterDidReceiveNewMessage object:nil queue:nil usingBlock: ^(NSNotification *note) {
        // 接受消息
        if ([note.object isKindOfClass:[NSArray class]]) {
            NSArray *list = (NSArray *)note.object;
            DLog(@"------list [%@]", list);
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
//    [cell configureCell:[self.sessionFetchedResultsController fetchedObjects][indexPath.row]];
    AXMappedConversationListItem *item = [self.sessionFetchedResultsController objectAtIndexPath:indexPath];
    [cell configureCell:item];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self removeDataArrAtIndex:indexPath.row];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
    
//    [tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AXMappedConversationListItem *item = [self.sessionFetchedResultsController objectAtIndexPath:indexPath];

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
}

@end
