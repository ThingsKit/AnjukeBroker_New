//
//  QiangFangYuanWeiTuoViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RushPropertyViewController.h"
#import "UIViewExt.h"
#import "PropertyModel.h"
#import "MyPropertyModel.h"
#import "LoginManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"

@interface RushPropertyViewController ()

@property (nonatomic, strong) PropertyTableView* tableView;
@property (nonatomic ,strong) MyPropertyTableView* myTableView;

@property (nonatomic, strong) UIButton* leftTabButton;
@property (nonatomic, strong) UIButton* rightTabButton;
@property (nonatomic, strong) UIView* leftEmptyBackgroundView;
@property (nonatomic, strong) UIView* rightEmptyBackgroundView;
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) UIImageView* hudBackground;
@property (nonatomic, strong) UIImageView* hudImageView;
@property (nonatomic, strong) UILabel* hudText;
@property (nonatomic, strong) UILabel* hubSubText;


@end

@implementation RushPropertyViewController

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
    [self initUI]; //初始化 self.navigationItem.titleView
    
    self.tableView = [[PropertyTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain];
    self.tableView.hidden = NO;
    [self.view addSubview:self.tableView];
    
    self.myTableView = [[MyPropertyTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain];
    self.myTableView.hidden = YES;
    [self.view addSubview:self.myTableView];
    
    self.tableView.eventDelegate = self;
    self.myTableView.eventDelegate = self;  //以self.tableView.hidden 来做逻辑判断
    
    [self autoRefresh];
    
//    NSString *method = @"commission/rush/";
//    NSMutableDictionary* params = [NSMutableDictionary dictionary];
//    [params setObject:@"token" forKey:[LoginManager getToken]];
//    [params setObject:@"brokerId" forKey:[LoginManager getUserID]];
//    [params setObject:@"propertyId" forKey:@"123"];
//    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestTestFinished:)];
    
}


#pragma mark -
#pragma mark Test
- (void)onRequestTestFinished:(RTNetworkResponse*)response{
    NSString* message = [response.content objectForKey:@"message"];
    NSLog(@"%@", message);
    
//    NSArray* data = [response.content objectForKey:@"data"];
//    for (NSDictionary* dic in data) {
//        NSLog(@"%@", dic);
//    }
}


#pragma mark -
#pragma mark - 数据请求完成

- (void)onRequestFinished:(RTNetworkResponse *)response {
    
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess || status == RTNetworkResponseStatusJsonError) {
        NSDictionary* content = response.content;
//        NSArray* data = [content objectForKey:@"data"];
        
        NSDictionary* dict = @{@"id":@"1", @"propertyId":@"123", @"commName":@"新中源", @"type":@"2", @"room":@"2", @"hall":@"2", @"toilet":@"2", @"area":@"400", @"price":@"2000", @"priceUnit":@"元/月", @"publishTime":@"2014-05-01 06:03:07", @"rushable":@"1", @"rushed":@"0",};
        NSDictionary* dict2 = @{@"id":@"2", @"propertyId":@"456", @"commName":@"新中源实际花园", @"type":@"1", @"room":@"2", @"hall":@"2", @"toilet":@"2", @"area":@"400", @"price":@"500", @"priceUnit":@"万", @"publishTime":@"2014-05-01 06:03:07", @"rushable":@"0", @"rushed":@"1",};
        
        NSArray* data = @[dict, dict2];
        
        NSMutableArray* properties = [NSMutableArray arrayWithCapacity:1];
        if (data.count > 0) { //请求如果有数据
            if (self.myTableView.hidden) {
                //获取待委托列表数据
                properties = [[NSMutableArray alloc] initWithCapacity:data.count];
                for (NSDictionary* temp in data) {
                    PropertyModel* property = [[PropertyModel alloc] initWithDataDic:temp];
                    [properties addObject:property];
                }
                
            }else{
                //获取我的委托列表数据
                properties = [[NSMutableArray alloc] initWithCapacity:data.count];
                for (NSDictionary* temp in data) {
                    MyPropertyModel* property = [[MyPropertyModel alloc] initWithDataDic:temp];
                    [properties addObject:property];
                }
            }
        }
        
        
        //如果有新数据
        if (properties.count > 0) {
            NSMutableArray* list = nil;
  
            if (self.myTableView.hidden) { //待委托房源列表
                
                if (!self.tableView.isPullUp) { //待委托列表下拉
                    list = [NSMutableArray arrayWithArray:properties];
                    [list addObjectsFromArray:self.tableView.data];
                }else{ //待委托列表上啦
                    list = [NSMutableArray arrayWithArray:self.tableView.data];
                    [list addObjectsFromArray:properties];
                }
  
                self.tableView.data = list;
                
                PropertyModel* minProperty = self.tableView.data.lastObject;  //获取最小id
                self.tableView.sinceId = minProperty.id;
                
                PropertyModel* maxProperty = self.tableView.data.firstObject; //获取最大id
                self.tableView.maxId = maxProperty.id;
                
                self.tableView.tableHeaderView = nil;
                
                [self.tableView reloadData];
                
            }else{ //我的委托房源列表
                
                if (!self.myTableView.isPullUp) { //我的委托列表下拉
                    list = [NSMutableArray arrayWithArray:properties];
                    [list addObjectsFromArray:self.myTableView.data];
                }else{ //我的委托上啦
                    list = [NSMutableArray arrayWithArray:self.myTableView.data];
                    [list addObjectsFromArray:properties];
                }
                
                self.myTableView.data = list;
                
                MyPropertyModel* minProperty = self.myTableView.data.lastObject;  //获取最小id
                self.myTableView.sinceId = minProperty.id;
                
                MyPropertyModel* maxProperty = self.myTableView.data.firstObject; //获取最大id
                self.myTableView.maxId = maxProperty.id;
                
                self.myTableView.tableHeaderView = nil;
                
                [self.myTableView reloadData];
            }
            
            
            //播放提示音
            SystemSoundID sounds[0];
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
            CFURLRef soundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:soundPath];
            AudioServicesCreateSystemSoundID(soundURL, &sounds[0]);
            AudioServicesPlaySystemSound(sounds[0]);
            
            
        }else{ //没有新数据
            [self showEmptyBackground];
            
        }
        
        
    }else{ //数据请求失败
        [self showEmptyBackground];

    }
    

}


