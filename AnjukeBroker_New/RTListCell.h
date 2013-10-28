//
//  RTListCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_TITLE_FONT 15
#define CELL_HEIGHT 50

@interface RTListCell : UITableViewCell

- (BOOL)configureCell:(id)dataModel; //传递cell数据

@end
