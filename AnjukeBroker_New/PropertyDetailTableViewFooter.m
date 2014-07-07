//
//  PropertyDetailTableViewFooter.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyDetailTableViewFooter.h"
#import "PropertyDetailButton.h"

@interface PropertyDetailTableViewFooter ()

@property (nonatomic, strong) PropertyDetailButton* buttonEdit;  //编辑按钮
@property (nonatomic, strong) PropertyDetailButton* buttonDelete;  //删除按钮

@end


@implementation PropertyDetailTableViewFooter

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
    self.frame = CGRectMake(0, ScreenHeight - 20 - 44 - 49, ScreenWidth, 49);
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.7;
    
    _buttonEdit = [PropertyDetailButton buttonWithType:UIButtonTypeCustom];
    _buttonEdit.frame = CGRectMake(0, 0, ScreenWidth*0.5, 49);
    [_buttonEdit setImage:[UIImage imageNamed:@"broker_property_edit"] forState:UIControlStateNormal];
    [_buttonEdit setTitle:@"编辑" forState:UIControlStateNormal];
    [_buttonEdit addTarget:self action:@selector(editPropertyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _buttonDelete = [PropertyDetailButton buttonWithType:UIButtonTypeCustom];
    _buttonDelete.frame = CGRectMake(ScreenWidth*0.5, 0, ScreenWidth*0.5, 49);
    [_buttonDelete setImage:[UIImage imageNamed:@"broker_property_delete"] forState:UIControlStateNormal];
    [_buttonDelete setTitle:@"删除" forState:UIControlStateNormal];
    [_buttonDelete addTarget:self action:@selector(deletePropertyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_buttonEdit];
    [self addSubview:_buttonDelete];
    
}

#pragma mark -
#pragma Button Action
- (void)editPropertyButtonClicked:(UIButton*)button{
    NSLog(@"编辑房源");
    if (self.editBlock != nil) {
        _editBlock(button);
    }
}

- (void)deletePropertyButtonClicked:(UIButton*)button{
    NSLog(@"删除房源");
    if (self.deleteBlock != nil) {
        _deleteBlock(button);
    }
}

@end
