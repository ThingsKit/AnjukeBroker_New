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
#import "PublishBuildingViewController.h"
#import "BrokerLineView.h"
#import "AppManager.h"

#define SELECT_BTN_TAG 1000

@interface PublishHouseTypeViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
@property int selectedIndex; //记录当前点选的row对应的cellDataSource对应的indexTag
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘

@property int houseType_inputedRow0;
@property int houseType_inputedRow1;
@property int houseType_inputedRow2;

@property int exposure_inputedRow0;
@property int exposure_inputedRow1;
@property int exposure_inputedRow2;

@property (nonatomic, strong) NSMutableArray *lastHouseTypeImgArr; //上一次的户型图arr，用于取消时将户型图还原 T T

@end

@implementation PublishHouseTypeViewController
@synthesize isHaozu;
@synthesize dataArray;
@synthesize houseTypeTF, exposureTF;
@synthesize inputingTextF;
@synthesize houseType_inputedRow0, houseType_inputedRow1, houseType_inputedRow2;
@synthesize exposure_inputedRow0, exposure_inputedRow1, exposure_inputedRow2;
@synthesize superViewController;
@synthesize property;
@synthesize lastExposure, lastRooms;
@synthesize footerView;
@synthesize houseTypeImageArr;
@synthesize imageOverLay;
@synthesize imagePicker;
@synthesize isTakePhoto;
@synthesize inPhotoProcessing;
@synthesize lastHouseTypeImgArr;
@synthesize onlineHouseTypeDic;
@synthesize lastRoomValue, lastHallValue, lastToiletValue;

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
    
//    [self addRightButton:@"保存" andPossibleTitle:nil];
    UIBarButtonItem *rBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonAction:)];
    if (![AppManager isIOS6]) {
        rBtn.tintColor = SYSTEM_NAVIBAR_COLOR;
    }
    self.navigationItem.leftBarButtonItem = rBtn;
    
    self.lastRooms = [NSString stringWithString:self.property.rooms];
    self.lastExposure = [NSString stringWithString:self.property.exposure];
    
    [self setLastDefultValueAndShowImg];
    [self setDefultValue];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.houseTypeTF && self.isFirstShow) {
        [self.houseTypeTF becomeFirstResponder];
        self.isFirstShow = NO;
    }
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
        code = HZ_HOUSETYPE_001;
    }
    else
        code = AJK_HOUSETYPE_001;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_HOUSETYPE_002;
    }
    else
        code = AJK_HOUSETYPE_002;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - init Method

- (void)setLastDefultValueAndShowImg {
    
    for (int i = 0; i < self.houseTypeImageArr.count; i ++) {
        [self.lastHouseTypeImgArr addObject:[self.houseTypeImageArr objectAtIndex:i]];
    }
    
    self.onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
    
    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

- (void)initModel {
    self.dataArray = [NSMutableArray array];
    
    self.lastRooms = [NSString string];
    self.lastExposure = [NSString string];
    self.lastHouseTypeImgArr = [NSMutableArray array];
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
        
        BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, btn.frame.size.height - BL_HEIGHT, btn.frame.size.width, BL_HEIGHT)];
        [btn addSubview:line];
        
        UILabel *comTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(15, (btn.frame.size.height - 20)/2, 100, 20)];
        comTitleLb.backgroundColor = [UIColor clearColor];
        if (i == 0) {
            comTitleLb.text = @"户型";
        }
        else
            comTitleLb.text = @"朝向";
        comTitleLb.textColor = SYSTEM_DARK_GRAY;
        comTitleLb.font = [UIFont systemFontOfSize:17];
        [btn addSubview:comTitleLb];
        
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
        cellTextField.delegate = self;
        if (i == 0) {
            self.houseTypeTF = cellTextField;
        }
        else {
            self.exposureTF = cellTextField;
        }
        [btn addSubview:cellTextField];
    }
    
    [self drawFooter];
}

