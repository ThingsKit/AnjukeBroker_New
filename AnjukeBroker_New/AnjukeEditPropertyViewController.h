//
//  AnjukeEditPropertyViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"
#import "RTInputPickerView.h"
#import "KeyboardToolBar.h"
#import "AnjukeEditableCell.h"
#import "PropertyBigImageViewController.h"
#import "PhotoShowView.h"
#import "BK_ELCImagePickerController.h"
#import "BK_ELCAlbumPickerController.h"
#import "CommunityListViewController.h"
#import "Property.h"
#import "LoginManager.h"
#import "ConfigPlistManager.h"
#import "AnjukeEditableTV_DataSource.h"
#import "InputOrderManager.h"
#import "PhotoButton.h"
#import "E_Photo.h"
#import "PhotoManager.h"
#import "Util_UI.h"
#import "ASIFormDataRequest.h"
#import "BK_RTNavigationController.h"
#import "AnjukeOnlineImgController.h"
#import "SimpleKeyboardToolBar.h"
#import "AnjukeEditTextViewController.h"

#define PhotoImg_MAX_COUNT 10 //最多上传照片数
#define MAX_PHOTO_ALERT_MESSAGE @"最多仅可添加10张图亲"
 
#define PhotoImg_H 76
#define PhotoImg_Gap 10
#define photoHeaderH 100
#define photoHeaderH_RecNum 100 +50
#define Input_H 260

#define IMAGE_MAXSIZE_WIDTH 600 //屏幕预览图的最大分辨率，只负责预览显示

#define TagOfImg_Base 1000
#define TagOfActionSheet_Img 901
#define TagOfActionSheet_Save 902

@interface AnjukeEditPropertyViewController : RTViewController <UITableViewDelegate, UITextFieldDelegate ,UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KeyboardBarClickDelegate, CellTextFieldEditDelegate, BigImageViewBtnClickDelegate, PhotoViewClickDelegate, ELCImagePickerControllerDelegate, CommunitySelectDelegate, OnlineImgSelectDelegate, SimpleKeyboardBarClickDelegate, TextFieldModifyDelegate>

@property BOOL isHaozu;
@property (nonatomic, strong) Property *property;
@property (nonatomic, strong) AnjukeEditableTV_DataSource *dataSource;
@property (nonatomic, strong) NSMutableArray *imgBtnArray;
@property BOOL isTakePhoto; //是否拍照，区别拍照和从相册取图
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIScrollView *photoSV;
@property int imageSelectIndex; //记录选择的第几个image
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property int uploadImgIndex; //上传图片的顺序，每上传一张此index+1
@property (nonatomic, strong) NSMutableArray *houseTypeImgArr; //在线房形图数组，只保存一个imgDic

@property BOOL hideOnlineImg; //是否需要在线房形图功能
@property (nonatomic, strong) UITextField *fileNoTextF; //备案号输入框
@property (nonatomic, strong) SimpleKeyboardToolBar *simToolBar;
@property (nonatomic, strong) UITableView *tvList;
@property BOOL                             needFileNO; //是否需要备案号，部分城市需要备案号（北京）

@property BOOL inPhotoProcessing;
@property BOOL isTBBtnPressedToShowKeyboard; //是否是通过上一项、下一项点按控制键盘、滚轮显示，是则屏蔽textField的delegate方法

//公开函数，仅继承页面使用
- (void)setCommunityWithText:(NSString *)string; //设置小区名，上次使用
- (void)doSave;
- (void)setTextFieldForProperty;
- (void)refreshPhotoHeader;
- (NSString *)getImageJson;
- (void)doPushToCommunity;
- (void)showPhoto:(id)sender;
- (void)addPhoto;
- (void)setDefultValue;

- (BOOL)checkUploadProperty;
@end
