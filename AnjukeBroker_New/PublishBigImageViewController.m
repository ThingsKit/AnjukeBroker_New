//
//  PublishBigImageViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-1-26.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PublishBigImageViewController.h"
#import "Util_UI.h"
#import "PhotoButton.h"

#import "E_Photo.h"

@interface PublishBigImageViewController ()

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *buttonImgArr;

@property (nonatomic, strong) UIScrollView *mainScroll;
@property int currentIndex;

@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView *rightIcon;

@property (nonatomic, strong) UITextView* textView;
//@property (nonatomic, strong) NSMutableArray* imageDescArray;

@property BOOL isHouseType;

@end

@implementation PublishBigImageViewController
@synthesize clickDelegate;
@synthesize imgArr;
@synthesize buttonImgArr;
@synthesize mainScroll;
@synthesize currentIndex;
@synthesize leftIcon, rightIcon;
@synthesize isHouseType;
@synthesize isEditProperty;
@synthesize isNewAddImg;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
    }
    return self;
}

- (void)dealloc {
    DLog(@"dealloc PublishBigImageViewController");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitleViewWithString:@"查看大图"];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(doBack:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(doDelete)];
    self.navigationItem.rightBarButtonItem = deleteItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initModel {
    self.imgArr = [NSMutableArray array];
    self.buttonImgArr = [NSMutableArray array];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"%d", self.currentIndex);
    [_imageDescArray insertObject:textView.text atIndex:self.currentIndex];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
//- (void)textViewDidChange:(UITextView *)textView;


#pragma mark -
#pragma mark 键盘监听事件
/* NSLog(@"%@", notification.userInfo);
 
 UIKeyboardAnimationCurveUserInfoKey = 7;
 UIKeyboardAnimationDurationUserInfoKey = "0.4";
 UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {320, 216}}";
 UIKeyboardCenterBeginUserInfoKey = "NSPoint: {160, 1028}";
 UIKeyboardCenterEndUserInfoKey = "NSPoint: {160, 460}";
 UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 920}, {320, 216}}";
 UIKeyboardFrameChangedByUserInteraction = 0;
 UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 352}, {320, 216}}";
 
 */

//键盘显示之前调用
- (void)keyboardWillShow:(NSNotification*)notification {
    //结构体包装成NSValue对象
    NSValue* value = [notification.userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"];
//    _keyboardHeight = [value CGRectValue].size.height; //键盘高度
//    self.editorBar.bottom = ScreenHeight - _keyboardHeight - 20 - 44; //减去状态栏和导航栏
//    self.textView.height = self.editorBar.top;
    
    //设置表情scrollView的位置,高度
    //    _scrollViewEmotion.top = self.editroBar.bottom;
    //    _scrollViewEmotion.height = height;
    
    //    NSLog(@"%f", self.editroBar.origin.y);
    //    CGRect rect = [self.editroBar convertRect:self.editroBar.bounds toView:self.view.window];
    //    NSLog(@"%f", rect.origin.y);
    
}

//#define FRAME_WITH_NAV CGRectMake(0, 0, [self windowWidth], [self windowHeight] - STATUS_BAR_H - NAV_BAT_H)

- (void)initDisplay {
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight])];
    sv.backgroundColor = SYSTEM_BLACK;
    sv.delegate = self;
    sv.pagingEnabled = YES;
    self.mainScroll = sv;
    sv.contentSize = CGSizeMake([self windowWidth], [self currentViewHeight]);
    [self.view addSubview:sv];
    
    if (self.hasTextView) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight], 320, [self currentViewHeight])];
        self.textView.delegate = self;
        [self.view addSubview:self.textView];
    }
    
    
}

- (NSInteger)currentViewHeight{
    if (self.hasTextView) {
        return (ScreenHeight-20-44)/2;
    }
    return ScreenHeight-20-44;
    
}

#pragma mark - Private Method

