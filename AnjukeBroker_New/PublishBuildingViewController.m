//
//  PublishBuildingViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBuildingViewController.h"
#import "AnjukeEditableCell.h"

@interface PublishBuildingViewController ()

@property int selectedIndex; //记录当前点选的row对应的cellDataSource对应的indexTag
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘

@property int selectedSection;
@property int selectedRow; //记录选中的cell所在section和row，便于更改tableview的frame和位置

@end

@implementation PublishBuildingViewController
@synthesize isHaozu;
@synthesize tableViewList;
@synthesize cellDataSource;
@synthesize selectedIndex;
@synthesize pickerView;
@synthesize toolBar;
@synthesize inputingTextF;
@synthesize selectedRow, selectedSection;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.tableViewList.delegate = nil;
    self.cellDataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *titleStr = @"发布二手房";
    if (self.isHaozu) {
        titleStr = @"发布租房";
    }
    [self setTitleViewWithString:titleStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    
}

- (void)initDisplay {
    //init main sv
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    tv.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    tv.delegate = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewList = tv;
    [self.view addSubview:tv];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 30)];
    headerView.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    [self.tableViewList setTableHeaderView:headerView];
    
    [self initCellDataSource];
}

- (void)initCellDataSource {
    PublishTableViewDataSource *pd = [[PublishTableViewDataSource alloc] init];
    self.cellDataSource = pd;
    self.tableViewList.dataSource = pd;
    [pd setSuperViewController:self];
    [pd createCells:[PublishDataModel getPropertyTitleArrayForHaozu:self.isHaozu] isHaozu:self.isHaozu];
    
    [self.tableViewList reloadData];
    
}

#pragma mark - Input Method 

//**根据当前输入焦点行移动tableView显示
- (void)tableViewStyleChangeForInput:(BOOL)isInput {
    if (isInput) { //输入状态，tableView缩起
        [self.tableViewList setFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight] - self.pickerView.frame.size.height - self.toolBar.frame.size.height)];
        
        [self.tableViewList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:self.selectedSection] atScrollPosition:UITableViewScrollPositionMiddle animated:NO]; //animated
    }
    else { //收起键盘，tableView还原
        [self.tableViewList setFrame:FRAME_WITH_NAV];
        [self.tableViewList setContentOffset:CGPointMake(0, 0)];
    }
}

- (int)transformIndexWithIndexPath:(NSIndexPath *)indexPath { //将indexPath转换为cellDataSource对应的cell的indexTag
    int index = 0;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    index = 0;
                    break;
                case 1:
                    index = 1;
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    index = 2;
                    break;
                case 1:
                    index = 3;
                    break;
                case 2:
                    index = 4;
                    break;
                case 3:
                    index = 5;
                    break;

                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0: {
                    index = 5;
                    if (self.isHaozu) {
                        index +=1;
                    }
                }
                    break;
                case 1: {
                    index = 6;
                    if (self.isHaozu) {
                        index +=1;
                    }
                }
                    break;
                    
                default:{
                    
                }
                    break;
            }
        }
            break;
  
        default:
            break;
    }
    
    DLog(@"当前的cell index 【%d】", index);
    return index;
}

- (void)showInputWithIndex:(int)index isPicker:(BOOL)isPicker {
    self.inputingTextF = [(AnjukeEditableCell *)[[self.cellDataSource inputCellArray] objectAtIndex:index] text_Field];
    
    //初始化滚轮和键盘控制条
    if (!self.pickerView) {
        self.pickerView = [[RTInputPickerView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - RT_PICKERVIEW_H - 0, [self windowWidth], RT_PICKERVIEW_H)];
    }
    
    if ((!self.toolBar)) {
        self.toolBar = [[KeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], NAV_BAT_H)];
        self.toolBar.clickDelagate = self;
    }
    
    if (isPicker) { //滚轮输入
        //弹出滚轮
        self.inputingTextF.inputAccessoryView = self.toolBar;
        self.inputingTextF.inputView = self.pickerView;
        
    }
    else { //键盘输入
        //弹出键盘
        self.inputingTextF.inputAccessoryView = self.toolBar;
        self.inputingTextF.inputView = nil;
        self.inputingTextF.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    
    [self tableViewStyleChangeForInput:YES];
    [self.inputingTextF becomeFirstResponder];
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellDataSource heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.cellDataSource heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self.cellDataSource heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.cellDataSource viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self.cellDataSource viewForFooterInSection:section];
}

//******点击******

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = [self transformIndexWithIndexPath:indexPath];
    self.selectedSection = indexPath.section;
    self.selectedRow = indexPath.row;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: //价格
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:NO];
                }
                    break;
                case 1: //面积
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:NO];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0: //房型
                {
                    
                }
                    break;
                case 1: //装修
                {
                    
                }
                    break;
                case 2: //楼层
                {
                    
                }
                    break;
                case 3: //出租方式（仅好租）
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BrokerPickerDelegate

- (void)finishBtnClicked { //点击完成，输入框组件消失
    
    //收起键盘，还原tableView
    [self.inputingTextF resignFirstResponder];
    [self tableViewStyleChangeForInput:NO];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    
}

- (BOOL)isInputOK {
    BOOL isOkay = YES;
    
    return isOkay;
}

@end
