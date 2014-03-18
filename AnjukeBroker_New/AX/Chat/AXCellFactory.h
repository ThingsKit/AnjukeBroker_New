//
//  AXCellFactory.h
//  Anjuke2
//
//  Created by Gin on 3/2/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AXChatBaseCell.h"

@interface AXCellFactory : NSObject

+ (AXChatBaseCell *)cellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary *)dic withIdentity:(NSString *)identity;

test


@end
