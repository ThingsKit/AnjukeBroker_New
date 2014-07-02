//
//  SWUtilityButtonView.h
//  SWTableViewCell
//
//  Created by Matt Bowman on 11/27/13.
//  Copyright (c) 2013 Chris Wendel. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUtilityButtonWidthDefault 90
@class SWTableViewCell;
@class MutipleEditTableViewCell;


@interface SWUtilityButtonView : UIView

@property (nonatomic, strong) NSArray *utilityButtons;
@property (nonatomic) CGFloat utilityButtonWidth;
@property (nonatomic, weak) SWTableViewCell *parentCell;
@property (nonatomic, weak) MutipleEditTableViewCell *mutipleCell;
@property (nonatomic) SEL utilityButtonSelector;
@property (nonatomic) CGFloat height;

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initUtilityButtons:(NSArray *)utilityButtons parentCell:(MutipleEditTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (id)initWithFrame:(CGRect)frame utilityButtons:(NSArray *)utilityButtons parentCell:(SWTableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (void)populateUtilityButtons;
- (CGFloat)utilityButtonsWidth;

@end
