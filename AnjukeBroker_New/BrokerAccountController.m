//
//  BrokerAccountController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/26/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "BrokerAccountController.h"
#import "BrokerAccountCell.h"
#import "LoginManager.h"
#import "WebImageView.h"
#import "Util_UI.h"

@interface BrokerAccountController ()

@end

@implementation BrokerAccountController
@synthesize myTable;
@synthesize ppcDataDic;
@synthesize dataDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleViewWithString:@"账户信息"];
	// Do any additional setup after loading the view.
}
- (void)initDisplay{
    self.myTable = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.myTable.delegate = self;
    self.myTable.dataSource = self;
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.myTable.separatorColor = [UIColor whiteColor];
    [self.view addSubview:self.myTable];
    
    UIView *img = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], 120)];
    img.backgroundColor = [Util_UI colorWithHexString:@"#EEEEEE"];
    self.myTable.tableHeaderView = img;
    CGFloat imgw = 160/2;
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:img.frame];
//    [self drawLine:imageView];
//    [img addSubview:imageView];
    WebImageView *brokerImg = [[WebImageView alloc] initWithFrame:CGRectMake(([self windowWidth] - imgw)/2, (120-imgw)/2, imgw, imgw)];
    brokerImg.imageUrl = [LoginManager getUse_photo_url];
    brokerImg.contentMode = UIViewContentModeScaleAspectFit;
    brokerImg.layer.masksToBounds = YES;

    [img addSubview:brokerImg];
    brokerImg.layer.cornerRadius = imgw / 2;
    brokerImg.layer.borderWidth = 1;
    brokerImg.layer.borderColor = [[UIColor whiteColor] CGColor];
}

//- (void)drawLine:(UIImageView *) imageView{
//    UIGraphicsBeginImageContext(imageView.frame.size);
//    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
//    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
//    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 0.1);
//    CGContextSetAllowsAntialiasing(UIGraphicsGetCurrentContext(), YES);
//    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 46.0/255, 46.0/255, 46.0/255, 1.0);
//    CGContextBeginPath(UIGraphicsGetCurrentContext());
//    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 17, 80);
//    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 320, 80);
//    CGContextStrokePath(UIGraphicsGetCurrentContext());
//    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//}
- (void)initModel{
    self.dataDic = [NSMutableDictionary dictionary];
    self.ppcDataDic =[NSMutableDictionary dictionary];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self doRequest];

}

#pragma mark - Request Method

- (void)doRequest {
    if (![self isNetworkOkay]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId",[LoginManager getCity_id], @"cityId", nil];
    method = @"broker/getinfoandppc/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    [self showLoadingActivity:YES];
    self.isLoading = YES;
}

- (void)onRequestFinished:(RTNetworkResponse *)response {
    DLog(@"。。。response [%@]", [response content]);
    if([[response content] count] == 0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        [self showInfo:@"操作失败"];
        return ;
    }
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return;
    }
    
    self.dataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerBaseInfo"];
    self.ppcDataDic = [[[response content] objectForKey:@"data"] objectForKey:@"brokerPPCInfo"];
    [self.myTable reloadData];
//
//    [self setHomeValue];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - tableView Datasource

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 6;//self.groupArray.count;
    return [self.dataDic count] - 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
//    tableView.separatorColor = [UIColor lightGrayColor];
    BrokerAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[BrokerAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
    }
    else {
        
    }
    
    [cell configureCell:self.dataDic withIndex:indexPath.row];
    [cell showBottonLineWithCellHeight:40];

    return cell;
}

#pragma mark - tableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
