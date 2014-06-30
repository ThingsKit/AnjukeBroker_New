//
//  BrokerChatViewController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 2/24/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerChatViewController.h"
#import "CommunitySelectViewController.h"
#import "AXPhotoBrowser.h"
#import "ClientDetailViewController.h"
#import "AXChatWebViewController.h"
#import "AXPhoto.h"
#import "Util_UI.h"
#import "UIImage+Resize.h"
#import "NSString+RTStyle.h"
#import "ClientDetailPublicViewController.h"
#import "AXNotificationTutorialViewController.h"
#import "RTGestureBackNavigationController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "AXChatDataCenter.h"
#import "LoginManager.h"

#import "RTDeviceInfo.h"
//#import "AXIMGDownloader.h"



@interface BrokerChatViewController ()
{
    
}
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImageView *brokerIcon;
@property (nonatomic, assign) BOOL  isAlloc;
@property (nonatomic, strong) UIView *sayHelloAlertView;
//@property (nonatomic, strong) AXIMGDownloader *imgDownloader;


//浮层相关
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, strong) UIImageView* hudBackground;
@property (nonatomic, strong) UIImageView* hudImageView;
@property (nonatomic, strong) UILabel* hudText;
@property (nonatomic, strong) UILabel* hubSubText;
@end

@implementation BrokerChatViewController
static BrokerChatViewController *brokerSender = nil;
+ (void)setBrokerSelf:(BrokerChatViewController *)sender
{
    brokerSender = sender;
}
+ (BrokerChatViewController *)getBrokerSelf
{
    return brokerSender;
}

#pragma mark - log
- (void)sendAppearLog
{
    if (_isSayHello)
    {
        [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_CHAT page:POTENTIAL_CLIENT_CHAT_ONVIEW note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }else
    {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ONVIEW page:CHAT note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
    }
    
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

- (void)didMoreBackView:(UIButton *)sender
{
    if (_isSayHello)
    {
        self.moreBackView.hidden = YES;
    }
    [super didMoreBackView:sender];
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ADD page:CHAT note:nil];
}

#pragma mark - lifeCycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.brokerIcon = [[UIImageView alloc] init];
        // Custom initialization
        self.backType = RTSelectorBackTypePopToRoot;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.backType = RTSelectorBackTypePopToRoot;
    
    // 设置返回btn
    [self initRightBar];
    _isAlloc = YES;
    
    if (_isSayHello)
    {
        self.brokerName = _userNickName;
        [self setTitleViewWithString:_userNickName];
        
        [self sendSystemMessage:AXMessageTypeWillSenprop content:@"推荐1套客户喜欢的房源，越精准越好" messageId:NULL];
    }
    [BrokerChatViewController setBrokerSelf:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *uid = self.friendPerson.uid;
    if (_isSayHello)
    {
        uid = _deviceID;
    }
    
    self.friendPerson = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:uid];
    [self initNavTitle];
    [self resetLayoutOfKeyboard];
    [self removeStorageLayoutOfKeyboard];
//    [self downLoadIcon];
    
    if (_isAlloc && _isSayHello)
    {
        [self initLearnView];
        [self initButtonInLearnView];
    }
    _isAlloc = NO;
    
    //修复回到 MessageListViewController 小红点上数字不消失的问题 add by leo
    [[AXChatMessageCenter defaultMessageCenter] chatListWillAppearWithFriendUid:self.friendPerson.uid];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dobackMore:) name:@"PopActionIsOver" object:nil];
}

