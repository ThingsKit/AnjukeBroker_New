//
//  AnjukeEditableCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@protocol CellTextFieldEditDelegate <NSObject>

- (void)textFieldBeginEdit:(UITextField *)textField; //textField开始编辑代理
- (void)textFieldDidEndEdit:(NSString *)text; //textField结束编辑代理，用以记录数值

@end

@interface AnjukeEditableCell : RTListCell <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *text_Field;
@property (nonatomic, assign) id <CellTextFieldEditDelegate> editDelegate;
@property (nonatomic, strong) UILabel *unitLb;

@property int inputed_RowAtCom0; //上一次选择picke数据的index，用于输入时校对上一次的输入
@property int inputed_RowAtCom1;
@property int inputed_RowAtCom2;

@end
