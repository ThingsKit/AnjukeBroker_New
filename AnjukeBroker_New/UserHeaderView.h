//
//  MoreHeaderView.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterModel.h"

@interface UserHeaderView : UIView
- (void)setImageView:(UIImage *)img;
- (void)updateUserHeaderInfo:(NSString *)name;
- (void)updateWchatData:(UserCenterModel *)model;
//- (void)scrollViewDrag:(UIScrollView *)scrollView;
//- (void)setLoading;
//- (void)hideLoading;
@end
