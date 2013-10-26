//
//  BrokerPicker.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-22.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RT_PICKERVIEW_H 180.0

typedef NS_ENUM(NSInteger, PickerType){
    PickerTypeHuXing = 0,
    PickerTypeZhuangXiu,
    PickerTypeChaoXiang,
    PickertypeLouCeng
};

@protocol BrokerPickerDelegate <NSObject>

@end

@interface RTInputPickerView : UIPickerView  <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) PickerType pickerType;
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *secondArray;
@property (nonatomic, strong) NSArray *thirdArray;

@property (nonatomic, assign) id <BrokerPickerDelegate> brokerPickerDelegate;

- (void)reloadPickerWithRow:(int)row;

@end
