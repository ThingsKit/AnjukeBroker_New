//
//  PublishBuildingViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBuildingViewController.h"
#import "AppManager.h"
#import "AnjukeNormalCell.h"
#import "PublishHouseTypeViewController.h"
#import "PropertyGroupListViewController.h"
#import "BrokerLineView.h"
#import "RTGestureLock.h"
#import "PropertyAuctionPublishViewController.h"
#import "AJKBRadioButton.h"

#import "BK_RTNavigationController.h"

typedef enum {
    Property_DJ = 0, //发房_定价
    Property_JJ, //发房_竞价
    Property_WTG //为推广
}PropertyUploadType;

@interface PublishBuildingViewController ()

@property int selectedIndex; //记录当前点选的row对应的cellDataSource对应的indexTag
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘

@property int selectedSection;
@property (nonatomic)  int selectedRow; //记录选中的cell所在section和row，便于更改tableview的frame和位置

@property (nonatomic, copy) NSString *lastPrice; //记录上一次的价格输入，用于判断是否需要
@property (nonatomic, copy) NSString *propertyPrice; //房源定价价格

@property BOOL needFileNO; //是否需要备案号，部分城市需要备案号（北京）

@property (nonatomic, strong) PhotoShowView *imageOverLay;

@property (nonatomic, assign) PropertyUploadType uploadType;

@end

@implementation PublishBuildingViewController
@synthesize footerViewDict = _footerViewDict;//footviewdict
@synthesize footClickType;//操作foot的tag
@synthesize footerView;
@synthesize uploadRoomImgDescIndex = _uploadRoomImgDescIndex;

- (void)dealloc {
    self.tableViewList.delegate = nil;
    self.cellDataSource = nil;
    
    DLog(@"dealloc PublishBuildingViewController");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _uploadRoomImgDescIndex = 0;
    NSString *titleStr = @"发布二手房";
    if (self.isHaozu) {
        titleStr = @"发布租房";
    }
    [self setTitleViewWithString:titleStr];
    [self addRightButton:@"保存" andPossibleTitle:nil];
    
    [self setDefultValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //修改为每次显示发房页面都隐藏
    //    [self pickerDisappear];
    
    //房型图是否多图的icon显示
    BOOL show = NO;
    if (self.houseTypeImageArray.count > 0 || [self.property.onlineHouseTypeDic count] > 0) {
        show = YES;
    }
    [self.cellDataSource houseTypeCellImageIconShow:show isHaozu:self.isHaozu];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [RTGestureLock setDisableGestureForBack:self.navigationController disableGestureback:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - init Method

- (void)initModel {
    self.property = [PublishDataModel getNewPropertyObject];
    
    self.lastPrice = [NSString string];
    self.propertyPrice = [NSString string];
    
    self.roomImageArray = [NSMutableArray array];
    self.houseTypeImageArray = [NSMutableArray array];
    
    self.uploadImageArray = [NSMutableArray array];
    
    self.needFileNO = [LoginManager needFileNOWithCityID:[LoginManager getCity_id]];
    
    self.fixGroupArr = [NSArray array];
    
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
    [self drawFooter];
    [self initCellDataSource];
    
    self.pickerView = [[RTInputPickerView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - RT_PICKERVIEW_H - 0, [self windowWidth], RT_PICKERVIEW_H)];
    
    self.toolBar = [[KeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], NAV_BAT_H)];
    self.toolBar.clickDelagate = self;
}

- (void)initCellDataSource {
    PublishTableViewDataSource *pd = [[PublishTableViewDataSource alloc] init];
    
    if (self.needFileNO && self.isHaozu == NO)
    {//需要备案号
        pd.isSafeNum = YES;
    }

    self.cellDataSource = pd;
    self.tableViewList.dataSource = pd;
    [pd setSuperViewController:self];
    [pd createCells:[PublishDataModel getPropertyTitleArrayForHaozu:self.isHaozu] isHaozu:self.isHaozu];
    
    [self.tableViewList reloadData];
}

- (void)drawHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], CELL_HEIGHT+PUBLISH_SECTION_HEIGHT*2)];
    /*
    if (self.needFileNO && self.isHaozu == NO) { //仅二手房发房（北京）需要备案号
        headerView.frame = CGRectMake(0, 0, [self windowWidth], CELL_HEIGHT+PUBLISH_SECTION_HEIGHT*3+CELL_HEIGHT);
    }
    else*/
    

    headerView.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    [self.tableViewList setTableHeaderView:headerView];
    
    //小区
    UIView *comView = [[UIView alloc] initWithFrame:CGRectMake(0, PUBLISH_SECTION_HEIGHT, [self windowWidth], CELL_HEIGHT)];
    comView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:comView];
    
    /* 删除背景图片
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, -BL_HEIGHT, comView.frame.size.width, BL_HEIGHT)];
    [comView addSubview:line];
    BrokerLineView *line2 = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, comView.frame.size.height -BL_HEIGHT, comView.frame.size.width, BL_HEIGHT)];
    [comView addSubview:line2];
    
    
    UILabel *comTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, (comView.frame.size.height - 20)/2, 100, 20)];
    comTitleLb.backgroundColor = [UIColor clearColor];
    comTitleLb.text = @"小区";
    comTitleLb.textColor = SYSTEM_DARK_GRAY;
    comTitleLb.font = [UIFont systemFontOfSize:17];
    [comView addSubview:comTitleLb];
    */
    
    //小区名 label
    UILabel *comDetailLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 20)];
    comDetailLb.backgroundColor = [UIColor clearColor];
    comDetailLb.textColor = SYSTEM_BLACK;
    comDetailLb.font = [UIFont boldSystemFontOfSize:17];
    self.communityDetailLb = comDetailLb;
    [comView addSubview:comDetailLb];
    
    [self communityDataSet:comDetailLb];
    
    //小区地址 label
    CGFloat comStX = comDetailLb.frame.origin.x;
    CGFloat comStY = comDetailLb.frame.origin.y + CGRectGetHeight(comDetailLb.frame) + 5;
    CGFloat comStWidth = CGRectGetWidth(comDetailLb.frame);
    CGFloat comStHeiht = 14;
    
    NSString *adSt = [self.communityDic objectForKey:@"address"];
    
    UILabel *comStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(comStX, comStY, comStWidth, comStHeiht)];
    [comStateLabel setFont:[UIFont systemFontOfSize:14]];
    [comStateLabel setTextColor:SYSTEM_BLACK];
    [comStateLabel setBackgroundColor:[UIColor clearColor]];
    [comStateLabel setText:adSt];
    self.communityDetailAdLb = comStateLabel;
    [comView addSubview:comStateLabel];
}


