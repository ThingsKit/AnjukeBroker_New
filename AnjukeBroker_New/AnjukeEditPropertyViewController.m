//
//  AnjukeEditPropertyViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditPropertyViewController.h"
#import "PropertyDataManager.h"

#define cellHeight 50

#define photoHeaderH 100
#define photoHeaderH_RecNum 100 +cellHeight


@interface AnjukeEditPropertyViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *tvList;
@property BOOL needRecordNum; //是否需要备案号，部分城市需要备案号（北京）
@property (nonatomic, strong) BrokerPicker *picker; //定制的输入框
@property int selectedRow; //记录当前点选的row

@property (nonatomic, strong) UITextField *areaTextF;
@property (nonatomic, strong) UITextField *priceTextF;
@end

@implementation AnjukeEditPropertyViewController
@synthesize titleArray, tvList;
@synthesize needRecordNum;
@synthesize picker;
@synthesize selectedRow;
@synthesize areaTextF, priceTextF;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

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
    else {
        [cellTextField removeFromSuperview]; //不需要输入框
    }
    
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) { //小区
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    
    if (indexPath.row == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        //小区 push
        
        return;
    }
    
    //输入
    BrokerPicker *bp = [[BrokerPicker alloc] initWithFrame:CGRectMake(0, 300, [self windowWidth], [self windowHeight] -300)];
    bp.layer.borderColor = [UIColor blackColor].CGColor;
    bp.layer.borderWidth = 1;
    bp.brokerPickerDelegate = self;
    self.picker = bp;
    
    switch (indexPath.row) { //户型
        case 1:
        {
            bp.firstArray = [PropertyDataManager getPropertyHuxingArray_Shi];
            bp.secondArray = [PropertyDataManager getPropertyHuxingArray_Ting];
            bp.thirdArray = [PropertyDataManager getPropertyHuxingArray_Wei];
        }
            break;
            
        default:
            break;
    }
    
    [self.view addSubview:bp];
    [self.view bringSubviewToFront:bp];
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self pickerDisappear];
}

#pragma mark - Broker Picker Delegate

- (void)finishBtnClicked {
    [self pickerDisappear];
}

#pragma mark - button method

- (void)pickerDisappear {
    [UIView animateWithDuration: 0.3
                          delay: 0.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.picker.alpha = 0.1 ;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             //
                             [self.picker removeFromSuperview];
                             self.picker = nil;
                         }
                     }];
    
    [self.areaTextF resignFirstResponder];
    [self.priceTextF resignFirstResponder];
    
    [self.tvList deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0] animated:YES];
}

- (void)doSave {
    
}

- (void)addPhoto {
    
}

@end
