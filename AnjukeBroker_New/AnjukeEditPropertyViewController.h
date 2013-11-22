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
#import "ELCImagePickerController.h"
#import "CommunityListViewController.h"
#import "Property.h"
#import "LoginManager.h"
#import "ConfigPlistManager.h"
#import "AnjukeEditableTV_DataSource.h"
#import "InputOrderManager.h"

@interface AnjukeEditPropertyViewController : RTViewController <UITableViewDelegate, BrokerPickerDelegate, UITextFieldDelegate ,UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, KeyboardBarClickDelegate, CellTextFieldEditDelegate, BigImageViewBtnClickDelegate, PhotoViewClickDelegate, ELCImagePickerControllerDelegate, CommunitySelectDelegate>

@property BOOL isHaozu;
@property (nonatomic, strong) Property *property;
@property (nonatomic, strong) AnjukeEditableTV_DataSource *dataSource;

//公开函数，仅继承页面使用
- (void)setCommunityWithText:(NSString *)string; //设置小区名，上次使用
- (void)doSave;
- (void)setTextFieldForProperty;

@end
