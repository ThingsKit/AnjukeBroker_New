//
//  QiangFangYuanWeiTuoViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RushPropertyViewController.h"
#import "UIViewExt.h"
#import "NetworkRequest.h"
#import "PropertyModel.h"
#import "MyPropertyModel.h"
#import "LoginManager.h"
#import <AudioToolbox/AudioToolbox.h>

@interface RushPropertyViewController ()

@property (nonatomic, strong) PropertyTableView* tableView;
@property (nonatomic ,strong) MyPropertyTableView* myTableView;

@property (nonatomic, strong) UIButton* leftTabButton;
@property (nonatomic, strong) UIButton* rightTabButton;

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
    
    self.tableView = [[PropertyTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44) style:UITableViewStylePlain];
    self.tableView.hidden = NO;
    [self.view addSubview:self.tableView];
    
    self.myTableView = [[MyPropertyTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44) style:UITableViewStylePlain];
    self.myTableView.hidden = YES;
    [self.view addSubview:self.myTableView];
    
    self.tableView.eventDelegate = self;
    self.myTableView.eventDelegate = self;  //以self.tableView.hidden 来做逻辑判断
    
    [self autoRefresh];
}


#pragma mark -
#pragma mark - 数据请求完成

- (void)onRequestFinished:(RTNetworkResponse *)response {
    
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSDictionary* content = response.content;
        NSArray* data = [content objectForKey:@"data"];
        
        NSMutableArray* properties = nil;
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
                
                [self.myTableView reloadData];
            }
            
            
            //播放提示音
            SystemSoundID sounds[0];
            NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
            CFURLRef soundURL = (__bridge CFURLRef)[NSURL fileURLWithPath:soundPath];
            AudioServicesCreateSystemSoundID(soundURL, &sounds[0]);
            AudioServicesPlaySystemSound(sounds[0]);
            
            
        }else{ //没有新数据
            
        }
        
        
    }else{ //数据请求失败
        if (self.myTableView.hidden) { //如果位于抢委托房源列表
            UIView* emptyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-49-44)];
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2, ScreenHeight/2, 180/2, 158/2)];
            
            
        }else{
            
        }
        
    }
    
    

    
}

#pragma mark -
#pragma mark TabButton Action
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
#pragma mark - BaseTableViewDelegate

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
    
}


#pragma mark -
#pragma mark NetworkRequest Method
- (void)requestPropertyList:(NSMutableDictionary*)params{
    NSString *method = @"commission/propertyList/";
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
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
#pragma mark Memory Managment

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