- (void)drawFooter {
    UIView *photoBGV = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT*2 + PUBLISH_SECTION_HEIGHT, [self windowWidth], PUBLISH_SECTION_HEIGHT + PF_EMPTY_IMAGE_HEIGHT)];
    photoBGV.backgroundColor = [UIColor clearColor];
    self.photoBGView = photoBGV; //预览图底板
    photoBGV.clipsToBounds = YES;
    [self.view addSubview:photoBGV];
    
    PhotoFooterView *pf = [[PhotoFooterView alloc] initWithFrame:CGRectMake(0, PUBLISH_SECTION_HEIGHT, [self windowWidth], PF_EMPTY_IMAGE_HEIGHT)];
    pf.clickDelegate = self;
    self.footerView = pf;
    [photoBGV addSubview:pf];
}

#pragma mark - Private Method

- (void)setDefultValue {
    if (self.property.rooms.length > 0) { //户型已有录入
        //设置户型的row-index和title
        NSString *roomValue = [NSString stringWithFormat:@"%d", [(PublishBuildingViewController *)self.superViewController roomValue]];
        NSString *hallValue = [NSString stringWithFormat:@"%d", [(PublishBuildingViewController *)self.superViewController hallValue]];
        NSString *toiletValue = [NSString stringWithFormat:@"%d", [(PublishBuildingViewController *)self.superViewController toiletValue]];
        
        self.lastRoomValue = [NSString stringWithString:roomValue];
        self.lastHallValue = [NSString stringWithString:hallValue];
        self.lastToiletValue = [NSString stringWithString:toiletValue];
        
        self.houseType_inputedRow0 = [PublishDataModel getRoomIndexWithValue:roomValue];
        self.houseType_inputedRow1 = [PublishDataModel getHallIndexWithValue:hallValue];
        self.houseType_inputedRow2 = [PublishDataModel getToiletIndexWithValue:toiletValue];
        
        NSString *name = [PublishDataModel getRoomTitleWithIndex:self.houseType_inputedRow0];
        NSString *name2 = [PublishDataModel getHallTitleWithIndex:self.houseType_inputedRow1];
        NSString *name3 = [PublishDataModel getToiletTitleWithIndex:self.houseType_inputedRow2];
        
        self.houseTypeTF.text = [NSString stringWithFormat:@"%@%@%@", name, name2, name3];
    }
    
    if (self.property.exposure.length > 0) { //朝向已有录入
        //设置朝向的row-index和title
        self.exposureTF.text = [PublishDataModel getExposureTitleWithValue:self.property.exposure];
        self.exposure_inputedRow0 = [PublishDataModel getExposureIndexWithTitle:self.exposureTF.text];
    }
}

