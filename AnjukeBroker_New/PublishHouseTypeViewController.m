//
//  PublishHouseTypeViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishHouseTypeViewController.h"
#import "PublishTableViewDataSource.h"
#import "PublishDataModel.h"
#import "AnjukeEditableCell.h"
#import "Property.h"
#import "Util_UI.h"

#define SELECT_BTN_TAG 1000

@interface PublishHouseTypeViewController ()

@property (nonatomic, strong) PublishTableViewDataSource *cellDataSource;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableViewList;
@property int selectedIndex; //记录当前点选的row对应的cellDataSource对应的indexTag
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘

@property (nonatomic, strong) UITextField *houseTypeTF;
@property (nonatomic, strong) UITextField *exposureTF;
@property (nonatomic, strong) UITextField *inputingTF;

@end

@implementation PublishHouseTypeViewController
@synthesize isHaozu;
@synthesize cellDataSource;
@synthesize dataArray;
@synthesize tableViewList;
@synthesize houseTypeTF, exposureTF;
@synthesize inputingTextF;

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
    
    [self setTitleViewWithString:@"房型"];
    [self addRightButton:@"保存" andPossibleTitle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    self.cellDataSource = [[PublishTableViewDataSource alloc] init];
    self.dataArray = [NSMutableArray array];
    
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
    
    DLog(@"index %d", index);
    
    self.selectedIndex = index;
    
    if (index == 0) {
        //户型
        self.inputingTextF = self.houseTypeTF;
    }
    else { //朝向
        self.inputingTextF = self.exposureTF;
    }
    
    [self showPicker];
}

- (void)pickerDisappear {
    [self.inputingTextF resignFirstResponder];
}

- (void)showPicker {
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
    
    [self.inputingTextF becomeFirstResponder];
}

#pragma mark - KeyboardBarClickDelegate
- (void)finishBtnClicked { //点击完成，输入框组件消失
    
    [self pickerDisappear];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    
}

#pragma mark - UITextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.houseTypeTF]) {
        self.inputingTextF = self.houseTypeTF;
    }
    else if ([textField isEqual:self.exposureTF]) {
        self.inputingTextF = self.exposureTF;
    }
    
    [self showPicker];
}

@end
