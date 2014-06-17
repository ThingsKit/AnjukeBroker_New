//
//  FindCustomerViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "FindCustomerViewController.h"
#import "CustomerTableView.h"
#import "UIViewExt.h"
#import "CustomerModel.h"
#import "CustomerDetailViewController.h"

@interface FindCustomerViewController ()

@property (nonatomic, strong) CustomerTableView* tableView;
@property (nonatomic, strong) UIView* emptyBackgroundView;
@property (nonatomic, strong) UIImageView* emptyBackgroundImageView;
@property (nonatomic, strong) UILabel* emptyBackgroundLabel;

@property (nonatomic, assign) BOOL networkRequesting; //是否正在网络请求, 加锁防止多次请求

@end

@implementation FindCustomerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitleViewWithString:@"抢客户"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[CustomerTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    
    self.tableView.eventDelegate = self;
    
    [self autoRefresh];
    
}

- (void) autoRefresh {
    [self.tableView autoPullDownRefresh]; //自动下拉
    [self pullDown:nil];
}


#pragma mark -
#pragma mark 上拉下拉点击
- (void)pullUp:(BaseTableView *)tableView{
    self.tableView.isPullUp = YES;
    if (self.tableView.sinceId != nil && self.tableView.sinceId.length != 0) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.tableView.sinceId forKey:@"sinceId"];
        [self requestList:params];
    }else{
        [self requestList:nil];
    }
}


- (void)pullDown:(BaseTableView *)tableView{
    self.tableView.isPullUp = NO;
    if (self.tableView.maxId != nil && self.tableView.maxId.length != 0) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.tableView.maxId forKey:@"maxId"];
        [self requestList:params];
    }else{
        [self requestList:nil];
    }
}

- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CustomerDetailViewController* detail = [[CustomerDetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:YES];
    
}



#pragma mark -
#pragma mark NetworkRequest Method 网络请求相关方法
- (void)requestList:(NSMutableDictionary*)params{
    NSString* method = @"customer/userlist/";
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES; //网络请求加锁, 每次只有一个网络请求
    
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"broker_id", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }else{
        [params setObject:[LoginManager getToken] forKey:@"token"];
        [params setObject:[LoginManager getUserID] forKey:@"broker_id"];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }
    
    
}

#pragma mark - 数据请求完成

- (void)onRequestFinished:(RTNetworkResponse *)response {
    
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSDictionary* content = response.content;
//        NSArray* data = [content objectForKey:@"data"];
        
        self.tableView.customerCount = 10;
        self.tableView.propertyRushableCount = 3;
        
//        @property (nonatomic, copy) NSString* id;
//        @property (nonatomic, copy) NSString* userIcon;  //用户头像
//        @property (nonatomic, copy) NSString* userName;   //用户名
//        @property (nonatomic, copy) NSString* loginTime;  //用户上次登录时间
//        @property (nonatomic, copy) NSString* location; //地点
//        @property (nonatomic, copy) NSString* houseType; //户型
//        @property (nonatomic, copy) NSString* price; //售价
//        @property (nonatomic, copy) NSString* propertyCount; //浏览房源数
//        @property (nonatomic, copy) NSString* userStatus; //当前改用户相对于经纪人的状态 (我抢了, 抢完了)
        
        NSDictionary* dict = @{@"id":@"1", @"userIcon":@"http://tp1.sinaimg.cn/1404376560/50/0/1", @"userName":@"王女士", @"loginTime":@"10", @"location":@"地球", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"price":@"2000w", @"propertyCount":@"20",@"userStatus":@"1"};
        NSDictionary* dict2 = @{@"id":@"2", @"userIcon":@"", @"userName":@"欧阳先生", @"loginTime":@"10", @"location":@"地球", @"room":@"2",@"hall":@"1",@"toilet":@"1", @"price":@"2000w", @"propertyCount":@"20",@"userStatus":@"2"};
        
        NSArray* data = @[dict, dict2];
        
        NSMutableArray* models = [NSMutableArray arrayWithCapacity:1];
        if (data.count > 0) { //请求如果有数据
            //获取列表数据
            for (NSDictionary* temp in data) {
                CustomerModel* customer = [[CustomerModel alloc] initWithDataDic:temp];
                [models addObject:customer];
            }
        }else{ //没有数据
            
        }
        
        //如果有新数据
        if (models.count > 0) {
            NSMutableArray* list = nil;
            
            if (!self.tableView.isPullUp) {
                list = [NSMutableArray arrayWithArray:models];
                [list addObjectsFromArray:self.tableView.data];
            }else{ //待委托列表上啦
                list = [NSMutableArray arrayWithArray:self.tableView.data];
                [list addObjectsFromArray:models];
            }
            
            self.tableView.data = list;
            
            CustomerModel* minModel = self.tableView.data.lastObject;  //获取最小id
            self.tableView.sinceId = minModel.id;
            
            CustomerModel* maxModel = self.tableView.data.firstObject; //获取最大id
            self.tableView.maxId = maxModel.id;
            
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
            
            [self showTipViewWithImageViewFrame:CGRectMake(ScreenWidth/2-85/2, ScreenHeight/2-20-44-75/2, 170/2, 149/2) ImageName:@"broker_qkh_noclient" LabelText:@"暂无客户"];
            
        }
        
        
    }else{ //数据请求失败
        [self showTipViewWithImageViewFrame:CGRectMake(ScreenWidth/2-100/2, ScreenHeight/2-20-44-70/2, 200/2, 140/2) ImageName:@"check_no_wifi" LabelText:@"无网络连接"];
        
    }
    
    //解除请求锁
    self.networkRequesting = NO;
    
}

#pragma mark -
#pragma mark UI相关
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
        self.tableView.hasMore = NO;
    }else{
        self.tableView.tableHeaderView.hidden = YES;
    }
    [self.tableView reloadData];
    
}


@end
