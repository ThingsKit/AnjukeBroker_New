//
//  RTLaunchAdd.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTLaunchImg.h"

@implementation RTLaunchImg

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (UIImageView *)loadLaunchAdd:(UIImage *)img{
    float originY = 0;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        originY = 20;
    }
 
    UIImageView *launchAddView = [[UIImageView alloc] initWithFrame:CGRectMake(0, originY, [self windowWidth], [self windowHeight]-originY)];
    launchAddView.image = img;
    launchAddView.contentMode = UIViewContentModeScaleAspectFill;
    return launchAddView;
}

+ (float)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}

+ (float)windowHeight {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
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
