//
//  PublishBuildingViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBuildingViewController.h"
#import "AppManager.h"
#import "PublishInputOrderModel.h"
#import "AnjukeNormalCell.h"

@interface PublishBuildingViewController ()

@property int selectedIndex; //记录当前点选的row对应的cellDataSource对应的indexTag
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘

@property int selectedSection;
@property int selectedRow; //记录选中的cell所在section和row，便于更改tableview的frame和位置

@property (nonatomic, copy) NSString *lastPrice; //记录上一次的价格输入，用于判断是否需要
@property (nonatomic, copy) NSString *propertyPrice; //房源定价价格

@property BOOL needFileNO; //是否需要备案号，部分城市需要备案号（北京）

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
@synthesize isTBBtnPressedToShowKeyboard;
@synthesize property;
@synthesize lastPrice, propertyPrice;
@synthesize needFileNO;
@synthesize communityDic;

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
    
    DLog(@"dealloc PublishBuildingViewController");
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
    
    [self addRightButton:@"保存" andPossibleTitle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    self.property = [PublishDataModel getNewPropertyObject];
    
    self.lastPrice = [NSString string];
    self.propertyPrice = [NSString string];
}

- (void)initDisplay {
    //init main sv
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    tv.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    tv.delegate = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewList = tv;
    [self.view addSubview:tv];
    
    [self drawHeader];
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

- (void)drawHeader {
    self.needFileNO = [LoginManager needFileNOWithCityID:[LoginManager getCity_id]];
    
    UIView *headerView = [[UIView alloc] init];
    if (self.needFileNO && self.isHaozu == NO) { //仅二手房发房（北京）需要备案号
        headerView.frame = CGRectMake(0, 0, [self windowWidth], CELL_HEIGHT+PUBLISH_SECTION_HEIGHT+CELL_HEIGHT);
    }
    else
        headerView.frame = CGRectMake(0, 0, [self windowWidth], CELL_HEIGHT+PUBLISH_SECTION_HEIGHT);
    headerView.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    [self.tableViewList setTableHeaderView:headerView];
    
    //小区
    UIView *comView = [[UIView alloc] initWithFrame:CGRectMake(0, PUBLISH_SECTION_HEIGHT, [self windowWidth], CELL_HEIGHT)];
    comView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:comView];
    
    UILabel *comTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, (comView.frame.size.height - 20)/2, 100, 20)];
    comTitleLb.backgroundColor = [UIColor clearColor];
    comTitleLb.text = @"小区";
    comTitleLb.textColor = SYSTEM_DARK_GRAY;
    comTitleLb.font = [UIFont systemFontOfSize:17];
    [comView addSubview:comTitleLb];
    
    UILabel *comDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(224/2, (comView.frame.size.height - 20)/2, 150, 20)];
    comDetailLb.backgroundColor = [UIColor clearColor];
    comDetailLb.textColor = SYSTEM_BLACK;
    comDetailLb.font = [UIFont systemFontOfSize:17];
    [comView addSubview:comDetailLb];
    
    [self communityDataSet:comDetailLb];
}

#pragma mark - Private Method

- (void)rightButtonAction:(id)sender {
    [self doSave];
}

- (void)doSave {
    if (![self checkUploadProperty]) {
        return;
    }
    
    if ([self.lastPrice isEqualToString:self.property.price]) { //价格未变，无需重心请求
        [self showAlertViewWithPrice:self.propertyPrice];
    }
    else {
        self.lastPrice = [NSString stringWithString:self.property.price];
//        [self requestWithPrice];
    }
}

- (void)showAlertViewWithPrice:(NSString *)price {
    NSString *title = nil;
    if (price.length == 0 || price == nil) {
        title = [NSString stringWithFormat:@"定价：暂无"];
    }
    else
        title = [NSString stringWithFormat:@"定价：%@元/次",price];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"定价推广", @"定价且竞价推广", @"暂不推广", nil];
    sheet.tag = PUBLISH_ACTIONSHEET_TAG;
    [sheet showInView:self.view];
}

