//
//  AnjukeEditPropertyViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-10-21.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditPropertyViewController.h"
#import "PropertyDataManager.h"
#import "InputOrderManager.h"
#import "PhotoButton.h"
#import "AnjukeEditableTV_DataSource.h"
#import "Util_UI.h"
#import "PropertyGroupListViewController.h"
#import "PropertyBigImageViewController.h"
#import "BrokerLineView.h"

#define photoHeaderH 100
#define photoHeaderH_RecNum 100 +50
#define Input_H 260

#define IMAGE_MAXSIZE_WIDTH 1280 //上传图片的最大分辨率

#define LimitRow_INPUT 1 //从row=1行开始输入，即最小输入行数(第一行为小区无需输入，从户型行开始输入)
#define TagOfImg_Base 1000
#define TagOfActionSheet_Img 901
#define TagOfActionSheet_Save 902

#define PhotoImg_H 80
#define PhotoImg_Gap 10
#define PhotoImg_MAX_COUNT 8 //最多上传照片数

@interface AnjukeEditPropertyViewController ()
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) UITableView *tvList;
@property BOOL needRecordNum; //是否需要备案号，部分城市需要备案号（北京）
@property (nonatomic, strong) RTInputPickerView *pickerView; //定制的输入框
@property (nonatomic, strong) KeyboardToolBar *toolBar;
@property (nonatomic, strong) UITextField *inputingTextF; //正在输入的textField，用于指向后关闭键盘
@property int selectedRow; //记录当前点选的row

@property BOOL isTakePhoto; //是否拍照，区别拍照和从相册取图
@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, strong) UIScrollView *photoSV;
@property (nonatomic, strong) NSMutableArray *imgBtnArray;
@property int imageSelectIndex; //记录选择的第几个image

@property (nonatomic, strong) AnjukeEditableTV_DataSource *dataSource;

@end

@implementation AnjukeEditPropertyViewController
@synthesize titleArray, tvList;
@synthesize needRecordNum;
@synthesize pickerView, toolBar, inputingTextF;
@synthesize selectedRow;
@synthesize isTakePhoto;
@synthesize imgArray;
@synthesize photoSV, imgBtnArray;
@synthesize dataSource;
@synthesize imageSelectIndex;

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
        
    [self setTitleViewWithString:@"房源信息"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self pickerDisappear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (self.pickerView) {
        self.pickerView.brokerPickerDelegate = nil;
    }
    if (self.tvList) {
        self.tvList.delegate = nil;
    }
}

#pragma mark - init Method

- (void)initModel {
    self.titleArray = [NSArray arrayWithArray:[PropertyDataManager getPropertyTitleArrayForAnjuke:YES]];
    self.imgArray = [NSMutableArray array];
    self.imgBtnArray = [NSMutableArray array];
    
}

- (void)initDisplay {
    //save btn
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = ITEM_BTN_FRAME;
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(doSave) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rButton = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rButton;
    
    //draw tableView list
    self.dataSource = [[AnjukeEditableTV_DataSource alloc] init];
    self.dataSource.superViewController = self;
    [self.dataSource createCells:self.titleArray];
    
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self.dataSource;
    [self.view addSubview:tv];
    
    //draw tableView header
    [self drawHeader];
}

