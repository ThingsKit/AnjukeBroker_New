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

@protocol companyDelegate <NSObject>
- (void)processCompanyNameWithDic:(NSDictionary *)dic;
@end

@interface SearchCompanyController : RTViewController <UITextFieldDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

//UI
@property (nonatomic, retain) UISearchBar *searchBar;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSString *cityId;

@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) NSDictionary *selectCellInfo;
@property (nonatomic, strong) id<companyDelegate> delegate;

@end