- (void)doDelete {
    if (self.isEditProperty) {
        if (self.isHouseType) {
            //通知删除在线户型图。。。并退出
            if ([self.clickDelegate respondsToSelector:@selector(onlineHouseTypeImgDelete)]) {
                [self.clickDelegate onlineHouseTypeImgDelete];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
        
        //通知房源编辑页面删除对应图片
        if ([self.clickDelegate respondsToSelector:@selector(editPropertyDidDeleteImgWithDeleteIndex:)]) {
            [self.clickDelegate editPropertyDidDeleteImgWithDeleteIndex:self.editDeleteImgIndex];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.isHouseType) {
        //通知删除在线户型图。。。并退出
        if ([self.clickDelegate respondsToSelector:@selector(onlineHouseTypeImgDelete)]) {
            [self.clickDelegate onlineHouseTypeImgDelete];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else { //非在线户型图查看，删除后重绘页面
        if (self.currentIndex == self.imgArr.count - 1) { //如果是最后一项删除，则将当前选择的index前移一位
            [self.imgArr removeLastObject];
            self.currentIndex --;
        }
        else
            [self.imgArr removeObjectAtIndex:self.currentIndex];
        
        if (self.imgArr.count <= 0) {
            [self doBack:self];
        }
        
        //redraw
        [self redrawImageScroll];
    }
}

- (void)doBack:(id)sender {
    if (self.isEditProperty) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.isHouseType) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    //设置...
    if ([self.clickDelegate respondsToSelector:@selector(viewDidFinishWithImageArr:)]) {
        [self.clickDelegate viewDidFinishWithImageArr:self.imgArr];
    }
    if ([self.clickDelegate respondsToSelector:@selector(viewDidFinishWithImageArr:sender:)])
    {
        [self.clickDelegate viewDidFinishWithImageArr:self.imgArr sender:self];
    }
    
    //do back
    [self dismissViewControllerAnimated:YES completion:nil];
}

//绘制图片
- (void)drawImageScroll {
    
    [self showLoadingActivity:YES];
    
    CGFloat buttonW = [self windowWidth];
    CGFloat buttonGap = ([self currentViewHeight] - buttonW) /2;
    
    if (self.isEditProperty) {
        //直接显示url图片
        PhotoButton *pb = [[PhotoButton alloc] initWithFrame:CGRectMake(0, buttonGap, buttonW, buttonW)];
        NSString *url = [self.imgArr objectAtIndex:0];
        if (self.isNewAddImg) { //新添加图片显示
            pb.photoImg.image = [UIImage imageWithContentsOfFile:url];
        }
        else //已有图片进行下载显示
            pb.photoImg.imageUrl = url;
        [self.buttonImgArr addObject:pb];
        [self.mainScroll addSubview:pb];
    }
    else {
        for (int i = 0; i < self.imgArr.count; i ++) {
            PhotoButton *pb = [[PhotoButton alloc] initWithFrame:CGRectMake(0 + buttonW*i, buttonGap, buttonW, buttonW)];
            pb.tag = i;
            NSString *url = nil;
            url =  [(E_Photo *)[self.imgArr objectAtIndex:i] smallPhotoUrl];
            pb.photoImg.image = [UIImage imageWithContentsOfFile:url];
            [self.buttonImgArr addObject:pb];
            [self.mainScroll addSubview:pb];
        }
    }
    
    self.mainScroll.contentSize = CGSizeMake([self windowWidth] * self.imgArr.count, [self currentViewHeight]);
    self.mainScroll.contentOffset = CGPointMake([self windowWidth] * self.currentIndex, 0);
    
    [self showArrowImg];
    
    [self hideLoadWithAnimated:YES];
}

- (void)redrawImageScroll {
    for (int i = 0; i < self.buttonImgArr.count; i ++) {
        [[self.buttonImgArr objectAtIndex:i] removeFromSuperview];
    }
    [self.buttonImgArr removeAllObjects];
    
    [self drawImageScroll];
}

- (void)showArrowImg {
    if (self.imgArr.count >1) {
        if (!self.leftIcon) {
            CGFloat imgGap = 3;
            CGFloat imgH = 26/2;
            CGFloat imgW = 17/2;
            
            UIImageView *leftImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_arrow_left.png"]];
            leftImg.backgroundColor = [UIColor clearColor];
            leftImg.frame = CGRectMake(imgGap, ([self currentViewHeight]- imgH)/2 -imgGap, imgW, imgH);
            self.leftIcon = leftImg;
            
            UIImageView *rightImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"details_arrow_right.png"]];
            rightImg.backgroundColor = [UIColor clearColor];
            rightImg.frame = CGRectMake([self windowWidth] - imgW- imgGap, ([self currentViewHeight]- imgH)/2 -imgGap, imgW, imgH);
            self.rightIcon = rightImg;
        }
        
        [self.view addSubview:self.leftIcon];
        [self.view addSubview:self.rightIcon];
    }
    else { //hide
        [self.leftIcon removeFromSuperview];
        [self.rightIcon removeFromSuperview];
    }
}

#pragma mark - Public Method
- (void)showImagesWithNewArray:(NSArray *)imageArr atIndex:(int)index{
    [self.imgArr addObjectsFromArray:imageArr];
    if (self.isEditProperty) {
        self.editDeleteImgIndex = index;
        self.currentIndex = 0;
    }
    else
        self.currentIndex = index;
    
    [self drawImageScroll];
}


- (void)showImagesWithArray:(NSArray *)imageArr atIndex:(int)index {
    [self.imgArr addObjectsFromArray:imageArr];
    if (self.isEditProperty) {
        self.editDeleteImgIndex = index;
        self.currentIndex = 0;
    }
    else
        self.currentIndex = index;
    
    //初始化数组
    _imageDescArray = [[NSMutableArray alloc] initWithCapacity:self.imgArr.count];
    for (int i = 0; i< self.imgArr.count; i++){
        E_Photo* photo = (E_Photo*)[self.imgArr objectAtIndex:i];
        if (photo.imageDic && [photo.imageDic objectForKey:@"imageDesc"]){
            [_imageDescArray insertObject:[photo.imageDic objectForKey:@"imageDesc"] atIndex:self.currentIndex];
        }else{
            [_imageDescArray insertObject:@"" atIndex:self.currentIndex];
        }
    }
    
    [self drawImageScroll];
    
}

//在线户型图单独显示
- (void)showImagesForOnlineHouseTypeWithDic:(NSDictionary *)dic {
    self.isHouseType = YES;
    
    [self showLoadingActivity:YES];
    
    CGFloat buttonW = [self windowWidth];
    CGFloat buttonGap = ([self currentViewHeight] - buttonW) /2;
    
    PhotoButton *pb = [[PhotoButton alloc] initWithFrame:CGRectMake(0, buttonGap, buttonW, buttonW)];
    pb.photoImg.imageUrl = [dic objectForKey:@"url"];
    [self.buttonImgArr addObject:pb];
    [self.mainScroll addSubview:pb];
    
    self.mainScroll.contentSize = CGSizeMake([self windowWidth], [self currentViewHeight]);
    self.mainScroll.contentOffset = CGPointMake(0, 0);
    
    [self hideLoadWithAnimated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / [self windowWidth];
    DLog(@"index [%d]", self.currentIndex);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        //
    }
}

@end
