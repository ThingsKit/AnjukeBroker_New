//
//  HZWaitingForPromotedViewController.m
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "HZWaitingForPromotedViewController.h"
#import "PropSelectStatusModel.h"
#import "PropertyDetailTableViewCellModel.h"
#import "MutipleEditTableViewCell.h"

@interface HZWaitingForPromotedViewController ()

@property (nonatomic, strong) UIButton *buttonSelect;  //编辑按钮
@property (nonatomic, strong) UIButton *buttonPromote;  //删除按钮
@property (nonatomic, strong) UIImageView *selectImage;
@property (nonatomic, strong) NSMutableDictionary *cellSelectStatus;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) NSInteger selectedCellCount;

@property (nonatomic) BOOL isSelectAll;

@end

@implementation HZWaitingForPromotedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"租房待推广房源"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.MutipleEditView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 49 -64, ScreenWidth, 49)];
    
    self.MutipleEditView.backgroundColor = [UIColor brokerBlackColor];
    self.MutipleEditView.alpha = 0.7;
    
    self.isSelectAll = false;
    self.selectedCellCount = 0;
    
    _buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonSelect.frame = CGRectMake(0, 0, ScreenWidth * 0.48, 49);
    [_buttonSelect addTarget:self action:@selector(selectAllProps:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake((56 - 22)/2, (50 - 22)/2, 22, 22)];
    [selectImage setImage:[UIImage imageNamed:@"broker_property_control_select_gray@2x.png"]];
    [_buttonSelect addSubview:selectImage];
    self.selectImage = selectImage;
    
    UILabel *allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 10, 80, 40)];
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
    [_buttonPromote setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_button_little_blue@2x.png"] forState:UIControlStateNormal];
    [_buttonPromote setTitle:[NSString stringWithFormat:@"定价推广(%@)", @"6"]  forState:UIControlStateNormal];
    
    [self.MutipleEditView addSubview:_buttonSelect];
    [self.MutipleEditView addSubview:_buttonPromote];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.MutipleEditView];
    [self requestDataWithBrokerId:@"858573" cityId:@"11"];
}

- (void)requestDataWithBrokerId:(NSString *)brokerId cityId:(NSString *)cityId
{
    NSString     *method = @"anjuke/prop/noplanprops/";
    NSDictionary *params = @{@"token":[LoginManager getToken],@"brokerId":brokerId,@"cityId":cityId,@"is_nocheck":@"1"};
    [[RTRequestProxy sharedInstance]asyncRESTGetWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(handleRequestData:)];
}

- (void)handleRequestData:(RTNetworkResponse *)response
{
    NSArray *dataArray       = [[response.content objectForKey:@"data"] objectForKey:@"propertyList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (int i = 0; i < dataArray.count; i++) {
        PropSelectStatusModel *selectStatusModel = [PropSelectStatusModel new];
        selectStatusModel.selectStatus = false;
        selectStatusModel.propId       = [dataArray[i] objectForKey:@"propId"];
        [dic setValue:selectStatusModel forKey:[NSString stringWithFormat:@"%d",i]];
    }
    self.cellSelectStatus = dic;
    self.dataSource        = dataArray;
    [self.tableView reloadData];
    
}

#pragma mark - cell选择处理

- (void)selectAllProps:(id)sender
{
    self.selectedCellCount = 0;
    if (!self.isSelectAll) {
        self.isSelectAll = true;
        self.selectImage.image = [UIImage imageNamed:@"broker_property_control_selected"];
        for (NSString * key in self.cellSelectStatus.allKeys) {
            [self changeCellStatusForCellSelectStatusKey:key selectStatus:true];
            self.selectedCellCount ++;
        }
        
    } else {
        self.isSelectAll = false;
        self.selectImage.image = [UIImage imageNamed:@"broker_property_control_select_gray"];
        for (NSString * key in self.cellSelectStatus.allKeys) {
            [self changeCellStatusForCellSelectStatusKey:key selectStatus:false];
        }
    }
    [self.tableView reloadData];
    [self updatePromotionButtonText];
}

- (void)cellStatusChanged:(BOOL)isSelect atRowIndex:(NSInteger)rowIndex
{
    if (isSelect) {
        self.selectedCellCount ++;
    } else {
        self.selectedCellCount --;
        if (self.isSelectAll) {
           self.selectImage.image = [UIImage imageNamed:@"broker_property_control_select_gray"];
        }
    }
    [self changeCellStatusForCellSelectStatusKey:[NSString stringWithFormat:@"%d",rowIndex] selectStatus:isSelect];
    [self updatePromotionButtonText];
}

- (void)changeCellStatusForCellSelectStatusKey:(NSString *)key selectStatus:(BOOL)selectStatus
{
    PropSelectStatusModel *selectStatusModel = [self.cellSelectStatus valueForKey:key];
    selectStatusModel.selectStatus = selectStatus;
}

- (void)updatePromotionButtonText
{
    [self.buttonPromote setTitle:[NSString stringWithFormat:@"定价推广(%d)",self.selectedCellCount] forState:UIControlStateNormal];
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
    static NSString *identifier = @"identifierCell";
    MutipleEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MutipleEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierCell"];
    }
    PropSelectStatusModel *selectStatusModel = [self.cellSelectStatus valueForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    [cell changeCellSelectStatus:selectStatusModel.selectStatus];
    PropertyDetailTableViewCellModel *model = [[PropertyDetailTableViewCellModel alloc] initWithDataDic:[self.dataSource objectAtIndex:indexPath.row]];
    cell.propertyDetailTableViewCellModel   = model;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.delegate       = self;
    cell.rowIndex       = indexPath.row;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.textLabel.text = @"test";
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    MultipleChoiceAndEditListCell *oldCell = (MultipleChoiceAndEditListCell *)[tableView cellForRowAtIndexPath:indexPath];
    

}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"More"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)sw_addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self addObject:button];
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(MutipleEditTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(MutipleEditTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
            [alertTest show];
            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
//            [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(MutipleEditTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(MutipleEditTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}


@end
