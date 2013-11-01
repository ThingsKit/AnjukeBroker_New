//
//  MoreListCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-1.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "MoreListCell.h"

@implementation MoreListCell
@synthesize messageSwtich;

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
    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(320 - 25 - 35, (MORE_CELL_H - 20)/2-5, 30, 20)];
    sw.on = YES;
    self.messageSwtich = sw;
    [self.contentView addSubview:sw];
    
}

@end
