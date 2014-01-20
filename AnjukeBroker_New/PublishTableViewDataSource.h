//
//  PublishTableViewDataSource.h
//  AnjukeBroker_New
//
//  Created by paper on 14-1-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishTableViewDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, assign) id superViewController;

- (void)createCells:(NSArray *)dataArray isHaozu:(BOOL)isHaozu;


@end
