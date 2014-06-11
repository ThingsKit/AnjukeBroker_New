//
//  HomeCell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-9.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "HomeCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation HomeCell
@synthesize cellTit;
@synthesize cellDes;
@synthesize dotView;
@synthesize dotImg;
@synthesize dotLab;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    self.cellTit = [[UILabel alloc] initWithFrame:CGRectMake(15, 4, 150, 30)];
    self.cellTit.backgroundColor = [UIColor clearColor];
    self.cellTit.font = [UIFont ajkH2Font];
    self.cellTit.textColor = [UIColor brokerBlackColor];
    [self.contentView addSubview:self.cellTit];
    
    self.cellDes = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, 200, 20)];
    self.cellDes.backgroundColor = [UIColor clearColor];
    self.cellDes.font = [UIFont ajkH4Font];
    self.cellDes.textColor = [UIColor brokerLightGrayColor];
    [self.contentView addSubview:self.cellDes];
    
    self.dotView = [[UIView alloc] initWithFrame:CGRectMake(70, 8, 8, 8)];
    [self.dotView setBackgroundColor:[UIColor clearColor]];
    
    self.dotImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.dotView.frame.size.width, self.dotView.frame.size.height)];
    self.dotImg.layer.masksToBounds = YES;
    self.dotImg.layer.cornerRadius = 4;
    [self.dotImg setImage:[UIImage createImageWithColor:[UIColor redColor]]];
    [self.dotView addSubview:self.dotImg];
    
    self.dotLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.dotView.frame.size.width, self.dotView.frame.size.height)];
    self.dotLab.textAlignment = NSTextAlignmentCenter;
    self.dotLab.textColor = [UIColor whiteColor];
    self.dotLab.backgroundColor = [UIColor clearColor];
    self.dotLab.font = [UIFont systemFontOfSize:10];
    [self.dotView addSubview:self.dotLab];
}

- (void)configWithModel:(id)model indexPath:(NSIndexPath *)indexPath{
    NSArray *arr = (NSArray *)model;
    
    NSArray *titAndDesArr = [[arr objectAtIndex:indexPath.row] componentsSeparatedByString:NSLocalizedString(@"=", nil)];
    
    self.cellTit.text = [NSString stringWithFormat:@"%@",[titAndDesArr objectAtIndex:0]];
    self.cellDes.text = [NSString stringWithFormat:@"%@",[titAndDesArr objectAtIndex:1]];
}

- (void)showDot:(BOOL)showDot dotNum:(NSInteger)dotNum offsetX:(float)offsetX{
    [self.dotView removeFromSuperview];
    if (showDot) {
        if (dotNum == 0) {
            self.dotLab.text = nil;
            self.dotView.frame = CGRectMake(offsetX, 8, 8, 8);
            self.dotImg.layer.cornerRadius = 4;
        }else{
            if (dotNum < 10) {
                self.dotView.frame = CGRectMake(offsetX, 5, 16, 16);
                self.dotLab.text = [NSString stringWithFormat:@"%d",dotNum];
            }else if (dotNum < 100){
                self.dotView.frame = CGRectMake(offsetX, 5, 20, 16);
                self.dotLab.text = [NSString stringWithFormat:@"%d",dotNum];
            }else{
                self.dotView.frame = CGRectMake(offsetX, 5, 24, 16);
                self.dotLab.text = @"99+";
            }
            self.dotImg.layer.cornerRadius = 8;
        }
        self.dotImg.frame = CGRectMake(0, 0, self.dotView.frame.size.width, self.dotView.frame.size.height);
        self.dotLab.frame = CGRectMake(0, 0, self.dotView.frame.size.width, self.dotView.frame.size.height);
        [self.contentView addSubview:self.dotView];
    }
}
@end
