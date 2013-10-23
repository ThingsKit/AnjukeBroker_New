//
//  AnjukeEditPropertyViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditPropertyViewController.h"
#import "PropertyDataManager.h"
#import "InputOrderManager.h"

#define cellHeight 50

#define photoHeaderH 100
#define photoHeaderH_RecNum 100 +cellHeight
#define Input_H 216 + 44

#define LimitRow_INPUT 1 //从row=1行开始输入，即最小输入行数(第一行为小区无需输入，从户型行开始输入)

@interface AnjukeEditPropertyViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *tvList;
@property BOOL needRecordNum; //是否需要备案号，部分城市需要备案号（北京）
@property (nonatomic, strong) BrokerPicker *pickerView; //定制的输入框
@property int selectedRow; //记录当前点选的row

@property (nonatomic, strong) UITextField *areaTextF;
@property (nonatomic, strong) UITextField *priceTextF;
@property (nonatomic, strong) UITextField *titleTextF;
@property (nonatomic, strong) UITextField *contentTextF;
@end

@implementation AnjukeEditPropertyViewController
@synthesize titleArray, tvList;
@synthesize needRecordNum;
@synthesize pickerView;
@synthesize selectedRow;
@synthesize areaTextF, priceTextF, titleTextF, contentTextF;

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
        
    [self setTitleViewWithString:@"房源信息"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self pickerDisappear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.pickerView) {
        self.pickerView.brokerPickerDelegate = nil;
    }
    if (self.tvList) {
        self.tvList.delegate = nil;
    }
}

#pragma mark - init Method

- (void)initModel {
    self.titleArray = [NSArray arrayWithArray:[PropertyDataManager getPropertyTitleArrayForAnjuke:YES]];
}

- (void)initDisplay {
    //save btn
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = ITEM_BTN_FRAME;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rButton;
    
    //draw tableView list
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
    
    //draw tableView header
    [self drawHeader];
}

- (void)drawHeader {
    //根据是否需要备案号调整高度
    UIView *headerView = [[UIView alloc] init];
    if (self.needRecordNum) {
        headerView.frame = CGRectMake(0, 0, [self windowWidth], photoHeaderH_RecNum);
    }
    else
        headerView.frame = CGRectMake(0, 0, [self windowWidth], photoHeaderH);
    headerView.backgroundColor = [UIColor clearColor];
    
    //phtot btn
    int pBtnH = 80;
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(([self windowWidth] -pBtnH)/2, (headerView.frame.size.height - pBtnH)/2, pBtnH, pBtnH);
    photoBtn.backgroundColor = [UIColor clearColor];
    photoBtn.layer.borderColor = [UIColor blackColor].CGColor;
    photoBtn.layer.borderWidth = 0.5;
    [photoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:photoBtn];
    
    //备案号
    if (self.needRecordNum) {
        //
    }
    
    self.tvList.tableHeaderView = headerView;
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(15, headerView.frame.size.height -1, [self windowWidth]-15, 1)];
    [headerView addSubview:line];

}

#pragma mark - Input Method

//根据输入焦点行更改输入组件样式、数据
- (void)checkInputTypeWithIndex:(int)index {
    //移动tableView并修改高亮cell
    [self tableVIewMoveWithIndex:index];
    
    [self.tvList selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if ([InputOrderManager isKeyBoardInputWithIndex:index]) { //键盘输入，隐藏滚轮
        [self.pickerView pickerHide:[InputOrderManager isKeyBoardInputWithIndex:index]];
        
        switch (index) {
            case 2: //产证面积
                [self.areaTextF becomeFirstResponder];
                break;
            case 3: //价格
                [self.priceTextF becomeFirstResponder];
                break;
            case 7: //标题
                [self.titleTextF becomeFirstResponder];
                break;
            case 8: //描述
                [self.contentTextF becomeFirstResponder];
                break;
                
            default:
                break;
        }
    }
    else { //滚轮输入，收起键盘
        [self.pickerView pickerHide:[InputOrderManager isKeyBoardInputWithIndex:index]];
        
        [self textFieldAllResign];
        [self.pickerView reloadPickerWithRow:self.selectedRow];
    }
}

//**根据当前输入焦点行移动tableView显示
- (void)tableVIewMoveWithIndex:(NSInteger)index {
    //    [self.tvList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tvList setContentOffset:CGPointMake(0, cellHeight* index*0.8) animated:YES];
}

#pragma mark - Broker Picker Delegate

- (void)finishBtnClicked { //点击完成，输入框组件消失
    [self pickerDisappear];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    self.selectedRow --; //当前输入行数-1
    if (self.selectedRow < LimitRow_INPUT) {
        self.selectedRow = LimitRow_INPUT;
        return;
    }
    
    DLog(@"index-[%d]", self.selectedRow);
    
    //修改输入组件样式
    [self.pickerView pickerHide:[InputOrderManager isKeyBoardInputWithIndex:self.selectedRow]];
    
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self checkInputTypeWithIndex:self.selectedRow];
    
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    self.selectedRow ++; //当前输入行数+1
    if (self.selectedRow > self.titleArray.count -1) {
        DLog(@"max row -%d", self.selectedRow);
        self.selectedRow = self.titleArray.count -1;
        return;
    }
    
    DLog(@"index-[%d]", self.selectedRow);
    
    //修改输入组件样式
    [self.pickerView pickerHide:[InputOrderManager isKeyBoardInputWithIndex:self.selectedRow]];
    
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self checkInputTypeWithIndex:self.selectedRow];
}

