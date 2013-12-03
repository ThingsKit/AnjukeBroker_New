//
//  PropertyResetViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-19.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyResetViewController.h"
#import "PropertyDataManager.h"
#import "BigZhenzhenButton.h"

@interface PropertyResetViewController ()

@property (nonatomic, strong) NSMutableArray *extImageArray; //得到的旧房源数据数组
@property (nonatomic, strong) NSMutableArray *addImageArray; //新添加的图片数组

@property (nonatomic, strong) NSMutableArray *commImgArray; //保存小区图、室内图、户型图，用于保存图片时遍历fileName以判断图片类型(type)
@property (nonatomic, strong) NSMutableArray *roomImgArray;
@property (nonatomic, strong) NSMutableArray *moduleImgArray;
@end

#define EDIT__PROPERTY_FINISH @"房源信息已更新"

@implementation PropertyResetViewController
@synthesize propertyID;
@synthesize extImageArray, addImageArray;
@synthesize commImgArray, roomImgArray, moduleImgArray;

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
    
    self.hideOnlineImg = YES;
    [self doRequestProp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)initModel {
    [super initModel];
    
    self.extImageArray = [NSMutableArray array];
    self.addImageArray = [NSMutableArray array];
    
    self.commImgArray = [NSMutableArray array];
    self.roomImgArray = [NSMutableArray array];
    self.moduleImgArray = [NSMutableArray array];
}

- (void)initDisplay {
    [super initDisplay];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], CELL_HEIGHT*1.5)];
    footerView.backgroundColor = [UIColor clearColor];
    
    CGFloat btnW = 200;
    CGFloat btnH = CELL_HEIGHT - 15;
    BigZhenzhenButton *logoutBtn = [[BigZhenzhenButton alloc] initWithFrame:CGRectMake((footerView.frame.size.width -btnW)/2, (footerView.frame.size.height - btnH)/2, btnW, btnH)];
    [logoutBtn setTitle:@"删除房源" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(doDeleteProperty) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    
    self.tvList.tableFooterView = footerView;
    
}

