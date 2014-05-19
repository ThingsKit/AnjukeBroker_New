//
//  PublishBuildingViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "Util_UI.h"
#import "PublishTableViewDataSource.h"
#import "PublishDataModel.h"
#import "RTInputPickerView.h"
#import "KeyboardToolBar.h"
#import "AnjukeEditableCell.h"
#import "Property.h"
#import "LoginManager.h"
#import "PhotoFooterView.h"
#import "BK_ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "PhotoShowView.h"
#import "E_Photo.h"
#import "PhotoManager.h"
#import "AnjukeEditTextViewController.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "PublishBigImageViewController.h"
#import "BK_RTNavigationController.h"
#import "SimpleKeyboardToolBar.h"
#import "PublishInputOrderModel.h"
#import "PublishFeatureViewController.h"

#define IMAGE_ACTIONSHEET_TAG 9010
#define PUBLISH_ACTIONSHEET_TAG 9020

#define PHOTO_FOOTER_BOTTOM_HEIGHT 80

@interface PublishBuildingViewController : RTViewController <UITableViewDelegate, KeyboardBarClickDelegate, CellTextFieldEditDelegate, UIActionSheetDelegate, PhotoFooterImageClickDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate, PhotoViewClickDelegate, TextFieldModifyDelegate ,PublishBigImageViewClickDelegate, UIAlertViewDelegate, UITextFieldDelegate, SimpleKeyboardBarClickDelegate, PublishFeatureDelegate>

@property BOOL isHaozu; //是否是好租，页面布局不同
@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) PublishTableViewDataSource *cellDataSource;
@property (nonatomic, strong) Property *property;

@property BOOL isTBBtnPressedToShowKeyboard; //是否是通过上一项、下一项点按控制键盘、滚轮显示，是则屏蔽textField的delegate方法
@property (nonatomic, strong) NSDictionary *communityDic; //小区内容显示label

@property int roomValue;
@property int hallValue;
@property int toiletValue; //用于页面间户型数据的传递

@property (nonatomic, strong) NSMutableArray *roomImageArray;
@property (nonatomic, strong) NSMutableArray *houseTypeImageArray; //室内图、户型图数据存放数组

@property (nonatomic, strong) PhotoFooterView *footerView;
@property BOOL inPhotoProcessing;
@property BOOL isTakePhoto; //是否拍照，区别拍照和从相册取图
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property int uploadImgIndex; //上传图片的顺序，每上传一张此index+1
@property (nonatomic, strong) NSMutableArray *uploadImageArray; //用于上传的图片数组整集，整合室内图和房型图数组内容

@property (nonatomic, strong) UITextField *fileNoTextF; //备案号输入框
@property (nonatomic, strong) SimpleKeyboardToolBar *simToolBar;
@property (nonatomic, strong) UILabel *communityDetailLb;

@property int uploadImg_houseTypeIndex; //上传图片时户型图数据所在整个图片上传队列中的位置
@property (nonatomic, strong) UIView *photoBGView; //室内图预览底板

@property (nonatomic, copy) NSString *property_ID; //房源ID
@property (nonatomic, strong) NSArray *fixGroupArr; //定价房源定价组
@property BOOL isBid; //是否为定价且竞价

- (void)setTextFieldForProperty;
- (BOOL)canAddMoreImageWithAddCount:(int)addCount;
- (void)setHouseTypeShowWithString:(NSString *)string; //设置房型文案
- (BOOL)checkUploadProperty;

- (int)getCurrentRoomImgCount;
- (int)getMaxAddRoomImgCountForPhotoAlbum;
- (void)prepareUploadImgArr;
- (NSString *)getImageJson;

- (void)doPushToHouseTypeVC;
- (void)drawFooter;

- (void)pickerDisappear;

@end
