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
#import "UIViewExt.h"
#import "E_Photo.h"
#import "RTGestureLock.h"

@interface PublishBigImageViewController ()

@property (nonatomic, strong) NSMutableArray *imgArr;
@property (nonatomic, strong) NSMutableArray *buttonImgArr;

@property (nonatomic, strong) UIScrollView *mainScroll;
@property int currentIndex;

@property (nonatomic, strong) UIImageView *leftIcon;
@property (nonatomic, strong) UIImageView *rightIcon;

@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIView* mainView;
@property (nonatomic, strong) UILabel* numberOfText;
@property (nonatomic, strong) NSString* placeHolder;
@property (nonatomic, strong) UIImageView* pencil;
//@property (nonatomic, strong) NSMutableArray* imageDescArray;

@property BOOL isHouseType;

@end

@implementation PublishBigImageViewController
@synthesize clickDelegate;
@synthesize imgArr;
@synthesize buttonImgArr;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
        
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
    
    [self addRightButton:@"删除" andPossibleTitle:nil];
    
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

//#define FRAME_WITH_NAV CGRectMake(0, 0, [self windowWidth], [self windowHeight] - STATUS_BAR_H - NAV_BAT_H)

- (void)initDisplay {
    _mainScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight])];
    _mainScroll.backgroundColor = SYSTEM_BLACK;
    _mainScroll.delegate = self;
    _mainScroll.pagingEnabled = YES;
    _mainScroll.contentSize = CGSizeMake([self windowWidth], [self currentViewHeight]);
    
    if (self.hasTextView) {
        self.placeHolder = @"    描述这张图片, 如装修, 采光等...";
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, [self currentViewHeight]+6, 290, 80)];
        _pencil = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anjuke_icon_write_discription"]];
        _pencil.frame = CGRectMake(0, 10, 16, 16);
        [_textView addSubview:_pencil];
        _textView.text = self.placeHolder;
        [_textView setTextColor:[UIColor brokerLightGrayColor]];
        [_textView setFont:[UIFont ajkH2Font]];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
    }
    
    if (self.hasTextView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.mainScroll.height + self.textView.height)];
        [_mainView addSubview:_mainScroll];
        [_mainView addSubview:_textView];
        
        _numberOfText = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-30, _textView.bottom, 30, 20)];
        _numberOfText.font = [UIFont systemFontOfSize:12.0f];
        [_numberOfText setTextColor:[Util_UI colorWithHexString:@"#B2B2B2"]];
        _numberOfText.text = @"20";
        _numberOfText.hidden = YES;
        [_mainView addSubview:_numberOfText];
        
//        _mainView.backgroundColor = [UIColor redColor];
        
    }else{
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.mainScroll.height)];
        [_mainView addSubview:_mainScroll];
    }
    
    [self.view addSubview:_mainView];
    
}

- (NSInteger)currentViewHeight{
    if (self.hasTextView) {
        return 240;
    }
    return ScreenHeight-20-44;
    
}

#pragma mark - Private Method

- (void)rightButtonAction:(id)sender {
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
        if ([self.clickDelegate respondsToSelector:@selector(editPropertyDidDeleteImgWithDeleteIndex:sender:)]) {
            [self.clickDelegate editPropertyDidDeleteImgWithDeleteIndex:self.editDeleteImgIndex sender:self];
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
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [pb addGestureRecognizer:tap];
        NSString *url = [self.imgArr objectAtIndex:0];
        if (self.isNewAddImg) { //新添加图片显示
            pb.photoImg.image = [UIImage imageWithContentsOfFile:url];
        }
        else //已有图片进行下载显示
            pb.photoImg.imageUrl = url;
        pb.photoImg.contentMode = UIViewContentModeScaleAspectFit;
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
            pb.photoImg.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [pb addGestureRecognizer:tap];
            [self.buttonImgArr addObject:pb];
            [self.mainScroll addSubview:pb];
        }
    }
    
    self.mainScroll.contentSize = CGSizeMake([self windowWidth] * self.imgArr.count, [self currentViewHeight]);
    self.mainScroll.contentOffset = CGPointMake([self windowWidth] * self.currentIndex, 0);
    
//    [self showArrowImg];
    

    if (self.hasTextView && _imageDescArray) {
        NSString* content = [_imageDescArray objectAtIndex:self.currentIndex];
        if (content.length > 0 && ![content isEqualToString:self.placeHolder]) {
            _textView.text = [_imageDescArray objectAtIndex:self.currentIndex];
            _pencil.hidden = YES;
            _textView.textColor = SYSTEM_BLACK;
        }else{
            _pencil.hidden = NO;
            _textView.text = _placeHolder;
            [_textView setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
        }
    }
    
//    NSLog(@"%f", self.mainView.bottom);
    
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
        
        [_mainView addSubview:self.leftIcon];
        [_mainView addSubview:self.rightIcon];
    }
    else { //hide
        [self.leftIcon removeFromSuperview];
        [self.rightIcon removeFromSuperview];
    }
}

