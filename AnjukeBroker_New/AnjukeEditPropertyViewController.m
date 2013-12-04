//
//  AnjukeEditPropertyViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditPropertyViewController.h"
#import "PropertyDataManager.h"
#import "PropertyGroupListViewController.h"
#import "PropertyBigImageViewController.h"
#import "BrokerLineView.h"
#import "RTCoreDataManager.h"
#import "AnjukePropertyResultController.h"
#import "AnjukeOnlineImgController.h"
#import "AppDelegate.h"

#define LimitRow_INPUT 1 //从row=1行开始输入，即最小输入行数(第一行为小区无需输入，从户型行开始输入)

#define DEFULT_TITLE_FITMENT @"精装修"
#define DEFULT_TITLE_EXPOSURE @"南北"

typedef enum {
    Property_DJ = 0, //发房_定价
    Property_JJ, //发房_竞价
    Property_WTG //为推广
}PropertyUploadType;

@interface AnjukeEditPropertyViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@property BOOL needFileNO; //是否需要备案号，部分城市需要备案号（北京）
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘
@property int selectedRow; //记录当前点选的row

@property (nonatomic, strong) PhotoShowView *imageOverLay;
@property (nonatomic, assign) PropertyUploadType uploadType;

@property (nonatomic, copy) NSString *lastPrice; //记录上一次的价格输入，用于判断是否需要
@property (nonatomic, copy) NSString *propertyPrice; //房源定价价格

@end

@implementation AnjukeEditPropertyViewController
@synthesize titleArray, tvList;
@synthesize needFileNO;
@synthesize pickerView, toolBar, inputingTextF;
@synthesize selectedRow;
@synthesize isTakePhoto;
@synthesize imgArray;
@synthesize photoSV, imgBtnArray;
@synthesize dataSource;
@synthesize imageSelectIndex;
@synthesize imagePicker, imageOverLay;
@synthesize uploadImgIndex;
@synthesize property;
@synthesize isHaozu;
@synthesize uploadType;
@synthesize houseTypeImgArr;
@synthesize hideOnlineImg;
@synthesize fileNoTextF;
@synthesize simToolBar;
@synthesize inPhotoProcessing;
@synthesize lastPrice, propertyPrice;
@synthesize isTBBtnPressedToShowKeyboard;

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
    
    [self setDefultValue];
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
    if (self.imagePicker) {
        self.imagePicker.delegate = nil;
    }
}

#pragma mark - log
- (void)sendAppearLog {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_001;
    }
    else
        code = AJK_PROPERTY_001;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_002;
    }
    else
        code = AJK_PROPERTY_002;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

- (void)doBack:(id)sender {
    if (self.isLoading) {
        return; //请求时不返回
    }
    
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_003;
    }
    else
        code = AJK_PROPERTY_003;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    [super doBack:self];
}

#pragma mark - init Method

- (void)initModel {
    self.titleArray = [NSArray arrayWithArray:[PropertyDataManager getPropertyTitleArrayForHaozu:self.isHaozu]];
    self.imgArray = [NSMutableArray array];
    self.imgBtnArray = [NSMutableArray array];
    self.houseTypeImgArr = [NSMutableArray array];
    
    self.uploadImgIndex = 0;
    self.property = [PropertyDataManager getNewPropertyObject];
    
    self.lastPrice = [NSString string];
    self.propertyPrice = [NSString string];
}

- (void)initDisplay {
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(doSave)];
//    self.navigationItem.rightBarButtonItem = backBtn;
    
    [self addRightButton:@"保存" andPossibleTitle:nil];
    
    //draw tableView list
    self.dataSource = [[AnjukeEditableTV_DataSource alloc] init];
    self.dataSource.superViewController = self;
    [self.dataSource createCells:self.titleArray isHaozu:self.isHaozu];
    
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self.dataSource;
    [self.view addSubview:tv];
    
    //draw tableView header
    [self drawHeader];
}

- (void)drawHeader {
    self.needFileNO = [LoginManager needFileNOWithCityID:[LoginManager getCity_id]];
    
    //根据是否需要备案号调整高度
    UIView *headerView = [[UIView alloc] init];
    if (self.needFileNO && self.isHaozu == NO) { //仅二手房发房（北京）需要备案号
        headerView.frame = CGRectMake(0, 0, [self windowWidth], photoHeaderH_RecNum);
    }
    else
        headerView.frame = CGRectMake(0, 0, [self windowWidth], photoHeaderH);
    headerView.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    
    // photo sv
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, photoHeaderH)];
    self.photoSV = sv;
    sv.clipsToBounds = YES;
    sv.backgroundColor = [UIColor clearColor];
    sv.contentSize = CGSizeMake(headerView.frame.size.width, headerView.frame.size.height);
    [headerView addSubview:sv];
    
    //phtot btn
    int pBtnH = 76;
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(([self windowWidth] -pBtnH)/2, (sv.frame.size.height - pBtnH)/2, pBtnH, pBtnH);
    photoBtn.backgroundColor = [UIColor whiteColor];
    [photoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:photoBtn];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon05_photo"]];
    icon.frame = CGRectMake((photoBtn.frame.size.width - 65/2)/2, (photoBtn.frame.size.width - 50/2)/2, 65/2, 50/2);
    [icon setUserInteractionEnabled:NO];
    [photoBtn addSubview:icon];
    
    photoBtn.frame = CGRectMake( PhotoImg_Gap , PhotoImg_Gap, PhotoImg_H, PhotoImg_H);
    
    for (int i = 0; i< PhotoImg_MAX_COUNT; i ++) {
        PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(PhotoImg_Gap +(i +1) * (PhotoImg_Gap + PhotoImg_H), PhotoImg_Gap, PhotoImg_H, PhotoImg_H)];
        pBtn.tag = TagOfImg_Base + i;
        [pBtn addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
        pBtn.deleteBtnShow = NO;
        [self.photoSV addSubview:pBtn];
        [self.imgBtnArray addObject:pBtn];
    }
    
    //备案号
    if (self.needFileNO && self.isHaozu == NO) {
        UIView *fileNO_BG = [[UIView alloc] initWithFrame:CGRectMake(0, photoHeaderH, [self windowWidth], photoHeaderH_RecNum - photoHeaderH)];
        fileNO_BG.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:fileNO_BG];
        
        UILabel *fnLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 20)];
        fnLb.backgroundColor = [UIColor clearColor];
        fnLb.textColor = SYSTEM_DARK_GRAY;
        fnLb.font = [UIFont systemFontOfSize:18];
        fnLb.text = @"备案号";
        [fileNO_BG addSubview:fnLb];
        
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
        cellTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.fileNoTextF = cellTextField;
        [fileNO_BG addSubview:cellTextField];
    }
    
    self.tvList.tableHeaderView = headerView;
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(15, headerView.frame.size.height -1, [self windowWidth]-15, 1)];
    [headerView addSubview:line];
    
    [self refreshPhotoHeader];
}

