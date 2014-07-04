//
//  PricePromotionPropertySingleViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertySingleViewController.h"
#import "AXChatWebViewController.h"

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
#import "ChoiceSummaryModel.h"
#import "BrokerBalanceModel.h"

@interface PropertySingleViewController ()

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, assign) BOOL networkRequesting; //网络请求锁
@property (nonatomic, strong) PropertyDetailTableViewFooter* footer; //页脚
@property (nonatomic, strong) UIView* loadingView; //正在加载中的UIView;
@property (nonatomic, strong) UILabel* loadingTipLabel; //正在加载中的UILabel
@property (nonatomic, strong) UIActivityIndicatorView* activity; //风火轮

@property (nonatomic, strong) NSMutableArray* data; //数组用来存储5个请求回来的对象

@end

@implementation PropertySingleViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitleViewWithString:@"房源单页"];
    
    //取出参数
//    @"brokerId":@"858573", @"propId":@"168783092"   for test
    if (self.params != nil) {
        _isHaozu = [self.params[@"isHaozu"] boolValue];
        _pageType = [self.params[@"pageType"] intValue];
        _propId = self.params[@"propId"];
//        _cityId = self.params[@"cityId"];
    }else{
        _propId = @"168783092"; //测试
//        _cityId = @"11"; //上海
    }
    
    
    //表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 - 44 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor brokerBgPageColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0);
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
    
    //页脚
    _footer = [[PropertyDetailTableViewFooter alloc] init]; //页尾
    _footer.hidden = YES;
    [self.view addSubview:_footer];
    
    //正在加载中的view
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 - 44)];
    
    _loadingView.userInteractionEnabled = NO;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refresh:)];
    [_loadingView addGestureRecognizer:tap];
    
    _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activity.bounds = CGRectMake(0, 0, 200, 200);
    _activity.center = CGPointMake(ScreenWidth*0.5 - 60, (ScreenHeight-20-44)*0.5);
    [_activity startAnimating];
    [_loadingView addSubview:_activity];
    
    _loadingTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    _loadingTipLabel.center = CGPointMake(ScreenWidth*0.5, (ScreenHeight-20-44)*0.5);
    _loadingTipLabel.font = [UIFont ajkH3Font];
    _loadingTipLabel.textColor = [UIColor brokerLightGrayColor];
    _loadingTipLabel.text = @"努力加载中...";
    _loadingTipLabel.textAlignment = NSTextAlignmentCenter;
    [_loadingView addSubview:_loadingTipLabel];
    
    [self.view addSubview:_loadingView];
    
    [self requestPropFixChoice];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.data.count > 2) {
        if (self.pageType == PAGE_TYPE_FIX) { //从定价过来
            return 3;
        }else if (self.pageType == PAGE_TYPE_CHOICE){ //从精选过来
            return 3;
        }else{ //从待推广过来, 默认从待推广过来
            return 2;
        }
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) { //房源
        static NSString* identifier = @"PropertyDetailTableViewCell";
        PropertyDetailTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[PropertyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if (self.data.count > 0) {
            cell.propertyDetailTableViewCellModel = self.data[0]; //第一个是房源数据模型
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:95];
            return cell;
        }else{
            return nil;
        }
        
    }else if (indexPath.section == 1){ //定价
        
        if (self.pageType == PAGE_TYPE_NO_PLAN) { //从待推广过来
            static NSString* identifier1 = @"PricePromotionableCell";
            PricePromotionableCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
            if (cell == nil) {
                cell = [[PricePromotionableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
            }
            if (self.data.count > 1) {
                cell.pricePromotionCellModel = self.data[1]; //第二个是定价推广概况
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell showTopLine];
                [cell showBottonLineWithCellHeight:120];
                return cell;
            }else{
                return nil;
            }
            
        }else{
            static NSString* identifier2 = @"PricePromotioningCell";
            PricePromotioningCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
            if (cell == nil) {
                cell = [[PricePromotioningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            }
            if (self.data.count > 1) {
                cell.pricePromotionCellModel = self.data[1]; //第二个是定价推广概况
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell showTopLine];
                [cell showBottonLineWithCellHeight:90];
                return cell;
            }else{
                return nil;
            }
            
        }
      
    }else if(indexPath.section == 2){ //精选
        
        if (self.pageType == PAGE_TYPE_NO_PLAN) { //如果是从待推广过来, 不显示第三个cell
            return nil;
        }else{
            if (self.data.count > 2) {
                ChoicePromotionCellModel* propChoice = self.data[2]; //第三个是精选推广概况
                NSString* actionType = propChoice.actionType;
                if ([@"1" isEqualToString:actionType]) { //已推广
                    ChoicePromotioningCell* cell = [[ChoicePromotioningCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.choicePromotionModel = propChoice;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell showTopLine];
                    [cell showBottonLineWithCellHeight:150];
                    return cell;
                    
                }else if ([@"2" isEqualToString:actionType]){ //已排队
                    
                    ChoicePromotionQueuingCell* cell = [[ChoicePromotionQueuingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.queuePosition = @"2";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell showTopLine];
                    [cell showBottonLineWithCellHeight:150];
                    return cell;
                    
                }else if ([@"3" isEqualToString:actionType]){ //可推广
                    
                    ChoicePromotionableCell* cell = [[ChoicePromotionableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.choicePromotionModel = self.data[2];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell showTopLine];
                    [cell showBottonLineWithCellHeight:200];
                    return cell;
                    
                }else if ([@"4" isEqualToString:actionType]){ //坑位已满
                    
                    ChoicePromotionDisableCell* cell = [[ChoicePromotionDisableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.choiceConditionText = @"精选推广条件: 多图+新发15天";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell showTopLine];
                    [cell showBottonLineWithCellHeight:125];
                    return cell;
                    
                    
                }else{
                    
                    ChoicePromotionableCell* cell = [[ChoicePromotionableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.choicePromotionModel = self.data[2];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    [cell showTopLine];
                    [cell showBottonLineWithCellHeight:200];
                    return cell;
                    
//                    return nil;
                }
                
                
            }else{
                return nil;
            }
            
        }
        
    }else{
        return nil;
    }
    
}



#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"行%d 组%d", indexPath.row, indexPath.section);
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //取消高亮
    
    if (indexPath.section == 0) {
        
        //push 到 webview
        AXChatWebViewController *webViewController = [[AXChatWebViewController alloc] init];
//        webViewController.webUrl = url;
//        webViewController.webTitle = title;
        [self.navigationController pushViewController:webViewController animated:YES];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) { //房源详情
        return 95;
    }else{
        
        if (self.pageType == PAGE_TYPE_NO_PLAN) { //从待推广过来
            if (indexPath.section == 1) {
                return 120;
            }else{
                return 0;
            }
        }else{
            
            if (indexPath.section == 1) {
                return 90;
            }else{
                
                if (self.data.count > 2) {
                    ChoicePromotionCellModel* propChoice = self.data[2]; //第三个是精选推广概况
                    NSString* actionType = propChoice.actionType;
                    if ([@"1" isEqualToString:actionType]) {   //已推广
                        return 150;
                    }else if ([@"2" isEqualToString:actionType]){  //已排队
                        return 150;
                    }else if ([@"3" isEqualToString:actionType]){  //可推广
                        return 200;
                    }else if ([@"4" isEqualToString:actionType]){  //坑位已满
                        return 200;
                    }else if ([@"5" isEqualToString:actionType]){  //不符合推广条件
                        return 125;
                    }else{
                        return 200;
                    }
                }else{
                    return 0;
                }
            }
            
        }
        
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
        
        if (self.data.count > 0) {
            UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
            view.backgroundColor = [UIColor clearColor];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-15, 30)];
            label.backgroundColor = [UIColor brokerBgPageColor];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont ajkH5Font];
            label.textColor = [UIColor brokerLightGrayColor];
            PropertyDetailCellModel* property = self.data[0];
            label.text = property.publishDaysMsg;
            [view addSubview:label];
            return view;
        }else{
            return nil;
        }
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


#pragma mark 请求房源详情 + 定价推广 + 精选推广  - 可推广, 推广中, 可排队(坑会超过一半), 排队中, 推广位已满, 不符合推广条件
- (void)requestPropFixChoice{
    if (self.networkRequesting) {
        return;
    }
    
    self.networkRequesting = YES;

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
    
    NSString* prefix = @"anjuke";
    if (self.isHaozu) { //如果是租房 (默认是二手房)
        prefix = @"zufang";
    }
    
//    NSDictionary* param1 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":@"168783092"};
    NSDictionary* param1 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":_propId};
    NSDictionary* dic1 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/prop/summary/"], @"query_params":param1}; //房源概况
    
    NSDictionary* param2 = @{@"token":[LoginManager getToken], @"cityId":[LoginManager getCity_id], @"propId":_propId}; //11表示上海
    NSDictionary* dic2 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/prop/fix/summary/"], @"query_params":param2}; //房源定价概况
    
    NSDictionary* param3 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":_propId};
    NSDictionary* dic3 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/prop/choice/summary/"], @"query_params":param3}; //房源精选概况
    
    NSDictionary* param4 = @{@"token":[LoginManager getToken], @"brokerId":@"858573", @"propId":_propId};
    NSDictionary* dic4 = @{@"method":@"GET", @"relative_url":[prefix stringByAppendingString:@"/choice/summary/"], @"query_params":param4}; //最大最小预算余额
    
    NSDictionary* param5 = @{@"token":[LoginManager getToken], @"brokerId":@"858573"};
    NSDictionary* dic5 = @{@"method":@"GET", @"relative_url":@"broker/account/balance/", @"query_params":param5}; //经纪人可用余额
    
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
        
        if ([@"ok" isEqualToString:response.content[@"status"]]) { //匹请求成功
            
            NSDictionary* propSum = [response.content[@"data"][@"responses"][@"prop_summary"][@"body"] JSONValue];
            NSDictionary* propFixSum = [response.content[@"data"][@"responses"][@"prop_fix_summary"][@"body"] JSONValue];
            NSDictionary* propChoiceSum = [response.content[@"data"][@"responses"][@"prop_choice_summary"][@"body"] JSONValue];
            NSDictionary* choiceSum = [response.content[@"data"][@"responses"][@"choice_summary"][@"body"] JSONValue];
            NSDictionary* brokerBalance = [response.content[@"data"][@"responses"][@"broker_balance"][@"body"] JSONValue];
            
            self.data = [NSMutableArray arrayWithCapacity:5]; //清空
            
            if (propSum != nil && propFixSum != nil && propChoiceSum != nil) { //前三个不为空
                if ([@"ok" isEqualToString:[propSum objectForKey:@"status"]] && [@"ok" isEqualToString:[propFixSum objectForKey:@"status"]] && [@"ok" isEqualToString:[propChoiceSum objectForKey:@"status"]]) {
                    PropertyDetailCellModel* property = [[PropertyDetailCellModel alloc] initWithDataDic:[propSum objectForKey:@"data"]]; //房源概况
                    [self.data addObject:property];
                    
                    PricePromotionCellModel* fix = [[PricePromotionCellModel alloc] initWithDataDic:[propFixSum objectForKey:@"data"]]; //房源定价概况
                    [self.data addObject:fix];
                    
                    ChoicePromotionCellModel* propChoice = [[ChoicePromotionCellModel alloc] initWithDataDic:[propChoiceSum objectForKey:@"data"]]; //房源精选概况
                    //######################################### for test
                    propChoice.maxBucketNum = @"20";
                    propChoice.useNum = @"10";
                    propChoice.actionType = @"3"; //1-已推广 2-已排队 3-可推广 4-坑位已满
                    //#########################################
                    [self.data addObject:propChoice];
                    
                    _tableView.hidden = NO;
                    _footer.hidden = NO;
                    _loadingView.hidden = YES;
                    [_tableView reloadData];
                    
                }else{ //前三个中任意一个失败, 页面等待, 重新请求, 请求超时
                    [_activity stopAnimating];
                    _loadingTipLabel.text = @"加载超时, 点击重新加载";
                    _loadingView.userInteractionEnabled = YES;
                    
                }
            }
            
            if (choiceSum != nil && brokerBalance != nil) {
                if ([@"ok" isEqualToString:[choiceSum objectForKey:@"status"]]) {
                    ChoiceSummaryModel* choice = [[ChoiceSummaryModel alloc] initWithDataDic:[choiceSum objectForKey:@"data"]];
                    [self.data addObject:choice];
                }
                if ([@"ok" isEqualToString:[brokerBalance objectForKey:@"status"]]) {
                    BrokerBalanceModel* balance = [[BrokerBalanceModel alloc] initWithDataDic:[brokerBalance objectForKey:@"data"]];
                    [self.data addObject:balance];
                }
            }else{ //这两者的数据用于UIAlertView, 如果为空, 弹框前再次请求
                
            }
            
            
            
        }else{  //匹请求失败
            
        }
        
        
    }else{ //数据请求失败
        
    }
    
    //解除请求锁
    self.networkRequesting = NO;
}

#pragma mark -
#pragma mark 手势重新加载
- (void)refresh:(UITapGestureRecognizer*)gesture{
    NSLog(@"tap");
    _loadingView.userInteractionEnabled = NO;
    _loadingTipLabel.text = @"努力加载中...";
    [_activity startAnimating];
    [self requestPropFixChoice];
}

@end
