//
//  HZWaitingForPromotedViewController.m
//  AnjukeBroker_New
//
//  Created by xubing on 14-7-1.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "HZWaitingForPromotedViewController.h"

@interface HZWaitingForPromotedViewController ()

@property (nonatomic, strong) UIButton *buttonSelect;  //编辑按钮
@property (nonatomic, strong) UIButton *buttonPromote;  //删除按钮

@end

@implementation HZWaitingForPromotedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"租房待推广房源"];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50) style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    self.MutipleEditView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 49 -64, ScreenWidth, 49)];
    
    self.MutipleEditView.backgroundColor = [UIColor brokerBlackColor];
    self.MutipleEditView.alpha = 0.7;
    
    _buttonSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonSelect.frame = CGRectMake(0, 0, ScreenWidth * 0.48, 49);
    
    
    UIImageView *selectImage = [[UIImageView alloc] initWithFrame:CGRectMake((56 - 22)/2, (50 - 22)/2, 22, 22)];
    [selectImage setImage:[UIImage imageNamed:@"broker_property_control_select_gray@2x.png"]];
    [_buttonSelect addSubview:selectImage];
    
    UILabel *allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 10, 80, 40)];
    allSelectLabel.font = [UIFont ajkH2Font];
    allSelectLabel.text = @"全选";
    allSelectLabel.textColor = [UIColor whiteColor];
    allSelectLabel.centerY = 50/2;
    allSelectLabel.left = selectImage.right + 5;
    [_buttonSelect addSubview:allSelectLabel];
    
    
    _buttonPromote = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonPromote.frame = CGRectMake(0, 12, 120, 33);
    _buttonPromote.right = ScreenWidth - 10;
    _buttonPromote.centerY = 50/2;
    _buttonPromote.titleLabel.font = [UIFont ajkH3Font];
    [_buttonPromote setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_button_little_blue@2x.png"] forState:UIControlStateNormal];
    [_buttonPromote setTitle:[NSString stringWithFormat:@"定价推广(%@)", @"6"]  forState:UIControlStateNormal];
    
    [self.MutipleEditView addSubview:_buttonSelect];
    [self.MutipleEditView addSubview:_buttonPromote];

    [self.view addSubview:self.tableView];
    [self.view addSubview:self.MutipleEditView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifierCell";
    MultipleChoiceAndEditListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MultipleChoiceAndEditListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"identifierCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    cell.rightUtilityButtons = [self rightButtons];
//    cell.delegate = self;
//    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MultipleChoiceAndEditListCell *oldCell = (MultipleChoiceAndEditListCell *)[tableView cellForRowAtIndexPath:indexPath];
    

}


//- (NSArray *)rightButtons
//{
//    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
//                                                title:@"More"];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:
//     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
//                                                title:@"Delete"];
//    
//    return rightUtilityButtons;
//}
//
//- (void)sw_addUtilityButtonWithColor:(UIColor *)color title:(NSString *)title
//{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = color;
//    [button setTitle:title forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////    [self addObject:button];
//}


@end
