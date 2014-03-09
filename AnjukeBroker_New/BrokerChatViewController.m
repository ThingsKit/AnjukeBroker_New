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
#import "AXUtil_UI.h"
#import "UIImage+Resize.h"
#import "NSString+RTStyle.h"
#import "ClientDetailPublicViewController.h"

@interface BrokerChatViewController ()
{
    
}
@property (nonatomic, strong) NSString *phoneNumber;
@end

@implementation BrokerChatViewController
#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - lifeCycle
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
    // 设置返回btn
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString getStyleBundlePath:@"anjuke_icon_back.png"]];
    UIImage *highlighted = [UIImage imageWithContentsOfFile:[NSString getStyleBundlePath:@"anjuke_icon_back.png"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width + 40 , 44);
    [button addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlighted forState:UIControlStateHighlighted];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitle:@"返回" forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    button.titleLabel.backgroundColor = [UIColor clearColor];
    button.backgroundColor = [UIColor clearColor];
    self.backBtn = button;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    UIButton *brokerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    brokerButton.frame = CGRectMake(0, 0, 44, 44);
//    [brokerButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *buttonItems = [[UIBarButtonItem alloc] initWithCustomView:brokerButton];
//
//    [self.navigationItem setLeftBarButtonItem:buttonItems];
    [self initRightBar];
    
    [self initNavTitle];
}
- (void)initNavTitle {
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:self.friendPerson.uid];
    NSString *titleString = @"";
    if (person.markName.length > 0) {
        titleString = [NSString stringWithFormat:@"%@", person.markName];
    }
    else {
        titleString = [NSString stringWithFormat:@"%@", self.friendPerson.name];
        if ([person.markName isEqualToString:person.phone]) {
            titleString = [Util_TEXT getChatNameWithPhoneFormat:person.phone];
        }
    }
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 31)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:19];
    lb.text = titleString;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = lb;
}

- (void)initRightBar {
    UIButton *brokerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    brokerButton.frame = CGRectMake(0, 0, 44, 44);
    [brokerButton setImage:[UIImage imageNamed:@"anjuke_icon_person.png"] forState:UIControlStateNormal];
    [brokerButton setImage:[UIImage imageNamed:@"anjuke_icon_person.png"] forState:UIControlStateHighlighted];
    [brokerButton addTarget:self action:@selector(viewCustomerDetailInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItems = [[UIBarButtonItem alloc] initWithCustomView:brokerButton];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -10.0f;
    [self.navigationItem setRightBarButtonItems:@[spacer, buttonItems]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = (self.identifierData)[[indexPath row]];
    NSDictionary *dic = self.cellDict[identifier];
    if ([dic[@"messageType"] isEqualToNumber:@(AXMessageTypePic)]) {
        NSMutableArray *imgArray = [NSMutableArray arrayWithArray:[[AXChatMessageCenter defaultMessageCenter] picMessageArrayWithFriendUid:[self checkFriendUid]]];
        NSMutableArray *photoArray = [NSMutableArray array];
        int currentPhotoIndex = 0;
        for (int i =0; i <imgArray.count; i ++) {
            AXPhoto *photo = [[AXPhoto alloc] init];
            photo.picMessage = imgArray[i];
            if ([dic[@"identifier"] isEqualToString:photo.picMessage.identifier]) {
                currentPhotoIndex = i;
            }
            [photoArray addObject:photo];
        }
        AXPhotoBrowser *controller = [[AXPhotoBrowser alloc] init];
        controller.currentPhotoIndex = currentPhotoIndex; // 弹出相册时显示的第一张图片是？
        [controller setPhotos:photoArray]; // 设置所有的图片
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (void)pickIMG:(id)sender {
    AXELCImagePickerController *elcPicker = [[AXELCImagePickerController alloc] init];
    
    elcPicker.maximumImagesCount = 20; //(maxCount - self.roomImageArray.count);
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)takePic:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
- (void)pickAJK:(id)sender {
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = secondHandHouse;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)pickHZ:(id)sender {
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = rentHouse;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
}
-(void)returnSelectedHouseDic:(NSDictionary *)dic houseType:(BOOL)houseType {
    NSMutableDictionary *propDict = [NSMutableDictionary dictionary];
    //二手房单页详情url确认结果：http://m.anjuke.com/sale/x/11/204603156
    //格式：http://fp07.m.dev.anjuke.com/sale/x/{城市id}/{房源id}
    
    // 租房单页详情url确认结果：http://lvandu.dev.anjuke.com/rent/x/11/23893357-3
    //格式：http://fp07.m.dev.anjuke.com/rent/x/{城市id}/{房源id}-{租房类型}
    NSString *des = [NSString stringWithFormat:@"%@室%@厅%@卫 %d平",dic[@"roomNum"], dic[@"hallNum"], dic[@"toiletNum"], [dic[@"area"] integerValue]];
    if (houseType ) {
        NSString *price = [NSString stringWithFormat:@"%d%@", [dic[@"price"] integerValue], dic[@"priceUnit"]];
        NSString *url = nil;
        url = [NSString stringWithFormat:@"http://m.anjuke.com/sale/x/%@/%@",[LoginManager getCity_id],dic[@"id"]];
#if DEBUG
//        url = [NSString stringWithFormat:@"http://fp07.m.dev.anjuke.com/sale/x/%@/%@",[LoginManager getCity_id],dic[@"id"]];
#endif
        propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceErShouFang]}];
    }else{
        NSString *price = [NSString stringWithFormat:@"%@%@/月", dic[@"price"], dic[@"priceUnit"]];
        NSString *url = nil;//http://lvandu.dev.anjuke.com/rent/x/11/23893357-3
        url = [NSString stringWithFormat:@"http://m.anjuke.com/rent/x/%@/%@-3",[LoginManager getCity_id],dic[@"id"]];
#if DEBUG
//        url = [NSString stringWithFormat:@"http://lvandu.dev.anjuke.com/rent/x/%@/%@-3",[LoginManager getCity_id],dic[@"id"]];
#endif
        propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceZuFang]}];
    }
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"1";
    mappedMessageProp.content = [propDict JSONRepresentation];
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
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
//        AXMappedPerson *item = self.currentPerson;
//        //for test
//        ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
//        cd.person = item;
//        [cd setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:cd animated:YES];
    }else {

            AXMappedPerson *item = self.friendPerson;
            //for test
            ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
            cd.person = item;
        cd.backType = RTSelectorBackTypePopToRoot;
            [cd setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:cd animated:YES];

    }
    
}

