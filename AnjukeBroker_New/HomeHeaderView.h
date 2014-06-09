//
//  HomeHeaderView.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol headerBtnClickDelegate <NSObject>

- (void)btnClickWithTag:(NSInteger)index;

@end

@interface HomeHeaderView : UIView

@property(nonatomic, assign) id<headerBtnClickDelegate> btnClickDelegate;

@end
