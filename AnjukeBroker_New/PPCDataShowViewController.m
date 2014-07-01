//
//  PPCDataShowViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PPCDataShowViewController.h"
#import "PPCDataShowCell.h"

@interface PPCDataShowViewController ()
//@property(nonatomic, strong) UITableView *tableList;
@property(nonatomic, strong) NSDictionary *tableData;
@end

@implementation PPCDataShowViewController
@synthesize isHaozu;

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    if (self.isHaozu) {
        [self setTitleViewWithString:@"租房"];
    }else{
        [self setTitleViewWithString:@"二手房"];
    }
    [self addRightButton:@"发布" andPossibleTitle:nil];
    
    self.tableList.dataSource = self;
    self.tableList.delegate = self;
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableList.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableList];

//    [self autoPullDown];
}

- (void)doRequest{
//    NSMutableDictionary *params = nil;
//    NSString *method = nil;
//    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"]) {
//        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude_specify"] doubleValue]],@"lat",[NSString stringWithFormat:@"%f",[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude_specify"] doubleValue]],@"lng", nil];
//    }else{
//        params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[LoginManager getToken], @"token",[LoginManager getUserID],@"brokerId",[NSString stringWithFormat:@"%f",self.nowCoords.latitude],@"lat",[NSString stringWithFormat:@"%f",self.nowCoords.longitude],@"lng", nil];
//    }
//    method = [NSString stringWithFormat:@"broker/commSignList/"];
//    
//    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 3) {
        return 15;
    }else if (indexPath.row == 1 || indexPath.row == 2){
        return 150;
    }else if (indexPath.row == 4){
        return 45;
    }else{
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify1 = @"cell1";
    static NSString *identify2 = @"cell2";
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        PPCDataShowCell *cell = [tableView dequeueReusableCellWithIdentifier:identify1];
        if (!cell) {
            cell = [[PPCDataShowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify1];
        }
        if (indexPath.row == 1) {
            [cell showTopLine];
            cell.isPricing = YES;
            [cell showBottonLineWithCellHeight:150 andOffsetX:15];
        }else{
            cell.isPricing = NO;
            [cell showBottonLineWithCellHeight:150];
        }
        [cell configureCell:nil withIndex:indexPath.row];
        return cell;
    }else{
        RTListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify2];
        if (!cell) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify2];
        }
        if ((indexPath.row == 0 || indexPath.row == 3)) {
            cell.backgroundColor = [UIColor clearColor];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row == 4){
            [cell showTopLine];
            [cell showBottonLineWithCellHeight:45];
            cell.textLabel.text = @"待推广房源";
            cell.textLabel.textColor = [UIColor brokerBlackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }else if (indexPath.row == 5){
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
            lab.backgroundColor = [UIColor clearColor];
            lab.textAlignment = NSTextAlignmentRight;
            lab.textColor = [UIColor brokerLightGrayColor];
            lab.text = @"以上均为今日数据";
            lab.font = [UIFont ajkH5Font];
            [cell.contentView addSubview:lab];
        }
        
        return cell;
    }
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.tableData || self.navigationController.view.frame.origin.x > 0) {
        return;
    }
    
    
}

#pragma mark -- rightButton
- (void)rightButtonAction:(id)sender{
    if (self.isHaozu) {
        
    }else{
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
