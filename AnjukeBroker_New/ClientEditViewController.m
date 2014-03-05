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

@interface ClientEditViewController ()

@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *telTextF;
@property (nonatomic, strong) UITextView *messageTextV;

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

#pragma mark - init Method

- (void)initModel {
    
}

- (void)initDisplay {
    NSArray *titleArr = [NSArray arrayWithObjects:@"备注名", @"电话号码", @"备注信息", nil];
    
    CGFloat inputViewH = INPUT_EDIT_VIEW_H;
    
    for (int i = 0; i < titleArr.count; i ++) {
        if (i == 2) {
            inputViewH = INPUT_EDIT_TEXTVIEW_H;
        }
        Broker_InputEditView *bi = [[Broker_InputEditView alloc] initWithFrame:CGRectMake(0, 10 + INPUT_EDIT_VIEW_H* i, [self windowWidth], inputViewH)];
        bi.backgroundColor = [UIColor whiteColor];
        bi.titleLb.text = [titleArr objectAtIndex:i];
        switch (i) {
            case 0:
            {
                [bi drawInputWithStyle:DisplayStyle_ForTextField];
                [bi addLineViewWithOriginY:-0.5]; //top line
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
            case 2:
            {
                [bi drawInputWithStyle:DisplayStyle_ForTextView];
                self.messageTextV = bi.textView_Input;
                self.messageTextV.text = self.person.markDesc;
                self.messageTextV.backgroundColor = [UIColor clearColor];
                self.messageTextV.delegate = self;
            }
                break;
                
            default:
                break;
        }
        [bi addLineViewWithOriginY:inputViewH-0.5]; //bottom line
        [self.view addSubview:bi];
    }
}

#pragma mark - Private Method

- (void)rightButtonAction:(id)sender {
    [self textInputDisappear];
    
    if (![self checkInputOK]) {
        return;
    }
    
    self.person.markName = self.nameTextF.text;
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
    if (self.person.isStar) {
        isStar = @"1";
    }
    
    [self showLoadingActivity:YES];
    
    NSString *methodName = [NSString stringWithFormat:@"user/modifyFriendInfo/%@",[LoginManager getPhone]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: self.person.uid ,@"to_uid" , self.person.markName ,@"mark_name", self.person.markPhone, @"mark_phone", self.person.markDesc, @"mark_desc", @"0" ,@"relation_cate_id", isStar, @"is_star", nil];
    
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
    DLog(@"%@", resultFromAPI);
    
    if ([[resultFromAPI objectForKey:@"status"] isEqualToString:@"OK"]) {
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
    
    return YES;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

@end
