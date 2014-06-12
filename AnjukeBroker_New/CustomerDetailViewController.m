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
@property (nonatomic, strong) UIView* emptyBackgroundView;
@property (nonatomic, assign) BOOL networkRequesting; //是否正在网络请求, 加锁防止多次请求

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
    
    _tableView = [[CustomerDetailTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 -44 - 70) style:UITableViewStylePlain];
    _tableView.needRefreshFooter = NO;
    _tableView.needRefreshHeader = NO;
    [self.view addSubview:_tableView];
    
    [self initUI];
    
    [self requestList:nil];
    
}

#pragma mark -
#pragma mark UI相关

- (void)initUI{
    
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, ScreenWidth, 70)];
    bottomView.backgroundColor = [UIColor brokerWhiteColor];
    bottomView.alpha = 0.9;
    [self.view addSubview:bottomView];
    
    BrokerLineView* line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, 0, 320 - 0, 0.5)];
    [bottomView addSubview:line];
    
    _chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _chatButton.frame = CGRectMake(12, 14, ScreenWidth-12*2, 42);
    [_chatButton addTarget:self action:@selector(startChat:) forControlEvents:UIControlEventTouchUpInside];
    
    //根据该用户相对于经纪人的状态来决定按钮是什么(已抢到, 微聊, 抢完了)
    
    //可以点按状态
//    [_chatButton setTitle:@"微聊" forState:UIControlStateNormal];
//    [_chatButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
//    [_chatButton setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_blue_press"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateHighlighted];
//    _chatButton.enabled = YES;
    
    //灰色不可按状态
    [_chatButton setTitle:@"已抢到" forState:UIControlStateNormal];
    [_chatButton setTitle:@"抢完了" forState:UIControlStateNormal];
    [_chatButton setBackgroundImage:[[UIImage imageNamed:@"broker_icon_button_gray"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 20)] forState:UIControlStateNormal];
    _chatButton.enabled = NO;
    
    [bottomView addSubview:_chatButton];
    
}


#pragma mark -
#pragma mark 按钮处理事件
- (void)startChat:(UIButton*)button{
    NSLog(@"发起网络强求, 判断是否可以微聊");

    
}


#pragma mark -
#pragma mark NetworkRequest Method 网络请求相关方法
- (void)requestList:(NSMutableDictionary*)params{
    NSString* method = @"commission/propertyList/";
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES; //网络请求加锁, 每次只有一个网络请求
    
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }else{
        [params setObject:[LoginManager getToken] forKey:@"token"];
        [params setObject:[LoginManager getUserID] forKey:@"brokerId"];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }
    
    
}

#pragma mark  数据请求完成

- (void)onRequestFinished:(RTNetworkResponse *)response {
    
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSDictionary* content = response.content;
        //        NSArray* data = [content objectForKey:@"data"];
        
//        @property (nonatomic, copy) NSString* userIcon; //用户头像路径
//        @property (nonatomic, copy) NSString* userName; //用户名称
//        @property (nonatomic, copy) NSString* propertyCount; //浏览房源数量
//        
//        @property (nonatomic, copy) NSString* community; //偏好小区
//        @property (nonatomic, copy) NSString* room; //偏好户型
//        @property (nonatomic, copy) NSString* hall;
//        @property (nonatomic, copy) NSString* toilet;
//        @property (nonatomic, copy) NSString* price; //偏好价格
        
        NSDictionary* community = @{@"userIcon":@"http://tp1.sinaimg.cn/1404376560/50/0/1", @"userName":@"王女士", @"propertyCount":@"20", @"community":@"汤臣一品 汤臣一品 汤臣一品 汤臣一品 汤臣一品 汤臣一品 汤臣一品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"90", @"price":@"2000万"};
        CustomerDetailModel* customer = [[CustomerDetailModel alloc] initWithDataDic:community];
        self.tableView.customerDetailModel = customer;
        
        
//        @property (nonatomic, copy) NSString* propertyId; //房源id
//        @property (nonatomic, copy) NSString* propertyIcon; //房源图片
//        @property (nonatomic, copy) NSString* propertyTitle;  //房源标题
//        @property (nonatomic, copy) NSString* location;   //房源所属板块
//        @property (nonatomic, copy) NSString* community; //房源所属小区
//        @property (nonatomic, copy) NSString* room; //室
//        @property (nonatomic, copy) NSString* hall; //厅
//        @property (nonatomic, copy) NSString* toilet; //卫
//        @property (nonatomic, copy) NSString* area;   //面积
//        @property (nonatomic, copy) NSString* price;  //价格或租金
//        @property (nonatomic, copy) NSString* priceUnit;  //单位价格
        
        
        
        NSDictionary* dict = @{@"propertyId":@"1", @"propertyIcon":@"http://pic1.ajkimg.com/display/7c545a2869acb5c3a5522ac21af8391e/133x100c.jpg", @"propertyTitle":@"高品质小区1 户型大气 满意度超高",  @"location":@"太阳系", @"community":@"汤臣一品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"90", @"price":@"2000万"};
        NSDictionary* dict2 = @{@"propertyId":@"2", @"propertyIcon":@"http://pic1.ajkimg.com/display/02f038614189f930cfb6012f97743230/133x100c.jpg", @"propertyTitle":@"高品质小区2 户型大气 满意度超高",  @"location":@"银河系", @"community":@"汤臣二品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"190", @"price":@"20000万"};
        NSDictionary* dict3 = @{@"propertyId":@"3", @"propertyIcon":@"http://pic1.ajkimg.com/display/290175a966af385a91814cfaf53b1686/133x100c.jpg", @"propertyTitle":@"高品质小区3 户型大气 满意度超高",  @"location":@"银河系", @"community":@"汤臣三品", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"area":@"180", @"price":@"2000万"};
        
        NSArray* data = @[dict, dict2, dict3];
        
        NSMutableArray* models = [NSMutableArray arrayWithCapacity:1];
        if (data.count > 0) { //请求如果有数据
            //获取列表数据
            for (NSDictionary* temp in data) {
                FavoritePropertyModel* property = [[FavoritePropertyModel alloc] initWithDataDic:temp];
                [models addObject:property];
            }
        }else{ //没有数据
            
        }
        
        //如果有新数据
        if (models.count > 0) {
            
            self.tableView.data = models;
            
            self.tableView.tableHeaderView = nil;
            
            if (models.count < 20) {
                self.tableView.hasMore = NO;
            }else{
                self.tableView.hasMore = YES;
            }
            
            [self.tableView reloadData];
            
            
            
        }else{ //没有新数据
            if (self.tableView.isPullUp) {
                self.tableView.hasMore = NO;
            }
            
//            [self showEmptyBackground];
            
        }
        
        
    }else{ //数据请求失败
//        [self showEmptyBackground];
        
    }
    
    //解除请求锁
    self.networkRequesting = NO;
    
}


@end
