//
//  SystemMessageCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-31.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "SystemMessageCell.h"
#import "Util_UI.h"
#import "Util_TEXT.h"
#import "SystemCellManager.h"

#define Expand_Title @"全文"
#define PickUp_Title @"收起"

@implementation SystemMessageCell
@synthesize contentLb;
@synthesize dataLb;

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

- (void)initUI {
    CGFloat lbW = 320 - TITLE_OFFESTX*2;
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, 10, lbW, CONTENT_NORMAL_HEIGHT)];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont systemFontOfSize:15];
    lb1.textColor = SYSTEM_BLACK;
    lb1.numberOfLines = 0;
    self.contentLb = lb1;
    [self.contentView addSubview:lb1];
    
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, self.contentLb.frame.origin.y+ self.contentLb.frame.size.height+3, 200, 20)];
    lb2.backgroundColor = [UIColor clearColor];
    lb2.font = [UIFont systemFontOfSize:15];
    lb2.textColor = SYSTEM_LIGHT_GRAY;
    self.dataLb = lb2;
    [self.contentView addSubview:lb2];
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
    NSDictionary *tempDic = [NSDictionary dictionary];
    if([dataModel isKindOfClass:[NSArray class]]){
        tempDic = [dataModel objectAtIndex:index];
    
    }
        
    self.contentLb.text = [tempDic objectForKey:@"content"];
    
    CGFloat lbW = 320 - TITLE_OFFESTX*2;
    CGFloat contentH = [SystemCellManager getContentLabelHeightForExpand:YES withContentStr:[tempDic objectForKey:@"content"]];
    self.contentLb.frame = CGRectMake(TITLE_OFFESTX, 10, lbW, contentH);
    
    self.dataLb.frame = CGRectMake(TITLE_OFFESTX, self.contentLb.frame.origin.y+ self.contentLb.frame.size.height+3, 200, 20);
    
    [self transformDate:[[tempDic objectForKey:@"createtime"] doubleValue]];
    
    return YES;
}

- (void)transformDate:(double) timeInter{
    NSDate *postDate = [NSDate dateWithTimeIntervalSince1970:timeInter];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    NSDateComponents *postComponents = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:postDate];
    if (nowComponents.year == postComponents.year )
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    else
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    self.dataLb.text =  [dateFormatter stringFromDate:postDate];
}

@end
