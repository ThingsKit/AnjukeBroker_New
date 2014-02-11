//
//  FindPropertyCell.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 1/24/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "FindPropertyCell.h"
#import "Util_UI.h"

@implementation FindPropertyCell
@synthesize imgIcon;
@synthesize titleLab;
@synthesize detailLab;
@synthesize numLab;
@synthesize attentionLab;
@synthesize smallIcon;
@synthesize mapIcon;
@synthesize distantLab;
@synthesize fanIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
        // Initialization code
    }
    return self;
}

- (void)initUI {
    self.imgIcon = [[UIImageView alloc] init];
    self.imgIcon.frame = CGRectMake(15.0f / 2, 10, 65.0f/2, 65.0f / 2);
    [self.contentView addSubview:self.imgIcon];

    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(95.0f / 2, 5, 160, 25)];
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.titleLab.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titleLab];
    
    self.fanIcon = [[UIImageView alloc] init];
    [self.contentView addSubview:self.fanIcon];
    
    self.detailLab = [[UILabel alloc] initWithFrame:CGRectMake(95.0f / 2, 40, 200, 20)];
    self.detailLab.backgroundColor = [UIColor clearColor];
    self.detailLab.font = [UIFont systemFontOfSize:12];
    self.detailLab.textColor = [Util_UI colorWithHexString:@"#666666"];
    [self.contentView addSubview:self.detailLab];
    
    self.mapIcon = [[UIImageView alloc] initWithFrame:CGRectMake(260, 20, 24.0f / 2, 24.0f / 2)];
    self.mapIcon.image = [UIImage imageNamed:@"anjuke_icon_local@2x.png"];
    [self.contentView addSubview:self.mapIcon];
    
    self.distantLab = [[UILabel alloc] initWithFrame:CGRectMake(self.mapIcon.frame.origin.x + 15, 15, 60 - 25.0f / 2, 20)];
    self.distantLab.font = [UIFont systemFontOfSize:12];
    self.distantLab.textColor = [Util_UI colorWithHexString:@"#666666"];
    [self.contentView addSubview:self.distantLab];
    

}
- (BOOL)configureCell:(id)dataModel {
    if ([dataModel isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *cellData = (NSMutableDictionary *) dataModel;
        

        
        self.distantLab.text = [cellData objectForKey:@"distance"];
        self.detailLab.text = [NSString stringWithFormat:@"昨日房源%@套    %@名用户关注", [cellData objectForKey:@"spreadNum"], [cellData objectForKey:@"totalVPPV"]];

    }
    
    return NO;
}

- (BOOL)configureCell:(id)dataModel withIndex:(int)index {
    if ([dataModel isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *cellData = (NSMutableDictionary *) dataModel;
        
        self.titleLab.text = [cellData objectForKey:@"name"];
        [self setFanIconAdjust:cellData];

        
        self.distantLab.text = [cellData objectForKey:@"distance"];
        self.detailLab.text = [NSString stringWithFormat:@"昨日房源%@套    %@名用户关注", [cellData objectForKey:@"spreadNum"], [cellData objectForKey:@"totalVPPV"]];
        [self setImgIconToCell:cellData :index];
        [self setDistantNum:dataModel];
    }
    return NO;
}
- (void)setFanIconAdjust:(NSDictionary *) cellData{
    if ([[cellData objectForKey:@"isFanComm"] integerValue] == 0) {
        CGSize si = [Util_UI sizeOfString:[cellData objectForKey:@"name"] maxWidth:320 withFontSize:15];
        self.fanIcon.frame = CGRectMake(self.titleLab.frame.origin.x + si.width +10, 10, 14, 14);
        self.fanIcon.image = [UIImage imageNamed:@"anjuke_icon_feedback@2x.png"];
    } else {
        self.fanIcon.image = nil;
    }

}

- (void)setImgIconToCell:(NSDictionary *) cellData :(int) index{
    if (index > 1) {
        [self setImgSmallIconByData:cellData];
    } else {
        [self setImgBigIconByData:cellData];
    }
}

- (void)setImgBigIconByData:(NSDictionary *) cellData {
    if ([[cellData objectForKey:@"commType"] isEqualToString:@"lanhai"]) {
        self.imgIcon.frame = CGRectMake(15.0f / 2, 10, 65.0f/2, 65.0f / 2);
        self.imgIcon.image = [UIImage imageNamed:@"anjuke_icon_bluesea_best@2x.png"];
    } else if ([[cellData objectForKey:@"commType"] isEqualToString:@"hot"]) {
        self.imgIcon.frame = CGRectMake(15.0f / 2, 10, 65.0f/2, 65.0f / 2);
        self.imgIcon.image = [UIImage imageNamed:@"anjuke_icon_hot_best@2x.png"];
    }
}

- (void)setImgSmallIconByData:(NSDictionary *) cellData {
    if ([[cellData objectForKey:@"commType"] isEqualToString:@"lanhai"]) {
        self.imgIcon.frame = CGRectMake(52.0f / 2, 10, 28.0f/2, 28.0f / 2);
        self.imgIcon.image = [UIImage imageNamed:@"anjuke_icon_bluesea1@2x.png"];
    } else if ([[cellData objectForKey:@"commType"] isEqualToString:@"hot"]) {
        self.imgIcon.frame = CGRectMake(52.0f / 2, 10, 28.0f/2, 28.0f / 2);
        self.imgIcon.image = [UIImage imageNamed:@"anjuke_icon_hot1@2x.png"];
    }
}

- (void)setDistantNum:(NSDictionary *)celldata {
    if ([[celldata objectForKey:@"distance"] intValue] < 1000) {
        self.distantLab.text = [NSString stringWithFormat:@"%dm", [[celldata objectForKey:@"distance"] intValue]];
    } else {
        self.distantLab.text = [NSString stringWithFormat:@"%dkm", [[celldata objectForKey:@"distance"] intValue] / 1000];
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
