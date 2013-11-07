//
//  AJK_HaozuHomeViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "HaozuHomeViewController.h"
#import "RentNoPlanListController.h"
#import "RentFixedDetailController.h"
#import "RentBidDetailController.h"
#import "PPCGroupCell.h"

@interface HaozuHomeViewController ()

@end

@implementation HaozuHomeViewController
@synthesize myTable;
@synthesize myArray;

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
    [self setTitleViewWithString:@"租房"];

	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
}
-(void)initModel{
    myArray = [NSMutableArray array];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"竞价房源" forKey:@"title"];
    [dic setValue:@"房源数：10套" forKey:@"detail"];
    [dic setValue:@"" forKey:@"status"];
    [dic setValue:@"1" forKey:@"type"];
    [self.myArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"定价房源" forKey:@"title"];
    [dic setValue:@"分组名称  房源数：10套" forKey:@"detail"];
    [dic setValue:@"推广中" forKey:@"status"];
    [dic setValue:@"2" forKey:@"type"];
    [self.myArray addObject:dic];
    
    dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"待推广房源" forKey:@"title"];
    [dic setValue:@"房源数：10套" forKey:@"detail"];
    [dic setValue:@"3" forKey:@"status"];
    [dic setValue:@"3" forKey:@"type"];
    [self.myArray addObject:dic];

}
-(void)initDisplay{
    myTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    myTable.delegate = self;
    myTable.dataSource = self;
    [self.view addSubview:myTable];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if([indexPath row] == 0)
    {
        RentBidDetailController *controller = [[RentBidDetailController alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([indexPath row] == 1){
        RentFixedDetailController *controller = [[RentFixedDetailController alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
        
    }else{
        RentNoPlanListController *controller = [[RentNoPlanListController alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [myArray count];
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    
    PPCGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
        cell = [[NSClassFromString(@"PPCGroupCell") alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
    }
    
//    [cell setValueForCellByData:[self.myArray objectAtIndex:[indexPath row]]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    content.backgroundColor = [UIColor lightGrayColor];
//    
//    UILabel *headerLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 20)];
//    headerLab.backgroundColor = [UIColor clearColor];
//    headerLab.text = @"10";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 45, 320, 20)];
//    headerLab.text = @"在线房源";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(130, 10, 50, 20)];
//    headerLab.text = @"100";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 320, 20)];
//    headerLab.text = @"今日已点击";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(230, 10, 50, 20)];
//    headerLab.text = @"99.0";
//    [content addSubview:headerLab];
//    
//    headerLab = [[UILabel alloc] initWithFrame:CGRectMake(220, 45, 320, 20)];
//    headerLab.text = @"今日花费(元)";
//    [content addSubview:headerLab];
//    
//    return content;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 100;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
