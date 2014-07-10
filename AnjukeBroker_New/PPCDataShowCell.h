//
//  PPCDataShowCell.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTListCell.h"

typedef enum : NSUInteger {
    CELLTYPEFORPRICING,
    CELLTYPEFORSELECTING,
    CELLTYPEFORBIT,
} CELLTYPE;

@interface PPCDataShowCell : RTListCell
@property(nonatomic, assign) CELLTYPE cellType;
@end
