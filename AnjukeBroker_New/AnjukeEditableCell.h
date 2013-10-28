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

@end
