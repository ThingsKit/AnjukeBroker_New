//
//  BaseTableStructViewController.m
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-14.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseTableStructViewController.h"

@interface BaseTableStructViewController ()
@property (nonatomic, assign) BOOL reloading; //是否正在载入
@end

@implementation BaseTableStructViewController
@synthesize tableList;
@synthesize forbiddenEgo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.forbiddenEgo = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableList = [[BrokerTableStuct alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tableList.backgroundColor = [UIColor clearColor];
    self.tableList.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!self.forbiddenEgo) {
        if (self.refreshHeaderView == nil) {
            self.refreshHeaderView = [[BK_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
            self.refreshHeaderView.delegate = self;
            self.refreshHeaderView.backgroundColor = [UIColor clearColor];
            [self.tableList addSubview:self.refreshHeaderView];
        }
    }
}
#pragma mark - method
- (void)autoPullDown{
    [self.tableList setContentOffset:CGPointMake(0, -70) animated:NO];
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableList];
}
- (void)donePullDown{
    [self doneLoadingTableViewData];
}
- (void)doRequest{
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	self.reloading = YES;
}

- (void)doneLoadingTableViewData{
	self.reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableList];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;  //显示状态栏风火轮
}



#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(BK_EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;  //显示状态栏风火轮
    
    [self doRequest];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(BK_EGORefreshTableHeaderView*)view{
	return self.reloading; // should return if data source model is reloading
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(BK_EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