#pragma mark - Public Method

- (void)showImagesWithArray:(NSArray *)imageArr atIndex:(int)index {
    [self.imgArr addObjectsFromArray:imageArr];
    if (self.isEditProperty) {
        self.editDeleteImgIndex = index;
        self.currentIndex = 0;
    }
    else
        self.currentIndex = index;
    
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
    CGFloat keyboardHeight = [value CGRectValue].size.height; //键盘高度
//    _textView.height = 20;
//    CGAffineTransform transform = this.mainView.transform;
//    view.transform = CGAffineTransformScale(transform, 0.7, 0.7);
//    view.alpha = 0;
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        view.transform = CGAffineTransformScale(transform, 1.3, 1.3);
//        view.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3 animations:^{
//            view.transform = CGAffineTransformIdentity;
//        }];
//    }];
    _numberOfText.hidden = NO;
    __block PublishBigImageViewController* this = self;
//    CGAffineTransform transform = this.mainView.transform;
    
    [UIView animateWithDuration:0.3 animations:^{
        this.mainView.bottom = ScreenHeight - keyboardHeight - 20 - 44 - 40;
//        CGFloat bottom = ScreenHeight - 20 - 44 - 35 - this.mainView.height;
//        CGFloat gap = keyboardHeight - bottom;
//        this.mainView.transform = CGAffineTransformTranslate(transform, 0, -gap);
    }];
    
}

- (void)keyboardDidHide:(NSNotification*)notification {
    //结构体包装成NSValue对象
//    _textView.height = 252;
    _numberOfText.hidden = YES;
    if (_imageDescArray) {
        NSString* content = [_imageDescArray objectAtIndex:self.currentIndex];
        if (content.length > 0 && ![content isEqualToString:self.placeHolder]) {
            _textView.text = [_imageDescArray objectAtIndex:self.currentIndex];
        }else{
            _pencil.hidden = NO;
            _textView.text = _placeHolder;
            [_textView setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
        }
        
    }
    __block PublishBigImageViewController* this = self;
    [UIView animateWithDuration:0.3 animations:^{
        this.mainView.bottom = 240 + 80;
//        this.mainView.bottom = ScreenHeight - 20 - 44 - 175;
//        this.mainView.top = 20 + 44;
//        this.mainView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
//    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, [self currentViewHeight]+15, 290, 80)];
    _mainScroll.scrollEnabled = NO;
    if ([_textView.text isEqualToString:self.placeHolder]) {
        _pencil.hidden = YES;
        _textView.text = @"";
        _textView.textColor = SYSTEM_BLACK;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
//    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, [self currentViewHeight]+15, 290, [self currentViewHeight])];
    _mainScroll.scrollEnabled = YES;
    NSLog(@"%d", self.currentIndex);
    if (_imageDescArray) {
        if (_textView.text.length > 0 && ![_textView.text isEqualToString:self.placeHolder]) {
            [_imageDescArray insertObject:self.textView.text atIndex:self.currentIndex];
        }
    }else{
        NSLog(@"赋值数组为空");
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString* temp = [_textView.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _textView.text = temp;
    if (_textView.markedTextRange == nil && _textView.text.length > 20) {
        _textView.text = [_textView.text substringToIndex:20];
    }else{
        NSInteger length = 20 - _textView.text.length;
        if (length < 0) {
            length = 0;
        }
        _numberOfText.text = [NSString stringWithFormat:@"%d", length];
        if (length == 0) {
            _numberOfText.textColor = (__bridge UIColor *)([UIColor brokerRedColor].CGColor);
        }
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / [self windowWidth];
    DLog(@"index [%d]", self.currentIndex);
    
    if (self.hasTextView) {
        if (_imageDescArray) {
            NSString* content = [_imageDescArray objectAtIndex:self.currentIndex];
            if (content.length > 0 && ![content isEqualToString:self.placeHolder]) {
                _textView.text = [_imageDescArray objectAtIndex:self.currentIndex];
                _pencil.hidden = YES;
                _textView.textColor = SYSTEM_BLACK;
            }else{
                _pencil.hidden = NO;
                _textView.text = _placeHolder;
                [_textView setTextColor:[UIColor colorWithWhite:0.6 alpha:1]];
            }
            
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        //
    }
}

#pragma mark -
#pragma mark TapAction
- (void)tap:(UITapGestureRecognizer*)gesture{
    [_textView resignFirstResponder];
}



@end
