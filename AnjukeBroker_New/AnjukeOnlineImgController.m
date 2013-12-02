//
//  AnjukeOnlineImgController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/21/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#import "AnjukeOnlineImgController.h"
#import "LoginManager.h"
#import "WebImageView.h"
#import "Util_UI.h"

@interface AnjukeOnlineImgController ()
@property (strong, nonatomic) NSMutableArray *imgArray;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property int selectedIndex;
@end

@implementation AnjukeOnlineImgController
@synthesize imgArray;
@synthesize property;
@synthesize imageSelectDelegate;
@synthesize selectedIndex;

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
    
	// Do any additional setup after loading the view.
    [self setTitleViewWithString:@"在线房型图"];
    [self addRightButton:@"选择" andPossibleTitle:@""];
    
    [self doRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - log
- (void)sendAppearLog {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_ONLINE_001;
    }
    else
        code = AJK_ONLINE_001;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_ONLINE_002;
    }
    else
        code = AJK_ONLINE_002;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

- (void)doBack:(id)sender {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_ONLINE_003;
    }
    else
        code = AJK_ONLINE_003;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    [super doBack:self];
}

#pragma mark - Private Method

- (void)initModel{
    self.imgArray = [NSMutableArray array];
}

- (void)initDisplay {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:FRAME_WITH_NAV];
    sv.delegate = self;
    sv.backgroundColor = SYSTEM_BLACK;
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = YES;
    self.mainScrollView = sv;
    [self.view addSubview:sv];
    
}

- (void)rightButtonAction:(id)sender {
    NSString *code = [NSString string];
    if (self.isHaozu) {
        code = HZ_ONLINE_004;
    }
    else
        code = AJK_ONLINE_004;
    [[BrokerLogger sharedInstance] logWithActionCode:code note:nil];
    
    if (self.imgArray.count == 0) {
        [self doBack:self];
    }
    
    if ([self.imageSelectDelegate respondsToSelector:@selector(onlineImgDidSelect:)]) {
        [self.imageSelectDelegate onlineImgDidSelect:[self.imgArray objectAtIndex:self.selectedIndex]];
    }
    
    [self doBack:self];
}

- (void)drawMain {
    self.mainScrollView.contentSize = CGSizeMake([self windowWidth]* self.imgArray.count, [self currentViewHeight]);
    
    [self setTitleViewWithString:[NSString stringWithFormat:@"在线房型图 %d/%d", self.selectedIndex +1, self.imgArray.count]];
    
    //test
    for (int i = 0; i < self.imgArray.count; i ++) {
        WebImageView *wv = [[WebImageView alloc] initWithFrame:CGRectMake(0+ [self windowWidth]*i, 0, [self windowWidth], [self currentViewHeight])];
        wv.contentMode = UIViewContentModeScaleAspectFit;
        wv.backgroundColor = [UIColor clearColor];
        wv.imageUrl = [[self.imgArray objectAtIndex:i] objectForKey:@"url"];
        [self.mainScrollView addSubview:wv];
    }
    
    if (self.imgArray.count >1) {
        CGFloat imgGap = 3;
        CGFloat imgH = 26/2;
        CGFloat imgW = 17/2;
        
        UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_arrow_left.png"]];
        leftImg.backgroundColor = [UIColor clearColor];
        leftImg.frame = CGRectMake(imgGap, ([self currentViewHeight]- imgH)/2 -imgGap, imgW, imgH);
        [self.view addSubview:leftImg];
        
        UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_arrow_right.png"]];
        rightImg.backgroundColor = [UIColor clearColor];
        rightImg.frame = CGRectMake([self windowWidth] - imgW- imgGap, ([self currentViewHeight]- imgH)/2 -imgGap, imgW, imgH);
        [self.view addSubview:rightImg];
    }
}

#pragma mark - Request OnlineImg

- (void)doRequest{
    
    if(![self isNetworkOkay]){
        return;
    }
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.property.comm_id, @"commId", self.property.rooms, @"rooms", nil];
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:@"img/gethousemoduleimg/" params:params target:self action:@selector(onGetLogin:)];
    
}

- (void)onGetLogin:(RTNetworkResponse *)response {
    DLog(@"------response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请求失败" message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        return;
    }
    
    NSDictionary *resultFromAPI = [NSDictionary dictionaryWithDictionary:[[response content] objectForKey:@"data"]];
    if([resultFromAPI count] ==  0){
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        return ;
    }
    
    if ([[[resultFromAPI objectForKey:@"houseImg"] objectForKey:@"count"] intValue] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"很抱歉" message:@"暂无该小区户型房形图，点击可返回" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我知道了", nil];
        [alert show];
        
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
    }
    
    [self.imgArray removeAllObjects];
    [self.imgArray addObjectsFromArray:[[resultFromAPI objectForKey:@"houseImg"] objectForKey:@"imgs"]];
    
    [self drawMain];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / 320;
    DLog(@"房形图index [%d]", index);
    
    self.selectedIndex = index;
    
    [self setTitleViewWithString:[NSString stringWithFormat:@"在线房型图 %d/%d", self.selectedIndex +1, self.imgArray.count]];
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            [self doBack:self];
        }
            break;
            
        default:
            break;
    }
}

@end
