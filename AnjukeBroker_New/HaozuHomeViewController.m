//
//  AJK_HaozuHomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "HaozuHomeViewController.h"

@interface HaozuHomeViewController ()

@end

@implementation HaozuHomeViewController

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
    myArray = [NSMutableArray arrayWithObjects:@"竞价房源(12)", @"定价房源(10)", @"未推广房源(12)", nil];
    myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStylePlain];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if([indexPath row] == 1)
//    {
//        SaleFixedDetailController *controller = [[SaleFixedDetailController alloc] init];
//        [controller setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:controller animated:YES];
//    }else if ([indexPath row] == 0){
//        SaleBidDetailController *controller = [[SaleBidDetailController alloc] init];
//        [controller setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:controller animated:YES];
//        
//    }else{
//        NoPlanController *controller = [[NoPlanController alloc] init];
//        [controller setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:controller animated:YES];
//    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == Nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    cell.textLabel.text = [myArray objectAtIndex:[indexPath row]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    content.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 20)];
    headerLab.backgroundColor = [UIColor clearColor];
    headerLab.text = @"10";
    [content addSubview:headerLab];
    
    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 320, 20)];
    headerLab.text = @"在线房源";
    [content addSubview:headerLab];
    
    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 50, 20)];
    headerLab.text = @"100";
    [content addSubview:headerLab];
    
    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 320, 20)];
    headerLab.text = @"今日已点击";
    [content addSubview:headerLab];
    
    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 50, 20)];
    headerLab.text = @"99.0";
    [content addSubview:headerLab];
    
    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(220, 45, 320, 20)];
    headerLab.text = @"今日花费(元)";
    [content addSubview:headerLab];
    
    return content;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 100;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
