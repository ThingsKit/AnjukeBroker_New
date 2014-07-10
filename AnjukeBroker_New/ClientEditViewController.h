//
//  ClientEditViewController.h
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "RTViewController.h"
#import "AXMappedPerson.h"

@protocol ClientEditPopDelegate <NSObject>

- (void)didSaveBackWithData:(AXMappedPerson *)data;

@end

@interface ClientEditViewController : RTViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) AXMappedPerson *person;
@property id<ClientEditPopDelegate> editDelegate;

@end
