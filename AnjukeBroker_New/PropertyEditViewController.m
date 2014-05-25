//
//  PropertyEditViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-29.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyEditViewController.h"
#import "PublishHouseTypeEditViewController.h"
#import "BigZhenzhenButton.h"

@interface PropertyEditViewController ()

@property int deleteShowedImgIndex; //需要删除的已有图片的index
@property (nonatomic, strong) BigZhenzhenButton *deleteButton;
@property (nonatomic, strong) NSMutableArray *roomImageDetailArr;

@end

#define EDIT__PROPERTY_FINISH @"房源信息已更新"

@implementation PropertyEditViewController
@synthesize propertyID;
@synthesize addHouseTypeImageArray, addRoomImageArray;
@synthesize roomShowedImgArray, houseTypeShowedImgArray;
@synthesize propertyDelegate;
@synthesize deleteShowedImgIndex;
@synthesize deleteButton;
@synthesize roomImageDetailArr;
@synthesize footClickType = _footClickType;//操作foot的tag

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
    
    [self setTitleViewWithString:@"房源编辑"];
    [self doRequestProp];
    
    //页面可见log
    [[BrokerLogger sharedInstance] logWithActionCode:HZ_PPC_RESET_001 note:[NSDictionary dictionaryWithObjectsAndKeys:self.propertyID, @"bp", nil]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //房型图是否多图的icon显示
    BOOL show = NO;
    if (self.addHouseTypeImageArray.count + self.houseTypeShowedImgArray.count > 0) {
        show = YES;
    }
    [self.cellDataSource houseTypeCellImageIconShow:show isHaozu:self.isHaozu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)initModel {
    [super initModel];
    
    self.addRoomImageArray = [NSMutableArray array];
    self.addHouseTypeImageArray = [NSMutableArray array];
    
    self.roomShowedImgArray = [NSMutableArray array];
    self.houseTypeShowedImgArray = [NSMutableArray array];
    
}

- (void)initDisplay {
    [super initDisplay];
    
}

- (void)drawFooter {
    [super drawFooter];
}

- (void)setPropertyWithDic:(NSDictionary *)dic {
    self.property = [PublishDataModel getNewPropertyObject];
    
    if ([LoginManager needFileNOWithCityID:[LoginManager getCity_id]] && !self.isHaozu) { //仅二手房发房需要备案号
        self.property.fileNo = [dic objectForKey:@"fileNo"];
        self.fileNoTextF.text = [dic objectForKey:@"fileNo"];
    }
    
    //数据赋值，映射，得到显示值
    //户型
    self.property.rooms = [NSString stringWithFormat:@"%@,%@,%@", [dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"]];
    self.roomValue = [[dic objectForKey:@"roomNum"] intValue];
    self.hallValue = [[dic objectForKey:@"hallNum"] intValue];
    self.toiletValue = [[dic objectForKey:@"toiletNum"] intValue];
    
    //面积
    self.property.area = [dic objectForKey:@"area"];
    //价格
    self.property.price = [dic objectForKey:@"price"];
    //装修
    self.property.fitment = [dic objectForKey:@"fitment"];
    if (!self.isHaozu) {
        NSString *fitmentVaule = [PublishDataModel getFitmentVauleWithTitle:[dic objectForKey:@"fitment"] forHaozu:self.isHaozu];
        self.property.fitment = fitmentVaule;
    }
    //朝向
    self.property.exposure = [dic objectForKey:@"exposure"];
    //楼层
    self.property.floor = [NSString stringWithFormat:@"%@,%@", [dic objectForKey:@"floor"], [dic objectForKey:@"floorNum"]];
    //title
    self.property.title = [dic objectForKey:@"title"];
    
    //desc
    self.property.desc = [dic objectForKey:@"description"];
    
    //image
    self.roomShowedImgArray = [dic objectForKey:@"roomImg"];
    self.houseTypeShowedImgArray = [dic objectForKey:@"moduleImg"];
    
    //设置小区名字
    //小区
    self.property.comm_id = [dic objectForKey:@"commId"];
    self.communityDetailLb.text = [dic objectForKey:@"commName"];
    self.communityDetailAdLb.text = [dic objectForKey:@"commAddress"];
    
    //户型、朝向
    NSString *roomStr = [NSString stringWithFormat:@"%@室%@厅%@卫",[dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"]];
    NSString *houseTypeName = [NSString stringWithFormat:@"%@", roomStr];
    [self setHouseTypeShowWithString:houseTypeName vDict:dic];
    
    //房型图是否多图的icon显示
    BOOL show = NO;
    if (self.addHouseTypeImageArray.count + self.houseTypeShowedImgArray.count > 0) {
        show = YES;
    }
    [self.cellDataSource houseTypeCellImageIconShow:show isHaozu:self.isHaozu];
    
    if (self.isHaozu) { //租房
        //Text
        //price
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_TEXT_PRICE] text_Field] setText:self.property.price];
        //area
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_TEXT_AREA] text_Field] setText:self.property.area];
        
        //title
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_CLICK_TITLE] communityDetailLb] setText:self.property.title];
        //desc
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_CLICK_DESC] communityDetailLb] setText:self.property.desc];
        
        //Picker Data
        //出租方式
        self.property.rentType = [dic objectForKey:@"shareRent"];
        NSString *rentStr = [PublishDataModel getRentTypeTitleWitValue:self.property.rentType];
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_RENTTYPE] text_Field] setText:rentStr];
        
        //装修
        NSString *fitmentStr = [PublishDataModel getFitmentTitleWithValue:self.property.fitment forHaozu:self.isHaozu];
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FITMENT] text_Field] setText:fitmentStr];
        
        //楼层
        NSString *floorStr = [NSString stringWithFormat:@"%@楼共%@层",[dic objectForKey:@"floor"], [dic objectForKey:@"floorNum"]];
        [[[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FLOORS] text_Field] setText:floorStr];
        
        //设置各picker展示时，初始数据所在行
        //出租方式
        int rentIndex = [PublishDataModel getRentTypeIndexWithValue:self.property.rentType];
        [[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_RENTTYPE] setInputed_RowAtCom0:rentIndex];
        //装修
        int fitmentIndex = [PublishDataModel getFitmentIndexWithTitle:[dic objectForKey:@"fitment"] forHaozu:self.isHaozu];
        [[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FITMENT] setInputed_RowAtCom0:fitmentIndex];
        //楼层
        //楼
        int floorIndex = [PublishDataModel getFloorIndexWithValue:[dic objectForKey:@"floor"]];
        [[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FLOORS] setInputed_RowAtCom0:floorIndex];
        //层
        int profloorIndex = [PublishDataModel getProFloorIndexWithValue:[dic objectForKey:@"floorNum"]];
        [[[self.cellDataSource inputCellArray] objectAtIndex:HZ_PICKER_FLOORS] setInputed_RowAtCom1:profloorIndex];
        
    }
    else { //二手房
        
        //price
        NSString *priceValue = [NSString stringWithFormat:@"%d", [self.property.price intValue]/10000];
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_TEXT_PRICE] text_Field] setText:priceValue];
        //area
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_TEXT_AREA] text_Field] setText:self.property.area];
        
        //title
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_TITLE] communityDetailLb] setText:self.property.title];
        //desc
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_DESC] communityDetailLb] setText:self.property.desc];
        
        //Picker Data
        //装修 二手房直接返回title
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FITMENT] text_Field] setText:[dic objectForKey:@"fitment"]];
        
        //楼层
        NSString *floorStr = [NSString stringWithFormat:@"%@楼共%@层",[dic objectForKey:@"floor"], [dic objectForKey:@"floorNum"]];
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FLOORS] text_Field] setText:floorStr];
        
        //设置各picker展示时，初始数据所在行
        //装修
        int fitmentIndex = [PublishDataModel getFitmentIndexWithTitle:[dic objectForKey:@"fitment"] forHaozu:self.isHaozu];
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FITMENT] setInputed_RowAtCom0:fitmentIndex];
        //楼层
        //楼
        int floorIndex = [PublishDataModel getFloorIndexWithValue:[dic objectForKey:@"floor"]];
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FLOORS] setInputed_RowAtCom0:floorIndex];
        //层
        int profloorIndex = [PublishDataModel getProFloorIndexWithValue:[dic objectForKey:@"floorNum"]];
        [[[self.cellDataSource inputCellArray] objectAtIndex:AJK_PICKER_FLOORS] setInputed_RowAtCom1:profloorIndex];
        
        //最低首付
