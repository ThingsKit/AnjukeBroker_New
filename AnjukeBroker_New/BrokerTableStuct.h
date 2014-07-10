//
//  BrokerTableStuct.h
//  AnjukeBroker_New
//
//  Created by xiazer on 14-5-12.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableStatus) {
    STATUSFORNETWORKERROR = 0,
    STATUSFORREMOTESERVERERROR,
    STATUSFORNODATA,
    STATUSFORNOGPS,
    STATUSFOROK,
    STATUSFORNODATAFORPRICINGLIST,
    STATUSFORNODATAFOSELECTLIST,
    STATUSFORNODATAFORNOHOUSE
};


@interface BrokerTableStuct : UITableView<UIGestureRecognizerDelegate>
@property(nonatomic, assign) TableStatus stauts;
@property(nonatomic, strong) UIView *headerViews;
- (void)setTableStatus:(TableStatus)status;
@end