- (void)drawHeader {
    //根据是否需要备案号调整高度
    UIView *headerView = [[UIView alloc] init];
    if (self.needRecordNum) {
        headerView.frame = CGRectMake(0, 0, [self windowWidth], photoHeaderH_RecNum);
    }
    else
        headerView.frame = CGRectMake(0, 0, [self windowWidth], photoHeaderH);
    headerView.backgroundColor = [UIColor clearColor];
    
    // photo sv
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:headerView.bounds];
    self.photoSV = sv;
    sv.backgroundColor = [UIColor clearColor];
    sv.contentSize = CGSizeMake(headerView.frame.size.width, headerView.frame.size.height);
    [headerView addSubview:sv];
    
    //phtot btn
    int pBtnH = 80;
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(([self windowWidth] -pBtnH)/2, (sv.frame.size.height - pBtnH)/2, pBtnH, pBtnH);
    photoBtn.backgroundColor = [UIColor clearColor];
    photoBtn.layer.borderColor = [UIColor blackColor].CGColor;
    photoBtn.layer.borderWidth = 0.5;
    [photoBtn setTitle:@"+" forState:UIControlStateNormal];
    [photoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [sv addSubview:photoBtn];
    
    photoBtn.frame = CGRectMake( PhotoImg_Gap , PhotoImg_Gap, PhotoImg_H, PhotoImg_H);
    
    for (int i = 0; i< PhotoImg_MAX_COUNT; i ++) {
        PhotoButton *pBtn = [[PhotoButton alloc] initWithFrame:CGRectMake(PhotoImg_Gap +(i +1) * (PhotoImg_Gap + PhotoImg_H), PhotoImg_Gap, PhotoImg_H, PhotoImg_H)];
        pBtn.tag = TagOfImg_Base + i;
        [pBtn addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
        pBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        pBtn.layer.borderWidth = 0.5;
        [self.photoSV addSubview:pBtn];
        [self.imgBtnArray addObject:pBtn];
    }
    
    self.photoSV.contentSize = CGSizeMake(PhotoImg_Gap +(PhotoImg_Gap+ PhotoImg_H) * (PhotoImg_MAX_COUNT +1), headerView.frame.size.height);
    
    //备案号
    if (self.needRecordNum) {
        //
    }
    
    self.tvList.tableHeaderView = headerView;
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(15, headerView.frame.size.height -1, [self windowWidth]-15, 1)];
    [headerView addSubview:line];

}

#pragma mark - Private Method

//**根据当前输入焦点行移动tableView显示
- (void)tableVIewMoveWithIndex:(NSInteger)index {
    [self.tvList setFrame:CGRectMake(0, 0, [self windowWidth], [self currentViewHeight] - self.pickerView.frame.size.height - self.toolBar.frame.size.height)];
    
    [self.tvList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO]; //animated
}

- (NSMutableString *)getInputString {
    NSMutableString *string = [NSMutableString string];
    
    int index1 = [self.pickerView selectedRowInComponent:0];
    NSString *string1 = [[self.pickerView firstArray] objectAtIndex:index1];
    [string appendString:string1];
    
    if ([self.pickerView.secondArray count] > 0) {
        int index2 = [self.pickerView selectedRowInComponent:1];
        NSString *string2 = [[self.pickerView secondArray] objectAtIndex:index2];
        [string appendString:string2];
    }
    
    if ([self.pickerView.thirdArray count] > 0) {
        int index3 = [self.pickerView selectedRowInComponent:2];
        NSString *string3 = [[self.pickerView thirdArray] objectAtIndex:index3];
        [string appendString:string3];
    }
    
    DLog(@"string-[%@]", string);
    
    return string;
}

- (void)pickerDisappear {
    [self textFieldAllResign];
    
    [self.tvList setFrame:FRAME_WITH_NAV];
    [self.tvList setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - Broker Picker Delegate

- (void)finishBtnClicked { //点击完成，输入框组件消失
    if (![self isKeyboardShowWithRow:self.selectedRow]) {
        self.inputingTextF.text = [self getInputString]; //当前输入框为滚轮输入，则切换前输入
    }
    
    [self pickerDisappear];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    if (![self isKeyboardShowWithRow:self.selectedRow]) {
        self.inputingTextF.text = [self getInputString]; //当前输入框为滚轮输入，则切换前输入
    }
    
    self.selectedRow --; //当前输入行数-1
    if (self.selectedRow < LimitRow_INPUT) {
        self.selectedRow = LimitRow_INPUT;
        return;
    }
    
    DLog(@"index-[%d]", self.selectedRow);
    
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self tableVIewMoveWithIndex:self.selectedRow];
    
//    UITextField *tf = [(AnjukeEditableCell *)[self.dataSource.cellArray objectAtIndex:self.selectedRow] text_Field];
//    self.inputingTextF = tf;
    [self getTextFieldWithIndex:self.selectedRow];
    [self textFieldShowWithIndex:self.selectedRow];
    
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    //得到前一条的输入数据，并显示下一条的输入框
    if (![self isKeyboardShowWithRow:self.selectedRow]) {
        self.inputingTextF.text = [self getInputString]; //当前输入框为滚轮输入，则切换前输入
    }
    
    self.selectedRow ++; //当前输入行数+1
    if (self.selectedRow > self.titleArray.count -1) {
        DLog(@"max row -%d", self.selectedRow);
        self.selectedRow = self.titleArray.count -1;
        return;
    }
    
    DLog(@"index-[%d]", self.selectedRow);
    
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self tableVIewMoveWithIndex:self.selectedRow];
    
    [self getTextFieldWithIndex:self.selectedRow];
    [self textFieldShowWithIndex:self.selectedRow];
    
}

