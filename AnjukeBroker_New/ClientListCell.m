//
//  ClientListCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientListCell.h"
#import "Util_UI.h"
#import "WebImageView.h"

@implementation ClientListCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    CGFloat imgW = 45;
    WebImageView *icon = [[WebImageView alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, (MESSAGE_LIST_HEIGHT - imgW)/2, imgW, imgW)];
    self.imageIcon = icon;
    icon.layer.cornerRadius = 5;
    icon.layer.borderColor = SYSTEM_LIGHT_GRAY.CGColor;
    icon.layer.borderWidth = 0.5;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:icon];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + 12, icon.frame.origin.y, 150, 20)];
    self.nameLb = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = SYSTEM_BLACK;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];

}

@end