#pragma mark - Picker Button Method

- (void)pickerDisappear {
//    [UIView animateWithDuration: 0.02
//                          delay: 0.0
//                        options: UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         self.pickerView.alpha = 0.1 ;
//                     }
//                     completion:^(BOOL finished){
//                         if (finished) {
//                             //
//                             [self.pickerView removeFromSuperview];
//                             self.pickerView.alpha = 1;
////                             self.pickerView = nil;
//                         }
//                     }];
    
    [self.pickerView removeFromSuperview];
    [self textFieldAllResign];
    
    [self.tvList deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0] animated:YES];
    [self.tvList setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)doSave {
    
}

- (void)addPhoto {
    
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITextField *cellTextField = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(180, 5,  100, cellHeight - 5*2)];
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.backgroundColor = [UIColor yellowColor];
        cellTextField.borderStyle = UITextBorderStyleNone;
        cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cellTextField.keyboardType = UIKeyboardTypeNumberPad;
        cellTextField.delegate = self;
        cellTextField.tag = 102;
        cellTextField.text = @"";
        cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [cell.contentView addSubview:cellTextField];
    }
    else {
        cellTextField = (UITextField *)[cell.contentView viewWithTag:102];
    }
    
    if (indexPath.row == 2) { //面积输入
		cellTextField.placeholder = @"";
		cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		cellTextField.font = [UIFont systemFontOfSize:15];
        cellTextField.secureTextEntry = NO;
        self.areaTextF = cellTextField;
    }
    else if (indexPath.row == 3) { //价格输入
        cellTextField.placeholder = @"";
		cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		cellTextField.font = [UIFont systemFontOfSize:15];
        cellTextField.secureTextEntry = NO;
        self.priceTextF = cellTextField;
    }
    else if (indexPath.row == 7){ //标题
        cellTextField.placeholder = @"";
		cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		cellTextField.font = [UIFont systemFontOfSize:15];
        cellTextField.secureTextEntry = NO;
        cellTextField.keyboardType = UIKeyboardTypeDefault;
        self.titleTextF = cellTextField;
    }
    else if (indexPath.row == 8){ //内容
        cellTextField.placeholder = @"";
		cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		cellTextField.font = [UIFont systemFontOfSize:15];
        cellTextField.secureTextEntry = NO;
        cellTextField.keyboardType = UIKeyboardTypeDefault;
        self.contentTextF = cellTextField;
    }
    else
        [cellTextField removeFromSuperview]; //不需要输入框
    
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) { //小区
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - tableView Delegate & Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //小区 push
        
        return;
    }
    
    //输入
    if (!self.pickerView) {
        BrokerPicker *bp = [[BrokerPicker alloc] initWithFrame:CGRectMake(0, 290, [self windowWidth], [self windowHeight] - 290)];
        bp.layer.borderColor = [UIColor blackColor].CGColor;
        bp.layer.borderWidth = 1;
        bp.brokerPickerDelegate = self;
        self.pickerView = bp;
    }
    [self checkInputTypeWithIndex:self.selectedRow];
    
    [self.view addSubview:self.pickerView];
    [self.view bringSubviewToFront:self.pickerView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self pickerDisappear];
}

#pragma mark - TextField Delegate & Method

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (void)textFieldAllResign { //全部收起键盘
    [self.areaTextF resignFirstResponder];
    [self.priceTextF resignFirstResponder];
    [self.titleTextF resignFirstResponder];
    [self.contentTextF resignFirstResponder];
}

@end