/*
- (void)draw
{
    //草泥马的备案号。。。
    if (self.needFileNO && self.isHaozu == NO) {
        UIView *fileNoView = [[UIView alloc] initWithFrame:CGRectMake(0, comView.frame.origin.y+ comView.frame.size.height + PUBLISH_SECTION_HEIGHT, [self windowWidth], CELL_HEIGHT)];
        fileNoView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:fileNoView];
        
        BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, -1, fileNoView.frame.size.width, 1)];
        [fileNoView addSubview:line];
        BrokerLineView *line2 = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, fileNoView.frame.size.height - 1, fileNoView.frame.size.width, 1)];
        [fileNoView addSubview:line2];
        
        UILabel *fileTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, (fileNoView.frame.size.height - 20)/2, 100, 20)];
        fileTitleLb.backgroundColor = [UIColor clearColor];
        fileTitleLb.text = @"备案号";
        fileTitleLb.textColor = SYSTEM_DARK_GRAY;
        fileTitleLb.font = [UIFont systemFontOfSize:17];
        [fileNoView addSubview:fileTitleLb];
        
        //text field
        UITextField *cellTextField = nil;
        cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(224/2, 3,  150, CELL_HEIGHT - 1*5)];
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.backgroundColor = [UIColor clearColor];
        cellTextField.borderStyle = UITextBorderStyleNone;
        cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cellTextField.text = @"";
        cellTextField.clearButtonMode = UITextFieldViewModeNever;
        cellTextField.placeholder = @"";
        cellTextField.delegate = self;
        cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        cellTextField.font = [UIFont systemFontOfSize:17];
        cellTextField.secureTextEntry = NO;
        cellTextField.textColor = SYSTEM_BLACK;
        cellTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.fileNoTextF = cellTextField;
        [fileNoView addSubview:cellTextField];
    }
}*/

- (void)drawFooter {
    UIView *photoBGV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], PUBLISH_SECTION_HEIGHT+PHOTO_FOOTER_BOTTOM_HEIGHT + PF_EMPTY_IMAGE_HEIGHT)];
    photoBGV.backgroundColor = [UIColor clearColor];
    self.photoBGView = photoBGV; //预览图底板
    
    //初始化数组
    _footerViewDict = [[NSMutableDictionary alloc] initWithCapacity:2];
    //室内图
    PhotoFooterView *pfRoom = [[PhotoFooterView alloc] initWithFrame:CGRectMake(0, PUBLISH_SECTION_HEIGHT, [self windowWidth], PF_EMPTY_IMAGE_HEIGHT)];
    pfRoom.clickDelegate = self;
    [pfRoom setTag:1];
    [_footerViewDict setObject:pfRoom forKey:FOOTERVIEWDICTROOM];
    
    [photoBGV addSubview:pfRoom];
    
    //房型图
    CGFloat pfStY = pfRoom.frame.origin.y + CGRectGetHeight(pfRoom.frame) + 22;
    PhotoFooterView *pfStyle = [[PhotoFooterView alloc] initWithFrame:CGRectMake(0, pfStY, [self windowWidth], PF_EMPTY_IMAGE_HEIGHT)];
    pfStyle.clickDelegate = self;
    pfStyle.isHouseType = YES;
    [pfStyle setTag:2];
    
    [_footerViewDict setObject:pfStyle forKey:FOOTERVIEWDICTSTYLE];
    
    [photoBGV addSubview:pfStyle];
    
    [self.tableViewList setTableFooterView:photoBGV];
    
    [pfRoom redrawWithImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.roomImageArray]];
    [pfStyle redrawWithImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArray]];
}

#pragma mark - Private Method
//初始化_imgdescArr
- (void)initImgDesc
{
    if (!_imgdescArr || _imgdescArr.count < self.roomImageArray.count || self.roomImageArray.count > 0)
    {
        int i = 0;
        if (_imgdescArr == 0)
        {
            _imgdescArr = [NSMutableArray arrayWithCapacity:5];
            
        }else
        {
            i = _imgdescArr.count;
        }
        
        for (i = 0; i < self.roomImageArray.count; i++)
        {
            NSString *va = @"";
            [_imgdescArr addObject:va];
        }
    }
}

- (void)setDefultValue {
    //房屋装修、朝向
    if (!self.isHaozu) {
        
        DLog(@"arr == %@", [self.cellDataSource inputCellArray]);
        DLog(@"arr count == %d", [[self.cellDataSource inputCellArray] count]);
        //fitment
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FITMENT] text_Field] setText:_DEFULT_TITLE_FITMENT];
        int index = [PublishDataModel getFitmentIndexWithTitle:_DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        NSString *value = [PublishDataModel getFitmentVauleWithTitle:_DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        self.property.fitment = value;
        
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FITMENT] setInputed_RowAtCom0:index];
        
        //楼层-默认3楼6层
        int floorIndex = [PublishDataModel getFloorIndexWithValue:_DEFULT_VALUE_FLOOR];
        int proFloorIndex = [PublishDataModel getProFloorIndexWithValue:_DEFULT_VALUE_PROFLOOR];
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FLOORS] setInputed_RowAtCom0:floorIndex];
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FLOORS] setInputed_RowAtCom1:proFloorIndex];
        
        //朝向
        AnjukeEditableCell *orientCell = [[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_ORIENTATION];
        int orientIndex = [PublishDataModel getExposureIndexWithTitle:_DEFULT_TITLE_EXPOSURE];
        [[orientCell text_Field] setText:_DEFULT_TITLE_EXPOSURE];
        [orientCell setInputed_RowAtCom0:orientIndex];
        int orientationIndex = [PublishDataModel getExposureIndexWithTitle:_DEFULT_TITLE_FITMENT];
        NSString *orientationValue = [PublishDataModel getExposureTitleWithValue:_DEFULT_TITLE_FITMENT];
        self.property.exposure = orientationValue;
        
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FITMENT] setInputed_RowAtCom0:orientationIndex];
        
    }
    else {
        //fitment
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FITMENT] text_Field] setText:_DEFULT_TITLE_FITMENT];
        int index = [PublishDataModel getFitmentIndexWithTitle:_DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        NSString *value = [PublishDataModel getFitmentVauleWithTitle:_DEFULT_TITLE_FITMENT forHaozu:self.isHaozu];
        self.property.fitment = value;
        
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FITMENT] setInputed_RowAtCom0:index];

        //楼层-默认3楼6层
        int floorIndex = [PublishDataModel getFloorIndexWithValue:_DEFULT_VALUE_FLOOR];
        int proFloorIndex = [PublishDataModel getProFloorIndexWithValue:_DEFULT_VALUE_PROFLOOR];
        [[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FLOORS] setInputed_RowAtCom0:floorIndex];
        [[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FLOORS] setInputed_RowAtCom1:proFloorIndex];
        
        //朝向
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_ORIENTATION] text_Field] setText:_DEFULT_TITLE_EXPOSURE];
        int orientationIndex = [PublishDataModel getFitmentIndexWithTitle:_DEFULT_TITLE_EXPOSURE forHaozu:self.isHaozu];
        NSString *orientationValue = [PublishDataModel getFitmentVauleWithTitle:_DEFULT_TITLE_EXPOSURE forHaozu:self.isHaozu];
        self.property.fitment = orientationValue;
        
        [[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_ORIENTATION] setInputed_RowAtCom0:orientationIndex];
    }
    
    self.property.exposure = _DEFULT_TITLE_EXPOSURE;
}

