//
//  BrokerPicker.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-22.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTInputPickerView.h"
#import "PropertyDataManager.h"

@implementation RTInputPickerView
@synthesize pickerType;
@synthesize firstArray, secondArray, thirdArray;
@synthesize brokerPickerDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        [self initModel];
        
        self.dataSource = self;
        self.delegate = self;
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

#pragma mark - method

- (void)initModel {
    self.firstArray = [NSArray array];
    self.secondArray = [NSArray array];
    self.thirdArray = [NSArray array];
}

//***根据当前输入的内容（第几行）判断所需提供的输入dataSource***
- (void)reloadPickerWithRow:(int)row {
    self.firstArray = [NSArray array];
    self.secondArray = [NSArray array];
    self.thirdArray = [NSArray array];
    
    //get data
    switch (row) { //户型
        case 1:
        {
            self.firstArray = [PropertyDataManager getPropertyHuxingArray_Shi];
            self.secondArray = [PropertyDataManager getPropertyHuxingArray_Ting];
            self.thirdArray = [PropertyDataManager getPropertyHuxingArray_Wei];
        }
            break;
        case 4: //装修
        {
            self.firstArray = [PropertyDataManager getPropertyZhuangxiu];
        }
            break;
            
        case 5: //朝向
        {
            self.firstArray = [PropertyDataManager getPropertyChaoXiang];
        }
            break;
        case 6: //楼层
        {
            self.firstArray = [PropertyDataManager getPropertyLou_Number];
            self.secondArray = [PropertyDataManager getPropertyCeng_Number];
        }
            break;

        default:
            break;
            
    }
    
    [self reloadAllComponents];
}

#pragma mark - UIPickerView DataSource & Delegate

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.thirdArray.count > 0) {
        return 3;
    }
    else if (self.secondArray.count > 0) {
        return 2;
    }
    else if (self.firstArray.count > 0) {
        return 1;
    }
    
    return 0;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return [self.firstArray count];
    }
    else if (component == 1) {
        return [self.secondArray count];
    }
    else{
        return [self.thirdArray count];
    }
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [self.firstArray objectAtIndex:row];
            break;
        case 1:
            return [self.secondArray objectAtIndex:row];
            break;
        case 2:
            return [self.thirdArray objectAtIndex:row];
            break;
            
        default:
            break;
    }
    
    return @"";
}

@end
