//
//  SegmentView.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 5/20/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SegmentView;
@protocol SegmentViewDelegate <NSObject>

- (void)didSelectedIndex:(NSInteger)index;

@end

@interface SegmentView : UIView

@property (nonatomic, assign)id<SegmentViewDelegate> delegate;
@property (nonatomic) NSInteger selectedSegmentIndex;
@property (nonatomic, strong) UIColor *selectedBackGroundColor;
@property (nonatomic, strong) UIColor *selectedButTitleColor;
@property (nonatomic, strong) UIColor *disSelectedButTitleColor;

- (void)setLeftButTitle:(NSString *)title withColor:(UIColor *)color;
- (void)setRightButTitle:(NSString *)title withColor:(UIColor *)color;
- (void)setLeftButBackColor:(UIColor *)color;
- (void)setRightButBackColor:(UIColor *)color;
- (void)setSelectedBGColor:(UIColor *)color;
- (void)setDisSelectTitleColor:(UIColor *)disColor selectedTitleColor:(UIColor *)selectedColor;
@end
