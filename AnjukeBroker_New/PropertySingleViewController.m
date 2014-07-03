//
//  PricePromotionPropertySingleViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertySingleViewController.h"

#import "PropertyDetailTableViewFooter.h"
#import "PropertyDetailTableViewCell.h"
#import "PricePromotioningCell.h"
#import "ChoicePromotionableCell.h"
#import "ChoicePromotioningCell.h"
#import "ChoicePromotionDisableCell.h"
#import "PricePromotionableCell.h"
#import "ChoicePromotionQueuingCell.h"



#import "PropertyDetailCellModel.h"
#import "PricePromotionCellModel.h"
#import "ChoicePromotionCellModel.h"

@interface PropertySingleViewController ()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL networkRequesting; //网络请求锁

@property (nonatomic, strong) NSMutableArray* data; //数组用来存储5个请求回来的对象

@end

@implementation PropertySingleViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 - 44 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor brokerBgPageColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0);
    [self.view addSubview:_tableView];
    
    PropertyDetailTableViewFooter* footer = [[PropertyDetailTableViewFooter alloc] init];
    [self.view addSubview:footer];
    
    [self requestPropFixChoice];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PropertyDetailTableViewCell* cell = [[PropertyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSDictionary* dict = @{@"title":@"耀江花园30楼景观房", @"commName":@"耀江花园", @"roomNum":@"3", @"hallNum":@"2", @"toiletNum":@"1", @"area":@"120", @"price":@"400", @"priceUnit":@"万", @"isMoreImg":@"1", @"isPhonePub":@"1", @"isChoice":@"1", @"imgURL":@"http://pic1.ajkimg.com/display/fd36c5144dc2e7ef1f44d26ea6866be7/133x100c.jpg", @"publishDaysMsg":@"30天前发布"};
        cell.propertyDetailTableViewCellModel = [[PropertyDetailCellModel alloc] initWithDataDic:dict];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:95];
        return cell;
        
    }else if (indexPath.section == 1){
        
        PricePromotioningCell* cell = [[PricePromotioningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSDictionary* dict = @{@"todayClicks":@"11", @"totalClicks":@"12", @"clickPrice":@"10", @"clickPriceUnit":@"元"};
        cell.pricePromotionCellModel = [[PricePromotionCellModel alloc] initWithDataDic:dict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:90];
        return cell;
        
    }else if(indexPath.section == 2){
        
        ChoicePromotioningCell* cell = [[ChoicePromotioningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSDictionary* dict = @{@"totalClicks":@"10", @"balance":@"10", @"balanceUnit":@"元", @"todayClicks":@"1", @"todayConsume":@"1230", @"todayConsumeUnit":@"元", @"clickPrice":@"123", @"clickPriceUnit":@"元", @"maxBucketNum":@"12", @"useNum":@"12", @"actionType":@"3"};
        cell.choicePromotionModel = [[ChoicePromotionCellModel alloc] initWithDataDic:dict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:150];
        return cell;
        
    }else if(indexPath.section == 3){
        
        ChoicePromotionableCell* cell = [[ChoicePromotionableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSDictionary* dict = @{@"totalClicks":@"10", @"balance":@"10", @"balanceUnit":@"元", @"todayClicks":@"1", @"todayConsume":@"1230", @"todayConsumeUnit":@"元", @"clickPrice":@"123", @"clickPriceUnit":@"元", @"maxBucketNum":@"12", @"useNum":@"6", @"actionType":@"3"};
        cell.choicePromotionModel = [[ChoicePromotionCellModel alloc] initWithDataDic:dict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:200];
        return cell;
        
    }else if(indexPath.section == 4){
        
        ChoicePromotionDisableCell* cell = [[ChoicePromotionDisableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.choiceConditionText = @"精选推广条件: 多图+新发15天";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:125];
        return cell;
        
    }else if(indexPath.section == 5){
        
        PricePromotionableCell* cell = [[PricePromotionableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        NSDictionary* dict = @{@"todayClicks":@"11", @"totalClicks":@"12", @"clickPrice":@"10", @"clickPriceUnit":@"元"};
        cell.pricePromotionCellModel = [[PricePromotionCellModel alloc] initWithDataDic:dict];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:120];
        return cell;
    
    }else if(indexPath.section == 6){
        
        ChoicePromotionQueuingCell* cell = [[ChoicePromotionQueuingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.queuePosition = @"2";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell showTopLine];
        [cell showBottonLineWithCellHeight:150];
        return cell;
        
    }else{
        return nil;
    }
    
}



#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 95;
    }else if (indexPath.section == 1){
        return 90;
    }else if (indexPath.section == 2){
        return 150;
    }else if (indexPath.section == 3){
        return 200;
    }else if (indexPath.section == 4){
        return 125;
    }else if (indexPath.section == 5){
        return 120;
    }else if (indexPath.section == 6){
        return 150;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 30;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
    label.backgroundColor = [UIColor brokerBgPageColor];
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-15, 30)];
        label.backgroundColor = [UIColor brokerBgPageColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont ajkH5Font];
        label.textColor = [UIColor brokerLightGrayColor];
        label.text = @"30天前发布";
        [view addSubview:label];
        
        return view;
    }else{
        return nil;
    }
}


#pragma mark -
#pragma mark 解决section不跟随tableView移动的问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 15;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, -30, 0);
    } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -30, 0);
    }
    

}


