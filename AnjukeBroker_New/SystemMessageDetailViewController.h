//
//  SystemMessageDetailViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"

@interface SystemMessageDetailViewController : RTViewController

@property (nonatomic, strong) UITextView *contentTextView;

- (void)drawTextWithContent:(NSString *)contentStr;

@end
