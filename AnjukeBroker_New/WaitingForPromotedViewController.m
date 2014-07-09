//
//  HZWaitingForPromotedViewController.m
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "WaitingForPromotedViewController.h"
#import "PropSelectStatusModel.h"
#import "PropertyDetailCellModel.h"
#import "PropertyEditViewController.h"
#import "MultipleChoiceAndEditListCell.h"
#import "RTGestureBackNavigationController.h"
#import "PropertySingleViewController.h"
#import "UIView+AXChatMessage.h"
#import "UIFont+RT.h"
#import "HudTipsUtils.h"
#import "PPCPlanIdRequest.h"

@interface WaitingForPromotedViewController ()

@property (nonatomic, strong) UIButton *buttonSelect;  //选择按钮
@property (nonatomic, strong) UIButton *buttonPromote;  //推广按钮
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) NSMutableArray *cellSelectStatus;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *editPropertyId;//编辑和删除cell的房源Id
@property (nonatomic) NSInteger selectedCellCount;
@property (nonatomic) MBProgressHUD *loadingHud;


@property (nonatomic) BOOL isShowActivity;
@property (nonatomic) BOOL isSelectAll;

@end

@implementation WaitingForPromotedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"待推广房源"];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50) style:UITableViewStylePlain];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50 - 20) style:UITableViewStylePlain];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    self.tableView.rowHeight = 90;
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.isSelectAll = false;
    self.selectedCellCount = 0;
    [self.view addSubview:self.tableView];

}

- (void)showBottomView
{
 
    if (self.mutipleEditView != nil) {
        if (![self.view.subviews containsObject:self.mutipleEditView]) {
            [self.view addSubview:self.mutipleEditView];
        }
        return;
    }
    
    self.MutipleEditView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 49 -64, ScreenWidth, 49)];
    self.mutipleEditView.backgroundColor = [UIColor blackColor];
    self.mutipleEditView.alpha = 0.9;
    
    _buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonSelect.frame = CGRectMake(0, 0, ScreenWidth * 0.48, 49);
    [_buttonSelect addTarget:self action:@selector(selectAllProps:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake((56 - 22)/2, (50 - 22)/2, 22, 22)];
    selectImage.image = [UIImage imageNamed:@"broker_property_control_select_gray@2x.png"];
    [_buttonSelect addSubview:selectImage];
    self.selectImage = selectImage;
    
    UILabel *allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 10, 80, 40)];
    allSelectLabel.backgroundColor = [UIColor clearColor];
    allSelectLabel.font = [UIFont ajkH2Font];
    allSelectLabel.text = @"全选";
    allSelectLabel.textColor = [UIColor whiteColor];
    allSelectLabel.centerY = 50/2;
    allSelectLabel.left = selectImage.right + 5;
    [_buttonSelect addSubview:allSelectLabel];
    
    _buttonPromote = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonPromote.frame = CGRectMake(0, 12, 120, 33);
    _buttonPromote.right = ScreenWidth - 10;
    _buttonPromote.centerY = 50/2;
    _buttonPromote.titleLabel.font = [UIFont ajkH3Font];
    [self promotionButtonBackImage];
    [_buttonPromote setTitle:[NSString stringWithFormat:@"定价推广(%d)", self.selectedCellCount]  forState:UIControlStateNormal];
    [_buttonPromote addTarget:self action:@selector(clickFixPromotionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mutipleEditView addSubview:_buttonSelect];
    [self.mutipleEditView addSubview:_buttonPromote];
    
    [self.view addSubview:self.mutipleEditView];
}

- (void)viewDidAppear:(BOOL)animated
{
     [self loadDataWithActivityShow:YES];
}

- (void)loadDataWithActivityShow:(BOOL)isShowActivity
{
   self.isShowActivity = isShowActivity;
   [self clearStatus];
   [self requestDataWithBrokerId:[LoginManager getUserID] cityId:[LoginManager getCity_id]];
}

