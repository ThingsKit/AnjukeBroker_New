//
//  AnjukeEditTextViewController.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-12-2.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "AnjukeEditTextViewController.h"
#import "Util_UI.h"
#import "Util_TEXT.h"

#define VOICEBACKVIEWHEIGHT 100
#define BUTWHID 80

@interface AnjukeEditTextViewController ()
{
    UIButton *voiceBtn;
    UIButton *cancelBut;
    UIButton *stopBut;
    float offset;
    float moveoffset;
}
@property (nonatomic, strong) UITextView *textV;
@end

@implementation AnjukeEditTextViewController
@synthesize textString;
@synthesize textFieldModifyDelegate;
@synthesize textV;
@synthesize isTitle;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

	// Do any additional setup after loading the view.
    
    [self addRightButton:@"完成" andPossibleTitle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self.textV becomeFirstResponder];
}

#pragma mark - private method
- (void)initModel {
    
}

- (void)initDisplay {

}

- (void)rightButtonAction:(id)sender {
    if (self.isTitle) {
        if (self.textV.text.length > 30 || self.textV.text.length < 5) {
            [self showInfo:@"房源标题必须5到30个字符"];
            return;
        }
    }
    else {
        if (self.textV.text.length < 10) {
            [self showInfo:@"房源描述必须至少10个字符"];
            return;
        }
    }
    
    if ([self.textFieldModifyDelegate respondsToSelector:@selector(textDidInput:isTitle:)]) {
        [self.textFieldModifyDelegate textDidInput:self.textV.text isTitle:self.isTitle];
    }
    [self.textV resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTextFieldDetail:(NSString *)string {
    CGFloat TextViewH = 260;
    if ([self windowHeight] <= 960/2) {
        TextViewH = 180;
    }
    
    UITextView *cellTextField = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, [self windowWidth] - 40, [self windowHeight] - VOICEBACKVIEWHEIGHT - 64)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cellTextField.text = @"";
    cellTextField.delegate = self;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = SYSTEM_BLACK;
    cellTextField.layer.borderWidth = 1;
    cellTextField.layer.borderColor = [[Util_UI colorWithHexString:@"CCCCCC"] CGColor];
    cellTextField.layer.cornerRadius = 6;
    self.textV = cellTextField;
    [self.view addSubview:cellTextField];
    
    if (self.textV) {
        self.textV.text = string;
    }
    
//    UIView *voiceBack = [[UIView alloc] initWithFrame:CGRectMake(0, [self windowHeight] - VOICEBACKVIEWHEIGHT - 64 + 15, [self windowWidth], VOICEBACKVIEWHEIGHT)];
//    [voiceBack setBackgroundColor:[UIColor lightGrayColor]];
    
    voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    float whidth = 106/2;
    float height = 106/2;
    
    voiceBtn.frame = CGRectMake(160 - whidth/2, self.textV.frame.size.height + self.textV.frame.origin.y +15, whidth, height);
    [voiceBtn setImage:[UIImage imageNamed:@"anjuke_icon_sound@2x.png"] forState:UIControlStateNormal];
    [voiceBtn setImage:[UIImage imageNamed:@"anjuke_icon_sound1@2x.png"] forState:UIControlStateHighlighted];
    [voiceBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchDown];
//    [voiceBack addSubview:voiceBtn];
    [self.view addSubview:voiceBtn];
    
    cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBut setTitleColor:[Util_UI colorWithHexString:@"FF8800"] forState:UIControlStateNormal];
    cancelBut.frame = CGRectMake(20, self.textV.frame.size.height + self.textV.frame.origin.y +15, BUTWHID, height);
    [cancelBut addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
    //    [voiceBack addSubview:voiceBtn];
    [self.view addSubview:cancelBut];

    stopBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopBut setTitle:@"说完了" forState:UIControlStateNormal];
    [stopBut setTitleColor:[Util_UI colorWithHexString:@"FF8800"] forState:UIControlStateNormal];
    stopBut.frame = CGRectMake([self windowWidth] - 20 - BUTWHID, self.textV.frame.size.height + self.textV.frame.origin.y +15, BUTWHID, height);
    [stopBut addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
    //    [voiceBack addSubview:voiceBtn];
    [self.view addSubview:stopBut];
    
    self.textV.frame = CGRectMake(self.textV.frame.origin.x, self.textV.frame.origin.y, self.textV.frame.size.width, self.textV.frame.size.height - 30);
    UIImage *myimage = [UIImage imageNamed:@"anjuke_icon_saying@2x.png"];
    
    CGRect rect = CGRectMake(0, 0, 163, 60);
    
    CGImageRef imageRef=CGImageCreateWithImageInRect([myimage CGImage],rect);
    
    UIImage *image1=[UIImage imageWithCGImage:imageRef];
    
    //    [imgView setImage:image1];
    
    
    UIImageView *view1 = [[UIImageView alloc] initWithFrame:CGRectMake(voiceBtn.frame.origin.x - 25, voiceBtn.frame.origin.y - 25, 82, 82)];
    view1.image = [UIImage imageNamed:@"anjuke_icon_saying1@2x.png"];
    [self.view addSubview:view1];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(voiceBtn.frame.origin.x - 25, voiceBtn.frame.origin.y - 25, 82, 30)];
    view.image = image1;
    [self.view addSubview:view];
    
}

