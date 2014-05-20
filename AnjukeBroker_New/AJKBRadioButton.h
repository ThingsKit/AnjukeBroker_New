//
//  AJKBRadioButton.h
//  AnjukeBroker_New
//
//  Created by anjuke on 14-5-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AJKBRadioButtonDelegate <NSObject>

- (void)clickAction:(id)sender;

@end

@interface AJKBRadioButton : UIButton
{

}
@property (nonatomic, assign)BOOL isChoose;//是否选择
@property (nonatomic, assign)id   delegate;//代理

- (void)clickAction;

@end