- (void)clearStatus
{
    self.isSelectAll = false;
    self.selectedCellCount = 0;
    self.selectImage.image = [UIImage imageNamed:@"broker_property_control_select_gray@2x.png"];
    [self updatePromotionButtonText];
}

- (void)requestDataWithBrokerId:(NSString *)brokerId cityId:(NSString *)cityId
{
    NSString *method = [[NSString alloc] init];
    if (self.isHaozu) {
        method = @"zufang/prop/noplanprops/";
    } else {
        method = @"anjuke/prop/noplanprops/";
    }
    
    NSDictionary *params = @{@"token":[LoginManager getToken],@"brokerId":brokerId,@"cityId":cityId};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleRequestData:)];
    if (self.isShowActivity) {
        self.isLoading = YES;
        self.loadingHud = [self showLoadingActivity:YES];
    }
}

- (void)handleRequestData:(RTNetworkResponse *)response
{
    if (self.isShowActivity) {
        self.isLoading = NO;
        [self hideLoadWithAnimated:YES];
    }
    if (![self checkNetworkAndErrorWithResponse:response]) {
        return;
    };
    NSArray *dataArray  = [self checkDataWithResponse:response];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:dataArray.count];
    for (int i = 0; i < dataArray.count; i++) {
        PropSelectStatusModel *selectStatusModel = [PropSelectStatusModel new];
        selectStatusModel.selectStatus = false;
        selectStatusModel.propId       = [dataArray[i] objectForKey:@"propId"];
        [arr addObject:selectStatusModel];
    }
    self.cellSelectStatus  = arr;
    self.dataSource        = [NSMutableArray arrayWithArray:dataArray];
    [self.tableView reloadData];
    
}

- (void)clickFixPromotionButton:(id)sender
{
    if (self.planId == nil || [self.planId isEqualToString:@""]) {
        
        [[PPCPlanIdRequest sharePlanIdRequest] getPricingPlanId:self.isHaozu returnInfo:^(NSString *planId, RequestStatus status) {
            
            if (status == RequestStatusForOk) {
                if (self.planId !=nil && ![self.planId isEqualToString:@""]) {
                    self.planId = planId;
                    [self fixPromotionRequestWithPlanId:planId];
                    DLog(@"get planId:%@",self.planId);
                } else {
                    [self displayHUDWithStatus:@"error" Message:@"定价计划不存在" ErrCode:@"1"];
                }
                
            } else if (status == RequestStatusForNetRemoteServerError){
                
                
            } else if (status == RequestStatusForNetWorkError) {
                
            }
            
        }];
        return ;
    }
    if (![self checkWithPlanIdandSelectCount]) {
        return;
    };
    [self fixPromotionRequestWithPlanId:self.planId];

}

- (void)fixPromotionRequestWithPlanId:(NSString *)planId
{
    if (self.selectedCellCount == 0) {
        [self showAlertViewWithTitle:@"请选择要推广的房源"];
        return ;
    }
    NSString *propIds    = @"";
    for (PropSelectStatusModel *selectStatusModel in self.cellSelectStatus) {
        if (selectStatusModel.selectStatus) {
            propIds = [propIds stringByAppendingFormat:@"%@,",selectStatusModel.propId];
        }
    }
    propIds = [propIds substringToIndex:propIds.length - 1];
    NSString *method = [[NSString alloc] init];
    if (self.isHaozu) {
        method = @"zufang/fix/addpropstoplan/";
    } else {
        method = @"anjuke/fix/addpropstoplan/";
    }
    NSDictionary *params = @{@"token":[LoginManager getToken], @"brokerId":[LoginManager  getUserID], @"planId":planId,@"propIds":propIds};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onFixPromotionRequestFinished:)];
    self.isLoading = YES;
    [self showLoadingActivity:YES];
    [self sendClickFixPromotionButtonLogWithPropIds:propIds];
}