#pragma mark - Request Method

- (void)uploadPhoto {
    if (![self checkUploadProperty]) {
        return;
    }
    
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    if (self.uploadImgIndex > self.imgArray.count - 1) {
        DLog(@"图片上传完毕，开始发房");
        
        [self uploadProperty]; //开始上传房源
        return;
    }
        
    if (self.imgArray.count == 0) {
        [self showLoadingActivity:YES];
        self.isLoading = YES;
        [self uploadProperty]; //......
//        [self showInfo:@"请选择房源图片，谢谢"];
        return; //没有上传图片
    }
    
    if (self.uploadImgIndex == 0) { //第一张图片开始上传就显示黑框，之后不重复显示，上传流程结束后再消掉黑框
        [self showLoadingActivity:YES];
        self.isLoading = YES;
    }
    
    //test
    //上传图片给UFS服务器
    NSString *photoUrl = [[self.imgArray objectAtIndex:self.uploadImgIndex] photoURL];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:API_PhotoUpload]];
    [request addFile:photoUrl forKey:@"file"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(uploadPhotoFinish:)];
    [request setDidFailSelector:@selector(uploadPhotoFail:)];
    [request startAsynchronous];
}

- (void)uploadPhotoFinish:(ASIFormDataRequest *)request{
    NSDictionary *result = [request.responseString JSONValue];
    RTNetworkResponse *response = [[RTNetworkResponse alloc] init];
    [response setContent:result];
    
    DLog(@"image upload result[%@]", result);
    
    //保存imageDic在E_Photo
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"image"]];
//    [dic setObject:@"2" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
    if (self.isHaozu) {
        [dic setObject:@"1" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
    }
    else //二手房
        [dic setObject:@"2" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
    
    [(E_Photo *)[self.imgArray objectAtIndex:self.uploadImgIndex] setImageDic:dic];
    
    //继续上传图片
    self.uploadImgIndex ++;
    [self uploadPhoto];
}

- (void)uploadPhotoFail:(ASIFormDataRequest *)request{
    NSDictionary *result = [request.responseString JSONValue];
    RTNetworkResponse *response = [[RTNetworkResponse alloc] init];
    [response setContent:result];
    
    self.uploadImgIndex = 0;
    
    [self showInfo:@"图片上传失败，请重试"];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

//发房
- (void)uploadProperty {
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    self.property.imageJson = [self getImageJson];
    [self setTextFieldForProperty];
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", self.property.comm_id, @"commId", self.property.rooms, @"rooms", self.property.area, @"area", self.property.price, @"price", self.property.fitment, @"fitment", self.property.exposure, @"exposure", self.property.floor, @"floor", self.property.title, @"title", self.property.desc, @"description", self.property.imageJson, @"imageJson", self.property.fileNo, @"fileNo",nil];
    method = @"anjuke/prop/publish/";
    
    if (self.isHaozu) {
        [params setObject:self.property.rentType forKey:@"shareRent"]; //租房新增出租方式
        method = @"zufang/prop/publish/";
    }
    
    if (self.isHaozu) {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onUploadPropertyHZFinished:)];
    }
    else {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onUploadPropertyFinished:)];
    }
}

- (void)onUploadPropertyFinished:(RTNetworkResponse *)response {
    DLog(@"--发房结束。。。response [%@]", [response content]);

    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    //保存房源id
    NSString *propertyID = [[[response content] objectForKey:@"data"] objectForKey:@"id"];
    [self doPushPropertyID:propertyID];
    
    [self hideLoadWithAnimated:YES];
}

- (void)onUploadPropertyHZFinished:(RTNetworkResponse *)response {
    DLog(@"--发房结束HZ。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        [self hideLoadWithAnimated:YES];
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    //保存房源id for test 暂无法选定价竞价组
    NSString *propertyID = [[[response content] objectForKey:@"data"] objectForKey:@"id"];
    [self doPushPropertyID:propertyID];
    
    [self hideLoadWithAnimated:YES];
}

- (void)requestWithPrice {
    if(![self isNetworkOkay]){
        [self showAlertViewWithPrice:@""];
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.property.price, @"price", [LoginManager getCity_id], @"cityId", nil];
    
    method = @"anjuke/fix/minoffer/";
    if (self.isHaozu) {
        method = @"zufang/fix/minoffer/";
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onGetPrice:)];
}

