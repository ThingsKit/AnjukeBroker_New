//
//  BrokerPicker.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-22.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "BrokerPicker.h"
#import "PropertyDataManager.h"

@implementation BrokerPicker
@synthesize pickerType;
@synthesize firstArray, secondArray, thirdArray;
@synthesize picker;
@synthesize brokerPickerDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor whiteColor];
        [self initModel];
        
        //NaviBar
        UINavigationBar *naviBar = [[UINavigationBar alloc]
                                    initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        naviBar.barStyle = UIBarStyleDefault;
        [self addSubview:naviBar];
        
        //完成btn
        UINavigationItem *item = [[UINavigationItem alloc] init];
        UIBarButtonItem *submitBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doFinish)];
		item.rightBarButtonItem = submitBtn;
        
        //上一个、下一个btn
        UIBarButtonItem *preBtn = [[UIBarButtonItem alloc] initWithTitle:@"  <  " style:UIBarButtonItemStylePlain target:self action:@selector(doPrevious)];
        UIBarButtonItem *nextBtn = [[UIBarButtonItem alloc] initWithTitle:@"  >  " style:UIBarButtonItemStylePlain target:self action:@selector(doNext)];
		item.leftBarButtonItems = [NSArray arrayWithObjects:preBtn, nextBtn, nil];
        
        naviBar.items = [NSArray arrayWithObject:item];
        
        //数据滚轮
        UIPickerView *pk = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height - 44)];
        self.picker = pk;
        pk.dataSource = self;
        pk.delegate = self;
        [self addSubview:pk];

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

- (void)doFinish {
    if ([self.brokerPickerDelegate respondsToSelector:@selector(finishBtnClicked)]) {
        [self.brokerPickerDelegate finishBtnClicked];
    }
}

- (void)doPrevious {
    if ([self.brokerPickerDelegate respondsToSelector:@selector(preBtnClicked)]) {
        [self.brokerPickerDelegate preBtnClicked];
    }
}

- (void)doNext {
    if ([self.brokerPickerDelegate respondsToSelector:@selector(nextBtnClicked)]) {
        [self.brokerPickerDelegate nextBtnClicked];
    }
}

- (void)pickerHide:(BOOL)hide{ //根据是否需要显示滚轮控制picker的显示
    if (hide) {
        [self.picker removeFromSuperview];
    }
    else
        [self addSubview:self.picker];
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
    //reload
    [self.picker reloadAllComponents];
    
}

#pragma mark - UIPickerView DataSource & Delegate

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (self.pickerType) {
        case PickerTypeHuXing:
            return 3;
            break;
            
        default:
            break;
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
