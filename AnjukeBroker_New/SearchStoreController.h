//
//  SearchIndexController.h
//  HaoZu
//
//  Created by developer on 12-11-6.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/NSObject.h>
#import "UIView+AIFFrame.h"
#import "RTViewController.h"
#import "BrokerRegisterInfoViewController.h"

@protocol storeDelegate <NSObject>
- (void)processStoreNameWithDic:(NSDictionary *)dic;
@end

@interface SearchStoreController : RTViewController <UITextFieldDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

//UI
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tableView;

//value
@property (nonatomic, strong) NSString *cityId;
@property (nonatomic, strong) NSString *companyId;

//select
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) NSDictionary *selectCompanyInfo;
@property (nonatomic, strong) id<storeDelegate> delegate;

@end