- (void)dobackMore:(NSNotification*) notification{
    if ([BrokerChatViewController getBrokerSelf])
    {
        [BrokerChatViewController setBrokerSelf:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self hideLearnView:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PopActionIsOver" object:nil];
}

- (void)updatePersion {

}

//引导页
- (void)initLearnView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideLearnView:)];
    
    NSString *learnViewKey = @"brokerchatlearn3.5";
    NSString *learnValue = [[NSUserDefaults standardUserDefaults] objectForKey:learnViewKey];
    NSInteger learnValueInt = learnValue.intValue;
    
    self.moreBackView.hidden = YES;
    [self didMoreBackView:nil];
    //判断学习页面出现次数
    if (learnValue && learnValueInt > 3)
    {
        return;
    }
    learnValueInt ++;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", learnValueInt] forKey:learnViewKey];
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *learnView = [[UIView alloc] initWithFrame:window.bounds];
    [learnView setBackgroundColor:[UIColor clearColor]];
    [window addSubview:learnView];
    [learnView setTag:-11];//为了隐藏自己
    [learnView addGestureRecognizer:tap];

    UIView *moreView = self.moreBackView;
    UIButton *ajkErbt = (UIButton *)[moreView viewWithTag:-10];
    
    //提示文字
    UIImage *titleImg = [UIImage imageNamed:@"broker_qkh_guide"];
    UIImageView *titleImgVIew = [[UIImageView alloc] initWithImage:titleImg];
    
    NSString *iosType = [RTDeviceInfo iosType];
    
    NSRange range = [iosType rangeOfString:@"5"];
    CGFloat xHeight = -10;
    if (range.length > 0)
    {
        xHeight = 40;
    }
    [titleImgVIew setCenter:CGPointMake(CGRectGetWidth(window.frame) / 2, CGRectGetHeight(window.frame) / 2 + xHeight)];
    [titleImgVIew setTag:-12];
    [window addSubview:titleImgVIew];
    
    //镂空icon
    UIImage *img = [UIImage imageNamed:@"broker_qkh_guide_bg"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setCenter:CGPointMake(ajkErbt.frame.origin.x - 17, (ajkErbt.frame.origin.y + moreView.frame.origin.y) + 36 + 65)];
    [learnView addSubview:imgView];
    
    CGFloat imgViewX = imgView.frame.origin.x;
    CGFloat imgViewY = imgView.frame.origin.y;
    CGFloat imgViewWidth  = imgView.frame.size.width;
    CGFloat imgViewHeight = imgView.frame.size.height;
    
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewWidth = CGRectGetWidth(window.frame);
    CGFloat topViewHeight = imgViewY;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(topViewX, topViewY, topViewWidth, topViewHeight)];
    [topView setBackgroundColor:[UIColor blackColor]];
    [topView setAlpha:.5f];
    [learnView addSubview:topView];
    
    CGFloat footViewX = 0;
    CGFloat footViewY = imgViewY + imgViewHeight;
    CGFloat footWidth = topViewWidth;
    CGFloat footHeiht = CGRectGetHeight(window.frame) - footViewY;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(footViewX, footViewY, footWidth, footHeiht)];
    [footView setBackgroundColor:[UIColor blackColor]];
    [footView setAlpha:.5f];
    [learnView addSubview:footView];
    
    CGFloat leftViewX = 0;
    CGFloat leftViewY = imgViewY;
    CGFloat leftViewWidth = imgViewX;
    CGFloat leftViewHeight = imgViewHeight;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(leftViewX, leftViewY, leftViewWidth, leftViewHeight)];
    [leftView setBackgroundColor:[UIColor blackColor]];
    [leftView setAlpha:.5f];
    [learnView addSubview:leftView];
    
    CGFloat rightViewX = imgViewX + imgViewWidth;
    CGFloat rightViewY = imgViewY;
    CGFloat rightViewWidth = CGRectGetWidth(window.frame) - rightViewX;
    CGFloat rightViewHeight = imgViewHeight;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(rightViewX, rightViewY, rightViewWidth, rightViewHeight)];
    [rightView setBackgroundColor:[UIColor blackColor]];
    [rightView setAlpha:.5f];
    [learnView addSubview:rightView];
    
    
}

//初始化learnview的bt