- (void)setPropertyWithDic:(NSDictionary *)dic {
    self.property = [PropertyDataManager getNewPropertyObject];
    
    //数据赋值，映射，得到显示值 for test
    //户型
    self.property.rooms = [NSString stringWithFormat:@"%@,%@,%@", [dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"]];
    //面积
    self.property.area = [dic objectForKey:@"area"];
    //价格
    self.property.price = [dic objectForKey:@"price"];
    //装修
    self.property.fitment = [dic objectForKey:@"fitment"];
    if (!self.isHaozu) {
        NSString *fitmentVaule = [PropertyDataManager getFitmentVauleWithTitle:[dic objectForKey:@"fitment"] forHaozu:self.isHaozu];
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
    self.roomImgArray = [dic objectForKey:@"roomImg"];
    self.commImgArray = [dic objectForKey:@"commImg"];
    self.moduleImgArray = [dic objectForKey:@"moduleImg"];
    if (self.roomImgArray.count > 0) {
        [self.extImageArray addObjectsFromArray:self.roomImgArray];
    }
//    if (self.commImgArray.count > 0) {
//        [self.extImageArray addObjectsFromArray:self.commImgArray];
//    }
    
    //设置小区名字
    //小区
    self.property.comm_id = [dic objectForKey:@"commId"];
    [self setCommunityWithText:[dic objectForKey:@"commName"]];
    
    if (self.isHaozu) { //租房
        //Text
        //price
        [[[[self.dataSource cellArray] objectAtIndex:HZ_T_PRICE] text_Field] setText:self.property.price];
        //area
        [[[[self.dataSource cellArray] objectAtIndex:HZ_T_AREA] text_Field] setText:self.property.area];
        
        //title
        [[[[self.dataSource cellArray] objectAtIndex:HZ_T_TITLE] communityDetailLb] setText:self.property.title];
        //desc
        [[[[self.dataSource cellArray] objectAtIndex:HZ_T_DESC] communityDetailLb] setText:self.property.desc];
        
        //Picker Data
        //户型
        NSString *roomStr = [NSString stringWithFormat:@"%@室%@厅%@卫",[dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"]];
        [[[[self.dataSource cellArray] objectAtIndex:HZ_P_ROOMS] text_Field] setText:roomStr];
        
        //出租方式
        self.property.rentType = [dic objectForKey:@"shareRent"];
        NSString *rentStr = [PropertyDataManager getRentTypeTitleWithNum:self.property.rentType];
        [[[[self.dataSource cellArray] objectAtIndex:HZ_P_RENTTYPE] text_Field] setText:rentStr];
        
        //装修
        NSString *fitmentStr = [PropertyDataManager getFitmentTitleWithNum:self.property.fitment forHaozu:self.isHaozu];
        [[[[self.dataSource cellArray] objectAtIndex:HZ_P_FITMENT] text_Field] setText:fitmentStr];
        
        //朝向 test，租房更改返回信息
        [[[[self.dataSource cellArray] objectAtIndex:HZ_P_EXPOSURE] text_Field] setText:self.property.exposure];
        
        //楼层
        NSString *floorStr = [NSString stringWithFormat:@"%@楼%@层",[dic objectForKey:@"floor"], [dic objectForKey:@"floorNum"]];
        [[[[self.dataSource cellArray] objectAtIndex:HZ_P_FLOORS] text_Field] setText:floorStr];
        
        //设置各picker展示时，初始数据所在行
        //户型
        int roomIndex = [PropertyDataManager getRoomIndexWithNum:[dic objectForKey:@"roomNum"]];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_ROOMS] setInputed_RowAtCom0:roomIndex];
        int hallIndex = [PropertyDataManager getHallIndexWithNum:[dic objectForKey:@"hallNum"]];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_ROOMS] setInputed_RowAtCom1:hallIndex];
        int toiletIndex = [PropertyDataManager getToiletIndexWithNum:[dic objectForKey:@"toiletNum"]];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_ROOMS] setInputed_RowAtCom2:toiletIndex];
        //出租方式
        int rentIndex = [PropertyDataManager getRentTypeIndexWithNum:self.property.rentType];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_RENTTYPE] setInputed_RowAtCom0:rentIndex];
        //装修
        int fitmentIndex = [PropertyDataManager getFitmentIndexWithString:self.property.fitment forHaozu:self.isHaozu];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_FITMENT] setInputed_RowAtCom0:fitmentIndex];
        //朝向
        int exIndex = [PropertyDataManager getExposureIndexWithTitle:self.property.exposure];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_EXPOSURE] setInputed_RowAtCom0:exIndex];
        //楼层
        int profloorIndex = [PropertyDataManager getProFloorIndexWithNum:[dic objectForKey:@"floor"]];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_FLOORS] setInputed_RowAtCom0:profloorIndex];
        int floorIndex = [PropertyDataManager getFloorIndexWithNum:[dic objectForKey:@"floorNum"]];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_FLOORS] setInputed_RowAtCom1:floorIndex];
        
    }
    else { //二手房
        
        //price
        NSString *priceValue = [NSString stringWithFormat:@"%d", [self.property.price intValue]/10000];
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_PRICE] text_Field] setText:priceValue];
        //area
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_AREA] text_Field] setText:self.property.area];
        
        //title
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_TITLE] communityDetailLb] setText:self.property.title];
        //desc
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_DESC] communityDetailLb] setText:self.property.desc];
        
        //Picker Data
        //户型
        NSString *roomStr = [NSString stringWithFormat:@"%@室%@厅%@卫",[dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"]];
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_ROOMS] text_Field] setText:roomStr];
        
        //装修 test 二手房直接返回title
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_FITMENT] text_Field] setText:[dic objectForKey:@"fitment"]];
        
        //朝向
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_EXPOSURE] text_Field] setText:self.property.exposure];
        
        //楼层
        NSString *floorStr = [NSString stringWithFormat:@"%@楼%@层",[dic objectForKey:@"floor"], [dic objectForKey:@"floorNum"]];
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_FLOORS] text_Field] setText:floorStr];
        
        //设置各picker展示时，初始数据所在行
        //户型
        int roomIndex = [PropertyDataManager getRoomIndexWithNum:[dic objectForKey:@"roomNum"]];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_ROOMS] setInputed_RowAtCom0:roomIndex];
        int hallIndex = [PropertyDataManager getHallIndexWithNum:[dic objectForKey:@"hallNum"]];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_ROOMS] setInputed_RowAtCom1:hallIndex];
        int toiletIndex = [PropertyDataManager getToiletIndexWithNum:[dic objectForKey:@"toiletNum"]];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_ROOMS] setInputed_RowAtCom2:toiletIndex];
        //装修
        int fitmentIndex = [PropertyDataManager getFitmentIndexWithString:[dic objectForKey:@"fitment"] forHaozu:self.isHaozu];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_FITMENT] setInputed_RowAtCom0:fitmentIndex];
        //朝向
        int exIndex = [PropertyDataManager getExposureIndexWithTitle:self.property.exposure];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_EXPOSURE] setInputed_RowAtCom0:exIndex];
        //楼层
        int profloorIndex = [PropertyDataManager getProFloorIndexWithNum:[dic objectForKey:@"floor"]];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_FLOORS] setInputed_RowAtCom0:profloorIndex];
        int floorIndex = [PropertyDataManager getFloorIndexWithNum:[dic objectForKey:@"floorNum"]];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_FLOORS] setInputed_RowAtCom1:floorIndex];
    }
}

