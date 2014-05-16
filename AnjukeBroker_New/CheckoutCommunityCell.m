//
//  CheckoutCommunityCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "CheckoutCommunityCell.h"
#import "CheckCommunityModel.h"
#import "UIFont+RT.h"

#define CHECKOUTSTATEFRAME CGRectMake(200,0,90,48)

@implementation CheckoutCommunityCell
@synthesize checkStatusLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initUI {
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.checkStatusLab = [[UILabel alloc] initWithFrame:CHECKOUTSTATEFRAME];
    self.checkStatusLab.textAlignment = NSTextAlignmentRight;
    self.checkStatusLab.textColor = [UIColor ajkGreenColor];
    self.checkStatusLab.backgroundColor = [UIColor clearColor];
    self.checkStatusLab.font = [UIFont ajkH3Font];
    [self.contentView addSubview:self.checkStatusLab];    

    
}
- (BOOL)configureCell:(id)dataModel withIndex:(int)index{
    if ([dataModel isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)dataModel;
        if (arr.count == 0) {
            return NO;
        }
        CheckCommunityModel *model = [CheckCommunityModel convertToMappedObject:[arr objectAtIndex:index]];
        
        self.textLabel.text = [NSString stringWithFormat:@"%@",model.commName];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16];
        self.checkStatusLab.text = model.signAble ? @"已签到" : @"";
    }
    return YES;
}

@end