//        self.property.minDownPay = dic[@"minDownPay"];
//        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_TEXT_LIMIT_PAY] text_Field] setText:self.property.minDownPay];
        
        //是否满五年
        self.property.isOnly = [NSNumber numberWithInt:[[dic objectForKey:@"isOnly"] intValue]];
        self.property.isFullFive = [NSNumber numberWithInt:[[dic objectForKey:@"isFullFive"] intValue]];
        
        //set Text
        //set title and property
        /*NSMutableString *featureStr = [NSMutableString string];
        if ([self.property.isFullFive boolValue] == YES) {
            [featureStr appendString:@"满五年 "];
        }
        
        if ([self.property.isOnly boolValue] == YES) {
            [featureStr appendString:@"唯一住房"];
        }
        
        [[[[self.cellDataSource inputCellArray] objectAtIndex:AJK_CLICK_FEATURE] communityDetailLb] setText:featureStr];*/
    }
    
    DLog(@"*** 编辑房源property 【%@】", self.property);
}

//点击的预览图片是否是新添加的图片
- (BOOL)isClickImgNewAddWithClickIndex:(int)clickIndex imgType:(int)type{
    BOOL isNewAdd = NO;
    
    if (type == 1)
    {//室内图
        if (clickIndex >= self.roomShowedImgArray.count) {
            isNewAdd = YES;
        }
    }else if (type == 2)
    {//户型图
        if (clickIndex >= self.houseTypeShowedImgArray.count) {
            isNewAdd = YES;
        }
    }
    
    
    return isNewAdd;
}

