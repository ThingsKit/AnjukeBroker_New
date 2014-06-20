//
//  AXChatMessagePublicCellButton.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXChatMessagePublicCellButton.h"
#import "BK_WebImageView.h"
#import "BrokerLineView.h"

@interface AXChatMessagePublicCellButton ()
//@property(nonatomic, strong) NSDictionary *data;
@end

@implementation AXChatMessagePublicCellButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithData:(NSDictionary *)dic{
    self = [AXChatMessagePublicCellButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _data = dic;
        
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.frame = CGRectMake(1, 0, 290 - 2, 66);
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(1, 0, self.frame.size.width-2, 1)];
    line.horizontalLine = YES;
    [self addSubview:line];
    
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 13, self.frame.size.width - 90, 40)];
    titLab.backgroundColor = [UIColor clearColor];
    titLab.textColor = [UIColor brokerBlackColor];
    titLab.lineBreakMode = UILineBreakModeWordWrap;
    titLab.numberOfLines = 0;
    titLab.textAlignment = NSTextAlignmentLeft;
    titLab.font = [UIFont ajkH3Font];
    titLab.text = _data[@"title"];
    [self addSubview:titLab];
    
    BK_WebImageView *img = [[BK_WebImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, 10, 50, 50)];
    [img setImageUrl:_data[@"img"]];
    [self addSubview:img];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [UIColor brokerBgSelectColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