//发房与编辑价格格式不同，需要更新
- (void)setTextFieldForProperty {
    [super setTextFieldForProperty];
    
    if (self.isHaozu) {
        self.property.price = [[[[self.dataSource cellArray] objectAtIndex:HZ_T_PRICE] text_Field] text];
    }
    else {
        NSString *priceValue = [NSString stringWithFormat:@"%d", [[[[[self.dataSource cellArray] objectAtIndex:AJK_T_PRICE] text_Field] text] intValue]*10000];
        self.property.price = priceValue;
    }
    
    DLog(@"price [%@]_[%@]", self.property.price, [[[[[self.dataSource cellArray] objectAtIndex:HZ_T_PRICE] text_Field] text] class]);
}

- (void)refreshPhotoHeader {
    int preCount = 0; //递增之前imgArr的个数，用于控制btnImgArr的显示位置
    
    for (int i = 0; i < self.extImageArray.count; i ++) {
        PhotoButton *imgBtn = (PhotoButton *)[self.imgBtnArray objectAtIndex:i];
        NSString *url = [[self.extImageArray objectAtIndex:i] objectForKey:@"imgUrl"];
        [imgBtn.photoImg setImageUrl:url];
        imgBtn.hidden = NO;
    }
    
    preCount += self.extImageArray.count;
    DLog(@"1_preCount--[%d]", preCount);
    
    for (int i = 0; i < self.addImageArray.count; i ++) {
        PhotoButton *imgBtn = (PhotoButton *)[self.imgBtnArray objectAtIndex:i+ preCount]; //***取到需要继续显示预览图的btnImg
        NSString *url = [(E_Photo *)[self.addImageArray objectAtIndex:i] smallPhotoUrl];
        [imgBtn.photoImg setImage:[UIImage imageWithContentsOfFile:url]];
        imgBtn.hidden = NO;
    }
    
    preCount += self.addImageArray.count;
    DLog(@"2_preCount--[%d]", preCount);
    
//    if (PhotoImg_MAX_COUNT - preCount >0) {
//        DLog(@"无预览图count [%d]" , PhotoImg_MAX_COUNT- preCount);
//        //隐藏无图的预览图
//        for (int i = 0; i < PhotoImg_MAX_COUNT - preCount; i ++) {
//            DLog(@"无预览图index [%d]" , PhotoImg_MAX_COUNT-1- preCount+i);
//            
//            PhotoButton *imgBtn = (PhotoButton *)[self.imgBtnArray objectAtIndex:PhotoImg_MAX_COUNT-1- preCount+i]; //***取到不显示预览图的btnImg
//            imgBtn.hidden = YES;
//        }
//    }
    
    
//    for (PhotoButton * imgBtn in self.imgBtnArray) {
//        if (imgBtn.photoImg.image == nil) {
//            imgBtn.hidden = YES;
//            imgBtn.alpha = 0;
//        }
//        else {
//            imgBtn.hidden = NO;
//            imgBtn.alpha = 1;
//        }
//    }
    
    int allCount = self.extImageArray.count + self.addImageArray.count;
    self.photoSV.contentSize = CGSizeMake(PhotoImg_Gap + (PhotoImg_Gap+ PhotoImg_H)* (allCount +1), photoHeaderH);
}

