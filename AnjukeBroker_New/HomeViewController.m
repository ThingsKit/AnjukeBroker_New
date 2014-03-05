//
//  AJK_HomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "HomeViewController.h"
#import "AnjukeEditPropertyViewController.h"
#import "SystemMessageViewController.h"
#import "Util_UI.h"
#import "BrokerLineView.h"
#import "RTNavigationController.h"
#import "WebImageView.h"
#import "LoginManager.h"
#import "AppManager.h"

#import "PublishBuildingViewController.h"
#import "CommunityListViewController.h"
#import "MoreViewController.h"
#import "FindHomeViewController.h"
#import "BrokerAccountController.h"
#import "BrokerTwoDimensionalCodeViewController.h"

#import "AXChatMessageCenter.h"
#import "AppDelegate.h"

#define HOME_cellHeight 50
#define Max_Account_Lb_Width 80

#define HEADER_VIEW1_Height 250
#define HEADER_VIEW2_Height 125
#define HEADER_VIEW_WHOLE_HEIGHT HEADER_VIEW1_Height+HEADER_VIEW2_Height

@interface HomeViewController ()
@property (nonatomic, strong) NSArray *taskArray;
@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) WebImageView *photoImg;

@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableDictionary *ppcDataDic;

@property (nonatomic, strong) UILabel *nameLb;
@property (nonatomic, strong) UILabel *phoneLb;
@property (nonatomic, strong) UILabel *accountTitleLb;
@property (nonatomic, strong) UILabel *accountLb;
@property (nonatomic, strong) UILabel *accountYuanLb;
@property (nonatomic, strong) UILabel *propNumLb;
@property (nonatomic, strong) UILabel *costLb;
@property (nonatomic, strong) UILabel *clickLb;

@property BOOL hasLongLinked;
@property (nonatomic, strong) NSDictionary *configDic;

@end

@implementation HomeViewController

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
    
//    [self setTitleViewWithString:[LoginManager getUserName]];
    
    //设置按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_setting.png"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonAction:)];
    if (![AppManager isIOS6]) {
        rightItem.tintColor = [UIColor whiteColor];
    }
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //监听被踢出下线通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogOutEnforce) name:@"MessageCenterUserDidQuit" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self doRequest];
    
    if (self.configDic.count == 0) {
        [self requestForConfigure];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - private method

//强制被踢退出登录
- (void)doLogOutEnforce {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:@"您的账号已在其他设备上登录，请知悉" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
    [av show];
}

- (void)initModel {
    self.taskArray = [NSArray arrayWithObjects:@"发布二手房", @"发布租房", @"市场分析", nil];
    
    self.dataDic = [NSMutableDictionary dictionary];
    self.ppcDataDic = [NSMutableDictionary dictionary];
    
    self.configDic = [NSDictionary dictionary];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_TAB style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor whiteColor];
//    tv.layer.borderColor = [UIColor redColor].CGColor;
//    tv.layer.borderWidth = 1;
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.showsHorizontalScrollIndicator = NO;
    tv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tv];
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], HEADER_VIEW_WHOLE_HEIGHT)];
    hView.backgroundColor = [UIColor whiteColor];
    tv.tableHeaderView = hView;
    
    //暂时只显示header，无row
    [self drawHeaderWithBG:hView];
}

- (void)drawHeaderWithBG:(UIView *)BG_View {
    //part 1
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], HEADER_VIEW1_Height)];
    view1.backgroundColor = SYSTEM_LIGHT_GRAY_BG2;
    [BG_View addSubview:view1];
    
    CGFloat view1_H = 45;
    
    if ([AppManager isiPhone4Display]) { //适配3.5inch display
        view1.frame = CGRectMake(0, 0, [self windowWidth], HEADER_VIEW1_Height -20);
        BG_View.frame = CGRectMake(0, 0, [self windowWidth], HEADER_VIEW_WHOLE_HEIGHT -20);
        view1_H = 35;
    }
    
    //photo /name...
    CGFloat photoW = 130/2;
    UIButton *personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame = CGRectMake(([self windowWidth] - photoW)/2, view1_H, photoW, photoW);
    personBtn.backgroundColor = [UIColor clearColor];
    [personBtn addTarget:self action:@selector(pushToPerson) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:personBtn];
    
    WebImageView *photo = [[WebImageView alloc] initWithFrame:CGRectMake(0, 0, photoW, photoW)];
    photo.backgroundColor = [UIColor whiteColor];
    photo.contentMode = UIViewContentModeScaleAspectFill;
    photo.clipsToBounds = YES;
    photo.imageUrl = [LoginManager getUse_photo_url];
    photo.layer.cornerRadius = 8;
    photo.layer.borderColor = SYSTEM_BLACK.CGColor;
    photo.layer.borderWidth = 0.5;
    self.photoImg = photo;
    [personBtn addSubview:photo];
    
    //二维码
    UIImageView *codeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(personBtn.frame.origin.x + personBtn.frame.size.width*0.8, personBtn.frame.origin.y + personBtn.frame.size.height * 0.75, 53/2, 54/2)];
    codeIcon.image = [UIImage imageNamed:@"anjuke_icon_ewm.png"];
    [view1 addSubview:codeIcon];
    
    //name