#pragma mark - Request Method
//房源信息请求
- (void)doRequestProp {
    [self showLoadingActivity:YES];
    
    NSDictionary *params = nil;
    NSString *methodStr = [NSString string];
    
    if (self.isHaozu) {
        methodStr = @"zufang/prop/getpropdetail/";
        params = [NSDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", nil];
    }
    else { //二手房
        methodStr = @"anjuke/prop/getpropdetail/";
        params = [NSDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", nil];
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:methodStr params:params target:self action:@selector(onGetProp:)];
}

- (void)onGetProp:(RTNetworkResponse *)response {
    DLog(@"---get Detail---response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        
        return;
    }
    
    NSDictionary *dic = [[[response content] objectForKey:@"data"] objectForKey:@"propInfo"];
    
    //处理imgNewArr信息
//    self.roomImageDetailArr = ;
    
    //保存房源详情 //映射到房源object，并遍历得到每个数据的index
    [self setPropertyWithDic:dic];
    
    //redraw footer img view
    NSArray *addImgArr = [PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray];
    NSArray *showImgArr = [PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray];
    
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.addRoomImageArray];
    [newArr addObjectsFromArray:self.roomShowedImgArray];
    [self addImgDesc:newArr];
    
    self.footerView = [self.footerViewDict objectForKey:FOOTERVIEWDICTROOM];
    [self.footerView redrawWithEditRoomImageArray:addImgArr andImgUrl:showImgArr];
    
    CGFloat height = CGRectGetHeight(self.footerView.frame);
    
    NSArray *addHouseImgArr = [PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray];
    NSArray *showHouseImgArr = [PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray];
    NSDictionary *onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
    
    self.footerView = [self.footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
    
    [self.footerView redrawWithEditHouseTypeShowedImageArray:showHouseImgArr andAddImgArr:addHouseImgArr andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:onlineHouseTypeDic]];
    
    CGRect sFootFrame = self.footerView.frame;
    sFootFrame.origin.y = height + 22;
    self.footerView.frame = sFootFrame;
    
    [self hideLoadWithAnimated:YES];
}

//给img设置desc
- (void)addImgDesc:(NSArray *)arr
{
    
    for (int i = 0; i < arr.count; i++)
    {
        if([[arr objectAtIndex:i] isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = [arr objectAtIndex:i];
            if ([[dict allKeys] containsObject:@"imgDesc"])
            {
                NSString *v = [dict objectForKey:@"imgDesc"];
                if (v)
                {
                    [self.imgdescArr insertObject:v atIndex:i];
                }else
                {
                    [self.imgdescArr insertObject:@"" atIndex:i];
                }
                
            }
        }
        
    }
}

//图片删除
- (void)doDeleteImgWithImgID:(NSString *)imgID {
    if (![self isNetworkOkay]) {
        return;
    }
    
    [self showLoadingActivity:YES];
    
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", imgID, @"aids", nil];
    method = @"img/delimg/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onDeleteImgFinished:)];
}

- (void)onDeleteImgFinished:(RTNetworkResponse *)response {
    DLog(@"--。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
//    [self showInfo:@"图片已删除"];
    
    
    if (self.footClickType == 1)
    {
        [self.roomShowedImgArray removeObjectAtIndex:self.deleteShowedImgIndex];
        [self.footerView redrawWithEditRoomImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray] andImgUrl:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray]];
    }else if(self.footClickType == 2)
    {
        [self.houseTypeShowedImgArray removeObjectAtIndex:self.deleteShowedImgIndex];
        NSArray *addHouseImgArr = [PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray];
        NSArray *showHouseImgArr = [PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray];
        NSDictionary *onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
        
        self.footerView = [self.footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
        
        [self.footerView redrawWithEditHouseTypeShowedImageArray:showHouseImgArr andAddImgArr:addHouseImgArr andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:onlineHouseTypeDic]];
    }
    //redraw footer img view
    
    
    [self hideLoadWithAnimated:YES];
}

//更新房源信息
- (void)doSave {
    if (self.isLoading == YES) {
        return;
    }
    
    [self pickerDisappear];
    
    if (![self checkUploadProperty]) {
        return;
    }
    
    if (![self isNetworkOkay]) {
        return;
    }
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_PPC_RESET_004;
    }
    else
        code = AJK_PPC_RESET_004;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    [self showLoadingActivity:YES];
    
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    [self setTextFieldForProperty];
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", self.property.comm_id, @"commId", self.property.rooms, @"rooms", self.property.area, @"area", self.property.price, @"price", self.property.fitment, @"fitment", self.property.exposure, @"exposure", self.property.floor, @"floor", self.property.title, @"title", self.property.desc, @"description", self.propertyID, @"propId",self.property.fileNo, @"fileNo", nil];
    method = @"anjuke/prop/update/";
    
    if (self.isHaozu) {
        [params setObject:self.property.rentType forKey:@"shareRent"]; //租房新增出租方式
        method = @"zufang/prop/update/";
    }
    else { //二手房新增是否满五年、是否唯一、最低首付字段
        self.property.isOnly = [NSNumber numberWithBool:[self onlyRadioValue:false getV:true]];
        self.property.isFullFive = [NSNumber numberWithBool:[self fiveRadioValue:false getV:true]];
        
        [params setObject:[self.property.isOnly stringValue] forKey:@"isOnly"];
        [params setObject:[self.property.isFullFive stringValue] forKey:@"isFullFive"];
//        [params setObject:self.property.minDownPay forKey:@"minDownPay"];
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onUpdatePropertyFinished:)];
}

