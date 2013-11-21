//
//  AppDelegate.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-15.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) UIViewController *rootViewController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//private method
+ (AppDelegate *)sharedAppDelegate;

- (void)requestSalePropertyConfig;

@end