- (void)sayHelloSuccessButton
{
    NSDictionary *btDict = self.buttonDict;
    
    UIButton *erShou = [btDict objectForKey:AXBTKEYER];
    UIView *v4 = [[UIView alloc] initWithFrame:erShou.bounds];
    v4.layer.masksToBounds = YES;
    v4.layer.cornerRadius = .5f;
    [v4 setUserInteractionEnabled:NO];
    [v4 setAlpha:.15f];
    [erShou addSubview:v4];
    [erShou removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [erShou addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *moreBt = [btDict objectForKey:AXBTKEYMORE];
    UIView *v5 = [[UIView alloc] initWithFrame:moreBt.bounds];
    [v5 setBackgroundColor:[UIColor blackColor]];
    [v5 setAlpha:.15f];
    [v5.layer setMasksToBounds:YES];
    [v5.layer setCornerRadius:CGRectGetHeight(v5.frame)/2];
    [v5 setUserInteractionEnabled:NO];
    
    [moreBt addSubview:v5];
    [moreBt removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [moreBt addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initButtonInLearnView
{
    [super initButtonInLearnView];
    NSDictionary *btDict = self.buttonDict;
    
    UIButton *getPic = [btDict objectForKey:AXBTKEYPIC];
    UIButton *takePic = [btDict objectForKey:AXBTKEYTAKE];
    UIButton *zuFang = [btDict objectForKey:AXBTKEYZU];
    UIButton *local = [btDict objectForKey:AXBTKEYLOCAL];
    UIButton *speak = [btDict objectForKey:AXBTKEYTALL];
    UIButton *emjle = [btDict objectForKey:AXBTKEYEMIJE];
    UIBarButtonItem *people = [btDict objectForKey:AXBTKEYPEOPLE];
    JSMessageInputView *messInputView = [btDict objectForKey:AXUITEXVIEWEDIT];
    
    UIImage *getPicImg = [getPic imageForState:UIControlStateNormal];
    
    CGFloat radius = 5.f;
    
    CGFloat w = getPicImg.size.width;
    CGFloat h = getPicImg.size.height;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    [v setBackgroundColor:[UIColor blackColor]];
    v.layer.masksToBounds = YES;
    v.layer.cornerRadius = radius;
    [v setUserInteractionEnabled:NO];
    [v setAlpha:.15f];
    
    UIView *v1 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:v]];
    v1.layer.masksToBounds = YES;
    v1.layer.cornerRadius = radius;
    UIView *v2 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:v]];
    v2.layer.masksToBounds = YES;
    v2.layer.cornerRadius = radius;
    UIView *v3 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:v]];
    v3.layer.masksToBounds = YES;
    v3.layer.cornerRadius = radius;
    
    
    [getPic addSubview:v1];
    [takePic addSubview:v2];
    [zuFang addSubview:v3];
    [local addSubview:v];
    
    UIView *v6 = [[UIView alloc] initWithFrame:emjle.bounds];
    [v6 setBackgroundColor:[UIColor blackColor]];
    [v6 setAlpha:.15f];
    [v6.layer setMasksToBounds:YES];
    [v6.layer setCornerRadius:CGRectGetHeight(v6.frame)/2];
    [v6 setUserInteractionEnabled:NO];
    
    UIView *v7 = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:v6]];
    [v7.layer setCornerRadius:CGRectGetHeight(v7.frame)/2];
    v7.layer.masksToBounds = YES;

    
    [speak addSubview:v7];
    [emjle addSubview:v6];
    
    [getPic addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [takePic addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [zuFang addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [local addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [speak addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchDown];
    [emjle addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cuBt = (UIButton *)[people customView];
    [cuBt removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [cuBt addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat inputHeight = CGRectGetHeight(messInputView.textView.frame);
    CGFloat inputWidth = CGRectGetWidth(messInputView.textView.frame);
    
    UIButton *textView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, inputWidth, inputHeight + 4)];
    [textView setBackgroundColor:[UIColor blackColor]];
    [textView setAlpha:.15f];
    [textView addTarget:self action:@selector(learnViewBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [messInputView.textView addSubview:textView];
}


- (void)initNavTitle {
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:self.friendPerson.uid];
    NSString *titleString = @"noname";
    if (person.markName.length > 0) {
        titleString = [NSString stringWithFormat:@"%@", person.markName];
    }
    else {
        titleString = [NSString stringWithFormat:@"%@", self.friendPerson.name];
        if ([person.markName isEqualToString:person.phone]) {
            titleString = [Util_TEXT getChatNameWithPhoneFormat:person.phone];
        }
    }
    if (titleString.length == 0 || [titleString isEqualToString:@"(null)"]) {
        titleString = [Util_TEXT getChatNameWithPhoneFormat:person.phone];
        
    }
    if (_isSayHello)
    {
        [self setTitleViewWithString:_userNickName];
    }else
    {
        [self setTitleViewWithString:titleString];
    }
    
 }

- (void)initRightBar {
    UIBarButtonItem *rightItem = [UIBarButtonItem getBarButtonItemWithImage:[UIImage imageNamed:@"anjuke_icon_person.png"] highLihtedImg:[UIImage imageNamed:@"anjuke_icon_person_press"] taget:self action:@selector(rightButtonAction:)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {//fix ios7以下 10像素偏离
        UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:10.0];
        [self.navigationItem setRightBarButtonItems:@[spacer, rightItem]];
    }else{
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    [self.buttonDict setValue:self.navigationItem.rightBarButtonItem forKey:AXBTKEYPEOPLE];
}

- (void)resetLayoutOfKeyboard {
    if (self.friendPerson.uid == nil) {
        return;
    }
    if (self.isHavPublicMenu) {
        return;
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:self.friendPerson.uid] isEqualToString:@"1"]) {
        [self didMoreBackView:nil];
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:self.friendPerson.uid] isEqualToString:@"2"]) {
        [self didEmojiButClick];
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:self.friendPerson.uid] isEqualToString:@"3"]) {
        [self.messageInputView.textView becomeFirstResponder];
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:self.friendPerson.uid] isEqualToString:@"4"]) {
        [self restoreDraftContent];
        [self speeking];
    }
}

