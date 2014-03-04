//
//  AXChatPhotoActionSheet.m
//  Anjuke2
//
//  Created by Gin on 3/4/14.
//  Copyright (c) 2014 anjuke inc. All rights reserved.
//

#import "AXChatPhotoActionSheet.h"

@interface AXChatPhotoActionSheet ()

@property (nonatomic, strong) void (^completion)(NSUInteger index);
@property (nonatomic, strong) UIButton *background;

@end

@implementation AXChatPhotoActionSheet

#pragma mark - getters and setters
- (UIButton *)background
{
    if (!_background) {
        _background = [UIButton buttonWithType:UIButtonTypeCustom];
        _background.frame = [[UIScreen mainScreen] bounds];
        [_background addTarget:self action:@selector(backgroundButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _background;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public Method
- (void)showWithBlock:(void (^)(NSUInteger))completion
{
    
    if ([self superview]) {
        return;
    }
    
    self.completion = completion;
    self.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 190, 320, 170);
    self.backgroundColor = [UIColor colorWithHex:0xbbbbbb alpha:1.0f];
    self.alpha = 0.9f;
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(30, 50, 260, 43);
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5;
    [saveBtn addTarget:self action:@selector(savebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor colorWithHex:0xffffff alpha:1.0f] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0xda4c3e alpha:1.0f]] forState:UIControlStateNormal];
    [self addSubview:saveBtn];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(30, saveBtn.bottom + 20, 260, 43);
    cancelBtn.layer.cornerRadius = 5.0f;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHex:0x434343 alpha:1.0f]] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHex:0xc9c9c9 alpha:1.0f] forState:UIControlStateNormal];
    [self addSubview:cancelBtn];
    
    [[AppDelegate sharedInstance].window addSubview:self.background];
    [[AppDelegate sharedInstance].window addSubview:self];
    self.top = [[UIScreen mainScreen] bounds].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.top = self.top - self.height;
    }];

}

- (void)backgroundButtonClicked:(id)sender
{
    [self cancelbuttonClicked:nil];
}

- (void)savebuttonClicked:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = self.top + self.height;
    } completion:^(BOOL finished) {
        [self.background removeFromSuperview];
        [self removeFromSuperview];
    }];
    self.completion(1);
}

- (void)cancelbuttonClicked:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        self.top = self.top + self.height;
    } completion:^(BOOL finished) {
        [self.background removeFromSuperview];
        [self removeFromSuperview];
    }];
    self.completion(0);
}

@end
