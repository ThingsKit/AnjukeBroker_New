//
//  PublishHouseTypeEditViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-7.
//  Copyright (c) 2014年 Anjuke. All rights reserved.
//

#import "PublishHouseTypeEditViewController.h"
#import "BK_RTNavigationController.h"
#import "PropertyEditViewController.h"

@interface PublishHouseTypeEditViewController ()

@property (nonatomic, strong) NSMutableArray *lastAddHouseTypeImgArr; //上一次的户型图arr，用于取消时将户型图还原 T T
@property (nonatomic, strong) NSMutableArray *lastHouseTypeShowedImgArr; //上一次的户型图arr，用于取消时将户型图还原 T T

@property int deleteShowedImgIndex; //需要删除的已有图片的index

@end

@implementation PublishHouseTypeEditViewController
@synthesize addHouseTypeImageArray, houseTypeShowedImgArray;
@synthesize lastAddHouseTypeImgArr, lastHouseTypeShowedImgArr;
@synthesize deleteShowedImgIndex;
@synthesize propertyID;

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
    self.lastAddHouseTypeImgArr = [NSMutableArray array];
    self.lastHouseTypeShowedImgArr = [NSMutableArray array];
    
    for (int i = 0; i < self.addHouseTypeImageArray.count; i ++) {
        [self.lastAddHouseTypeImgArr addObject:[self.addHouseTypeImageArray objectAtIndex:i]];
    }
    
    for (int i = 0; i < self.houseTypeShowedImgArray.count; i ++) {
        [self.lastHouseTypeShowedImgArr addObject:[self.houseTypeShowedImgArray objectAtIndex:i]];
    }
    
    self.onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:self.property.onlineHouseTypeDic];
    
    [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

//点击的预览图片是否是新添加的图片
- (BOOL)isClickImgNewAddWithClickIndex:(int)clickIndex {
    BOOL isNewAdd = NO;
    
    if (clickIndex >= self.houseTypeShowedImgArray.count) {
        isNewAdd = YES;
    }
    
    return isNewAdd;
}

- (void)doBack:(id)sender {
    if ([self.superViewController isKindOfClass:[PropertyEditViewController class]]) {
        [[(PropertyEditViewController *)self.superViewController property] setRooms:self.lastRooms];
        [[(PropertyEditViewController *)self.superViewController property] setExposure:self.lastExposure];//还原上一次的输入
        
        [(PublishBuildingViewController *)self.superViewController setRoomValue:[self.lastRoomValue intValue]];
        [(PublishBuildingViewController *)self.superViewController setHallValue:[self.lastHallValue intValue]];
        [(PublishBuildingViewController *)self.superViewController setToiletValue:[self.lastToiletValue intValue]];
        
        [(PropertyEditViewController *)self.superViewController setAddHouseTypeImageArray:self.lastAddHouseTypeImgArr]; //还原户型图
        [(PropertyEditViewController *)self.superViewController setHouseTypeShowedImgArray:self.lastHouseTypeShowedImgArr]; //还原户型图
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction:(id)sender { //do save
    
    if ([self.superViewController isKindOfClass:[PropertyEditViewController class]]) {
        [[(PropertyEditViewController *)self.superViewController property] setOnlineHouseTypeDic:[NSDictionary dictionaryWithDictionary:self.onlineHouseTypeDic]];//赋值新在线户型图数据
        
        NSString *houseTypeName = [NSString stringWithFormat:@"%@  %@", self.houseTypeTF.text, self.exposureTF.text];
        
        //设置房型文案显示
//        [(PropertyEditViewController *)self.superViewController setHouseTypeShowWithString:houseTypeName];
        [(PropertyEditViewController *)self.superViewController setAddHouseTypeImageArray:self.addHouseTypeImageArray]; //设置户型图
        [(PropertyEditViewController *)self.superViewController setHouseTypeShowedImgArray:self.houseTypeShowedImgArray]; //设置户型图
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request Method

//图片删除
- (void)doDeleteImgWithImgID:(NSString *)imgID {
    if (![self isNetworkOkayWithNoInfo]) {
        [[HUDNews sharedHUDNEWS] createHUD:@"无网络连接" hudTitleTwo:nil addView:self.view isDim:NO isHidden:YES hudTipsType:HUDTIPSWITHNetWorkBad];
        return;
    }
    
    [self showLoadingActivity:YES];
    self.isLoading = YES;
    
    //更新房源信息
    NSMutableDictionary *params = nil;
    NSString *method = nil;
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[LoginManager getToken], @"token", [LoginManager getUserID], @"brokerId", self.propertyID, @"propId", imgID, @"aids", nil];
    method = @"img/delimg/";
    
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onDeleteImgFinished:)];
}

- (void)onDeleteImgFinished:(RTNetworkResponse *)response {
    DLog(@"--。。。response [%@]", [response content]);
    
    if ([response status] == RTNetworkResponseStatusFailed || [[[response content] objectForKey:@"status"] isEqualToString:@"error"]) {
        [self hideLoadWithAnimated:YES];
        self.isLoading = NO;
        
        NSString *errorMsg = [NSString stringWithFormat:@"%@",[[response content] objectForKey:@"message"]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
//    [self showInfo:@"图片已删除"];
    
    [self.houseTypeShowedImgArray removeObjectAtIndex:self.deleteShowedImgIndex];
    
    //redraw footer img view
    [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
    
    [self hideLoadWithAnimated:YES];
    self.isLoading = NO;
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

//当前已有的室内图数量
- (int)getCurrentHouseTypeImgCount {
    if (self.onlineHouseTypeDic.count > 0) {
        return self.addHouseTypeImageArray.count + self.houseTypeShowedImgArray.count +1;
    }

    return self.addHouseTypeImageArray.count + self.houseTypeShowedImgArray.count;
}

//相册还可添加的图片数量
- (int)getMaxAddHouseTypeImgCountForPhotoAlbum {
    int maxCount = AJK_MAXCOUNT_HOUSETYPEIMAGE;
    if (self.isHaozu) {
        maxCount = HZ_MAXCOUNT_HOUSETYPEIMAGE;
    }
    
    if (self.onlineHouseTypeDic.count > 0) {
        return (maxCount - self.addHouseTypeImageArray.count - self.houseTypeShowedImgArray.count - 1);
    }
    
    return (maxCount - self.addHouseTypeImageArray.count - self.houseTypeShowedImgArray.count);
}

#pragma mark - PhotoFooterImageClickDelegate

- (void)imageDidClickWithIndex:(int)index { //图片预览点击
    int imageIndex = index - 0;
    DLog(@"查看大图--index [%d]", imageIndex);
    
    //查看大图
    //模态弹出图片播放器
    PublishBigImageViewController *pb = [[PublishBigImageViewController alloc] init];
    pb.clickDelegate = self;
    pb.isEditProperty = YES;
    BK_RTNavigationController *navController = [[BK_RTNavigationController alloc] initWithRootViewController:pb];
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:navController animated:YES completion:^(void) {
        
        NSMutableArray *editImgShowArr = [NSMutableArray array];
        if (![self isClickImgNewAddWithClickIndex:imageIndex]) {
            //已有图片array
            [editImgShowArr addObject:[[self.houseTypeShowedImgArray objectAtIndex:imageIndex] objectForKey:@"imgUrl"]];
        }
        else { //新添加图片
            if (self.onlineHouseTypeDic.count > 0 && imageIndex == self.houseTypeShowedImgArray.count + self.addHouseTypeImageArray.count) {
                [pb showImagesForOnlineHouseTypeWithDic:self.onlineHouseTypeDic];
                return;
            }
            else
                [editImgShowArr addObject:[(E_Photo *)[self.addHouseTypeImageArray objectAtIndex:imageIndex - self.houseTypeShowedImgArray.count] smallPhotoUrl]];
        }
        
        pb.isNewAddImg = [self isClickImgNewAddWithClickIndex:imageIndex];
        [pb showImagesWithArray:editImgShowArr atIndex:imageIndex];
    }];
}

#pragma mark - PhotoViewClickDelegate

- (void)closePicker_Click_WithImgArr:(NSMutableArray *)arr {
    for (int i = 0; i < arr.count; i ++) {
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:(UIImage *)[arr objectAtIndex:i] toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        ep.smallPhotoUrl = url;
        
        [self.addHouseTypeImageArray addObject:ep];
    }
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
    
    //redraw footer img view
    [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

#pragma mark - PublishBigImageViewClickDelegate

- (void)editPropertyDidDeleteImgWithDeleteIndex:(int)deleteIndex sender:(id)sender{
    
    //删除对应图片
    if ([self isClickImgNewAddWithClickIndex:deleteIndex]) { //新添加图片
        [self.addHouseTypeImageArray removeObjectAtIndex:deleteIndex - self.houseTypeShowedImgArray.count];
        
        //redraw footer img view
        [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
    }
    else {//已有图片删除，交互...
        self.deleteShowedImgIndex = deleteIndex;
        if (deleteIndex >= self.houseTypeShowedImgArray.count) {
            return;
        }
        
        NSString *deleteImgID = [[self.houseTypeShowedImgArray objectAtIndex:deleteIndex] objectForKey:@"imgId"];
        [self doDeleteImgWithImgID:deleteImgID];
    }
}

- (void)onlineHouseTypeImgDelete {
    self.onlineHouseTypeDic = [NSDictionary dictionary];
    
    [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

#pragma mark - Online Img Select Delegate

- (void)onlineImgDidSelect:(NSDictionary *)imgDic {
    DLog(@"在线房形图Data--[%@]", imgDic);
    self.onlineHouseTypeDic = [NSDictionary dictionaryWithDictionary:imgDic];
    
    [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
}

#pragma mark - ELCImagePickerControllerDelegate

- (void)elcImagePickerController:(BK_ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    int count = [info count];
    if (![self canAddMoreImageWithAddCount:count]) {
        return;
    }
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        //保存原始图片、得到url
        E_Photo *ep = [PhotoManager getNewE_Photo];
        NSString *path = [PhotoManager saveImageFile:image toFolder:PHOTO_FOLDER_NAME];
        NSString *url = [PhotoManager getDocumentPath:path];
        ep.photoURL = url;
        
        UIImage *newSizeImage = nil;
        //压缩图片
        if (image.size.width > IMAGE_MAXSIZE_WIDTH || image.size.height > IMAGE_MAXSIZE_WIDTH || self.isTakePhoto) {
            CGSize coreSize;
            if (image.size.width > image.size.height) {
                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH*(image.size.height /image.size.width));
            }
            else if (image.size.width < image.size.height){
                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH *(image.size.width /image.size.height), IMAGE_MAXSIZE_WIDTH);
            }
            else {
                coreSize = CGSizeMake(IMAGE_MAXSIZE_WIDTH, IMAGE_MAXSIZE_WIDTH);
            }
            
            UIGraphicsBeginImageContext(coreSize);
            [image drawInRect:[Util_UI frameSize:image.size inSize:coreSize]];
            newSizeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            path = [PhotoManager saveImageFile:newSizeImage toFolder:PHOTO_FOLDER_NAME];
            url = [PhotoManager getDocumentPath:path];
            ep.smallPhotoUrl = url;
            
        }
        else {
            ep.smallPhotoUrl = url;
        }
        
        [self.addHouseTypeImageArray addObject:ep];
	}
    
    //redraw footer img view
    [self.footerView redrawWithEditHouseTypeShowedImageArray:[PhotoManager transformEditImageArrToFooterShowArrWithArr:self.houseTypeShowedImgArray] andAddImgArr:[PhotoManager transformRoomImageArrToFooterShowArrWithArr:self.addHouseTypeImageArray] andOnlineHouseTypeArr:[PhotoManager transformOnlineHouseTypeImageArrToFooterShowArrWithArr:self.onlineHouseTypeDic]];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
