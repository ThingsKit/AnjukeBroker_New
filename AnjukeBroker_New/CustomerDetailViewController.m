//
//  CustomerDetailViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "CustomerDetailTableView.h"
#import "UIViewExt.h"
#import "BrokerLineView.h"
#import "FavoritePropertyModel.h"
#import "CustomerDetailModel.h"
#import "BrokerChatViewController.h"
#import "AppDelegate.h"
#import "WillSendPropModel.h"

@interface CustomerDetailViewController ()

@property (nonatomic, strong) CustomerDetailTableView* tableView;

//无数据或无网络提示相关
@property (nonatomic, strong) UIView* emptyBackgroundView;
@property (nonatomic, strong) UIImageView* emptyBackgroundImageView;
@property (nonatomic, strong) UILabel* emptyBackgroundLabel;

//网络请求锁
@property (nonatomic, assign) BOOL networkRequesting; //是否正在网络请求, 加锁防止多次请求

@property (nonatomic, strong) UIView* bottomView; //底部微聊button的父视图
@property (nonatomic, strong) UIButton* chatButton; //微聊按钮

//浮层相关
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) UIImageView* hudBackground;
@property (nonatomic, strong) UIImageView* hudImageView;
@property (nonatomic, strong) UILabel* hudText;
@property (nonatomic, strong) UILabel* hubSubText;

@end

@implementation CustomerDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleViewWithString:@"客户资料"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_DETAIL_ONVIEW page:POTENTIAL_CLIENT_DETAIL note:nil]; //页面可见
    
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    _tableView = [[CustomerDetailTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 -44 - 70) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    [self initUI];
    
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    
//    [self userDetailRequest:nil];
    
}

- (void)doBack:(id)sender{
    [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_DETAIL_BACK page:POTENTIAL_CLIENT_DETAIL note:nil]; //点击返回
    [super doBack:sender];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self userDetailRequest:nil];
}


#pragma mark -
#pragma mark 按钮处理事件
- (void)startChat:(UIButton*)button{
    NSLog(@"发起网络强求, 判断是否可以微聊");
    [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_DETAIL_CHAT page:POTENTIAL_CLIENT_DETAIL note:@{@"clientid":self.tableView.customerDetailModel.device_id}]; //页面可见
    _chatButton.enabled = NO; //锁定按钮
    [self checkStatusRequest:nil];

}

- (void)pushToBrokerChatViewController{
    
    WillSendPropModel *sendProp = [[WillSendPropModel alloc] init];
    
    BrokerChatViewController *bc = [[BrokerChatViewController alloc] init];
    bc.backType = RTSelectorBackTypePopBack;
    bc.isBroker = YES;
    bc.isSayHello = YES;
    
    [sendProp setI:self.tableView.customerDetailModel.i];
    [sendProp setMacid:self.tableView.customerDetailModel.macid];
    [sendProp setUdid2:self.tableView.customerDetailModel.udid2];
    [sendProp setDevice_id:self.tableView.customerDetailModel.device_id];
    [sendProp setApp:self.tableView.customerDetailModel.app];
    
    bc.willSendProp = sendProp;
    if ([@"i-ajk" isEqualToString:self.tableView.customerDetailModel.app]) {
        bc.deviceID = self.tableView.customerDetailModel.udid2;
    }else if([@"a-ajk" isEqualToString:self.tableView.customerDetailModel.app]){
        bc.deviceID = [self.tableView.customerDetailModel.i stringByAppendingString:self.tableView.customerDetailModel.macid];
    }
    
    bc.userNickName = self.tableView.customerDetailModel.user_name;
    
    
    [bc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:bc animated:YES];
}

#pragma mark -
#pragma mark NetworkRequest Method 网络请求相关方法

- (void)userDetailRequest:(NSMutableDictionary*)params{
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES; //网络请求加锁, 每次只有一个网络请求
    NSString* method = @"customer/userdetail/";
    
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"broker_id", self.device_id, @"device_id", nil];
//        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", @"147468", @"broker_id", @"1", @"is_nocheck", self.device_id, @"device_id", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }else{
        
    }
    
    
}

