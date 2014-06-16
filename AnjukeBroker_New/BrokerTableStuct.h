//
//  BrokerTableStuct.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableStatus) {
    STATUSFORNETWORKERROR = 0,
    STATUSFORNODATA,
    STATUSFORNOGPS,
    STATUSFOROK
};

@protocol NoNetWorkDelegate <NSObject>

- (void)requestData;

@end


@interface BrokerTableStuct : UITableView<UIGestureRecognizerDelegate>
@property(nonatomic, assign) id<NoNetWorkDelegate> noNetWorkViewdelegate;
@property(nonatomic, assign) TableStatus stauts;
@property(nonatomic, strong) UIView *headerView;
- (void)setTableStatus:(TableStatus)status;
@end