#pragma mark - ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(AXELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
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
        NSString *url = [AXPhotoManager getLibrary:path];
        NSLog(@"==========url=======%@",url);
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = @"1";
        //        mappedMessage.content = self.messageInputView.textView.text;
//        mappedMessage.content = @"[图片]";
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypePic];
        mappedMessage.imgPath = url;
        [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(AXELCImagePickerController *)picker {
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
    NSString *url = [AXPhotoManager getLibrary:path];
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = @"2";
    //        mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = @(AXMessageTypePic);
    mappedMessage.imgPath = url;
    [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
    
    //        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
    //        NSDictionary *imageData = @{@"messageType":@"image",@"content":image,@"messageSource":@"incoming"};
    //        [self.cellData addObject:imageData];
    //        [self reloadMytableView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PrivateMethods
- (void)rightBarButtonClick:(id)sender {
    [self viewCustomerDetailInfo];
}

- (void)viewCustomerDetailInfo {
    if (self.friendPerson.userType == AXPersonTypePublic) {
        
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
        AXMappedPerson *item = self.friendPerson;
        //for test
        ClientDetailPublicViewController *cd = [[ClientDetailPublicViewController alloc] init];
        cd.person = item;
        [cd setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cd animated:YES];
    }else if (self.friendPerson.userType == AXPersonTypeUser){
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_009 note:nil];
        AXMappedPerson *item = self.friendPerson;
        //for test
        ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
        cd.person = item;
        [cd setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:cd animated:YES];
    }
    

}
- (void)doBack:(id)sender {
    
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_013 note:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didClickTelNumber:(NSString *)telNumber {

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
    }else {
        [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_012 note:nil];
            self.friendPerson.markPhone = self.phoneNumber;
            [[AXChatMessageCenter defaultMessageCenter] updatePerson:self.friendPerson];
        
    }
}
#pragma mark - AXChatMessageRootCellDelegate
- (void)didClickPropertyWithUrl:(NSString *)url withTitle:(NSString *)title;
{
    AXChatWebViewController *webViewController = [[AXChatWebViewController alloc] init];
    webViewController.webUrl = url;
    webViewController.webTitle = title;
    [self.navigationController pushViewController:webViewController animated:YES];
}
#pragma mark - NSNotificationCenter
- (void)connectionStatusDidChangeNotification:(NSNotification *)notification
{
    if (self.navigationController.presentedViewController) {
        [self.navigationController.presentedViewController dismissModalViewControllerAnimated:NO];
    }
    
    if (self.navigationController.viewControllers) {
        NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
        if (index > 0) {
            NSArray *vcArray = [self.navigationController.viewControllers objectsAtIndexes:[[NSIndexSet alloc] initWithIndex:index - 1]];
            [self.navigationController setViewControllers:vcArray animated:YES];
        }
    }
}
@end
