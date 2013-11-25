//
//  RentNpPlanController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/4/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseNoPlanController.h"
#import "SaleNoPlanListCell.h"

@interface RentNoPlanController : BaseNoPlanController <UIActionSheetDelegate, UIAlertViewDelegate, CheckmarkBtnClickDelegate>
@property (strong, nonatomic) NSString *isSeedPid;
@end