- (void)rightButtonAction:(id)sender {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_004;
    }
    else
        code = AJK_PROPERTY_004;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:@"true", @"save", nil]];
    
    [self doSave];
}

- (void)doSave {
    [self pickerDisappear];
    
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
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_003;
    }
    else
        code = AJK_PROPERTY_003;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认不保存当前内容?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.cancelButtonIndex = 0;
    [alert show];
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

- (NSString *)getImageJson {
    NSMutableArray *arr = [NSMutableArray array];
    
    for (int i = 0; i < self.uploadImageArray.count; i ++) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[(E_Photo *)[self.uploadImageArray objectAtIndex:i] imageDic]];
        [arr addObject:dic];
    }
    
    if ([self.property.onlineHouseTypeDic count] > 0) { //添加在线房形图
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:[self.property.onlineHouseTypeDic objectForKey:@"aid"] forKey:@"commPicIds"];
        //        [dic setObject:@"3" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
        if (self.isHaozu) {
            [dic setObject:@"2" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
        }
        else //二手房
            [dic setObject:@"3" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
        [dic setValue:@"1" forKey:@"flag"];
        
        [arr addObject:dic];
    }
    
    NSString *str = [arr RTJSONRepresentation];
    DLog(@"image json [%@]", str);
    return str;
}

