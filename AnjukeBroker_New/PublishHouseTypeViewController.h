//
//  PublishHouseTypeViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "RTInputPickerView.h"
#import "KeyboardToolBar.h"
#import "Property.h"
#import "PhotoManager.h"
#import "PhotoFooterView.h"
#import "ELCImagePickerController.h"
#import "PhotoShowView.h"
#import "AnjukeOnlineImgController.h"
#import "PublishBigImageViewController.h"

#define INDEX_HOUSETYPE 0
#define INDEX_EXPOSURE 1

@interface PublishHouseTypeViewController : RTViewController <UITextFieldDelegate, KeyboardBarClickDelegate, PhotoFooterImageClickDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ELCImagePickerControllerDelegate, PhotoViewClickDelegate ,OnlineImgSelectDelegate, PublishBigImageViewClickDelegate>

@property BOOL isHaozu;
@property (nonatomic, strong) Property *property;
@property id superViewController;
@property (nonatomic, strong) PhotoFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *houseTypeImageArr;

@property (nonatomic, strong) NSDictionary *onlineHouseTypeDic; //户型图专用Dic
@property (nonatomic, strong) UIView *photoBGView; //室内图预览底板
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) PhotoShowView *imageOverLay;
@property BOOL isTakePhoto;
@property BOOL inPhotoProcessing;

@property BOOL isFirstShow; //是否第一次显示页面

- (BOOL)canAddMoreImageWithAddCount:(int)addCount;
- (void)setLastDefultValueAndShowImg;
- (void)setDefultValue;

@end
