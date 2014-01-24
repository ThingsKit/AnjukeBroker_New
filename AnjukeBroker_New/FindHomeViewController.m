//
//  FindHomeViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-24.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "FindHomeViewController.h"
#import "FindPropertyCell.h"

@interface FindHomeViewController ()

@end

@implementation FindHomeViewController
@synthesize myArray;
@synthesize myTable;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitleViewWithString:@"发现"];
}

- (void)initModel {
    self.myArray = [NSMutableArray array];
    

}

- (void)initDisplay {
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_BETWEEN_NAV_TAB style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    [self.view addSubview:myTable];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.myArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentify = @"cell";
    FindPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if(cell == nil){
        cell = [[FindPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