- (void)doBack:(id)sender {
    //test
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)communityDataSet:(UILabel *)comLabel {
    
    NSString *name = [NSString string];
    NSString *idStr = [NSString string];
    
    if (self.isHaozu) {
        name = [self.communityDic objectForKey:@"commName"];
        idStr = [self.communityDic objectForKey:@"commId"];
    }
    else {
        name = [self.communityDic objectForKey:@"commName"];
        idStr = [self.communityDic objectForKey:@"commId"];
    }
    
    [self.property setComm_id:idStr];
    comLabel.text = name;
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
        [self.tableViewList setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)pickerDisappear {
    [self textFieldAllResign];
    [self tableViewStyleChangeForInput:NO];
    
    self.isTBBtnPressedToShowKeyboard = NO;
}

- (void)textFieldAllResign { //全部收起键盘
    [self.inputingTextF resignFirstResponder];
//    [self.fileNoTextF resignFirstResponder];
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
    
    DLog(@"点击TableView得到的selectIndex - [%d]", index);
    
    return index;
}

- (int)getCellIndexWithClickTextField:(UITextField *)tf {
    self.inputingTextF = tf;
    
    AnjukeEditableCell *cell = nil;
    if ([AppManager isIOS6]) {
        cell = (AnjukeEditableCell *)[[tf superview] superview];
    }
    else
        cell = (AnjukeEditableCell *)[[[tf superview] superview] superview];
    
    //记录点击的TextField所在的cell的indexPath
    self.selectedSection = [[self.tableViewList indexPathForCell:cell] section];
    self.selectedRow = [[self.tableViewList indexPathForCell:cell] row];
    
    //将indexPath转换为对应的index
    int index = [self transformIndexWithIndexPath:[self.tableViewList indexPathForCell:cell]];
    
    DLog(@"点击TextField得到的selectIndex - [%d]", index);
    
    return index;
}

- (void)showInputWithIndex:(int)index isPicker:(BOOL)isPicker {
    if ([[[self.cellDataSource inputCellArray] objectAtIndex:index] isKindOfClass:[AnjukeNormalCell class]]) {
        return; //避免crash
    }
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
        
        //重置pickerView数据
        [self.pickerView reloadPublishPickerWithIndex:self.selectedIndex isHaozu:self.isHaozu];
        
        //聚焦上一次的输入
        int pickerIndex1 = [(AnjukeEditableCell *)[[self.cellDataSource inputCellArray] objectAtIndex:index] inputed_RowAtCom0];
        int pickerIndex2 = [(AnjukeEditableCell *)[[self.cellDataSource inputCellArray] objectAtIndex:index] inputed_RowAtCom1];
        int pickerIndex3 = [(AnjukeEditableCell *)[[self.cellDataSource inputCellArray] objectAtIndex:index] inputed_RowAtCom2];
        
        [self.pickerView pickerScrollToRowAtIndex:pickerIndex1 atCom:0];
        [self.pickerView pickerScrollToRowAtIndex:pickerIndex2 atCom:1];
        [self.pickerView pickerScrollToRowAtIndex:pickerIndex3 atCom:2];
        
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

- (NSMutableString *)getInputStringAndSetProperty {
    NSMutableString *string = [NSMutableString string]; //显示用string
    NSMutableString * idStr = [NSMutableString string]; //上传用string（id）
    
    NSString *strValue1 = [NSString string];
    NSString *strValue2 = [NSString string];
    NSString *strValue3 = [NSString string];
    
    int index1 = [self.pickerView selectedRowInComponent:0];
    NSString *string1 = [[[self.pickerView firstArray] objectAtIndex:index1] objectForKey:@"Title"];
    [string appendString:string1];
    strValue1 = [[[self.pickerView firstArray] objectAtIndex:index1] objectForKey:@"Value"];
    
    //记录此次输入的数据所在row，方便下一次输入时聚焦
    [(AnjukeEditableCell *)[[self.cellDataSource inputCellArray] objectAtIndex:self.selectedIndex] setInputed_RowAtCom0:index1];
    
    if ([self.pickerView.secondArray count] > 0) {
        int index2 = [self.pickerView selectedRowInComponent:1];
        NSString *string2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Title"];
        [string appendString:string2];
        
        strValue2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Value"];
        
        [(AnjukeEditableCell *)[[self.cellDataSource inputCellArray] objectAtIndex:self.selectedIndex] setInputed_RowAtCom1:index2];
    }
    
    if ([self.pickerView.thirdArray count] > 0) {
        int index3 = [self.pickerView selectedRowInComponent:2];
        NSString *string3 = [[[self.pickerView thirdArray] objectAtIndex:index3] objectForKey:@"Title"];
        [string appendString:string3];
        
        strValue3 = [[[self.pickerView thirdArray] objectAtIndex:index3] objectForKey:@"Value"];
        
        [(AnjukeEditableCell *)[[self.cellDataSource inputCellArray] objectAtIndex:self.selectedIndex] setInputed_RowAtCom2:index3];
    }

    //顺便写入传参数值。。。以后优化代码
    if (self.isHaozu) {
        switch (self.selectedIndex) { //二手房
            case HZ_PICKER_FLOORS: //楼层
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                self.property.floor = idStr;
            }
                break;
            case HZ_PICKER_FITMENT: //装修
            {
                [idStr appendString:strValue1];
                self.property.fitment = idStr;
            }
                break;
            case HZ_PICKER_RENTTYPE: //出租方式
            {
                [idStr appendString:strValue1];
                self.property.rentType = idStr;
            }
                break;
            default:
                break;
        }
    }
    else {
        switch (self.selectedIndex) { //二手房
            case AJK_PICKER_FLOORS: //楼层
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                self.property.floor = idStr;
            }
                break;
            case AJK_PICKER_FITMENT: //装修
            {
                [idStr appendString:strValue1];
                self.property.fitment = idStr;
            }
                break;
            default:
                break;
        }
    }
    
    return string;
}

