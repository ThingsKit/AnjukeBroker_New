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

#define IMAGE_ACTIONSHEET_TAG 9010
#define PUBLISH_ACTIONSHEET_TAG 9020

@interface PublishBuildingViewController : RTViewController <UITableViewDelegate, KeyboardBarClickDelegate, CellTextFieldEditDelegate, UIActionSheetDelegate>

@property BOOL isHaozu; //是否是好租，页面布局不同
@property (nonatomic, strong) UITableView *tableViewList;
@property (nonatomic, strong) PublishTableViewDataSource *cellDataSource;
@property (nonatomic, strong) Property *property;

@property BOOL isTBBtnPressedToShowKeyboard; //是否是通过上一项、下一项点按控制键盘、滚轮显示，是则屏蔽textField的delegate方法

- (void)setTextFieldForProperty;

@end
