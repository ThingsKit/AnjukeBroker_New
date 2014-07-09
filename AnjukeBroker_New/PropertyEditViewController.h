//
//  PropertyEditViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-29.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBuildingViewController.h"
#import "BK_RTNavigationController.h"

@protocol PropertyEditDelegate <NSObject>
- (void)propertyDidDelete;
@end

@interface PropertyEditViewController : PublishBuildingViewController

@property (nonatomic, copy) NSString *propertyID;
@property (nonatomic, assign) id <PropertyEditDelegate> propertyDelegate;

@property (nonatomic, strong) NSMutableArray *addHouseTypeImageArray;
@property (nonatomic, strong) NSMutableArray *addRoomImageArray; //新添加的图片数组

@property (nonatomic, strong) NSMutableArray *roomShowedImgArray; //保存小区图、室内图、户型图，用于保存图片时遍历fileName以判断图片类型(type)
@property (nonatomic, strong) NSMutableArray *houseTypeShowedImgArray; //室内图、户型图已获得的图片数组

@end
