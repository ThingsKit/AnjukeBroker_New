//
//  ClientEditViewController.m
//  AnjukeBroker_New
//
//  Created by paper on 14-2-20.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "ClientEditViewController.h"
#import "Broker_InputEditView.h"
#import "Util_UI.h"
#import "AXMappedPerson.h"
#import "AXChatMessageCenter.h"
#import "BrokerLineView.h"
#import "Util_TEXT.h"

#define INPUT_EDIT_TEXTVIEW_H 90
#define lbH 20

@interface ClientEditViewController ()

@property (nonatomic, strong) UIScrollView *editeScroll;
@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *telTextF;
@property (nonatomic, strong) UITextView *messageTextV;
@property (nonatomic, strong) UILabel *noteLabTit;
@property (nonatomic, strong) UIView *noteView;
@property (nonatomic, strong) UIView *mesLine;
@end

@implementation ClientEditViewController
@synthesize nameTextF, telTextF, messageTextV;
@synthesize person;
@synthesize editDelegate;

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
    
    [self setTitleViewWithString:@"备注"];
    [self.view setBackgroundColor:SYSTEM_LIGHT_GRAY_BG2];
    
    [self addRightButton:@"保存" andPossibleTitle:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - log
- (void)sendAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_EDIT_001 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot", nil]];
}

- (void)sendDisAppearLog {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_EDIT_002 note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"dt", nil]];
}

#pragma mark - init Method

- (void)initModel {
    
}

- (void)initDisplay {
    self.editeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [self windowWidth], [self windowHeight]-64)];
    self.editeScroll.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    self.editeScroll.contentSize = CGSizeMake([self windowWidth], [self windowHeight]-64);
    self.editeScroll.backgroundColor = [UIColor clearColor];
    self.editeScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.editeScroll];
    NSArray *titleArr = [NSArray arrayWithObjects:@"备注名", @"电话号码", @"备注信息", nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    for (int i = 0; i < titleArr.count; i++) {
        CGFloat inputViewH = INPUT_EDIT_VIEW_H;
        if (i != 2) {
            Broker_InputEditView *bi;
            if (i == 0) {
                bi = [[Broker_InputEditView alloc] initWithFrame:CGRectMake(0, INPUT_EDIT_VIEW_H*i, [self windowWidth], inputViewH)];
            }else{
                bi = [[Broker_InputEditView alloc] initWithFrame:CGRectMake(0, INPUT_EDIT_VIEW_H*i+20, [self windowWidth], inputViewH)];
            }
            bi.backgroundColor = [UIColor whiteColor];
            bi.titleLb.text = [titleArr objectAtIndex:i];
            switch (i) {
                case 0:
                {
                    [bi drawInputWithStyle:DisplayStyle_ForTextField];
                    self.nameTextF = bi.textFidle_Input;
                    self.nameTextF.text = self.person.markName;
                    self.nameTextF.delegate = self;
                }
                    break;
                case 1:
                {
                    [bi drawInputWithStyle:DisplayStyle_ForTextField];
                    self.telTextF = bi.textFidle_Input;
                    self.telTextF.text = self.person.markPhone;
                    self.telTextF.keyboardType = UIKeyboardTypePhonePad;
                    self.telTextF.delegate = self;
                }
                    break;

                default:
                    break;
            }
            [self.editeScroll addSubview:bi];
        }else {
            float noteDesH = [Util_UI sizeOfString:self.person.markDesc maxWidth:170 withFontSize:15].height;
            if (noteDesH < INPUT_EDIT_TEXTVIEW_H - 20) {
                inputViewH = INPUT_EDIT_TEXTVIEW_H;
            }else{
                inputViewH = noteDesH+20;
            }
            
            self.noteView = [[UIView alloc] initWithFrame:CGRectMake(0, INPUT_EDIT_VIEW_H*2+20, [self windowWidth], inputViewH)];
            self.noteView.backgroundColor = [UIColor whiteColor];
            [self.editeScroll addSubview:self.noteView];
            
            self.noteLabTit = [[UILabel alloc] initWithFrame:CGRectMake(17, (inputViewH - lbH)/2, 70, lbH)];
            self.noteLabTit.backgroundColor = [UIColor clearColor];
            self.noteLabTit.textColor = SYSTEM_DARK_GRAY;
            self.noteLabTit.text = [titleArr objectAtIndex:2];
            self.noteLabTit.font = [UIFont systemFontOfSize:15];
            [self.noteView addSubview:self.noteLabTit];

            self.messageTextV = [[UITextView alloc] initWithFrame:CGRectMake(self.noteLabTit.frame.origin.x + self.noteLabTit.frame.size.width + 15, 5, 185, inputViewH+10)];
            self.messageTextV.backgroundColor = [UIColor clearColor];
            self.messageTextV.font = self.noteLabTit.font;
            self.messageTextV.textColor = SYSTEM_BLACK;
            self.messageTextV.delegate = self;
            self.messageTextV.text = self.person.markDesc;
            self.messageTextV.keyboardType = UIKeyboardTypeDefault;
            [self.noteView addSubview:messageTextV];
            
            UIView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, inputViewH, 320, 0.5)];
            self.mesLine = line;
            [self.noteView addSubview:line];
        }

    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
