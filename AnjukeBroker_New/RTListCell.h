//
//  RTListCell.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrokerLineView.h"

#define CELL_TITLE_FONT 15
#define CELL_HEIGHT 50

@interface RTListCell : UITableViewCell

@property int selectRow; //当前此cell所在row
@property CGFloat cellHeight;
@property (strong, nonatomic) BrokerLineView *lineView;

- (void)initUI; // init UI for cell reuse
- (BOOL)configureCell:(id)dataModel; //传递cell数据
- (BOOL)configureCell:(id)dataModel withIndex:(int)index; //传递cell数据_with Index

- (void)showUpArrowImg; //定制的cell向下箭头IMG

- (void)showBottonLineWithCellHeight:(CGFloat)cellH;

@end
