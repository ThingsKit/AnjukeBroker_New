//
//  SWTableViewCell.h
//  SWTableViewCell
//
//  Created by Chris Wendel on 9/10/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "SWCellScrollView.h"
#import "SWLongPressGestureRecognizer.h"
#import "SWUtilityButtonTapGestureRecognizer.h"
#import "NSMutableArray+SWUtilityButtons.h"

@class MutipleEditTableViewCell;

typedef enum {
    mCellStateCenter,
    mCellStateLeft,
    mCellStateRight
} MCellState;

@protocol TableViewCellDelegate <NSObject>

@optional
- (void)swipeableTableViewCell:(MutipleEditTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(MutipleEditTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swipeableTableViewCell:(MutipleEditTableViewCell *)cell scrollingToState:(MCellState)state;
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(MutipleEditTableViewCell *)cell;
- (BOOL)swipeableTableViewCell:(MutipleEditTableViewCell *)cell canSwipeToState:(MCellState)state;

@end

@interface MutipleEditTableViewCell : UITableViewCell

@property (nonatomic, copy) NSArray *leftUtilityButtons;
@property (nonatomic, copy) NSArray *rightUtilityButtons;
@property (nonatomic, weak) id <TableViewCellDelegate> delegate;

- (void)hideUtilityButtonsAnimated:(BOOL)animated;
- (void)showLeftUtilityButtonsAnimated:(BOOL)animated;
- (void)showRightUtilityButtonsAnimated:(BOOL)animated;

- (BOOL)isUtilityButtonsHidden;

@end