- (BOOL)checkUploadProperty {
    [self setTextFieldForProperty];
    
    return YES;
}

//将输入框内内容赋值到property中
- (void)setTextFieldForProperty {
    if (self.isHaozu) {
        self.property.area = [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_TEXT_AREA] text_Field] text];
        
        NSInteger price = [[[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_TEXT_PRICE] text_Field] text] intValue];
        self.property.price = [NSString stringWithFormat:@"%d", price];
    }
    else { //二手房
        self.property.area = [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_TEXT_AREA] text_Field] text];
        
        NSInteger price = [[[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_TEXT_PRICE] text_Field] text] intValue] * 10000;
        self.property.price = [NSString stringWithFormat:@"%d", price];
    }
    DLog(@"房源上传数据:[%@]", self.property);
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
                case 1: //楼层
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:YES];
                }
                    break;
                case 2: //装修
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:YES];
                }
                    break;
                case 3: //出租方式（仅好租）
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0: //title
                {
                    
                }
                    break;
                case 1: //desc
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BrokerPickerDelegate

- (void)finishBtnClicked { //点击完成，输入框组件消失
    self.isTBBtnPressedToShowKeyboard = NO;
    
    if (![self isInputOK]) {
        return;
    }
    
    if (self.selectedSection == 1) { //滚轮输入范围
        self.inputingTextF.text = [self getInputStringAndSetProperty];
    }
    
    //收起键盘，还原tableView
    [self pickerDisappear];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    self.isTBBtnPressedToShowKeyboard = YES;

    if (![self isInputOK]) {
        return;
    }
    
    if (self.selectedSection == 1) { //滚轮输入范围
        self.inputingTextF.text = [self getInputStringAndSetProperty];
    }

    BOOL isPicker = NO;
    
    //向下跳转，selectIndex+1，section和row根据跳转的位置向下递增
    if (self.isHaozu) {
        switch (self.selectedIndex) {
            case HZ_TEXT_PRICE:
            {
                return; //不做处理
            }
                break;
            case HZ_TEXT_AREA:
            {
                self.selectedIndex --;
                self.selectedRow = 0;
                self.selectedSection = 0;
            }
                break;
            case HZ_PICKER_FLOORS: //楼层
            {
                self.selectedIndex -=2;
                self.selectedRow = 1;
                self.selectedSection = 0;
            }
                break;
            case HZ_PICKER_FITMENT: //装修
            {
                self.selectedIndex --;
                isPicker = YES;
                self.selectedRow = 1;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_RENTTYPE: //出租方式
            {
                self.selectedIndex --;
                isPicker = YES;
                self.selectedRow = 2;
                self.selectedSection = 1;
            }
                break;
                
            default:
                break;
        }
    }
    else {
        switch (self.selectedIndex) {
            case AJK_TEXT_PRICE:
            {
                return; //不做处理
            }
                break;
            case AJK_TEXT_AREA:
            {
                self.selectedIndex --;
                self.selectedRow = 0;
                self.selectedSection = 0;
            }
                break;
            case AJK_PICKER_FLOORS: //楼层
            {
                self.selectedIndex -=2;
                self.selectedRow = 1;
                self.selectedSection = 0;
            }
                break;
            case AJK_PICKER_FITMENT: //装修
            {
                self.selectedIndex --;
                isPicker = YES;
                self.selectedRow = 1;
                self.selectedSection = 1;
            }
                break;
                
            default:
                break;
        }
    }
    
    [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
    
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    self.isTBBtnPressedToShowKeyboard = YES;
    
    if (![self isInputOK]) {
        return;
    }
    
    if (self.selectedSection == 1) { //滚轮输入范围
        self.inputingTextF.text = [self getInputStringAndSetProperty];
    }
    
    BOOL isPicker = NO;

    //向下跳转，selectIndex+1，section和row根据跳转的位置向下递增
    if (self.isHaozu) {
        switch (self.selectedIndex) {
            case HZ_TEXT_PRICE:
            {
                self.selectedIndex ++;
                self.selectedRow = 1;
                self.selectedSection = 0;
            }
                break;
            case HZ_TEXT_AREA:
            {
                self.selectedIndex +=2;
                isPicker = YES;
                self.selectedRow = 1;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_FLOORS: //楼层
            {
                self.selectedIndex ++;
                isPicker = YES;
                self.selectedRow = 2;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_FITMENT: //装修
            {
                self.selectedIndex ++;
                isPicker = YES;
                self.selectedRow = 3;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_RENTTYPE: //出租方式
            {
                return; //不做处理
            }
                break;

            default:
                break;
        }
    }
    else {
        switch (self.selectedIndex) {
            case AJK_TEXT_PRICE:
            {
                self.selectedIndex ++;
                self.selectedRow = 1;
                self.selectedSection = 0;
            }
                break;
            case AJK_TEXT_AREA:
            {
                self.selectedIndex +=2;
                isPicker = YES;
                self.selectedRow = 1;
                self.selectedSection = 1;
            }
                break;
            case AJK_PICKER_FLOORS: //楼层
            {
                self.selectedIndex ++;
                isPicker = YES;
                self.selectedRow = 2;
                self.selectedSection = 1;
            }
                break;
            case AJK_PICKER_FITMENT: //装修
            {
                return; //不做处理
            }
                break;
            
            default:
                break;
        }
    }
    
    [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
    
}

- (BOOL)isInputOK {
    BOOL isOkay = YES;
    
    return isOkay;
}

#pragma mark - CellTextFieldEditDelegate

- (void)textFieldBeginEdit:(UITextField *)textField {
    if (self.isTBBtnPressedToShowKeyboard) {
        self.isTBBtnPressedToShowKeyboard = NO; //锁还原
    }
    else {
        self.selectedIndex = [self getCellIndexWithClickTextField:textField];
        
        BOOL isPicker = NO;
        if (self.selectedSection == 1) {
            isPicker = YES;
        }
        [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
        
    }
}

- (void)textFieldDidEndEdit:(NSString *)text { //暂不可用
    
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == IMAGE_ACTIONSHEET_TAG) {
        
    }
    else if (actionSheet.tag == PUBLISH_ACTIONSHEET_TAG) {
        switch (buttonIndex) {
            case 0: //定价
            {
                
            }
                break;
            case 1: //定价+竞价
            {
                
            }
                break;
            case 2: //暂不推广
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