- (void)onUpdatePropertyFinished:(RTNetworkResponse *)response {
    DLog(@"--更新房源信息结束。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //保存房源id
    //    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self prepareUploadImgArr];
    [self uploadNewImgToProperty]; //问题信息更新结束，开始新增图片上传
    //    [self hideLoadWithAnimated:YES];
}

//上传新图片
- (void)uploadNewImgToProperty {
    if (self.uploadImageArray.count == 0) {
        if ([self.property.onlineHouseTypeDic count] > 0) { //无图片但有在线户型图，需要上传在线户型图
            [self updateNewImg];
            return;
        }
        
        //无新图片和在线户型图，则返回
        [self hideLoadWithAnimated:YES];
        
        [self showInfo:EDIT__PROPERTY_FINISH];
        [self dismissViewControllerAnimated:YES completion:nil]; //没有更新图片，直接退出
        
        return; //没有上传图片
    }
    
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        
        return;
    }
    
    //上传新添加的图片
    if (self.uploadImgIndex > self.uploadImageArray.count - 1) {
        //        [self hideLoadWithAnimated:YES];
        
        DLog(@"图片上传服务器完毕，结束");
        
        //        [self dismissViewControllerAnimated:YES completion:nil];
        //调用图片接口更新图片
        [self updateNewImg];
        
        return;
    }
    
    if (self.uploadImgIndex == 0) { //第一张图片开始上传就显示黑框，之后不重复显示，上传流程结束后再消掉黑框
        //        [self showLoadingActivity:YES];
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
    
    DLog(@"image upload result[%@]", result);
    
    //保存imageDic在E_Photo
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[result objectForKey:@"image"]];
    if (self.isHaozu) {
        if (self.uploadImgIndex < self.uploadImg_houseTypeIndex) { //属于室内图类型
            [self initImgDesc];
            if ((self.uploadRoomImgDescIndex <= ([self.imgdescArr count] - 1)) && self.imgdescArr.count > 0)
            {
                DLog(@"desc === %@", [self.imgdescArr objectAtIndex:self.uploadRoomImgDescIndex]);
                [dic setObject:[self.imgdescArr objectAtIndex:self.uploadRoomImgDescIndex] forKey:@"imageDesc"];
                self.uploadRoomImgDescIndex++;
            }
            [dic setObject:@"1" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
        }
        else //属于房型图类型
            [dic setObject:@"2" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
    }
    else //二手房
    {
        if (self.uploadImgIndex < self.uploadImg_houseTypeIndex) { //属于室内图类型
            [dic setObject:@"2" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
            [self initImgDesc];
            if ((self.uploadRoomImgDescIndex <= ([self.imgdescArr count] - 1)) && self.imgdescArr.count > 0)
            {
                DLog(@"desc === %@", [self.imgdescArr objectAtIndex:self.uploadRoomImgDescIndex]);
                [dic setObject:[self.imgdescArr objectAtIndex:self.uploadRoomImgDescIndex] forKey:@"imageDesc"];
                self.uploadRoomImgDescIndex++;
            }
        }
        else //属于房型图类型
            [dic setObject:@"3" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
    }
    
    if (self.uploadImgIndex <= self.uploadImageArray.count -1) { //
        [(E_Photo *)[self.uploadImageArray objectAtIndex:self.uploadImgIndex] setImageDic:dic];
        //继续上传图片
        self.uploadImgIndex ++;
        [self uploadNewImgToProperty];
    }
    else {
        //        [self hideLoadWithAnimated:YES];
        
        DLog(@"图片上传服务器完毕，结束");
        
        //        [self dismissViewControllerAnimated:YES completion:nil];
        //调用图片接口更新图片
        [self updateNewImg];
        
        return;
    }
}

- (void)uploadPhotoFail:(ASIFormDataRequest *)request{
    NSDictionary *result = [request.responseString JSONValue];
    RTNetworkResponse *response = [[RTNetworkResponse alloc] init];
    [response setContent:result];
    
    self.uploadRoomImgDescIndex = 0;
    
    self.uploadImgIndex = 0;
    
    [self showInfo:@"图片上传失败，请重试"];
    
    [self hideLoadWithAnimated:YES];
}

- (void)updateNewImg {
    //    [self showLoadingActivity:YES];
    
    //更新图片接口，上传imgJson+房源ID
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    self.property.imageJson = [self getImageJson];
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.propertyID, @"propId", self.property.imageJson, @"imageJson", [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", nil];
    method = @"img/addimg/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onUpdateNewImageForPeopertyFinished:)];
}

- (void)onUpdateNewImageForPeopertyFinished:(RTNetworkResponse *)response {
    DLog(@"--更新图片信息结束，尼玛。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self showInfo:EDIT__PROPERTY_FINISH];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self hideLoadWithAnimated:YES];
}

//删除房源
- (void)doDeleteProperty {
    self.isLoading = YES;
    
    if (![self isNetworkOkay]) {
        self.isLoading = NO;
        return;
    }
    
    [self showLoadingActivity:YES];
    
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (self.isHaozu) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", [LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propIds", nil];
        method = @"zufang/prop/delprops/";
    }
    else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propIds", nil];
        method = @"anjuke/prop/delprops/";
    }
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onDeletePropFinished:)];
}

- (void)onDeletePropFinished:(RTNetworkResponse *)response {
    DLog(@"--delete Prop。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        return;
    }
    
    //延迟一秒再dismiss页面，已让API端更新房源删除数据
    [self performSelector:@selector(doDeleteDismiss) withObject:nil afterDelay:1];
}

#pragma mark - ******** Overwrite Method ********
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    
    if (actionSheet.tag == IMAGE_ACTIONSHEET_TAG)
    {
        
        
        if (self.footClickType == 1)
        {
            NSString *code = AJK_PPC_RESET_009;
            if (self.isHaozu)
            {
                code = HZ_PPC_RESET_009;
            }
            [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
        }else if (self.footClickType == 2)
        {
            NSString *code = AJK_PPC_RESET_012;
            if (self.isHaozu)
            {
                code = HZ_PPC_RESET_012;
            }
            [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
        }
        
        switch (buttonIndex) {
            case 0: //拍照
            {
                NSString *code = @"";
                if (self.footClickType == 1)
                {
                    code = AJK_PPC_RESET_010;
                    if (self.isHaozu)
                    {
                        code = HZ_PPC_RESET_010;
                    }
                    
                }else if (self.footClickType == 2)
                {
                    code = AJK_PPC_RESET_014;
                    if (self.isHaozu)
                    {
                        code = HZ_PPC_RESET_014;
                    }
                }
                [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
            }
                break;
            case 1: //从手机相册xuan'z
            {
                //室内图

                NSString *code2 = HZ_PPC_RESET_011;
                if(!self.isHaozu)
                {
                    code2 = AJK_PPC_RESET_011;
                }
                
                //户型图
                if (self.footClickType == 2)
                {
                    code2 = HZ_PPC_RESET_013;
                    if(!self.isHaozu)
                    {
                        code2 = AJK_PPC_RESET_013;
                    }
                }
                
                [[BrokerLogger sharedInstance] logWithActionCode:code2 note:nil];
                
                
            }
                break;
            default:
                break;
        }
    }else if (actionSheet.tag == PUBLISH_ACTIONSHEET_TAG)
    {
        NSString *code = @"";
        switch (buttonIndex) {
            case 0: //定价
            {
                code = AJK_PPC_RESET_006;
                if (self.isHaozu)
                {
                    code = HZ_PPC_RESET_006;
                }
                
            }
                break;
            case 1: //定价+竞价
            {
                NSString *code = AJK_PPC_RESET_007;
                if (self.isHaozu)
                {
                    code = HZ_PPC_RESET_007;
                }

            }
                break;
            case 2: //暂不推广
            {
                NSString *code = AJK_PPC_RESET_008;
                if (self.isHaozu)
                {
                    code = HZ_PPC_RESET_008;
                }
            }
                break;
                
            default:
                break;
        }
        //页面可见log
        [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    }
}

- (void)prepareUploadImgArr {
    [self.uploadImageArray removeAllObjects];
    [self.uploadImageArray addObjectsFromArray:self.addRoomImageArray];
    [self.uploadImageArray addObjectsFromArray:self.addHouseTypeImageArray];
    
    self.uploadImgIndex = 0;
    
    self.uploadImg_houseTypeIndex = self.addRoomImageArray.count; //
}

- (void)doPushToHouseTypeVC {
    PublishHouseTypeEditViewController *ph = [[PublishHouseTypeEditViewController alloc] init];
    ph.isHaozu = self.isHaozu;
    ph.backType = RTSelectorBackTypePopBack;
    ph.property = self.property; //指针指向
    ph.superViewController = self;
    ph.propertyID = self.propertyID;
    ph.addHouseTypeImageArray = self.addHouseTypeImageArray;
    ph.houseTypeShowedImgArray = self.houseTypeShowedImgArray; //指针指向
    [self.navigationController pushViewController:ph animated:YES];
}

- (void)doDeleteDismiss {
    [self hideLoadWithAnimated:YES];
    [self showInfo:@"删除房源成功"];
    self.isLoading = NO;
    
    if ([self.propertyDelegate respondsToSelector:@selector(propertyDidDelete)]) {
        [self.propertyDelegate propertyDidDelete];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Check Method

//是否能添加更多室内图
- (BOOL)canAddMoreImageWithAddCount:(int)addCount{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObjectsFromArray:self.addRoomImageArray];
    [arr addObjectsFromArray:self.roomShowedImgArray];
    
    if (![PhotoManager canAddMoreRoomImageForImageArr:arr isHaozu:self.isHaozu]) {
        [self showInfo:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:NO]];
        return NO; //超出
    }
    
    return YES;
}

//当前已有的室内图数量
- (int)getCurrentRoomImgCount {
    return self.addRoomImageArray.count + self.roomShowedImgArray.count;
}

//相册还可添加的图片数量
- (int)getMaxAddRoomImgCountForPhotoAlbum {
    int maxCount = AJK_MAXCOUNT_ROOMIMAGE;
    if (self.isHaozu) {
        maxCount = HZ_MAXCOUNT_ROOMIMAGE;
    }
    return (maxCount - self.addRoomImageArray.count - self.roomShowedImgArray.count);
}

#pragma mark - PhotoFooterImageClickDelegate
- (void)initImgDesc
{
    int count = self.roomShowedImgArray.count + self.addRoomImageArray.count;
    if (!self.imgdescArr || self.imgdescArr.count < count || count > 0)
    {
        int i = 0;
        if (self.imgdescArr.count > 0)
        {
            i = self.imgdescArr.count;
        }else
        {
            self.imgdescArr = [NSMutableArray arrayWithCapacity:5];
        }
        
        for (i = 0; i < count; i++)
        {
            NSString *va = @"";
            [self.imgdescArr addObject:va];
        }
    }
}
- (void)imageDidClickWithIndex:(int)index sender:(PhotoFooterView *)sender{ //图片预览点击
    
    int imageIndex = index - 0;
    DLog(@"查看大图--index [%d]", imageIndex);
    
    //检查_imdescarr是否存在
    [self initImgDesc];
    
    //查看大图
    //模态弹出图片播放器
    PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
    pb.backType = RTSelectorBackTypeDismiss;
    pb.imageDescArray = self.imgdescArr;
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
        if (self.isHaozu)
        {
            pb.hasTextView = YES; //有照片编辑框
        }

        pb.isEditProperty = YES;
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            
            NSMutableArray *editImgShowArr = [NSMutableArray array];
            if (![self isClickImgNewAddWithClickIndex:imageIndex imgType:1]) {
                //已有图片array
                [editImgShowArr addObject:[[self.roomShowedImgArray objectAtIndex:imageIndex] objectForKey:@"imgUrl"]];
            }
            else { //新添加图片
                [editImgShowArr addObject:[(E_Photo *)[self.addRoomImageArray objectAtIndex:imageIndex - self.roomShowedImgArray.count] smallPhotoUrl]];
            }
            
            pb.isNewAddImg = [self isClickImgNewAddWithClickIndex:imageIndex imgType:1];
            [pb showImagesWithArray:editImgShowArr atIndex:imageIndex];
            
        }];
    }else if (self.footClickType == 2) //户型图
    {
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            NSMutableArray *editImgShowArr = [NSMutableArray array];
            NSDictionary *onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
            if (![self isClickImgNewAddWithClickIndex:imageIndex imgType:2]) {
                //已有图片array
                [editImgShowArr addObject:[[self.houseTypeShowedImgArray objectAtIndex:imageIndex] objectForKey:@"imgUrl"]];
            }
            else { //新添加图片
                if (onlineHouseTypeDic.count > 0 && imageIndex == self.houseTypeShowedImgArray.count + self.addHouseTypeImageArray.count) {
                    [pb showImagesForOnlineHouseTypeWithDic:onlineHouseTypeDic];
                    return;
                }
                else
                    [editImgShowArr addObject:[(E_Photo *)[self.addHouseTypeImageArray objectAtIndex:imageIndex - self.houseTypeShowedImgArray.count] smallPhotoUrl]];
            }
            pb.isEditProperty = YES;
            pb.isNewAddImg = [self isClickImgNewAddWithClickIndex:imageIndex imgType:2];
            [pb showImagesWithArray:editImgShowArr atIndex:imageIndex];
        }];
    }
}

