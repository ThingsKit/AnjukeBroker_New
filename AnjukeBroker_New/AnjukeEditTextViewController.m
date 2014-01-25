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
#import <QuartzCore/QuartzCore.h>

#define APPID @"52d7a64b"
#define TIMEOUT         @"20000"            // timeout      连接超时的时间，以ms为单位

#define VOICEBACKVIEWHEIGHT 90 //语音的空间高度
#define VOICEANIMATIONIMGHEIGHT 163/2   //说话时动画图片高度
#define BUTWHID 80 //取消按钮宽度
#define BUTHIGHT 30  //
#define SOUNDBUTTONHEIGHT 57 // 键盘出来后的语音框
#define VOICEBUTTONHEIHGT 106/2 //开始语音按钮的图片高度

//#define 
@interface AnjukeEditTextViewController ()
{
    float offset;
    float moveoffset;
    UIImage *corlorIMG;
    IFlySpeechRecognizer * _iFlySpeechRecognizer;
    UILabel *wordNum;
    NSString *placeHolder;
    
}
@property (nonatomic, strong) UITextView *textV;
@property (nonatomic, strong) UIImageView *backIMG;
@property (nonatomic, strong) UIImageView *beforIMG;
@property (nonatomic, strong) UIButton *stopBut;
@property (nonatomic, strong) UIButton *cancelBut;
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *voiceUpBut;
@end

@implementation AnjukeEditTextViewController
@synthesize textString;
@synthesize textFieldModifyDelegate;
@synthesize textV;
@synthesize isTitle;
@synthesize backIMG;
@synthesize beforIMG;
@synthesize stopBut;
@synthesize cancelBut;
@synthesize voiceBtn;
@synthesize voiceUpBut;

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
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_iFlySpeechRecognizer stopListening];
    _iFlySpeechRecognizer.delegate = nil;
}
#pragma mark - private method
- (void)initModel {
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,timeout=%@",APPID,TIMEOUT];
    _iFlySpeechRecognizer = [IFlySpeechRecognizer createRecognizer: initString delegate:self];
    _iFlySpeechRecognizer.delegate = self;
    [_iFlySpeechRecognizer setParameter:@"domain" value:@"sms"];
    [_iFlySpeechRecognizer setParameter:@"sample_rate" value:@"16000"];
    [_iFlySpeechRecognizer setParameter:@"plain_result" value:@"0"];
    
}

- (void)initDisplay {
    wordNum = [[UILabel alloc] initWithFrame:CGRectZero];
    wordNum.backgroundColor = [UIColor clearColor];
    [self.textV addSubview:wordNum];
    if(self.isTitle){
        wordNum.text = @"30";
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }
    
    self.voiceUpBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceUpBut.frame = CGRectMake(0, 0, 0, 0);
    [self.voiceUpBut setTitle:@"语音输入" forState:UIControlStateNormal];
    [self.voiceUpBut setImage:[UIImage imageNamed:@"anjuke_icon_sound_button@2x.png"] forState:UIControlStateNormal];
    [self.voiceUpBut setImage:[UIImage imageNamed:@"anjuke_icon_sound_button1@2x.png"] forState:UIControlStateHighlighted];
    [self.voiceUpBut addTarget:self action:@selector(startAgain) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.voiceUpBut];
    
    
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceBtn.frame = CGRectMake(160 - 106/2/2, [self windowHeight] - 106/2 - 64 - 15 , 106/2, 106/2);
    [self.voiceBtn setImage:[UIImage imageNamed:@"anjuke_icon_sound@2x.png"] forState:UIControlStateNormal];
    [self.voiceBtn setImage:[UIImage imageNamed:@"anjuke_icon_sound1@2x.png"] forState:UIControlStateHighlighted];
    [self.voiceBtn addTarget:self action:@selector(start:) forControlEvents:UIControlEventTouchUpInside];
    //    [voiceBack addSubview:voiceBtn];
    [self.view addSubview:self.voiceBtn];
    
    self.cancelBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBut setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBut setTitleColor:[Util_UI colorWithHexString:@"FF8800"] forState:UIControlStateNormal];
    self.cancelBut.frame = CGRectZero;
    [self.cancelBut addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchDown];
    //    [voiceBack addSubview:voiceBtn];
    [self.view addSubview:self.cancelBut];
    
    self.stopBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.stopBut setTitle:@"说完了" forState:UIControlStateNormal];
    [self.stopBut setTitleColor:[Util_UI colorWithHexString:@"FF8800"] forState:UIControlStateNormal];
    self.stopBut.frame = CGRectZero;
    [self.stopBut addTarget:self action:@selector(speechOver:) forControlEvents:UIControlEventTouchDown];
    //    [voiceBack addSubview:voiceBtn];
    [self.view addSubview:self.stopBut];
    
    UIImage *orgIMG = [UIImage imageNamed:@"anjuke_icon_saying@2x.png"];
    CGRect rect = CGRectMake(0, 0, 163, 60);
    CGImageRef imageRef=CGImageCreateWithImageInRect([orgIMG CGImage],rect);
    corlorIMG=[UIImage imageWithCGImage:imageRef];
    
    self.backIMG = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.backIMG.image = [UIImage imageNamed:@"anjuke_icon_saying1@2x.png"];
    [self.view addSubview:self.backIMG];
    
    self.beforIMG = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.beforIMG.image = corlorIMG;
    [self.view addSubview:self.beforIMG];

}

