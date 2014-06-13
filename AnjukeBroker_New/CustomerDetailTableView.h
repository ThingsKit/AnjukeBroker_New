//
//  CustomerDetailTableView.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//


#import "CustomerDetailModel.h"

@interface CustomerDetailTableView : UITableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) CustomerDetailModel* customerDetailModel; //客户资料数据
@property (nonatomic, strong) NSMutableArray* data;

@end
