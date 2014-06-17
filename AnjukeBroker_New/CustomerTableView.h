//
//  CustomerTableView.h
//  AnjukeBroker_New
//
//  Created by leozhu on 14-6-11.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "BaseTableView.h"

@class CustomerListModel;
@interface CustomerTableView : BaseTableView

@property (nonatomic, strong) CustomerListModel* customerListModel;

@end
