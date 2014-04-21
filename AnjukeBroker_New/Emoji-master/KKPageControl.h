//
//  KKPageControl.h
//  WeiboDemo1
//
//  Created by leo.zhu on 14-4-18.
//  Copyright (c) 2014年 3k. All rights reserved.
//

//
//  PageControl.h
//
//  Replacement for UIPageControl because that one only supports white dots.
//
//  Created by Morten Heiberg <morten@heiberg.net> on November 1, 2010.
//

#import <UIKit/UIKit.h>

@protocol KKPageControlDelegate;

@interface KKPageControl : UIView
{
@private
    NSInteger _currentPage;
    NSInteger _numberOfPages;
    UIColor *dotColorCurrentPage;
    UIColor *dotColorOtherPage;
    NSObject<KKPageControlDelegate> *delegate;
    //If ARC use __unsafe_unretained id delegate;
}

// Set these to control the PageControl.
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

// Customize these as well as the backgroundColor property.
@property (nonatomic, retain) UIColor *dotColorCurrentPage;
@property (nonatomic, retain) UIColor *dotColorOtherPage;

// Optional delegate for callbacks when user taps a page dot.
@property (nonatomic, retain) NSObject<KKPageControlDelegate> *delegate;

@end

@protocol KKPageControlDelegate<NSObject>
@optional
- (void)pageControlPageDidChange:(KKPageControl *)pageControl;
@end