- (void)checkStatusRequest:(NSMutableDictionary*)params{
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES; //网络请求加锁, 每次只有一个网络请求
    NSString* method = @"customer/checkstatus/";
    
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"broker_id", self.device_id, @"device_id", nil];
//        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", @"147468", @"broker_id", self.device_id, @"device_id", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onCheckFinished:)];
    }else{

    }
    
}

- (void)lockRequest:(NSMutableDictionary*)params{
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES; //网络请求加锁, 每次只有一个网络请求
    NSString* method = @"customer/lock/";
    
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"broker_id", self.device_id, @"device_id", nil];
//        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", @"147468", @"broker_id", @"1", @"is_nocheck", self.device_id, @"device_id", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onLockFinished:)];
    }else{
        
    }
}

#pragma mark -
#pragma mark  数据请求完成

- (void)onRequestFinished:(RTNetworkResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.networkRequesting = NO; //解除请求锁
    
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSDictionary* content = response.content;
//        NSLog(@"%@", content);
        
        if ([@"ok" isEqualToString:[content objectForKey:@"status"]]) {
            
            CustomerDetailModel* data = [[CustomerDetailModel alloc] initWithDataDic:[content objectForKey:@"data"]];
            self.tableView.customerDetailModel = data;
//            self.tableView.customerDetailModel.comm_preference = @"江山如画(一至三期) 东辉花园 葛洲坝国际广场";
            CGSize communitySize = [self.tableView.customerDetailModel.comm_preference sizeWithFont:[UIFont ajkH3Font] constrainedToSize:CGSizeMake(ScreenWidth - 15*2, 40)];
            self.tableView.customerDetailModel.lineHeight = communitySize.height;
            //        self.tableView.customerDetailModel.status = @"0";
            //        self.tableView.customerDetailModel.comm_preference = @"汤臣一品 汤臣一品 汤臣一品汤臣一品 汤臣一品 汤臣一品汤臣一品 汤臣一品 汤臣一品";
            
            NSMutableArray* models = [NSMutableArray arrayWithCapacity:1];
            if (data.view_prop_info.count > 0) { //如果有房源数据
                for (NSDictionary* temp in data.view_prop_info) {
                    FavoritePropertyModel* property = [[FavoritePropertyModel alloc] initWithDataDic:temp];
                    [models addObject:property];
                }
            }else{ //没有数据
                
            }
            
            //如果有新数据
            if (models.count > 0) {
                self.tableView.data = models;
            }else{ //没有房源数据
                
            }
//            data.status = @"0";
            //根据该用户相对于经纪人的状态来决定按钮是什么(已抢到, 微聊, 抢完了)
            if ([@"0" isEqualToString:data.status]) {
                //可抢
                [self setChatButtonEnable];
                
            }else if ([@"1" isEqualToString:data.status]){
                //已抢到
                [self setChatButtonRushSucceed];
                
            }else if([@"2" isEqualToString:data.status]){
                //抢完了
                [self setChatButtonRushFail];
            }else if([@"3" isEqualToString:data.status]){
                //已经锁定
                [self setChatButtonEnable];
            }else if([@"4" isEqualToString:data.status]){
                //人数达到上限
                [self setChatButtonEnable];
            }else{
                _bottomView.hidden = YES;
            }
            
            self.tableView.tableHeaderView = nil;
            self.bottomView.hidden = NO;
            [self.tableView reloadData];
            
        }else{ //数据请求失败
            NSDictionary* content = response.content;
            NSString* message = [content objectForKey:@"message"];
            if (message) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
        
    }else{ //网络不畅
        [self showTipViewWithImageViewFrame:CGRectMake(ScreenWidth/2-100/2, ScreenHeight/2-20-44-70/2, 200/2, 140/2) ImageName:@"check_no_wifi" LabelText:@"无网络连接"];
    }
    
    self.tableView.hidden = NO;
    
}