- (void)drawFinishedWithCurrentHeight:(CGFloat)height { //每次重绘后返回当前预览底图的高度
    PhotoFooterView *styleFootView = [self.footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
    PhotoFooterView *houseFootView = [self.footerViewDict objectForKey:FOOTERVIEWDICTROOM];
    
    CGFloat btnW = 200;
    CGFloat btnH = CELL_HEIGHT - 15;
    
    CGFloat footHeight = CGRectGetHeight(styleFootView.frame) + CGRectGetHeight(houseFootView.frame) + btnH + 40 + 40;
    
    self.photoBGView.frame = CGRectMake(0, 0, [self windowWidth], footHeight);

    if (self.footClickType == 1)
    {
        CGFloat height2 = CGRectGetHeight(houseFootView.frame);
        CGRect sFootFrame = styleFootView.frame;
        sFootFrame.origin.y = height2 + 22;
        styleFootView.frame = sFootFrame;
    }
    
    if (!self.deleteButton) {
        BigZhenzhenButton *logoutBtn = [[BigZhenzhenButton alloc] init];
        self.deleteButton = logoutBtn;
        [logoutBtn setTitle:@"删除房源" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(doDeleteProperty) forControlEvents:UIControlEventTouchUpInside];
        [self.photoBGView addSubview:self.deleteButton];
    }
    self.deleteButton.frame = CGRectMake(([self windowWidth] -btnW)/2, footHeight - btnH - 20, btnW, btnH);
    
    self.tableViewList.tableFooterView = self.photoBGView; //状态改变后需要重新赋值footerView
}

#pragma mark - PhotoViewClickDelegate

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
            [self.addRoomImageArray addObject:ep];
        }else if (_footClickType == 2)
        {
            [self.addHouseTypeImageArray addObject:ep];
        }
        
    }
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
    
    DLog(@"拍照添加室内图:count[%d]", self.roomImageArray.count);
    DLog(@"sender.tag == %d", sender.tag);
    

    self.footerView = [self.footerViewDict objectForKey:FOOTERVIEWDICTROOM];
    DLog(@"self.footerView.tag == %d", self.footerView.tag);
    NSArray *addImgArr = [PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray];
    NSArray *showImgArr = [PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray];
    
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:self.addRoomImageArray];
    [newArr addObjectsFromArray:self.roomShowedImgArray];
    [self addImgDesc:newArr];

    [self.footerView redrawWithEditRoomImageArray:addImgArr andImgUrl:showImgArr];
    
    NSArray *addHouseImgArr = [PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray];
    NSArray *showHouseImgArr = [PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray];
    NSDictionary *onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
    
    self.footerView = [self.footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
    
    [self.footerView redrawWithEditHouseTypeShowedImageArray:showHouseImgArr andAddImgArr:addHouseImgArr andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:onlineHouseTypeDic]];
    //redraw footer img view
