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
@synthesize lineView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    [self initUI];
        // Initialization code
    }
    return self;
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
    selectRow = index;
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

@end
