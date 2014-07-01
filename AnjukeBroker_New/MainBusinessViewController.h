//
//  FirstViewController.h
//  Tel
//
//  Created by xubing on 13-12-20.
//  Copyright (c) 2013年 xubing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+AIFFrame.h"
#import "RTViewController.h"

@protocol MainBusinessDelegate <NSObject>
- (void)processMainBusinessNameWithDic:(NSDictionary *)dic;
@end

@interface MainBusinessViewController : RTViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) id <MainBusinessDelegate> delegate;
@property (nonatomic, strong) NSDictionary *selectCellInfo;
@property (nonatomic, strong) NSString *cityId;
<<<<<<< HEAD
@property (nonatomic) int tag;
=======
>>>>>>> add register model

@end
