//
//  ClientListCell.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-19.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientListCell.h"
#import "Util_UI.h"
#import "WebImageView.h"
#import "RTListCell.h"
#import "AXMappedPerson.h"
#import "Util_TEXT.h"

@implementation ClientListCell
@synthesize imageIcon, nameLb;
@synthesize lineView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons];
    
    if (self) {
        [self initUI];
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

- (void)initUI {
    WebImageView *icon = [[WebImageView alloc] initWithFrame:CGRectMake(CELL_OFFSET_TITLE, (CLIENT_LIST_HEIGHT - IMG_ICON_H)/2, IMG_ICON_H, IMG_ICON_H)];
    self.imageIcon = icon;
    icon.layer.cornerRadius = 5;
    //    icon.layer.borderColor = [UIColor whiteColor].CGColor;
    //    icon.layer.borderWidth = 0.5;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    icon.clipsToBounds = YES;
    [self.contentView addSubview:icon];
    
    CGFloat nameLbH = 30;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x + icon.frame.size.width + CELL_OFFSET_TITLE, icon.frame.origin.y+(IMG_ICON_H - nameLbH)/2 , 200, nameLbH)];
    self.nameLb = nameLabel;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = SYSTEM_BLACK;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    
}

- (BOOL)configureCellWithData:(id)data {
    
    [self cleanValue];
    
    AXMappedPerson *item = (AXMappedPerson *)data;
    
    if (item.iconUrl.length > 0) {
        if (item.isIconDownloaded) {
            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
            self.imageIcon.image = [[UIImage alloc] initWithContentsOfFile:[libraryPath stringByAppendingPathComponent:item.iconPath]];
            //            self.imageIcon.image = [UIImage imageWithContentsOfFile:item.iconPath];
        }
        else {
            self.imageIcon.image = [UIImage imageNamed:@"anjuke_icon_headpic.png"];
            self.imageIcon.imageUrl = item.iconUrl;
        }
    }
    else {
        self.imageIcon.image = [UIImage imageNamed:@"anjuke_icon_headpic.png"];
    }
    self.imageIcon.imageUrl = item.iconUrl;
    
    if (item.markName.length > 0) {
        self.nameLb.text = item.markName;
    }
    else {
        self.nameLb.text = item.name;
        if ([item.name isEqualToString:item.phone] || item.name.length == 0) {
            self.nameLb.text = [Util_TEXT getChatNameWithPhoneFormat:item.phone];
        }
        if ([self.nameLb.text isEqualToString:@"(null)"]) {
            self.nameLb.text = [Util_TEXT getChatNameWithPhoneFormat:item.phone];
        }
    }
    
    return YES;
}

- (void)cleanValue {
    //    self.imageIcon.image = nil;
    self.nameLb.text = @"";
}

- (void)showBottonLineWithCellHeight:(CGFloat)cellH andOffsetX:(CGFloat)offsetX {
    if (self.lineView == nil) {
        self.lineView = [[BrokerLineView alloc] initWithFrame:CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5)];
        [self.contentView addSubview:self.lineView];
    }
    else {
        self.lineView.frame = CGRectMake(offsetX, cellH -0.5, 320 - offsetX, 0.5);
    }
}

@end
