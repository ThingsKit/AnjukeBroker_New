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
#import <QuartzCore/QuartzCore.h>

@interface AXChatMessagePublicCard3Cell ()
@property(nonatomic, strong) UIImageView *backgoundView;

@end

@implementation AXChatMessagePublicCard3Cell
@synthesize delegate;

- (UIImageView *)backgoundView{
    if (!_backgoundView) {
        _backgoundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"xproject_dialogue_articalcard.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5]];
        _backgoundView.backgroundColor = [UIColor clearColor];
        _backgoundView.frame = CGRectMake(15, 10, ScreenWidth - 15*2, 0);
        [self.contentView addSubview:_backgoundView];
    }
    return _backgoundView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor orangeColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)configWithData:(NSDictionary *)data{
    NSDictionary *dic = [data[@"content"] JSONValue];
    NSArray *arr = [NSArray arrayWithArray:dic[@"articles"]];
    
    self.identifyString = data[@"identifier"];
    
    NSInteger subEventCount = arr.count;
    
    self.backgoundView.frame = CGRectMake(15, 10, ScreenWidth - 15*2, 156 + (subEventCount -1)*66);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 10, 290, 156 + (subEventCount -1)*66)];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 8;
    [self addSubview:view];
    
    AXChatMessagePublicCellTopButton *topButton = [[AXChatMessagePublicCellTopButton alloc] initWithData:dic[@"articles"][0]];
    topButton.tag = 0;
    [topButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:topButton];

    for (int i = 1; i < subEventCount; i++) {
        AXChatMessagePublicCellButton *button = [[AXChatMessagePublicCellButton alloc] initWithData:dic[@"articles"][i]];
        button.frame = CGRectMake(1, 155 +66*(i-1), 290 - 2, button.frame.size.height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPressGesture:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
}

- (void)buttonClick:(id)sender{
    NSDictionary *dic = [[NSDictionary alloc] init];
    if ([sender isKindOfClass:[AXChatMessagePublicCellTopButton class]]) {
        dic = [(AXChatMessagePublicCellTopButton *)sender data];
    }else{
        dic = [(AXChatMessagePublicCellButton *)sender data];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didOpenPublicCard3:senderInfo:)]) {
        [self.delegate didOpenPublicCard3:self senderInfo:dic];
    }
}

@end
