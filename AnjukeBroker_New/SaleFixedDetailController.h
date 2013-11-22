//
//  SaleFixedDetailController.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 10/29/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BaseFixedDetailController.h"
#import "RTPopoverTableViewController.h"

@interface SaleFixedDetailController : BaseFixedDetailController <UIActionSheetDelegate, RTPopoverTableViewDelegate, UIPopoverControllerDelegate,UIAlertViewDelegate>
{

}
@property (strong, nonatomic) NSMutableDictionary *tempDic;

@end
