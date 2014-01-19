//
//  PublishTextCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishTextCell.h"
#import "Util_UI.h"

#define LABEL_HEIGHT 30
#define LABEL_TITLE_FONT 17
#define LABEL_GAP 25/2

@implementation PublishTextCell
@synthesize titleLabel, unitLb, textF;
@synthesize index;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initDisplayWithFrame:frame];
    }
    return self;
}

- (void)initDisplayWithFrame:(CGRect)frame {
    //title
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_GAP, (TEXTCELL_HEIGHT- LABEL_HEIGHT)/2, 100, LABEL_HEIGHT)];
    title.backgroundColor = [UIColor greenColor]; //test
    title.textColor = SYSTEM_BLACK;
    title.font = [UIFont systemFontOfSize:LABEL_TITLE_FONT];
    self.titleLb = title;
    [self addSubview:title];
    
    //text field
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(title.frame.origin.x+title.frame.size.width, title.frame.origin.y,  150, title.frame.size.height)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor lightGrayColor]; //test
    cellTextField.borderStyle = UITextBorderStyleNone;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    cellTextField.delegate = self;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:LABEL_TITLE_FONT];
    cellTextField.textColor = SYSTEM_BLACK;
    self.textF = cellTextField;
    [self addSubview:cellTextField];
    
    //unit
    CGFloat unitLbW = 40;
    UILabel *unit = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-LABEL_GAP-unitLbW, (TEXTCELL_HEIGHT- LABEL_HEIGHT)/2, unitLbW, LABEL_HEIGHT)];
    unit.backgroundColor = [UIColor yellowColor]; //test
    unit.textColor = SYSTEM_LIGHT_GRAY;
    unit.font = [UIFont systemFontOfSize:LABEL_TITLE_FONT];
    self.unitLb = unit;
    [self addSubview:unit];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
