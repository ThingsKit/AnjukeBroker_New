//
//  AnjukeEditTextViewController.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-12-2.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@protocol TextFieldModifyDelegate <NSObject>

- (void)textDidInput:(NSString *)string isTitle:(BOOL)isTitle;

@end

@interface AnjukeEditTextViewController : RTViewController <UITextViewDelegate>

@property (nonatomic, copy) NSString *textString;
@property (nonatomic, assign) id <TextFieldModifyDelegate> textFieldModifyDelegate;
@property BOOL isTitle; //是房源标题还是房源详情

- (void)setTextFieldDetail:(NSString *)string;

@end