- (void)onCheckFinished:(RTNetworkResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.networkRequesting = NO;//解除请求锁
    _chatButton.enabled = YES;
    
    RTNetworkResponseStatus status = response.status;

    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSDictionary* content = response.content;
        
        if ([@"ok" isEqualToString:[content objectForKey:@"status"]]) {
            //这里有五种状态, 分别对应不同的处理
            NSDictionary* data = [content objectForKey:@"data"];
            NSString* status = [data objectForKey:@"status"];

            if ([@"0" isEqualToString:status]) {
                //可以抢, 发起锁定请求,如果请求成功, 则进入相应页面
                [self lockRequest:nil];
                
            }else if ([@"1" isEqualToString:status]){
                //已抢到, 按钮变灰
                [self setChatButtonRushSucceed];
                [self displayHUDWithStatus:@"error" Message:nil ErrCode:@"1"];
                
            }else if ([@"2" isEqualToString:status]){
                //已抢完, 按钮变灰
                [self setChatButtonRushFail];
                [self displayHUDWithStatus:@"error" Message:nil ErrCode:@"2"];
                
            }else if ([@"3" isEqualToString:status]){
                //用户被临时锁定, 显示微聊(可以抢), 不再锁定, 直接跳转相应页面
                [self pushToBrokerChatViewController];
            }else if ([@"4" isEqualToString:status]){
                //经纪人每天只能抢3个, 达到上限
                NSString* message = [data objectForKey:@"message"];
                [self displayHUDWithStatus:@"error" Message:message ErrCode:@"3"];
            }
            
        }else{ //数据请求失败
            NSDictionary* content = response.content;
            NSString* message = [content objectForKey:@"message"];
            if (message) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        }
        
    }else{ //网络不畅
        [self displayHUDWithStatus:@"error" Message:nil ErrCode:nil];
    }

}

- (void)onLockFinished:(RTNetworkResponse *)response {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.networkRequesting = NO;//解除请求锁
    _chatButton.enabled = YES;
    
    RTNetworkResponseStatus status = response.status;
    if (status == RTNetworkResponseStatusSuccess) { //如果请求数据成功
        NSDictionary* content = response.content;
        
        if ([@"ok" isEqualToString:[content objectForKey:@"status"]]) {
            NSDictionary* data = [content objectForKey:@"data"];
            if ([@"1" isEqualToString:[data objectForKey:@"success"]]) {
                //锁定成功, 跳转相应页面
                [self pushToBrokerChatViewController];
            }
            
        }else{//请求锁定失败

        }
        
    }else{ //网络不畅
        [self displayHUDWithStatus:@"error" Message:nil ErrCode:nil];
    }
    
}


#pragma mark -
#pragma mark UI相关

- (void)initUI{
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, ScreenWidth, 70)];
    _bottomView.backgroundColor = [UIColor brokerWhiteColor];
//    _bottomView.backgroundColor = [UIColor redColor];
    _bottomView.alpha = 0.9;
    [self.view addSubview:_bottomView];
    
    BrokerLineView* line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, 0, 320 - 0, 0.5)];
    [_bottomView addSubview:line];
    
    _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chatButton.frame = CGRectMake(12, 14, ScreenWidth-12*2, 42);
    [_chatButton addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_chatButton];
    
}


- (void)setChatButtonEnable{
    _bottomView.hidden = NO;
    [_chatButton setTitle:@"微聊" forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateHighlighted];
    _chatButton.enabled = YES;
}

