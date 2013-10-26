//
//  KeyboardToolBar.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-26.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardBarClickDelegate <NSObject>

- (void)finishBtnClicked; //完成按钮点击delegate
- (void)preBtnClicked;
- (void)nextBtnClicked;

@end

@interface KeyboardToolBar : UIToolbar

@property (nonatomic, assign) id <KeyboardBarClickDelegate> clickDelagate;

@end
