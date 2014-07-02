//
//  PricePromotionPropertySingleViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PricePromotionPropertySingleViewController.h"

#import "PropertyDetailTableViewFooter.h"
#import "PropertyDetailTableViewCell.h"
#import "PricePromotioningCell.h"
#import "ChoicePromotionableCell.h"
#import "ChoicePromotioningCell.h"
#import "ChoicePromotionDisableCell.h"
#import "PricePromotionableCell.h"
#import "ChoicePromotionQueuingCell.h"



#import "PropertyDetailTableViewCellModel.h"
#import "PricePromotionCellModel.h"
#import "ChoicePromotionCellModel.h"

@interface PricePromotionPropertySingleViewController ()

@property (nonatomic, strong) UITableView* tableView;

@end

@implementation PricePromotionPropertySingleViewController

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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 20 - 44 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor brokerBgPageColor];
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, -30, 0);
    [self.view addSubview:_tableView];
    
    PropertyDetailTableViewFooter* footer = [[PropertyDetailTableViewFooter alloc] init];
    [self.view addSubview:footer];
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
        cell.propertyDetailTableViewCellModel = [[PropertyDetailTableViewCellModel alloc] initWithDataDic:dict];
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

@end
