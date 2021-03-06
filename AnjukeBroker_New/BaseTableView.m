//
//  BaseTableView.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//


#import "BaseTableView.h"
#import "UIViewExt.h"

@interface BaseTableView ()

@property (nonatomic, strong) BK_EGORefreshTableHeaderView* refreshHeaderView; //下拉刷新表头
@property (nonatomic, strong) UIButton* refreshFooterView; //下拉刷新表头
@property (nonatomic, assign) BOOL reloading; //是否正在载入

@end

@implementation BaseTableView

//使用xib创建
- (void)awakeFromNib {
    [self initView];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        [self initView]; //加载基类的BaseView
    }
    return self;
}

- (void)initView {
    
    if (self.refreshHeaderView == nil) {
        self.refreshHeaderView = [[BK_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
        self.refreshHeaderView.delegate = self;
        self.refreshHeaderView.backgroundColor = [UIColor clearColor];
    }
    
    if (self.refreshFooterView == nil) {
        self.refreshFooterView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        self.refreshFooterView.backgroundColor = [UIColor clearColor];
        self.refreshFooterView.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [self.refreshFooterView setTitle:@"" forState:UIControlStateNormal];
        [self.refreshFooterView setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.refreshFooterView.showsTouchWhenHighlighted = YES;
        [self.refreshFooterView addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activity.origin = CGPointMake(90, 15);
        activity.tag = 2014;
        [activity stopAnimating];
        [self.refreshFooterView addSubview:activity];

    }
    
    self.dataSource = self;
    self.delegate = self;
    self.needRefreshHeader = YES; //默认有下拉刷新
    self.needRefreshFooter = YES; //默认有上啦刷新
    self.firstAutoPullDown = YES; //默认是第一次自动下拉
    
    [self setSeparatorStyle:UITableViewCellSeparatorStyleNone]; //没有分割线
    [self setBackgroundColor:[UIColor brokerBgPageColor]];
    
}

- (void)setNeedRefreshHeader:(BOOL)needRefreshHeader {
    _needRefreshHeader = needRefreshHeader;
    
    if (self.needRefreshHeader) {
        [self addSubview:_refreshHeaderView];
    }else{
        if ([self.refreshHeaderView superview]) {
            [self.refreshHeaderView removeFromSuperview];
        }
    }
}

- (void)setNeedRefreshFooter:(BOOL)needRefreshFooter {
    _needRefreshFooter = needRefreshFooter;
    
    if (self.needRefreshFooter) {
        self.tableFooterView = _refreshFooterView;
    }else{
        if ([self.refreshFooterView superview]) {
            [self.refreshFooterView removeFromSuperview];
        }
    }
}


#pragma mark -
#pragma mark 上拉加载更多
- (void)loadMore:(UIButton*)button {
    [self pullUpButtonFrozenAndStartActivity];
    
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) { //预判断
        [self.eventDelegate pullUp:self]; //上拉
    }
    
}

//上拉按钮禁用,风火轮开始
- (void)pullUpButtonFrozenAndStartActivity {
    [self.refreshFooterView setTitle:@"努力加载中..." forState:UIControlStateNormal];
    [self.refreshFooterView setEnabled:NO];
    UIActivityIndicatorView* activity = (UIActivityIndicatorView*)[_refreshFooterView viewWithTag:2014];
    [activity startAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//上拉按钮恢复交互,风火轮停止
- (void)pullUpButtonRecoverAndStopActivity {
    if (self.hasMore) {
        [self.refreshFooterView setEnabled:YES];
        [self.refreshFooterView setTitle:@"上拉查看更多" forState:UIControlStateNormal];
    }else{
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            self.refreshFooterView.titleLabel.text = @"";
        }else{
            [self.refreshFooterView setTitle:@"" forState:UIControlStateNormal];
        }
        [self.refreshFooterView setEnabled:NO];
    }
    
    UIActivityIndicatorView* activity = (UIActivityIndicatorView*)[_refreshFooterView viewWithTag:2014];
    [activity stopAnimating];
    
}


#pragma mark -
#pragma mark 自动下拉
- (void)autoPullDownRefresh{
    [self.refreshHeaderView autoRefreshLoading:self]; //自定义下拉动画
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	self.reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	self.reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (!self.hasMore) {
        return;
    }
    
    if (_refreshFooterView && self.data && self.data.count > 6) {
        CGRect rect = [self.refreshFooterView convertRect:_refreshFooterView.bounds toView:self.window];
        if (rect.origin.y < 480 + 85) {
            [self loadMore:nil];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (!self.hasMore) {
        return;
    }
 
    if (_refreshFooterView && self.data && self.data.count > 6) {
        CGRect rect = [self.refreshFooterView convertRect:_refreshFooterView.bounds toView:self.window];
        if (rect.origin.y < 480 + 85) {
            [self loadMore:nil];
        }
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(BK_EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
//    [self doneLoadingTableViewData];
//	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:1.0];
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self]; //下拉
    }
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(BK_EGORefreshTableHeaderView*)view{
	
	return self.reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(BK_EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)reloadData {
    [super reloadData];
    
    if (!self.isPullUp) {
        [self doneLoadingTableViewData]; //weiboTableView 弹回
    }
    if (self.firstAutoPullDown) {
        [self.refreshFooterView setEnabled:NO];
        [self.refreshFooterView setTitle:@"正在加载..." forState:UIControlStateNormal];
        self.firstAutoPullDown = NO;
    }else{
        [self pullUpButtonRecoverAndStopActivity]; //上拉按钮恢复交互, 文本恢复, 风火轮停止
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}


#pragma mark -
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
    
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"did select");
//}

// Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
// {
// // Return NO if you do not want the specified item to be editable.
//     return NO;
// }


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end

