//
//  PublishTableViewDataSource.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InputOrderManager.h"

#define PUBLISH_SECTION_HEIGHT 10

@interface PublishTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) id superViewController;

- (void)createCells:(NSArray *)dataArray isHaozu:(BOOL)isHaozu;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForHeaderInSection:(NSInteger)section;
- (CGFloat)heightForFooterInSection:(NSInteger)section;

- (UIView *)viewForHeaderInSection:(NSInteger)section;
- (UIView *)viewForFooterInSection:(NSInteger)section;

@end
