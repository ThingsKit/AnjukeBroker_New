//
//  PublishBuildingViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
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
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "PhotoShowView.h"
#import "E_Photo.h"
#import "PhotoManager.h"
#import "AnjukeEditTextViewController.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
#import "PublishBigImageViewController.h"
#import "RTNavigationController.h"
#import "SimpleKeyboardToolBar.h"
#import "PublishInputOrderModel.h"
#import "PublishFeatureViewController.h"
#import "AnjukeOnlineImgController.h"
#import "BrokerLogger.h"
#import "AJKSaveMessModel.h"

#define IMAGE_ACTIONSHEET_TAG 9010
#define PUBLISH_ACTIONSHEET_TAG 9020
#define PUBLISH_ACTIONSHEETFORSELECT_TAG 9030

#define PHOTO_FOOTER_BOTTOM_HEIGHT 80

#define FOOTERVIEWDICTROOM   @"pfRoom"
#define FOOTERVIEWDICTSTYLE  @"pfStyle"


@interface PublishBuildingViewController : RTViewController <UITableViewDelegate, KeyboardBarClickDelegate, CellTextFieldEditDelegate, UIActionSheetDelegate, PhotoFooterImageClickDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate, PhotoViewClickDelegate, TextFieldModifyDelegate ,PublishBigImageViewClickDelegate, UIAlertViewDelegate, UITextFieldDelegate, SimpleKeyboardBarClickDelegate, PublishFeatureDelegate, OnlineImgSelectDelegate>

@property BOOL isHaozu; //是否是好租，页面布局不同
@property (nonatomic, strong) NSString *pdId;
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
@property (nonatomic, assign) NSInteger footClickType;////1,室内图2,户型图

@property (nonatomic, strong) PhotoFooterView *footerView;
@property (nonatomic, strong) NSMutableDictionary *footerViewDict;
@property BOOL inPhotoProcessing;
@property BOOL isTakePhoto; //是否拍照，区别拍照和从相册取图
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, assign)NSInteger uploadImgIndex; //上传图片的顺序，每上传一张此index+1
@property (nonatomic, assign)NSInteger uploadRoomImgDescIndex;//上传图片简介的index
@property (nonatomic, strong) NSMutableArray *uploadImageArray; //用于上传的图片数组整集，整合室内图和房型图数组内容

@property (nonatomic, strong) UITextField *fileNoTextF; //备案号输入框
@property (nonatomic, strong) SimpleKeyboardToolBar *simToolBar;
@property (nonatomic, strong) UILabel *communityDetailLb;//小区名字
@property (nonatomic, strong) UILabel *communityDetailAdLb;//小区地址

@property int uploadImg_houseTypeIndex; //上传图片时户型图数据所在整个图片上传队列中的位置
@property (nonatomic, strong) UIView *photoBGView; //室内图预览底板

@property (nonatomic, copy) NSString *property_ID; //房源ID
@property (nonatomic, strong) NSArray *fixGroupArr; //定价房源定价组

@property (nonatomic, strong) NSMutableArray *imgdescArr;;//图片描述
@property BOOL isBid; //是否为定价且竞价
@property (nonatomic, strong) AJKSaveMessModel *saveMessModel;//日志model

@property (nonatomic, assign) BOOL isChildClass;//是否是子类
@property BOOL needFileNO; //是否需要备案号，部分城市需要备案号（北京）

- (void)setTextFieldForProperty;
- (BOOL)canAddMoreImageWithAddCount:(int)addCount;
- (void)setHouseTypeShowWithString:(NSString *)string vDict:(NSDictionary *)dict; //设置房型文案
//初始化_imgdescArr
- (void)initImgDesc;
////isT:false是取值,true赋值
//满5年的值
- (BOOL)fiveRadioValue:(BOOL)bValue getV:(BOOL)isT;
//唯一的值
- (BOOL)onlyRadioValue:(BOOL)bValue getV:(BOOL)isT;

- (BOOL)checkUploadProperty;

- (int)getCurrentRoomImgCount;
- (int)getMaxAddRoomImgCountForPhotoAlbum;
- (void)prepareUploadImgArr;
- (NSString *)getImageJson;

- (void)doPushToHouseTypeVC;
- (void)drawFooter;

- (void)pickerDisappear;

@end
