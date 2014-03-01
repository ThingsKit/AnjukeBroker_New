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
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.cellData objectAtIndex:indexPath.row] && [[[self.cellData objectAtIndex:indexPath.row] objectForKey:@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePic]]) {
//    NSMutableArray *photos = [NSMutableArray array];
    
        
     NSMutableArray *imgArray = [NSMutableArray arrayWithArray:[[AXChatMessageCenter defaultMessageCenter] picMessageArrayWithFriendUid:[self checkFriendUid]]];
        NSMutableArray *photoArray = [NSMutableArray array];
        
        for (int i =0; i <imgArray.count; i ++) {
            AXPhoto *photo = [[AXPhoto alloc] init];
            photo.picMessage = [imgArray objectAtIndex:i];
            photo.picMessage.imgPath = @"http://www.baidu.com/img/bdlogo.gif";
//            NSLog(@"%@===%@===%@===%@",photo.picMessage.imgPath,photo.picMessage.imgUrl,photo.picMessage.thumbnailImgPath,photo.picMessage.thumbnailImgUrl);
            [photoArray addObject:photo];
        }
        
        
//        AXPhoto *photo = [[AXPhoto alloc] init];
//        photo.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.baidu.com/img/bdlogo.gif"]]];
//        [photos addObject:photo];
//        [photos addObject:photo];
//        [photos addObject:photo];
//        [photos addObject:photo];
//        [photos addObject:photo];

        
        AXPhotoBrowser *controller = [[AXPhotoBrowser alloc] init];
#warning TODO 判断当前是第几张图
        controller.currentPhotoIndex = 1; // 弹出相册时显示的第一张图片是？
        controller.photos = photoArray; // 设置所有的图片
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
    
    NSString *des = [NSString stringWithFormat:@"%@室%@厅%@卫",dic[@"roomNum"], dic[@"hallNum"], dic[@"toiletNum"]];
    NSString *price = [NSString stringWithFormat:@"%@/%@", dic[@"price"], dic[@"priceUnit"]];
    if (houseType ) {
        self.propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceErShouFang]}];
    }else{
        self.propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceZuFang]}];
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
@end