- (void)onGetPrice:(RTNetworkResponse *)response {
    DLog(@"--get price。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        [self hideLoadWithAnimated:YES];
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    self.propertyPrice = [[[response content] objectForKey:@"data"] objectForKey:@"price"];
    [self showAlertViewWithPrice:self.propertyPrice];
}

#pragma mark - Private Method

//**根据当前输入焦点行移动tableView显示
- (void)tableVIewMoveWithIndex:(NSInteger)index {
    [self.tvList setFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight] - self.pickerView.frame.size.height - self.toolBar.frame.size.height-28)]; //***减28像素，先保证最后一行输入时不被中文输入法遮挡
    
    [self.tvList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO]; //animated
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
    [(AnjukeEditableCell *)[[self.dataSource cellArray] objectAtIndex:self.selectedRow] setInputed_RowAtCom0:index1];
    
    if ([self.pickerView.secondArray count] > 0) {
        int index2 = [self.pickerView selectedRowInComponent:1];
        NSString *string2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Title"];
        [string appendString:string2];
        
        strValue2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Value"];
        
        [(AnjukeEditableCell *)[[self.dataSource cellArray] objectAtIndex:self.selectedRow] setInputed_RowAtCom1:index2];
    }
    
    if ([self.pickerView.thirdArray count] > 0) {
        int index3 = [self.pickerView selectedRowInComponent:2];
        NSString *string3 = [[[self.pickerView thirdArray] objectAtIndex:index3] objectForKey:@"Title"];
        [string appendString:string3];
        
        strValue3 = [[[self.pickerView thirdArray] objectAtIndex:index3] objectForKey:@"Value"];
        
        [(AnjukeEditableCell *)[[self.dataSource cellArray] objectAtIndex:self.selectedRow] setInputed_RowAtCom2:index3];
    }
    
//    DLog(@"string-[%@]", string);
    
    //顺便写入传参数值。。。以后优化代码
    if (self.isHaozu) {
        switch (self.selectedRow) { //二手房
            case HZ_P_ROOMS: //户型
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue3]];
                self.property.rooms = idStr;
            }
                break;
            case HZ_P_FITMENT: //装修
            {
                [idStr appendString:strValue1];
                self.property.fitment = idStr;
            }
                break;
            case HZ_P_RENTTYPE: //出租方式
            {
                [idStr appendString:strValue1];
                self.property.rentType = idStr;
            }
                break;
            case HZ_P_EXPOSURE: //朝向
            {
                [idStr appendString:strValue1];
                self.property.exposure = idStr;
            }
                break;
            case HZ_P_FLOORS: //楼层
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                self.property.floor = idStr;
            }
                break;
            default:
                break;
        }
    }
    else {
        switch (self.selectedRow) { //二手房
            case AJK_P_ROOMS: //户型
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue3]];
                self.property.rooms = idStr;
            }
                break;
            case AJK_P_FITMENT: //装修
            {
                [idStr appendString:strValue1];
                self.property.fitment = idStr;
            }
                break;
            case AJK_P_EXPOSURE: //朝向
            {
                [idStr appendString:strValue1];
                self.property.exposure = idStr;
            }
                break;
            case AJK_P_FLOORS: //楼层
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                self.property.floor = idStr;
            }
                break;
            default:
                break;
        }
    }
    
    DLog(@"id string-[%@]", idStr);
    
    return string;
}

- (void)pickerDisappear {
    [self textFieldAllResign];
    
    [self.tvList setFrame:FRAME_WITH_NAV];
    [self.tvList setContentOffset:CGPointMake(0, 0) animated:YES];
    
    self.isTBBtnPressedToShowKeyboard = NO;
    
    
}

- (NSString *)getImageJson {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.imgArray.count; i ++) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[(E_Photo *)[self.imgArray objectAtIndex:i] imageDic]];
        [arr addObject:dic];
    }
    if ([self onlineHouseTypeImgExit]) { //添加在线房形图
        NSDictionary *houseTypeDic = [self.houseTypeImgArr objectAtIndex:0];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[houseTypeDic objectForKey:@"aid"] forKey:@"commPicIds"];
//        [dic setObject:@"3" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
        if (self.isHaozu) {
            [dic setObject:@"2" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
        }
        else //二手房
            [dic setObject:@"3" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
        [dic setValue:@"1" forKey:@"flag"];
        
        [arr addObject:dic];
    }
    
    NSString *str = [arr JSONRepresentation];
    DLog(@"image json [%@]", str);
    return str;
}

//将输入框内内容赋值到property中
- (void)setTextFieldForProperty {
    if (self.isHaozu) {
        self.property.area = [[[[self.dataSource cellArray] objectAtIndex:HZ_T_AREA] text_Field] text];
        
        NSInteger price = [[[[[self.dataSource cellArray] objectAtIndex:HZ_T_PRICE] text_Field] text] intValue];
        self.property.price = [NSString stringWithFormat:@"%d", price];
    }
    else { //二手房
        self.property.area = [[[[self.dataSource cellArray] objectAtIndex:AJK_T_AREA] text_Field] text];
        
        NSInteger price = [[[[[self.dataSource cellArray] objectAtIndex:AJK_T_PRICE] text_Field] text] intValue] * 10000;
        self.property.price = [NSString stringWithFormat:@"%d", price];
    }
}

