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
#import "WebImageView.h"
#import "LoginManager.h"
#import "AppManager.h"
#import "AXPhotoManager.h"
#import "RTGestureBackNavigationController.h"

#import "PublishBuildingViewController.h"
#import "CommunityListViewController.h"
#import "MoreViewController.h"
#import "FindHomeViewController.h"
#import "BrokerAccountController.h"
#import "BrokerTwoDimensionalCodeViewController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "AXChatMessageCenter.h"
#import "AppDelegate.h"
#import "BrokerWebViewController.h"
#import "LocationManager.h"
#import "RTNetworkResponse.h"
#import "AXIMGDownloader.h"
#import "IMGDowloaderManager.h"
#import "UserCenterViewController.h"
#import "CheckoutCommunityViewController.h"

#import "SaleBidDetailController.h"
#import "SaleFixedDetailController.h"
#import "SaleNoPlanGroupController.h"

#define HOME_cellHeight 50
#define Max_Account_Lb_Width 80

#define HEADER_VIEW1_Height 250
#define HEADER_VIEW2_Height 125
#define HEADER_VIEW_WHOLE_HEIGHT HEADER_VIEW1_Height+HEADER_VIEW2_Height

@interface HomeViewController ()
@property (nonatomic, strong) NSArray *taskArray;
@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) WebImageView *photoImg;
@property (nonatomic, strong) AXIMGDownloader *imgDownloader;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableDictionary *ppcDataDic;
@property BOOL isAJK;
@property (nonatomic, strong) NSString *isSeedPid;
@property (nonatomic, strong) NSMutableArray *myArray;
//@property (nonatomic, strong) UILabel *nameLb;
//@property (nonatomic, strong) UILabel *phoneLb;
//@property (nonatomic, strong) UILabel *accountTitleLb;
//@property (nonatomic, strong) UILabel *accountLb;
//@property (nonatomic, strong) UILabel *accountYuanLb;
//@property (nonatomic, strong) UILabel *propNumLb;
//@property (nonatomic, strong) UILabel *costLb;
//@property (nonatomic, strong) UILabel *clickLb;

@property (nonatomic, strong) UILabel *tapName;
@property (nonatomic, strong) UILabel *tapValue;
@property (nonatomic, strong) UILabel *costName;
@property (nonatomic, strong) UILabel *costValue;

@property BOOL configChecked;
@property (nonatomic, copy) NSString *loadingURL;
@property (nonatomic, strong) UIButton *topAlertButton;

@end

@implementation HomeViewController

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (AXIMGDownloader *)imgDownloader {
    if (_imgDownloader == nil) {
        _imgDownloader = [[AXIMGDownloader alloc] init];
    }
    return _imgDownloader;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor];
    [self initRightBarButton];
    [self initView];
//    [self initDisplay];
}
- (void)initView {
    [self setTitle:@"房源"];
    
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_TAB style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor lightGrayColor];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.showsHorizontalScrollIndicator = NO;
    tv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tv];
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 110)];
    tv.tableHeaderView = hView;
    
    self.tapName = [[UILabel alloc] init];
    self.tapName.text = @"今日点击";
    self.tapName.textAlignment = NSTextAlignmentCenter;
    self.tapValue = [[UILabel alloc] init];
    self.tapValue.textAlignment = NSTextAlignmentCenter;
    self.tapValue.text = @"2";
    self.costName = [[UILabel alloc] init];
    self.costName.textAlignment = NSTextAlignmentCenter;
    self.costName.text = @"今日花费";
    self.costValue = [[UILabel alloc] init];
    self.costValue.textAlignment = NSTextAlignmentCenter;
    self.costValue.text = @"1.0";
    
    [hView addSubview:self.tapName];
    [hView addSubview:self.tapValue];
    [hView addSubview:self.costName];
    [hView addSubview:self.costValue];
    
    if ([self.view respondsToSelector:@selector(addConstraint:)]) {
        self.tapName.translatesAutoresizingMaskIntoConstraints  = NO;
        self.tapValue.translatesAutoresizingMaskIntoConstraints = NO;
        self.costName.translatesAutoresizingMaskIntoConstraints = NO;
        self.costValue.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *dictionary = NSDictionaryOfVariableBindings(_tapName, _tapValue, _costName, _costValue);
        float widthIndex = [self windowWidth]/320.0f;
        NSDictionary *metrics = @{@"leftSpace":@(60.0*widthIndex), @"centerSpace":@(40.0f*widthIndex), @"topSpace":@(30.0f*widthIndex), @"valueAndNameSpace": @(10.0f*widthIndex)};
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftSpace-[_tapName(80)]-centerSpace-[_costName(80)]" options:0 metrics:metrics views:dictionary]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftSpace-[_tapValue(80)]-centerSpace-[_costValue(80)]" options:0 metrics:metrics views:dictionary]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topSpace-[_tapValue(30)]-valueAndNameSpace-[_tapName(30)]" options:0 metrics:metrics views:dictionary]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topSpace-[_costValue(30)]-valueAndNameSpace-[_costName(30)]" options:0 metrics:metrics views:dictionary]];
    }else {
        self.tapValue.frame = CGRectMake(60.0f, 30.0f, 80.0f, 30.0f);
        self.tapName.frame = CGRectMake(60.0f, 70.0f, 80.0f, 30.0f);
        self.costValue.frame = CGRectMake(180.0f, 30.0f, 80.0f, 30.0f);
        self.costName.frame = CGRectMake(180.0f, 70.0f, 80.0f, 30.0f);
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self doRequest];
    [self doRequestPPC];
    if (!self.configChecked) {
        [self requestForConfigure];
    }

}

