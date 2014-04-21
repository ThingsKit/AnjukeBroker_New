//
//  Broker_InputEditView.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-21.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DisplayStyle_ForTextField = 0,
    DisplayStyle_ForTextView
} DisplayStyle;

#define INPUT_EDIT_VIEW_H 45
#define INPUT_EDIT_TEXTVIEW_H 90

@interface Broker_InputEditView : UIView<UITextViewDelegate>

@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UITextField *textFidle_Input;
@property (nonatomic, strong) UITextView *textView_Input;

@property (nonatomic, assign) DisplayStyle displayStyle;

- (void)addLineViewWithOriginY:(CGFloat)originY;
- (void)drawInputWithStyle:(DisplayStyle)style;

@end
