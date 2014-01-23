//
//  PublishHouseTypeViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishHouseTypeViewController.h"
#import "PublishDataModel.h"
#import "AnjukeEditableCell.h"
#import "Property.h"
#import "Util_UI.h"
#import "PublishBuildingViewController.h"

#define SELECT_BTN_TAG 1000

@interface PublishHouseTypeViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableViewList;
@property int selectedIndex; //记录当前点选的row对应的cellDataSource对应的indexTag
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘

@property (nonatomic, strong) UITextField *houseTypeTF;
@property (nonatomic, strong) UITextField *exposureTF;
@property (nonatomic, strong) UITextField *inputingTF;

@property int houseType_inputedRow0;
@property int houseType_inputedRow1;
@property int houseType_inputedRow2;

@property int exposure_inputedRow0;
@property int exposure_inputedRow1;
@property int exposure_inputedRow2;

@property (nonatomic, copy) NSString *lastRooms;
@property (nonatomic, copy) NSString *lastExposure;

@end

@implementation PublishHouseTypeViewController
@synthesize isHaozu;
@synthesize dataArray;
@synthesize tableViewList;
@synthesize houseTypeTF, exposureTF;
@synthesize inputingTextF;
@synthesize houseType_inputedRow0, houseType_inputedRow1, houseType_inputedRow2;
@synthesize exposure_inputedRow0, exposure_inputedRow1, exposure_inputedRow2;
@synthesize superViewController;
@synthesize property;
@synthesize lastExposure, lastRooms;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    
    DLog(@"dealloc PublishHouseTypeViewController");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    
    [self setTitleViewWithString:@"房型"];
    [self addRightButton:@"保存" andPossibleTitle:nil];
    
    self.lastRooms = self.property.rooms;
    self.lastExposure = self.property.exposure;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    self.dataArray = [NSMutableArray array];
    
    self.lastRooms = [NSString string];
    self.lastExposure = [NSString string];
}

- (void)initDisplay {
    
    for (int i = 0; i < 2; i ++) {
        //小区
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, i * CELL_HEIGHT, [self windowWidth], CELL_HEIGHT);
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(buttonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            btn.tag = SELECT_BTN_TAG+0;
        }
        else {
            btn.tag = SELECT_BTN_TAG+1;
        }
        [self.view addSubview:btn];
        
        UILabel *comTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, (btn.frame.size.height - 20)/2, 100, 20)];
        comTitleLb.backgroundColor = [UIColor clearColor];
        if (i == 0) {
            comTitleLb.text = @"户型";
        }
        else
            comTitleLb.text = @"朝南";
        comTitleLb.textColor = SYSTEM_DARK_GRAY;
        comTitleLb.font = [UIFont systemFontOfSize:17];
        [btn addSubview:comTitleLb];
        
        //text field
        UITextField *cellTextField = nil;
        cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(224/2, 1,  150, CELL_HEIGHT - 1*5)];
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.backgroundColor = [UIColor clearColor];
        cellTextField.borderStyle = UITextBorderStyleNone;
        cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cellTextField.text = @"";
        cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cellTextField.placeholder = @"";
        cellTextField.delegate = self;
        cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        cellTextField.font = [UIFont systemFontOfSize:17];
        cellTextField.secureTextEntry = NO;
        cellTextField.textColor = SYSTEM_BLACK;
        cellTextField.delegate = self;
        if (i == 0) {
            self.houseTypeTF = cellTextField;
        }
        else {
            self.exposureTF = cellTextField;
        }
        [btn addSubview:cellTextField];
    }
}

#pragma mark - Private Method

- (void)buttonDidSelect:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag - SELECT_BTN_TAG;
    BOOL isHouseType = NO;
    
    self.selectedIndex = index;
    
    if (index == INDEX_HOUSETYPE) {
        //户型
        self.inputingTextF = self.houseTypeTF;
        isHouseType = YES;
    }
    else { //朝向
        self.inputingTextF = self.exposureTF;
    }
    
    [self showPicker:isHouseType];
}

- (void)pickerDisappear {
    [self.inputingTextF resignFirstResponder];
}

