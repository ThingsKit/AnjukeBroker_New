//
//  CommunityListViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-5.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "CommunityListViewController.h"
#import "Util_UI.h"

#define CELL_HEIGHT 45

@interface CommunityListViewController ()

@property (nonatomic, strong) UITableView *tvList;
@property (nonatomic, strong) NSMutableArray *listDataArray;
@end

@implementation CommunityListViewController
@synthesize listDataArray;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)initModel {
    self.listDataArray = [NSMutableArray array];
}

- (void)initDisplay {
    UITextField *cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 270, 30)];
    cellTextField.backgroundColor = [UIColor whiteColor];
    cellTextField.delegate = self;
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.9 alpha:1];
    cellTextField.borderStyle = UITextBorderStyleNone;
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cellTextField.placeholder = @"请输入小区名或地址";
    cellTextField.delegate = self;
    cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.textAlignment = NSTextAlignmentCenter;
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = SYSTEM_BLACK;
    self.navigationItem.titleView = cellTextField;
    
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
    [self.view addSubview:tv];
}

- (void)doCancel {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView Delegate && DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"你是否在找";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cityCell = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCell];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cityCell];
        
    }
    else {
        
    }
    
    UIFont *font = [UIFont systemFontOfSize:18];
    
    cell.textLabel.text = [self.listDataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = font;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *keyword = [self.listDataArray objectAtIndex:indexPath.row];
    
//    [self saveKeywordHistoryWithString:keyword];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Textfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