- (void)onFixPromotionRequestFinished:(RTNetworkResponse *)response
{
    self.isLoading = NO;
    [self hideLoadWithAnimated:YES];
    if (![self checkNetworkAndErrorWithResponse:response]) {
        return;
    };
    if ([[response.content valueForKey:@"status"] isEqualToString:@"ok"]) {
         [self loadDataWithActivityShow:NO];
        [self displayHUDWithStatus:@"ok" Message:@"推广成功" ErrCode:nil];
    }
    
}
- (void)showAlertViewWithTitle:(NSString *)title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}
- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode
{
    [[HudTipsUtils sharedInstance] displayHUDWithStatus:status Message:message ErrCode:errCode toView:self.view];
}
#pragma mark - response check
- (BOOL)checkNetworkAndErrorWithResponse:(RTNetworkResponse *)response
{
    if (response.status == RTNetworkResponseStatusFailed) {
        [self displayHUDWithStatus:@"error" Message:@"无网络连接" ErrCode:response.content[@"errcode"]];
        return false;
    } else if ([[response.content valueForKey:@"status"] isEqualToString:@"error"]) {
        DLog(@"message:--->%@",[response.content valueForKey:@"message"]);
        [self displayHUDWithStatus:response.content[@"status"] Message:response.content[@"message"] ErrCode:@"1"];
        return false;
    }
    return true;
}

- (NSArray *)checkDataWithResponse:(RTNetworkResponse *)response
{
    NSArray *dataArray = [[response.content objectForKey:@"data"] objectForKey:@"propertyList"];
    if (dataArray == nil || [dataArray count] == 0) {
        [self showEmptyView];
    } else {
        [self showBottomView];
    }
    
    return dataArray;
}

- (void)checkDataSourceOnDelete
{
    if (self.dataSource == nil || [self.dataSource count] == 0) {
        [self showEmptyView];
    }
}

- (void)showEmptyView
{
    UIImageView *noResult = [[UIImageView alloc] initWithFrame:CGRectMake(104.0f, 210 - 80, 112.0f, 80.0f)];
    [noResult setImage:[UIImage imageNamed:@"pic_3.4_01.png"]];
    [self.view addSubview:noResult];
//    [self.view sendSubviewToBack:noResult];
    UILabel *noR  = [[UILabel alloc] initWithFrame:CGRectMake(0, 210 + 15, 200, 50)];
    noR.text      = @"暂无待推广房源";
    noR.textColor = [UIColor grayColor];
    [noR sizeToFit];
    noR.centerX   = self.view.centerX;
    [self.view addSubview:noR];
    [self.view bringSubviewToFront:self.loadingHud];
    [self.view bringSubviewToFront:[[HudTipsUtils sharedInstance] hud]];
    [self.mutipleEditView removeFromSuperview];
    self.mutipleEditView.hidden = YES;
}

- (BOOL)checkWithPlanIdandSelectCount
{
    if (self.selectedCellCount == 0) {
        [self showAlertViewWithTitle:@"请选择要推广的房源"];
        return false;
    }
    return true;
}

#pragma mark - cell选择处理

- (void)selectAllProps:(id)sender
{
    [self sendClickSelectAllButtonLog];
    self.selectedCellCount = 0;
    if (!self.isSelectAll) {
        self.selectImage.image = [UIImage imageNamed:@"broker_property_control_selected"];
        for (PropSelectStatusModel *statusModel in self.cellSelectStatus) {
            statusModel.selectStatus = true;
            self.selectedCellCount ++;
        }
    } else {
        self.selectImage.image = [UIImage imageNamed:@"broker_property_control_select_gray"];
        for (PropSelectStatusModel *statusModel in self.cellSelectStatus) {
            statusModel.selectStatus = false;
        }
    }
    self.isSelectAll = !self.isSelectAll;
    [self.tableView reloadData];
    [self updatePromotionButtonText];
    
}