- (NSString *)getImageJson {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < self.addImageArray.count; i ++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[(E_Photo *)[self.addImageArray objectAtIndex:i] imageDic]];
        [arr addObject:dic];
        if (self.isHaozu) {
            [dic setObject:@"1" forKey:@"type"]; //1:室内图;2:房型图;3:小区图"
        }
        else //二手房
            [dic setObject:@"2" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
    }
    NSString *str = [arr JSONRepresentation];
    //    DLog(@"image json [%@]", str);
    return str;
}

- (void)doPushToCommunity {
    //
}

//将已有图片数量和新加入图片数量与最大张数对比
- (BOOL)canAddNewImgWithNewCount:(int)newCount {
    int count = self.extImageArray.count + self.addImageArray.count + newCount;
    
    if (count <= PhotoImg_MAX_COUNT) {
        DLog(@"可继续添加 [%d]",count);
        return YES;
    }
    DLog(@"不可继续添加 [%d]",count);
    return NO;
}

- (void)addPhoto {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    sheet.tag = TagOfActionSheet_Img;
    sheet.cancelButtonIndex = 2;
    [sheet showInView:self.view];
}

- (void)setDefultValue {
    
}

#pragma mark - Request Method

- (void)doRequestProp {
    [self showLoadingActivity:YES];
    
    NSDictionary *params = nil;
    NSString *methodStr = [NSString string];
    
    if (self.isHaozu) {
        methodStr = @"zufang/prop/getpropdetail/";
        params = [NSDictionary dictionaryWithObjectsAndKeys:self.propertyID, @"propId", nil];
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
    [self refreshPhotoHeader];
    
    [self hideLoadWithAnimated:YES];
}

- (void)doSave {
    if (![self isNetworkOkay]) {
        return;
    }
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    [self setTextFieldForProperty];
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", self.property.comm_id, @"commId", self.property.rooms, @"rooms", self.property.area, @"area", self.property.price, @"price", self.property.fitment, @"fitment", self.property.exposure, @"exposure", self.property.floor, @"floor", self.property.title, @"title", self.property.desc, @"description", self.propertyID, @"propId",nil];
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
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //保存房源id
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadNewImgToProperty]; //问题信息更新结束，开始新增图片上传
    [self hideLoadWithAnimated:YES];
}

- (void)uploadNewImgToProperty {
    if (self.addImageArray.count == 0) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        [self showInfo:EDIT__PROPERTY_FINISH];
        [self dismissViewControllerAnimated:YES completion:nil]; //没有更新图片，直接退出
        
        return; //没有上传图片
    }
    
    if (![self isNetworkOkay]) {
        return;
    }
    
    //上传新添加的图片
    if (self.uploadImgIndex > self.addImageArray.count - 1) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        DLog(@"图片上传服务器完毕，结束");
        
