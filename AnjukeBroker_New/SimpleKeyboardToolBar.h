//
//  SimpleKeyboardToolBar.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-24.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleKeyboardBarClickDelegate <NSObject>
- (void)SK_finishBtnClicked; //完成按钮点击delegate
@end

@interface SimpleKeyboardToolBar : UIToolbar

@property (nonatomic, assign) id <SimpleKeyboardBarClickDelegate> clickDelagate;

@end
