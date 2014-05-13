//
//  BaseTableView.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@class BaseTableView;
@protocol BaseTableViewEventDelegate <NSObject>

@optional
- (void)pullDown:(BaseTableView*)tableView; //下拉
- (void)pullUp:(BaseTableView*)tableView;   //上拉
- (void)tableView:(BaseTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; //选中cells
@end


@interface BaseTableView : UITableView<EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL needRefreshHeader; //是否需要下拉刷新功能
@property (nonatomic, assign) BOOL needRefreshFooter; //是否需要上啦刷新功能
@property (nonatomic, retain) NSArray* data; //表视图的数据

@property (nonatomic, assign) id<BaseTableViewEventDelegate> eventDelegate;
@property (nonatomic, copy) NSString* maxId; //用于下拉
@property (nonatomic, copy) NSString* sinceId; //用于上拉
@property (nonatomic, assign) BOOL isPullUp; // NO 表示pull down, YES 表示pull up
@property (nonatomic, assign) BOOL hasMore; //是否还有更多微博,评论


- (void)doneLoadingTableViewData; //弹回
- (void)autoPullDownRefresh; //自动下拉
- (void)pullUpButtonRecoverAndStopActivity; //上拉按钮恢复交互,风火轮停止

@end
