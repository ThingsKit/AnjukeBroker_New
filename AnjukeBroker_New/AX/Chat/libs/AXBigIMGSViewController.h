//
//  BigIMGSViewController.h
//  X
//
//  Created by jianzhongliu on 2/20/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXBigIMGSViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) UIImage *img;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) NSMutableArray *myIMGArray;
// 当前展示的图片索引
@property (nonatomic, assign) NSUInteger currentPhotoIndex;

@end
