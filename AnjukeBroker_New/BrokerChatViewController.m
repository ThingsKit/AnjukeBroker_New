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
//#import "AXIMGDownloader.h"

@interface BrokerChatViewController ()
{
    
}
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) UIImageView *brokerIcon;
@property (nonatomic, assign) BOOL  isAlloc;
//@property (nonatomic, strong) AXIMGDownloader *imgDownloader;
@end

@implementation BrokerChatViewController
#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

- (void)didMoreBackView:(UIButton *)sender {
    [super didMoreBackView:sender];
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_004 note:nil];
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
    
    self.backType = RTSelectorBackTypePopToRoot;
    
    // 设置返回btn
    [self initRightBar];
    _isAlloc = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.friendPerson = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:self.friendPerson.uid];
    [self initNavTitle];
    [self resetLayoutOfKeyboard];
    [self removeStorageLayoutOfKeyboard];
//    [self downLoadIcon];
    
    if (_isAlloc && _needLearnView)
    {
        [self initLearnView];
    }
    _isAlloc = NO;
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
    
    self.moreBackView.hidden = YES;
    [self didMoreBackView:nil];

    UIView *moreView = self.moreBackView;
    UIButton *ajkErbt = (UIButton *)[moreView viewWithTag:-10];
    
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
    [self setTitleViewWithString:titleString];
 }

- (void)initRightBar {
    UIBarButtonItem *rightItem = [UIBarButtonItem getBarButtonItemWithImage:[UIImage imageNamed:@"anjuke_icon_person.png"] highLihtedImg:[UIImage imageNamed:@"anjuke_icon_person_press"] taget:self action:@selector(rightButtonAction:)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {//fix ios7以下 10像素偏离
        UIBarButtonItem *spacer = [UIBarButtonItem getBarSpace:10.0];
        [self.navigationItem setRightBarButtonItems:@[spacer, rightItem]];
    }else{
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)resetLayoutOfKeyboard {
    if (self.friendPerson.uid == nil) {
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
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_006 note:nil];
    
    BK_ELCAlbumPickerController *albumPicker = [[BK_ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    BK_ELCImagePickerController *elcPicker = [[BK_ELCImagePickerController alloc] initWithRootViewController:albumPicker];
    elcPicker.maximumImagesCount = 5; //(maxCount - self.roomImageArray.count);
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)takePic:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_005 note:nil];
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
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_007 note:nil];
    
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = secondHandHouse;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)pickHZ:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_008 note:nil];
    
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
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"1";
    mappedMessageProp.content = [propDict RTJSONRepresentation];
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
    if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendMessageToPublic:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    } else {
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}
#pragma mark - DataSouce Method
- (NSString *)checkFriendUid
{
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
- (void)hideLearnView:(id)sender
{//隐藏引导页
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIView *learnView = [window viewWithTag:-11];//获得引导页
    [learnView removeFromSuperview];
}

- (void)rightButtonAction:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
    [self viewCustomerDetailInfo];
}

- (void)viewCustomerDetailInfo {
    if (self.friendPerson.userType == AXPersonTypePublic) {
        
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
        AXMappedPerson *item = self.friendPerson;
        //for test
        ClientDetailPublicViewController *cd = [[ClientDetailPublicViewController alloc] init];
        cd.publicComeFromeType = AXPersonPublicComeFromeTypeChatView;
        cd.person = item;
        cd.backType = RTSelectorBackTypePopBack;
        [cd setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cd animated:YES];
    }else if (self.friendPerson.userType == AXPersonTypeUser){
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
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
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_015 note:nil];
}
- (void)switchToVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_016 note:nil];
}
- (void)switchToTextLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_017 note:nil];
}
- (void)pressForVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_018 note:nil];
}
- (void)cancelSendingVoiceLog{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_019 note:nil];
}

- (void)doBack:(id)sender {
    
    [self storageLayoutOfKeyboard];
    
    [self didClickKeyboardControl];
    
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_013 note:nil];
    self.tabBarController.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didClickTelNumber:(NSString *)telNumber {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_010 note:nil];
    
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
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_011 note:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumber]]];
    }else if (buttonIndex == 1){
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_012 note:nil];
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
    
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_020 note:nil];
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