- (void)setChatButtonRushSucceed{
    _bottomView.hidden = NO;
    [_chatButton setTitle:@"已抢到" forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:[[UIImage imageNamed:@"broker_icon_button_gray"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateNormal];
    _chatButton.enabled = NO;
}

- (void)setChatButtonRushFail{
    _bottomView.hidden = NO;
    [_chatButton setTitle:@"抢完了" forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:[[UIImage imageNamed:@"broker_icon_button_gray"] stretchableImageWithLeftCapWidth:20 topCapHeight:21] forState:UIControlStateDisabled];
    _chatButton.enabled = NO;
}

- (void) showTipViewWithImageViewFrame:(CGRect)imageViewFrame ImageName:(NSString*)imageName LabelText:(NSString*)labelText{
    if (self.emptyBackgroundView == nil) {
        _emptyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
        _emptyBackgroundView.backgroundColor = [UIColor clearColor];
        _emptyBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.emptyBackgroundView addSubview:_emptyBackgroundImageView];
        
        _emptyBackgroundLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _emptyBackgroundLabel.backgroundColor = [UIColor clearColor];
        _emptyBackgroundLabel.textAlignment = NSTextAlignmentCenter;
        [_emptyBackgroundLabel setFont:[UIFont ajkH3Font]];
        [_emptyBackgroundLabel setTextColor:[UIColor brokerLightGrayColor]];
        [self.emptyBackgroundView addSubview:_emptyBackgroundLabel];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoRefresh)];
        [self.emptyBackgroundView addGestureRecognizer:tap];
        
    }
    
    _emptyBackgroundImageView.frame = imageViewFrame;
    _emptyBackgroundImageView.image = [UIImage imageNamed:imageName];
    
    _emptyBackgroundLabel.frame = CGRectMake(ScreenWidth/2-90/2, _emptyBackgroundImageView.bottom, 90, 30);
    _emptyBackgroundLabel.text = labelText;
    
    if (self.tableView.data.count == 0) {
        self.tableView.tableHeaderView = self.emptyBackgroundView;
        self.tableView.tableHeaderView.hidden = NO;
        self.bottomView.hidden = YES;
    }else{
        self.tableView.tableHeaderView.hidden = YES;
        self.bottomView.hidden = NO;
    }
    [self.tableView reloadData];
    
}

- (void) autoRefresh {
    [self userDetailRequest:nil];
    //加载数据
}



#pragma mark -
#pragma mark MBProgressHUD 相关
//使用 MBProgressHUD 显示微聊按钮的状态
- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode {
    if (self.hudBackground == nil) {
        self.hudBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 135)];
        self.hudBackground.image = [UIImage imageNamed:@"anjuke_icon_tips_bg"];
        
        self.hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(135/2-70/2, 135/2-70/2 - 20, 70, 70)];
        self.hudText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.hudImageView.bottom+7, 135, 20)];
        [self.hudText setTextColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [self.hudText setFont:[UIFont systemFontOfSize:17.0f]];
        [self.hudText setTextAlignment:NSTextAlignmentCenter];
        self.hudText.backgroundColor = [UIColor clearColor];
        
        self.hubSubText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.hudText.bottom, 135, 20)];
        [self.hubSubText setTextColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [self.hubSubText setFont:[UIFont systemFontOfSize:12.0f]];
        [self.hubSubText setTextAlignment:NSTextAlignmentCenter];
        self.hubSubText.backgroundColor = [UIColor clearColor];
        
        [self.hudBackground addSubview:self.hudImageView];
        [self.hudBackground addSubview:self.hudText];
        [self.hudBackground addSubview:self.hubSubText];
        
    }
    
    //使用 MBProgressHUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.customView = self.hudBackground;
    self.hud.yOffset = -20;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.dimBackground = NO;
    
    if([status isEqualToString:@"error"]){ //失败逻辑
        
        if ([@"1" isEqualToString:errCode]) {
            
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_laugh"];
            self.hudText.text = @"客户已抢到";
            self.hubSubText.text = @"去微聊吧";
            self.hubSubText.hidden = NO;
            
        }else if ([@"2" isEqualToString:errCode]){
            
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
            self.hudText.text = @"客户被抢了";
            self.hubSubText.text = @"你太慢了";
            self.hubSubText.hidden = NO;
            
        }else if([@"3" isEqualToString:errCode]){
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
            self.hudText.hidden = YES;
            self.hudText.text = message;
            self.hubSubText.text = message;
            self.hubSubText.hidden = NO;
            
        }else{
            self.hudImageView.image = [UIImage imageNamed:@"check_no_wifi"];
            self.hudImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.hudText.text = @"无网络连接";
            self.hubSubText.hidden = YES;
            self.hudText.hidden = NO;
            
        }
    }
    
    [self.hud hide:YES afterDelay:2]; //显示一段时间后隐藏
}


@end