- (void)storageLayoutOfKeyboard {
    if (self.friendPerson.uid == nil) {
        return;
    }
    if (self.moreBackView.hidden == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:self.friendPerson.uid];
    }
    if (self.emojiScrollView.hidden == NO) {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:self.friendPerson.uid];
    }
    if (self.messageInputView.textView.isFirstResponder == YES) {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:self.friendPerson.uid];
    }
    if (self.isVoiceInput) {
        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:self.friendPerson.uid];
    }
}

- (void)removeStorageLayoutOfKeyboard {
    if (self.friendPerson.uid) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:self.friendPerson.uid];
    }
}

- (void)pickIMG:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ALBUM page:CHAT note:nil];
    
    BK_ELCAlbumPickerController *albumPicker = [[BK_ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    BK_ELCImagePickerController *elcPicker = [[BK_ELCImagePickerController alloc] initWithRootViewController:albumPicker];
    elcPicker.maximumImagesCount = 5; //(maxCount - self.roomImageArray.count);
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)takePic:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_SHOOT page:CHAT note:nil];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您没有开启移动经纪人的相机权限,请前往设置-隐私-相机中设置" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alert show];
            return;
        }
    }
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
- (void)pickAJK:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ESF page:CHAT note:nil];
    
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = secondHandHouse;
    controller.isSayHello = _isSayHello;
    _willSendProp.propid = POTENTIAL_CLIENT_PROP_SELECT;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)pickHZ:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_ZF page:CHAT note:nil];
    
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = rentHouse;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)returnSelectedHouseDic:(NSDictionary *)dic houseType:(BOOL)houseType {
    
    NSMutableDictionary *propDict = [NSMutableDictionary dictionary];
    NSString *des = [NSString stringWithFormat:@"%@室%@厅%@卫 %d平",dic[@"roomNum"], dic[@"hallNum"], dic[@"toiletNum"], [dic[@"area"] integerValue]];
    if (houseType ) {
        NSString *price = [NSString stringWithFormat:@"%d%@", [dic[@"price"] integerValue], dic[@"priceUnit"]];
        NSString *url = nil;
        if ([dic[@"proUrl"] length] > 0) {
            url = dic[@"proUrl"];
        }else {
            url = [NSString stringWithFormat:@"http://m.anjuke.com/sale/x/%@/%@",[LoginManager getCity_id],dic[@"id"]];
        }
        propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceErShouFang]}];
    }else{
        NSString *price = [NSString stringWithFormat:@"%@%@/月", dic[@"price"], dic[@"priceUnit"]];
        NSString *url = nil;
        if ([dic[@"proUrl"] length] > 0) {
            url = dic[@"proUrl"];
        }else {
            url = [NSString stringWithFormat:@"http://m.anjuke.com/rent/x/%@/%@-3",[LoginManager getCity_id],dic[@"id"]];
        }
        propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceZuFang]}];
    }
    
    NSString *brokerId = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"1";
    mappedMessageProp.content = [propDict RTJSONRepresentation];
    mappedMessageProp.to = [self checkFriendUid];
    if (_isSayHello)
    {
        mappedMessageProp.to = _deviceID;
    }
    mappedMessageProp.from = brokerId;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
    if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendMessageToPublic:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    } else
    {
        [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_CHAT_ESF page:POTENTIAL_CLIENT_CHAT note:nil];
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp sayHello:_isSayHello willSendProp:_willSendProp willSendMessage:self.finishSendMessageBlock];
    }
}

