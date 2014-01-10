//
//  SystemCellManager.h
//  AnjukeBroker_New
//
//  Created by paper on 13-12-25.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYSTEM_MESSAGE_CELL_H 97
#define CONTENT_NORMAL_HEIGHT 55 //默认3行的内容高度
#define TITLE_OFFESTX 17

@interface SystemCellManager : NSObject

+ (CGFloat)getCellHeightForExpand:(BOOL)expand withContentStr:(NSString *)contentStr;
+ (CGFloat)getContentLabelHeightForExpand:(BOOL)expand withContentStr:(NSString *)contentStr;

@end