- (void)doPushPropertyID:(NSString *)propertyID {
    
    //tabController切换
    int tabIndex = 1;
    if (self.isHaozu) {
        tabIndex = 2;
    }
    
    //do push
    switch (self.uploadType) {
        case Property_DJ:
        {
            PropertyGroupListViewController *pv = [[PropertyGroupListViewController alloc] init];
            pv.propertyID = [NSString stringWithFormat:@"%@", propertyID];
            pv.isHaozu = self.isHaozu;
            pv.backType = RTSelectorBackTypeDismiss;
            pv.commID = [NSString stringWithFormat:@"%@", self.property.comm_id];
            [self.navigationController pushViewController:pv animated:YES];
            
        }
            break;
        case Property_JJ:
        {
            PropertyGroupListViewController *pv = [[PropertyGroupListViewController alloc] init];
            pv.propertyID = [NSString stringWithFormat:@"%@", propertyID];
            pv.commID = [NSString stringWithFormat:@"%@", self.property.comm_id];
            pv.isHaozu = self.isHaozu;
            pv.backType = RTSelectorBackTypeDismiss;
            pv.isBid = YES;
            [self.navigationController pushViewController:pv animated:YES];
            
        }
            break;
        case Property_WTG: {
            //为推广，直接去到房源结果页
            if (self.isHaozu) {
                [[AppDelegate sharedAppDelegate] dismissController:self withSwitchIndex:tabIndex withSwtichType:SwitchType_RentNoPlan withPropertyDic:[NSDictionary dictionary]];
            }
            else
                [[AppDelegate sharedAppDelegate] dismissController:self withSwitchIndex:tabIndex withSwtichType:SwitchType_SaleNoPlan withPropertyDic:[NSDictionary dictionary]];
        }
            break;
            
        default:
            break;
    }
}

- (void)doPushToCommunity {
    CommunityListViewController *cl = [[CommunityListViewController alloc] init];
    cl.isHaouzu = self.isHaozu;
    cl.communityDelegate = self;
    [self.navigationController pushViewController:cl animated:YES];
}

//检查是否有在线房形图
- (BOOL)onlineHouseTypeImgExit {
    if (self.houseTypeImgArr.count > 0) {
        return YES; //有在线房形图
    }
    
    return NO; //无在线房形图
}

- (BOOL)canAddMoreImgWithNewCount:(int)newCount {
    int count = self.imgArray.count + newCount;
    if ([self onlineHouseTypeImgExit]) {
        //有户型图
        count +=1; //先有图片数+1
    }
    DLog(@"test *** 当前图片数[%d]", count);
    
    if (count > PhotoImg_MAX_COUNT) {
        return NO; //超出最大可上传图片数
    }
    
    return YES;
}

- (NSString *)getOnlineHouseTypeImgURL {
    NSString *url = [NSString string];
    
    if ([self onlineHouseTypeImgExit]) {
        url = [[self.houseTypeImgArr objectAtIndex:0] objectForKey:@"url"];
    }
    
    return url;
}

- (void)setDefultValue {
    //房屋装修、朝向
    if (!self.isHaozu) {
        //fitment
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_FITMENT] text_Field] setText:DEFULT_TITLE_FITMENT];
        int index = [PropertyDataManager getFitmentIndexWithString:DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        NSString *value = [PropertyDataManager getFitmentVauleWithTitle:DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        self.property.fitment = value;
        
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_FITMENT] setInputed_RowAtCom0:index];
        
        //exposure
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_EXPOSURE] text_Field] setText:DEFULT_TITLE_EXPOSURE];
        int index2 = [PropertyDataManager getExposureIndexWithTitle:DEFULT_TITLE_EXPOSURE];
        NSString *value2 = [PropertyDataManager getExposureValueWithTitle:DEFULT_TITLE_EXPOSURE];
        self.property.exposure = value2;
        
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_EXPOSURE] setInputed_RowAtCom0:index2];
    }
    else {
        //fitment
        [[[[self.dataSource cellArray] objectAtIndex:HZ_P_FITMENT] text_Field] setText:DEFULT_TITLE_FITMENT];
        int index = [PropertyDataManager getFitmentIndexWithString:DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        NSString *value = [PropertyDataManager getFitmentVauleWithTitle:DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        self.property.fitment = value;
        
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_FITMENT] setInputed_RowAtCom0:index];
        
        //exposure
        [[[[self.dataSource cellArray] objectAtIndex:HZ_P_EXPOSURE] text_Field] setText:DEFULT_TITLE_EXPOSURE];
        int index2 = [PropertyDataManager getExposureIndexWithTitle:DEFULT_TITLE_EXPOSURE];
        NSString *value2 = [PropertyDataManager getExposureValueWithTitle:DEFULT_TITLE_EXPOSURE];
        self.property.exposure = value2;
        
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_EXPOSURE] setInputed_RowAtCom0:index2];
    }
}