- (void)doBack:(id)sender {
    if (!self.textV) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if ([[Util_TEXT rmBlankFromString:self.textV.text] isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                 message:@"是否保存当前输入"
                                                delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"不保存",@"保存并退出",nil];
    av.tag = 102;
    [av show];
}

#pragma mark - Text Field Delegate

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: //不保存
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        case 1: //保存并退出
        {
            [self rightButtonAction:self];
        }
            break;
        default:
            break;
    }
}

#pragma mark - keyBoardNotification
- (void)keyboardWillShow:(NSNotification *)notification

{
    //static CGFloat normalKeyboardHeight = 216.0f;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    // CGFloat distanceToMove = kbSize.height - normalKeyboardHeight;
    //自适应代码
    if (offset == 0) {
        offset = kbSize.height;
        moveoffset = offset;
    }
    else{
        if (offset == 216.0f) {
            offset = kbSize.height;
            moveoffset = (kbSize.height == 216.0f ? 0.0f:kbSize.height-216.0f);
        }
        else if(offset == 252.0f){
            offset = kbSize.height;
            moveoffset = (kbSize.height == 252.0f ? 0.0f:216.0f-252.0f);
        }
    }
//    [self dealwithShowKeyboard];
    
    //    offset = (kbSize.height == 216.0f ? 216.0f:kbSize.height-216.0f);
    
    //    DLog(@"%f,%f,%f,%f",tableViewRect.origin.x, tableViewRect.origin.y , tableViewRect.size.width, tableViewRect.size.height);
    
    //    DLog(@"normalKeyboardHeight is %f and kbSize is %f",kbSize.height,offset);
    
    
    
    //    CATransition *animation = [CATransition animation];
    
    //	//animation.delegate = self;
    
    //	animation.duration = 0.7f;
    
    //	animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    //	animation.fillMode = kCAFillModeForwards;
    
    //	animation.type = kCATransitionPush;
    
    //	animation.subtype = kCATransitionFromTop;
    
    //
    
    //    toolView.frame = CGRectMake(toolViewRect.origin.x, toolViewRect.origin.y - moveoffset, toolViewRect.size.width, toolViewRect.size.height);
    
    //
    
    //	[toolView.layer addAnimation:animation forKey:@"animation"];
    
    
    
    //    [UIView animateWithDuration:0.25f
    
    //                     animations:^{
    
    //                         toolView.frame = CGRectMake(toolViewRect.origin.x, toolViewRect.origin.y - moveoffset, toolViewRect.size.width, toolViewRect.size.height);
    
    //                         myTableView.frame = CGRectMake(tableViewRect.origin.x, tableViewRect.origin.y , tableViewRect.size.width, tableViewRect.size.height - moveoffset);
    
    //                     }
    
    //                     completion:^(BOOL finished){
    
    //                     }
    
    //     ];
    
    //    [self reloadMyTableView];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    //    NSDictionary *info = [notification userInfo];
    
    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    //
    
    //
    
    //
    
    //    //自适应代码
    
    //
    
    //    myTableView.frame = CGRectMake(tableViewRect.origin.x, tableViewRect.origin.y - kbSize.height, tableViewRect.size.width, tableViewRect.size.height);
    
    //
    
    //    toolView.frame = CGRectMake(toolViewRect.origin.x, toolViewRect.origin.y - kbSize.height, toolViewRect.size.width, toolViewRect.size.height);
    
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    [self dealwithHideKeyboard];
    
}

-(void)dealwithHideKeyboard{
    
//    tableViewRect = myTableView.frame;
//    
//    toolViewRect = toolView.frame;
//    
//    
//    
//    [UIView animateWithDuration:0.25f
//     
//                     animations:^{
//                         
//                         myTableView.frame = CGRectMake(tableViewRect.origin.x, tableViewRect.origin.y , tableViewRect.size.width, tableViewRect.size.height+offset);
//                         
//                         toolView.frame = CGRectMake(toolViewRect.origin.x, toolViewRect.origin.y+offset, toolViewRect.size.width, toolViewRect.size.height);
//                         
//                     }
//     
//                     completion:^(BOOL finished){
//                         
//                     }
//     
//     ];
//    
//    offset= 0;
//    
//    moveoffset = 0;
    
    //[self reloadMyTableView];
    
}

#pragma mark - privateMethod
- (void)start:(id) sender {


}
- (void)cancel:(id) sender {


}



@end
