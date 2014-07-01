//
//  PromotionSettingsViewController.m
//  AnjukeBroker_New
//
//  Created by jason on 6/30/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "PromotionSettingsViewController.h"
#import "RTListCell.h"

#define MORE_CELL_H 96/2
@interface PromotionSettingsViewController ()

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *dataSrouce;
@property(nonatomic,strong) UISwitch *ESFPricePromotionSwitch;
@property(nonatomic,strong) UISwitch *ZFPricePromotionSwitch;
@property(nonatomic,strong) UILabel  *ESFPlanceilingLabel;
@property(nonatomic,strong) UILabel  *ZFPlanceilingLabel;

@end

@implementation PromotionSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSrouce = @[@[@"二手房定价推广",@"二手房每日限额"],@[@"租房定价推广",@"租房每日限额"]];
    [self setTitleViewWithString:@"推广设置"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIView navigationControllerBound] style:UITableViewStyleGrouped];
    tableView.dataSource   = self;
    tableView.delegate     = self;
    tableView.rowHeight    = 44;
    tableView.sectionFooterHeight = 0;
    self.tableView         = tableView;
    [self.view addSubview:tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSrouce count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSrouce objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"idenfifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            switch (indexPath.section) {
                case 0:
                {
                    self.ESFPricePromotionSwitch    = [[UISwitch alloc] initWithFrame:CGRectMake(255, (MORE_CELL_H - 20)/2 - 5, 30, 20)];
                    self.ESFPricePromotionSwitch.on = YES;
                    [self.ESFPricePromotionSwitch addTarget:self action:@selector(checkESFPricePromotionSwitch:) forControlEvents:UIControlEventValueChanged];
                    [cell addSubview:self.ESFPricePromotionSwitch];
                }
                    break;
                case 1:
                {
                    self.ZFPricePromotionSwitch    = [[UISwitch alloc] initWithFrame:CGRectMake(255, (MORE_CELL_H - 20)/2 - 5, 30, 20)];
                    self.ZFPricePromotionSwitch.on = YES;
                    [self.ZFPricePromotionSwitch addTarget:self action:@selector(checkZFPricePromotionSwitch:) forControlEvents:UIControlEventValueChanged];
                    [cell addSubview:self.ZFPricePromotionSwitch];
                }
                    break;
                default:
                    break;
            }
            
        } else if (indexPath.row == 1) {
            switch (indexPath.section) {
                case 0:
                {
                    self.ESFPlanceilingLabel      = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 60, 15)];
                    self.ESFPlanceilingLabel.text = @"100元";
                    self.ESFPlanceilingLabel.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:self.ESFPlanceilingLabel];
                }
                    break;
                case 1:
                {
                    self.ZFPlanceilingLabel      = [[UILabel alloc] initWithFrame:CGRectMake(240, 15, 60, 15)];
                    self.ZFPlanceilingLabel.text = @"100元";
                    self.ZFPlanceilingLabel.font = [UIFont systemFontOfSize:17];
                    [cell addSubview:self.ZFPlanceilingLabel];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
    cell.textLabel.text = [[self.dataSrouce objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 1) {
        
        switch (indexPath.section) {
                
            case 0:
                
                break;
            case 1:
                
                break;
            default:
                break;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (void)checkESFPricePromotionSwitch:(id)sender
{
    if (!self.ESFPricePromotionSwitch.on) {
        
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"二手房定价推广" message:@"关闭后，所有定价房源将暂停推广" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭", nil];
        alert.tag      = 10;
        [alert show];
        
    } else {
        
        
        
        
    }
}

- (void)checkZFPricePromotionSwitch:(id)sender
{
    
    if (!self.ZFPricePromotionSwitch.on) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"租房定价推广" message:@"关闭后，所有定价房源将暂停推广" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"关闭", nil];
        alert.tag      = 20;
        [alert show];
        
    } else {
        
        
        
    }
    
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 10 && buttonIndex == 0) {
        
        self.ESFPricePromotionSwitch.on = YES;
        
    } else if (alertView.tag == 10 && buttonIndex == 1){
        
        self.ESFPricePromotionSwitch.on = NO;
        
    } else if (alertView.tag == 20 && buttonIndex == 0) {
        
        self.ZFPricePromotionSwitch.on = YES;
        
    } else if (alertView.tag == 20 && buttonIndex == 1) {
        
        self.ZFPricePromotionSwitch.on = NO;
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
