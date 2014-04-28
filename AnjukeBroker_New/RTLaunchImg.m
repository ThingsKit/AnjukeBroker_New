//
//  RTLaunchAdd.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-4-23.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
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
    UIImageView *launchAddView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self viewHeight])];
    launchAddView.image = img;
    launchAddView.contentMode = UIViewContentModeScaleToFill;
    
    return launchAddView;
}
+ (float)originY{
    float originY = 0;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")){
        originY = 20;
    }
    return originY;
}
+ (float)windowWidth {
    return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.width;
}

+ (float)viewHeight {
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height-20;
    }else{
        return [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame].size.height;
    }
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
