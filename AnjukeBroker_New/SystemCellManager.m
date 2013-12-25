//
//  SystemCellManager.m
//  AnjukeBroker_New
//
//  Created by paper on 13-12-25.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "SystemCellManager.h"
#import "Util_UI.h"

@implementation SystemCellManager

+ (CGFloat)getCellHeightForExpand:(BOOL)expand withContentStr:(NSString *)contentStr {
    if (!expand) { //不展开的高度
        return SYSTEM_MESSAGE_CELL_H;
    }
    
    //展开的cell高度
    CGFloat cellHeight = 0;
    CGFloat expandContentH = [self getContentLabelHeightForExpand:expand withContentStr:contentStr]; //
    
    CGFloat diffHeight = expandContentH - CONTENT_NORMAL_HEIGHT; //展开内容高度差值
    cellHeight = SYSTEM_MESSAGE_CELL_H + diffHeight;
    
    return cellHeight;
}

+ (CGFloat)getContentLabelHeightForExpand:(BOOL)expand withContentStr:(NSString *)contentStr {
    if (!expand) { //不展开的高度
        return SYSTEM_MESSAGE_CELL_H;
    }
    
    CGSize size = [Util_UI sizeOfString:contentStr maxWidth:320 - TITLE_OFFESTX*2 withFontSize:15];
    return size.height;
}

@end