#pragma mark - private method
- (void)initRightBarButton {
    UIBarButtonItem *rightItem = [UIBarButtonItem getBarButtonItemWithImage:[UIImage imageNamed:@"anjuke_icon_setting.png"] highLihtedImg:[UIImage imageNamed:@"anjuke_icon_setting_press.png"] taget:self action:@selector(rightButtonAction:)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {//fix ios7以下 10像素偏离
        UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:10.0];
        [self.navigationItem setRightBarButtonItems:@[spacer, rightItem]];
    }else{
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}
- (void)initModel {
    self.isAJK = YES;
    self.taskArray = [NSArray arrayWithObjects:@"定价房源", @"竞价房源", @"待推广房源", nil];
    
    self.dataDic = [NSMutableDictionary dictionary];
    self.ppcDataDic = [NSMutableDictionary dictionary];
    self.myArray = [NSMutableArray array];
}

- (void)initDisplay {
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_TAB style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor whiteColor];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.showsHorizontalScrollIndicator = NO;
    tv.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tv];
    

    
    //暂时只显示header，无row
//    [self drawHeaderWithBG:hView];
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
    //check is icon downloaded
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
    if (person && person.isIconDownloaded) {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
        photo.image = [[UIImage alloc] initWithContentsOfFile:[libraryPath stringByAppendingPathComponent:person.iconPath]];
    }
    else
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
        
//        switch (i) {
//            case 0: {
//                titleStr = @"在线房源";
//                self.propNumLb = numLb;
//            }
//                break;
//            case 1: {
//                titleStr = @"今日花费";
//                self.costLb = numLb;
//            }
//                break;
//            case 2: {
//                titleStr = @"今日点击";
//                self.clickLb = numLb;
//            }
//                break;
//                
//            default:
//                break;
//        }
        
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
    
    //账户自适应
//    self.accountLb.text = [NSString stringWithFormat:@"账户余额: %@元", [self.ppcDataDic objectForKey:@"balance"]];
//    
//    self.propNumLb.text = [self.ppcDataDic objectForKey:@"onLinePropNum"];
//    self.costLb.text = [self.ppcDataDic objectForKey:@"todayAllCosts"];
//    self.clickLb.text = [self.ppcDataDic objectForKey:@"todayAllClicks"];
    
}

- (void)rightButtonAction:(id)sender {
    //设置跳转
    //    MoreViewController *mv = [[MoreViewController alloc] init];
    //    [mv setHidesBottomBarWhenPushed:YES];
    //    self.navigationController.navigationBarHidden = NO;
    //    [self.navigationController pushViewController:mv animated:YES];
    UserCenterViewController *mv = [[UserCenterViewController alloc] init];
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
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
//            nav.disableGestureForBack = YES;
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
            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
//            nav.disableGestureForBack = YES;
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_005 note:nil];
            