- (BOOL)checkUploadProperty {
    [self setTextFieldForProperty];
    
    if ([self.property.rooms isEqualToString:@""]) {
        [self showInfo:@"请选择户型，谢谢"];
        return NO;
    }
    if ([self.property.area length] == 0) {
        [self showInfo:@"请填写面积，谢谢"];
        return NO;
    }
    if ([self.property.price length] == 0) {
        [self showInfo:@"请填写价格，谢谢"];
        return NO;
    }
    if ([self.property.fitment isEqualToString:@""]) {
        [self showInfo:@"请选择装修情况，谢谢"];
        return NO;
    }
    if ([self.property.exposure isEqualToString:@""]) {
        [self showInfo:@"请选择朝向，谢谢"];
        return NO;
    }
    if ([self.property.floor isEqualToString:@""]) {
        [self showInfo:@"请选择楼层，谢谢"];
        return NO;
    }
    if ([self.property.title isEqualToString:@""]) {
        [self showInfo:@"请填写房源标题，谢谢"];
        return NO;
    }
    if ([self.property.desc isEqualToString:@""]) {
        [self showInfo:@"请填写房源详情，谢谢"];
        return NO;
    }
    if ([self.property.comm_id isEqualToString:@""]) {
        [self showInfo:@"请选择小区，谢谢"];
        return NO;
    }

    DLog(@"rent Type [%@]", self.property.rentType);
    
    if (self.isHaozu) {
        if ([self.property.area intValue] < 10 || [self.property.area intValue] > 2000) {
            [self showInfo:@"面积范围10至2000平米"];
            return NO;
        }
        if ([self.property.rentType isEqualToString:@""]) {
            [self showInfo:@"请选择出租类型，谢谢"];
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Photo ScrollView && ImagePickerOverLay method

//得到需要在第几个预览图显示
- (int)getPhotoImgShowIndex {
    if (self.imgArray.count == 0) {
        return 0;
    }
    
    int index = self.imgArray.count;
    return index;
}

- (PhotoButton *)getPhotoIMG_VIEW {
    PhotoButton *pBtn = [self.imgBtnArray objectAtIndex:[self getPhotoImgShowIndex]];
    return pBtn;
}

- (void)refreshPhotoHeader {
    for (PhotoButton *btn in self.imgBtnArray) {
        btn.photoImg.image = nil;
    }
    
    //redraw header img scroll
    for (int i = 0; i < self.imgArray.count; i ++) {
        PhotoButton *imgBtn = (PhotoButton *)[self.imgBtnArray objectAtIndex:i];
        NSString *url = [(E_Photo *)[self.imgArray objectAtIndex:i] smallPhotoUrl];
        [imgBtn.photoImg setImage:[UIImage imageWithContentsOfFile:url]];
    }
    
    if ([self onlineHouseTypeImgExit]) { //最后添加上在线房形图
        //add online
        PhotoButton *imgBtn = (PhotoButton *)[self.imgBtnArray objectAtIndex:self.imgArray.count];
        imgBtn.photoImg.imageUrl = [self getOnlineHouseTypeImgURL];
    }
    
//    for (PhotoButton * imgBtn in self.imgBtnArray) {
//        if (imgBtn.photoImg.image == nil) {
//            imgBtn.hidden = YES;
//        }
//        else
//            imgBtn.hidden = NO;
//    }
    
    if ([self onlineHouseTypeImgExit]) {
        self.photoSV.contentSize = CGSizeMake(PhotoImg_Gap + (PhotoImg_Gap+ PhotoImg_H)* (self.imgArray.count +2), photoHeaderH);
    }
    else {
        self.photoSV.contentSize = CGSizeMake(PhotoImg_Gap + (PhotoImg_Gap+ PhotoImg_H)* (self.imgArray.count +1), photoHeaderH);
    }
}

#pragma mark - Simple Toolbar Delegate

- (void)SK_finishBtnClicked {
    [self.fileNoTextF resignFirstResponder];
    
    self.property.fileNo = self.fileNoTextF.text;
}

#pragma mark - Broker Picker Delegate

- (void)finishBtnClicked { //点击完成，输入框组件消失
    self.isTBBtnPressedToShowKeyboard = NO; 
    
    if (![InputOrderManager isKeyBoardInputWithIndex:self.selectedRow isHaozu:self.isHaozu]) {
        self.inputingTextF.text = [self getInputStringAndSetProperty]; //当前输入框为滚轮输入，则切换前输入
    }
    
    [self pickerDisappear];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    self.isTBBtnPressedToShowKeyboard = YES;
    
    if (![InputOrderManager isKeyBoardInputWithIndex:self.selectedRow isHaozu:self.isHaozu]) {
        self.inputingTextF.text = [self getInputStringAndSetProperty]; //当前输入框为滚轮输入，则切换前输入
    }
    
    self.selectedRow --; //当前输入行数-1
    if (self.selectedRow < LimitRow_INPUT) {
        self.selectedRow = LimitRow_INPUT;
        return;
    }
    
    DLog(@"上一项index-[%d]", self.selectedRow);
    
    [self getTextFieldWithIndex:self.selectedRow];
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self tableVIewMoveWithIndex:self.selectedRow];
    //显示弹框
    [self textFieldShowWithIndex:self.selectedRow];
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    self.isTBBtnPressedToShowKeyboard = YES;
    
    //得到前一条的输入数据，并显示下一条的输入框
    if (![InputOrderManager isKeyBoardInputWithIndex:self.selectedRow isHaozu:self.isHaozu]) {
        self.inputingTextF.text = [self getInputStringAndSetProperty]; //当前输入框为滚轮输入，则切换前输入
    }
    
    self.selectedRow ++; //当前输入行数+1
    if (self.selectedRow > self.titleArray.count -1-2) {
        self.selectedRow = self.titleArray.count -1-2; //title、详情跳转输入
        return;
    }
    
    DLog(@"下一项index-[%d]", self.selectedRow);
    
    [self getTextFieldWithIndex:self.selectedRow];
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self tableVIewMoveWithIndex:self.selectedRow];
    //显示弹框
    [self textFieldShowWithIndex:self.selectedRow];    
}

#pragma mark - Image Picker Button Method

- (void)rightButtonAction:(id)sender {
    [self doSave];
}

- (void)doSave {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_004;
    }
    else
        code = AJK_PROPERTY_004;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    if (![self checkUploadProperty]) {
        return;
    }
    
    if ([self.lastPrice isEqualToString:self.property.price]) { //价格未变，无需重心请求
        [self showAlertViewWithPrice:self.propertyPrice];
    }
    else {
        self.lastPrice = [NSString stringWithString:self.property.price];
        [self requestWithPrice];
    }
}

- (void)addPhoto {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", @"选择在线房形图", nil];
    sheet.tag = TagOfActionSheet_Img;
    [sheet showInView:self.view];
}

- (void)showPhoto:(id)sender {
    PhotoButton *pBtn = (PhotoButton *)sender;
    int photoIndex = pBtn.tag - TagOfImg_Base;
    
    //模态弹出图片播放器
    PropertyBigImageViewController *pb = [[PropertyBigImageViewController alloc] init];
    pb.btnDelegate = self;
    RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    if ([self onlineHouseTypeImgExit] && photoIndex == self.imgArray.count) { //选中在线房形图
        pb.isOnlineImg = YES;
        
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            pb.contentImgView.imageUrl = [self getOnlineHouseTypeImgURL];
        }];
    }
    else { //本地图片展示
        self.imageSelectIndex = photoIndex;
        if (pBtn.photoImg.image == nil) {
            return;
        }
        
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            pb.contentImgView.image = pBtn.photoImg.image;
        }];
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
    sheet.tag = TagOfActionSheet_Save;
    [sheet showInView:self.view];
}