#pragma mark - Image Picker Button Method

- (void)doSave {
    //for test
//    [self.navigationController popViewControllerAnimated:YES];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"定价推广", @"定价且竞价推广", @"暂不推广", nil];
    sheet.tag = TagOfActionSheet_Save;
    [sheet showInView:self.view];
}

- (void)addPhoto {
    DLog(@"add photo");
    
    if (self.imgArray.count > PhotoImg_MAX_COUNT) {
        DLog(@"最多上传8张照片");
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", @"选择在线房形图", nil];
    sheet.tag = TagOfActionSheet_Img;
    [sheet showInView:self.view];
}

- (void)showPhoto:(id)sender {
    PhotoButton *pBtn = (PhotoButton *)sender;
    
    int photoIndex = pBtn.tag - TagOfImg_Base;
    
    self.imageSelectIndex = photoIndex;
    if (pBtn.photoImg.image == nil) {
        return;
    }
    
    DLog(@"photo Index [%d]", photoIndex);
    
    //模态弹出图片播放器
    PropertyBigImageViewController *pb = [[PropertyBigImageViewController alloc] init];
    pb.btnDelegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pb];
    navController.navigationBar.translucent = NO;
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self.navigationController presentViewController:navController animated:YES completion:^(void) {
        pb.contentImgView.image = pBtn.photoImg.image;
    }];
}

#pragma mark - BigImageView Delegate
- (void)deletebtnClick {
    [self.imgArray removeObjectAtIndex:self.imageSelectIndex];
    
    for (PhotoButton *btn in self.imgBtnArray) {
        btn.photoImg.image = nil;
    }
    DLog(@"img count [%d]", self.imgArray.count);
    //redraw header img scroll
    for (int i = 0; i < self.imgArray.count; i ++) {
        PhotoButton *imgBtn = (PhotoButton *)[self.imgBtnArray objectAtIndex:i];
        [imgBtn.photoImg setImage:[self.imgArray objectAtIndex:i]];
    }
}

#pragma mark - tableView Delegate & Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //小区 push
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    self.selectedRow = indexPath.row;
    
    [self getTextFieldWithIndex:self.selectedRow];
    [self textFieldShowWithIndex:self.selectedRow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - EDIT_CELL Delegate

- (void)textFieldBeginEdit:(UITextField *)textField {
    [self getTextFieldIndexWithTF:textField];
    [self textFieldShowWithIndex:self.selectedRow];
}

#pragma mark - TextField Method

- (BOOL)isKeyboardShowWithRow:(NSInteger)row {
    if (row == 2 || row == 3 || row == 7 || row == 8) {
        return YES; //弹出键盘
    }
    
    return NO; //弹出滚轮
}

- (void)getTextFieldIndexWithTF:(UITextField *)tf {
    self.inputingTextF = tf;
    
    AnjukeEditableCell *cell = (AnjukeEditableCell *)[[[tf superview] superview] superview];
    self.selectedRow = [[self.tvList indexPathForCell:cell] row];
    DLog(@"index - [%d]", self.selectedRow);
}

- (void)getTextFieldWithIndex:(int)index {
    UITextField *tf = [(AnjukeEditableCell *)[self.dataSource.cellArray objectAtIndex:self.selectedRow] text_Field];
    self.inputingTextF = tf;
}

- (void)textFieldShowWithIndex:(int)index {
    if (!self.pickerView) {
        self.pickerView = [[RTInputPickerView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - RT_PICKERVIEW_H - 0, [self windowWidth], RT_PICKERVIEW_H)];
    }
    
    if ((!self.toolBar)) {
        self.toolBar = [[KeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], NAV_BAT_H)];
        self.toolBar.clickDelagate = self;
    }
    
    if ([self isKeyboardShowWithRow:self.selectedRow]) {
        //弹出键盘
        self.inputingTextF.inputAccessoryView = self.toolBar;
        self.inputingTextF.inputView = nil;
    }
    else {
        //弹出滚轮
        self.inputingTextF.inputAccessoryView = self.toolBar;
        self.inputingTextF.inputView = self.pickerView;
        
        //重置pickerView数据
        [self.pickerView reloadPickerWithRow:self.selectedRow];
        
        //根据输入数据滑动到当前row
        if (![self.inputingTextF.text isEqualToString:@""]) {
            //
        }
    }
    
    [self tableVIewMoveWithIndex:self.selectedRow];
    
    [self.inputingTextF becomeFirstResponder];
}

