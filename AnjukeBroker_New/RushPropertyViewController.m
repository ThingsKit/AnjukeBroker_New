//
//  QiangFangYuanWeiTuoViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RushPropertyViewController.h"
#import "UIViewExt.h"
#import "PropertyModel.h"
#import "MyPropertyModel.h"
#import "MBProgressHUD.h"
#import "PropertyTableViewCell.h"

@interface RushPropertyViewController ()

@property (nonatomic, strong) PropertyTableView* tableView;
@property (nonatomic ,strong) MyPropertyTableView* myTableView;

@property (nonatomic, strong) UIButton* leftTabButton;
@property (nonatomic, strong) UIButton* rightTabButton;
@property (nonatomic, strong) UIView* leftEmptyBackgroundView;
@property (nonatomic, strong) UIView* rightEmptyBackgroundView;
@property (nonatomic, strong) UIImageView* leftImageView;
@property (nonatomic, strong) UIImageView* rightImageView;
@property (nonatomic, strong) UILabel* leftLabel;
@property (nonatomic, strong) UILabel* rightLabel;

//浮层相关
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) UIImageView* hudBackground;
@property (nonatomic, strong) UIImageView* hudImageView;
@property (nonatomic, strong) UILabel* hudText;
@property (nonatomic, strong) UILabel* hubSubText;

//alert相关
@property (nonatomic, strong) UIImageView* alertBackgroundImageView;

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
    [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_LIST_ONVIEW page:COMMISSION_LIST note:@{@"push":FIND_PAGE}];
    self.tableView = [[PropertyTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain];
    self.tableView.hidden = NO;
    self.tableView.hasMore = YES;
    [self.view addSubview:self.tableView];
    
    self.myTableView = [[MyPropertyTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44) style:UITableViewStylePlain];
    self.myTableView.hidden = YES;
    self.myTableView.hasMore = YES;
    [self.view addSubview:self.myTableView];
    
    self.tableView.eventDelegate = self;
    self.myTableView.eventDelegate = self;  //以self.tableView.hidden 来做逻辑判断
    
    
    [self autoRefresh]; //自动下拉
    
}

- (void)doBack:(id)sender{
    if (self.myTableView.hidden) {
        [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_LIST_CLICK_BACK page:COMMISSION_LIST note:nil];
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_MINE_CLICK_BACK page:COMMISSION_MINE note:nil];
    }
    
    [super doBack:sender];
}


#pragma mark -
#pragma mark - 数据请求完成

- (void)onRequestFinished:(RTNetworkResponse *)response {
    
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSDictionary* content = response.content;
        NSArray* data = [content objectForKey:@"data"];
        
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
        }else{
            
        }
        
        //如果有新数据
        if (properties.count > 0) {
            NSMutableArray* list = nil;
            
            if (self.myTableView.hidden) { //待委托房源列表
                
                if (!self.tableView.isPullUp) { //待委托列表下拉
                    list = [NSMutableArray arrayWithArray:properties];
//                    [list addObjectsFromArray:self.tableView.data];
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
                
                NSString* nextPage = [content objectForKey:@"nextPage"];
                if ([@"0" isEqualToString:nextPage]) {
                    self.tableView.hasMore = NO;
                }else{
                    self.tableView.hasMore = YES;
                }
                
                [self.tableView reloadData];
                
                
            }else{ //我的委托房源列表
                
                if (!self.myTableView.isPullUp) { //我的委托列表下拉
                    list = [NSMutableArray arrayWithArray:properties];
//                    [list addObjectsFromArray:self.myTableView.data];
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
                
                NSString* nextPage = [content objectForKey:@"nextPage"];
                if ([@"0" isEqualToString:nextPage]) {
                    self.myTableView.hasMore = NO;
                }else{
                    self.myTableView.hasMore = YES;
                }
                
                [self.myTableView reloadData];
            }
            
            
        }else{ //没有新数据
            if (self.myTableView.hidden) {
                if (self.tableView.isPullUp) {
                    self.tableView.hasMore = NO;
                }
                
            }else{
                if (self.myTableView.isPullUp) {
                    self.myTableView.hasMore = NO;
                }
                
            }
            
            [self showTipViewWithImageViewFrame:CGRectMake(ScreenWidth/2-90/2, ScreenHeight/2-20-44-79/2, 180/2, 158/2) ImageName:@"anjuke_icon_weituo_nopropery" LabelText:@"暂无委托"];
            
        }
        
        
    }else{ //数据请求失败
        [self showTipViewWithImageViewFrame:CGRectMake(ScreenWidth/2-100/2, ScreenHeight/2-20-44-70/2, 200/2, 140/2) ImageName:@"check_no_wifi" LabelText:@"无网络连接"];
        
    }
    
    //解除请求锁
    self.leftIsRequesting = NO;
    self.rightIsRequesting = NO;
    
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
    
    if ([status isEqualToString:@"ok"]) { //抢成功逻辑
        
        self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_laugh"];
        self.hudImageView.hidden = NO;
        self.hudText.text = @"抢成功!";
        self.hubSubText.text = @"快去联系业主吧";
        self.hubSubText.hidden = NO;
        
    }else if([status isEqualToString:@"error"]){ //失败逻辑
        
        if ([errCode isEqualToString:@"5001"]) {
            
            self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
            self.hudImageView.hidden = NO;
            self.hudText.text = @"来晚啦~";
            self.hubSubText.text = @"房源已删除";
            self.hubSubText.hidden = NO;
            
        }else{
            self.hudImageView.hidden = YES;
            self.hudText.frame = CGRectMake(135/2-120/2, 135/2 -20, 120, 70);
            self.hudText.numberOfLines = 0;
            self.hudText.text = message;
            self.hudText.hidden = NO;
            self.hubSubText.hidden = YES;
        }
        
    }else{ //这里表示网络异常
        self.hudImageView.image = [UIImage imageNamed:@"check_no_wifi"];
        self.hudImageView.hidden = NO;
        self.hudImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.hudText.text = @"无网络连接";
        self.hudText.hidden = NO;
        self.hubSubText.hidden = YES;
    }
    
    [self.hud hide:YES afterDelay:1]; //显示一段时间后隐藏
}



