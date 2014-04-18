//
//  ClientDetailViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientDetailViewController.h"
#import "ClientDetailCell.h"
#import "BrokerChatViewController.h"
#import "LoginManager.h"
#import "AppManager.h"
#import "WebImageView.h"
#import "BrokerCallAlert.h"

#define DETAIL_HEADER_H 52+40

#define TagOfMoreActionSheet 1001

@interface ClientDetailViewController ()

@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *listDataArray;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *companyLabel;
@property (nonatomic, strong) WebImageView *iconImage;

@property BOOL isBlankStyle; //如果标注电话和标注信息为空，则显示为空样式提示标注

@end

@implementation ClientDetailViewController
@synthesize tableViewList;
@synthesize listDataArray;
@synthesize person;
@synthesize nameLabel, companyLabel, iconImage;
@synthesize isBlankStyle;

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
    
    [self setTitleViewWithString:@"详细资料"];
    
    UIBarButtonItem *moreItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_danye_more_.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
    
    UIBarButtonItem *startItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_danye_noxingbiao_.png"] style:UIBarButtonItemStylePlain target:self action:@selector(redrawStarStatus:)];
    if (self.person.isStar) {
        startItem.image = [UIImage imageNamed:@"anjuke_icon_danye_xingbiao_.png"];
    }
    else
        startItem.image = [UIImage imageNamed:@"anjuke_icon_danye_noxingbiao_.png"];
    
    self.navigationItem.rightBarButtonItems = @[moreItem, startItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshDataAndView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - init Method

- (void)initModel {
    self.listDataArray = [NSMutableArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tableViewList = tv;
    tv.delegate = self;
    tv.dataSource = self;
    tv.backgroundColor = SYSTEM_LIGHT_GRAY_BG2;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    
    //draw header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], DETAIL_HEADER_H)];
    headerView.backgroundColor = [UIColor clearColor];
    [self.tableViewList setTableHeaderView:headerView];
    
    WebImageView *icon = [[WebImageView alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, 52/2, 40, 40)];
    icon.backgroundColor = [UIColor clearColor];
//    icon.layer.borderColor = [UIColor whiteColor].CGColor;
//    icon.layer.borderWidth = 0.5;
    icon.layer.cornerRadius = 5;
    self.iconImage = icon;
    if (self.person.iconUrl.length > 0) {
        if (self.person.isIconDownloaded) {
            icon.image = [UIImage imageWithContentsOfFile:self.person.iconPath];
        }
        else
            icon.imageUrl = self.person.iconUrl;
    }
    else
        icon.image = [UIImage imageNamed:@"anjuke_icon_headpic.png"];
    [headerView addSubview:icon];
    
    UILabel *nameLb = [[UILabel alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE + icon.frame.size.width + CELL_OFFSET_TITLE, icon.frame.origin.y, 200, 25)];
    nameLb.backgroundColor = [UIColor clearColor];
    self.nameLabel = nameLb;
    nameLb.textColor = SYSTEM_BLACK;
    nameLb.font = [UIFont systemFontOfSize:19];
    [headerView addSubview:nameLb];
    
    UILabel *tipLb = [[UILabel alloc] initWithFrame:CGRectMake(nameLb.frame.origin.x, nameLb.frame.origin.y+ nameLb.frame.size.height +5, 200, 15)];
    tipLb.backgroundColor = [UIColor clearColor];
    tipLb.textColor = SYSTEM_LIGHT_GRAY;
    self.companyLabel = tipLb;
    tipLb.font = [UIFont systemFontOfSize:12];
    [headerView addSubview:tipLb];
    
    //draw footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 50)];
    footerView.backgroundColor = [UIColor clearColor];
    [self.tableViewList setTableFooterView:footerView];
    
    CGFloat btnW = 200;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(([self windowWidth] - btnW )/2, 23, btnW, 75/2);
    [btn setTitle:@"微聊" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(startChart) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_bluebutton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(77/2-1, 5, 77/2+1, 52/2-5)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_bluebutton1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(77/2-1, 5, 77/2+1, 52/2-5)] forState:UIControlStateHighlighted];
    [footerView addSubview:btn];
}

#pragma mark - Request Method

- (void)requestUpdatePerson {
    if (![self isNetworkOkay]) {
        return;
    }
    
    NSString *isStar = @"0";
    if (self.person.isStar == YES) {
        isStar = @"1";
    }
    
    NSString *methodName = [NSString stringWithFormat:@"user/modifyFriendInfo/%@",[LoginManager getPhone]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.person.uid ,@"to_uid" , isStar, @"is_star", @"0" ,@"relation_cate_id", self.person.markName ,@"mark_name", self.person.markPhone, @"mark_phone", self.person.markDesc, @"mark_desc",  nil];
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

#pragma mark - Private Method

- (void)refreshDataAndView {
    [self showLoadingActivity:YES];
    
    if (self.person.markPhone.length <= 0 && self.person.markDesc.length <= 0) {
        self.isBlankStyle = YES;
    }
    else {
        self.isBlankStyle = NO;
        
    }
    
    //重新刷新信息
    NSString *uid = self.person.uid;
    self.person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:uid];
    
    if (self.person.markName.length > 0) {
        self.nameLabel.text = self.person.markName;
        self.companyLabel.text = [NSString stringWithFormat:@"安居客用户 %@",self.person.name];
    }
    else {
        self.nameLabel.text = self.person.name;
        self.companyLabel.text = @"";
        
        if ([self.person.name isEqualToString:self.person.phone] || self.person.name.length <= 0) {
            self.nameLabel.text = [Util_TEXT getChatNameWithPhoneFormat:self.person.phone];
        }
    }
    
    if (self.person.isIconDownloaded) {
        self.iconImage.image = [UIImage imageWithContentsOfFile:self.person.iconPath];
    }
    else
        self.iconImage.imageUrl = self.person.iconUrl;
    
    [self.tableViewList reloadData];
    
    [self hideLoadWithAnimated:YES];
}

- (void)startChart {
    BrokerChatViewController *bc = [[BrokerChatViewController alloc] init];
    bc.isBroker = YES;
    bc.uid = self.person.uid;
    [self.navigationController pushViewController:bc animated:YES];
}

- (void)rightButtonAction:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_003 note:nil];
    
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑备注", @"删除客户", nil];
    as.delegate = self;
    as.tag = TagOfMoreActionSheet;
    as.destructiveButtonIndex = 1;
    [as showInView:self.view];
}

