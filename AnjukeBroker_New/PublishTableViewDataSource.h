//
//  PublishTableViewDataSource.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-19.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputOrderManager.h"

#define PUBLISH_SECTION_HEIGHT 20

@interface PublishTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) id             superViewController;
@property (nonatomic, strong) NSMutableArray *inputCellArray; //直接保存输入cell的array
@property (nonatomic, strong) NSMutableArray *indexJumpCellArray; //通过上一项、下一项切换的cell的array
@property (nonatomic, assign) BOOL           isSafeNum;//是否需要备案号

- (void)createCells:(NSArray *)dataArray isHaozu:(BOOL)isHaozu;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForHeaderInSection:(NSInteger)section;
- (CGFloat)heightForFooterInSection:(NSInteger)section;

- (UIView *)viewForHeaderInSection:(NSInteger)section;
- (UIView *)viewForFooterInSection:(NSInteger)section;

- (void)houseTypeCellImageIconShow:(BOOL)show isHaozu:(BOOL)isHaozu; //户型图是否显示多图icon

@end
