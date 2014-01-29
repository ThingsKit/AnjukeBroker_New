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
//    [self refreshPhotoHeader];
    
    [self hideLoadWithAnimated:YES];
}

@end
