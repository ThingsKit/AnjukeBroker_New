//
//  AnjukeNormalCell.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-28.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeNormalCell.h"
#import "Util_UI.h"
#import "AJKBRadioButton.h"

@implementation AnjukeNormalCell
@synthesize communityDetailLb;
@synthesize titleLb;

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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.backgroundColor = [UIColor whiteColor];
        self.backgroundView = [self baseCellBackgroundView];
    }
    return self;
}

- (void)initUI {
    self.textLabel.textColor = SYSTEM_DARK_GRAY;
    
    UILabel *comTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, (CELL_HEIGHT - 20)/2, 90, 20)];
    comTitleLb.backgroundColor = [UIColor clearColor];
    comTitleLb.textColor = SYSTEM_DARK_GRAY;
    comTitleLb.font = [UIFont systemFontOfSize:17];
    self.titleLb = comTitleLb;
    [self.contentView addSubview:comTitleLb];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(224/2, 3,  150, CELL_HEIGHT - 1*5)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = SYSTEM_BLACK;
    lb.font = [UIFont systemFontOfSize:17];
    self.communityDetailLb = lb;
    [self.contentView addSubview:lb];
    
    CGFloat iconW = 20;
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(260, (CELL_HEIGHT - iconW)/2, iconW, iconW)];
    iv.backgroundColor = [UIColor clearColor];
    self.iconImage = iv;
    [self.contentView addSubview:iv];
    
    [self showBottonLineWithCellHeight:CELL_HEIGHT];
}

//
- (UIView *)drawSpecView
{
    self.accessoryType = UITableViewCellAccessoryNone;
    UIView *specView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    
    
    CGFloat inViewY = 20;
    CGFloat inViewX = 110;
    CGFloat inViewWidth = 75;
    CGFloat inViewHeight = 45;
    
    UIView *radioOne = [self radioButtonView:CGRectMake(inViewX, inViewY, inViewWidth, inViewHeight) title:@"满五年"];
    [radioOne setTag:-1];
    
    inViewX = inViewX + CGRectGetWidth(radioOne.frame);
    
    UIView *radioTwo = [self radioButtonView:CGRectMake(inViewX, inViewY, inViewWidth, inViewHeight) title:@"唯一住房"];
    [radioTwo setTag:-2];
    
    [specView addSubview:radioOne];
    [specView addSubview:radioTwo];
    
    [self.contentView addSubview:specView];
    
    
    return specView;
}

- (UIView *)radioButtonView:(CGRect)rdFrame title:(NSString *)titleS
{
    UIImage *img = [UIImage imageNamed:@"anjuke_icon_choosed"];
    UIView *specView = [[UIView alloc] initWithFrame:rdFrame];
    AJKBRadioButton *rdMoreFive = [[AJKBRadioButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [rdMoreFive setTag:110];
    [rdMoreFive setIsChoose:NO];
    
    //cgMoreFivela
    CGFloat moLaX = rdMoreFive.frame.origin.x + CGRectGetWidth(rdMoreFive.frame);
    CGFloat moLaY = rdMoreFive.frame.origin.y - 5;
    
    UIFont *srFont = [UIFont systemFontOfSize:16];
    CGSize srSize = [titleS sizeWithFont:srFont];
    UIButton *moreFiveLa = [[UIButton alloc] initWithFrame:CGRectMake(moLaX, moLaY, srSize.width, 25)];
    [[moreFiveLa titleLabel] setTextAlignment:NSTextAlignmentLeft];
    [moreFiveLa setTitle:titleS forState:UIControlStateNormal];
    [moreFiveLa setTitleColor:SYSTEM_BLACK forState:UIControlStateNormal];
    [[moreFiveLa titleLabel] setFont:srFont];
    [moreFiveLa addTarget:rdMoreFive action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    
    [specView addSubview:rdMoreFive];
    [specView addSubview:moreFiveLa];
    
    return specView;
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
//    self.textLabel.text = title;
    self.titleLb.text = title;
    
    return YES;
}

@end
