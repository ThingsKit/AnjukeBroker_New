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

#define INDEX_HOUSETYPE 0
#define INDEX_EXPOSURE 1

@interface PublishHouseTypeViewController : RTViewController <UITextFieldDelegate, KeyboardBarClickDelegate, PhotoFooterImageClickDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,ELCImagePickerControllerDelegate, PhotoViewClickDelegate ,OnlineImgSelectDelegate>

@property BOOL isHaozu;
@property (nonatomic, strong) Property *property;
@property id superViewController;
@property (nonatomic, strong) PhotoFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *houseTypeImageArr;

@end