#pragma mark - CellSelectStatusDelegate
- (void)cellStatusChanged:(BOOL)isSelect atRowIndex:(NSInteger)rowIndex
{
    if (isSelect) {
        self.selectedCellCount ++;
        if (self.selectedCellCount == [self.cellSelectStatus count]) {
            self.selectImage.image = [UIImage imageNamed:@"broker_property_control_selected"];
            self.isSelectAll = YES;
        }
    } else {
        self.selectedCellCount --;
        if (self.selectedCellCount != [self.cellSelectStatus count]) {
            self.selectImage.image = [UIImage imageNamed:@"broker_property_control_select_gray"];
            self.isSelectAll = NO;
        }
    }
    PropSelectStatusModel *statusModel = self.cellSelectStatus[rowIndex];
    statusModel.selectStatus = isSelect;
    [self updatePromotionButtonText];
    DLog(@"%@----%@",statusModel.propId,[self.dataSource[rowIndex] valueForKey:@"propId"]);

}

- (void)updatePromotionButtonText
{
    [self.buttonPromote setTitle:[NSString stringWithFormat:@"定价推广(%d)",self.selectedCellCount] forState:UIControlStateNormal];
    [self promotionButtonBackImage];
}

- (void)promotionButtonBackImage
{
    if (self.selectedCellCount == 0) {
        [_buttonPromote setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_little_blue_lost@2x.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    } else {
        [_buttonPromote setBackgroundImage:[[UIImage imageNamed:@"anjuke_icon_button_little_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"identifierCell";
    MultipleChoiceAndEditListCell *cell = (MultipleChoiceAndEditListCell *)[tableView dequeueReusableCellWithIdentifier:nil];

    NSArray *rightBtnarr = [NSArray array];
    rightBtnarr = [self rightButtons];
    if (cell == nil) {
        cell = [[MultipleChoiceAndEditListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:nil
                                                containingTableView:tableView
                                                 leftUtilityButtons:nil
                                                rightUtilityButtons:rightBtnarr];

        cell.cellSelectstatusDelegate = self;

    }
    PropSelectStatusModel *selectStatusModel = self.cellSelectStatus[indexPath.row];
    [cell changeCellSelectStatus:selectStatusModel.selectStatus];
    PropertyDetailCellModel *model = [[PropertyDetailCellModel alloc] initWithDataDic:[self.dataSource objectAtIndex:indexPath.row]];
    cell.propertyDetailTableViewCellModel   = model;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.rowIndex       = indexPath.row;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.delegate = self;
    cell.isHaozu = self.isHaozu;
    int sectionTotalRow = [self.dataSource count] -1;
    if (indexPath.row == sectionTotalRow) {
        [cell showBottonLineWithCellHeight:90 andOffsetX:0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int i = indexPath.row;
    NSDictionary *editCell = self.dataSource[i];
    self.editPropertyId = [editCell objectForKey:@"propId"];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PropertySingleViewController *propZF = [[PropertySingleViewController alloc] init];
    propZF.isHaozu = self.isHaozu;
    propZF.pageType = PAGE_TYPE_NO_PLAN;
    propZF.propId = self.editPropertyId;
    [self.navigationController pushViewController:propZF animated:YES];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray array];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor brokerLineColor] title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor brokerRedColor] title:@"删除"];
    return rightUtilityButtons;
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(MultipleChoiceAndEditListCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    self.editAndDeleteCellIndexPath = [self.tableView indexPathForCell:cell];
    int i = self.editAndDeleteCellIndexPath.row;
    NSDictionary *editCell = self.dataSource[i];
    self.editPropertyId = [editCell objectForKey:@"propId"];
    
    [self showLoadingActivity:YES];
    
    switch (index) {
        case 0:
        {
            //编辑房源
            [self hideLoadWithAnimated:YES];
            [self sendLeftEditLogAndPropId:self.editPropertyId];
            [cell hideUtilityButtonsAnimated:YES];
            [self editProperty];
            break;
        }
        case 1:
        {
            //删除房源
            [self hideLoadWithAnimated:YES];
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"您确认删除吗?"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确认", nil];
            [alertTest show];
            break;
        };

        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

//编辑房源
- (void)editProperty
{
    PropertyEditViewController *controller = [[PropertyEditViewController alloc] init];
    controller.isHaozu = self.isHaozu;
    controller.propertyID = [self.dataSource objectAtIndex:self.editAndDeleteCellIndexPath.row][@"propId"];
    controller.backType = RTSelectorBackTypeDismiss;
    RTGestureBackNavigationController *nav = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self sendLeftDeleteLogAndPropId:self.editPropertyId];
        [self doDeleteProperty:self.editPropertyId];
    }
}

//删除房源
- (void)doDeleteProperty:(NSString *)propertyID
{
    self.isLoading = YES;
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        self.isLoading = NO;
        return;
    }
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;

    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", propertyID, @"propIds", nil];
    if (self.isHaozu) {
        method = @"zufang/prop/delprops/";
    } else {
        method = @"anjuke/prop/delprops/";
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onDeletePropFinished:)];
    self.isLoading = YES;
    [self showLoadingActivity:YES];
    [self performSelector:@selector(doBack:) withObject:nil afterDelay:3.0];
}

- (void)onDeletePropFinished:(RTNetworkResponse *)response {
    DLog(@"--delete Prop。。。response [%@]", [response content]);
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    if([[response content] count] == 0){
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
    }

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"网络不畅" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];

        //        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        return;
    }
    
    [self.dataSource removeObjectAtIndex:self.editAndDeleteCellIndexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[self.editAndDeleteCellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    PropSelectStatusModel *model = [self.cellSelectStatus objectAtIndex:self.editAndDeleteCellIndexPath.row];
    if (model.selectStatus) {
        self.selectedCellCount --;
        [self updatePromotionButtonText];
    }
    [self.cellSelectStatus removeObjectAtIndex:self.editAndDeleteCellIndexPath.row];
    [self checkDataSourceOnDelete];
    [self.tableView reloadData];
    [[HUDNews sharedHUDNEWS] createHUD:@"删除房源成功" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNORMALOK];
}

#pragma mark - Log

#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(MultipleChoiceAndEditListCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 2:{
            NSLog(@"right utility buttons open");
            self.editAndDeleteCellIndexPath = [self.tableView indexPathForCell:cell];
            int i = self.editAndDeleteCellIndexPath.row;
            NSDictionary *editCell = self.dataSource[i];
            self.editPropertyId = [editCell objectForKey:@"propId"];
            [self sendLeftSwipLogAndPropId:self.editPropertyId];
        }
            break;
        default:
            break;
    }
}