- (void)doPushPropertyID:(NSString *)propertyID {
    self.property_ID = [NSString stringWithString:propertyID];
    
    //tabController切换
    /*
    int tabIndex = 3;
    if (self.isHaozu) {
        tabIndex = 4;
    }*/
    int tabIndex = 0;
    
    self.isBid = NO;
    
    //do push
    switch (self.uploadType) {
        case Property_DJ:
        {
            //非封顶城市，原路径
            if (![LoginManager isSeedForAJK:!self.isHaozu]) {
                PropertyGroupListViewController *pv = [[PropertyGroupListViewController alloc] init];
                pv.propertyID = [NSString stringWithFormat:@"%@", propertyID];
                pv.isHaozu = self.isHaozu;
                pv.backType = RTSelectorBackTypeDismiss;
                pv.commID = [NSString stringWithFormat:@"%@", self.property.comm_id];
                [self.navigationController pushViewController:pv animated:YES];
                
                return;
            }
            
            //封顶城市：房源发布页-点击【保存】-选择【定价推广】-定价推广成功，转入【定价房源列表】页
            //call 定价组API
            [self doRequestForFixPlan];
        }
            break;
        case Property_JJ:
        {
            self.isBid = YES;
            
            //非封顶城市，原路径
            if (![LoginManager isSeedForAJK:!self.isHaozu]) {
                PropertyGroupListViewController *pv = [[PropertyGroupListViewController alloc] init];
                pv.propertyID = [NSString stringWithFormat:@"%@", propertyID];
                pv.commID = [NSString stringWithFormat:@"%@", self.property.comm_id];
                pv.isHaozu = self.isHaozu;
                pv.backType = RTSelectorBackTypeDismiss;
                pv.isBid = YES;
                [self.navigationController pushViewController:pv animated:YES];

                return;
            }
            
            //封顶城市：直接设置竞价 -->房源发布页-点击【保存】-选择【定价且竞价推广】-【设置竞价】页
            //call 定价组API
            [self doRequestForFixPlan];
            
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

- (void)prepareUploadImgArr {
    [self.uploadImageArray removeAllObjects];
    [self.uploadImageArray addObjectsFromArray:self.roomImageArray];
    [self.uploadImageArray addObjectsFromArray:self.houseTypeImageArray];
    
    self.uploadImgIndex = 0;
    
    self.uploadImg_houseTypeIndex = self.roomImageArray.count; //
}

- (void)setHouseTypeShowWithString:(NSString *)string vDict:(NSDictionary *)dic{
    
    NSString *orientSt= [dic objectForKey:@"exposure"];//朝向

    NSString *roomNumSt = [dic objectForKey:@"roomNum"];//室
    NSString *hallNumSt = [dic objectForKey:@"hallNum"];//厅
    NSString *toiletNumSt = [dic objectForKey:@"toiletNum"];//卫
    //户型
    int roomNumIndex = [PublishDataModel getRoomIndexWithValue:roomNumSt];
    int hallNumIndex = [PublishDataModel getHallIndexWithValue:hallNumSt];
    int totileNumIndex = [PublishDataModel getToiletIndexWithValue:toiletNumSt];
    
    //朝向
    int orientIndex = [PublishDataModel getExposureIndexWithTitle:orientSt];
    
    //是否满五年 和  唯一住房
    NSNumber *onlyNum = [NSNumber numberWithInt:[[dic objectForKey:@"isOnly"] intValue]];
    NSNumber *fiveNum = [NSNumber numberWithInt:[[dic objectForKey:@"isFullFive"] intValue]];
    
    if (self.isHaozu) {
        //户型
        AnjukeEditableCell *roomsCell = [[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_ROOMS];
        [[roomsCell text_Field] setText:string];
        [roomsCell setInputed_RowAtCom0:roomNumIndex];
        [roomsCell setInputed_RowAtCom1:hallNumIndex];
        [roomsCell setInputed_RowAtCom2:totileNumIndex];
        
        //朝向
        AnjukeEditableCell *orientCell = [[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_ORIENTATION];
        [orientCell setInputed_RowAtCom0:orientIndex];
        [[orientCell text_Field] setText:orientSt];
    }
    else {
        //户型
        AnjukeEditableCell *roomsCell = [[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_ROOMS];
        [[roomsCell text_Field] setText:string];
        [roomsCell setInputed_RowAtCom0:roomNumIndex];
        [roomsCell setInputed_RowAtCom1:hallNumIndex];
        [roomsCell setInputed_RowAtCom2:totileNumIndex];
        
        //朝向
        AnjukeEditableCell *orientCell = [[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_ORIENTATION];
        [orientCell setInputed_RowAtCom0:orientIndex];
        [[orientCell text_Field] setText:orientSt];
        
        //唯一住房和5年
        /*
        AnjukeNormalCell *fullOnly = [[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_FEATURE];
        UIView *fiveView = [fullOnly viewWithTag:-1];
        UIView *onlyView = [fullOnly viewWithTag:-2];

        AJKBRadioButton *fiveRadio = (AJKBRadioButton *)[fiveView viewWithTag:110];
        AJKBRadioButton *onlyRadio = (AJKBRadioButton *)[onlyView viewWithTag:110];
        onlyRadio.isChoose = [onlyNum boolValue];
        fiveRadio.isChoose = [fiveNum boolValue];*/
        [self fiveRadioValue:[fiveNum boolValue] getV:false];
        [self onlyRadioValue:[onlyNum boolValue] getV:false];
        
    }
}

//满5年的值
- (BOOL)fiveRadioValue:(BOOL)bValue getV:(BOOL)isT
{
    AnjukeNormalCell *fullOnly = [[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_FEATURE];
    UIView *fiveView = [fullOnly viewWithTag:-1];
    AJKBRadioButton *fiveRadio = (AJKBRadioButton *)[fiveView viewWithTag:110];
    if (isT)
    {
        return fiveRadio.isChoose;
    }

    fiveRadio.isChoose = bValue;
    
    return fiveRadio.isChoose;
}
//唯一的值
- (BOOL)onlyRadioValue:(BOOL)bValue getV:(BOOL)isT
{
    AnjukeNormalCell *fullOnly = [[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_FEATURE];
    UIView *onlyView = [fullOnly viewWithTag:-2];
    AJKBRadioButton *onlyRadio = (AJKBRadioButton *)[onlyView viewWithTag:110];
    if (isT)
    {
        return onlyRadio.isChoose;
    }
    onlyRadio.isChoose = bValue;

    return onlyRadio.isChoose;
}


- (void)doPushToHouseTypeVC {
    PublishHouseTypeViewController *ph = [[PublishHouseTypeViewController alloc] init];
    ph.isHaozu = self.isHaozu;
    ph.backType = RTSelectorBackTypePopBack;
    ph.property = self.property; //指针指向
    ph.superViewController = self;
    ph.houseTypeImageArr = self.houseTypeImageArray; //指针指向
    [self.navigationController pushViewController:ph animated:YES];
}

#pragma mark - Check Method

//是否能添加更多室内图
- (BOOL)canAddMoreImageWithAddCount:(int)addCount{
    if (![PhotoManager canAddMoreRoomImageForImageArr:self.roomImageArray isHaozu:self.isHaozu]) {
        [self showInfo:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:NO]];
        return NO; //超出
    }
    
    return YES;
}

- (int)allImageCount {
    int count = self.roomImageArray.count + self.houseTypeImageArray.count;
    
    DLog(@"所有图片数量 [%d]", count);
    
    return count;
}

//当前已有的室内图数量
- (int)getCurrentRoomImgCount {
    return self.roomImageArray.count;
}

//相册还可添加的图片数量
- (int)getMaxAddRoomImgCountForPhotoAlbum {
    int maxCount = AJK_MAXCOUNT_ROOMIMAGE;
    if (self.isHaozu) {
        maxCount = HZ_MAXCOUNT_ROOMIMAGE;
    }
    return (maxCount - self.roomImageArray.count);
}

#pragma mark - Request Method

- (void)uploadPhoto {
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    if (self.uploadImgIndex >= [self allImageCount]) {
        DLog(@"图片上传完毕，开始发房");
        
        [self uploadProperty]; //开始上传房源
        return;
    }
    
    if (self.uploadImageArray.count == 0) {
        [self showLoadingActivity:YES];
        self.isLoading = YES;
        [self uploadProperty]; //......
        return; //没有上传图片
    }
    
    if (self.uploadImgIndex == 0) { //第一张图片开始上传就显示黑框，之后不重复显示，上传流程结束后再消掉黑框
        
        [self showLoadingActivity:YES];
        self.isLoading = YES;
    }
    
    //test
    //上传图片给UFS服务器
    NSString *photoUrl = [[self.uploadImageArray objectAtIndex:self.uploadImgIndex] photoURL];
    
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
    
    //保存imageDic在E_Photo
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"image"]];
    if (self.isHaozu) {
        if (self.uploadImgIndex < self.uploadImg_houseTypeIndex) { //属于室内图类型
            [dic setObject:@"1" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
            //检查_imgdescArr是否存在
            [self initImgDesc];
            if ((_uploadRoomImgDescIndex <= ([_imgdescArr count] - 1)) && _imgdescArr.count > 0)
            {
                DLog(@"desc === %@", [_imgdescArr objectAtIndex:_uploadRoomImgDescIndex]);
                [dic setObject:[_imgdescArr objectAtIndex:_uploadRoomImgDescIndex] forKey:@"imageDesc"];
                _uploadRoomImgDescIndex++;
            }
        }
        else //属于房型图类型
            [dic setObject:@"2" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
        
    }
    else //二手房
    {
        if (self.uploadImgIndex < self.uploadImg_houseTypeIndex) { //属于室内图类型
            [dic setObject:@"2" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
            //检查_imgdescArr是否存在
            [self initImgDesc];
            if ((_uploadRoomImgDescIndex <= ([_imgdescArr count] - 1)) && _imgdescArr.count > 0)
            {
                DLog(@"desc === %@", [_imgdescArr objectAtIndex:_uploadRoomImgDescIndex]);
                [dic setObject:[_imgdescArr objectAtIndex:_uploadRoomImgDescIndex] forKey:@"imageDesc"];
                _uploadRoomImgDescIndex++;
            }
            
        }
        else //属于房型图类型
            [dic setObject:@"3" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
        
        
    }
    
    if (self.uploadImgIndex >= [self allImageCount]) {
        DLog(@"图片上传完毕，开始发房");
        
        [self uploadProperty]; //开始上传房源
    }
    else {
        [(E_Photo *)[self.uploadImageArray objectAtIndex:self.uploadImgIndex] setImageDic:dic];
        
        //继续上传图片
        self.uploadImgIndex ++;
        [self uploadPhoto];
    }
}

- (void)uploadPhotoFail:(ASIFormDataRequest *)request{
    NSDictionary *result = [request.responseString JSONValue];
    RTNetworkResponse *response = [[RTNetworkResponse alloc] init];
    [response setContent:result];
    
    self.uploadImgIndex = 0;
    
    [self showInfo:@"图片上传失败，请重试"];
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    _uploadRoomImgDescIndex = 0;
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
    else { //二手房新增是否满五年、是否唯一、最低首付字段
        self.property.isOnly = [NSNumber numberWithBool:[self onlyRadioValue:false getV:true]];
        self.property.isFullFive = [NSNumber numberWithBool:[self fiveRadioValue:false getV:true]];
        
        [params setObject:[self.property.isOnly stringValue] forKey:@"isOnly"];
        [params setObject:[self.property.isFullFive stringValue] forKey:@"isFullFive"];
//        [params setObject:self.property.minDownPay forKey:@"minDownPay"];
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

- (void)doRequestForFixPlan { //获得定价推广组
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    if (self.isHaozu) {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"zufang/fix/getplans/" params:params target:self action:@selector(getFixPlanFinished:)];
    }
    else {
        [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"anjuke/fix/getplans/" params:params target:self action:@selector(getFixPlanFinished:)];
    }
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
}

- (void)getFixPlanFinished:(RTNetworkResponse *)response {
    DLog(@"---getGroupList---response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    self.fixGroupArr = [[[response content] objectForKey:@"data"] objectForKey:@"planList"];
    if (self.fixGroupArr.count == 0) {
        [self hideLoadWithAnimated:NO];
        self.isLoading = NO;
        [self showInfo:@"暂无定价组"];
        
        return;
    }
    [self addPropertyToPlanWithGroupID:self.fixGroupArr[0][@"fixPlanId"]]; //添加至定价组
    
}

- (void)addPropertyToPlanWithGroupID:(NSString *)groupID{
    if(![self isNetworkOkay]){
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",  self.property_ID, @"propIds", groupID, @"planId", nil];
    
    NSString *methodStr = [NSString string];
    if (self.isHaozu) {
        methodStr = @"zufang/fix/addpropstoplan/";
    }
    else
        methodStr = @"anjuke/fix/addpropstoplan/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:methodStr params:params target:self action:@selector(addToFixFinished:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)addToFixFinished:(RTNetworkResponse *)response {
    DLog(@"---addToFix---response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
    
    if (self.isBid) { //去竞价页面
        PropertyAuctionPublishViewController *pa = [[PropertyAuctionPublishViewController alloc] init];
        pa.propertyID = [NSString stringWithFormat:@"%@", self.property_ID];
        pa.isHaozu = self.isHaozu;
        pa.backType = RTSelectorBackTypeDismiss;
        pa.commID = [NSString stringWithFormat:@"%@", self.property.comm_id];
        [self.navigationController pushViewController:pa animated:YES];
    }
    else { //跳转
        /*
        int tabIndex = 3;
        if (self.isHaozu) {
            tabIndex = 4;
        }
        */
        int tabIndex = 0;
        
        if (self.isHaozu) {
            [[AppDelegate sharedAppDelegate] dismissController:self withSwitchIndex:tabIndex withSwtichType:SwitchType_RentFixed withPropertyDic:[self.fixGroupArr objectAtIndex:0]];
        }
        else
            [[AppDelegate sharedAppDelegate] dismissController:self withSwitchIndex:tabIndex withSwtichType:SwitchType_SaleFixed withPropertyDic:[self.fixGroupArr objectAtIndex:0]];
    }
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
                case 2:
                    if (!self.isHaozu) {
                        index = 2;
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
                case 0:
                    index = AJK_PICKER_ROOMS;
                    break;
                case 1:
                    index = AJK_PICKER_FLOORS;
                    break;
                case 2:
                    index = AJK_PICKER_ORIENTATION;
                    break;
                case 3:
                    index = AJK_PICKER_FITMENT;
                    break;
                case 4:
                    index = HZ_PICKER_RENTTYPE;
                    break;
                    
                default:
                    break;
            }
            /*
            if (!self.isHaozu) {
                index ++; //二手房，此index需要递增1（多最低首付）
            }
             */
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
    if (![[[self.cellDataSource inputCellArray] objectAtIndex:index] isKindOfClass:[AnjukeEditableCell class]]) {
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
            case HZ_PICKER_ROOMS://户型
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue3]];
                self.property.rooms = idStr;
            }
                break;
            case HZ_PICKER_ORIENTATION://朝向
            {
                [idStr appendString:strValue1];
                self.property.exposure = idStr;
            }
                break;
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
            case AJK_PICKER_ROOMS://户型
            {
                [idStr appendString:strValue1];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue2]];
                [idStr appendString:[NSString stringWithFormat:@",%@", strValue3]];
                self.property.rooms = idStr;
            }
                break;
            case AJK_PICKER_ORIENTATION://朝向
            {
                [idStr appendString:strValue1];
                self.property.exposure = idStr;
            }
                break;
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
    
    if ([self.property.price length] == 0) {
        [self showInfo:@"请填写价格"];
        return NO;
    }
    if ([self.property.area length] == 0) {
        [self showInfo:@"请填写面积"];
        return NO;
    }
    if ([self.property.rooms isEqualToString:@""]) {
        [self showInfo:@"请选择户型"];
        return NO;
    }
    if ([self.property.exposure isEqualToString:@""]) {
        [self showInfo:@"请选择朝向"];
        return NO;
    }
    
    if ([self.property.floor isEqualToString:@""]) {
        [self showInfo:@"请选择楼层"];
        return NO;
    }
    if ([self.property.fitment isEqualToString:@""]) {
        [self showInfo:@"请选择装修"];
        return NO;
    }
    if ([self.property.title isEqualToString:@""]) {
        [self showInfo:@"请填写房源标题"];
        return NO;
    }
    if ([self.property.desc isEqualToString:@""]) {
        [self showInfo:@"请填写房源描述"];
        return NO;
    }
    if ([self.property.comm_id isEqualToString:@""]) {
        [self showInfo:@"请选择小区"];
        return NO;
    }
    
    //字段判断
    if ([self.property.area intValue] < 10 || [self.property.area intValue] > 2000) {
        [self showInfo:@"面积范围10至2000平米"];
        return NO;
    }
    
    if (self.isHaozu) { //租房
        if ([self.property.rentType isEqualToString:@""]) {
            [self showInfo:@"请选择出租类型"];
            return NO;
        }
        if ([self.property.price floatValue] < 200 || [[self.property price] floatValue] > 400000) {
            [self showInfo:@"租金范围为200到400000元"];
            return NO;
        }
    }
    else { //二手房
        if ([self.property.price floatValue] < 100000 || [[self.property price] floatValue] > 1000000000) {
            [self showInfo:@"价格范围为10万到100000万元"];
            return NO;
        }
        
//        if (self.property.minDownPay.length <= 0 || [self.property.minDownPay isEqualToString:@""]) {
//            [self showInfo:@"请填写最低首付"];
//            return NO;
//        }
        /*
        if (self.property.minDownPay.length > 0) {
            //最低首付
//            if ([self.property.minDownPay intValue] *10000 < [self.property.price intValue] * 0.3 ) {
//                [self showInfo:@"最低首付不低于房屋价格的30%"];
//                return NO;
//            }
            if ([self.property.minDownPay intValue] * 10000 > [self.property.price intValue]) {
                [self showInfo:@"最低首付不得高于房屋价格"];
                return NO;
            }
            
            if ([self.property.minDownPay floatValue] > [self.property.minDownPay intValue]) {
                [self showInfo:@"最低首付必须为正整数"];
                return NO;
            }
        }*/
    }
    
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
        
//        self.property.minDownPay = [NSString stringWithFormat:@"%f", [[[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_TEXT_LIMIT_PAY] text_Field] text] floatValue] * 1];
        
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

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path
{
    if (!self.isHaozu && path.section == 1 && path.row == 4) {
        
        return nil;
    }
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.view.frame.origin.x > 0) return;
    
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
                case 1: //最低首付、面积
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:NO];
                }
                    break;
                case 2: //面积
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
                case 0: //户型
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:YES];
                    /*
                    [self doPushToHouseTypeVC];
                    [self pickerDisappear]; //每次push进新页面隐藏键盘、picker
                     */
                }
                    break;
                case 1: //楼层
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:YES];
                }
                    break;
                case 2:
                    [self showInputWithIndex:self.selectedIndex isPicker:YES];
                    break;
                case 3: //装修
                {
                    [self showInputWithIndex:self.selectedIndex isPicker:YES];
                }
                    break;
                case 4: //出租方式（仅好租）、特色
                {
                    if (self.isHaozu) {
                        [self showInputWithIndex:self.selectedIndex isPicker:YES];
                    }
                    else { //push to 特色
                        [self showInputWithIndex:self.selectedIndex isPicker:YES];
                        /*
                        PublishFeatureViewController *pf = [[PublishFeatureViewController alloc] init];
                        pf.featureDelegate = self;
                        pf.isFiveYear = [self.property.isFullFive boolValue];
                        pf.isOnlyHouse = [self.property.isOnly boolValue];
                        [self.navigationController pushViewController:pf animated:YES];
                        
                        [self pickerDisappear]; //每次push进新页面，
                         */
                    }
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
                    AnjukeEditTextViewController *ae = [[AnjukeEditTextViewController alloc] init];
                    ae.textFieldModifyDelegate = self;
                    [ae setTitleViewWithString:@"标题"];
                    ae.isTitle = YES;
                    ae.isHZ = self.isHaozu;
                    [ae setTextFieldDetail:self.property.title];
                    [self.navigationController pushViewController:ae animated:YES];
                    
                    [self pickerDisappear]; //每次push进新页面，
                }
                    break;
                case 1: //desc
                {
                    AnjukeEditTextViewController *ae = [[AnjukeEditTextViewController alloc] init];
                    ae.textFieldModifyDelegate = self;
                    [ae setTitleViewWithString:@"描述"];
                    ae.isTitle = NO;
                    ae.isHZ = self.isHaozu;
                    [ae setTextFieldDetail:self.property.desc];
                    [self.navigationController pushViewController:ae animated:YES];
                    
                    [self pickerDisappear]; //每次push进新页面，
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

//housestyle
- (void)houseStyleAction
{

}

#pragma mark - BrokerPickerDelegate

- (void)setToolBarLeftBtnDisable {
    [self.toolBar setDisableWithButton:self.toolBar.leftButton];
    [self.toolBar setNormalWithButton:self.toolBar.rightButton];
}

- (void)setToolBarRightBtnDisable {
    [self.toolBar setNormalWithButton:self.toolBar.leftButton];
    [self.toolBar setDisableWithButton:self.toolBar.rightButton];
}

- (void)setBothToolBarBtnNormal {
    [self.toolBar setNormalWithButton:self.toolBar.leftButton];
    [self.toolBar setNormalWithButton:self.toolBar.rightButton];
}

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
            case HZ_TEXT_PRICE://价格
            {
                [self setToolBarLeftBtnDisable];
                return; //不做处理
            }
                break;
            case HZ_TEXT_AREA://面积
            {
                self.selectedIndex = HZ_TEXT_PRICE;
                self.selectedRow = 0;
                self.selectedSection = 0;
                
                [self setToolBarLeftBtnDisable];
                [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
                return;
            }
                break;
            case HZ_PICKER_ROOMS://户型
            {
                self.selectedIndex = HZ_TEXT_AREA;
                self.selectedRow = 1;
                self.selectedSection = 0;
            }
                break;
            case HZ_PICKER_FLOORS: //楼层
            {
                self.selectedIndex = HZ_PICKER_ROOMS;
                self.selectedRow = 0;
                self.selectedSection = 1;
                isPicker = YES;
            }
                break;
            case HZ_PICKER_ORIENTATION://朝向
            {
                self.selectedIndex = HZ_PICKER_FLOORS;
                self.selectedRow = 1;
                self.selectedSection = 1;
                isPicker = YES;
            }
                break;
            case HZ_PICKER_FITMENT: //装修
            {
                self.selectedIndex = HZ_PICKER_ORIENTATION;
                isPicker = YES;
                self.selectedRow = 2;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_RENTTYPE: //出租方式
            {
                self.selectedIndex = HZ_PICKER_FITMENT;
                isPicker = YES;
                self.selectedRow = 3;
                self.selectedSection = 1;
            }
                break;
                
            default:
                break;
        }
    }
    else {
        switch (self.selectedIndex) {
            case AJK_TEXT_PRICE://价格
            {
                [self setToolBarLeftBtnDisable];
                return; //不做处理
            }
                break;
            case AJK_TEXT_AREA://面积
            {
                self.selectedIndex = AJK_TEXT_PRICE;
                self.selectedRow --;
                self.selectedSection = 0;
                [self setToolBarLeftBtnDisable];
                [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
                return;
                
            }
                break;
            case AJK_PICKER_FLOORS: //楼层
            {
                self.selectedIndex = AJK_PICKER_ROOMS;
                self.selectedRow --;
                self.selectedSection = 1;
                isPicker = YES;
            }
                break;
            case AJK_PICKER_ORIENTATION://朝向
            {
                self.selectedIndex = AJK_PICKER_FLOORS;
                self.selectedRow --;
                self.selectedSection = 1;
                isPicker = YES;
            }
                break;
                
            case AJK_PICKER_FITMENT: //装修
            {
                self.selectedIndex = AJK_PICKER_ORIENTATION;
                self.selectedRow --;
                self.selectedSection = 1;
                isPicker = YES;
            }
                break;
            case AJK_TEXT_SAFENUM://备案号
            {
                self.selectedIndex = AJK_TEXT_AREA;
                self.selectedRow --;
                self.selectedSection = 0;
            }
                break;
            case AJK_PICKER_ROOMS://户型
            {
                self.selectedIndex = AJK_TEXT_AREA;
                if (self.needFileNO && self.isHaozu == NO)
                {//是否有备案号
                    self.selectedRow = 2;
                }else
                {
                    self.selectedRow = 1;
                }
                
                self.selectedSection = 0;
            }
                break;
                
            default:
                break;
        }
    }
    
    [self setBothToolBarBtnNormal];
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
            case HZ_TEXT_PRICE://价格
            {
                self.selectedIndex = HZ_TEXT_AREA;
                self.selectedRow = 1;
                self.selectedSection = 0;
            }
                break;
            case HZ_TEXT_AREA://面积
            {
                self.selectedIndex = HZ_PICKER_ROOMS;
                isPicker = YES;
                self.selectedRow = 0;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_ROOMS://户型
            {
                self.selectedIndex = HZ_PICKER_FLOORS;
                isPicker = YES;
                self.selectedRow = 1;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_FLOORS: //楼层
            {
                self.selectedIndex = HZ_PICKER_ORIENTATION;
                isPicker = YES;
                self.selectedRow = 2;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_ORIENTATION://朝向
            {
                self.selectedIndex = HZ_PICKER_FITMENT;
                isPicker = YES;
                self.selectedRow = 3;
                self.selectedSection = 1;
            }
                break;
            case HZ_PICKER_FITMENT: //装修
            {
                self.selectedIndex = HZ_PICKER_RENTTYPE;
                isPicker = YES;
                self.selectedRow = 3;
                self.selectedSection = 1;
                
                [self setToolBarRightBtnDisable];
                [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
                return;
            }
                break;
            case HZ_PICKER_RENTTYPE: //出租方式
            {
                [self setToolBarRightBtnDisable];
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
                self.selectedIndex = AJK_TEXT_AREA;
                self.selectedRow ++;
                self.selectedSection = 0;
            }
                break;
            /*
            case AJK_TEXT_LIMIT_PAY:
            {
                self.selectedIndex +=1;
                self.selectedRow = 2;
                self.selectedSection = 0;
            }
                break;
             */
            case AJK_TEXT_AREA://面积
            {
                if (self.needFileNO && self.isHaozu == NO)
                {//是否有备案号
                    self.selectedIndex = AJK_TEXT_SAFENUM;
                    
                    self.selectedRow ++ ;
                    self.selectedSection = 0;
                }else
                {
                    self.selectedIndex = AJK_PICKER_ROOMS;
                    
                    isPicker = YES;
                    self.selectedRow = 0;
                    self.selectedSection = 1;
                }
                
            }
                break;
            case AJK_PICKER_ROOMS://户型
            {
                self.selectedIndex = AJK_PICKER_FLOORS;
                isPicker = YES;
                self.selectedRow ++ ;
                self.selectedSection = 1;
            }
                break;
            case AJK_PICKER_FLOORS: //楼层
            {
                self.selectedIndex = AJK_PICKER_ORIENTATION;
                isPicker = YES;
                self.selectedRow ++ ;
                self.selectedSection = 1;
                
//                [self setToolBarRightBtnDisable];
                [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
                return;
            }
                break;
            case AJK_PICKER_ORIENTATION://朝向
            {
                self.selectedIndex = AJK_PICKER_FITMENT;
                isPicker = YES;
                self.selectedRow ++ ;
                self.selectedSection = 1;
                
                [self setToolBarRightBtnDisable];
                [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
                
                return;
            }
                break;
            case AJK_PICKER_FITMENT: //装修
            {
                [self setToolBarRightBtnDisable];
                return; //不做处理
            }
                break;
                
            default:
                break;
        }
    }
    
    [self setBothToolBarBtnNormal];
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
        
        if (self.selectedIndex == 0) {
            [self setToolBarLeftBtnDisable];
        }
        else if (self.selectedIndex == AJK_PICKER_FITMENT && !self.isHaozu) {
            [self setToolBarRightBtnDisable];
        }
        else if (self.selectedIndex == HZ_PICKER_RENTTYPE && self.isHaozu) {
            [self setToolBarRightBtnDisable];
        }
        else
            [self setBothToolBarBtnNormal];
        
        [self showInputWithIndex:self.selectedIndex isPicker:isPicker];
        
    }
}

- (void)textFieldDidEndEdit:(NSString *)text { //暂不可用
    
}

#pragma mark - PhotoFooterImageClickDelegate

- (void)imageDidClickWithIndex:(int)index sender:(PhotoFooterView *)sender{ //图片预览点击
    int imageIndex = index - 0;
    DLog(@"查看大图--index [%d]", imageIndex);
    
    //检查_imdescarr是否存在
    [self initImgDesc];
    
    //查看大图
    //模态弹出图片播放器
    PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
    pb.backType = RTSelectorBackTypeDismiss;
    pb.imageDescArray = _imgdescArr;
    pb.clickDelegate = self;
    
    if (!sender.isHouseType)
    {
        self.footClickType = 1;
    }else
    {
        self.footClickType = 2;
    }
    
    BK_RTNavigationController *navController = [[BK_RTNavigationController alloc] initWithRootViewController:pb];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (self.footClickType == 1) //室内图
    {
        pb.hasTextView = YES; //有照片编辑框
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            [pb showImagesWithArray:self.roomImageArray atIndex:imageIndex];
        }];
    }else if (self.footClickType == 2) //户型图
    {
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            [pb showImagesWithArray:self.houseTypeImageArray atIndex:imageIndex];
        }];
    }
    
    
}

//图片预览点击

- (void)addImageDidClick:(PhotoFooterView *)sender { //添加按钮点击
    if (self.isHaozu) {
        [[BrokerLogger sharedInstance] logWithActionCode:HZ_PROPERTY_011 note:nil];
    }
    else
        [[BrokerLogger sharedInstance] logWithActionCode:AJK_PROPERTY_011 note:nil];
    
    DLog(@"sender.tag == %d", sender.tag);
    
    self.footClickType = sender.tag;
    if (sender.tag == 1)
    {
        self.footerView = [_footerViewDict objectForKey:FOOTERVIEWDICTROOM];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
        sheet.tag = IMAGE_ACTIONSHEET_TAG;
        [sheet showInView:self.view];
    }else if (sender.tag == 2)
    {
        self.footerView = [_footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择在线房型图", @"从手机相册选择", nil];
        sheet.tag = IMAGE_ACTIONSHEET_TAG;
        [sheet showInView:self.view];
    }
        
    
    
    
}

- (void)drawFinishedWithCurrentHeight:(CGFloat)height { //每次重绘后返回当前预览底图的高度
    
    PhotoFooterView *styleFootView = [_footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
    PhotoFooterView *houseFootView = [_footerViewDict objectForKey:FOOTERVIEWDICTROOM];
    
    CGFloat footHeight = CGRectGetHeight(styleFootView.frame) + CGRectGetHeight(houseFootView.frame) + 40;
    
    self.photoBGView.frame = CGRectMake(0, 0, [self windowWidth], footHeight);
    self.tableViewList.tableFooterView = self.photoBGView; //状态改变后需要重新赋值footerView
    
    if (self.footClickType == 1)
    {
        
        CGRect sFootFrame = styleFootView.frame;
        sFootFrame.origin.y = height+22;
        styleFootView.frame = sFootFrame;
    }
}

#pragma mark - PublishBigImageViewClickDelegate

- (void)viewDidFinishWithImageArr:(NSArray *)imageArray sender:(PublishBigImageViewController *)sender{
    
    if (self.footClickType == 1) //室内图
    {
        _imgdescArr = [NSMutableArray arrayWithArray:sender.imageDescArray];
        self.roomImageArray = [NSMutableArray arrayWithArray:imageArray];
    }else if(self.footClickType == 2) //户型图
    {
        self.houseTypeImageArray = [NSMutableArray arrayWithArray:imageArray];
    }
    
    [self.footerView redrawWithImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:imageArray]];
}

- (void)onlineHouseTypeImgDelete {
    //do nothing
}

- (void)editPropertyDidDeleteImgWithDeleteIndex:(int)deleteIndex sender:(id)sender{
    //非编辑房源 do nothing
}

#pragma mark - PublishFeatureDelegate

- (void)didPropertyFeatureSelectWithIsFiveYear:(BOOL)isFiveYear isOnlyHouse:(BOOL)isOnlyHouse {
    if (self.isHaozu) {
        return;
    }
    
    self.property.isFullFive = [NSNumber numberWithBool:isFiveYear];
    self.property.isOnly = [NSNumber numberWithBool:isOnlyHouse];
    
    //set title and property
    NSMutableString *featureStr = [NSMutableString string];
    if (isFiveYear) {
        [featureStr appendString:@"满五年 "];
    }
    
    if (isOnlyHouse) {
        [featureStr appendString:@"唯一住房"];
    }
    
    [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_FEATURE] communityDetailLb] setText:featureStr];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.inPhotoProcessing = YES;
    
    UIImage *image = nil;
    UIImage *newSizeImage = nil;
    
    //    for (NSString *str  in [info allKeys]) {
    //        DLog(@"pickerInfo Keys %@",str);
    //    }
    
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

#pragma mark - PhotoViewClickDelegate

- (void)takePhoto_Click {
    //外部控制最大拍照数量，如果到达上限则不继续拍照
    int count = [[self.imageOverLay imgArray] count]+1;
    DLog(@"拍摄 [%d]", [[self.imageOverLay imgArray] count]);
    
    if (![self canAddMoreImageWithAddCount:count]) {
//        UIAlertView *pickerAlert = [[UIAlertView alloc] initWithTitle:nil message:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:NO] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [pickerAlert show];
        
        return;
    }
    
    if (self.inPhotoProcessing) { //照片处理过程中不拍照
        DLog(@"处理照片呢，二逼啊拍那么快");
        return;
    }
    
    [self.imagePicker takePicture];
}


- (void)closePicker_Click_WithImgArr:(NSMutableArray *)arr sender:(PhotoShowView *)sender{
    for (int i = 0; i < arr.count; i ++) {
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:(UIImage *)[arr objectAtIndex:i] toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        ep.smallPhotoUrl = url;
        
        if (self.footClickType == 1)
        {
            [self.roomImageArray addObject:ep];
        }else if (self.footClickType == 2)
        {
            [self.houseTypeImageArray addObject:ep];
        }
        
    }
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
    
    DLog(@"拍照添加室内图:count[%d]", self.roomImageArray.count);
    DLog(@"sender.tag == %d", sender.tag);
    
    NSArray *willdoArr = self.roomImageArray;
    if (self.footClickType == 1)
    {
        self.footerView = [_footerViewDict objectForKey:FOOTERVIEWDICTROOM];
    }else if (self.footClickType == 2)
    {
        willdoArr = self.houseTypeImageArray;
        self.footerView = [_footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
    }
    
    DLog(@"self.footerView.tag == %d", self.footerView.tag);
    
    //redraw footer img view
    [self.footerView redrawWithImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:willdoArr]];
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    int count = [info count];
    if (![self canAddMoreImageWithAddCount:count]) {
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
        
        if (self.footClickType == 1)
        {
            [self.roomImageArray addObject:ep];
        }else if (self.footClickType == 2)
        {
            [self.houseTypeImageArray addObject:ep];
        }
        
	}
    
    NSArray *willdoArr = self.roomImageArray;
    if (self.footClickType == 2)
    {
        willdoArr = self.houseTypeImageArray;
    }
    
    DLog(@"相册添加室内图:count[%d]", self.roomImageArray.count);
    
    //redraw footer img view
    [self.footerView redrawWithImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:willdoArr]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EditTextView Input Delegate

- (void)textDidInput:(NSString *)string isTitle:(BOOL)isTitle {
    if (isTitle) {
        if (self.isHaozu) {
            [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_CLICK_TITLE] communityDetailLb] setText:string];
        }
        else {
            [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_TITLE] communityDetailLb] setText:string];
        }
        self.property.title = string;
    }
    else {
        if (self.isHaozu) {
            [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_CLICK_DESC] communityDetailLb] setText:string];
        }
        else {
            [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_DESC] communityDetailLb] setText:string];
        }
        self.property.desc = string;
    }
}