#pragma mark - BigImageView Delegate
- (void)deletebtnClickForOnlineImg:(BOOL)isOnlineImg {
    if (isOnlineImg) {
        [self.houseTypeImgArr removeAllObjects]; //删除在线房形图
    }
    else //删除本地添加图片
        [self.imgArray removeObjectAtIndex:self.imageSelectIndex];
    
    //redraw header img scroll
    [self refreshPhotoHeader];
}

#pragma mark - Online Img Select Delegate

- (void)onlineImgDidSelect:(NSDictionary *)imgDic {
    DLog(@"在线房形图Data--[%@]", imgDic);
    
    if ([self onlineHouseTypeImgExit]) { //替换在线房形图
        [self.houseTypeImgArr removeAllObjects];
        [self.houseTypeImgArr addObject:imgDic];
    }
    else if ([self canAddMoreImgWithNewCount:1]) { //添加在线房形图
        //直接在新加图片后更新房形图
        [self.houseTypeImgArr removeAllObjects];
        [self.houseTypeImgArr addObject:imgDic];
    }
    
    [self refreshPhotoHeader];
}

#pragma mark - TableView Delegate & Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //小区 push，仅发房页面可编辑小区，上层编辑房源不可编辑小区
        [self doPushToCommunity];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    if (self.isHaozu) {
        if (indexPath.row == HZ_T_TITLE) {
            AnjukeEditTextViewController *ae = [[AnjukeEditTextViewController alloc] init];
            ae.textFieldModifyDelegate = self;
            [ae setTitleViewWithString:@"房源标题"];
            [ae setTextFieldDetail:self.property.title];
            ae.isTitle = YES;
            [self.navigationController pushViewController:ae animated:YES];
        }
        else if (indexPath.row == HZ_T_DESC) {
            AnjukeEditTextViewController *ae = [[AnjukeEditTextViewController alloc] init];
            ae.textFieldModifyDelegate = self;
            [ae setTitleViewWithString:@"房源描述"];
            [ae setTextFieldDetail:self.property.desc];
            ae.isTitle = NO;
            [self.navigationController pushViewController:ae animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    else {
        if (indexPath.row == AJK_T_TITLE) {
            AnjukeEditTextViewController *ae = [[AnjukeEditTextViewController alloc] init];
            ae.textFieldModifyDelegate = self;
            [ae setTitleViewWithString:@"房源标题"];
            [ae setTextFieldDetail:self.property.title];
            ae.isTitle = YES;
            [self.navigationController pushViewController:ae animated:YES];
        }
        else if (indexPath.row == AJK_T_DESC) {
            AnjukeEditTextViewController *ae = [[AnjukeEditTextViewController alloc] init];
            ae.textFieldModifyDelegate = self;
            [ae setTitleViewWithString:@"房源描述"];
            [ae setTextFieldDetail:self.property.desc];
            ae.isTitle = NO;
            [self.navigationController pushViewController:ae animated:YES];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    self.selectedRow = indexPath.row;
    
    [self getTextFieldWithIndex:self.selectedRow];
    [self textFieldShowWithIndex:self.selectedRow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - Edit_Cell Delegate

- (void)textFieldBeginEdit:(UITextField *)textField {
    if (self.isTBBtnPressedToShowKeyboard) {
        self.isTBBtnPressedToShowKeyboard = NO; //锁还原
    }
    else {
//        if (self.inputingTextF) {
//            self.inputingTextF.text = [self getInputStringAndSetProperty]; //当前输入框为滚轮输入，则切换前输入
//        }
        
        [self getTextFieldIndexWithTF:textField];
        [self textFieldShowWithIndex:self.selectedRow];
    }
}

- (void)textFieldDidEndEdit:(NSString *)text { //暂不可用
    
}

#pragma mark - Community List Select Delegate

- (void)communityDidSelect:(NSDictionary *)commDic {
    NSString *name = [NSString string];
    NSString *idStr = [NSString string];
    
    if (self.isHaozu) {
        name = [commDic objectForKey:@"commName"];
        idStr = [commDic objectForKey:@"commId"];
    }
    else {
        name = [commDic objectForKey:@"commName"];
        idStr = [commDic objectForKey:@"commId"];
    }
    
    [self setCommunityWithText:name];
    [self.property setComm_id:idStr];
    
    //删除在线房形图（如果有）
    [self.houseTypeImgArr removeAllObjects];
    [self refreshPhotoHeader];
}

- (void)setCommunityWithText:(NSString *)string {
    [[[[self.dataSource cellArray] objectAtIndex:0] communityDetailLb] setText:string];
}

#pragma mark - EditTextView Input Delegate

- (void)textDidInput:(NSString *)string isTitle:(BOOL)isTitle {
    if (isTitle) {
        if (self.isHaozu) {
            [[[[self.dataSource cellArray] objectAtIndex:HZ_T_TITLE] communityDetailLb] setText:string];
        }
        else {
            [[[[self.dataSource cellArray] objectAtIndex:AJK_T_TITLE] communityDetailLb] setText:string];
        }
        self.property.title = string;
    }
    else {
        if (self.isHaozu) {
            [[[[self.dataSource cellArray] objectAtIndex:HZ_T_DESC] communityDetailLb] setText:string];
        }
        else {
            [[[[self.dataSource cellArray] objectAtIndex:AJK_T_DESC] communityDetailLb] setText:string];
        }
        self.property.desc = string;
    }
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.fileNoTextF]) {
        if (!self.simToolBar) {
            self.simToolBar = [[SimpleKeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], NAV_BAT_H)];
            self.simToolBar.clickDelagate = self;
        }
        
        //弹出键盘
        self.fileNoTextF.inputAccessoryView = self.simToolBar;
        self.fileNoTextF.inputView = nil;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.needFileNO && [textField isEqual:self.fileNoTextF]) {
        self.property.fileNo = textField.text;
        DLog(@"fileNo [%@]", self.property.fileNo);
    }
}

#pragma mark - TextField Method

- (void)getTextFieldIndexWithTF:(UITextField *)tf {
    self.inputingTextF = tf;
    
    AnjukeEditableCell *cell = (AnjukeEditableCell *)[[[tf superview] superview] superview];
    self.selectedRow = [[self.tvList indexPathForCell:cell] row];
    
    DLog(@"修改selectRow index - [%d]", self.selectedRow);
}

- (void)getTextFieldWithIndex:(int)index {
    UITextField *tf = [(AnjukeEditableCell *)[self.dataSource.cellArray objectAtIndex:self.selectedRow] text_Field];
    self.inputingTextF = tf;
}

- (void)textFieldShowWithIndex:(int)index {
    DLog(@"传入的index [%d] selectRow[%d]", index, self.selectedRow);
    
    if (!self.pickerView) {
        self.pickerView = [[RTInputPickerView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - RT_PICKERVIEW_H - 0, [self windowWidth], RT_PICKERVIEW_H)];
    }
    
    if ((!self.toolBar)) {
        self.toolBar = [[KeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], NAV_BAT_H)];
        self.toolBar.clickDelagate = self;
    }
    
    if ([InputOrderManager isKeyBoardInputWithIndex:self.selectedRow isHaozu:self.isHaozu]) {
        //弹出键盘
        self.inputingTextF.inputAccessoryView = self.toolBar;
        self.inputingTextF.inputView = nil;
        
        DLog(@"显示键盘的index [%d]", index);
    }
    else {
        DLog(@"显示滚轮的index [%d]", index);
        
        //弹出滚轮
        self.inputingTextF.inputAccessoryView = self.toolBar;
        self.inputingTextF.inputView = self.pickerView;
        
        //重置pickerView数据
        [self.pickerView reloadPickerWithRow:self.selectedRow isHaozu:self.isHaozu];
        
        //聚焦上一次的输入
        int pickerIndex1 = [(AnjukeEditableCell *)[[self.dataSource cellArray] objectAtIndex:index] inputed_RowAtCom0];
        int pickerIndex2 = [(AnjukeEditableCell *)[[self.dataSource cellArray] objectAtIndex:index] inputed_RowAtCom1];
        int pickerIndex3 = [(AnjukeEditableCell *)[[self.dataSource cellArray] objectAtIndex:index] inputed_RowAtCom2];
        
        [self.pickerView pickerScrollToRowAtIndex:pickerIndex1 atCom:0];
        [self.pickerView pickerScrollToRowAtIndex:pickerIndex2 atCom:1];
        [self.pickerView pickerScrollToRowAtIndex:pickerIndex3 atCom:2];
        
        //根据输入数据滑动到当前row
        if (![self.inputingTextF.text isEqualToString:@""]) {
            //
        }
    }
    
    [self tableVIewMoveWithIndex:self.selectedRow];
    [self.inputingTextF becomeFirstResponder];
}

- (void)textFieldAllResign { //全部收起键盘
    [self.inputingTextF resignFirstResponder];
    [self.fileNoTextF resignFirstResponder];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == TagOfActionSheet_Img) {
        
        int maxImgCount = PhotoImg_MAX_COUNT - self.imgArray.count;
        if ([self onlineHouseTypeImgExit]) {
            maxImgCount -=1;
        }
        
        if (maxImgCount == 0) {
            [self showInfo:MAX_PHOTO_ALERT_MESSAGE];
            return;
        }
        
        switch (buttonIndex) {
            case 0: //拍照
            {
                NSString *code = [NSString string];
                if (self.isHaozu) {
                    code = HZ_PROPERTY_005;
                }
                else
                    code = AJK_PROPERTY_005;
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
                
                self.isTakePhoto = YES;
                
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
                self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                self.imagePicker = ipc;
                ipc.delegate = self;
                ipc.allowsEditing = NO;
                ipc.showsCameraControls = NO;
                self.imagePicker.cameraViewTransform = CGAffineTransformIdentity;
                if ( [UIImagePickerController isFlashAvailableForCameraDevice:self.imagePicker.cameraDevice] ) {
                    self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                }
                //拍照预览图
                PhotoShowView *pv = [[PhotoShowView alloc] initWithFrame:CGRectMake(0, [self windowHeight] - PHOTO_SHOW_VIEW_H, [self windowWidth], PHOTO_SHOW_VIEW_H)];
                self.imageOverLay = pv;
//                pv.maxImgCount = PhotoImg_MAX_COUNT;
                pv.currentImgCount = self.imgArray.count;
                pv.clickDelegate = self;
                
                ipc.cameraOverlayView = self.imageOverLay;
                
                [self presentViewController:ipc animated:YES completion:nil];
            }
                break;
            case 1: //手机相册
            {
                NSString *code = [NSString string];
                if (self.isHaozu) {
                    code = HZ_PROPERTY_006;
                }
                else
                    code = AJK_PROPERTY_006;
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
                
                self.isTakePhoto = NO;
                
                ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
                elcPicker.maximumImagesCount = maxImgCount;
                elcPicker.imagePickerDelegate = self;
                
                [self presentViewController:elcPicker animated:YES completion:nil];
            }
                break;
            case 2: //在线房形图
            {
                NSString *code = [NSString string];
                if (self.isHaozu) {
                    code = HZ_PROPERTY_007;
                }
                else
                    code = AJK_PROPERTY_007;
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
                
                if (!self.hideOnlineImg) {
                    //check小区、户型、朝向
                    if ([self.property.comm_id isEqualToString:@""] || self.property.comm_id == nil) {
//                        [self doPushToCommunity];
                        [self showInfo:@"查看在线房形图需要选择小区"];
                        return;
                    }
                    else if ([self.property.rooms isEqualToString:@""] || self.property.rooms == nil) {
                        [self showInfo:@"查看在线房形图需要选择户型"];
                        return;
                    }
//                    else if ([self.property.exposure isEqualToString:@""] || self.property.exposure == nil) {
//                        [self showInfo:@"请选择朝向"];
//                        return;
//                    }
                    
                    AnjukeOnlineImgController *ao = [[AnjukeOnlineImgController alloc] init];
                    ao.imageSelectDelegate = self;
                    ao.property = self.property;
                    ao.isHaozu = self.isHaozu;
                    [self.navigationController pushViewController:ao animated:YES];
                }
             }
                break;
                
            default:
                break;
        }
    }
    else if (actionSheet.tag == TagOfActionSheet_Save) {
        switch (buttonIndex) {
            case 0: //定价
            {
                NSString *code = [NSString string];
                if (self.isHaozu) {
                    code = HZ_PROPERTY_008;
                }
                else
                    code = AJK_PROPERTY_008;
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
                
                self.uploadType = Property_DJ;
                
                //test upload img
                [self uploadPhoto];
            }
                break;
            case 1: //定价+竞价
            {
                NSString *code = [NSString string];
                if (self.isHaozu) {
                    code = HZ_PROPERTY_009;
                }
                else
                    code = AJK_PROPERTY_009;
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
                
                self.uploadType = Property_JJ;
                
                //test upload img
                [self uploadPhoto];
            }
                break;
            case 2: //暂不推广
            {
                NSString *code = [NSString string];
                if (self.isHaozu) {
                    code = HZ_PROPERTY_010;
                }
                else
                    code = AJK_PROPERTY_010;
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
                
                self.uploadType = Property_WTG;
                
                //test upload img
                [self uploadPhoto];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - Photo Show View Delegate
- (void)takePhoto_Click {
    //外部控制最大拍照数量，如果到达上限则不继续拍照
    int count = [[self.imageOverLay imgArray] count]+1;
    DLog(@"拍摄 [%d]", [[self.imageOverLay imgArray] count]);
    
    if (![self canAddMoreImgWithNewCount:count]) {
        [self showInfo:MAX_PHOTO_ALERT_MESSAGE];
        return;
    }
    
    if (self.inPhotoProcessing) { //照片处理过程中不拍照
        DLog(@"处理照片呢，二逼啊拍那么快");
        return;
    }
    
    [self.imagePicker takePicture];
}

- (void)closePicker_Click_WithImgArr:(NSMutableArray *)arr {
    for (int i = 0; i < arr.count; i ++) {
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:(UIImage *)[arr objectAtIndex:i] toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        ep.smallPhotoUrl = url;
        
        [self.imgArray addObject:ep];
    }
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
    
    //redraw header img scroll
    [self refreshPhotoHeader];
}

#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.inPhotoProcessing = YES;
    
    UIImage *image = nil;
    UIImage *newSizeImage = nil;
    
    for (NSString *str  in [info allKeys]) {
        DLog(@"pickerInfo Keys %@",str);
    }
    
    if (self.isTakePhoto) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //原片写入相册 for test(调试代码时不写入)
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(errorCheck:didFinishSavingWithError:contextInfo:), nil);
    }
    else {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    //压缩图片
    if (image.size.width > IMAGE_MAXSIZE_WIDTH || image.size.height > IMAGE_MAXSIZE_WIDTH || self.isTakePhoto) {
        CGSize coreSize;
        if (image.size.width > image.size.height) {
            coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH*(image.size.height /image.size.width));
        }
        else if (image.size.width < image.size.height){
            coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH *(image.size.width /image.size.height), IMAGE_MAXSIZE_WIDTH);
        }
        else {
            coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH);
        }
        
        UIGraphicsBeginImageContext(coreSize);
        [image drawInRect:[Util_UI frameSize:image.size inSize:coreSize]];
        newSizeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
        newSizeImage = image; //只显示预览图
    
    //拍照界面加入新预览图
    [self.imageOverLay takePhotoWithImage:newSizeImage];
    
    self.inPhotoProcessing = NO;
    
//    [self dismissViewControllerAnimated:YES completion:^(void){
//        //
//    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
}

- (void)errorCheck:(NSString *)imgPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	
	if(error) {
        DLog(@"fail...");
    }
	else
	{
        DLog(@"success");
	}
}