- (void)redrawStarStatus:(id)sender {
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    
    self.person.isStar = !self.person.isStar;
    [[AXChatMessageCenter defaultMessageCenter] updatePerson:self.person];
    
    if ([item.image isEqual:[UIImage imageNamed:@"anjuke_icon_danye_xingbiao_.png"]]) {
        [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_007 note:nil];
        
        item.image = [UIImage imageNamed:@"anjuke_icon_danye_noxingbiao_.png"];
        
        [self showInfo:@"取消标星成功"];
    }
    else{
        [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_006 note:nil];
        
        item.image = [UIImage imageNamed:@"anjuke_icon_danye_xingbiao_.png"];
        
        [self showInfo:@"添加标星成功"];
    }
    
    [self requestUpdatePerson];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isBlankStyle) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isBlankStyle) {
        return CLIENT_DETAIL_TEL_HEIGHT;
    }
    
    if (indexPath.row == 0) {
        return CLIENT_DETAIL_TEL_HEIGHT;
    }
    return CLIENT_DETAIL_MESSAGE_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    ClientDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ClientDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    else {
    }
    [cell configureCell:self.person withIndex:indexPath.row isBlankStyle:self.isBlankStyle];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        if (self.isBlankStyle) {
            //编辑
            ClientEditViewController *ce = [[ClientEditViewController alloc] init];
            ce.person = self.person;
            ce.editDelegate = self;
            [self.navigationController pushViewController:ce animated:YES];
            
            return;
        }
        
        [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_008 note:nil];
        
        if (self.person.markPhone.length <= 0) {
            return;
        }
        
        //make call
        if (![AppManager checkPhoneFunction]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请检测是否支持电话功能" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alertView show];
        }
        else {
            NSString *markNameStr = self.person.markName ? self.person.markName : @"";
            [[BrokerCallAlert sharedCallAlert] callAlert:[NSString stringWithFormat:@"您是否要联系%@：",markNameStr] callPhone:self.person.markPhone];
        }
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == TagOfMoreActionSheet) {
        switch (buttonIndex) {
            case 0:
            {
                [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_004 note:nil];
                
                //编辑
                ClientEditViewController *ce = [[ClientEditViewController alloc] init];
                ce.person = self.person;
                ce.editDelegate = self;
                [self.navigationController pushViewController:ce animated:YES];
            }
                break;
            case 1:
            {
                [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_DETAIL_005 note:nil];
                
                //删除
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"是否删除" message:@"删除客户，将同时删除备注和聊天记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                av.delegate = self;
                [av show];
                
            }
                break;
            case 2:
            {
                //取消
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            //取消
        }
            break;
        case 1:
        {
            //确定删除
            __weak   ClientDetailViewController *myself = self;
            [[AXChatMessageCenter defaultMessageCenter] removeFriendBydeleteUid:@[self.person.uid] compeletionBlock:^(BOOL isSuccess) {
                if (myself && isSuccess) {
                    myself.backType = RTSelectorBackTypePopToRoot;
                    [self showInfo:@"客户已删除"];
                    
                    [self performSelector:@selector(doBack:) withObject:nil afterDelay:0.5];
                }else if (myself && !isSuccess){
                    [self showInfo:@"客户删除失败"];
                }
            }];
            
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - ClientEditPopDelegate

- (void)didSaveBackWithData:(AXMappedPerson *)data {
    self.person = data;
    
    [self.tableViewList reloadData];
}


@end