#pragma mark - UIActionSheet Delegate

- (void)getCrameAction
{
    if (![self canAddMoreImageWithAddCount:1]) { //到达上限后张就不能继续拍摄
        return; //室内图超出限制
    }
    
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_012;
    }
    else
        code = AJK_PROPERTY_012;
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
    pv.maxImgCount = AJK_MAXCOUNT_ROOMIMAGE;
    if (self.isHaozu) {
        pv.maxImgCount = HZ_MAXCOUNT_ROOMIMAGE;
    }
    pv.currentImgCount = [self getCurrentRoomImgCount]; //self.roomImageArray.count;
    pv.clickDelegate = self;
    
    ipc.cameraOverlayView = self.imageOverLay;
    
    [self presentViewController:ipc animated:YES completion:nil];//选择在线房型图
}

//在线房源选择回调
- (void)onlineImgDidSelect:(NSDictionary *)imgDic
{
    /*
    for (int i = 0; i < arr.count; i ++) {
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:(UIImage *)[arr objectAtIndex:i] toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        ep.smallPhotoUrl = url;
        
        if (self.footClickType == 1)
        {
            [self.roomImageArray addObject:ep];
        }else if (self.footClickType == 2)
        {
            [self.houseTypeImageArray addObject:ep];
        }
        
    }
    
    
    self.onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:imgDic];
    
    //redraw footer img view
    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
     */
}

