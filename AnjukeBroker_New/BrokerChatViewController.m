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
	// Do any additional setup after loading the view.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableArray *photos = [NSMutableArray array];
    AXPhoto *photo = [[AXPhoto alloc] init];
    photo.image = [UIImage imageNamed:@"anjuke_icon05_photo_selected@2x.png"];
    [photos addObject:photo];
        [photos addObject:photo];
        [photos addObject:photo];
        [photos addObject:photo];
        [photos addObject:photo];
    
//    if ([self.cellData objectAtIndex:indexPath.row] && [[[self.cellData objectAtIndex:indexPath.row] objectForKey:@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePic]]) {
        AXPhotoBrowser *controller = [[AXPhotoBrowser alloc] init];
        controller.currentPhotoIndex = 1; // 弹出相册时显示的第一张图片是？
        controller.photos = photos; // 设置所有的图片
        [self.navigationController pushViewController:controller animated:YES];
//    }
}
- (void)pickAJK:(id)sender {
    CommunitySelectViewController *controller = [[CommunitySelectViewController alloc] init];
    controller.pageTypeFrom = secondHandHouse;
    HouseSelectNavigationController *nav = [[HouseSelectNavigationController alloc] initWithRootViewController:controller];
    nav.selectedHouseDelgate = self;
    [self presentViewController:nav animated:YES completion:nil];
    //    NSDictionary *roomSource = @{@"title": @"中房二期花园，地理位置好",@"price":@"12000",@"roomType":@"3房两厅",@"area":@"200",@"floor":@"13/14",@"year":@"2005",@"messageType":[NSNumber numberWithInteger:AXMessageTypeProperty],@"messageSource":[NSNumber numberWithInteger:AXChatMessageSourceDestinationIncoming]};
    //    [self.cellData addObject:roomSource];
    //    [self reloadMytableView];
}
-(void)returnSelectedHouseDic:(NSDictionary *)dic houseType:(BOOL)houseType {
    
    NSString *des = [NSString stringWithFormat:@"%@室%@厅%@卫",dic[@"roomNum"], dic[@"hallNum"], dic[@"toiletNum"]];
    NSString *price = [NSString stringWithFormat:@"%@/%@", dic[@"price"], dic[@"priceUnit"]];
    self.propDict = [NSMutableDictionary dictionaryWithDictionary:@{@"id":dic[@"id"], @"des":des, @"img":dic[@"imgUrl"], @"name":dic[@"commName"], @"price":price, @"tradeType":[NSNumber numberWithInteger:AXMessagePropertySourceErShouFang]}];
    
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = @"1";
    mappedMessageProp.content = [self.propDict JSONRepresentation];
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = [NSNumber numberWithBool:YES];
    mappedMessageProp.isRemoved = [NSNumber numberWithBool:NO];
    mappedMessageProp.messageType = [NSNumber numberWithInteger:AXMessageTypeProperty];
    [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
}
@end
