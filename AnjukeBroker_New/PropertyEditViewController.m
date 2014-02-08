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

@end

#define EDIT__PROPERTY_FINISH @"房源信息已更新"

@implementation PropertyEditViewController
@synthesize propertyID;
@synthesize addHouseTypeImageArray, addRoomImageArray;
@synthesize roomShowedImgArray, houseTypeShowedImgArray;
@synthesize propertyDelegate;
@synthesize deleteShowedImgIndex;
@synthesize deleteButton;

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
    
    //户型、朝向
    NSString *roomStr = [NSString stringWithFormat:@"%@室%@厅%@卫",[dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"]];
    NSString *houseTypeName = [NSString stringWithFormat:@"%@  %@", roomStr, self.property.exposure];
    [self setHouseTypeShowWithString:houseTypeName];
    
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
    }
    
    DLog(@"*** 编辑房源property 【%@】", self.property);
}

//点击的预览图片是否是新添加的图片
- (BOOL)isClickImgNewAddWithClickIndex:(int)clickIndex {
    BOOL isNewAdd = NO;
    
    if (clickIndex >= self.roomShowedImgArray.count) {
        isNewAdd = YES;
    }
    
    return isNewAdd;
}

- (void)doDeleteProperty {
    if ([self.propertyDelegate respondsToSelector:@selector(propertyDidDelete)]) {
        [self.propertyDelegate propertyDidDelete];
    }
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
        self.isLoading = NO;
        
        return;
    }
    
    NSDictionary *dic = [[[response content] objectForKey:@"data"] objectForKey:@"propInfo"];
    
    //保存房源详情 //映射到房源object，并遍历得到每个数据的index
    [self setPropertyWithDic:dic];
    
    //redraw footer img view
    [self.footerView redrawWithEditRoomImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray] andImgUrl:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray]];
    
    [self hideLoadWithAnimated:YES];
}

//图片删除
- (void)doDeleteImgWithImgID:(NSString *)imgID {
    if (![self isNetworkOkay]) {
        return;
    }
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
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
        self.isLoading = NO;
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self showInfo:@"图片已删除"];
    
    [self.roomShowedImgArray removeObjectAtIndex:self.deleteShowedImgIndex];
    //redraw footer img view
    [self.footerView redrawWithEditRoomImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray] andImgUrl:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray]];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

//更新房源信息
- (void)doSave {
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
    self.isLoading = YES;
    
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
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onUpdatePropertyFinished:)];
}

- (void)onUpdatePropertyFinished:(RTNetworkResponse *)response {
    DLog(@"--更新房源信息结束。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
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
    //    self.isLoading = NO;
}

//上传新图片
- (void)uploadNewImgToProperty {
    if (self.uploadImageArray.count == 0) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        [self showInfo:EDIT__PROPERTY_FINISH];
        [self dismissViewControllerAnimated:YES completion:nil]; //没有更新图片，直接退出
        
        return; //没有上传图片
    }
    
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    //上传新添加的图片
    if (self.uploadImgIndex > self.uploadImageArray.count - 1) {
        //        [self hideLoadWithAnimated:YES];
        //        self.isLoading = NO;
        
        DLog(@"图片上传服务器完毕，结束");
        
        //        [self dismissViewControllerAnimated:YES completion:nil];
        //调用图片接口更新图片
        [self updateNewImg];
        
        return;
    }
    
    if (self.uploadImgIndex == 0) { //第一张图片开始上传就显示黑框，之后不重复显示，上传流程结束后再消掉黑框
        //        [self showLoadingActivity:YES];
        //        self.isLoading = YES;
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
            [dic setObject:@"1" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
        }
        else //属于房型图类型
            [dic setObject:@"2" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
    }
    else //二手房
    {
        if (self.uploadImgIndex < self.uploadImg_houseTypeIndex) { //属于室内图类型
            [dic setObject:@"2" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
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
        //        self.isLoading = NO;
        
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
    
    self.uploadImgIndex = 0;
    
    [self showInfo:@"图片上传失败，请重试"];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

- (void)updateNewImg {
    //    [self showLoadingActivity:YES];
    //    self.isLoading = YES;
    
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
        self.isLoading = NO;
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self showInfo:EDIT__PROPERTY_FINISH];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - ******** Overwrite Method ********

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

- (void)imageDidClickWithIndex:(int)index { //图片预览点击
    int imageIndex = index - 0;
    DLog(@"查看大图--index [%d]", imageIndex);
    
    //查看大图
    //模态弹出图片播放器
    PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
    pb.clickDelegate = self;
    pb.isEditProperty = YES;
    RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:navController animated:YES completion:^(void) {
        
        NSMutableArray *editImgShowArr = [NSMutableArray array];
        if (![self isClickImgNewAddWithClickIndex:imageIndex]) {
            //已有图片array
            [editImgShowArr addObject:[[self.roomShowedImgArray objectAtIndex:imageIndex] objectForKey:@"imgUrl"]];
        }
        else { //新添加图片
            [editImgShowArr addObject:[(E_Photo *)[self.addRoomImageArray objectAtIndex:imageIndex - self.roomShowedImgArray.count] smallPhotoUrl]];
        }
        
        pb.isNewAddImg = [self isClickImgNewAddWithClickIndex:imageIndex];
        [pb showImagesWithArray:editImgShowArr atIndex:imageIndex];
    }];
}

- (void)drawFinishedWithCurrentHeight:(CGFloat)height { //每次重绘后返回当前预览底图的高度
    CGFloat btnW = 200;
    CGFloat btnH = CELL_HEIGHT - 15;
    
    self.photoBGView.frame = CGRectMake(0, 0, [self windowWidth], PUBLISH_SECTION_HEIGHT+PHOTO_FOOTER_BOTTOM_HEIGHT + height +10);
    
    if (!self.deleteButton) {
        BigZhenzhenButton *logoutBtn = [[BigZhenzhenButton alloc] init];
        self.deleteButton = logoutBtn;
        [logoutBtn setTitle:@"删除房源" forState:UIControlStateNormal];
        [logoutBtn addTarget:self action:@selector(doDeleteProperty) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:self.deleteButton];
    }
    self.deleteButton.frame = CGRectMake(([self windowWidth] -btnW)/2, self.photoBGView.frame.size.height- btnH -40, btnW, btnH);
    
    self.tableViewList.tableFooterView = self.photoBGView; //状态改变后需要重新赋值footerView
}

#pragma mark - PhotoViewClickDelegate

- (void)closePicker_Click_WithImgArr:(NSMutableArray *)arr {
    for (int i = 0; i < arr.count; i ++) {
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:(UIImage *)[arr objectAtIndex:i] toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        ep.smallPhotoUrl = url;
        
        [self.addRoomImageArray addObject:ep];
    }
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
    
    //redraw footer img view
    [self.footerView redrawWithEditRoomImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray] andImgUrl:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray]];
}

#pragma mark - PublishBigImageViewClickDelegate

- (void)editPropertyDidDeleteImgWithDeleteIndex:(int)deleteIndex {
    
    //删除对应图片
    if ([self isClickImgNewAddWithClickIndex:deleteIndex]) { //新添加图片
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
        
        [self.addRoomImageArray addObject:ep];
	}
    
    //redraw footer img view
    [self.footerView redrawWithEditRoomImageArray:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addRoomImageArray] andImgUrl:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.roomShowedImgArray]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