//    CGFloat labelW = 200;
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(([self windowWidth] - labelW)/2, photo.frame.origin.y + photo.frame.size.height+ 40, labelW, 20)];
//    lb.backgroundColor = [UIColor clearColor];
//    lb.font = [UIFont systemFontOfSize:15];
//    lb.textColor = SYSTEM_BLACK;
//    lb.textAlignment = NSTextAlignmentCenter;
//    self.nameLb = lb;
//    lb.text = [LoginManager getName];
//    [view1 addSubview:lb];
    
    //photo number
//    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y+ lb.frame.size.height+3, lb.frame.size.width, lb.frame.size.height)];
//    lb2.backgroundColor = [UIColor clearColor];
//    lb2.font = [UIFont systemFontOfSize:15];
//    lb2.textColor = SYSTEM_BLACK;
//    self.phoneLb = lb2;
//    lb2.text = [LoginManager getPhone];
//    [view1 addSubview:lb2];
    
    //account info
//    UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y+ lb.frame.size.height+3, 70, lb.frame.size.height)];
//    lb3.backgroundColor = [UIColor clearColor];
//    lb3.font = [UIFont systemFontOfSize:15];
//    lb3.textColor = SYSTEM_LIGHT_GRAY;
//    lb3.text = @"账户余额:";
//    self.accountTitleLb = lb3;
//    [view1 addSubview:lb3];
    
//    UILabel *lb4 = [[UILabel alloc] initWithFrame:CGRectMake(lb.frame.origin.x, lb.frame.origin.y+ lb.frame.size.height+5, labelW, lb.frame.size.height)];
//    lb4.backgroundColor = [UIColor clearColor];
//    lb4.font = [UIFont systemFontOfSize:15];
//    lb4.textColor = SYSTEM_BLACK;
//    lb4.textAlignment = NSTextAlignmentCenter;
//    self.accountLb = lb4;
//    lb4.text = @"账户余额: ";
//    [view1 addSubview:lb4];
    
