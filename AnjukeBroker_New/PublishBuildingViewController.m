//
//  PublishBuildingViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-17.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBuildingViewController.h"

@interface PublishBuildingViewController ()

@end

@implementation PublishBuildingViewController
@synthesize isHaozu;
@synthesize tableViewList;
@synthesize cellDataSource;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    self.tableViewList.delegate = nil;
    self.cellDataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *titleStr = @"发布二手房";
    if (self.isHaozu) {
        titleStr = @"发布租房";
    }
    [self setTitleViewWithString:titleStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method

- (void)initModel {
    
}

- (void)initDisplay {
    //init main sv
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    tv.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    tv.delegate = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewList = tv;
    [self.view addSubview:tv];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 30)];
    headerView.backgroundColor = SYSTEM_LIGHT_GRAY_BG;
    [self.tableViewList setTableHeaderView:headerView];
    
    [self initCellDataSource];
}

- (void)initCellDataSource {
    PublishTableViewDataSource *pd = [[PublishTableViewDataSource alloc] init];
    self.cellDataSource = pd;
    self.tableViewList.dataSource = pd;
    [pd setSuperViewController:self];
    [pd createCells:[PublishDataModel getPropertyTitleArrayForHaozu:self.isHaozu] isHaozu:self.isHaozu];
    
    [self.tableViewList reloadData];
    
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellDataSource heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.cellDataSource heightForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self.cellDataSource heightForFooterInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.cellDataSource viewForHeaderInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self.cellDataSource viewForFooterInSection:section];
}

//******点击******

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: //价格
                {
                    
                }
                    break;
                case 1: //面积
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0: //房型
                {
                    
                }
                    break;
                case 1: //装修
                {
                    
                }
                    break;
                case 2: //楼层
                {
                    
                }
                    break;
                case 3: //出租方式（仅好租）
                {
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
