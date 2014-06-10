//
//  PPCHeaderView.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-10.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPCHeaderView : UIView

@property(nonatomic ,strong) UILabel *clickNumLab;
@property(nonatomic ,strong) UILabel *todayCostLab;


- (void)updatePPCData:(NSDictionary *)dic isAJK:(BOOL)isAJK;
@end