- (void)textFieldAllResign { //全部收起键盘
    [self.inputingTextF resignFirstResponder];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"actionSheet tag [%d]", actionSheet.tag);
    
    if (actionSheet.tag == TagOfActionSheet_Img) {
        switch (buttonIndex) {
            case 0: //拍照
            {
                self.isTakePhoto = YES;
                
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
                ipc.delegate = self;
                ipc.allowsEditing = NO;
                [self presentViewController:ipc animated:YES completion:nil];
            }
                break;
            case 1: //手机相册
            {
                self.isTakePhoto = NO;
                
                UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
                ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //拍照
                ipc.delegate = self;
                ipc.allowsEditing = NO;
                [self presentViewController:ipc animated:YES completion:nil];
            }
                break;
            case 2: //在线房形图
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    else if (actionSheet.tag == TagOfActionSheet_Save) {
        switch (buttonIndex) {
            case 0: //定价
            {
                PropertyGroupListViewController *pv = [[PropertyGroupListViewController alloc] init];
                [self.navigationController pushViewController:pv animated:YES];
            }
                break;
            case 1: //定价+竞价
            {
                PropertyGroupListViewController *pv = [[PropertyGroupListViewController alloc] init];
                pv.isBid = YES;
                [self.navigationController pushViewController:pv animated:YES];
            }
                break;
            case 2: //暂不推广
            {
                
            }
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark - Photo ScrollView method

//得到需要在第几个预览图显示
- (int)getPhotoImgShowIndex {
    if (self.imgArray.count == 0) {
        return 0;
    }
    
    int index = self.imgArray.count;
    return index;
}

- (PhotoButton *)getPhotoIMG_VIEW {
    PhotoButton *pBtn = [self.imgBtnArray objectAtIndex:[self getPhotoImgShowIndex]];
    return pBtn;
}

#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = nil;
    UIImage *newSizeImage = nil;
    
    for (NSString *str  in [info allKeys]) {
        DLog(@"pickerInfo Keys %@",str);
    }
    
    if (self.isTakePhoto) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //        pickerImg.image = [UtilText unrotateImage:pickerImg.image]; //调整照片方向
    }
    else {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    if (self.imgArray.count >= PhotoImg_MAX_COUNT) {
        return;
    }
    PhotoButton *pBtn = [self getPhotoIMG_VIEW];
    
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
        
        pBtn.photoImg.image = newSizeImage;
    }
    else {
        pBtn.photoImg.image = image;
    }
    
    [self.imgArray addObject:pBtn.photoImg.image];
    DLog(@"editedSize [%f,%f]",pBtn.photoImg.image.size.width, pBtn.photoImg.image.size.height);
    
    
    //写入相册
    if (self.isTakePhoto) {
        UIImageWriteToSavedPhotosAlbum(pBtn.photoImg.image, self, @selector(errorCheck:didFinishSavingWithError:contextInfo:), nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^(void){
        //
    }];
}

- (void)errorCheck:(NSString *)imgPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	
	if(error) {
        DLog(@"fail...");
    }
	else
	{
        DLog(@"success");
	}
}

@end