#pragma mark -
#pragma mark 请求房源详情 + 定价推广

//- (void)requestPropFix{
//    if (self.networkRequesting) {
//        return;
//    }
//    
//    self.networkRequesting = YES;
//    
//    NSDictionary* param1 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":@"168783092"};
//    NSDictionary* dic1 = @{@"method":@"GET", @"relative_url":@"anjuke/prop/summary/", @"query_params":param1};
//    
//    NSDictionary* param2 = @{@"token":[LoginManager getToken], @"cityId":@"11", @"propId":@"168783092"};
//    NSDictionary* dic2 = @{@"method":@"GET", @"relative_url":@"anjuke/prop/fix/summary/", @"query_params":param2};
//    
//    NSDictionary* param = @{@"requests":@{@"prop_summary":dic1, @"fix_summary":dic2}};
//    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"batch/" params:param target:self action:@selector(onRequestPropFixFinished:)];
//    
//}
//
//- (void)onRequestPropFixFinished:(RTNetworkResponse *)response{
//    RTNetworkResponseStatus status = response.status;
//    
//    //如果请求数据成功
//    if (status == RTNetworkResponseStatusSuccess) {
//        
//        NSDictionary* content = [response.content[@"prop_summary"][@"body"] JSONValue];
//        NSString* status = [content objectForKey:@"status"];
//        
//        if ([@"ok" isEqualToString:status]) { //请求成功
//            NSDictionary* data = [content objectForKey:@"data"];
//            
//            
//        }else{ //请求失败
//            
//        }
//        
//    }else{ //数据请求失败
//        
//    }
//    
//    //解除请求锁
//    self.networkRequesting = NO;
//}

#pragma mark 请求房源详情 + 定价推广 + 精选推广  - 可推广, 推广中, 可排队(坑会超过一半), 排队中, 推广位已满, 不符合推广条件
- (void)requestPropFixChoice{
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES;
    
    NSString* prefix = @"anjuke";
    if (self.isHaozu) { //如果是租房 (默认是二手房)
        prefix = @"zufang";
    }
    
    NSDictionary* param1 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":@"168783092"};
    NSDictionary* dic1 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/prop/summary/"], @"query_params":param1}; //房源概况
    
    NSDictionary* param2 = @{@"token":[LoginManager getToken], @"cityId":@"11", @"propId":@"168783092"}; //11表示上海
    NSDictionary* dic2 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/prop/fix/summary/"], @"query_params":param2}; //房源定价概况
    
    NSDictionary* param3 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":@"168783092"};
    NSDictionary* dic3 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/prop/choice/summary/"], @"query_params":param3}; //房源精选概况
    
    NSDictionary* param4 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":@"168783092"};
    NSDictionary* dic4 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/choice/summary/"], @"query_params":param4}; //最大最小预算余额
    
    NSDictionary* param5 = @{@"token":[LoginManager getToken], @"brokerId":@"858573"};
    NSDictionary* dic5 = @{@"method":@"GET", @"relative_url":@"broker/account/balance/", @"query_params":param5}; //经纪人可用余额
    
//totalClikcs: 10, //总点击
//balance: 10, //预算余额
//balanceUnit: 元, //预算余额单位
//todayClicks: 1, //今日点击
//    todayConsume：1230, //今日花费
//todayConsumeUnit: 元, //今日花费单位
//    clickPrice : 123, //点击单价
//    clickPriceUnit : 元, //点击单价单位
//    maxBucketNum : 12, //总共拥有坑位数
//    useNum : 6,//已经使用坑位数
//actionType: => 1 //排队还是推广 1-已推广 2-已排队 3-可推广 4-坑位已满
    
    NSDictionary* param = @{@"requests":@{@"prop_summary":dic1,
                                          @"prop_fix_summary":dic2,
                                          @"prop_choice_summary":dic3,
                                          @"choice_summary":dic4,
                                          @"broker_balance":dic5
                                        }};
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"batch/" params:param target:self action:@selector(onRequestPropFixChoiceFinished:)];
    
}

- (void)onRequestPropFixChoiceFinished:(RTNetworkResponse *)response{
    RTNetworkResponseStatus status = response.status;
    
    //如果请求数据成功
    if (status == RTNetworkResponseStatusSuccess) {
        
        NSDictionary* propSum = [response.content[@"prop_summary"][@"body"] JSONValue];
        NSDictionary* propFixSum = [response.content[@"prop_fix_summary"][@"body"] JSONValue];
        NSDictionary* propChoiceSum = [response.content[@"prop_choice_summary"][@"body"] JSONValue];
        NSDictionary* choiceSum = [response.content[@"choice_summary"][@"body"] JSONValue];
        NSDictionary* brokerBalance = [response.content[@"broker_balance"][@"body"] JSONValue];
        
        if (propSum != nil && propFixSum != nil && propChoiceSum != nil) { //前三个不为空
            if ([@"ok" isEqualToString:[propSum objectForKey:@"status"]]) {
            }
        }
//        NSString* status = [content objectForKey:@"status"];
        
//        if ([@"ok" isEqualToString:status]) { //请求成功
//            NSDictionary* data = [content objectForKey:@"data"];
//        }else{ //请求失败
//            
//        }
        
    }else{ //数据请求失败
        
    }
    
    //解除请求锁
    self.networkRequesting = NO;
}


@end