- (void)showPicker:(BOOL)isHouseType {
    //初始化滚轮和键盘控制条
    if (!self.pickerView) {
        self.pickerView = [[RTInputPickerView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - RT_PICKERVIEW_H - 0, [self windowWidth], RT_PICKERVIEW_H)];
    }
    
    if ((!self.toolBar)) {
        self.toolBar = [[KeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], NAV_BAT_H)];
        self.toolBar.clickDelagate = self;
    }
    
    //弹出滚轮
    self.inputingTextF.inputAccessoryView = self.toolBar;
    self.inputingTextF.inputView = self.pickerView;
    
    //重置pickerView数据
    [self.pickerView reloadHouseTypePickerWithType:isHouseType isHaozu:self.isHaozu];
    
    if (isHouseType) {
        [self.pickerView pickerScrollToRowAtIndex:self.houseType_inputedRow0 atCom:0];
        [self.pickerView pickerScrollToRowAtIndex:self.houseType_inputedRow1 atCom:1];
        [self.pickerView pickerScrollToRowAtIndex:self.houseType_inputedRow2 atCom:2];
    }
    else {
        [self.pickerView pickerScrollToRowAtIndex:self.exposure_inputedRow0 atCom:0];
        [self.pickerView pickerScrollToRowAtIndex:self.exposure_inputedRow1 atCom:1];
        [self.pickerView pickerScrollToRowAtIndex:self.exposure_inputedRow2 atCom:2];
    }
    
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
    if (self.selectedIndex == INDEX_HOUSETYPE) {
        self.houseType_inputedRow0 = index1;
    }
    else {
        self.exposure_inputedRow0 = index1;
    }
    
    if ([self.pickerView.secondArray count] > 0) {
        int index2 = [self.pickerView selectedRowInComponent:1];
        NSString *string2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Title"];
        [string appendString:string2];
        
        strValue2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Value"];
        
        if (self.selectedIndex == INDEX_HOUSETYPE) {
            self.houseType_inputedRow1 = index2;
        }
        else {
            self.exposure_inputedRow1 = index2;
        }
    }
    
    if ([self.pickerView.thirdArray count] > 0) {
        int index3 = [self.pickerView selectedRowInComponent:2];
        NSString *string3 = [[[self.pickerView thirdArray] objectAtIndex:index3] objectForKey:@"Title"];
        [string appendString:string3];
        
        strValue3 = [[[self.pickerView thirdArray] objectAtIndex:index3] objectForKey:@"Value"];
        
        if (self.selectedIndex == INDEX_HOUSETYPE) {
            self.houseType_inputedRow2 = index3;
        }
        else {
            self.exposure_inputedRow2 = index3;
        }
    }
    
    //顺便写入传参数值。。。以后优化代码
    if (self.selectedIndex == INDEX_HOUSETYPE) { //户型
        //
        [idStr appendString:strValue1];
        [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
        [idStr appendString:[NSString stringWithFormat:@",%@", strValue3]];
        self.property.rooms = idStr;
    }
    else { //朝向
        [idStr appendString:strValue1];
        self.property.exposure = idStr;
    }
    
    DLog(@"户型property [%@]", self.property);
    
    return string;
}

- (void)rightButtonAction:(id)sender {
    [super doBack:self];
}

- (void)doBack:(id)sender {
    if ([self.superViewController isKindOfClass:[PublishBuildingViewController class]]) {
        self.property.rooms = self.lastRooms;
        self.property.exposure = self.lastExposure; //还原上一次的输入
    }
    
    [super doBack:self];
}

#pragma mark - KeyboardBarClickDelegate
- (void)finishBtnClicked { //点击完成，输入框组件消失
    self.inputingTextF.text = [self getInputStringAndSetProperty];
    [self pickerDisappear];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    if (self.selectedIndex == INDEX_HOUSETYPE) {
        return;
    }
    else { //户型跳转
        self.selectedIndex = INDEX_EXPOSURE;
        
        self.inputingTextF.text = [self getInputStringAndSetProperty];
        
        self.inputingTextF = self.houseTypeTF;
        [self showPicker:YES];
        
    }
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    if (self.selectedIndex == INDEX_EXPOSURE) {
        return;
    }
    else { //朝向跳转
        self.selectedIndex = INDEX_HOUSETYPE;
        
        self.inputingTextF.text = [self getInputStringAndSetProperty];
        
        self.inputingTextF = self.exposureTF;
        [self showPicker:NO];
    }

}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    BOOL isHouseType = NO;
    
    if ([textField isEqual:self.houseTypeTF]) {
        self.selectedIndex = INDEX_HOUSETYPE;
        self.inputingTextF = self.houseTypeTF;
        isHouseType = YES;
    }
    else if ([textField isEqual:self.exposureTF]) {
        self.selectedIndex = INDEX_EXPOSURE;
        self.inputingTextF = self.exposureTF;
    }
    
    [self showPicker:isHouseType];
}

@end
