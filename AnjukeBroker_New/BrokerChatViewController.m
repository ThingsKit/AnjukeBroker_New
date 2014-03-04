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

#import "AXPhoto.h"

@interface BrokerChatViewController ()
{
    
}
@property (nonatomic, strong) NSString *phoneNumber;
@end

@implementation BrokerChatViewController

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
    
    [self initRightBar];
	// Do any additional setup after loading the view.
}
- (void)initRightBar {
    UIButton *rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBut.frame = CGRectMake(0, 0, 40, 40);
    [rightBut addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBut setImage:[UIImage imageNamed:@"anjuke_icon_person"] forState:UIControlStateNormal];
    [rightBut setImage:[UIImage imageNamed:@"anjuke_icon_person"] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBut];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(doBack:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.cellData objectAtIndex:indexPath.row] && [[[self.cellData objectAtIndex:indexPath.row] objectForKey:@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePic]]) {
        
        NSMutableArray *imgArray = [NSMutableArray arrayWithArray:[[AXChatMessageCenter defaultMessageCenter] picMessageArrayWithFriendUid:[self checkFriendUid]]];
        
        NSMutableArray *photoArray = [NSMutableArray array];
        int currentPhotoIndex = 0;
        for (int i =0; i <imgArray.count; i ++) {
            AXPhoto *photo = [[AXPhoto alloc] init];
            photo.picMessage = [imgArray objectAtIndex:i];
//            photo.picMessage.imgUrl = @"http://a.hiphotos.baidu.com/image/w%3D2048/sign=0186658d0afa513d51aa6bde095554fb/359b033b5bb5c9ea85c7f3b2d739b6003af3b3af.jpg";
//            photo.picMessage.imgPath = @"";
            if ([[[self.cellData objectAtIndex:indexPath.row] objectForKey:@"identifier"] isEqualToString:photo.picMessage.identifier]) {
                currentPhotoIndex = i;
            }
            [photoArray addObject:photo];
        }

        AXPhotoBrowser *controller = [[AXPhotoBrowser alloc] init];
        controller.isBroker = YES;
        controller.currentPhotoIndex = currentPhotoIndex; // 弹出相册时显示的第一张图片是？
        [controller setPhotos:photoArray]; // 设置所有的图片
        [self.navigationController pushViewController:controller animated:YES];
    }
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
    //二手房单页详情url确认结果：http://m.anjuke.com/sale/x/11/204603156
    //格式：http://fp07.m.dev.anjuke.com/sale/x/{城市id}/{房源id}
    
    // 租房单页详情url确认结果：http://lvandu.dev.anjuke.com/rent/x/11/23893357-3
    //格式：http://fp07.m.dev.anjuke.com/rent/x/{城市id}/{房源id}-{租房类型}
    NSString *des = [NSString stringWithFormat:@"%@室%@厅%@卫 %@平",dic[@"roomNum"], dic[@"hallNum"], dic[@"toiletNum"], dic[@"area"]];
    if (houseType ) {
        NSString *price = [NSString stringWithFormat:@"%@%@", dic[@"price"], dic[@"priceUnit"]];
        NSString *url = nil;
        url = [NSString stringWithFormat:@"http://m.anjuke.com/sale/x/%@/%@",[LoginManager getCity_id],dic[@"id"]];
#if DEBUG
        url = [NSString stringWithFormat:@"http://fp07.m.dev.anjuke.com/sale/x/%@/%@",[LoginManager getCity_id],dic[@"id"]];
#endif
        self.propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceErShouFang]}];
    }else{
        NSString *price = [NSString stringWithFormat:@"%@%@/月", dic[@"price"], dic[@"priceUnit"]];
        NSString *url = nil;
        url = [NSString stringWithFormat:@"http://m.anjuke.com/sale/x/%@/%@-3",[LoginManager getCity_id],dic[@"id"]];
#if DEBUG
        url = [NSString stringWithFormat:@"http://fp07.m.dev.anjuke.com/rent/x/%@/%@-3",[LoginManager getCity_id],dic[@"id"]];
#endif
        self.propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"url":url, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceZuFang]}];
    }
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"1";
    mappedMessageProp.content = [self.propDict JSONRepresentation];
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
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGSize size = image.size;
    NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
    NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
    NSString *url = [AXPhotoManager getLibrary:path];
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = @"1";
    //        mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.content = @"[图片]";
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = [NSNumber numberWithInteger:AXMessageTypePic];
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
    AXMappedPerson *item = self.friendPerson;
    //for test
    ClientDetailViewController *cd = [[ClientDetailViewController alloc] init];
    cd.person = item;
    [cd setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:cd animated:YES];
}
- (void)doBack:(id)sender {
    
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
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumber]]];
    }else {

            self.friendPerson.markPhone = self.phoneNumber;
            [[AXChatMessageCenter defaultMessageCenter] updatePerson:self.friendPerson];
        
    }
}
@end
