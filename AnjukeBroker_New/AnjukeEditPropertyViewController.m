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

#define cellHeight 50

#define photoHeaderH 100
#define photoHeaderH_RecNum 100 +cellHeight
#define Input_H 260

#define LimitRow_INPUT 1 //从row=1行开始输入，即最小输入行数(第一行为小区无需输入，从户型行开始输入)
#define TagOfImg_Base 1000
#define TagOfTextField_Base 2000 //用于区分各输入框

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

@end

@implementation AnjukeEditPropertyViewController
@synthesize titleArray, tvList;
@synthesize needRecordNum;
@synthesize pickerView, toolBar, inputingTextF;
@synthesize selectedRow;
@synthesize isTakePhoto;
@synthesize imgArray;
@synthesize photoSV, imgBtnArray;


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
    UITableView *tv = [[UITableView alloc] initWithFrame:FRAME_WITH_NAV style:UITableViewStylePlain];
    self.tvList = tv;
    tv.backgroundColor = [UIColor clearColor];
    tv.delegate = self;
    tv.dataSource = self;
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

#pragma mark - Input Method

//根据输入焦点行更改输入组件样式、数据
- (void)checkInputTypeWithIndex:(int)index {
    //移动tableView并修改高亮cell
    [self tableVIewMoveWithIndex:index];
    
//    if ([InputOrderManager isKeyBoardInputWithIndex:index]) { //键盘输入，隐藏滚轮
//        [self.pickerView pickerHide:[InputOrderManager isKeyBoardInputWithIndex:index]];
//        
//        switch (index) {
//            case 2: //产证面积
//                [self.areaTextF becomeFirstResponder];
//                break;
//            case 3: //价格
//                [self.priceTextF becomeFirstResponder];
//                break;
//            case 7: //标题
//                [self.titleTextF becomeFirstResponder];
//                break;
//            case 8: //描述
//                [self.contentTextF becomeFirstResponder];
//                break;
//            
//            default:
//                break;
//        }
//    }
//    else { //滚轮输入，收起键盘
//        [self.pickerView pickerHide:[InputOrderManager isKeyBoardInputWithIndex:index]];
//        
//        [self textFieldAllResign];
//        [self.pickerView reloadPickerWithRow:self.selectedRow];
//    }
}

//**根据当前输入焦点行移动tableView显示
- (void)tableVIewMoveWithIndex:(NSInteger)index {
    //    [self.tvList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tvList setContentOffset:CGPointMake(0, cellHeight* index*0.85) animated:YES];
}

- (void)doInput {
    
}

#pragma mark - Broker Picker Delegate

- (void)finishBtnClicked { //点击完成，输入框组件消失
    [self pickerDisappear];
}

- (void)preBtnClicked { //点击”上一个“，检查输入样式并做转换，tableView下移
    self.selectedRow --; //当前输入行数-1
    if (self.selectedRow < LimitRow_INPUT) {
        self.selectedRow = LimitRow_INPUT;
        return;
    }
    
    DLog(@"index-[%d]", self.selectedRow);
    
    //前一个输入框
    UITextField *tf = (UITextField *)[self.view viewWithTag:TagOfTextField_Base + self.selectedRow];
    [tf becomeFirstResponder];
    
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self tableVIewMoveWithIndex:self.selectedRow];
    
}

- (void)nextBtnClicked { //点击”下一个“，检查输入样式并做转换，tableView上移
    self.selectedRow ++; //当前输入行数+1
    if (self.selectedRow > self.titleArray.count -1) {
        DLog(@"max row -%d", self.selectedRow);
        self.selectedRow = self.titleArray.count -1;
        return;
    }
    
    DLog(@"index-[%d]", self.selectedRow);
    
    //前一个输入框
    UITextField *tf = (UITextField *)[self.view viewWithTag:TagOfTextField_Base + self.selectedRow];
    [tf becomeFirstResponder];
    
    //修改输入组件数据/修改输入框焦点 //tableView移动
    [self tableVIewMoveWithIndex:self.selectedRow];
}

#pragma mark - Image Picker Button Method