#pragma mark -
#pragma mark MBProgressHUD 相关

//使用 MBProgressHUD 显示抢委托结果
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
    
    if ([status isEqualToString:@"ok"]) {
        self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_laugh"];
        self.hudText.text = @"抢成功!";
        self.hubSubText.text = @"快去联系业主吧";
        self.hubSubText.hidden = NO;
    }else if([status isEqualToString:@"error"]){
        if ([errCode isEqualToString:@"5001"]) {
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
            self.hudText.text = @"来晚啦~";
            self.hubSubText.text = @"房源已删除";
            self.hubSubText.hidden = NO;
        }else if ([errCode isEqualToString:@"5002"]){
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_laugh"];
            self.hudText.text = @"抢过来!";
            self.hubSubText.text = @"去我的委托看看吧";
            self.hubSubText.hidden = NO;
        }else{
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
            self.hudText.text = @"抢完了~";
            self.hubSubText.hidden = YES;
        }
        
    }else{ //这里表示网络异常
        self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
        self.hudText.text = @"网络异常";
        self.hubSubText.hidden = YES;
    }
    
    [self.hud hide:YES afterDelay:1]; //显示一段时间后隐藏
}



- (void)hideHUD {
    [self.hud hide:YES];
}


#pragma mark -
#pragma mark 释放模态视图
- (void)cancelAction:(UIButton*)button {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -
#pragma mark 显示空白背景

- (void)showEmptyBackground{
    
    if (self.leftEmptyBackgroundView == nil) {
        self.leftEmptyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
        self.leftEmptyBackgroundView.backgroundColor = [UIColor clearColor];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-90/2, ScreenHeight/2-20-44-79/2, 180/2, 158/2)];
        imageView.image = [UIImage imageNamed:@"anjuke_icon_weituo_nopropery"];
        [self.leftEmptyBackgroundView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-60/2, imageView.bottom, 60, 30)];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        label.text = @"暂无委托";
        [self.leftEmptyBackgroundView addSubview:label];
        
    }
    
    if (self.rightEmptyBackgroundView == nil) {
        self.rightEmptyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
        self.rightEmptyBackgroundView.backgroundColor = [UIColor clearColor];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-90/2, ScreenHeight/2-20-44-79/2, 180/2, 158/2)];
        imageView.image = [UIImage imageNamed:@"anjuke_icon_weituo_nopropery"];
        [self.rightEmptyBackgroundView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2-60/2, imageView.bottom, 60, 30)];
        label.backgroundColor = [UIColor clearColor];
        [label setFont:[UIFont systemFontOfSize:14.0]];
        label.text = @"暂无委托";
        [self.rightEmptyBackgroundView addSubview:label];
        
    }
    
    if (self.myTableView.hidden) { //如果位于抢委托房源列表
        if (self.tableView.data.count == 0) {
            self.tableView.tableHeaderView = self.leftEmptyBackgroundView;
            self.tableView.tableHeaderView.hidden = NO;
        }else{
            self.tableView.tableHeaderView.hidden = YES;
        }
        [self.tableView reloadData];
    }else{
        if (self.myTableView.data.count == 0) {
            self.myTableView.tableHeaderView = self.rightEmptyBackgroundView;
            self.myTableView.tableHeaderView.hidden = NO;
        }else{
            self.myTableView.tableHeaderView.hidden = YES;
        }
        [self.myTableView reloadData];
    }
}


#pragma mark -
#pragma mark TabButton Action 顶部左右两个tab相关