- (void)hideHUD {
    [self.hud hide:YES];
}



#pragma mark -
#pragma mark TabButton Action 顶部左右两个tab相关

- (void)leftTabButtonClicked{
    NSLog(@"left clicked");
    [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_LIST_ONVIEW page:COMMISSION_LIST note:@{@"bp":FIND_PAGE}];
    
    [self.leftTabButton setBackgroundColor:[UIColor brokerBlueGrayColor]];
    [self.rightTabButton setBackgroundColor:[UIColor clearColor]];
    self.leftTabButton.selected = YES; //左边选中状态
    self.rightTabButton.selected = NO;
    
    self.tableView.hidden = NO;
    self.myTableView.hidden = YES;
    [self autoRefresh];
}

- (void)rightTabButtonClicked{
    NSLog(@"right clicked");
    [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_MINE_ONVIEW page:COMMISSION_MINE note:nil];
    
    [self.leftTabButton setBackgroundColor:[UIColor clearColor]];
    [self.rightTabButton setBackgroundColor:[UIColor brokerBlueGrayColor]];
    self.leftTabButton.selected = NO;
    self.rightTabButton.selected = YES;
    
    self.tableView.hidden = YES;
    self.myTableView.hidden = NO;
    
    //badge清0
    self.propertyListBadgeLabel.hidden = YES;
    self.badgeNumber = 0;
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"propertyListBadgeLabelHidden"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self autoRefresh];
}



#pragma mark -
#pragma mark - BaseTableViewDelegate  上啦下拉点击相关

- (void)pullDown:(BaseTableView *)tableView {
    
    //如果位于抢委托页面
    if (self.myTableView.hidden) {
        [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_LIST_PULL_REFRESH page:COMMISSION_LIST note:nil];
        self.tableView.isPullUp = NO;
//        if (self.tableView.maxId != nil && self.tableView.maxId.length != 0) {
//            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.tableView.maxId forKey:@"maxId"];
//            [self requestList:params];
//        }else{
            [self requestList:nil];
//        }
        
        
    }else{
        self.myTableView.isPullUp = NO;
//        if (self.myTableView.maxId != nil && self.myTableView.maxId.length != 0) {
//            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.myTableView.maxId forKey:@"maxId"];
//            [self requestList:params];
//        }else{
            [self requestList:nil];
//        }
        
    }
    
}