- (void)pickerDisappear {
//    [UIView animateWithDuration: 0.02
//                          delay: 0.0
//                        options: UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         self.pickerView.alpha = 0.1 ;
//                     }
//                     completion:^(BOOL finished){
//                         if (finished) {
//                             //
//                             [self.pickerView removeFromSuperview];
//                             self.pickerView.alpha = 1;
////                             self.pickerView = nil;
//                         }
//                     }];
    
    [self.pickerView removeFromSuperview];
    [self textFieldAllResign];
    
    [self.tvList deselectRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedRow inSection:0] animated:YES];
    [self.tvList setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)doSave {
    //for test
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPhoto {
    DLog(@"add photo");
    
    if (self.imgArray.count > PhotoImg_MAX_COUNT) {
        DLog(@"最多上传8张照片");
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", @"选择在线房形图", nil];
    [sheet showInView:self.view];
}

- (void)showPhoto:(id)sender {
    PhotoButton *pBtn = (PhotoButton *)sender;
    
    int photoIndex = pBtn.tag - TagOfImg_Base;
    DLog(@"photo Index [%d]", photoIndex);
}

#pragma mark - tableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITextField *cellTextField = nil;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(150, 1,  150, cellHeight - 1*2)];
        cellTextField.returnKeyType = UIReturnKeyDone;
        cellTextField.backgroundColor = [UIColor clearColor];
        cellTextField.borderStyle = UITextBorderStyleNone;
        cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        cellTextField.delegate = self;
        cellTextField.text = @"";
        cellTextField.tag = TagOfTextField_Base;
        cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        cellTextField.placeholder = @"";
		cellTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		cellTextField.font = [UIFont systemFontOfSize:17];
        cellTextField.secureTextEntry = NO;
        [cell.contentView addSubview:cellTextField];
        
    }
    else {
        cellTextField = (UITextField *)[cell.contentView viewWithTag:TagOfTextField_Base];
    }
    
    if (indexPath.row == 0) {
        [cellTextField removeFromSuperview];
    }
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        cellTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (indexPath.row == 7 || indexPath.row == 8) {
        cellTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
    cellTextField.tag = TagOfTextField_Base + indexPath.row;
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0) { //小区
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - tableView Delegate & Method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //小区 push
        
        return;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self pickerDisappear];
}

#pragma mark - TextField Delegate & Method

- (BOOL)isKeyboardShowWithRow:(NSInteger)row {
    if (row == 2 || row == 3 || row == 7 || row == 8) {
        return YES; //弹出键盘
    }
    
    return NO; //弹出滚轮
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.inputingTextF = textField;
    
    self.selectedRow = textField.tag - TagOfTextField_Base;
    DLog(@"index - [%d]", self.selectedRow);
    
    if (!self.pickerView) {
        self.pickerView = [[RTInputPickerView alloc] initWithFrame:CGRectMake(0, [self currentViewHeight] - RT_PICKERVIEW_H - 0, [self windowWidth], RT_PICKERVIEW_H)];
    }
    
    if ((!self.toolBar)) {
        self.toolBar = [[KeyboardToolBar alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], NAV_BAT_H)];
        self.toolBar.clickDelagate = self;
    }
    
    if ([self isKeyboardShowWithRow:self.selectedRow]) {
        //弹出键盘
        textField.inputAccessoryView = self.toolBar;
        textField.inputView = nil;
    }
    else {
        //弹出滚轮
        textField.inputAccessoryView = self.toolBar;
        textField.inputView = self.pickerView;
        
        [self.pickerView reloadPickerWithRow:self.selectedRow];
    }
    
    [self tableVIewMoveWithIndex:self.selectedRow];
}

- (void)textFieldAllResign { //全部收起键盘
    [self.inputingTextF resignFirstResponder];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

#pragma mark - Photo ScrollView method

- (void)setPhotoSVContentSize {
    
}

- (PhotoButton *)getPhotoIMG_VIEW {
    PhotoButton *pBtn = [self.imgBtnArray objectAtIndex:self.imgArray.count -1];
    return pBtn;
}

#pragma mark - UIImagePickerControllerDelegate method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = nil;
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
    [self.imgArray addObject:image];
    
    PhotoButton *pBtn = [self getPhotoIMG_VIEW];
    pBtn.photoImg.image = image;
    
//    //压缩图片
//    if (pickerImg.image.size.width >960 || pickerImg.image.size.height > 960 || self.isTakePhoto) {
//        CGSize coreSize;
//        if (pickerImg.image.size.width > pickerImg.image.size.height) {
//            coreSize = CGSizeMake(960, 960*(pickerImg.image.size.height /pickerImg.image.size.width));
//        }
//        else if (pickerImg.image.size.width < pickerImg.image.size.height){
//            coreSize = CGSizeMake(960*(pickerImg.image.size.width /pickerImg.image.size.height), 960);
//        }
//        else {
//            coreSize = CGSizeMake(960, 960);
//        }
//        
//        UIGraphicsBeginImageContext(coreSize);
//        [pickerImg.image drawInRect:[UtilText frameSize:pickerImg.image.size inSize:coreSize]];
//        UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        pickerImg.image = newimg;
//    }
    
    DLog(@"editedSize [%f,%f]",pBtn.photoImg.image.size.width, pBtn.photoImg.image.size.height);
    
    
    //写入相册
    if (self.isTakePhoto) {
        UIImageWriteToSavedPhotosAlbum(pBtn.imageView.image, self, @selector(errorCheck:didFinishSavingWithError:contextInfo:), nil);
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
