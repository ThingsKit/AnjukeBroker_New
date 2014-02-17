//
//  PublishHouseTypeEditViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-7.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishHouseTypeViewController.h"

@interface PublishHouseTypeEditViewController : PublishHouseTypeViewController

@property (nonatomic, strong) NSMutableArray *addHouseTypeImageArray;
@property (nonatomic, strong) NSMutableArray *houseTypeShowedImgArray; //室内图、户型图已获得的图片数组

@property (nonatomic, copy) NSString *propertyID;
@end
