//
//  PropertyEditViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-29.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyEditViewController.h"

@interface PropertyEditViewController ()

@property (nonatomic, strong) NSMutableArray *addHouseTypeImageArray;
@property (nonatomic, strong) NSMutableArray *addRoomImageArray; //新添加的图片数组

@property (nonatomic, strong) NSMutableArray *roomShowedImgArray; //保存小区图、室内图、户型图，用于保存图片时遍历fileName以判断图片类型(type)
@property (nonatomic, strong) NSMutableArray *houseTypeShowedImgArray; //室内图、户型图已获得的图片数组

@end

#define EDIT__PROPERTY_FINISH @"房源信息已更新"

@implementation PropertyEditViewController
@synthesize propertyID;
@synthesize addHouseTypeImageArray, addRoomImageArray;
@synthesize roomShowedImgArray, houseTypeShowedImgArray;
@synthesize propertyDelegate;

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
        NSString *floorStr = [NSString stringWithFormat:@"%@楼%@层",[dic objectForKey:@"floor"], [dic objectForKey:@"floorNum"]];
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
        NSString *floorStr = [NSString stringWithFormat:@"%@楼%@层",[dic objectForKey:@"floor"], [dic objectForKey:@"floorNum"]];
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

#pragma mark - Request Method

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

@end
