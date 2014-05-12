//
//  MoreHeaderView.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserHeaderView : UIView
- (void)setImageView:(UIImage *)img;
- (void)updateUserHeaderInfo:(NSDictionary *)dic;
- (void)updateWchatData:(NSDictionary *)dic;
- (void)scrollViewDrag:(UIScrollView *)scrollView;
- (void)setLoading;
- (void)hideLoading;
@end