#pragma mark - ELCImagePickerController Delegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    int count = [info count];
    if (![self canAddMoreImgWithNewCount:count]) {
        [self showInfo:MAX_PHOTO_ALERT_MESSAGE];
        return;
    }
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:image toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        
        UIImage *newSizeImage = nil;
        //压缩图片
        if (image.size.width > IMAGE_MAXSIZE_WIDTH || image.size.height > IMAGE_MAXSIZE_WIDTH || self.isTakePhoto) {
            CGSize coreSize;
            if (image.size.width > image.size.height) {
                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH*(image.size.height /image.size.width));
            }
            else if (image.size.width < image.size.height){
                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH *(image.size.width /image.size.height), IMAGE_MAXSIZE_WIDTH);
            }
            else {
                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH);
            }
            
            UIGraphicsBeginImageContext(coreSize);
            [image drawInRect:[Util_UI frameSize:image.size inSize:coreSize]];
            newSizeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            path = [PhotoManager saveImageFile:newSizeImage toFolder:PHOTO_FOLDER_NAME];
            url = [PhotoManager getDocumentPath:path];
            ep.smallPhotoUrl = url;

        }
        else {
            ep.smallPhotoUrl = url;
        }
        
        [self.imgArray addObject:ep];
	}
    
    [self refreshPhotoHeader];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
