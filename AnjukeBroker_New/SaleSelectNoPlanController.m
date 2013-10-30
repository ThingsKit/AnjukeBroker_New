//
//  SaleSelectNoPlanController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleSelectNoPlanController.h"
#import "BaseNoPlanListCell.h"

@interface SaleSelectNoPlanController ()

@end

@implementation SaleSelectNoPlanController

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
    UIButton *action = [UIButton buttonWithType:UIButtonTypeCustom];
    [action setTitle:@"操作" forState:UIControlStateNormal];
    [action setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [action addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchDown];
//    [action setBackgroundColor:[UIColor lightGrayColor]];
    [action setFrame:CGRectMake(0, 0, 60, 40)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:action];
	// Do any additional setup after loading the view.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    BaseNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == Nil){
        cell = [[BaseNoPlanListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdent];
        
        cell.imageView.image = [UIImage imageNamed:@"agent_btn17_normal.png"];
        [cell setValueForTableCell];
        //        iamge = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
        //        iamge.image = [UIImage imageNamed:@"2leftarrow.png"];
        //        [cell addSubview:iamge];
    }
    
    if([self.selected containsObject:[self.myArray objectAtIndex:[indexPath row]]]){
        cell.imageView.image = [UIImage imageNamed:@"agent_btn17_selected.png"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"agent_btn17_normal.png"];
    }
    //    cell.textLabel.text = [self.myArray objectAtIndex:[indexPath row]];
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- PrivateMethod
-(void)action{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