//在线选择房源
- (void)onlineActionSheet
{
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PROPERTY_007;
    }
    else
        code = AJK_PROPERTY_007;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    //check小区、户型、朝向
    if ([self.property.rooms isEqualToString:@""] || self.property.rooms == nil) {
        [self showInfo:@"请先择户型"];
        return;
    }
    else if ([self.property.exposure isEqualToString:@""] || self.property.exposure == nil) {
        [self showInfo:@"请选择朝向"];
        return;
    }
    
    AnjukeOnlineImgController *ao = [[AnjukeOnlineImgController alloc] init];
    ao.imageSelectDelegate = self;
    ao.property = self.property;
    ao.isHaozu = self.isHaozu;
    [self.navigationController pushViewController:ao animated:NO];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == IMAGE_ACTIONSHEET_TAG) {
        switch (buttonIndex) {
            case 0: //拍照
            {
                if (self.footClickType == 1)
                {
                    [self getCrameAction];
                }else if (self.footClickType == 2)
                {
                    [self onlineActionSheet];
                }
            }
                break;
            case 1: //从手机相册xuan'z
            {
                if (![self canAddMoreImageWithAddCount:1]) { //到达上限后张就不能继续拍摄
                    return; //室内图超出限制
                }
                
                NSString *code = [NSString string];
                if (self.isHaozu) {
                    code = HZ_PROPERTY_013;
                }
                else
                    code = AJK_PROPERTY_013;
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
                
                self.isTakePhoto = NO;
                
                BK_ELCAlbumPickerController *albumPicker = [[BK_ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
                BK_ELCImagePickerController *elcPicker = [[BK_ELCImagePickerController alloc] initWithRootViewController:albumPicker];
                int maxCount = AJK_MAXCOUNT_ROOMIMAGE;
                if (self.isHaozu) {
                    maxCount = HZ_MAXCOUNT_ROOMIMAGE;
                }
                elcPicker.maximumImagesCount = [self getMaxAddRoomImgCountForPhotoAlbum]; //(maxCount - self.roomImageArray.count);
                elcPicker.imagePickerDelegate = self;
                
                [self presentViewController:elcPicker animated:YES completion:nil]; //点击添加室内图, 户型图,加载系统UIImagePickerController
            }
                break;
            default:
                break;
        }
    }
    else if (actionSheet.tag == PUBLISH_ACTIONSHEET_TAG) {
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
                [self prepareUploadImgArr];
                
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
                [self prepareUploadImgArr];
                
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
                [self prepareUploadImgArr];
                
                [self uploadPhoto];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - UIAlert View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
        {
            //test
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextField Delegate

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

#pragma mark - SimpleKeyboardBarClickDelegate

- (void)SK_finishBtnClicked {
    [self.fileNoTextF resignFirstResponder];
    
    self.property.fileNo = self.fileNoTextF.text;
}

@end
