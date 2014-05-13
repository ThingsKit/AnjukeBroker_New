//
//  SelectionToolView.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 5/13/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectionToolView;
@protocol SelectionToolViewDelegate <NSObject>

- (void)didClickSectionAtIndex:(NSInteger) index;

@end


@interface SelectionToolView : UIView
@property (nonatomic, assign) id<SelectionToolViewDelegate> delegate;
@end
