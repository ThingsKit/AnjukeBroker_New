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

@interface ClientEditViewController ()

@property (nonatomic, strong) UITextField *nameTextF;
@property (nonatomic, strong) UITextField *telTextF;
@property (nonatomic, strong) UITextView *messageTextV;

@end

@implementation ClientEditViewController
@synthesize nameTextF, telTextF, messageTextV;

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
            }
                break;
            case 1:
            {
                [bi drawInputWithStyle:DisplayStyle_ForTextField];
                self.telTextF = bi.textFidle_Input;
            }
                break;
            case 2:
            {
                [bi drawInputWithStyle:DisplayStyle_ForTextView];
                self.messageTextV = bi.textView_Input;
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
    
    DLog(@"--name[%@] ---tel[%@] ---message[%@]", self.nameTextF.text, self.telTextF.text, self.messageTextV.text);
}

- (void)textInputDisappear {
    [self.nameTextF resignFirstResponder];
    [self.telTextF resignFirstResponder];
    [self.messageTextV resignFirstResponder];
}

@end
