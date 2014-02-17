//
//  SaleNoPlanGroupController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/30/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanController.h"
#import "SaleNoPlanListCell.h"
#import "SalePropertyObject.h"
#import "PropertyEditViewController.h"

@interface SaleNoPlanGroupController : BaseNoPlanController <UIActionSheetDelegate, UIAlertViewDelegate, CheckmarkBtnClickDelegate, PropertyEditDelegate>
@property (strong, nonatomic) NSString *isSeedPid;
@end
