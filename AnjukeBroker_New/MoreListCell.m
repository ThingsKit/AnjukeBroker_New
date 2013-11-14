//
//  MoreListCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-1.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "MoreListCell.h"
#import "Util_UI.h"

@implementation MoreListCell
@synthesize messageSwtich;
@synthesize detailLb;

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
        
    }
    return self;
}

- (void)initUI {
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(224/2, 1,  170, CELL_HEIGHT - 1*5)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = SYSTEM_ORANGE;
    lb.textAlignment = NSTextAlignmentRight;
    lb.font = [UIFont systemFontOfSize:17];
    self.detailLb = lb;
    [self.contentView addSubview:lb];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    self.selectRow = index;
    
    if (![dataModel isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    NSString *title = [(NSArray *)dataModel objectAtIndex:index];
    
    //title
    self.textLabel.text = title;
    
    return YES;
}

- (void)showSwitch {
    if (!self.messageSwtich) {
        UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(320 - 25 - 35, (MORE_CELL_H - 20)/2-5, 30, 20)];
        sw.on = YES;
        self.messageSwtich = sw;
        [self.contentView addSubview:sw];
    }
}

- (void)setDetailText:(NSString *)string {
    self.detailLb.text = string;
}

@end
