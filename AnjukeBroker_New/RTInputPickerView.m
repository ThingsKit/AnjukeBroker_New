//
//  BrokerPicker.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-22.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "RTInputPickerView.h"
#import "PropertyDataManager.h"
#import "InputOrderManager.h"

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
- (void)reloadPickerWithRow:(int)row isHaozu:(BOOL)isHaozu {
    self.firstArray = [NSArray array];
    self.secondArray = [NSArray array];
    self.thirdArray = [NSArray array];
    
    if (isHaozu) {
        //get data
        switch (row) { //户型
            case HZ_P_ROOMS:
            {
                self.firstArray = [PropertyDataManager getPropertyHuxingArray_Shi];
                self.secondArray = [PropertyDataManager getPropertyHuxingArray_Ting];
                self.thirdArray = [PropertyDataManager getPropertyHuxingArray_Wei];
            }
                break;
            case HZ_P_FITMENT: //装修
            {
                self.firstArray = [PropertyDataManager getPropertyZhuangxiu];
            }
                break;
            case HZ_P_RENTTYPE: //出租方式
            {
                self.firstArray = [PropertyDataManager getPropertyRentType];
            }
                break;
                
            case HZ_P_EXPOSURE: //朝向
            {
                self.firstArray = [PropertyDataManager getPropertyChaoXiang];
            }
                break;
            case HZ_P_FLOORS: //楼层
            {
                self.firstArray = [PropertyDataManager getPropertyLou_Number];
                self.secondArray = [PropertyDataManager getPropertyCeng_Number];
            }
                break;
                
            default:
                break;
                
        }
    }
    else { //二手房
        //get data
        switch (row) { //户型
            case AJK_P_ROOMS:
            {
                self.firstArray = [PropertyDataManager getPropertyHuxingArray_Shi];
                self.secondArray = [PropertyDataManager getPropertyHuxingArray_Ting];
                self.thirdArray = [PropertyDataManager getPropertyHuxingArray_Wei];
            }
                break;
            case AJK_P_FITMENT: //装修
            {
                self.firstArray = [PropertyDataManager getPropertyZhuangxiu];
            }
                break;
                
            case AJK_P_EXPOSURE: //朝向
            {
                self.firstArray = [PropertyDataManager getPropertyChaoXiang];
            }
                break;
            case AJK_P_FLOORS: //楼层
            {
                self.firstArray = [PropertyDataManager getPropertyLou_Number];
                self.secondArray = [PropertyDataManager getPropertyCeng_Number];
            }
                break;
                
            default:
                break;
                
        }
    }
    
    
    [self reloadAllComponents];
    
}

- (void)pickerScrollToRowAtIndex:(NSInteger)row atCom:(NSInteger)com{
    if (com == 1 && self.secondArray.count == 0) {
        return;
    }
    if (com == 2 && self.thirdArray.count == 0) {
        return;
    }
    
    [self selectRow:row inComponent:com animated:NO];
}

#pragma mark - UIPickerView DataSource & Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
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

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
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
            return [[self.firstArray objectAtIndex:row] objectForKey:@"Title"];
            break;
        case 1:
            return [[self.secondArray objectAtIndex:row] objectForKey:@"Title"];
            break;
        case 2:
            return [[self.thirdArray objectAtIndex:row] objectForKey:@"Title"];
            break;
            
        default:
            break;
    }
    
    return @"";
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    CGFloat lbW = 100;
//    CGFloat lbH = 30;
//    
//    UILabel *titleLb = [[UILabel alloc] init];
//    titleLb.font = [UIFont systemFontOfSize:17];
//    titleLb.frame = CGRectMake(0, 0, lbW, lbH);
//    titleLb.textAlignment = NSTextAlignmentCenter;
//    titleLb.backgroundColor = [UIColor clearColor];
//    
//    switch (component) {
//        case 0:
//            titleLb.text = [self.firstArray objectAtIndex:row];
//            break;
//        case 1:
//            titleLb.text = [self.secondArray objectAtIndex:row];
//            break;
//        case 2:
//            titleLb.text = [self.thirdArray objectAtIndex:row];
//            break;
//            
//        default:
//            break;
//    }
//    
//    return titleLb;
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    NSMutableString *string = [NSMutableString string];
    
    DLog(@"r[%d] c[%d]", row, component);
}

@end