- (void)sendLeftSwipLogAndPropId:(NSString *)propId
{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DT_LIST_LEFT page:ZF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DT_LIST_LEFT page:ESF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
    }
}

-(void)sendAppearLog
{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DT_LIST_ONVIEW page:ZF_DT_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DT_LIST_ONVIEW page:ESF_DT_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
    
}

-(void)sendClickSelectAllButtonLog
{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DT_LIST_CLICK_SELECTALL page:ZF_DT_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DT_LIST_CLICK_SELECTALL page:ESF_DT_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
    
}

- (void)sendClickFixPromotionButtonLogWithPropIds:(NSString *)propIds
{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DT_LIST_CLICK_DJTG page:ZF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime],@"prop_ids":propIds}];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DT_LIST_CLICK_DJTG page:ESF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime],@"prop_ids":propIds}];
    }
}

- (void)sendLeftEditLogAndPropId:(NSString *)propId
{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DT_LIST_LEFT_EDIT page:ZF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DT_LIST_LEFT_EDIT page:ESF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
    }
}

- (void)sendLeftDeleteLogAndPropId:(NSString *)propId
{
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_DT_LIST_LEFT_DELETE page:ZF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_DT_LIST_LEFT_DELETE page:ESF_DT_LIST_PAGE note:@{@"ot":[Util_TEXT logTime], @"propId":propId}];
    }
}

- (void)doBack:(id)sender
{
    [super doBack:sender];
    [self hideLoadWithAnimated:YES];
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:ZF_WTG_LIST_BACK page:ZF_WTG_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    } else {
        [[BrokerLogger sharedInstance] logWithActionCode:ESF_WTG_LIST_BACK page:ESF_DT_LIST_PAGE note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
    
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
