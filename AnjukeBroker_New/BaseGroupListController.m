//
//  SaleGroupListController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/12/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseGroupListController.h"
#import "SaleFixedDetailController.h"
#import "SalePropertyObject.h"
#import "LoginManager.h"
#import "PPCGroupCell.h"

@interface BaseGroupListController ()
{
}
@end

@implementation BaseGroupListController
@synthesize myArray;
@synthesize myTable;
@synthesize propertyArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initModel_];
        // Custom initialization
    }
    return self;
}
-(void)initModel_{
    self.propertyArray = [NSMutableArray array];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"选择定价组"];
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)initDisplay{
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
//    self.myTable.separatorColor = [UIColor whiteColor];
    [self.view addSubview:self.myTable];
}

-(void)dealloc{
    self.myTable.delegate = nil;
}
- (void)initModel {
    self.myArray = [NSMutableArray array];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"PPCGroupCell";
    
    PPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"PPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    
//    [cell setFixedGroupValueForCellByData:self.myArray index:indexPath.row];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
