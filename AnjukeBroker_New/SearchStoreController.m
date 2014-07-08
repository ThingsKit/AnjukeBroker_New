//
//  SearchIndexController.m
//  HaoZu
//
//  Created by developer on 12-11-6.
//
//

#import "SearchStoreController.h"
#import "AppDelegate.h"
#import "BrokerRegisterInfoViewController.h"
#import "RTArray.h"
#import "RTListCell.h"

@interface SearchStoreController ()

@property (nonatomic, strong) NSArray *cellTitleArray;

@end

@implementation SearchStoreController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"所属公司"];
    self.cellTitleArray = [[NSArray alloc] init];
    self.view.backgroundColor = [UIColor brokerBgPageColor];
    
    UIView *barWrapper = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, ScreenWidth, ScreenHeight - 44)];
    [self.view addSubview:barWrapper];
    barWrapper.backgroundColor = [UIColor clearColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [self.searchBar setDelegate:self];
    [self.searchBar setPlaceholder:@"输入所在的门店名称"];
    [self.searchBar setBackgroundColor:[UIColor clearColor]];
    [self.searchBar setShowsCancelButton:NO animated:NO];
    for (UITextField *text in [self.searchBar subviews]) {
        if ([text isKindOfClass:[UITextField class]]) {
            [text setDelegate:self];
        }
    }
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    UIView *searchViews = self.searchBar;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        self.searchBar.tintColor = [[[[UIApplication sharedApplication] delegate] window] tintColor];
        searchViews = [self.searchBar.subviews objectAtIndex:0];
    }
    for (UIButton *button in searchViews.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            button.clipsToBounds = YES;
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//            [button setTitle:@"取消" forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(searchBarCancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            button.Left = button.frame.origin.x - 8 - 8;
        }
    }
    [barWrapper addSubview:self.searchBar];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 45.0, ScreenWidth, ScreenHeight - 44 - 64) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [barWrapper addSubview:self.tableView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - autoCompleteMethods
- (void)loadAutocompleteV2WithKeywords:(NSString *)keywords
{
    [[RTRequestProxy sharedInstance] asyncGetWithServiceID:RTBrokerRESTServiceID methodName:@"common/stores/" params:@{@"companyId":self.companyId, @"cityId":self.cityId, @"keyword":keywords} target:self action:@selector(keywordsFinish:)];
}

- (void)cancelAutocompleteRequest
{
    if (self.isLoading) {
        [[RTRequestProxy sharedInstance] cancelRequestsWithTarget:self];
    }
}

- (void)keywordsFinish:(RTNetworkResponse *)response
{
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    DLog(@"------response [%@]", [response content]);
    self.cellTitleArray = response.content[@"data"][@"storeList"];
    
    if([self.cellTitleArray count] == 0) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"亲，不好意思暂时没有数据~"];
        return;
    } else {
        [self.tableView reloadData];
    }
}

#pragma mark UISearchBarDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    [textField setBackground:[[UIImage imageNamed:@"searchbar_write.png"] stretchableImageWithLeftCapWidth:18 topCapHeight:15]];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [textField setBackground:[[UIImage imageNamed:@"searchbar.png"] stretchableImageWithLeftCapWidth:18 topCapHeight:15]];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([searchBar.text length] + [text length] > 128) {
        return NO;
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchBar.text length] > 0) {
        [self cancelAutocompleteRequest];
        [self loadAutocompleteV2WithKeywords:searchBar.text];
    } else {
        [self cancelAutocompleteRequest];
        self.cellTitleArray = nil;
    }
    [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.searchBar resignFirstResponder];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.cellTitleArray count] == 1) {
        return 2;
    } else if ([self.cellTitleArray count] > 1){
        return 1;
    } else {
        return 0;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.cellTitleArray != nil) {
        if ([self.cellTitleArray count] == 1) {
            return 1;
        } else {
            return [self.cellTitleArray count];
        }
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45.0;
    } else {
        return 300.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RTListCell *cell = nil;
    if (indexPath.section == 0) {
        static NSString *Identifer = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:Identifer];
        if (cell == nil) {
            cell = [[RTListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifer];
            
        }
        [cell showBottonLineWithCellHeight:45 andOffsetX:15];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (self.cellTitleArray != nil) {
            NSDictionary *store = [self.cellTitleArray objectAtIndex:indexPath.row];
            NSString *storeName = [store valueForKey:@"storeName"];
            cell.textLabel.text = storeName;
        }
    } else if (indexPath.section == 1){
        cell =[[RTListCell alloc] init];
        UIImageView *noResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_seachnocommunity@2x.png"]];
        noResult.frame = CGRectMake(0, 30, 80, 80);
        noResult.centerX = cell.centerX;
        UILabel *noR = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, 200, 50)];
        noR.text = @"没有找到门店";
        noR.textColor = [UIColor brokerLightGrayColor];
        [noR sizeToFit];
        noR.centerX = cell.centerX;
        [cell.contentView addSubview:noResult];
        [cell.contentView addSubview:noR];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.currentIndex = indexPath;
        [self doBack:self];

    } else {
        
    }
}

- (void)doBack:(id)sender{
    [super doBack:sender];
    NSDictionary * selectedCellInfo = [[NSDictionary alloc] init];
    if (self.cellTitleArray != nil) {
        if ([self.cellTitleArray safelyObjectAtIndex:self.currentIndex.row]) {
            selectedCellInfo = [self.cellTitleArray objectAtIndex:self.currentIndex.row];
            NSLog(@"business%@",selectedCellInfo);
            if ([self.delegate respondsToSelector:@selector(processStoreNameWithDic:)]) {
                [self.delegate processStoreNameWithDic:selectedCellInfo];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - textFieldDelegate
- (void)keyboardHide:(UITapGestureRecognizer*)tap {
    [self.searchBar resignFirstResponder];
}

@end