- (void)buttonDidSelect:(id)sender {
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag - SELECT_BTN_TAG;
    BOOL isHouseType = NO;
    
    self.selectedIndex = index;
    
    if (index == INDEX_HOUSETYPE) {
        //户型
        self.inputingTextF = self.houseTypeTF;
        isHouseType = YES;
        
        NSString *code = [NSString string];
        if (self.isHaozu) {
            code = HZ_HOUSETYPE_003;
        }
        else
            code = AJK_HOUSETYPE_003;
        [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    }
    else { //朝向
        NSString *code = [NSString string];
        if (self.isHaozu) {
            code = HZ_HOUSETYPE_004;
        }
        else
            code = AJK_HOUSETYPE_004;
        [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
        
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
        
        //设置室
        [(PublishBuildingViewController *)self.superViewController setRoomValue:[strValue1 intValue]];
    }
    else {
        self.exposure_inputedRow0 = index1;
    }
    
    if ([self.pickerView.secondArray count] > 0) {
        int index2 = [self.pickerView selectedRowInComponent:1];
        NSString *string2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Title"];
        [string appendString:string2];
        
        strValue2 = [[[self.pickerView secondArray] objectAtIndex:index2] objectForKey:@"Value"];
        
        if (self.selectedIndex == INDEX_HOUSETYPE) { //户型
            self.houseType_inputedRow1 = index2;
            
            //设置厅
            [(PublishBuildingViewController *)self.superViewController setHallValue:[strValue2 intValue]];
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
            
            //设置卫
            [(PublishBuildingViewController *)self.superViewController setToiletValue:[strValue2 intValue]];
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

- (void)rightButtonAction:(id)sender { //do save
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_HOUSETYPE_007;
    }
    else
        code = AJK_HOUSETYPE_007;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    if ([self.superViewController isKindOfClass:[PublishBuildingViewController class]]) {
        [[(PublishBuildingViewController *)self.superViewController property] setOnlineHouseTypeDic:[NSDictionary dictionaryWithDictionary:self.onlineHouseTypeDic]];//赋值新在线户型图数据
        
        NSString *houseTypeName = [NSString stringWithFormat:@"%@  %@", self.houseTypeTF.text, self.exposureTF.text];
        
        //设置房型文案显示
        [(PublishBuildingViewController *)self.superViewController setHouseTypeShowWithString:houseTypeName];
        [(PublishBuildingViewController *)self.superViewController setHouseTypeImageArray:self.houseTypeImageArr]; //设置户型图
    }
    [super doBack:self];
}

- (void)doBack:(id)sender {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_HOUSETYPE_006;
    }
    else
        code = AJK_HOUSETYPE_006;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    if ([self.superViewController isKindOfClass:[PublishBuildingViewController class]]) {
        [[(PublishBuildingViewController *)self.superViewController property] setRooms:self.lastRooms];
        [[(PublishBuildingViewController *)self.superViewController property] setExposure:self.lastExposure];//还原上一次的输入
        
        [(PublishBuildingViewController *)self.superViewController setRoomValue:[self.lastRoomValue intValue]];
        [(PublishBuildingViewController *)self.superViewController setHallValue:[self.lastHallValue intValue]];
        [(PublishBuildingViewController *)self.superViewController setToiletValue:[self.lastToiletValue intValue]];
        
        [(PublishBuildingViewController *)self.superViewController setHouseTypeImageArray:self.lastHouseTypeImgArr]; //还原户型图
    }
    
    [super doBack:self];
}

#pragma mark - Check Method

//是否能添加更多室内图
- (BOOL)canAddMoreImageWithAddCount:(int)addCount{
    int maxCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
    if (self.isHaozu) {
        maxCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
    }
    
    if (self.onlineHouseTypeDic.count > 0) {
        if (addCount + self.houseTypeImageArr.count +1 > maxCount ) {
            [self showInfo:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:YES]];
            return NO; //超出
        }
    }
    else  {
        if (addCount + self.houseTypeImageArr.count > maxCount ){
            [self showInfo:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:YES]];
            return NO; //超出
        }
    }
    
    return YES;
}

//当前已有的室内图数量
- (int)getCurrentHouseTypeImgCount {
    if (self.onlineHouseTypeDic.count > 0) {
        return self.houseTypeImageArr.count + 1;
    }
    return self.houseTypeImageArr.count;
}

//相册还可添加的图片数量
- (int)getMaxAddHouseTypeImgCountForPhotoAlbum {
    int maxCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
    if (self.isHaozu) {
        maxCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
    }
    
    if (self.onlineHouseTypeDic.count > 0) {
        return (maxCount - self.houseTypeImageArr.count -1);
    }
    
    return (maxCount - self.houseTypeImageArr.count);
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

#pragma mark - PhotoFooterImageClickDelegate

- (void)imageDidClickWithIndex:(int)index { //图片预览点击
    if (self.onlineHouseTypeDic.count > 0) { //有在线户型图
        if (self.houseTypeImageArr.count != 0 && index <= self.houseTypeImageArr.count - 1) { //户型图
            //查看大图
            DLog(@"查看大图有在线户型图--index [%d]", index);
            
            //模态弹出图片播放器
            PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
            pb.clickDelegate = self;
            RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController presentViewController:navController animated:YES completion:^(void) {
                [pb showImagesWithArray:self.houseTypeImageArr atIndex:index];
            }];
        }
        else { //在线户型图
            DLog(@"在线户型图查看大图--index [%d]", index);
            //模态弹出图片播放器
            PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
            pb.clickDelegate = self;
            RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController presentViewController:navController animated:YES completion:^(void) {
                [pb showImagesForOnlineHouseTypeWithDic:self.onlineHouseTypeDic];
            }];
        }
    }
    else { //无在线户型图
        DLog(@"查看大图无在线户型图--index [%d]", index);
        
        //查看大图
        //模态弹出图片播放器
        PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
        pb.clickDelegate = self;
        RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            [pb showImagesWithArray:self.houseTypeImageArr atIndex:index];
        }];
    }
}

