//
//  RTListCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTListCell.h"

@implementation RTListCell
@synthesize selectRow;
@synthesize cellHeight;
@synthesize lineView, topLine;
@synthesize indexTag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGues:)];
        longPressGestureRecognizer.cancelsTouchesInView = NO;
        longPressGestureRecognizer.minimumPressDuration = 0.1;
        [self addGestureRecognizer:longPressGestureRecognizer];
        
        [self initUI];
    }
    return self;
}

- (void)longGues:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateFailed || gesture.state == UIGestureRecognizerStateCancelled) {
        [self setHighlighted:NO];
    }else if (gesture.state == UIGestureRecognizerStateBegan){
        [self setHighlighted:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (BOOL)configureCell:(id)dataModel {
    return NO;
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    self.selectRow = index;
    return NO;
}

- (void)initUI {
}

//显示向上箭头
- (void)showUpArrowImg {
    CGFloat imgW = 25/2;
    CGFloat imgH = 16/2;
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon11_.png"]];
    arrow.frame = CGRectMake(320 - imgW*2, 15, imgW, imgH);
    arrow.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:arrow];
}

- (void)showBottonLineWithCellHeight:(CGFloat)cellH {
    if (self.lineView == nil) {
        self.lineView = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, cellH -0.5, 320 - 0, 0.5)];
        [self.contentView addSubview:self.lineView];
    }
    else {
        self.lineView.frame = CGRectMake(0, cellH -0.5, 320 - 0, 0.5);
    }
}

- (void)showBottonLineWithCellHeight:(CGFloat)cellH andOffsetX:(CGFloat)offsetX {
    if (self.lineView == nil) {
        self.lineView = [[BrokerLineView alloc] initWithFrame:CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5)];
        [self.contentView addSubview:self.lineView];
    }
    else {
        self.lineView.frame = CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5);
    }
}
- (void)showTopLineWithOffsetX:(CGFloat)offsetX {
    if (self.topLine == nil) {
        self.topLine = [[BrokerLineView alloc] initWithFrame:CGRectMake(offsetX, -0.5, 320 - offsetX, 0.5)];
        [self.contentView addSubview:self.topLine];
    }
    
    self.topLine.frame = CGRectMake(offsetX, 0, 320 - offsetX, 0.5);
    
}

- (void)showTopLine {
    if (self.topLine == nil) {
        self.topLine = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, -0.5, 320 - 0, 0.5)];
        [self.contentView addSubview:self.topLine];
    }
    
    self.topLine.frame = CGRectMake(0, 0, 320 - 0, 0.5);
    
}

- (UIView *)baseCellBackgroundView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CELL_HEIGHT)];
    view.backgroundColor = [UIColor whiteColor];
    
    return view;
}


@end