//打招呼成功之后的回调
- (void)sayHelloHttpRequest:(NSDictionary *)reponseDict
{
    NSDictionary *dic2 = reponseDict[@"data"];
    NSString *unid = reponseDict[@"unid"];
    NSString *status = dic2[@"status"];
    
    [self sayHelloSuccessButton];
    [self didClickKeyboardControl];
    
    NSString *modeStatus = [[dic2 objectForKey:@"model"] objectForKey:@"status"];
    if (![status isEqualToString:@"1"])
    {
        [self displayHUDWithStatus:@"" Message:@"" ErrCode:@""];
        [[AXChatMessageCenter defaultMessageCenter] deleteMessageByIdentifier:unid];
    }else
    {
        if ([modeStatus isEqualToString:@"ok"])
        {
            NSDictionary *postParams = [reponseDict objectForKey:@"propdict"];
            NSString *body = [[[postParams objectForKey:@"model_body"] JSONValue] objectForKey:@"body"];
            NSString *sayHelloSuccess = @"推荐房源成功，请等待客户联系你";
            NSString *messId = [[dic2 objectForKey:@"model"] objectForKey:@"msg_id"];
            
            AXMappedMessage *Mess = [self sendSystemMessage:AXMessageTypeText content:body messageId:messId];
            [[AXChatMessageCenter defaultMessageCenter] saveMessageWithSystemType:Mess];
            AXMappedMessage * mappMess = [self sendSystemMessage:AXMessageTypeSenpropSuccess content:sayHelloSuccess messageId:NULL];
            [[AXChatMessageCenter defaultMessageCenter] saveMessageWithSystemType:mappMess];
        }
    }
}


- (void)displayHUDWithStatus:(NSString *)status Message:(NSString*)message ErrCode:(NSString*)errCode {
    if (self.hudBackground == nil) {
        self.hudBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 135)];
        self.hudBackground.image = [UIImage imageNamed:@"anjuke_icon_tips_bg"];
        
        self.hudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(135/2-70/2, 135/2-70/2 - 20, 70, 70)];
        self.hudText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.hudImageView.bottom+7, 135, 20)];
        [self.hudText setTextColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [self.hudText setFont:[UIFont systemFontOfSize:17.0f]];
        [self.hudText setTextAlignment:NSTextAlignmentCenter];
        self.hudText.backgroundColor = [UIColor clearColor];
        
        self.hubSubText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.hudText.bottom, 135, 20)];
        [self.hubSubText setTextColor:[UIColor colorWithWhite:0.95 alpha:1]];
        [self.hubSubText setFont:[UIFont systemFontOfSize:12.0f]];
        [self.hubSubText setTextAlignment:NSTextAlignmentCenter];
        self.hubSubText.backgroundColor = [UIColor clearColor];
        
        [self.hudBackground addSubview:self.hudImageView];
        [self.hudBackground addSubview:self.hudText];
        [self.hudBackground addSubview:self.hubSubText];
        
    }
    
    //使用 MBProgressHUD
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.customView = self.hudBackground;
    self.hud.yOffset = -20;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.dimBackground = NO;
    
    self.hudImageView.image = [UIImage imageNamed:@"anjuke_icon_tips_sad"];
    self.hudText.text = @"客户被抢了";
    self.hubSubText.text = @"你太慢了";
    self.hubSubText.hidden = NO;
    
    [self.hud hide:YES afterDelay:2]; //显示一段时间后隐藏
}



#pragma mark - UITableview delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AXChatBaseCell *cell = (AXChatBaseCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];

    return cell;
}

#pragma mark - DataSouce Method
- (NSString *)checkFriendUid
{
    if (_isSayHello)
    {
        return _deviceID;
    }
    if (self.uid) {
        return self.uid;
    }
    return @"";
}
#pragma mark - AXChatMessageRootCellDelegate

- (void)didClickAvatar:(BOOL)isCurrentPerson {
    if (isCurrentPerson) {
        return;
    }else {
        [self viewCustomerDetailInfo];
//            AXMappedPerson *item = self.friendPerson;
//        
//        if (item.userType == AXPersonTypeUser) {
//            ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
//            cd.person = item;
//            cd.backType = RTSelectorBackTypePopToRoot;
//            [cd setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:cd animated:YES];
//        } else {
//        
//        }
            //for test


    }
    
}

