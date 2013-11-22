//
//  PropertyResetViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-19.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "PropertyResetViewController.h"
#import "PropertyDataManager.h"

@interface PropertyResetViewController ()

@end

@implementation PropertyResetViewController
@synthesize propertyID;

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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"搜索小区失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    NSDictionary *dic = [[[response content] objectForKey:@"data"] objectForKey:@"propInfo"];
    
    //保存房源详情 //映射到房源object，并遍历得到每个数据的index
    [self setPropertyWithDic:dic];
    
    [self hideLoadWithAnimated:YES];
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
    //朝向
    self.property.exposure = [dic objectForKey:@"exposure"];
    //楼层
    self.property.floor = [NSString stringWithFormat:@"%@,%@", [dic objectForKey:@"proFloor"], [dic objectForKey:@"floorNum"]];
    //title
    self.property.title = [dic objectForKey:@"title"];
    
    //desc
    self.property.desc = [dic objectForKey:@"description"];
    
    //image
    NSArray *imgArr = [dic objectForKey:@"commImg"];
    
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
        [[[[self.dataSource cellArray] objectAtIndex:HZ_T_TITLE] text_Field] setText:self.property.title];
        //desc
        [[[[self.dataSource cellArray] objectAtIndex:HZ_T_DESC] text_Field] setText:self.property.desc];
        
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
        NSString *floorStr = [NSString stringWithFormat:@"%@楼%@层",[dic objectForKey:@"proFloor"], [dic objectForKey:@"floorNum"]];
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
        int profloorIndex = [PropertyDataManager getProFloorIndexWithNum:[dic objectForKey:@"proFloor"]];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_FLOORS] setInputed_RowAtCom0:profloorIndex];
        int floorIndex = [PropertyDataManager getFloorIndexWithNum:[dic objectForKey:@"floorNum"]];
        [[[self.dataSource cellArray] objectAtIndex:HZ_P_FLOORS] setInputed_RowAtCom1:floorIndex];
        
    }
    else { //二手房
        
        //price
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_PRICE] text_Field] setText:self.property.price];
        //area
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_AREA] text_Field] setText:self.property.area];
        
        //title
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_TITLE] text_Field] setText:self.property.title];
        //desc
        [[[[self.dataSource cellArray] objectAtIndex:AJK_T_DESC] text_Field] setText:self.property.desc];
        
        //Picker Data
        //户型
        NSString *roomStr = [NSString stringWithFormat:@"%@室%@厅%@卫",[dic objectForKey:@"roomNum"], [dic objectForKey:@"hallNum"], [dic objectForKey:@"toiletNum"]];
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_ROOMS] text_Field] setText:roomStr];
        
        //装修 test 二手房直接返回title
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_FITMENT] text_Field] setText:self.property.fitment];
        
        //朝向
        [[[[self.dataSource cellArray] objectAtIndex:AJK_P_EXPOSURE] text_Field] setText:self.property.exposure];
        
        //楼层
        NSString *floorStr = [NSString stringWithFormat:@"%@楼%@层",[dic objectForKey:@"proFloor"], [dic objectForKey:@"floorNum"]];
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
        int fitmentIndex = [PropertyDataManager getFitmentIndexWithString:self.property.fitment forHaozu:self.isHaozu];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_FITMENT] setInputed_RowAtCom0:fitmentIndex];
        //朝向
        int exIndex = [PropertyDataManager getExposureIndexWithTitle:self.property.exposure];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_EXPOSURE] setInputed_RowAtCom0:exIndex];
        //楼层
        int profloorIndex = [PropertyDataManager getProFloorIndexWithNum:[dic objectForKey:@"proFloor"]];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_FLOORS] setInputed_RowAtCom0:profloorIndex];
        int floorIndex = [PropertyDataManager getFloorIndexWithNum:[dic objectForKey:@"floorNum"]];
        [[[self.dataSource cellArray] objectAtIndex:AJK_P_FLOORS] setInputed_RowAtCom1:floorIndex];
    }
    
}


@end
