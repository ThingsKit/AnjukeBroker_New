//
//  AnjukeFeatureCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-4-21.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "AnjukeFeatureCell.h"

@implementation AnjukeFeatureCell
@synthesize titleLb, clickImg;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = [self baseCellBackgroundView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initUI {
    CGFloat imgW = 20;
    
    UIImageView *imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, (CELL_HEIGHT - imgW)/2, imgW, imgW)];
    imgIcon.backgroundColor = [UIColor clearColor];
    imgIcon.contentMode = UIViewContentModeScaleAspectFit;
    self.clickImg = imgIcon;
    [self.contentView addSubview:imgIcon];
    
    UILabel *comTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE + imgW + CELL_OFFSET_TITLE, (CELL_HEIGHT - 20)/2, 90, 20)];
    comTitleLb.backgroundColor = [UIColor clearColor];
    comTitleLb.textColor = SYSTEM_DARK_GRAY;
    comTitleLb.font = [UIFont systemFontOfSize:17];
    self.titleLb = comTitleLb;
    [self.contentView addSubview:comTitleLb];
}

- (void)configureCellStatus:(BOOL)isClick {    
    self.clickImg.image = nil;
    if (isClick) {
        self.clickImg.image = [UIImage imageNamed:@"anjuke_icon06_selected.png"];
    }
    else
        self.clickImg.image = [UIImage imageNamed:@"anjuke_icon06_select.png"];
    
}

@end
