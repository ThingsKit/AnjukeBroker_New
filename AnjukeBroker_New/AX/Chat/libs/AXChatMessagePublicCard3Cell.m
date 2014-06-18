//
//  AXChatMessagePublicCard2Cell.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-6-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AXChatMessagePublicCard3Cell.h"
#import "AXChatMessagePublicCellTopButton.h"
#import "AXChatMessagePublicCellButton.h"

@interface AXChatMessagePublicCard3Cell ()
@property(nonatomic, strong) UIImageView *backgoundView;

@end

@implementation AXChatMessagePublicCard3Cell
@synthesize pcCardCell2Delegate;

- (UIImageView *)backgoundView{
    if (!_backgoundView) {
        _backgoundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"xproject_dialogue_articalcard.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
        [self.contentView addSubview:_backgoundView];
    }
    return _backgoundView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initUI{
    [super initUI];
}

- (void)configWithData:(NSDictionary *)data{
    NSDictionary *dic = [data[@"content"] JSONValue];
    
    NSInteger subEventCount = [dic[@"props"] count];
    
    self.backgoundView.frame = CGRectMake(15, 0, ScreenWidth - 15*2, 155 + (subEventCount -1)*66);
    
    AXChatMessagePublicCellTopButton *topButton = [[AXChatMessagePublicCellTopButton alloc] initWithData:dic[@"props"][0]];
    topButton.tag = 0;
    [topButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topButton];

    for (int i = 1; i < subEventCount; i++) {
        AXChatMessagePublicCellButton *button = [[AXChatMessagePublicCellButton alloc] initWithData:dic[@"props"][i]];
        button.frame = CGRectMake(0, 156+66*(i-1), button.frame.size.width, button.frame.size.height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)buttonClick:(id)sender{
    NSDictionary *dic = [[NSDictionary alloc] init];
    if ([sender isKindOfClass:[AXChatMessagePublicCellTopButton class]]) {
        dic = [(AXChatMessagePublicCellTopButton *)sender data];
    }else{
        dic = [(AXChatMessagePublicCellButton *)sender data];
    }
    if (self.pcCardCell2Delegate && [self.pcCardCell2Delegate respondsToSelector:@selector(didOpenPublicCard2:senderInfo:)]) {
        [self.pcCardCell2Delegate didOpenPublicCard2:self senderInfo:dic];
    }
}

@end
