//
//  UIView+RT.h
//  AiFang
//
//  Created by lh liu on 12-3-20.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AF)

- (id)initWithFullView;
- (id)initWithMainView;
- (id)initWithTabView;
- (void)setHeight:(CGFloat)height;
- (CGFloat)left;
- (CGFloat)right;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (void)setLeft:(CGFloat)left;
- (void)setBottom:(CGFloat)bottom;
- (void)setSize:(CGSize)size;
- (void)setTop:(CGFloat)top;
- (void)setWidth:(CGFloat)width;
- (void)setOrigin:(CGPoint)point;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;
- (void)setAddTop:(CGFloat)top;
- (void)setAddLeft:(CGFloat)left;
- (void)setEdgeLikeTableGrouped;

- (void)addBottomLinesWithUpHex:(uint)uplineHex downHex:(uint)downlineHex;

@end