#pragma mark - ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(BK_ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    
    if ([info count] == 0) {
        return;
    }
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    int tempNum = 1;
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        CGSize size = image.size;

        NSString *name = [NSString stringWithFormat:@"_%d-%dx%d", tempNum ++, (int)size.width, (int)size.width];
        NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
//        NSString *url = [AXPhotoManager getLibrary:path];
//        NSLog(@"==========url=======%@",url);
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = @"1";
        //        mappedMessage.content = self.messageInputView.textView.text;
//        mappedMessage.content = @"[图片]";
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypePic];
        mappedMessage.imgPath = path;
        mappedMessage.isImgDownloaded = YES;
        if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
            [[AXChatMessageCenter defaultMessageCenter] sendImageToPublic:mappedMessage willSendMessage:self.finishSendMessageBlock];
        } else {
            [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(BK_ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *newSizeImage = nil;
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
   newSizeImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(1280, 1280) interpolationQuality:kCGInterpolationHigh];
    
    CGSize size = newSizeImage.size;
    NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
    NSString *path = [AXPhotoManager saveImageFile:newSizeImage toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
//    NSString *url = [AXPhotoManager getLibrary:path];
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = @"2";
    //        mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = @(AXMessageTypePic);
    mappedMessage.imgPath = path;
    mappedMessage.isImgDownloaded = YES;
    if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendImageToPublic:mappedMessage willSendMessage:self.finishSendMessageBlock];
    } else {
        [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
    }
    
    //        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
    //        NSDictionary *imageData = @{@"messageType":@"image",@"content":image,@"messageSource":@"incoming"};
    //        [self.cellData addObject:imageData];
    //        [self reloadMytableView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PrivateMethods

- (void)learnViewBtAction:(id)sender
{
    NSDictionary *btDict = self.buttonDict;
    JSMessageInputView *messInputView = [btDict objectForKey:AXUITEXVIEWEDIT];
    if (!_sayHelloAlertView)
    {
        [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_CHAT_OTHER page:POTENTIAL_CLIENT_CHAT note:nil];
        NSString *alertText = @"用户回复你以后才能使用这功能:)";
        UIFont *aFont = [UIFont systemFontOfSize:14];
        CGSize aSize = [alertText sizeWithFont:aFont];
        
        
        _sayHelloAlertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aSize.width + 6, aSize.height + 6)];
        
        CGFloat hWidth = CGRectGetWidth(_sayHelloAlertView.frame);
        CGFloat hHeight = CGRectGetHeight(_sayHelloAlertView.frame);
        
        //文字背景
        UIImage *img = [UIImage imageNamed:@"broker_wl_unused_tips_bg"];
        UIImageView *alertHead = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, hWidth, hHeight)];
        [alertHead setImage:[img stretchableImageWithLeftCapWidth:3 topCapHeight:3]];
        
        //箭头
        
        UIImage *imgFoot = [UIImage imageNamed:@"broker_wl_unused_tips_arrow"];
        CGFloat fX = CGRectGetWidth(alertHead.frame) / 2;
        CGFloat fY = CGRectGetHeight(alertHead.frame) + imgFoot.size.height / 2 - .5f;
        UIImageView *alertFoot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgFoot.size.width, imgFoot.size.height)];
        [alertFoot setImage:imgFoot];
        [alertFoot setCenter:CGPointMake(fX, fY)];
        
        //提示文字
        UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, aSize.width, aSize.height)];
        [la setBackgroundColor:[UIColor clearColor]];
        [la setText:alertText];
        [la setFont:aFont];
        [la setTextColor:[UIColor ajkWhiteColor]];
        [alertHead addSubview:la];
        
        
        [_sayHelloAlertView addSubview:alertHead];
        [_sayHelloAlertView addSubview:alertFoot];
        [_sayHelloAlertView bringSubviewToFront:alertHead];
        [self.view addSubview:_sayHelloAlertView];
        
        CGFloat sHeight = CGRectGetHeight(alertHead.frame) + CGRectGetHeight(alertFoot.frame);
        [_sayHelloAlertView setFrame:CGRectMake(0, 0, CGRectGetWidth(alertHead.frame), sHeight)];
    }
    
    CGFloat alertX = CGRectGetWidth(self.view.frame) / 2;
    CGFloat alertY = messInputView.frame.origin.y - 20;
    [_sayHelloAlertView setCenter:CGPointMake(alertX, alertY)];
    
    if (_sayHelloAlertView.hidden)
    {
        [_sayHelloAlertView setHidden:NO];
        [_sayHelloAlertView setAlpha:1];
    }
    
    if (!_sayHelloAlertView.hidden)
    {
        [UIView animateWithDuration:1.f animations:
         ^{
            [_sayHelloAlertView setAlpha:0];
        } completion:^(BOOL finished)
        {
            [_sayHelloAlertView setHidden:YES];
        }];
    }
}

