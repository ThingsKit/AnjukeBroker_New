//
//  AnjukeEditableCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditableCell.h"

@implementation AnjukeEditableCell
@synthesize text_Field;
@synthesize editDelegate;

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;

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

- (BOOL)configureCell:(id)dataModel {
    if (![dataModel isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString *title = (NSString *)dataModel;
    
    //title
    self.textLabel.text = title;
//    self.textLabel.font = [UIFont systemFontOfSize:CELL_TITLE_FONT];
    
    //text field
    UITextField *cellTextField = nil;
    cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 1,  150, CELL_HEIGHT - 1*2)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.borderStyle = UITextBorderStyleNone;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.placeholder = @"";
    cellTextField.delegate = self;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.secureTextEntry = NO;
    self.text_Field = cellTextField;
    [self.contentView addSubview:cellTextField];
    
    return YES;
}

#pragma mark - TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.editDelegate respondsToSelector:@selector(textFieldBeginEdit:)]) {
        [self.editDelegate textFieldBeginEdit:textField];
    }
}

@end
