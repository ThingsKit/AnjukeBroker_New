//
//  RentNpPlanController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanController.h"
#import "SaleNoPlanListCell.h"
#import "PropertyEditViewController.h"

@interface RentNoPlanController : BaseNoPlanController <UIActionSheetDelegate, UIAlertViewDelegate, CheckmarkBtnClickDelegate, PropertyEditDelegate>
@property (strong, nonatomic) NSString *isSeedPid;
@end