- (void)pullUp:(BaseTableView *)tableView {
    //如果位于抢委托页面
    if (self.myTableView.hidden) {
        [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_LIST_PULL_LOAD page:COMMISSION_LIST note:nil];
        self.tableView.isPullUp = YES;
        if (self.tableView.sinceId != nil && self.tableView.sinceId.length != 0) {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.tableView.sinceId forKey:@"sinceId"];
            [self requestList:params];
        }else{
            [self requestList:nil];
        }
        
        
    }else{
        [[BrokerLogger sharedInstance] logWithActionCode:COMMISSION_MINE_PULL_REFRESH page:COMMISSION_MINE note:nil];
        self.myTableView.isPullUp = YES;
        if (self.myTableView.sinceId != nil && self.myTableView.sinceId.length != 0) {
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:self.myTableView.sinceId forKey:@"sinceId"];
            [self requestList:params];
        }else{
            [self requestList:nil];
        }
        
    }
    
}

- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell click %d", indexPath.row);
}


#pragma mark -
#pragma mark removeCellFromTableView
- (void)removeCellFromPropertyTableViewWithCell:(PropertyTableViewCell*)cell{ //删除cell
    NSIndexPath* indexPath = [self.tableView indexPathForCell:(UITableViewCell*)cell];
    [self.tableView.data removeObjectAtIndex:indexPath.row]; //删除数据
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)updateCellWithCell:(PropertyTableViewCell*)cell{ //更新cell状态
    NSIndexPath* indexPath = [self.tableView indexPathForCell:(UITableViewCell*)cell];
    [self.tableView.data replaceObjectAtIndex:indexPath.row withObject:cell.propertyModel]; //更新model
}

- (NSIndexPath*)indexPathFromCell:(PropertyTableViewCell*)cell{
    return [self.tableView indexPathForCell:(UITableViewCell*)cell];
}


#pragma mark -
#pragma mark NetworkRequest Method 网络请求相关方法
- (void)requestList:(NSMutableDictionary*)params{
    NSString* method = nil;
    
    if (self.myTableView.hidden) {
        
        if (self.leftIsRequesting) { //如果正在请求网络
            return;
        }
        self.leftIsRequesting = YES;
        method = @"commission/propertyList/";
        
        
    }else{
        
        if (self.rightIsRequesting) { //如果正在请求网络
            return;
        }
        self.rightIsRequesting = YES;
        method = @"commission/myPropertyList/";
        
    }
    
    if (params == nil) {
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }else{
        [params setObject:[LoginManager getToken] forKey:@"token"];
        [params setObject:[LoginManager getUserID] forKey:@"brokerId"];
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    }
    
    
}


- (void) autoRefresh {
    
    if (self.myTableView.hidden) {
        if (!self.leftAutoPullDown) {
            [self.tableView autoPullDownRefresh];
            self.leftAutoPullDown = YES;
            [self pullDown:nil];
        }
    }else{
        if (!self.rightAutoPullDown) {
            [self.myTableView autoPullDownRefresh]; //自动下拉
            self.rightAutoPullDown = YES;
            [self pullDown:nil];
        }
    }
    
    //加载数据
}


- (void) autoRefreshWithNoLimitation {
    
    if (self.myTableView.hidden) {
        [self.tableView autoPullDownRefresh];
        self.leftAutoPullDown = YES;
        [self pullDown:nil];
    }else{
        [self.myTableView autoPullDownRefresh]; //自动下拉
        self.rightAutoPullDown = YES;
        [self pullDown:nil];
    }
    
    //加载数据
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
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//    headView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    headView.layer.borderColor = [UIColor brokerBlueGrayColor].CGColor;
    headView.layer.borderWidth = 1.0f;
    headView.layer.cornerRadius = 3.0f;
    headView.layer.masksToBounds = YES;
    headView.clipsToBounds = NO; //超出部分切掉
    
    self.leftTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightTabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftTabButton.frame = CGRectMake(0, 0, headView.width/2, headView.height);
    self.rightTabButton.frame = CGRectMake(headView.width/2, 0, headView.width/2, headView.height);
    [self.leftTabButton setTitle:@"抢委托" forState:UIControlStateNormal];
    [self.rightTabButton setTitle:@"我的委托" forState:UIControlStateNormal];
    [self.leftTabButton.titleLabel setFont:[UIFont ajkH3Font_B]];
    [self.rightTabButton.titleLabel setFont:[UIFont ajkH3Font_B]];
    
    [self.leftTabButton setTitleColor:[UIColor brokerBlueGrayColor] forState:UIControlStateNormal];  //未选中的文字颜色
//    [self.leftTabButton setTitleColor:[UIColor brokerBlackColor] forState:UIControlStateHighlighted]; //选中后的文字颜色
    [self.leftTabButton setTitleColor:[UIColor brokerBlackColor] forState:UIControlStateSelected];
    
    [self.rightTabButton setTitleColor:[UIColor brokerBlueGrayColor] forState:UIControlStateNormal];
//    [self.rightTabButton setTitleColor:[UIColor brokerBlackColor] forState:UIControlStateHighlighted];
    [self.rightTabButton setTitleColor:[UIColor brokerBlackColor] forState:UIControlStateSelected];
    
//    [self.leftTabButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
    [self.leftTabButton setBackgroundColor:[UIColor brokerBlueGrayColor]];
    [self.rightTabButton setBackgroundColor:[UIColor clearColor]];
//    [self.rightTabButton setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:1]];
    
    self.leftTabButton.selected = YES; //默认左边选中
    
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
    
    
    //创建badge
    self.propertyListBadgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 6, 10, 10)];
    self.propertyListBadgeLabel.backgroundColor = [UIColor redColor];
    self.propertyListBadgeLabel.layer.cornerRadius = 5.0f;
    self.propertyListBadgeLabel.layer.masksToBounds = YES;
