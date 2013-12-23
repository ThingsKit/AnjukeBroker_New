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
    self.lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 1, 305, 1)];
//        [self.lineView setBackgroundColor:[UIColor redColor]];
    [self.contentView addSubview:self.lineView];
//        [self.contentView setBackgroundColor:[UIColor greenColor]];
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

- (void)drawLine{
//    self.lineView.frame = CGRectMake(0, cellHeight-15, 305, 15);
    UIGraphicsBeginImageContext(self.lineView.frame.size);
    [self.lineView.image drawInRect:CGRectMake(0, 0, self.lineView.frame.size.width, self.lineView.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.1);
    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 46.0/255, 46.0/255, 46.0/255, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 15, 0);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 305, 0);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.lineView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
