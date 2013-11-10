//
//  AnjukeEditableCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@protocol CellTextFieldEditDelegate <NSObject>

- (void)textFieldBeginEdit:(UITextField *)textField;

@end

@interface AnjukeEditableCell : RTListCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *text_Field;
@property (nonatomic, assign) id <CellTextFieldEditDelegate> editDelegate;
@property (nonatomic, strong) UILabel *unitLb;

@property int inputed_RowAtCom0; //上一次选择picke数据的index，用于输入时校对上一次的输入
@property int inputed_RowAtCom1;
@property int inputed_RowAtCom2;

@end
