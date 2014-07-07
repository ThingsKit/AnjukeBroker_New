//
//  PropertyDetailTableViewFooter.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditButtonBlock) (UIButton*); //返回类型void,  参数列表(void)
typedef void(^DeleteButtonBlock) (UIButton*); //返回类型void,  参数列表(void)

@interface PropertyDetailTableViewFooter : UIView

@property (nonatomic, copy) EditButtonBlock editBlock;  //编辑回调
@property (nonatomic, copy) DeleteButtonBlock deleteBlock; //删除回调

@end
