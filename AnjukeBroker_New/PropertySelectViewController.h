//
//  PropertySelectViewController.h
//  AnjukeBroker_New
//
//  Created by shan xu on 14-2-27.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "houseSelectViewController.h"
#import "AppManager.h"
#import "LoginManager.h"
#import "PropertyDetailCell.h"
#import "HouseSelectNavigationController.h"
#import "PropertyResponder.h"
#import "WillSendPropModel.h"

typedef enum {
    secondHandPropertyHouse = 0,
    rentPropertyHouse
}pageTypePropertyFrom;

@interface PropertySelectViewController : HouseSelectViewController
@property(nonatomic,assign) pageTypePropertyFrom  pageTypePropertyFrom;
@property(nonatomic,strong) NSDictionary *commDic;
@property(nonatomic,strong) NSMutableArray *arr;
@property(nonatomic, assign)BOOL isSayHello;
@property (nonatomic, strong)WillSendPropModel *willsendProp;

-(void)passDataWithDic:(NSDictionary *)dic;
@end