//    UILabel *yuanLb = [[UILabel alloc] initWithFrame:CGRectMake(self.accountLb.frame.origin.x+ self.accountLb.frame.size.width, self.accountTitleLb.frame.origin.y, 20, 20)];
//    yuanLb.backgroundColor = [UIColor clearColor];
//    yuanLb.font = [UIFont systemFontOfSize:15];
//    yuanLb.textColor = SYSTEM_LIGHT_GRAY;
////    yuanLb.text = @"元";
//    self.accountYuanLb = yuanLb;
//    [view1 addSubview:yuanLb];
    
    CGFloat lbW_ = 100;
    NSString *titleStr = [NSString string];
    for (int i = 0; i < 3; i ++) {
        //number label
        UILabel *numLb = [[UILabel alloc] initWithFrame:CGRectMake(10+i *lbW_, personBtn.frame.origin.y + personBtn.frame.size.height + view1_H, lbW_, 25)];
        numLb.backgroundColor = [UIColor clearColor];
        numLb.font = [UIFont systemFontOfSize:23];
        numLb.textColor = SYSTEM_BLACK;
        numLb.text = @""; //for test
        numLb.textAlignment = NSTextAlignmentCenter;
        [view1 addSubview:numLb];
        
        switch (i) {
            case 0: {
                titleStr = @"在线房源";
                self.propNumLb = numLb;
            }
                break;
            case 1: {
                titleStr = @"今日花费";
                self.costLb = numLb;
            }
                break;
            case 2: {
                titleStr = @"今日点击";
                self.clickLb = numLb;
            }
                break;
                
            default:
                break;
        }
        
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10+i *lbW_, numLb.frame.origin.y + numLb.frame.size.height+8, lbW_, 25)];
        titleLb.backgroundColor = [UIColor clearColor];
        titleLb.font = [UIFont systemFontOfSize:14];
        titleLb.textColor = SYSTEM_BLACK;
        titleLb.text = titleStr;
        titleLb.textAlignment = NSTextAlignmentCenter;
        [view1 addSubview:titleLb];
    }
    
    //part 2
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.frame.origin.y+ view1.frame.size.height, [self windowWidth], HEADER_VIEW2_Height)];
    view2.backgroundColor = [UIColor clearColor];
    [BG_View addSubview:view2];
    
    //add 3 btn
    CGFloat pushBtnW = 96/2;
    CGFloat pushBtnGap = ([self windowWidth] - pushBtnW*3)/4;
    
    CGFloat lbW = 80;
    
    for (int i = 0; i < 3; i ++) {
        UIImage *image = [UIImage imageNamed:@"anjuke_icon_poblish_esf.png"];
        UIImage *selectImg = [UIImage imageNamed:@"anjuke_icon_poblish_esf1.png"];
        NSString *title = [self.taskArray objectAtIndex:i];
        
        if (i == 1) {
            image = [UIImage imageNamed:@"anjuke_icon_poblish_zf.png"];
            selectImg = [UIImage imageNamed:@"anjuke_icon_poblish_zf1.png"];
        }
        else if (i == 2){
            image = [UIImage imageNamed:@"anjuke_icon_scyx.png"];
            selectImg = [UIImage imageNamed:@"anjuke_icon_scyx1.png"];
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(pushBtnGap +(pushBtnGap + pushBtnW)*i, 35, pushBtnW, pushBtnW);
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        [btn setBackgroundImage:selectImg forState:UIControlStateSelected];
        btn.tag = i;
        [btn addTarget:self action:@selector(doPush:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:btn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x - (lbW - pushBtnW)/2, btn.frame.origin.y+ btn.frame.size.height+15, lbW, 20)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = SYSTEM_BLACK;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        [view2 addSubview:titleLabel];
        
    }
}

- (void)setHomeValue {
//    self.nameLb.text = [self.dataDic objectForKey:@"brokerName"];
//    self.phoneLb.text = [self.dataDic objectForKey:@"phone"];
    
    //账户自适应
    self.accountLb.text = [NSString stringWithFormat:@"账户余额: %@元", [self.ppcDataDic objectForKey:@"balance"]];
//    CGSize size = [Util_UI sizeOfString:[self.ppcDataDic objectForKey:@"balance"] maxWidth:Max_Account_Lb_Width withFontSize:15];
//    self.accountLb.frame = CGRectMake(self.accountTitleLb.frame.origin.x+ self.accountTitleLb.frame.size.width, self.accountTitleLb.frame.origin.y, size.width, self.accountTitleLb.frame.size.height);
//    self.accountYuanLb.frame = CGRectMake(self.accountLb.frame.origin.x+ self.accountLb.frame.size.width, self.accountTitleLb.frame.origin.y, 20, 20);
//    self.accountYuanLb.text = @"元";
    
    self.propNumLb.text = [self.ppcDataDic objectForKey:@"onLinePropNum"];
    self.costLb.text = [self.ppcDataDic objectForKey:@"todayAllCosts"];
    self.clickLb.text = [self.ppcDataDic objectForKey:@"todayAllClicks"];
    
    [self setTitleViewWithString:[LoginManager getRealName]];
}

- (void)rightButtonAction:(id)sender {
    //设置跳转
    MoreViewController *mv = [[MoreViewController alloc] init];
    [mv setHidesBottomBarWhenPushed:YES];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:mv animated:YES];
}

- (void)doPush:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    
    switch (index) {
        case 0:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_003 note:nil];
            
            //模态弹出小区--万恶的结构变动尼玛
            CommunityListViewController *controller = [[CommunityListViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.isFirstShow = YES;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_004 note:nil];
            
            //模态弹出小区--万恶的结构变动尼玛
            CommunityListViewController *controller = [[CommunityListViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.isFirstShow = YES;
            controller.isHaouzu = YES;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_005 note:nil];
            
            FindHomeViewController *ae = [[FindHomeViewController alloc] init];
            [ae setHidesBottomBarWhenPushed:YES];
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:ae animated:YES];
        }
            break;
        
        default:
            break;
    }
}

//个人信息
- (void)pushToPerson {
    BrokerTwoDimensionalCodeViewController *ba = [[BrokerTwoDimensionalCodeViewController alloc] init];
    [ba hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:ba animated:YES];
}

#pragma mark - Request Method

