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

#define TITLE_OFFESTX 17

@implementation SystemMessageCell
@synthesize contentLb, dataLb;

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
    
    UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, 5, lbW, 55)];
    lb1.backgroundColor = [UIColor clearColor];
    lb1.font = [UIFont systemFontOfSize:15];
    lb1.textColor = SYSTEM_BLACK;
    lb1.numberOfLines = 0;
    self.contentLb = lb1;
    [self.contentView addSubview:lb1];
    
    UIButton *showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showBtn.frame = CGRectMake(TITLE_OFFESTX, lb1.frame.size.height + lb1.frame.origin.x -5, 50, 20);
    showBtn.backgroundColor = [UIColor clearColor];
    [showBtn addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:showBtn];
    
    UILabel *lbBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, showBtn.frame.size.width, showBtn.frame.size.height)];
    lbBtn.backgroundColor = [UIColor clearColor];
    lbBtn.font = [UIFont systemFontOfSize:15];
    lbBtn.text = @"全文";
    lbBtn.textColor = SYSTEM_ORANGE;
    [showBtn addSubview:lbBtn];
    
    UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_OFFESTX, SYSTEM_MESSAGE_CELL_H - 20-5, 200, 20)];
    lb2.backgroundColor = [UIColor clearColor];
    lb2.font = [UIFont systemFontOfSize:15];
    lb2.textColor = SYSTEM_LIGHT_GRAY;
    self.dataLb = lb2;
    [self.contentView addSubview:lb2];
    
    UIButton *dBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dBtn.frame = CGRectMake(320 - TITLE_OFFESTX -50, lb2.frame.origin.y-2, 50, 20);
    dBtn.backgroundColor = [UIColor clearColor];
    [dBtn addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:dBtn];
    
    UILabel *lbBtn2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, showBtn.frame.size.width, showBtn.frame.size.height)];
    lbBtn2.backgroundColor = [UIColor clearColor];
    lbBtn2.font = [UIFont systemFontOfSize:15];
//    lbBtn2.text = @"删除";
    lbBtn2.textColor = SYSTEM_ORANGE;
    [dBtn addSubview:lbBtn2];
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
    
    self.selectRow = index;
    
    //test
    self.contentLb.text = [tempDic objectForKey:@"content"];
    
    self.dataLb.text = [Util_TEXT getDateStrWithDate:[NSDate date]];
//    self.dataLb.text = [tempDic objectForKey:@"title"];
    return YES;
}

- (void)showAll:(id)sender {
    
}

- (void)doDelete:(id)sender {
    
}

@end