- (void)hideLearnView:(id)sender
{//隐藏引导页
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *learnView = [window viewWithTag:-11];//获得引导页
    UIImageView *titleLearn = (UIImageView *)[window viewWithTag:-12];
    [learnView removeFromSuperview];
    [titleLearn removeFromSuperview];
}

- (void)rightButtonAction:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_CLICK_CLIENT page:CHAT note:nil];
    [self viewCustomerDetailInfo];
}

- (void)viewCustomerDetailInfo {
    if (self.friendPerson.userType == AXPersonTypePublic) {
        
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_CLICK_CLIENT page:CHAT note:nil];
        AXMappedPerson *item = self.friendPerson;
        //for test
        ClientDetailPublicViewController *cd = [[ClientDetailPublicViewController alloc] init];
        cd.publicComeFromeType = AXPersonPublicComeFromeTypeChatView;
        cd.person = item;
        cd.backType = RTSelectorBackTypePopBack;
        [cd setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cd animated:YES];
    }else if (self.friendPerson.userType == AXPersonTypeUser){
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_CLICK_CLIENT page:CHAT note:nil];
        AXMappedPerson *item = self.friendPerson;
        //for test
        ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
        cd.comeFromeType = AXPersonComeFromeTypeChatView;
        cd.person = item;
        cd.backType = RTSelectorBackTypePopBack;
        [cd setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cd animated:YES];
    }
}


#pragma mark -
#pragma mark LOG Method
- (void)clickLocationLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_CLICK_LOCATION page:CHAT note:nil];
}
- (void)switchToVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_TRANSTOSPEAK page:CHAT note:nil];
}
- (void)switchToTextLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_TRANSTOWORD page:CHAT note:nil];
}
- (void)pressForVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_SPEAKING page:CHAT note:nil];
}
- (void)cancelSendingVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_CANCEL_SPEAKING page:CHAT note:nil];
}