- (void)rightButtonAction:(id)sender {
    if (self.isTitle) {
        if (self.textV.text.length > 30 || self.textV.text.length < 5 || [self.textV.text isEqualToString:placeHolder]) {
            [self showInfo:@"房源标题必须5到30个字符"];
            return;
        }
    }
    else {
        if (self.textV.text.length < 10 || [self.textV.text isEqualToString:placeHolder]) {
            [self showInfo:@"房源描述必须至少10个字符"];
            return;
        }
    }
    
    if ([self.textFieldModifyDelegate respondsToSelector:@selector(textDidInput:isTitle:)]) {
        if ([self.textV.text isEqualToString:placeHolder]) {
            [self.textFieldModifyDelegate textDidInput:@"" isTitle:self.isTitle];
        }else{
            [self.textFieldModifyDelegate textDidInput:self.textV.text isTitle:self.isTitle];
        }
    }
    [self.textV resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTextFieldDetail:(NSString *)string {
    CGFloat TextViewH = 260;
    if ([self windowHeight] <= 960/2) {
        TextViewH = 180;
    }
    
    UITextView *cellTextField = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - VOICEBACKVIEWHEIGHT - 64)];
    cellTextField.returnKeyType = UIReturnKeyDone;
    cellTextField.backgroundColor = [UIColor clearColor];
    cellTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    if(self.isTitle){
        placeHolder = [[NSString alloc] initWithFormat:@"简单明了的说出房源得特色，至少5个字"];
    } else {
        placeHolder = [[NSString alloc] initWithFormat:@"说说小区周边生活配套、小区内部环境、房源内部装修的房源描述，至少10个字"];
    }
    cellTextField.text = placeHolder;
    cellTextField.delegate = self;
    cellTextField.font = [UIFont systemFontOfSize:17];
    cellTextField.secureTextEntry = NO;
    cellTextField.textColor = [Util_UI colorWithHexString:@"#999999"];
    cellTextField.layer.borderWidth = 1;
    cellTextField.layer.borderColor = [[Util_UI colorWithHexString:@"CCCCCC"] CGColor];
    cellTextField.layer.cornerRadius = 6;
    self.textV = cellTextField;
    [self.view addSubview:cellTextField];
    
    if(self.textV && [string length] > 0){
        self.textV.text = string;
        self.textV.textColor = SYSTEM_BLACK;
    }
}

- (void)doBack:(id)sender {
    if (!self.textV || [self.textV.text isEqualToString:placeHolder]) {
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

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.textV.text isEqualToString:placeHolder]) {
        self.textV.text = @"";
        self.textV.textColor = SYSTEM_BLACK;
    }
//    if (self.textV.text.intValue < 1 && range.length == 0)
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    if(self.isTitle){
        NSString *temp = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if ([temp isEqualToString:placeHolder]) {
            wordNum.text = [NSString stringWithFormat:@"30"];
            return YES;
        }
        if (temp.length > 30) {
            DLog(@"111222 %@======%d", temp, [temp length]);
            self.textV.text = [temp substringToIndex:30];
            return NO;
        }else {
            wordNum.text = [NSString stringWithFormat:@"%d", 30 - [temp length]];
        }
    }

    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textV.text isEqualToString:placeHolder]) {
        self.textV.text = @"";
        self.textV.textColor = SYSTEM_BLACK;
    }
}