//            FindHomeViewController *ae = [[FindHomeViewController alloc] init];
//            [ae setHidesBottomBarWhenPushed:YES];
//            self.navigationController.navigationBarHidden = NO;
//            [self.navigationController pushViewController:ae animated:YES];
            CheckoutCommunityViewController *ae = [[CheckoutCommunityViewController alloc] init];
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
    [ba setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:ba animated:YES];
}

#pragma mark - Request Method

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
    
    if ([LoginManager getChatID].length <=0 || [LoginManager getChatID] == nil) {
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


    }
    //保存头像
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
    self.img = [[IMGDowloaderManager alloc] init];
    if (person.iconPath.length < 2) {
        if ([LoginManager getUse_photo_url] && ![[LoginManager getUse_photo_url] isEqualToString:@""]) {
//            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[LoginManager getUse_photo_url]]];
            if (self.photoImg) {
                [self.imgDownloader dowloadIMGWithURL:[NSURL URLWithString:[LoginManager getUse_photo_url]] resultBlock:^(RTNetworkResponse *response) {
                    if (response.status == 2) {
                        if (response.content && [response.content objectForKey:@"imagePath"]) {
                            UIImage *image = [UIImage imageWithContentsOfFile:[response.content objectForKey:@"imagePath"]];
                            NSArray*libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                            NSString*libPath = [libsPath objectAtIndex:0];
                            NSString *userFolder = [libPath stringByAppendingPathComponent:[LoginManager getChatID]];
                            if ([UIImageJPEGRepresentation(image, 0.96) writeToFile:userFolder atomically:YES]) {
                            }else{
                            }
                            AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
                            person.iconUrl = [LoginManager getUse_photo_url];
                            person.iconPath = [LoginManager getChatID];
                            person.isIconDownloaded = YES;
                            [[AXChatMessageCenter defaultMessageCenter] updatePerson:person];
                        }
                    }
                }];
            }
        }
    }

    [self setHomeValue];
    
    if (!self.hasLongLinked) {
        if (![LoginManager getChatID] || [[LoginManager getChatID] isEqualToString:@""] || [LoginManager getChatID] == nil) {
            
        }
        else {
            [self setTitleViewWithString:[LoginManager getRealName]];
            [self setTitleViewWithString:@"房源"];
            //******兼容安居客team得到userInfoDic并设置NSUserDefaults，以帮助底层通过对应路径获取相应数据******
            NSDictionary *dic = [LoginManager getFuckingChatUserDicJustForAnjukeTeamWithPhone:[LoginManager getPhone] uid:[LoginManager getChatID]];
            [[NSUserDefaults standardUserDefaults] setValue:dic forKey:USER_DEFAULT_KEY_AXCHATMC_USE];
            [AXChatMessageCenter defaultMessageCenter];

            [[AppDelegate sharedAppDelegate] connectLongLinkForChat];
            
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    self.configChecked = YES;
    
    NSDictionary *resultFromAPI = [[response content] objectForKey:@"data"];
    
    NSArray *frendOverNumArr = [resultFromAPI objectForKey:@"frendOverNum"]; //好友上限用
    [[NSUserDefaults standardUserDefaults] setValue:frendOverNumArr forKey:@"frendOverNumArr"];
    
    NSDictionary *tipsDic = [resultFromAPI objectForKey:@"tips"]; //是否显示状态条并跳转webView
    if ([[tipsDic objectForKey:@"openFlag"] isEqualToString:@"1"]) {//开启弹窗和跳转 test
        [self showWebViewJumpWithDic:tipsDic];
    }
    else {
        [self hideWebViewJumpBtn];
    }
}
#pragma mark - 获取计划管理信息
-(void)doRequestPPC{
    if (self.isLoading == YES) {
        //        return;
    }
    
    if(![self isNetworkOkay]){
        [self showInfo:NONETWORK_STR];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", [LoginManager getCity_id], @"cityId", nil];
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/prop/ppc/" params:params target:self action:@selector(onGetSuccess:)];
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}
- (void)onGetSuccess:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
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
    [self.myArray removeAllObjects];
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] ==  0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return ;
    }
    NSMutableDictionary *bidPlan = [[NSMutableDictionary alloc] initWithDictionary:[resultFromAPI objectForKey:@"bidPlan"]];
    [bidPlan setValue:@"1" forKey:@"type"];
    [self.myArray addObject:bidPlan];
    
    NSMutableArray *fixPlan = [NSMutableArray array];
    [fixPlan addObjectsFromArray:[resultFromAPI objectForKey:@"fixPlan"]];
    [self.myArray addObjectsFromArray:fixPlan];
    if ([fixPlan count] == 1) {
        self.isSeedPid = [[fixPlan objectAtIndex:0] objectForKey:@"fixPlanId"];
    }
    NSMutableDictionary *nodic = [[NSMutableDictionary alloc] init];
    [nodic setValue:@"待推广房源" forKey:@"title"];
    [nodic setValue:[resultFromAPI objectForKey:@"unRecommendPropNum"] forKey:@"unRecommendPropNum"];
    [nodic setValue:@"1" forKey:@"type"];
    [self.myArray addObject:nodic];
    
    [self.tvList reloadData];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
}