- (void)leftTabButtonClicked{
    NSLog(@"left clicked");
    [self.leftTabButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.rightTabButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    self.leftTabButton.highlighted = YES; //左边选中状态
    self.rightTabButton.highlighted = NO;
    
    self.tableView.hidden = NO;
    self.myTableView.hidden = YES;
    [self autoRefresh];
}

- (void)rightTabButtonClicked{
    NSLog(@"right clicked");
    [self.leftTabButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    [self.rightTabButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    self.leftTabButton.highlighted = NO;
    self.rightTabButton.highlighted = YES;
    
    self.tableView.hidden = YES;
    self.myTableView.hidden = NO;
    [self autoRefresh];
}



#pragma mark -
#pragma mark - BaseTableViewDelegate  上啦下拉点击相关

- (void)pullDown:(BaseTableView *)tableView {
    
    //如果位于抢委托页面
    if (self.myTableView.hidden) {
        self.tableView.isPullUp = NO;
        if (self.tableView.maxId != nil && self.tableView.maxId.length != 0) {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.tableView.maxId forKey:@"maxId"];
            [self requestPropertyList:params];
        }else{
            [self requestPropertyList:nil];
        }
        
        
    }else{
        self.myTableView.isPullUp = NO;
        if (self.myTableView.maxId != nil && self.myTableView.maxId.length != 0) {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.myTableView.maxId forKey:@"maxId"];
            [self requestMyPropertyList:params];
        }else{
            [self requestMyPropertyList:nil];
        }
        
    }

}

- (void)pullUp:(BaseTableView *)tableView {
    //如果位于抢委托页面
    if (self.myTableView.hidden) {
        self.tableView.isPullUp = NO;
        if (self.tableView.sinceId != nil && self.tableView.sinceId.length != 0) {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.tableView.sinceId forKey:@"sinceId"];
            [self requestPropertyList:params];
        }else{
            [self requestPropertyList:nil];
        }
        
        
    }else{
        self.myTableView.isPullUp = NO;
        if (self.myTableView.sinceId != nil && self.myTableView.sinceId.length != 0) {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.myTableView.sinceId forKey:@"sinceId"];
            [self requestMyPropertyList:params];
        }else{
            [self requestMyPropertyList:nil];
        }
        
    }
    
}

- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView.data removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    NSLog(@"cell click");
}


#pragma mark -
#pragma mark NetworkRequest Method 网络请求相关方法

- (void)requestPropertyList:(NSMutableDictionary*)params{
    NSString *method = @"commission/propertyList/";
    if (params == nil) {
//        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", @"147468", @"brokerId", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }else{
        [params setObject:@"token" forKey:[LoginManager getToken]];
        [params setObject:@"brokerId" forKey:[LoginManager getUserID]];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }
    
    
}

- (void)requestMyPropertyList:(NSMutableDictionary*)params{
    NSString *method = @"commission/myPropertyList/";
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }else{
        [params setObject:@"token" forKey:[LoginManager getToken]];
        [params setObject:@"brokerId" forKey:[LoginManager getUserID]];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }
}



- (void) autoRefresh {
    if (self.myTableView.hidden) {
        [self.tableView autoPullDownRefresh];
    }else{
        [self.myTableView autoPullDownRefresh]; //自动下拉
    }
    
    //加载数据
    [self pullDown:nil];
}



#pragma mark -
#pragma mark Memory Managment 内存相关

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -
#pragma mark init UI
- (void)initUI{
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    headView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    headView.layer.borderWidth = 2.0f;
    headView.layer.cornerRadius = 3.0f;
    headView.layer.masksToBounds = YES;
    headView.clipsToBounds = YES; //超出部分切掉
    
    self.leftTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftTabButton.frame = CGRectMake(0, 0, headView.width/2, headView.height);
    self.rightTabButton.frame = CGRectMake(headView.width/2, 0, headView.width/2, headView.height);
    [self.leftTabButton setTitle:@"抢委托" forState:UIControlStateNormal];
    [self.rightTabButton setTitle:@"我的委托" forState:UIControlStateNormal];
    
    [self.leftTabButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];  //未选中的文字颜色
    [self.leftTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted]; //选中后的文字颜色
    
    [self.rightTabButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.rightTabButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    [self.leftTabButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.rightTabButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
//    [leftTabButton setBackgroundImage:nil forState:UIControlStateNormal];
//    [leftTabButton setBackgroundImage:nil forState:UIControlStateHighlighted];
//    
//    [rightTabButton setBackgroundImage:nil forState:UIControlStateNormal];
//    [rightTabButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    
    self.leftTabButton.highlighted = YES; //默认左边选中
    
    [self.leftTabButton addTarget:self action:@selector(leftTabButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.rightTabButton addTarget:self action:@selector(rightTabButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:self.leftTabButton];
    [headView addSubview:self.rightTabButton];
    
    
    
    UIBezierPath* leftPath = [UIBezierPath bezierPathWithRoundedRect:self.leftTabButton.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                                         cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = headView.bounds;
    maskLayer.path = leftPath.CGPath;
    self.leftTabButton.layer.mask = maskLayer;
    
    UIBezierPath* rightPath = [UIBezierPath bezierPathWithRoundedRect:self.rightTabButton.bounds
                                                    byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                                          cornerRadii:CGSizeMake(3.0, 3.0)];
    
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = headView.bounds;
    maskLayer2.path = rightPath.CGPath;
    self.rightTabButton.layer.mask = maskLayer2;
    
    
    headView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = headView;
    
}

@end