- (void)textViewDidChange:(UITextView *)textView {

    if(self.isTitle){
        NSString *temp = self.textV.text;
        NSInteger num = [temp length];
        if(num < 30){
            wordNum.text = [NSString stringWithFormat:@"%d", 30 - [temp length]];
            wordNum.textColor = SYSTEM_BLACK;
        }else if (num == 30) {
            wordNum.textColor = [UIColor redColor];
            wordNum.text = [NSString stringWithFormat:@"%d", 30 - [temp length]];
            
        } else {
            wordNum.textColor = [UIColor redColor];
            wordNum.text = [NSString stringWithFormat:@"0"];
            self.textV.text = [temp substringToIndex:30];
        }
    }

//textView.text = [textView.text substringToIndex:2];
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
    [self cancelSpeech];
    [self cancelFrameChange];
    
    //static CGFloat normalKeyboardHeight = 216.0f;
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    offset = kbSize.height;
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - SOUNDBUTTONHEIGHT - 64 - offset);
    if(self.isTitle){
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }
    self.voiceUpBut.frame = CGRectMake((320 - 100)/2, [self windowHeight] - offset - 64 - 10 - 53/2, 200/2, 53/2);
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    offset = kbSize.height;
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - SOUNDBUTTONHEIGHT - 64 - offset);
    if(self.isTitle){
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }
    self.voiceUpBut.frame = CGRectMake((320 - 200)/2, [self windowHeight] - offset - 64 - 10, 200/2, 53/2);
}

- (void)keyboardWillHide:(NSNotification *)notification{
    
    [self dealwithHideKeyboard];
    
}

-(void)dealwithHideKeyboard{
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - VOICEBACKVIEWHEIGHT - 64);
    if(self.isTitle){
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }
    self.voiceUpBut.frame = CGRectZero;
}

#pragma mark - methods about listening

/** 停止录音
 
 调用此函数会停止录音，并开始进行语音识别
 */
-(void)stopSpeech {
    [_iFlySpeechRecognizer stopListening];
}
/** 开始识别
 
 同时只能进行一路会话,这次会话没有结束不能进行下一路会话，否则会报错
 */
-(void)startSpeech {
    _iFlySpeechRecognizer.delegate = self;
    [_iFlySpeechRecognizer startListening];
}
/** 取消本次会话 */
-(void)cancelSpeech {
    [_iFlySpeechRecognizer cancel];
}

#pragma mark - IFlySpeechRecognizerDelegate
/**
 * @fn      onVolumeChanged
 * @brief   音量变化回调
 *
 * @param   volume      -[in] 录音的音量，音量范围1~100
 * @see
 */
- (void) onVolumeChanged: (int)volume
{
    DLog(@"==========>>>>>>>>>%d",volume);
    [self speechAnimation:volume];
}

/**
 * @fn      onBeginOfSpeech
 * @brief   开始识别回调
 *
 * @see
 */
- (void) onBeginOfSpeech
{
    
}

/**
 * @fn      onEndOfSpeech
 * @brief   停止录音回调(自动停止时回调)
 *
 * @see
 */
- (void) onEndOfSpeech
{
    _iFlySpeechRecognizer.delegate = nil;
    [self cancelFrameChange];
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - VOICEBUTTONHEIHGT - 64 - 15*2 - 10);
    if(self.isTitle){
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }
}


/**
 * @fn      onError
 * @brief   识别结束回调
 *
 * @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
 */
- (void) onError:(IFlySpeechError *) error
{
    _iFlySpeechRecognizer.delegate = nil;
    [self cancelFrameChange];
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - VOICEBUTTONHEIHGT - 64 - 15*2 - 10);
    if(self.isTitle){
            wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
        } else {
            wordNum.frame = CGRectZero;
        }

}

/** 取消识别回调
 
 当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onError之前会有一个短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
- (void) onCancel {
    [self cancelFrameChange];
}
/**
 * @fn      onResults
 * @brief   识别结果回调
 *
 * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
 * @see
 */

