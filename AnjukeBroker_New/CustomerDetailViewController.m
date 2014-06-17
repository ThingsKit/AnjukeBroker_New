//
//  CustomerDetailViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "CustomerDetailTableView.h"
#import "UIViewExt.h"
#import "BrokerLineView.h"
#import "FavoritePropertyModel.h"
#import "CustomerDetailModel.h"

@interface CustomerDetailViewController ()

@property (nonatomic, strong) CustomerDetailTableView* tableView;

//无数据或无网络提示相关
@property (nonatomic, strong) UIView* emptyBackgroundView;
@property (nonatomic, strong) UIImageView* emptyBackgroundImageView;
@property (nonatomic, strong) UILabel* emptyBackgroundLabel;

//网络请求锁
@property (nonatomic, assign) BOOL networkRequesting; //是否正在网络请求, 加锁防止多次请求

//底部微聊button的父视图
@property (nonatomic, strong) UIView* bottomView;

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
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    _tableView = [[CustomerDetailTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 -44 - 70) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    [self initUI];
    
    self.tableView.hidden = YES;
    self.bottomView.hidden = YES;
    [self requestList:nil];
    
}

#pragma mark -
#pragma mark UI相关

- (void)initUI{
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, ScreenWidth, 70)];
    _bottomView.backgroundColor = [UIColor brokerWhiteColor];
    _bottomView.alpha = 0.9;
    [self.view addSubview:_bottomView];
    
    BrokerLineView* line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, 0, 320 - 0, 0.5)];
    [_bottomView addSubview:line];
    
    _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chatButton.frame = CGRectMake(12, 14, ScreenWidth-12*2, 42);
    [_chatButton addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_chatButton];
    
}


#pragma mark -
#pragma mark 按钮处理事件
- (void)startChat:(UIButton*)button{
    NSLog(@"发起网络强求, 判断是否可以微聊");
    
    
}


#pragma mark -
#pragma mark NetworkRequest Method 网络请求相关方法
- (void)requestList:(NSMutableDictionary*)params{
    NSString* method = @"customer/userdetail/";
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES; //网络请求加锁, 每次只有一个网络请求
    
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"broker_id", @"1", @"is_nocheck", @"123", @"device_id", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }else{
        [params setObject:[LoginManager getToken] forKey:@"token"];
        [params setObject:[LoginManager getUserID] forKey:@"broker_id"];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }
    
    
}

#pragma mark  数据请求完成

- (void)onRequestFinished:(RTNetworkResponse *)response {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSDictionary* content = response.content;
        
        CustomerDetailModel* data = [[CustomerDetailModel alloc] initWithDataDic:[content objectForKey:@"data"]];
        self.tableView.customerDetailModel = data;
        
//        NSDictionary* community = @{@"userIcon":@"http://tp1.sinaimg.cn/1404376560/50/0/1", @"userName":@"王女士", @"propertyCount":@"20", @"community":@"汤臣一品 汤臣一品 汤臣一品汤臣一品 汤臣一品 汤臣一品汤臣一品 汤臣一品 汤臣一品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"90", @"price":@"2000万"};
//        CustomerDetailModel* customer = [[CustomerDetailModel alloc] initWithDataDic:community];
//        self.tableView.customerDetailModel = customer;
   
//        NSDictionary* dict = @{@"propertyId":@"1", @"propertyIcon":@"http://pic1.ajkimg.com/display/7c545a2869acb5c3a5522ac21af8391e/133x100c.jpg", @"propertyTitle":@"高品质小区1 户型大气 满意度超高",  @"location":@"太阳系", @"community":@"汤臣一品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"90", @"price":@"2万"};
//        NSDictionary* dict2 = @{@"propertyId":@"2", @"propertyIcon":@"http://pic1.ajkimg.com/display/02f038614189f930cfb6012f97743230/133x100c.jpg", @"propertyTitle":@"高品质小区2 户型大气 满意度超高",  @"location":@"银河系", @"community":@"汤臣二品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"190", @"price":@"20000万"};
//        NSDictionary* dict3 = @{@"propertyId":@"3", @"propertyIcon":@"http://pic1.ajkimg.com/display/290175a966af385a91814cfaf53b1686/133x100c.jpg", @"propertyTitle":@"高品质小区3 户型大气 满意度超高",  @"location":@"银河系", @"community":@"汤臣三品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"180", @"price":@"2000万"};
//        
//        NSArray* data = @[dict, dict2, dict3];
        
        NSMutableArray* models = [NSMutableArray arrayWithCapacity:1];
        if (data.view_prop_info.count > 0) { //请求如果有数据
            //获取列表数据
            for (NSDictionary* temp in data.view_prop_info) {
                FavoritePropertyModel* property = [[FavoritePropertyModel alloc] initWithDataDic:temp];
                [models addObject:property];
            }
        }else{ //没有数据
            
        }
        
        //如果有新数据
        if (models.count > 0) {
            
            self.tableView.data = models;
            self.tableView.tableHeaderView = nil;
            
            //根据该用户相对于经纪人的状态来决定按钮是什么(已抢到, 微聊, 抢完了)
            if ([@"0" isEqualToString:data.status]) {
                //可以点按状态
                [_chatButton setTitle:@"微聊" forState:UIControlStateNormal];
                [_chatButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
                [_chatButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
                _chatButton.enabled = YES;
            }else if ([@"1" isEqualToString:data.status]){
//                灰色不可按状态
                [_chatButton setTitle:@"已抢到" forState:UIControlStateNormal];
                [_chatButton setTitle:@"抢完了" forState:UIControlStateNormal];
                [_chatButton setBackgroundImage:[[UIImage imageNamed:@"broker_icon_button_gray"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
                _chatButton.enabled = NO;
                
            }else if ([@"2" isEqualToString:data.status]){
                
            }
            
            
            self.bottomView.hidden = NO;
            [self.tableView reloadData];
            
            
            
        }else{ //没有新数据
            
        }
        
    }else{ //数据请求失败
        [self showTipViewWithImageViewFrame:CGRectMake(ScreenWidth/2-100/2, ScreenHeight/2-20-44-70/2, 200/2, 140/2) ImageName:@"check_no_wifi" LabelText:@"无网络连接"];
        
    }
    
    //解除请求锁
    self.networkRequesting = NO;
    self.tableView.hidden = NO;
    
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
    [self requestList:nil];
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
    
    if ([status isEqualToString:@"ok"]) { //抢成功逻辑
        
        self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_laugh"];
        self.hudText.text = @"抢成功!";
        self.hubSubText.text = @"快去联系业主吧";
        self.hubSubText.hidden = NO;
        
    }else if([status isEqualToString:@"error"]){ //失败逻辑
        
        if ([errCode isEqualToString:@"5001"]) {
            
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
            self.hudText.text = @"来晚啦~";
            self.hubSubText.text = @"房源已删除";
            self.hubSubText.hidden = NO;
            
        }else{
            self.hudText.hidden = YES;
            self.hubSubText.frame = CGRectMake(135/2-120/2, 135/2 -20, 120, 70);
            self.hubSubText.textAlignment = NSTextAlignmentCenter;
            self.hubSubText.numberOfLines = 0;
            self.hubSubText.text = message;
            [self.hubSubText sizeToFit];
            self.hubSubText.hidden = NO;
        }
        
    }else{ //这里表示网络异常
        self.hudText.hidden = YES;
        self.hubSubText.text = @"网络异常";
        self.hubSubText.hidden = NO;
    }
    
    [self.hud hide:YES afterDelay:1]; //显示一段时间后隐藏
}


@end