- (void)requestLongLink {
    //******兼容安居客team得到userInfoDic并设置NSUserDefaults，以帮助底层通过对应路径获取相应数据******
    NSDictionary *dic = [LoginManager getFuckingChatUserDicJustForAnjukeTeam];
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:USER_DEFAULT_KEY_AXCHATMC_USE];
    
    [AXChatMessageCenter defaultMessageCenter];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESH_MENU_TABLE" object:nil];
    [[AppDelegate sharedAppDelegate] connectLongLinkForChat];
    
}

- (void)doRequest {
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", @"1", @"chatFlag", nil];
    method = @"broker/getinfoandppc/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}

- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    self.dataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerBaseInfo"];
    self.ppcDataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerPPCInfo"];
    
    //保存聊天id和聊天token
    NSString *chatID = [[[response content] objectForKey:@"data"] objectForKey:@"chatId"];
    NSString *tokenChat = [[[response content] objectForKey:@"data"] objectForKey:@"tokenChat"];
    NSString *phone = [self.dataDic objectForKey:@"phone"];
    NSString *realName = [self.dataDic objectForKey:@"brokerName"]; //真实姓名保存
    NSString *twoCodeIcon = [[[response content] objectForKey:@"data"] objectForKey:@"twoCodeIcon"];
    
    //保存
    [[NSUserDefaults standardUserDefaults] setValue:chatID forKey:@"chatID"];
    [[NSUserDefaults standardUserDefaults] setValue:tokenChat forKey:@"tokenChat"];
    [[NSUserDefaults standardUserDefaults] setValue:phone forKey:@"phone"]; //联系电话
    [[NSUserDefaults standardUserDefaults] setValue:realName forKey:@"realName"]; //真实姓名
    [[NSUserDefaults standardUserDefaults] setValue:twoCodeIcon forKey:@"twoCodeIcon"]; //二维码
    
    [self setHomeValue];
    
    if (!self.hasLongLinked) {
        if (!chatID || [chatID isEqualToString:@""] || chatID == nil) {
#ifdef DEBUG
            [self showInfo:@"无法登录聊天，没ChatID"];
#endif
        }
        else {
            //******兼容安居客team得到userInfoDic并设置NSUserDefaults，以帮助底层通过对应路径获取相应数据******
            NSDictionary *dic = [LoginManager getFuckingChatUserDicJustForAnjukeTeamWithPhone:phone uid:chatID];
            [[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"anjuke_chat_login_info"];
            
            [AXChatMessageCenter defaultMessageCenter];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_NOTIFICATION" object:nil];
            
        }
        self.hasLongLinked = YES;
    }
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
}

- (void)requestForConfigure {
    if (![self isNetworkOkay]) {
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    method = @"globalconf/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestConfigureFinished:)];
    
}

- (void)onRequestConfigureFinished:(RTNetworkResponse *)response {
    DLog(@"。。。configure response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;//self.taskArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HOME_cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        UILabel *labNum = [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 20, 20)];
        labNum.tag = 101;
        labNum.textColor = [UIColor whiteColor];
        labNum.font = [UIFont systemFontOfSize:13];
        labNum.textAlignment = NSTextAlignmentCenter;
        labNum.layer.cornerRadius = 10;
        labNum.layer.masksToBounds = YES;
        
        [cell.contentView addSubview:labNum];
    }
    else {
        
    }
    
    cell.textLabel.text = [self.taskArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    ((UILabel *)[cell viewWithTag:101]).text = @"";
    [(UILabel *)[cell viewWithTag:101] setBackgroundColor:[UIColor clearColor]];
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(15, HOME_cellHeight -1, 320 - 15, 1)];
    [cell.contentView addSubview:line];
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_003 note:nil];
            
            //模态弹出小区--万恶的结构变动尼玛
            CommunityListViewController *controller = [[CommunityListViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.isFirstShow = YES;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_004 note:nil];
            
            //模态弹出小区--万恶的结构变动尼玛
            CommunityListViewController *controller = [[CommunityListViewController alloc] init];
            controller.backType = RTSelectorBackTypeDismiss;
            controller.isFirstShow = YES;
            controller.isHaouzu = YES;
            RTNavigationController *nav = [[RTNavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_005 note:nil];
            
            SystemMessageViewController *ae = [[SystemMessageViewController alloc] init];
            [ae setHidesBottomBarWhenPushed:YES];
            self.navigationController.navigationBarHidden = NO;
            [self.navigationController pushViewController:ae animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        case 1:
        {
            [[AppDelegate sharedAppDelegate] doLogOut];
            [[AppDelegate sharedAppDelegate] killLongLinkForChat];
        }
            break;
            
        default:
            break;
    }
}


@end
