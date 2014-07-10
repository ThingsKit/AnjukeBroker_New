//
//  MultipleChoiceAndEditListCell.h
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTListCell.h"
#import "SWTableViewCell.h"

@protocol CellSelectStatusDelegate <NSObject>

- (void)cellStatusChanged:(BOOL)isSelect atRowIndex:(NSInteger)rowIndex;

@end

@class PropertyDetailCellModel;

@interface MultipleChoiceAndEditListCell : SWTableViewCell

@property (nonatomic, strong) PropertyDetailCellModel* propertyDetailTableViewCellModel;
@property (nonatomic, weak) id<CellSelectStatusDelegate> cellSelectstatusDelegate;
@property (nonatomic) NSInteger rowIndex;
@property (nonatomic) BOOL isHaozu;
@property (nonatomic) BOOL isViolation;

- (void)changeCellSelectStatus:(BOOL)isSelected;
- (void)showBottonLineWithCellHeight:(CGFloat)cellH andOffsetX:(CGFloat)offsetX;

@end
