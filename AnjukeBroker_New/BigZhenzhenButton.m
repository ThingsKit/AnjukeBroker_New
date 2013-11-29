//
//  BigZhenzhenButton.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-29.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "BigZhenzhenButton.h"
#import "Util_UI.h"

@implementation BigZhenzhenButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = SYSTEM_ZZ_RED;
        self.layer.cornerRadius = 5;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

@end
