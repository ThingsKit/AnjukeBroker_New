//
//  PublishBigImageViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "RTViewController.h"

@protocol PublishBigImageViewClickDelegate <NSObject>

- (void)viewDidFinishWithImageArr:(NSArray *)imageArray;

@end

@interface PublishBigImageViewController : RTViewController <UIScrollViewDelegate>

@property (nonatomic, assign) id <PublishBigImageViewClickDelegate> clickDelegate;

- (void)showImagesWithArray:(NSArray *)imageArr atIndex:(int)index;

@end