//    [self.footerView redrawWithImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:willdoArr]];
}

#pragma mark - PublishBigImageViewClickDelegate

- (void)editPropertyDidDeleteImgWithDeleteIndex:(int)deleteIndex sender:(id)sender
{
    if (self.footClickType == 1)
    {//室内图
        self.footerView = [[self footerViewDict] objectForKey:FOOTERVIEWDICTROOM];
        //删除对应图片
        if ([self isClickImgNewAddWithClickIndex:deleteIndex imgType:1]) { //新添加图片
            [self.addRoomImageArray removeObjectAtIndex:deleteIndex - self.roomShowedImgArray.count];
            //redraw footer img view
            [self.footerView redrawWithEditRoomImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray] andImgUrl:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray]];
        }
        else {//已有图片删除，交互...
            self.deleteShowedImgIndex = deleteIndex;
            if (deleteIndex >= self.roomShowedImgArray.count) {
                return;
            }
            
            NSString *deleteImgID = [[self.roomShowedImgArray objectAtIndex:deleteIndex] objectForKey:@"imgId"];
            [self doDeleteImgWithImgID:deleteImgID];
        }

    }else if (self.footClickType == 2)
    {//户型图
        self.footerView = [[self footerViewDict] objectForKey:FOOTERVIEWDICTSTYLE];
        //删除对应图片
        if ([self isClickImgNewAddWithClickIndex:deleteIndex imgType:2]) { //新添加图片
            [self.addHouseTypeImageArray removeObjectAtIndex:deleteIndex - self.houseTypeShowedImgArray.count];
            
            NSArray *addHouseImgArr = [PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray];
            NSArray *showHouseImgArr = [PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray];
            NSDictionary *onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
            
            //redraw footer img view
            [self.footerView redrawWithEditHouseTypeShowedImageArray:showHouseImgArr andAddImgArr:addHouseImgArr andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:onlineHouseTypeDic]];
        }else {//已有图片删除，交互...
            self.deleteShowedImgIndex = deleteIndex;
            if (deleteIndex >= self.houseTypeShowedImgArray.count) {
                return;
            }
            
            NSString *deleteImgID = [[self.houseTypeShowedImgArray objectAtIndex:deleteIndex] objectForKey:@"imgId"];
            [self doDeleteImgWithImgID:deleteImgID];
        }
    }
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
            [self.addRoomImageArray addObject:ep];
        }else if (self.footClickType == 2)
        {
            [self.addHouseTypeImageArray addObject:ep];
//            [self.houseTypeImageArray addObject:ep];
        }
	}
    if (self.footClickType == 1)
    {
        self.footerView = [self.footerViewDict objectForKey:FOOTERVIEWDICTROOM];
        [self.footerView redrawWithEditRoomImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray] andImgUrl:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray]];
    }else if (self.footClickType == 2)
    {
        NSArray *addHouseImgArr = [PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray];
        NSArray *showHouseImgArr = [PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray];
        NSDictionary *onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
        
        self.footerView = [self.footerViewDict objectForKey:FOOTERVIEWDICTSTYLE];
        
        [self.footerView redrawWithEditHouseTypeShowedImageArray:showHouseImgArr andAddImgArr:addHouseImgArr andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:onlineHouseTypeDic]];
    }
    //redraw footer img view
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
