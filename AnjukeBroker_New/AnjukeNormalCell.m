//
//  AnjukeNormalCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeNormalCell.h"
#import "Util_UI.h"

@implementation AnjukeNormalCell
@synthesize communityDetailLb;

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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)initUI {
    self.textLabel.textColor = SYSTEM_DARK_GRAY;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(224/2, 3,  150, CELL_HEIGHT - 1*5)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = SYSTEM_BLACK;
    lb.font = [UIFont systemFontOfSize:17];
    self.communityDetailLb = lb;
    [self.contentView addSubview:lb];
    
    CGFloat iconW = 20;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(260, (CELL_HEIGHT - iconW)/2, iconW, iconW)];
    iv.backgroundColor = [UIColor clearColor];
    self.iconImage = iv;
    [self.contentView addSubview:iv];
    
    [self showBottonLineWithCellHeight:CELL_HEIGHT];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)configureCell:(id)dataModel {
    if (![dataModel isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *title = (NSString *)dataModel;
    
    //title
    self.textLabel.text = title;
    
    return YES;
}

@end