//    self.propertyListBadgeLabel.textColor = [UIColor grayColor];
//    self.propertyListBadgeLabel.textAlignment = UITextAlignmentCenter; //这里已经做过调整, 兼容ios5.0
    NSString* isHidden = [[NSUserDefaults standardUserDefaults] objectForKey:@"propertyListBadgeLabelHidden"];
    if ([@"1" isEqualToString:isHidden]) {
        self.propertyListBadgeLabel.hidden = NO;
    }else{
        self.propertyListBadgeLabel.hidden = YES;
        self.badgeNumber = 0;
    }
    [headView addSubview:self.propertyListBadgeLabel];
    
    headView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = headView;
    
    
}


#pragma mark -
#pragma mark 显示空白背景
- (void) showTipViewWithImageViewFrame:(CGRect)imageViewFrame ImageName:(NSString*)imageName LabelText:(NSString*)labelText{
    
    if (self.leftEmptyBackgroundView == nil) {
        _leftEmptyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
        _leftEmptyBackgroundView.backgroundColor = [UIColor clearColor];
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_leftEmptyBackgroundView addSubview:_leftImageView];
        
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.backgroundColor = [UIColor clearColor];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [_leftLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_leftLabel setTextColor:[UIColor brokerLightGrayColor]];
        [self.leftEmptyBackgroundView addSubview:_leftLabel];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoRefreshWithNoLimitation)];
        [self.leftEmptyBackgroundView addGestureRecognizer:tap];
        
    }
    
    _leftImageView.frame = imageViewFrame;
    _leftImageView.image = [UIImage imageNamed:imageName];
    
    _leftLabel.frame = CGRectMake(ScreenWidth/2-90/2, _leftImageView.bottom, 90, 30);
    _leftLabel.text = labelText;
    
    
    if (self.rightEmptyBackgroundView == nil) {
        _rightEmptyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20-44)];
        _rightEmptyBackgroundView.backgroundColor = [UIColor clearColor];
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.rightEmptyBackgroundView addSubview:_rightImageView];
        
        _rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.backgroundColor = [UIColor clearColor];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        [_rightLabel setFont:[UIFont systemFontOfSize:16.0]];
        [_rightLabel setTextColor:[UIColor brokerLightGrayColor]];
        [self.rightEmptyBackgroundView addSubview:_rightLabel];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(autoRefreshWithNoLimitation)];
        [self.rightEmptyBackgroundView addGestureRecognizer:tap];
        
    }
    
    _rightImageView.frame = imageViewFrame;
    _rightImageView.image = [UIImage imageNamed:imageName];
    
    _rightLabel.frame = CGRectMake(ScreenWidth/2-90/2, _leftImageView.bottom, 90, 30);
    _rightLabel.text = labelText;
    
    if (self.myTableView.hidden) { //如果位于抢委托房源列表
        if (self.tableView.data.count == 0) {
            self.tableView.tableHeaderView = self.leftEmptyBackgroundView;
            self.tableView.tableHeaderView.hidden = NO;
            self.tableView.hasMore = NO;
        }else{
            self.tableView.tableHeaderView.hidden = YES;
        }
        [self.tableView reloadData];
    }else{
        if (self.myTableView.data.count == 0) {
            self.myTableView.tableHeaderView = self.rightEmptyBackgroundView;
            self.myTableView.tableHeaderView.hidden = NO;
            self.myTableView.hasMore = NO;
        }else{
            self.myTableView.tableHeaderView.hidden = YES;
        }
        [self.myTableView reloadData];
    }

}

@end