//        [self dismissViewControllerAnimated:YES completion:nil];
        //调用图片接口更新图片
        [self updateNewImg];
        
        return;
    }
    
    if (self.uploadImgIndex == 0) { //第一张图片开始上传就显示黑框，之后不重复显示，上传流程结束后再消掉黑框
        [self showLoadingActivity:YES];
        self.isLoading = YES;
    }
    
    //test
    //上传图片给UFS服务器
    NSString *photoUrl = [[self.addImageArray objectAtIndex:self.uploadImgIndex] photoURL];
    
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
    [dic setObject:@"2" forKey:@"type"]; //1:小区图;2:室内图;3:房型图"
    
    [(E_Photo *)[self.addImageArray objectAtIndex:self.uploadImgIndex] setImageDic:dic];
    
    //继续上传图片
    self.uploadImgIndex ++;
    [self uploadNewImgToProperty];
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
    //更新图片接口，上传imgJson+房源ID
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    self.property.imageJson = [self getImageJson];
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.propertyID, @"propId", self.property.imageJson, @"imageJson", [LoginManager getUserID], @"brokerId", nil];
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
    
    [self showInfo:@"房源信息更新成功 "];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self hideLoadWithAnimated:YES];
}

- (void)doDeleteImgWithImgID:(NSString *)imgID {
    if (![self isNetworkOkay]) {
        return;
    }
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    [self setTextFieldForProperty];
    
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
    
    [self showInfo:@"图片已删除"];
    [self hideLoadWithAnimated:YES];
}

//删除房源
- (void)doDeleteProperty {
    if (![self isNetworkOkay]) {
        return;
    }
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    if (self.isHaozu) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getCity_id], @"cityId", [LoginManager getUserID], @"brokerId", self.propertyID, @"propIds", nil];
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
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        return;
    }
    
    [self hideLoadWithAnimated:YES];
    [self showInfo:@"删除房源成功"];
    
    [self doBack:self];
    
}

#pragma mark - BigImageView Delegate
- (void)deletebtnClickForOnlineImg:(BOOL)isOnlineImg {
    //判断index在哪个imgArr中
    if (self.extImageArray.count == 0) { //直接从新添加imgArr删除
        [self.addImageArray removeObjectAtIndex:self.imageSelectIndex];
    }
    else if (self.imageSelectIndex < self.extImageArray.count) {
        //需要请求api交互
        NSString *deleteImgID = [[self.extImageArray objectAtIndex:self.imageSelectIndex] objectForKey:@"imgId"];
        [self doDeleteImgWithImgID:deleteImgID];
        //删除原房源图片
        [self.extImageArray removeObjectAtIndex:self.imageSelectIndex];
    }
    else { //删除新添加的图片
        [self.addImageArray removeObjectAtIndex:self.imageSelectIndex- self.extImageArray.count];
    }
    
    for (PhotoButton *btn in self.imgBtnArray) {
        btn.photoImg.image = nil;
    }
    //    DLog(@"img count [%d]", self.imgArray.count);
    
    //redraw header img scroll
    [self refreshPhotoHeader];
}

#pragma mark - Photo Show View Delegate

- (void)closePicker_Click_WithImgArr:(NSMutableArray *)arr {
    if (![self canAddNewImgWithNewCount:arr.count]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self showInfo:MAX_PHOTO_ALERT_MESSAGE];
        return;
    }
    
    for (int i = 0; i < arr.count; i ++) {
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:(UIImage *)[arr objectAtIndex:i] toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        ep.smallPhotoUrl = url;
        
        [self.addImageArray addObject:ep];
    }
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
    
    //redraw header img scroll
    [self refreshPhotoHeader];
}

#pragma mark - ELCImagePickerController Delegate

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    if (![self canAddNewImgWithNewCount:info.count]) {
        [self dismissViewControllerAnimated:YES completion:nil];
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
        
        [self.addImageArray addObject:ep];
	}
    
    [self refreshPhotoHeader];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
