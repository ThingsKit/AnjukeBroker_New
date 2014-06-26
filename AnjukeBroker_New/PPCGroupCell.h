//
//  PPCGroupCell.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTListCell.h"
@interface PPCGroupCell : RTListCell
{
    UILabel *title;
    UILabel *detail;
    UILabel *status;
    
}
@property (strong, nonatomic) UIImageView *statueImg;
-(void)setValueForCellByData:(id ) data index:(int) index isHz:(BOOL)isHz;
-(void)setFixedGroupValueForCellByData:(id ) data index:(int) index;
-(void)setFixedGroupValueForCellByData:(id ) data index:(int) index isAJK:(BOOL) isAJK;
@end
