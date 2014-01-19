//
//  PublishTextCell.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishTextCell.h"

#define TEXTCELL_HEIGHT 45

@interface PublishTextCell : UIButton

@property (nonatomic, strong) UILabel *titleLb; //标题
@property (nonatomic, strong) UITextField *textF; //输入框
@property (nonatomic, strong) UILabel *unitLb; //单位
@property NSInteger *index;

@end
