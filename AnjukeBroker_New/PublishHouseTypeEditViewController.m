//
//  PublishHouseTypeEditViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-7.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishHouseTypeEditViewController.h"
#import "RTNavigationController.h"

@interface PublishHouseTypeEditViewController ()

@property (nonatomic, strong) NSMutableArray *lastAddHouseTypeImgArr; //上一次的户型图arr，用于取消时将户型图还原 T T
@property (nonatomic, strong) NSMutableArray *lastHouseTypeShowedImgArr; //上一次的户型图arr，用于取消时将户型图还原 T T

@end

@implementation PublishHouseTypeEditViewController
@synthesize addHouseTypeImageArray, houseTypeShowedImgArray;
@synthesize lastAddHouseTypeImgArr, lastHouseTypeShowedImgArr;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLastDefultValueAndShowImg {
    for (int i = 0; i < self.addHouseTypeImageArray.count; i ++) {
        [self.lastAddHouseTypeImgArr addObject:[self.addHouseTypeImageArray objectAtIndex:i]];
    }
    
    for (int i = 0; i < self.houseTypeShowedImgArray.count; i ++) {
        [self.lastHouseTypeShowedImgArr addObject:[self.houseTypeShowedImgArray objectAtIndex:i]];
    }
    
    self.onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
    
    [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

#pragma mark - Check Method

//是否能添加更多室内图
- (BOOL)canAddMoreImageWithAddCount:(int)addCount{
    int maxCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
    if (self.isHaozu) {
        maxCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
    }
    
    if (self.onlineHouseTypeDic.count > 0) {
        if (addCount + self.addHouseTypeImageArray.count + self.houseTypeShowedImgArray.count +1 > maxCount ) {
            [self showInfo:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:YES]];
            return NO; //超出
        }
    }
    else  {
        if (addCount + self.addHouseTypeImageArray.count + self.houseTypeShowedImgArray.count > maxCount ){
            [self showInfo:[PhotoManager getImageMaxAlertStringForHaozu:self.isHaozu isHouseType:YES]];
            return NO; //超出
        }
    }
    
    return YES;
}

#pragma mark - PhotoFooterImageClickDelegate

- (void)imageDidClickWithIndex:(int)index { //图片预览点击
    if (self.onlineHouseTypeDic.count > 0) { //有在线户型图
        if (self.houseTypeImageArr.count != 0 && index <= self.houseTypeImageArr.count - 1) { //户型图
            //查看大图
            DLog(@"查看大图有在线户型图--index [%d]", index);
            
            //模态弹出图片播放器
            PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
            pb.clickDelegate = self;
            RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController presentViewController:navController animated:YES completion:^(void) {
                [pb showImagesWithArray:self.houseTypeImageArr atIndex:index];
            }];
        }
        else { //在线户型图
            DLog(@"在线户型图查看大图--index [%d]", index);
            //模态弹出图片播放器
            PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
            pb.clickDelegate = self;
            RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
            navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [self.navigationController presentViewController:navController animated:YES completion:^(void) {
                [pb showImagesForOnlineHouseTypeWithDic:self.onlineHouseTypeDic];
            }];
        }
    }
    else { //无在线户型图
        DLog(@"查看大图无在线户型图--index [%d]", index);
        
        //查看大图
        //模态弹出图片播放器
        PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
        pb.clickDelegate = self;
        RTNavigationController *navController = [[RTNavigationController alloc] initWithRootViewController:pb];
        navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.navigationController presentViewController:navController animated:YES completion:^(void) {
            [pb showImagesWithArray:self.houseTypeImageArr atIndex:index];
        }];
    }
}

@end
