//
//  SaleNoPlanGroupController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "SaleNoPlanGroupController.h"
#import "BaseNoPlanListCell.h"

@interface SaleNoPlanGroupController ()

@end

@implementation SaleNoPlanGroupController

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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdent = @"cell";
    BaseNoPlanListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdent];
    if(cell == nil){
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

@end
