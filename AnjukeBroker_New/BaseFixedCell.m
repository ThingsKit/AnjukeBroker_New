//
//  BaseFixedCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseFixedCell.h"
#import "FixedObject.h"
#import "LoginManager.h"
#import "Util_UI.h"

@implementation BaseFixedCell
@synthesize tapNum;
@synthesize tapNumStr;
@synthesize topCost;
@synthesize topCostStr;
@synthesize totalCost;
@synthesize totalCostStr;
@synthesize statusimg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

-(void)initUI{
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 71)];
    content.backgroundColor = [Util_UI colorWithHexString:@"#EFEFF4"];
    self.statusimg = [[UIImageView alloc] init];
    self.statusimg.frame = CGRectMake(10, 28, 30, 13);
    [content addSubview:self.statusimg];
    
    self.tapNum = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 50, 20)];
    self.tapNum.backgroundColor = [UIColor clearColor];
    self.tapNum.textColor = SYSTEM_BLACK;
//    self.tapNum.text = @"10";
    self.tapNum.font = [UIFont systemFontOfSize:20];
    [content addSubview:self.tapNum];
    
    self.tapNumStr = [[UILabel alloc] initWithFrame:CGRectMake(50, 42, 320, 20)];
    self.tapNumStr.backgroundColor = [UIColor clearColor];
    self.tapNumStr.font = [UIFont systemFontOfSize:12];
    self.tapNumStr.textColor = SYSTEM_LIGHT_GRAY;
    self.tapNumStr.text = @"总点击";
    [content addSubview:self.tapNumStr];
    
    self.totalCost = [[UILabel alloc] initWithFrame:CGRectMake(155, 15, 50, 20)];
    self.totalCost.backgroundColor = [UIColor clearColor];
    self.totalCost.textColor = SYSTEM_BLACK;
    self.totalCost.font = [UIFont systemFontOfSize:20];
//    self.totalCost.text = @"100";
    [content addSubview:self.totalCost];
    
    self.totalCostStr = [[UILabel alloc] initWithFrame:CGRectMake(145, 42, 320, 20)];
    self.totalCostStr.backgroundColor = [UIColor clearColor];
    self.totalCostStr.font = [UIFont systemFontOfSize:12];
    self.totalCostStr.text = @"总花费(元)";
    self.totalCostStr.textColor = SYSTEM_LIGHT_GRAY;
    [content addSubview:self.totalCostStr];
    
    self.topCost = [[UILabel alloc] initWithFrame:CGRectMake(250, 15, 50, 20)];
    self.topCost.backgroundColor = [UIColor clearColor];
    self.topCost.textColor = SYSTEM_BLACK;
    self.topCost.font = [UIFont systemFontOfSize:20];
//    self.topCost.text = @"99.0";
    [content addSubview:self.topCost];
    
    self.topCostStr = [[UILabel alloc] initWithFrame:CGRectMake(245, 42, 320, 20)];
    self.topCostStr.backgroundColor = [UIColor clearColor];
    self.topCostStr.textColor = SYSTEM_LIGHT_GRAY;
//    self.topCostStr.text = @"日限额";
    self.topCostStr.font = [UIFont systemFontOfSize:12];
    [content addSubview:self.topCostStr];
    [self.contentView addSubview:content];
}

-(BOOL)configureCell:(id)dataModel isAJK:(BOOL) isAJK{
    if([dataModel isKindOfClass:[FixedObject class]]){
        FixedObject *obj = (FixedObject *)dataModel;
        self.tapNum.text = [NSString stringWithFormat:@"%@", obj.tapNum];
        self.totalCost.text = [NSString stringWithFormat:@"%@", obj.cost];
        self.topCost.text = [NSString stringWithFormat:@"%@", obj.topCost];
        [self setFixedImg:obj];
        if([LoginManager isSeedForAJK:isAJK]){
            self.topCostStr.frame = CGRectMake(225, 42, 320, 20);
            self.topCostStr.text = @"每日最高花费";
        }else{
            self.topCostStr.frame = CGRectMake(245, 42, 320, 20);
            self.topCostStr.text = @"日限额";
        }
        DLog(@"%d",[LoginManager isSeedForAJK:YES]);
        return YES;
    }
    return NO;
}
//设置状态
-(void)setFixedImg:(FixedObject *) obj{
    if([obj.fixedStatus isEqualToString:@"1"]){
        self.statusimg.image = [UIImage imageNamed:@"anjuke_icon09_woking@2x.png"];
    }else{
    self.statusimg.image = [UIImage imageNamed:@"anjuke_icon09_stop@2x.png"];
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
