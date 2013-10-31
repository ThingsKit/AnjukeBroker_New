//
//  BidPropertyDetailController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BidPropertyDetailController.h"
#import "PropertyDetailCell.h"
#import "FixedObject.h"
#import "AnjukeEditPropertyViewController.h"
#import "SaleBidPlanController.h"

@interface BidPropertyDetailController ()

@end

@implementation BidPropertyDetailController
@synthesize myTable;
@synthesize myArray;
@synthesize propertyObject;

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
    [self setTitleViewWithString:@"房源详情"];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"操作"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(action)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:self.myTable];
    
	// Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == 0) {
        return 75;
    }else{
        return 100;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([indexPath row] == 0){
        static NSString *cellIdent = @"PropertyDetailCell";
        PropertyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == Nil){
            cell = [[NSClassFromString(@"PropertyDetailCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PropertyDetailCell"];
            [cell setValueForCellByObject:self.propertyObject];
        }
        return cell;
    }else if([indexPath row] == 1){
        static NSString *cellIdent = @"FixedDetailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
            UILabel *fixedTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
            fixedTitle.backgroundColor = [UIColor clearColor];
            fixedTitle.text = @"定价";
            [cell.contentView addSubview:fixedTitle];
            
            UILabel *fixedStatus = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 60, 20)];
            fixedStatus.backgroundColor = [UIColor grayColor];
            fixedStatus.layer.cornerRadius = 6;
            fixedStatus.text = @"推广中";
            [cell.contentView addSubview:fixedStatus];
            UILabel *fixed = [[UILabel alloc] initWithFrame:CGRectMake(50, 35, 250, 20)];
            fixed.text = @"10                              10";
            [cell.contentView addSubview:fixed];
            
            fixed = [[UILabel alloc] initWithFrame:CGRectMake(50, 65, 250, 20)];
            fixed.text = @"今日点击                  定价价格(元)";
            [cell.contentView addSubview:fixed];
            
        }
        return cell;
    }else{
        static NSString *cellIdent = @"FixedDetailCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
            UILabel *fixedTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 40, 20)];
            fixedTitle.backgroundColor = [UIColor clearColor];
            fixedTitle.text = @"竞价";
            [cell.contentView addSubview:fixedTitle];
            
            fixedTitle = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 160, 20)];
            fixedTitle.backgroundColor = [UIColor clearColor];
            fixedTitle.font = [UIFont systemFontOfSize:12];
            fixedTitle.textColor = [UIColor grayColor];
            fixedTitle.text = @"目前排名：1";
            [cell.contentView addSubview:fixedTitle];
            
            UILabel *fixedStatus = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 60, 20)];
            fixedStatus.backgroundColor = [UIColor grayColor];
            fixedStatus.layer.cornerRadius = 6;
            fixedStatus.text = @"推广中";
            [cell.contentView addSubview:fixedStatus];
            UILabel *fixed = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 250, 20)];
            fixed.text = @"10                   1.0                   10";
            [cell.contentView addSubview:fixed];
            
            fixed = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, 280, 20)];
            fixed.textColor = [UIColor grayColor];
            fixed.font = [UIFont systemFontOfSize:12];
            fixed.text = @"今日点击               出价(元)                预算余额(元)";
            [cell.contentView addSubview:fixed];
            
        }
        return cell;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- PrivateMethod
-(void)action{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改房源", @"取消定价推广", @"竞价出价及预算", @"取消竞价推广", nil];
    [action showInView:self.view];
}
#pragma mark -- UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        AnjukeEditPropertyViewController *controller = [[AnjukeEditPropertyViewController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (buttonIndex == 1){
    
    }else if (buttonIndex == 2){
        SaleBidPlanController *controller = [[SaleBidPlanController alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (buttonIndex == 3){
    
    }

}
@end