- (void)addImageDidClick { //添加按钮点击
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"选择在线房型图", @"拍照", @"从手机相册选择", nil];
    [sheet showInView:self.view];
}

- (void)drawFinishedWithCurrentHeight:(CGFloat)height { //每次重绘后返回当前预览底图的高度
    self.photoBGView.frame = CGRectMake(0, CELL_HEIGHT*2 + PUBLISH_SECTION_HEIGHT, [self windowWidth], PUBLISH_SECTION_HEIGHT + height);
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

#pragma mark - PhotoViewClickDelegate

- (void)takePhoto_Click {
    //外部控制最大拍照数量，如果到达上限则不继续拍照
    int count = [[self.imageOverLay imgArray] count]+1;
    DLog(@"拍摄 [%d]", [[self.imageOverLay imgArray] count]);
    
    if (![self canAddMoreImageWithAddCount:count]) {
//        UIAlertView *pickerAlert = [[UIAlertView alloc] initWithTitle:nil message:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:YES] delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//        [pickerAlert show];
        
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
        
        [self.houseTypeImageArr addObject:ep];
    }
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
    
    DLog(@"拍照添加房型图:count[%d]", self.houseTypeImageArr.count);
    
    //redraw footer img view
    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

#pragma mark - Online Img Select Delegate

- (void)onlineImgDidSelect:(NSDictionary *)imgDic {
    DLog(@"在线房形图Data--[%@]", imgDic);
    self.onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:imgDic];
    
    //redraw footer img view
    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

#pragma mark - PublishBigImageViewClickDelegate

- (void)viewDidFinishWithImageArr:(NSArray *)imageArray {
    self.houseTypeImageArr = [NSMutableArray arrayWithArray:imageArray];
    
    //redraw footer img view
    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

- (void)onlineHouseTypeImgDelete {
    self.onlineHouseTypeDic = [NSDictionary dictionary];
    
    //redraw footer img view
    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
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
        
        [self.houseTypeImageArr addObject:ep];
	}
    
    DLog(@"相册添加室内图:count[%d]", self.houseTypeImageArr.count);
    
    //redraw footer img view
    [self.footerView redrawWithHouseTypeImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.houseTypeImageArr] andImgUrl:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: { //在线房型图
            if (![self canAddMoreImageWithAddCount:1]) { //到达上限后张就不能继续拍摄
                return; //室内图超出限制
            }
            
            NSString *code = [NSString string];
            if (self.isHaozu) {
                code = HZ_HOUSETYPE_004;
            }
            else
                code = AJK_HOUSETYPE_004;
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
            break;
        case 1: //拍照
        {
            if (![self canAddMoreImageWithAddCount:1]) { //到达上限后张就不能继续拍摄
                return; //室内图超出限制
            }
            
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
            pv.maxImgCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
            if (self.isHaozu) {
                pv.maxImgCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
            }
            pv.currentImgCount = [self getCurrentHouseTypeImgCount];//self.houseTypeImageArr.count;
            pv.clickDelegate = self;
            
            ipc.cameraOverlayView = self.imageOverLay;
            
            [self presentViewController:ipc animated:YES completion:nil];
        }
            break;
        case 2: //相册
        {
            if (![self canAddMoreImageWithAddCount:1]) { //到达上限后张就不能继续拍摄
                return; //室内图超出限制
            }
            
            NSString *code = [NSString string];
            if (self.isHaozu) {
                code = HZ_PROPERTY_006;
            }
            else
                code = AJK_PROPERTY_006;
            [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
            
            self.isTakePhoto = NO;
            
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
            int maxCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
            if (self.isHaozu) {
                maxCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
            }
            if (self.onlineHouseTypeDic.count > 0) {
                maxCount --;
            }
            elcPicker.maximumImagesCount = [self getMaxAddHouseTypeImgCountForPhotoAlbum];//(maxCount - self.houseTypeImageArr.count);
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

@end