//    static CGFloat normalKeyboardHeight = 216.0f;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    float conTH = [Util_UI sizeOfString:self.messageTextV.text maxWidth:170 withFontSize:15].height + 20 + INPUT_EDIT_TEXTVIEW_H + 10;
    if (conTH < [self windowHeight]- kbSize.height - 64) {
        conTH = [self windowHeight]- kbSize.height - 64;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.editeScroll.frame = CGRectMake(0, 0, [self windowWidth], [self windowHeight]- kbSize.height - 64);
        self.editeScroll.contentSize = self.editeScroll.contentSize = CGSizeMake([self windowWidth], conTH);
    } completion:^(BOOL finished) {
    }];
}
- (void)keyboardWillHide:(NSNotification *)notification{
    self.editeScroll.frame = CGRectMake(0, 0, [self windowWidth], [self windowHeight] -64);
}

#pragma mark -UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    float textConH = [Util_UI sizeOfString:[textView.text stringByAppendingString:text] maxWidth:170 withFontSize:15].height;
    float TVIH = INPUT_EDIT_TEXTVIEW_H - 20;
    
    if (textConH <= TVIH) {
        [self resetMsgView:TVIH];
    }else if (textConH > TVIH){
        [self resetMsgView:textConH];
    }
    return YES;
}

- (void)resetMsgView:(float)msgInputH{
    CGRect noteViewFrame = self.noteView.frame;
    CGRect noteTitLabFrame = self.noteLabTit.frame;
    CGRect noteMsgFrame = self.messageTextV.frame;
    CGRect msgLineFrame = self.mesLine.frame;
    CGSize size = self.editeScroll.contentSize;
    
    noteViewFrame.size.height = msgInputH+20;
    noteTitLabFrame.origin.y = (msgInputH + 20 - lbH)/2;
    noteMsgFrame.size.height = msgInputH;
    msgLineFrame.origin.y = msgInputH+20;
    
    float contentH = self.editeScroll.frame.size.height;
    size.height = INPUT_EDIT_VIEW_H*2+20+msgInputH+20+20;
    if (size.height < contentH) {
        size.height = contentH;
    }
    
    self.noteView.frame = noteViewFrame;
    self.noteLabTit.frame = noteTitLabFrame;
    self.messageTextV.frame = noteMsgFrame;
    self.mesLine.frame = msgLineFrame;
    self.editeScroll.contentSize = size;
}

#pragma mark - Private Method