- (void) onResults:(NSArray *) results
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [results objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    DLog(@"转写结果：%@",result);
    if ([self.textV.text isEqualToString:placeHolder] && [result length] > 0) {
        self.textV.text = @"";
        self.textV.textColor = SYSTEM_BLACK;
    }
    NSString *temp=[NSString stringWithFormat:@"%@%@", self.textV.text, result];
    if(self.isTitle){
//         = self.textV.text;
        NSInteger num = [temp length];
        if(num < 30){
            wordNum.text = [NSString stringWithFormat:@"%d", 30 - [temp length]];
            wordNum.textColor = SYSTEM_BLACK;
            self.textV.text = temp;
        }else if (num == 30) {
            wordNum.textColor = [UIColor redColor];
            wordNum.text = [NSString stringWithFormat:@"%d", 30 - [temp length]];
            self.textV.text = temp;
        } else {
            wordNum.textColor = [UIColor redColor];
            wordNum.text = [NSString stringWithFormat:@"0"];
            self.textV.text = [temp substringToIndex:30];
        }
    }
}

#pragma mark - privateMethod
- (void)start:(id) sender {
//    self.beforIMG = [[UIImageView alloc] initWithFrame:CGRectMake(voiceBtn.frame.origin.x - 25, voiceBtn.frame.origin.y - 25, 82, 30)];
//    self.backIMG = [[UIImageView alloc] initWithFrame:CGRectMake(voiceBtn.frame.origin.x - 25, voiceBtn.frame.origin.y - 25, 82, 82)];
    [self startSpeech];
    [self speechAnimation:0];
    self.voiceBtn.frame = CGRectZero;
    self.cancelBut.frame = CGRectMake(20, [self windowHeight] - 15 - VOICEANIMATIONIMGHEIGHT/2 - BUTHIGHT/2 - 64, BUTWHID, BUTHIGHT);
    self.stopBut.frame = CGRectMake([self windowWidth] - 20 - BUTWHID, [self windowHeight] - 15 - VOICEANIMATIONIMGHEIGHT/2 - BUTHIGHT/2 - 64, BUTWHID, BUTHIGHT);
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - VOICEANIMATIONIMGHEIGHT - 64 - 15*2 - 10);
    if(self.isTitle){
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }
    
}

- (void)speechAnimation:(int) volume {
    UIImage *orgIMG = [UIImage imageNamed:@"anjuke_icon_saying@2x.png"];
    CGRect rect = CGRectMake(0, 0, 163, 163 - 163 * volume/30 - 20);
    CGImageRef imageRef=CGImageCreateWithImageInRect([orgIMG CGImage],rect);
    corlorIMG=[UIImage imageWithCGImage:imageRef];
    self.backIMG.frame = CGRectMake((320 - VOICEANIMATIONIMGHEIGHT)/2 , [self windowHeight] - 106/2 - 64 - 15 - 25, 82, 82);
    self.backIMG.image = [UIImage imageNamed:@"anjuke_icon_saying1@2x.png"];
    self.beforIMG.frame = CGRectMake((320 - VOICEANIMATIONIMGHEIGHT)/2, [self windowHeight] - 106/2 - 64 - 15 - 25, 82, 82 - 163 * volume/30/2 - 10);
    self.beforIMG.image = corlorIMG;
}

- (void)cancel:(id) sender {
    [self cancelSpeech];
    [self cancelFrameChange];
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - VOICEBACKVIEWHEIGHT - 64);
    if(self.isTitle){
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }
}

- (void)cancelFrameChange{
    self.cancelBut.frame = CGRectZero;
    self.stopBut.frame = CGRectZero;
    self.backIMG.frame = CGRectZero;
    self.beforIMG.frame = CGRectZero;
    //    self.voiceBtn.frame = CGRectMake(160 - 106/2/2, self.textV.frame.size.height + self.textV.frame.origin.y +15, 106/2, 106/2);
    self.voiceBtn.frame = CGRectMake(160 - 106/2/2, [self windowHeight] - 106/2 - 64 - 15 , 106/2, 106/2);

}

- (void)startAgain {
    self.voiceUpBut.frame = CGRectZero;
    [self.textV resignFirstResponder];
    [self start:nil];
}

- (void)speechOver:(id)sender {
    [self stopSpeech];
    [self cancelFrameChange];
    self.textV.frame = CGRectMake(10, 10, [self windowWidth] - 20, [self windowHeight] - VOICEBACKVIEWHEIGHT - 64 - 15*2 - 10);
    if(self.isTitle){
        wordNum.frame = CGRectMake(self.textV.frame.size.width - 40, self.textV.frame.size.height - 40, 30, 30);
    } else {
        wordNum.frame = CGRectZero;
    }

}
@end
