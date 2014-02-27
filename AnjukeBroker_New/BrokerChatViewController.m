//
//  BrokerChatViewController.m
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 2/24/14.
//  Copyright (c) 2014 Wu sicong. All rights reserved.
//

#import "BrokerChatViewController.h"
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
        [photos addObject:photo];    [photos addObject:photo];
//    if ([self.cellData objectAtIndex:indexPath.row] && [[[self.cellData objectAtIndex:indexPath.row] objectForKey:@"messageType"] isEqualToNumber:[NSNumber numberWithInteger:AXMessageTypePic]]) {
        AXPhotoBrowser *controller = [[AXPhotoBrowser alloc] init];
        controller.currentPhotoIndex = 1; // 弹出相册时显示的第一张图片是？
        controller.photos = photos; // 设置所有的图片
        [self.navigationController pushViewController:controller animated:YES];
//    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