- (void)rightButtonAction:(id)sender {
    [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_EDIT_003 note:nil];
    
    [self textInputDisappear];
    
    if (![self checkInputOK]) {
        return;
    }
    
    self.person.markName = self.nameTextF.text;
    
    if (self.person.markName.length > 0) {
        //set person.markNamePinyin
        NSMutableString *markNamePinyin = [NSMutableString stringWithString:self.person.markName];
        if (CFStringTransform((__bridge CFMutableStringRef)markNamePinyin, 0, kCFStringTransformMandarinLatin, NO)) {
            if (markNamePinyin.length > 0) {
                self.person.markNamePinyin = [markNamePinyin substringToIndex:1];
            }
            DLog(@"mark name pinyin -- [%@] [%@]", markNamePinyin, [markNamePinyin substringToIndex:1]);
        }
    }
    else
        self.person.markNamePinyin = @"";
    
    self.person.markPhone = self.telTextF.text;
    self.person.markDesc = self.messageTextV.text;
    
    [[AXChatMessageCenter defaultMessageCenter] updatePerson:self.person];
    
    [self requestData];
    
    DLog(@"--name[%@] ---tel[%@] ---message[%@]", self.nameTextF.text, self.telTextF.text, self.messageTextV.text);
    
}

- (void)requestData {
    if (![self isNetworkOkay]) {
        return;
    }
    
    NSString *isStar = @"0";
    if (self.person.isStar == YES) {
        isStar = @"1";
    }
    
    [self showLoadingActivity:YES];
    
    NSString *methodName = [NSString stringWithFormat:@"user/modifyFriendInfo/%@",[LoginManager getPhone]];
    
    NSDictionary *params = @{@"to_uid":self.person.uid ? self.person.uid:@"",
                             @"is_star":isStar,
                             @"relation_cate_id":@"0",
                             @"mark_name":self.person.markName ? self.person.markName:@"",
                             @"mark_phone":self.person.markPhone ? self.person.markPhone:@"",
                             @"mark_desc":self.person.markDesc ? self.person.markDesc:@""};
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTAnjukeXRESTServiceID methodName:methodName params:params target:self action:@selector(onGetData:)];
}

- (void)onGetData:(RTNetworkResponse *) response {
    [self hideLoadWithAnimated:NO];

    //check network and response
    if (![self isNetworkOkay])
        return;
    
    if ([response status] == RTNetworkResponseStatusFailed || ([[[response content] objectForKey:@"status"] isEqualToString:@"error"]))
        return;
    
    NSDictionary *resultFromAPI = [response content];
    DLog(@"编辑客户---%@", resultFromAPI);
    
    if ([[resultFromAPI objectForKey:@"status"] isEqualToString:@"OK"]) {
        [[BrokerLogger sharedInstance] logWithActionCode:CLIENT_EDIT_005 note:nil];
        
        [self showInfo:@"备注信息更新成功"];
        
        if ([self.editDelegate respondsToSelector:@selector(didSaveBackWithData:)]) {
            [self.editDelegate didSaveBackWithData:self.person];
        }
        
        [self doBack:self];
    }
    else {
        [self showInfo:@"备注信息更新失败，请再试一次"];
    }
    
}

- (void)textInputDisappear {
    [self.nameTextF resignFirstResponder];
    [self.telTextF resignFirstResponder];
    [self.messageTextV resignFirstResponder];
}

- (BOOL)checkInputOK {
    if (self.nameTextF.text.length > 10) {
        [self showInfo:@"备注名上限10个字"];
        return NO;
    }
    if (self.telTextF.text.length > 20) {
        [self showInfo:@"电话号码上限20个字"];
        return NO;
    }
    if (self.messageTextV.text.length > 200) {
        [self showInfo:@"备注信息上限200个字"];
        return NO;
    }
    
    if (![Util_TEXT isNumber:self.telTextF.text]) {
        [self showInfo:@"备注电话必须为数字"];
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

@end