- (void)showWebViewJumpWithDic:(NSDictionary *)tipsDic {
    if ([[tipsDic objectForKey:@"url"] length] <= 0) {
        return;
    }
    
    self.loadingURL = [tipsDic objectForKey:@"url"];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, [self windowWidth], 40);
    [btn addTarget:self action:@selector(pushToWeb) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor whiteColor]];
    self.topAlertButton = btn;
    [btn setTintColor:[UIColor whiteColor]];
    [self.view addSubview:btn];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, (btn.frame.size.height - 20)/2, [self windowWidth] - 20*2, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:14];
    titleLb.textColor = SYSTEM_BLACK;
    titleLb.text = [tipsDic objectForKey:@"title"];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [btn addSubview:titleLb];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake([self windowWidth] - 12-10, (btn.frame.size.height - 12)/2, 12, 12)];
    icon.image = [UIImage imageNamed:@"anjuke_icon_next.png"];
    [btn addSubview:icon];
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height - 0.5, [self windowWidth], 0.5)];
    [btn addSubview:line];
}

- (void)pushToWeb {
    BrokerWebViewController *bw = [[BrokerWebViewController alloc] init];
    bw.loadingUrl = self.loadingURL;
    [bw setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:bw animated:YES];
}

- (void)hideWebViewJumpBtn {
    [self.topAlertButton removeFromSuperview];
    self.topAlertButton = nil;
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return  self.taskArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return HOME_cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentify = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
//        
//        UILabel *labNum = [[UILabel alloc] initWithFrame:CGRectMake(260, 15, 20, 20)];
//        labNum.tag = 101;
//        labNum.textColor = [UIColor whiteColor];
//        labNum.font = [UIFont systemFontOfSize:13];
//        labNum.textAlignment = NSTextAlignmentCenter;
//        labNum.layer.cornerRadius = 10;
//        labNum.layer.masksToBounds = YES;
        
//        [cell.contentView addSubview:labNum];
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
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_003 note:nil];
            
            SaleBidDetailController *controller = [[SaleBidDetailController alloc] init];
            controller.backType = RTSelectorBackTypePopToRoot;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
//            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_003 note:nil];
//            
//            //模态弹出小区--万恶的结构变动尼玛
//            CommunityListViewController *controller = [[CommunityListViewController alloc] init];
//            controller.backType = RTSelectorBackTypeDismiss;
//            controller.isFirstShow = YES;
//            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
//            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_005 note:nil];
            
            SaleNoPlanGroupController *controller = [[SaleNoPlanGroupController alloc] init];
            controller.isSeedPid = self.isSeedPid;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
//            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_004 note:nil];
//            
//            //模态弹出小区--万恶的结构变动尼玛
//            CommunityListViewController *controller = [[CommunityListViewController alloc] init];
//            controller.backType = RTSelectorBackTypeDismiss;
//            controller.isFirstShow = YES;
//            controller.isHaouzu = YES;
//            RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
//            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:
        {
            [[BrokerLogger sharedInstance] logWithActionCode:AJK_PPC_HOME_004 note:nil];
            
            SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
            controller.tempDic = [self.myArray objectAtIndex:indexPath.row];
            controller.backType = RTSelectorBackTypePopToRoot;
            [controller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:controller animated:YES];
//            [[BrokerLogger sharedInstance] logWithActionCode:AJK_HOME_005 note:nil];
//            
//            SystemMessageViewController *ae = [[SystemMessageViewController alloc] init];
//            [ae setHidesBottomBarWhenPushed:YES];
//            self.navigationController.navigationBarHidden = NO;
//            [self.navigationController pushViewController:ae animated:YES];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
