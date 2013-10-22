//
//  BrokerPicker.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-22.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PickerType){
    PickerTypeHuXing = 0,
    PickerTypeZhuangXiu,
    PickerTypeChaoXiang,
    PickertypeLouCeng
};

@protocol BrokerPickerDelegate <NSObject>

- (void)finishBtnClicked; //完成按钮点击delegate
- (void)preBtnClicked;
- (void)nextBtnClicked;

@end

@interface BrokerPicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) PickerType pickerType;
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *secondArray;
@property (nonatomic, strong) NSArray *thirdArray;

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, assign) id <BrokerPickerDelegate> brokerPickerDelegate;

- (void)pickerHide:(BOOL)hide;
- (void)reloadPickerWithRow:(int)row; //******

@end