- (void)doBack:(id)sender {
    
    [self storageLayoutOfKeyboard];
    
    [self didClickKeyboardControl];
    
    if ([BrokerChatViewController getBrokerSelf])
    {
        [BrokerChatViewController setBrokerSelf:nil];
    }
    
    if (_isSayHello)
    {
        [[BrokerLogger sharedInstance] logWithActionCode:POTENTIAL_CLIENT_CHAT_BACK page:POTENTIAL_CLIENT_CHAT note:nil];
    }else
    {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_BACK page:CHAT note:nil];
    }
    
    if (self.backType == RTSelectorBackTypePopBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.navigationController.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)didClickTelNumber:(NSString *)telNumber {
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_PHONE_NUMBER page:CHAT note:nil];
    
    NSArray *phone = [NSArray arrayWithArray:[telNumber componentsSeparatedByString:@":"]];
    
    if (phone.count == 2) {
        
            self.phoneNumber = [phone objectAtIndex:1];
        NSString *title = [NSString stringWithFormat:@"%@可能是个电话号码，你可以",self.phoneNumber];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拨打电话",@"保存到客户资料", nil];
        [sheet showInView:self.view];
    }

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_CALL page:CHAT note:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumber]]];
    }else if (buttonIndex == 1){
        [[BrokerLogger sharedInstance] logWithActionCode:CHAT_SAVE_PHONE_NUMBER page:CHAT note:nil];
        self.friendPerson.markPhone = self.phoneNumber;
        [[AXChatMessageCenter defaultMessageCenter] updatePerson:self.friendPerson];
        [self requestUpdatePerson];
    }else {
    
    }
}
- (void)requestUpdatePerson {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    NSString *methodName = [NSString stringWithFormat:@"user/modifyFriendInfo/%@",[LoginManager getPhone]];
    
    NSDictionary *params = @{@"to_uid":self.friendPerson.uid,
                             @"relation_cate_id":@"0",
                             @"mark_phone":self.friendPerson.markPhone ? self.friendPerson.markPhone : @"" };
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTAnjukeXRESTServiceID methodName:methodName params:params target:self action:@selector(onGetData:)];
}
- (void)onGetData:(RTNetworkResponse *) response {
    //check network and response
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    if ([[[response content] objectForKey:@"status"] isEqualToString:@"ERROR"]){
        [self showInfo:[[response content] objectForKey:@"errorMessage"]];
    }else if([[[response content] objectForKey:@"status"] isEqualToString:@"OK"]){
        [self showInfo:@"保存成功"];
    }
    DLog(@"更新标星后:%@--msg[%@]", [response content], [response content][@"errorMessage"]);
}
#pragma mark - AXChatMessageRootCellDelegate
- (void)didClickPropertyWithUrl:(NSString *)url withTitle:(NSString *)title;
{
    AXChatWebViewController *webViewController = [[AXChatWebViewController alloc] init];
    webViewController.webUrl = url;
    webViewController.webTitle = title;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - AJKChatMessageSystemCellDelegate
- (void)didClickSystemButton:(AXMessageType)messageType {
    switch (messageType) {
        case AXMessageTypeSendProperty:
        {
//            [self sendPropMessage];
        }
            break;
            
        case AXMessageTypeSettingNotifycation:
        {
            AXNotificationTutorialViewController *controller = [[AXNotificationTutorialViewController alloc] initWithNibName:@"AXNotificationTutorialViewController" bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
            controller.navigationController.navigationBar.translucent = NO;
            [self presentViewController:navController animated:YES completion:nil];
        }
            break;
        case AXMessageTypeAddNote:
        {
            ClientEditViewController *controller = [[ClientEditViewController alloc] init];
            controller.person = self.friendPerson;
            controller.backType = RTSelectorBackTypeDismiss;
            RTGestureBackNavigationController *navController = [[RTGestureBackNavigationController alloc] initWithRootViewController:controller];
            controller.navigationController.navigationBar.translucent = NO;
            [self presentViewController:navController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (void)didMessageRetry:(AXChatMessageRootCell *)axCell
{
    if (self.friendPerson.userType == AXPersonTypePublic) {
        if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeText)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeProperty)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeLocation)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeVoice)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendVoiceToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypePic)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendImageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else {
            
        }
        // 之后必改
    } else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypePic)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendImage:axCell.identifyString withCompeletionBlock:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeText)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeLocation)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeProperty)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeVoice)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendVoice:axCell.identifyString withCompeletionBlock:self.finishReSendMessageBlock];
    }else {
        
    }
}

#pragma mark - NSNotificationCenter
- (void)connectionStatusDidChangeNotification:(NSNotification *)notification
{
    if (self.navigationController.presentedViewController) {
        [self.navigationController.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.navigationController.viewControllers) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {
            NSArray *vcArray = [self.navigationController.viewControllers objectsAtIndexes:[[NSIndexSet alloc] initWithIndex:index - 1]];
            [self.navigationController setViewControllers:vcArray animated:YES];
        }
    }
}
#pragma mark - 
#pragma cellDelegate
- (void)didClickMapCell:(NSDictionary *) dic {
    MapViewController *mv = [[MapViewController alloc] init];
    [mv setHidesBottomBarWhenPushed:YES];
    mv.mapType = RegionNavi;
    mv.navDic = dic;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:mv animated:YES];
    
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_CLICK_OPEN_LOCATION page:CHAT note:nil];
}

#pragma mark -
#pragma MapViewControllerDelegate
- (void)loadMapSiteMessage:(NSDictionary *)mapSiteDic {
    
    NSDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"google_lat":mapSiteDic[@"google_lat"], @"google_lng":mapSiteDic[@"google_lng"], @"city":mapSiteDic[@"city"], @"region":mapSiteDic[@"region"], @"address":mapSiteDic[@"address"],@"from_map_type":mapSiteDic[@"from_map_type"], @"jsonVersion":@"1", @"tradeType":[NSNumber numberWithInteger:AXMessageTypeLocation]}];
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"2";
    mappedMessageProp.content = [dic RTJSONRepresentation];
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeLocation];
    if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendMessageToPublic:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }else {
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}

@end
