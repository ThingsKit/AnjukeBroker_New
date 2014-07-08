//
//  ViewController.m
//  X
//
//  Created by 杨 志豪 on 2/12/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXChatViewController.h"

#import <OHAttributedLabel/OHAttributedLabel.h>
#import <OHAttributedLabel/NSAttributedString+Attributes.h>
#import <OHAttributedLabel/OHASBasicMarkupParser.h>

// Cell
#import "AXChatMessageRoomSourceCell.h"
#import "AXChatMessageImageCell.h"
#import "AXChatMessagePublicCardCell.h"
#import "AXChatMessageTextCell.h"
#import "AXChatMessageVoiceCell.h"
#import "AXChatMessageSystemTimeCell.h"
#import "AXPhoto.h"
#import "AXIMGDownloader.h"

#import "NSString+AXChatMessage.h"
#import "UIColor+AXChatMessage.h"
#import "NSString+JSMessagesView.h"

#import "AXChatMessageCenter.h"
#import "LocationManager.h"

#import "AXPullToRefreshContentView.h"
#import "JSMessageInputView.h"

//view
#import "AXTTTAttributedLabel.h"

// Controller
#import "AXChatWebViewController.h"
#import "MapViewController.h"
#import "AXPhotoBrowser.h"

#import "AXPhotoManager.h"
#import "AXCellFactory.h"
#import "AXChatContentValidator.h"
#import "AXNetWorkResponse.h"

//录音组件
#import "KKAudioComponent.h"

//表情组件
#import "FaceScrollView.h"
#import "FaceView.h"
#import "RTGestureLock.h"

#import "AppDelegate.h"

#pragma mark -- 公众账号菜单
#import "AXPublicLoading.h"
#import "AXPublicSubMenu.h"
#import "AXPublicMenu.h"
#import "AXPublicMenuButton.h"
#import "BrokerLineView.h"
#import "AXChatMessagePublicCard3Cell.h"

//输入框和发送按钮栏的高度
static CGFloat const AXInputBackViewHeight = 49;
//键盘高度
static CGFloat const AXMoreBackViewHeight = 217.0f;

#ifdef DEBUG
static NSInteger const AXMessagePageSize = 15;
#else
static NSInteger const AXMessagePageSize = 15;
#endif
static CGFloat const AXScrollContentOffsetY = 800;

static NSString * const AXChatJsonVersion = @"1";

static NSString * const SpeekImgNameKeyboard = @"anjuke_icon_keyboard.png";
static NSString * const SpeekImgNameKeyboardHighlight = @"anjuke_icon_keyboard1.png";

static NSString * const SpeekImgNameVoice = @"anjuke_icon_voice.png";
static NSString * const SpeekImgNameVoiceHighlight  = @"anjuke_icon_voice1.png";

static NSString * const EmojiImgName = @"anjuke_icon_bq";
static NSString * const EmojiImgNameHighlight  = @"anjuke_icon_bq1";


@interface AXChatViewController ()<UITableViewDelegate, UITableViewDataSource, OHAttributedLabelDelegate, AXPullToRefreshViewDelegate, UIAlertViewDelegate, AXChatBaseCellDelegate, JSDismissiveTextViewDelegate, MapViewControllerDelegate,AXPublicMenuDelegate,AXPublicSubMenuDelegate>


@property (nonatomic, strong) UITableViewCell *selectedCell;
@property (nonatomic) BOOL isMenuVisible;
@property (nonatomic) BOOL isFinished;
@property (nonatomic) CGFloat tableViewBottom;
@property (nonatomic) BOOL hasMore;
@property (nonatomic) CGRect messageInputViewFrame;
@property (nonatomic) CGRect messageInputTextViewFrame;
@property (nonatomic, copy) NSString *currentText;

@property (nonatomic, strong) AXPullToRefreshView *pullToRefreshView;
@property (nonatomic, strong) AXMappedMessage *lastMessage;
@property (nonatomic, strong) UILabel *sendLabel;
@property (nonatomic, strong) UIControl *keyboardControl;
@property (nonatomic, strong) AXChatContentValidator *contentValidator;
@property (nonatomic, copy) NSString *playingIdentifier;
@property (nonatomic, strong)AXIMGDownloader *imgDownloader;
@property (nonatomic, strong) AXMappedPerson *currentPerson;


// JSMessage
@property (nonatomic, strong) UIView *inputBackView;
@property (nonatomic) CGFloat previousTextViewContentHeight;
@property (nonatomic) BOOL isUserScrolling;

@property (nonatomic, strong) AXTTTAttributedLabel *attrLabel;

//Debug
@property (nonatomic, strong) NSString *testUid;
@property (nonatomic, strong) NSNotification *preNotification;


//录音相关
@property (nonatomic, retain) UIImageView* volumnImageView;
@property (nonatomic, retain) MBProgressHUD* hud;
@property (nonatomic, retain) NSTimer* timer;
@property (nonatomic, strong) UIButton *pressSpeek;

@property (nonatomic, retain) UIImageView* warningImageView;
@property (nonatomic, retain) UIImageView* microphoneImageView;
@property (nonatomic, retain) UIImageView* highlightedMicrophoneImageView;
@property (nonatomic, retain) UIImageView* backgroundImageView;
@property (nonatomic, retain) UIImageView* dustbinImageView;
@property (nonatomic, retain) UIImageView* cancelBackgroundImgaeView;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) UILabel* hudLabel;
@property (nonatomic, retain) UILabel* countDownLabel;
@property (nonatomic, retain) UIImage* corlorIMG;
@property (nonatomic, assign) CGFloat curCount;
@property (nonatomic, assign) BOOL isInterrupted;
@property (nonatomic, assign) BOOL playTipView;
@property (nonatomic, assign) BOOL hasMicrophonePermission;
#define MAX_RECORD_TIME 60

//表情相关
@property (nonatomic, assign) NSUInteger cursorLocation; //文本输入框光标所在位置

@property (nonatomic, assign) BOOL isMenuFlag; //是否有输入框和菜单开关
@property (nonatomic, strong) AXPublicMenu * publicMenu;
@property (nonatomic, strong) AXPublicSubMenu * publicSubMenu;
@property (nonatomic, strong) NSMutableDictionary * menuConfigs;
@property (nonatomic, strong) BrokerLineView * line;
@property (nonatomic, strong) AXPublicLoading * publicLoadView;
@property (nonatomic, strong) void (^subMenuHideFinish)(BOOL isFinished);


@end

@implementation AXChatViewController
@synthesize myTableView;

#pragma mark - getters and setters
- (AXTTTAttributedLabel *)attrLabel
{
    if (!_attrLabel) {
        _attrLabel = [AXChatMessageTextCell createAXAttributedLabel];
    }
    return _attrLabel;
}
- (AXIMGDownloader *)imgDownloader {
    if (_imgDownloader == nil) {
        _imgDownloader = [[AXIMGDownloader alloc] init];
    }
    return _imgDownloader;
}

#pragma mark - lifeCyle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBroker = YES;
        _isMenuVisible = YES;
        _isFinished = NO;
        _needSendProp = NO;
        _hasMore = NO;
        self.isVoiceInput = NO;
        _contentValidator = [[AXChatContentValidator alloc] init];
        _playingIdentifier = @"";
        _currentText = @"";
        _messageInputViewFrame = CGRectZero;
        _messageInputTextViewFrame = CGRectZero;
        
        _isHavPublicMenu = NO;
        _isMenuFlag = NO;
    }
    return self;
}

- (void)dealloc
{
//    [[[AppDelegate sharedAppDelegate] tabController] setSelectedIndex:1];
    
    DLog(@"AXChatViewController dealloc");
    [self.messageInputView.textView removeObserver:self forKeyPath:@"contentSize"];
    self.messageInputView = nil;
    self.pullToRefreshView.delegate = nil;
    self.pullToRefreshView = nil;
    self.myTableView.delegate = nil;
    self.myTableView.dataSource = nil;
    self.myTableView = nil;
    self.subMenuHideFinish = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[LocationManager defaultLocationManager] cancellRequest];
    
    //只能在dealloc时调用，不允许在viewWillDisappear调用已造成friendUid为Nil！！！
    [[AXChatMessageCenter defaultMessageCenter] didLeaveChattingListWithFriendUID:[self checkFriendUid]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isFinished) {
        self.currentPerson = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson];
    }
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboardNotification:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboardNotification:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [self didClickRecored:nil]; //检测麦克风权限
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self restoreDraftContent];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //草稿
    if (self.messageInputView || self.currentText) {
        if (self.messageInputView.textView.text.length == 0) {
            [[AXChatMessageCenter defaultMessageCenter] saveDraft:self.currentText friendUID:[self checkFriendUid]];
        } else {
            [[AXChatMessageCenter defaultMessageCenter] saveDraft:self.messageInputView.textView.text friendUID:[self checkFriendUid]];
        }
        
    }

    [self.messageInputView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];

    [self cancelKKAudioPlaying];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // init Data
    [self initData];
    
    
    // init UI
    [self initUI];
    [self fetchLastChatList];
    [self initBlock];
    [self initPullToRefresh];
    self.previousTextViewContentHeight = 36;
    [self downLoadIcon];
}

- (void)initData {
    self.conversationListItem = [[AXChatMessageCenter defaultMessageCenter] fetchConversationListItemWithFriendUID:[self checkFriendUid]];
    self.currentPerson = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson];
    self.friendPerson = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[self checkFriendUid]];
    self.cellDict = [NSMutableDictionary dictionary];
    self.identifierData = [NSMutableArray array];
    self.locationArray = [NSMutableArray array];
    
    _buttonDict = [[NSMutableDictionary alloc] initWithCapacity:8];
}

#pragma mark - InitUI Method
- (void)initUI {
    if (self.brokerName) {
        self.title = self.brokerName;
    } else {
        self.title = self.friendPerson.name;
    }
    [self.view setBackgroundColor:[UIColor axChatBGColor:self.isBroker]];
    
    NSInteger viewHeight = 20;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        viewHeight = 0;
    }
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, AXWINDOWWHIDTH, AXWINDOWHEIGHT - AXInputBackViewHeight - viewHeight) style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.myTableView];
    
    self.keyboardControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.myTableView.width, 10)];
    self.keyboardControl.backgroundColor = [UIColor clearColor];
    self.keyboardControl.hidden = YES;
    [self.view addSubview:self.keyboardControl];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(didClickKeyboardControl)];
    [recognizer setMinimumPressDuration:0.0001f];
    [self.keyboardControl addGestureRecognizer:recognizer];
    
    self.moreBackView = [[UIView alloc] init];
    self.moreBackView.frame = CGRectMake(0, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXMoreBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);
    self.moreBackView.backgroundColor = [UIColor colorWithHex:0Xf6f6f6 alpha:1.0];
    self.moreBackView.hidden = YES;
    [self.view addSubview:self.moreBackView];
    
    BrokerLineView *line = [[BrokerLineView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    line.horizontalLine = YES;
    [self.moreBackView addSubview:line];
    
    CGSize size = self.view.frame.size;
    CGFloat inputViewHeight = 49;
    UIPanGestureRecognizer *pan = self.myTableView.panGestureRecognizer;
    
    //判断是否需要开启publicMenu
    self.menuConfigs = [[NSMutableDictionary alloc] initWithDictionary:self.friendPerson.configs];
    self.isMenuFlag = NO;
    self.isHavPublicMenu = NO;

    if ([self isPublicPerson] && self.menuConfigs[@"input_type"] && [self.menuConfigs[@"input_type"] integerValue]  == AXPublicInputTypeNormalAndPublicMenu) {
        self.isMenuFlag = YES;
    }
    
    if ([self isPublicPerson] && self.menuConfigs[@"input_type"] && ([self.menuConfigs[@"input_type"] integerValue]  == AXPublicInputTypePublicMenu || [self.menuConfigs[@"input_type"] integerValue]  == AXPublicInputTypeNormalAndPublicMenu)) {
        self.isHavPublicMenu = YES;
    }

    CGRect inputFrame;
    if (self.isHavPublicMenu) {
        inputFrame = CGRectMake(0.0f,
                                size.height,
                                size.width,
                                inputViewHeight);
    }else{
        inputFrame = CGRectMake(0.0f,
                                size.height - inputViewHeight,
                                size.width,
                                inputViewHeight);
    }

    
    
    JSMessageInputView *inputView = [[JSMessageInputView alloc] initWithFrame:inputFrame
                                                                        style:JSMessageInputViewStyleFlat
                                                                     delegate:self
                                                         panGestureRecognizer:pan
                                                                     isBroker:self.isBroker
                                                                     isSwitch:self.isMenuFlag
                                     
                                     ];
    self.messageInputView = inputView;
    
    [_buttonDict setValue:self.messageInputView forKey:AXUITEXVIEWEDIT];

    [self.view addSubview:self.messageInputView];
    [self.messageInputView.textView addObserver:self
                                     forKeyPath:@"contentSize"
                                        options:NSKeyValueObservingOptionNew
                                        context:nil];
    CGRect textViewRect = self.messageInputView.textView.frame;
    self.messageInputViewFrame = inputView.frame;
    
    //加载publicMenus
    if (self.isHavPublicMenu) {
        if (!self.publicMenu) {
            float y = 20;
            if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
                y = 0;
            }
            self.publicMenu = [[AXPublicMenu alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44- y - inputViewHeight , [self windowWidth], 49)];
            self.publicMenu.publicMenuDelegate = self;
            [self.publicMenu configPublicMenuView:self.menuConfigs[@"menu_list"] inputType:[self.menuConfigs[@"input_type"] integerValue]];
            //        [self.publicMenu configPublicMenuView:self.menuConfigs[@"menu_list"] inputType:2];
            
            [self.view addSubview:self.publicMenu];
            //如果只有public菜单，隐藏输入键盘
            if (self.menuConfigs[@"input_type"] && [self.menuConfigs[@"input_type"] integerValue]  == AXPublicInputTypePublicMenu) {
                self.publicMenu.frame = CGRectMake(0, self.view.frame.size.height - inputViewHeight - 44 - 20, [self windowWidth], 49);
                DLog(@"height--->>%f",self.view.frame.size.height);
                self.messageInputView.hidden = YES;
            }
        }
    }
    
    if (!self.isBroker) {
        inputView.sendButton.enabled = NO;
        [inputView.sendButton addTarget:self
                                 action:@selector(sendPressed:)
                       forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.messageInputView.textView.frame = CGRectMake(textViewRect.origin.x, textViewRect.origin.y, textViewRect.size.width - 1, textViewRect.size.height);

        self.messageInputTextViewFrame = self.messageInputView.textView.frame;
        
        [self initPrivateButtons];
//        [self initEmojiView];
        self.emojiScrollView = [[FaceScrollView alloc] init];
        self.emojiScrollView.hidden = YES;
        [self.view addSubview:self.emojiScrollView];
    }
    [self initMoreButs];
}


#pragma mark -- 是否为公众账号，显示菜单
- (BOOL)isPublicPerson{
    if (self.friendPerson.userType == AXPersonTypePublic || self.friendPerson.userType == AXPersonTypeSubscribe) {
        [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_ONVIEW page:PUBLIC_ACCOUNT_MOBILEBROKER note:[NSDictionary dictionaryWithObjectsAndKeys:[Util_TEXT logTime], @"ot" ,nil]];
        
        return YES;
    }
    
    return NO;
}

- (void)initPrivateButtons {
    float leftX = 6.0;
    
    //如果存在切换按钮，则显示之
    if (self.isMenuFlag) {
        UIButton *switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        switchBtn.frame = CGRectMake(0, 0, 48, 49);
        switchBtn.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        [switchBtn setImage:[UIImage imageNamed:@"broker_wl_gzh_a"] forState:UIControlStateNormal];
        [switchBtn setImage:[UIImage imageNamed:@"broker_wl_gzh_a_press"] forState:UIControlStateHighlighted];
        [switchBtn addTarget:self action:@selector(inputSwitch:) forControlEvents:UIControlEventTouchUpInside];
        [self.messageInputView addSubview:switchBtn];
        
        self.line = [[BrokerLineView alloc] initWithFrame:CGRectMake(48, 0, 1, 49)];
        self.line.horizontalLine = NO;
        [self.messageInputView addSubview:self.line];
        
        leftX += 48;
    }
    
    //最左侧的麦克风按钮
    self.voiceBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceBut.frame = CGRectMake(leftX, 10.0f, 28, 29);
    [self.voiceBut addTarget:self action:@selector(speeking) forControlEvents:UIControlEventTouchDown];
    [self.voiceBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameVoice] forState:UIControlStateNormal];
    [self.voiceBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameVoiceHighlight] forState:UIControlStateHighlighted];
    [self.messageInputView addSubview:self.voiceBut];
    [_buttonDict setValue:self.voiceBut forKey:AXBTKEYTALL];
    
    //最右侧的加号按钮
    self.sendBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBut.frame = CGRectMake(ScreenWidth - 35, 10.0f, 28, 29);
    self.sendBut.backgroundColor = [UIColor clearColor];
    [self.sendBut addTarget:self action:@selector(didMoreBackView:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendBut setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_add_more.png"] forState:UIControlStateNormal];
    [self.sendBut setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_add_more1.png"] forState:UIControlStateHighlighted];
    [self.messageInputView addSubview:self.sendBut];
    [_buttonDict setValue:self.sendBut forKey:AXBTKEYMORE];
    
    //中间的长按录音按钮
    self.pressSpeek = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.pressSpeek addTarget:self action:@selector(didBeginVoice) forControlEvents:UIControlEventTouchDown];
    [self.pressSpeek addTarget:self action:@selector(didCommitVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.pressSpeek addTarget:self action:@selector(didCancelVoice) forControlEvents:UIControlEventTouchUpOutside];
    [self.pressSpeek addTarget:self action:@selector(continueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
    [self.pressSpeek addTarget:self action:@selector(willCancelVoice) forControlEvents:UIControlEventTouchDragExit];
    [self.pressSpeek addTarget:self action:@selector(didInterruptRecord) forControlEvents:UIControlEventTouchCancel];
    
    
    self.pressSpeek.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.pressSpeek setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.pressSpeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.pressSpeek setTitle:@"松开结束" forState:UIControlStateHighlighted];
    [self.pressSpeek setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.pressSpeek setTitle:@"松开结束" forState:UIControlStateSelected];
    [self.pressSpeek setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    
    UIImage* imageNormal = [UIImage imageNamed:@"anjuke_icon_input_voice"];
    imageNormal = [imageNormal stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage* imageHighlighted = [UIImage imageNamed:@"anjuke_icon_input_voice_press"];
    imageHighlighted = [imageHighlighted stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [self.pressSpeek setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [self.pressSpeek setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
    [self.pressSpeek setBackgroundImage:imageHighlighted forState:UIControlStateSelected];
    
    [self.messageInputView addSubview:self.pressSpeek];
    
    //表情按钮
    self.emojiBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.emojiBut.frame = CGRectMake(ScreenWidth - 36*2, 10.0f, 28, 29);
    [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgName] forState:UIControlStateNormal];
    [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgNameHighlight] forState:UIControlStateHighlighted];
    self.emojiBut.backgroundColor = [UIColor clearColor];
    [self.emojiBut addTarget:self action:@selector(didEmojiButClick) forControlEvents:UIControlEventTouchUpInside];
    [self.messageInputView addSubview:self.emojiBut];
    [_buttonDict setValue:self.emojiBut forKey:AXBTKEYEMIJE];
}

- (void)initMoreButs {
    UIButton *pickIMG = [UIButton buttonWithType:UIButtonTypeCustom];
    pickIMG.frame = CGRectMake(17.0f, 16.0f, 46, 46);
    [pickIMG setImage:[UIImage imageNamed:@"anjuke_icon_add_pic4.png"] forState:UIControlStateNormal];
    [pickIMG addTarget:self action:@selector(pickIMG:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickIMG];
    [_buttonDict setValue:pickIMG forKey:AXBTKEYPIC];
    
    CGRect imgRect = pickIMG.frame;
    UILabel *imgLab = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    imgLab.backgroundColor = [UIColor clearColor];
    imgLab.font = [UIFont systemFontOfSize:14];
    imgLab.text = @"相册";
    imgLab.textAlignment = NSTextAlignmentCenter;
    imgLab.textColor = [UIColor axChatPropDescColor:self.isBroker];
    [self.moreBackView addSubview:imgLab];
    
    UIButton *takePic = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePic setImage:[UIImage imageNamed:@"anjuke_icon_add_takephoto4.png"] forState:UIControlStateNormal];
    takePic.frame = CGRectMake(97.0f, 16.0f, 46, 46);
    [takePic addTarget:self action:@selector(takePic:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:takePic];
    
    [_buttonDict setValue:takePic forKey:AXBTKEYTAKE];
    
    UILabel *picLab = [[UILabel alloc] initWithFrame:CGRectMake(97.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    picLab.backgroundColor = [UIColor clearColor];
    picLab.font = [UIFont systemFontOfSize:14];
    picLab.text = @"拍照";
    picLab.textAlignment = NSTextAlignmentCenter;
    picLab.textColor = [UIColor axChatPropDescColor:self.isBroker];
    [self.moreBackView addSubview:picLab];
    
    
    UIButton *pickAJK = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickAJK setImage:[UIImage imageNamed:@"anjuke_icon_add_esf.png"] forState:UIControlStateNormal];
    pickAJK.frame = CGRectMake(177.0f, 16.0f, 46, 46);
    [pickAJK setTag:-10];//为了确定二手房图标按钮
    [pickAJK addTarget:self action:@selector(pickAJK:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickAJK];

    [_buttonDict setValue:pickAJK forKey:AXBTKEYER];
    
    UILabel *ajkLab = [[UILabel alloc] initWithFrame:CGRectMake(177.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    ajkLab.backgroundColor = [UIColor clearColor];
    ajkLab.font = [UIFont systemFontOfSize:14];
    ajkLab.text = @"二手房";
    ajkLab.textAlignment = NSTextAlignmentCenter;
    ajkLab.textColor = [UIColor axChatPropDescColor:self.isBroker];
    [self.moreBackView addSubview:ajkLab];
    
    
    
    UIButton *pickHZ = [UIButton buttonWithType:UIButtonTypeCustom];
    [pickHZ setImage:[UIImage imageNamed:@"anjuke_icon_add_zf.png"] forState:UIControlStateNormal];
    pickHZ.frame = CGRectMake(257.0f, 16.0f, 46, 46);
    [pickHZ addTarget:self action:@selector(pickHZ:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:pickHZ];
    
    [_buttonDict setValue:pickHZ forKey:AXBTKEYZU];
    
    UILabel *hzLab = [[UILabel alloc] initWithFrame:CGRectMake(257.0f, imgRect.origin.y + imgRect.size.height + 8, imgRect.size.width, 30.0f)];
    hzLab.backgroundColor = [UIColor clearColor];
    hzLab.font = [UIFont systemFontOfSize:14];
    hzLab.text = @"租房";
    hzLab.textAlignment = NSTextAlignmentCenter;
    hzLab.textColor = [UIColor axChatPropDescColor:self.isBroker];
    [self.moreBackView addSubview:hzLab];
    
    UIButton *location = [UIButton buttonWithType:UIButtonTypeCustom];
    location.frame = CGRectMake(17.0f, 16.0f + 107.0f, 46, 46);
    [location setImage:[UIImage imageNamed:@"anjuke_icon_add_position.png"] forState:UIControlStateNormal];
    [location addTarget:self action:@selector(locationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBackView addSubview:location];
    
    [_buttonDict setValue:location forKey:AXBTKEYLOCAL];
    
    CGRect locationRect = location.frame;
    UILabel *locationLab = [[UILabel alloc] initWithFrame:CGRectMake(17.0f, locationRect.origin.y + locationRect.size.height + 8, locationRect.size.width, 30.0f)];
    locationLab.backgroundColor = [UIColor clearColor];
    locationLab.font = [UIFont systemFontOfSize:14];
    locationLab.text = @"位置";
    locationLab.textAlignment = NSTextAlignmentCenter;
    locationLab.textColor = [UIColor axChatPropDescColor:self.isBroker];
    [self.moreBackView addSubview:locationLab];
}

- (void)initBlock
{
    __weak AXChatViewController *blockSelf = self;
    // 重发消息的block
    self.finishReSendMessageBlock = ^ (NSArray *messages, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorCode) {
        for (AXMappedMessage *message in messages) {
        
        NSMutableDictionary *textData = [NSMutableDictionary dictionary];
        textData = [blockSelf mapAXMappedMessage:message];
        if (textData) {
            if ([message.messageType isEqualToNumber:@(AXMessageTypeSystemTime)]) {
                if (status == AXMessageCenterSendMessageStatusSending) {
                    textData[@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                    textData[AXCellIdentifyTag] = message.identifier;
                    [blockSelf appendCellData:textData];
                }
                continue;
            }
            if (status == AXMessageCenterSendMessageStatusSending) {
                textData[@"status"] = @(AXMessageCenterSendMessageStatusSending);
                textData[AXCellIdentifyTag] = message.identifier;
                [blockSelf appendCellData:textData];
                [blockSelf scrollToBottomAnimated:YES];
            } else if (status == AXMessageCenterSendMessageStatusFailed) {
                [[BrokerLogger sharedInstance] logWithActionCode:CHAT_SEND_FAIL page:CHAT note:nil];
                
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusFailed);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            if (errorCode == AXMessageCenterSendMessageErrorTypeCodeNotFriend && blockSelf.isBroker) {
                [blockSelf sendSystemMessage:AXMessageTypeSystemForbid];
            }
        }
            
        }
    };
    
    self.finishSendMessageBlock = ^ (NSArray *messages, AXMessageCenterSendMessageStatus status, AXMessageCenterSendMessageErrorTypeCode errorCode) {
        for (AXMappedMessage *message in messages) {

        NSMutableDictionary *textData = [NSMutableDictionary dictionary];
        textData = [blockSelf mapAXMappedMessage:message];
        if (textData) {
            if ([message.messageType isEqualToNumber:@(AXMessageTypeSystemTime)]) {
                if (status == AXMessageCenterSendMessageStatusSending) {
                    textData[@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                    textData[AXCellIdentifyTag] = message.identifier;
                    [blockSelf appendCellData:textData];
                }
                continue;
            }

            if (status == AXMessageCenterSendMessageStatusSending) {
                textData[@"status"] = @(AXMessageCenterSendMessageStatusSending);
                textData[AXCellIdentifyTag] = message.identifier;
                [blockSelf axAddCellData:textData];
            } else if (status == AXMessageCenterSendMessageStatusFailed) {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusFailed);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                NSUInteger index = [blockSelf.identifierData indexOfObject:message.identifier];
                blockSelf.cellDict[message.identifier][@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
                [blockSelf.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
            if (errorCode == AXMessageCenterSendMessageErrorTypeCodeNotFriend && blockSelf.isBroker) {
                [blockSelf sendSystemMessage:AXMessageTypeSystemForbid];
            }
        }
        }
    };
}

- (void)initEmojiView {
        self.emojiScrollView.frame = CGRectMake(0, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXMoreBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);

        
        //        NSLog(@"%d", self.messageInputView.textView.text.length);
//        if (self.messageInputView.textView.text.length > 0) {
            self.emojiScrollView.sendButton.enabled = YES;
            [self.emojiScrollView.sendButton setBackgroundColor:[UIColor colorWithRed:79.0/255 green:164.0/255 blue:236.0/255 alpha:1]];
            [self.emojiScrollView.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        }
    
        __weak AXChatViewController* this = self;
        self.emojiScrollView.sendButtonClick = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [this sendMessage:nil];
                this.emojiScrollView.sendButton.enabled = NO;
                [this.emojiScrollView.sendButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
                [this.emojiScrollView.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            });
        };
        
        self.emojiScrollView.faceView.faceClickBlock = ^(NSString* name){
            dispatch_async(dispatch_get_main_queue(), ^{
//                int this.cursorLocation = 0;

                this.cursorLocation = this.messageInputView.textView.selectedRange.location; //获取光标所在的位置
                //returns NSNotFound when the object is not present in the array.
                //NSNotFound is defined as NSIntegerMax (== 2147483647 on iOS 32 bit).
                if (this.cursorLocation == NSIntegerMax) {
                    this.cursorLocation = 0;
                }

                NSString *content = this.messageInputView.textView.text;
                
                if ([@"delete" isEqualToString:name]) {
                    NSString* newStr = nil;
                    if (this.messageInputView.textView.text.length>0 && this.cursorLocation > 0) {
                        NSRange rangeEmoji = NSMakeRange(this.cursorLocation-2, 2);
                        NSRange rangeText = NSMakeRange(this.cursorLocation-1, 1);
                        if ([[this.emojiScrollView.faceView emojis] containsObject:[this.messageInputView.textView.text substringWithRange:rangeEmoji]]) {
                            NSLog(@"删除emoji %@",[this.messageInputView.textView.text substringWithRange:rangeEmoji]);
                            
                            // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
                            newStr = [NSString stringWithFormat:@"%@%@",[content substringToIndex:this.cursorLocation-2],[content substringFromIndex:this.cursorLocation]];
                            this.messageInputView.textView.text = newStr;
                            this.messageInputView.textView.selectedRange = NSMakeRange(this.cursorLocation-2, 0);
                            
                        }else{
                            NSLog(@"删除文字%@",[this.messageInputView.textView.text substringWithRange:rangeText]);
                            
                            // 将UITextView中的内容进行调整（主要是在光标所在的位置进行字符串截取，再拼接你需要插入的文字即可）
                            newStr = [NSString stringWithFormat:@"%@%@",[content substringToIndex:this.cursorLocation-1],[content substringFromIndex:this.cursorLocation]];
                            this.messageInputView.textView.text = newStr;
                            this.messageInputView.textView.selectedRange = NSMakeRange(this.cursorLocation-1, 0);
                        }
                        
                        if (this.messageInputView.textView.text.length == 0) {
                            this.emojiScrollView.sendButton.enabled = NO;
                            [this.emojiScrollView.sendButton setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
                            [this.emojiScrollView.sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                        }
                        
                    }
                }else{
                    if (!this.emojiScrollView.sendButton.enabled) {
                        this.emojiScrollView.sendButton.enabled = YES;
                        [this.emojiScrollView.sendButton setBackgroundColor:[UIColor colorWithRed:79.0/255 green:164.0/255 blue:236.0/255 alpha:1]];
                        [this.emojiScrollView.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                    NSString* newStr = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:this.cursorLocation], name, [content substringFromIndex:this.cursorLocation]];
                    this.messageInputView.textView.text = newStr;
                    this.messageInputView.textView.selectedRange = NSMakeRange(this.cursorLocation+2, 0);

                }
            });
            
        };
}

- (void)fetchLastChatList
{
    AXMappedMessage *lastMessage = [[AXMappedMessage alloc] init];
    lastMessage.sendTime = [NSDate dateWithTimeIntervalSinceNow:0];
    lastMessage.from = self.currentPerson.uid;
    lastMessage.to  = [self checkFriendUid];
    lastMessage.orderNumber = NSIntegerMax;
    __weak AXChatViewController *blockSelf = self;
    
    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:lastMessage pageSize:AXMessagePageSize callBack:^(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        blockSelf.hasMore = [chatList[@"hasMore"] boolValue];
        if (blockSelf.hasMore) {
            self.pullToRefreshView.delegate = self;
        } else {
            if (blockSelf.friendPerson.markName.length == 0 && blockSelf.friendPerson.userType == AXPersonTypeUser) {
                [blockSelf sendSystemMessage:AXMessageTypeAddNote];
            }
            self.pullToRefreshView.delegate = nil;
        }
        NSArray *chatArray = chatList[@"messages"];
        if ([chatArray isKindOfClass:[NSArray class]] && [chatArray count] > 0) {
            blockSelf.lastMessage = chatArray[0];
            for (AXMappedMessage *mappedMessage in chatArray) {
                NSMutableDictionary *dict = [blockSelf mapAXMappedMessage:mappedMessage];
                if (!dict) {
                    continue;
                }
                if ([mappedMessage.from isEqualToString:[blockSelf checkFriendUid]]) {
                    dict[@"messageSource"] = @(AXChatMessageSourceDestinationIncoming);
                }
                
                [blockSelf.identifierData addObject:mappedMessage.identifier];
                blockSelf.cellDict[mappedMessage.identifier] = dict;
            }
            [blockSelf.myTableView reloadData];
            [blockSelf reloadDataFinish];
            [blockSelf scrollToBottomAnimated:NO];
        } else {
            if (blockSelf.propDict && [blockSelf.identifierData count] == 0) {
                [blockSelf sendSystemMessage:AXMessageTypeSendProperty];
            }
        }

        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
            [blockSelf sendSystemMessage:AXMessageTypeSettingNotifycation];
        }
        
        [blockSelf addMessageNotifycation];
    }];
}

- (void)restoreDraftContent {
    if (!self.isFinished) {
        self.isFinished = YES;
        if (self.conversationListItem) {
            if (!self.previousTextViewContentHeight) {
                self.previousTextViewContentHeight = self.messageInputView.textView.contentSize.height;
            }
            self.messageInputView.textView.text = self.conversationListItem.draftContent;
        }
        [self scrollToBottomAnimated:NO];
    }
}

- (CGSize)sizeOfString:(NSString *)string maxWidth:(float)width withFontSize:(UIFont *)fontSize {
    return [string rtSizeWithFont:fontSize constrainedToSize:CGSizeMake(width, 10000.0f) lineBreakMode:NSLineBreakByCharWrapping];
}

- (void)sendPropMessage
{
    // 如果第一次发消息，发送房源信息
    if (self.propDict && self.needSendProp) {
        NSMutableDictionary *propDict = [NSMutableDictionary dictionaryWithDictionary:self.propDict];
        propDict[@"jsonVersion"] = AXChatJsonVersion;
        self.needSendProp = NO;
        AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
        mappedMessageProp.accountType = [self checkAccountType];
        mappedMessageProp.content = [propDict RTJSONRepresentation];
        mappedMessageProp.to = [self checkFriendUid];
        mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
        mappedMessageProp.isRead = YES;
        mappedMessageProp.isRemoved = NO;
        mappedMessageProp.messageType = @(AXMessageTypeProperty);
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessageProp willSendMessage:self.finishSendMessageBlock];
    }
}

- (void)addMessageNotifycation
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:MessageCenterDidReceiveNewMessage object:nil];
}


- (void)inputSwitch:(id)sender{
    [self didClickKeyboardControl];
    
    [self.messageInputView.textView resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.messageInputView.frame = CGRectMake(0, self.view.frame.size.height, [self windowWidth], self.messageInputView.frame.size.height);
        self.publicMenu.frame = CGRectMake(0, self.view.frame.size.height - 49, [self windowWidth], 49);
    } completion:^(BOOL finished) {
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.publicMenu.top - AXNavBarHeight];
        [self scrollToBottomAnimated:YES];
    }];
}

#pragma mark --publicMenuDelegate
- (void)publicMenuShowSubMenu:(AXPublicMenuButton *)button menus:(NSArray *)menus{
    self.keyboardControl.hidden = NO;

    if (self.publicSubMenu && self.publicSubMenu.subMenuindex == button.index){
        CGRect frame = self.publicSubMenu.frame;
        frame.origin.y = self.view.height;
        //先移除submenu，再显示当前submenu
        [UIView animateWithDuration:.2 animations:^{
            self.publicSubMenu.frame = frame;
        } completion:^(BOOL finished) {
            [self.publicSubMenu removeFromSuperview];
            self.publicSubMenu = nil;
            self.keyboardControl.hidden = YES;
        }];
    }else if (self.publicSubMenu && self.publicSubMenu.subMenuindex != button.index){
        [self hideSubmenu:^(BOOL isFinished) {
            
            self.keyboardControl.hidden = NO;
            self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);
            
            [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_MENU page:PUBLIC_ACCOUNT_MOBILEBROKER note:[NSDictionary dictionaryWithObjectsAndKeys:@"menuid",button.btnInfo[@"menu_id"], nil]];
            
            self.publicSubMenu =[[AXPublicSubMenu alloc] init];
            self.publicSubMenu.publicSubMenuDelegate = self;
            self.publicSubMenu.subMenuindex = button.index;
            [self.publicSubMenu configPublicSubMenu:button menu:menus];
            [self.view insertSubview:self.publicSubMenu belowSubview:self.publicMenu];
            
            CGRect subMenuFrame = self.publicSubMenu.frame;
            subMenuFrame.origin.y = self.publicSubMenu.frame.origin.y - self.publicSubMenu.frame.size.height - 10;
            DLog(@"1hidden--->>%d",self.keyboardControl.hidden);
            [UIView animateWithDuration:.2 animations:^{
                self.publicSubMenu.frame = subMenuFrame;
            } completion:^(BOOL finished) {
            }];
        }];
    }else{
        self.keyboardControl.hidden = NO;
        self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49);

        [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_MENU page:PUBLIC_ACCOUNT_MOBILEBROKER note:[NSDictionary dictionaryWithObjectsAndKeys:@"menuid",button.btnInfo[@"menu_id"], nil]];
        
        self.publicSubMenu =[[AXPublicSubMenu alloc] init];
        self.publicSubMenu.publicSubMenuDelegate = self;
        self.publicSubMenu.subMenuindex = button.index;
        [self.publicSubMenu configPublicSubMenu:button menu:menus];
        [self.view insertSubview:self.publicSubMenu belowSubview:self.publicMenu];
        
        CGRect subMenuFrame = self.publicSubMenu.frame;
        subMenuFrame.origin.y = self.publicSubMenu.frame.origin.y - self.publicSubMenu.frame.size.height - 10;
        DLog(@"2hidden--->>%d",self.keyboardControl.hidden);
        [UIView animateWithDuration:.2 animations:^{
            self.publicSubMenu.frame = subMenuFrame;
        } completion:^(BOOL finished) {
        }];
    }
}


- (void)publicMenuWithAPI:(AXPublicMenuButton *)button actionStr:(NSString *)actionStr{
    [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_MENU page:PUBLIC_ACCOUNT_MOBILEBROKER note:[NSDictionary dictionaryWithObjectsAndKeys:@"menuid",button.btnInfo[@"menu_id"], nil]];

    [self publicEventWithApi:actionStr];
}
- (void)publicMenuWithURL:(AXPublicMenuButton *)button webURL:(NSString *)webURL{
    [self hideSubmenu:^(BOOL isFinished) {
    }];
    [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_MENU page:PUBLIC_ACCOUNT_MOBILEBROKER note:[NSDictionary dictionaryWithObjectsAndKeys:@"menuid",button.btnInfo[@"menu_id"], nil]];
    
    AXChatWebViewController *webVC = [[AXChatWebViewController alloc] init];
    webVC.webUrl = [NSString stringWithFormat:@"%@",webURL];
    [webVC setTitleViewWithString:button.btnInfo[@"menu_title"]];
    [self.navigationController pushViewController:webVC animated:YES];

    [self hidePublicLoadView];
}
- (void)publicMenuSwich{
    [self hideSubmenu:^(BOOL isFinished) {
        nil;
    }];
    [self.messageInputView.textView resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.messageInputView.frame = CGRectMake(0, self.view.frame.size.height-self.messageInputView.frame.size.height, [self windowWidth], self.messageInputView.frame.size.height);
        self.publicMenu.frame = CGRectMake(0, self.view.frame.size.height, [self windowWidth], 49);
        [self setTableViewInsetsWithBottomValue:self.myTableView.contentInset.bottom];
    } completion:^(BOOL finished) {
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.messageInputView.top - AXNavBarHeight];
        [self scrollToBottomAnimated:YES];
    }];
}

#pragma mark --AXPublicSubMenuDelegate
- (void)publicSubMenuWithAPI:(AXPublicMenuButton *)button actionStr:(NSString *)actionStr{
    [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_MENU page:PUBLIC_ACCOUNT_MOBILEBROKER note:[NSDictionary dictionaryWithObjectsAndKeys:@"menuid",button.btnInfo[@"menu_id"], nil]];

    [self publicEventWithApi:actionStr];
}

- (void)publicSubMenuWithURL:(AXPublicMenuButton *)button webURL:(NSString *)webURL{
    [self hideSubmenu:^(BOOL isFinished) {
        [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_MENU page:PUBLIC_ACCOUNT_MOBILEBROKER note:[NSDictionary dictionaryWithObjectsAndKeys:@"menuid",button.btnInfo[@"menu_id"], nil]];

        AXChatWebViewController *webVC = [[AXChatWebViewController alloc] init];
        webVC.webUrl = [NSString stringWithFormat:@"%@",webURL];
        [webVC setTitleViewWithString:button.btnInfo[@"menu_title"]];
        [self.navigationController pushViewController:webVC animated:YES];
        [self hidePublicLoadView];

        
//        NSError *error;
//        //http+:[^\\s]* 这是检测网址的正则表达式
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http://([w-]+.)+[w-]+(/[w[/url]- ./?%&=]*)?" options:0 error:&error];
//        
//        DLog(@"webURL--->>%@",webURL);
//        if (regex != nil) {
//            NSTextCheckingResult *firstMatch = [regex firstMatchInString:webURL options:0 range:NSMakeRange(0, [webURL length])];
//            if (firstMatch) {
//                AXChatWebViewController *webVC = [[AXChatWebViewController alloc] init];
//                webVC.webUrl = [NSString stringWithFormat:@"%@&city_id=%@",webURL,[LoginManager getCity_id]];
//                webVC.title = button.btnInfo[@"menu_title"];
//                [self.navigationController pushViewController:webVC animated:YES];
//                [self hidePublicLoadView];
//            }else{
//                AXChatWebViewController *webVC = [[AXChatWebViewController alloc] init];
//                webVC.webUrl = [NSString stringWithFormat:@"%@?city_id=%@",webURL,[LoginManager getCity_id]];
//                webVC.title = button.btnInfo[@"menu_title"];
//                [self.navigationController pushViewController:webVC animated:YES];
//                [self hidePublicLoadView];
//            }
//        }
    }];
}

- (void)hideSubmenu:(void(^)(BOOL isFinished))hideSubMenuFinished{
    self.subMenuHideFinish = hideSubMenuFinished;

    if (!self.publicSubMenu) {
        return;
    }
    CGRect frame = self.publicSubMenu.frame;
    frame.origin.y = self.view.frame.size.height - 49;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.publicSubMenu.frame = frame;
    } completion:^(BOOL finished) {
        [self.publicSubMenu removeFromSuperview];
        self.publicSubMenu = nil;
        
        self.keyboardControl.hidden = YES;
        
        self.subMenuHideFinish(YES);
    }];
}

- (void)showPublicLoadView{
    if (self.publicLoadView) {
        [self.publicLoadView removeFromSuperview];
    }
    self.publicLoadView = [[AXPublicLoading alloc] init];
    [self.view addSubview:self.publicLoadView];

}
- (void)hidePublicLoadView{
    if (self.publicLoadView) {
        [self.publicLoadView removeFromSuperview];
        self.publicLoadView = nil;
    }
}

- (void)publicEventWithApi:(NSString *)actionStr{
    [self showPublicLoadView];
    [self hideSubmenu:^(BOOL isFinished) {

        [[AXChatMessageCenter defaultMessageCenter] publicServiceSendActionByServiceId:[self checkFriendUid] actionID:actionStr cityID:[LoginManager getCity_id] userID:self.currentPerson.uid];
    }];
}

#pragma mark - Public Method
//初始化learnview的bt
- (void)initButtonInLearnView
{
    NSDictionary *btDict = self.buttonDict;
    
    UIButton *getPic = [btDict objectForKey:AXBTKEYPIC];
    UIButton *takePic = [btDict objectForKey:AXBTKEYTAKE];
    DLog(@"takePic == %@", takePic);
    //    UIButton *erShou = [btDict objectForKey:AXBTKEYER];
    UIButton *zuFang = [btDict objectForKey:AXBTKEYZU];
    UIButton *local = [btDict objectForKey:AXBTKEYLOCAL];
    UIButton *speak = [btDict objectForKey:AXBTKEYTALL];
    UIButton *emjle = [btDict objectForKey:AXBTKEYEMIJE];
//    UIButton *more = [btDict objectForKey:AXBTKEYMORE];
    
    [getPic removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [takePic removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [zuFang removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [local removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [speak removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [emjle removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//    [more removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
}

- (BOOL)checkUserLogin
{
    return YES;
}

- (AXMappedMessage *)sendSystemMessage:(AXMessageType)type content:(NSString *)con messageId:(NSString *)messId
{
    self.needSendProp = YES;
    AXMappedMessage *mappedMessageProp = [[AXMappedMessage alloc] init];
    mappedMessageProp.accountType = [self checkAccountType];
    mappedMessageProp.content = con;
    mappedMessageProp.to = [self checkFriendUid];
    mappedMessageProp.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessageProp.isRead = YES;
    mappedMessageProp.isRemoved = NO;
    mappedMessageProp.messageType = @(type);
    if (messId)
    {
        mappedMessageProp.messageId = [NSNumber numberWithInt:[messId integerValue]];
    }
    
    NSMutableDictionary *textData = [NSMutableDictionary dictionary];
    textData = [self mapAXMappedMessage:mappedMessageProp];
    if (textData) {
        NSString *identifier = [[NSProcessInfo processInfo] globallyUniqueString];
        textData[@"status"] = @(AXMessageCenterSendMessageStatusSuccessful);
        textData[AXCellIdentifyTag] = [NSString stringWithFormat:@"SystemMessage%@", identifier];
        [self appendCellData:textData];
        [self scrollToBottomAnimated:YES];
    }
    
    return mappedMessageProp;
}

- (void)sendSystemMessage:(AXMessageType)type
{
    [self sendSystemMessage:type content:@"" messageId:nil];
}

- (NSMutableAttributedString *)configAttributedString:(NSString *)text
{
    NSMutableAttributedString* mas = [NSMutableAttributedString attributedStringWithString:text];
    [mas setFont:[UIFont systemFontOfSize:16]];
    [mas setTextColor:[UIColor blackColor]];
    [mas setTextAlignment:kCTTextAlignmentLeft lineBreakMode:kCTLineBreakByWordWrapping];
    return mas;
}

#pragma mark - Public Method
- (NSDate *)formatterDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd";
    NSString *nowDateStr = [df stringFromDate:date];
    return [df dateFromString:nowDateStr];
}

- (void)reloadUnReadNum:(NSInteger)num
{
    // do nothing
}

- (void)sendMessageAppLog
{
    // do nothing
}

- (void)clickRightNavButtonAppLog
{
    // do nothing
}

- (void)clickLeftAvatarAppLog
{
    // do nothing
}

- (void)clickInputViewAppLog
{
    // do nothing
}

- (void)clickLocationLog{
    // do nothing
}
- (void)switchToVoiceLog{
    // do nothing
}
- (void)switchToTextLog{
    // do nothing
}
- (void)pressForVoiceLog{
    // do nothing
}
- (void)cancelSendingVoiceLog{
    // do nothing
}

#pragma mark - DataSouce Method
- (NSString *)checkFriendUid
{
    if (self.uid) {
        return self.uid;
    }
    return @"";
}

- (NSString *)checkAccountType
{
    if (self.isBroker) {
        return @"2";
    } else {
        return @"1";
    }
}

- (NSString *)fixedImgPath:(NSString *) imgPath {
    NSString *libPath = [AXPhotoManager getLibrary:nil];
    
    NSArray *imgArray = [imgPath componentsSeparatedByString:@"/"];
    
    NSString *resultPath = [NSString stringWithFormat:@"%@/%@/%@",libPath ,[imgArray objectAtIndex:[imgArray count] - 2], [imgArray objectAtIndex:[imgArray count] - 1]];
    
    
    return resultPath;
}
- (NSString *)fixThumbnailImagePath:(NSString *)path
{
    if (path && path.length > 0) {
        NSArray *arr = [path componentsSeparatedByString:@"/"];
        return [AXPhotoManager getLibrary:[arr lastObject]];
    }
    return @"";
}
- (NSMutableDictionary *)mapAXMappedMessage:(AXMappedMessage *)mappedMessage
{
    NSNumber *messageSource = @(AXChatMessageSourceDestinationIncoming);
    if (![mappedMessage.to isEqualToString:[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid]) {
        messageSource = @(AXChatMessageSourceDestinationOutPut);
    } else {
        messageSource = @(AXChatMessageSourceDestinationIncoming);
    }
    NSMutableDictionary *textData;

    switch ([mappedMessage.messageType integerValue]) {
        case AXMessageTypeText:
        {
            if (![self.contentValidator checkText:mappedMessage.content]) {
                return nil;
            }
             textData = [self configTextCellData:[NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeText), @"content":mappedMessage.content, @"messageSource":messageSource}]];
        }
            break;
        case AXMessageTypePic:
        {
            NSData *imgData = nil;
                if (mappedMessage.imgPath.length == 0) {
                    imgData = [NSData dataWithContentsOfFile:[self fixThumbnailImagePath:mappedMessage.thumbnailImgPath]];
                } else {
                    imgData = [NSData dataWithContentsOfFile:[self fixedImgPath:mappedMessage.imgPath]];
                }
            
            if (!imgData) {
                return nil;
            }
            UIImage *img = [UIImage imageWithData:imgData];
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypePic), @"content":img, @"messageSource":messageSource, @"identifier":mappedMessage.identifier}];
        }
            break;
            
        case AXMessageTypeProperty:
        {
            if (![self.contentValidator checkPropertyCard:mappedMessage.content]) {
                return nil;
            }
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeProperty),@"content":mappedMessage.content,@"messageSource":messageSource}];
        }
            break;
            
        case AXMessageTypeJinpuProperty:
        {
            if (![self.contentValidator checkPropertyCard:mappedMessage.content]) {
                return nil;
            }
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeJinpuProperty),@"content":mappedMessage.content,@"messageSource":messageSource}];
        }
            break;

        case AXMessageTypeVoice:
        {
            if (![self.contentValidator checkVoice:mappedMessage.content] || !mappedMessage.imgPath || [mappedMessage.imgPath length] == 0) {
                return nil;
            }
            
            NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
            NSString *voicePath = [NSString stringWithFormat:@"%@/%@", path, mappedMessage.imgPath];
            if (![[NSFileManager defaultManager] fileExistsAtPath:voicePath]) {
                return nil;
            }
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeVoice), @"content":mappedMessage.content, @"messageSource":messageSource, @"identifier":mappedMessage.identifier}];
        }
            break;
        case AXMessageTypeLocation:
        {
            if (![self.contentValidator checkLocation:mappedMessage.content]) {
                return nil;
            }
            NSDictionary *tempdic = [mappedMessage.content JSONValue];
            if ([tempdic[@"address"] length] == 0){
                [self reloadLocation:mappedMessage];
            }
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeLocation),@"content":mappedMessage.content,@"messageSource":messageSource}];
            
        }
            break;
        case AXMessageTypePublicCard:
        {
            if (![self.contentValidator checkPublicCard:mappedMessage.content]) {
                return nil;
            }
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypePublicCard),@"content":mappedMessage.content,@"messageSource":messageSource}];
        }
            break;
        case AXMessageTypePublicCard3:
        {
            if (![self.contentValidator checkPublicCard3:mappedMessage.content]) {
                return nil;
            }
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypePublicCard3),@"content":mappedMessage.content,@"messageSource":messageSource}];
        }
            break;
        case AXMessageTypeSystemTime:
        {
            if (!mappedMessage.sendTime) {
                return nil;
            }
            NSTimeInterval since = [[self formatterDate:[NSDate date]] timeIntervalSinceDate:[self formatterDate:mappedMessage.sendTime]];
            NSDateFormatter *dateFormatrer = [[NSDateFormatter alloc] init];
            dateFormatrer.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            if (since < 3600 * 24) {
                dateFormatrer.dateFormat = @"HH:mm";
            } else {
                dateFormatrer.dateFormat = @"MM月dd日 HH:mm";
            }
            NSString *timeContent =  [dateFormatrer stringFromDate:mappedMessage.sendTime];
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSystemTime),@"content":timeContent,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
            
        case AXMessageTypeSystemForbid:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSystemForbid),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];

        }
            break;
        case AXMessageTypeSettingNotifycation:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSettingNotifycation),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationIncoming)}];
        }
            break;
        case AXMessageTypeSenpropSuccess:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSenpropSuccess),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeWillSenprop:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeWillSenprop),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
            
        case AXMessageTypeAddNuckName:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeAddNuckName),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeAddNote:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeAddNote),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeSendProperty:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSendProperty),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeSafeMessage:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeSafeMessage),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
            break;
        case AXMessageTypeVersion:
        {
            textData = [NSMutableDictionary dictionaryWithDictionary:@{@"messageType":@(AXMessageTypeVersion),@"content":mappedMessage.content,@"messageSource":@(AXChatMessageSourceDestinationOutPut)}];
        }
        default:
            break;
    }
    textData[@"mappedMessage"] = mappedMessage;
    if (mappedMessage.identifier) {
        textData[AXCellIdentifyTag] = mappedMessage.identifier;
    }
    if (mappedMessage.sendStatus) {
        textData[@"status"] = mappedMessage.sendStatus;
    }
    return textData;
}

- (void)reloadLocation:(AXMappedMessage *)mappedMessage {
    [[LocationManager defaultLocationManager] locationByMessage:mappedMessage target:self action:@selector(didFinishGetAddress:)];
}

- (void)didFinishGetAddress:(AXNetWorkResponse *) response {
    RTNetworkResponse *requestResponse = response.response;
//    AXMappedMessage *message = response.message;

    if (response.sendStatus == 1) {
        [self.locationArray addObject:response];
    }else {
    [self.locationArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        AXNetWorkResponse *locationResponse = (AXNetWorkResponse *)obj;
        
        if (locationResponse.requestID == requestResponse.requestID) {
        
            NSArray *tempArray = [NSArray arrayWithArray:[requestResponse.content objectForKey:@"results"]];
            if (requestResponse.content && requestResponse.status == RTNetworkResponseStatusSuccess && [tempArray count] > 0) {
                NSMutableDictionary *data = [locationResponse.message.content JSONValue];
                if (data && [data[@"address"] length] == 0) {
                    data[@"address"] = [[tempArray objectAtIndex:0] objectForKey:@"formatted_address"];
                    locationResponse.message.content = [data RTJSONRepresentation];
                    NSMutableDictionary *dict = self.cellDict[locationResponse.message.identifier];
                    if (dict) {
                        dict[@"content"] = [data RTJSONRepresentation];
                        self.cellDict[locationResponse.message.identifier] = dict;
                    }
                    NSUInteger index = [self.identifierData indexOfObject:locationResponse.message.identifier];
                    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    [[AXChatMessageCenter defaultMessageCenter] updateMessageWithIdentifier:locationResponse.identify keyValues:@{@"content":locationResponse.message.content}];
                }
            }
            
        }
    }];
    }
   
}
- (void)downLoadIcon {
    //保存头像
    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
    if (person.iconPath.length < 2) {
        __weak AXChatViewController *blockSelf = self;
        [self.imgDownloader dowloadIMGWithURL:[NSURL URLWithString:[LoginManager getUse_photo_url]] resultBlock:^(RTNetworkResponse *response) {
            if (response.status == 2) {
                if (response.content && [response.content objectForKey:@"imagePath"]) {
                    UIImage *image = [UIImage imageWithContentsOfFile:[response.content objectForKey:@"imagePath"]];
                    NSArray*libsPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                    NSString*libPath = [libsPath objectAtIndex:0];
                    NSString *userFolder = [libPath stringByAppendingPathComponent:[LoginManager getChatID]];
                    if ([UIImageJPEGRepresentation(image, 0.96) writeToFile:userFolder atomically:YES]) {
                    }else{
                    }
                    AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
                    person.iconUrl = [LoginManager getUse_photo_url];
                    person.iconPath = [LoginManager getChatID];
                    person.isIconDownloaded = YES;
                    [[AXChatMessageCenter defaultMessageCenter] updatePerson:person];
                    if (blockSelf) {
                        [blockSelf.myTableView reloadData];
                        [blockSelf reloadDataFinish];
                        AXMappedPerson *person = [[AXChatMessageCenter defaultMessageCenter] fetchPersonWithUID:[LoginManager getChatID]];
                        blockSelf.currentPerson = person;
                    }
                }
            }
        }];
    }
}
- (void)axAddCellData:(NSDictionary *)msgData
{
    [self.identifierData addObject:msgData[AXCellIdentifyTag]];
    self.cellDict[msgData[AXCellIdentifyTag]] = msgData;
    [self.myTableView reloadData];
    [self reloadDataFinish];
    [self scrollToBottomAnimated:YES];
}

- (void)appendCellData:(NSDictionary *)msgData
{
    UITableViewRowAnimation insertAnimation = UITableViewRowAnimationBottom;
    if ([self.identifierData containsObject:msgData[AXCellIdentifyTag]]) {
        NSInteger row = [self.identifierData indexOfObject:msgData[AXCellIdentifyTag]];
        [self.identifierData removeObjectAtIndex:row];
        [self.cellDict removeObjectForKey:msgData[AXCellIdentifyTag]];
        [self.myTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]  withRowAnimation:UITableViewRowAnimationNone];
        insertAnimation = UITableViewRowAnimationNone;
    }
    [self.identifierData addObject:msgData[AXCellIdentifyTag]];
    self.cellDict[msgData[AXCellIdentifyTag]] = msgData;
    
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:[self.identifierData count] - 1 inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:insertAnimation];
    [self reloadDataFinish];
}

- (void)insertCellData:(NSDictionary *)msgData atIndex:(NSUInteger)index
{
    [self.identifierData insertObject:msgData[AXCellIdentifyTag] atIndex:index];
    self.cellDict[msgData[AXCellIdentifyTag]] = msgData;
    NSMutableArray *insertIndexPaths = [NSMutableArray array];
    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:index inSection:0];
    [insertIndexPaths addObject:newPath];
    [self.myTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    [self.myTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    [self reloadDataFinish];
}

#pragma mark - SSPullToRefresh
- (void)initPullToRefresh
{
    self.pullToRefreshView = [[AXPullToRefreshView alloc] initWithScrollView:self.myTableView delegate:self];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.identifierData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = (self.identifierData)[[indexPath row]];
    NSDictionary *dic = self.cellDict[identifier];
    if (dic[@"messageType"] && ([dic[@"messageType"] isEqualToNumber:@(AXMessageTypeProperty)] || [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeJinpuProperty)])) {
        // 房源
        return 105 + 20;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeText)]) {
        CGFloat rowHeight = [dic[@"rowHeight"] floatValue] + 2*kLabelVMargin + 20;
        return rowHeight;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypePic)]) {
        if ([AXChatMessageImageCell sizeOFImg:dic[@"content"]].size.height < 30.0f) {
            return 65.0f;
        }
        return [AXChatMessageImageCell sizeOFImg:dic[@"content"]].size.height + 20.0f;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)]) {
        return 25;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypePublicCard)]) {
        return 290 + 40;
    }
    else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypePublicCard3)]) {
        NSArray *arr = [[NSArray alloc] initWithArray:[[dic[@"content"] JSONValue] objectForKey:@"articles"]];
        return (arr.count - 1)*66 + 156 + 10;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemForbid)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeAddNuckName)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSettingNotifycation)]) {
        return 60;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeAddNote)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSendProperty)]) {
        return 45;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeSafeMessage)]) {
        return 75;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeVoice)]) {
        return 60.0f;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeLocation)]) {
        return 140.0f;
    } else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToNumber:@(AXMessageTypeVersion)]) {
        CGSize textSize = [dic[@"content"] rtSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(240.0f, CGFLOAT_MAX)];
        return textSize.height + AXChatMessageSystemTimeCellMarginTop * 2 + 20;
    }else {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[AXChatMessageVoiceCell class]]) {
        [((AXChatMessageVoiceCell *)cell) resetPlayer:self.playingIdentifier];
    }
}

#pragma mark - UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = (self.identifierData)[[indexPath row]];
    NSDictionary *dic = self.cellDict[identifier];
    
    AXChatBaseCell *cell = [AXCellFactory cellForTableView:tableView atIndexPath:indexPath withObject:dic withIdentity:[NSString stringWithFormat:@"AXChatCell%@", dic[@"messageType"]]];
    [UIView setAnimationsEnabled:NO];

    cell.delegate = self;
    cell.isBroker = self.isBroker;
    cell.messageSource = [self messageSource:dic];
    cell.messageStatus = AXMessageCenterSendMessageStatusSending;
    if ([dic[@"messageSource"] isEqualToNumber:@(AXChatMessageSourceDestinationOutPut)]) {
        [cell configAvatar:self.currentPerson];
    } else {
        [cell configAvatar:self.friendPerson];
    }
    [cell configWithData:dic];
    [cell configWithIndexPath:indexPath];
    [UIView setAnimationsEnabled:YES];

    return cell;
}

#pragma mark -- AXChatMessagePublicCard3CellDelegate
- (void)didOpenPublicCard3:(AXChatMessagePublicCard3Cell *)cell senderInfo:(NSDictionary *)senderInfo{
    [[BrokerLogger sharedInstance] logWithActionCode:PUBLIC_ACCOUNT_MOBILEBROKER_CLICK_ARTICLE page:CHAT note:nil];
    
    AXChatWebViewController *webVC = [[AXChatWebViewController alloc] init];
    webVC.webUrl = senderInfo[@"url"];
    webVC.webTitle = senderInfo[@"title"];
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - AJKChatMessageTextCell
- (NSMutableDictionary *)configTextCellData:(NSMutableDictionary *)textData
{
    NSString *text;
    if ([textData[@"content"] length] > 0 && [textData[@"content"] hasSuffix:@"]"]) {
        text = [NSString stringWithFormat:@"%@ ", textData[@"content"]];
    } else {
        text = textData[@"content"];
    }
    
    self.attrLabel.text = text;
    CGSize size = [AXTTTAttributedLabel sizeThatFitsAttributedString:self.attrLabel.attributedText
                                                     withConstraints:CGSizeMake(kLabelWidth, CGFLOAT_MAX)
                                              limitedToNumberOfLines:0];
    textData[@"rowHeight"] = [NSString stringWithFormat:@"%f", size.height];
    textData[@"rowWidth"] = [NSString stringWithFormat:@"%f", size.width];
    return textData;
}

#pragma mark - AJKChatMessageSystemCellDelegate
- (void)didClickSystemButton:(AXMessageType)messageType {
    
}

- (AXChatMessageSourceDestination)messageSource:(NSDictionary *)dic
{
    if (dic[@"messageSource"] && [dic[@"messageSource"] isEqualToNumber:@(AXChatMessageSourceDestinationIncoming)]) {
        return AXChatMessageSourceDestinationIncoming;
    } else {
        return AXChatMessageSourceDestinationOutPut;
    }
}

- (void)afterSendMessage
{
    
}

#pragma mark - NSNotificationCenter
- (void)didReceiveNewMessage:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)notification.object;
        if (notification.userInfo[@"unreadCount"] && [notification.userInfo[@"unreadCount"] integerValue] > 0) {
            [self reloadUnReadNum:[notification.userInfo[@"unreadCount"] integerValue]];
        }
        if (dict[[self checkFriendUid]]) {
            BOOL flg = NO;
            if (!self.keyboardControl.hidden || (self.myTableView.contentSize.height - self.myTableView.contentOffset.y < AXScrollContentOffsetY)) {
                flg = YES;
            }
            for (AXMappedMessage *mappedMessage in dict[[self checkFriendUid]]) {
                self.lastMessage = mappedMessage;
                NSMutableDictionary *dict = [self mapAXMappedMessage:mappedMessage];
                if (dict) {
                    dict[@"messageSource"] = @(AXChatMessageSourceDestinationIncoming);
                    dict[AXCellIdentifyTag] = mappedMessage.identifier;
                    [self appendCellData:dict];
                }
            }
            // 判断是否需要滑动到底部
            if (flg) {
                [self scrollToBottomAnimated:YES];
            }
        }
    }
}

- (void)willHideEditMenu:(NSNotification *)notification
{
    if (self.selectedCell) {
        if (((AXChatMessageRootCell *)self.selectedCell).messageSource == AXChatMessageSourceDestinationIncoming) {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        } else {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:NO] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        }
    }
}

- (void)willShowEditMenu:(NSNotification *)notification
{
    if (self.selectedCell) {
        if (((AXChatMessageRootCell *)self.selectedCell).messageSource == AXChatMessageSourceDestinationIncoming) {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axInChatBubbleBg:self.isBroker highlighted:YES] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        } else {
            ((AXChatMessageRootCell *)self.selectedCell).bubbleIMG.image = [[UIImage axOutChatBubbleBg:self.isBroker highlighted:YES] stretchableImageWithLeftCapWidth:40/2 topCapHeight:30/2];
        }
    }
}


#pragma mark - SSPullToRefreshViewDelegate
- (void)pullToRefreshViewDidStartLoading:(AXPullToRefreshView *)view {
    if (!self.lastMessage || !self.hasMore) {
        return;
    }
    [self.pullToRefreshView startLoading];
    [self refresh];
}

- (void)refresh {
    [self.pullToRefreshView finishLoading];
}

- (void)pullToRefreshViewDidFinishLoading:(AXPullToRefreshView *)view
{
    __weak AXChatViewController *blockSelf = self;
    [[AXChatMessageCenter defaultMessageCenter] fetchChatListWithLastMessage:self.lastMessage pageSize:AXMessagePageSize callBack:^(NSDictionary *chatList, AXMappedMessage *lastMessage, AXMappedPerson *chattingFriend) {
        blockSelf.hasMore = [chatList[@"hasMore"] boolValue];
        if (blockSelf.hasMore) {
            self.pullToRefreshView.delegate = self;
        } else {
            self.pullToRefreshView.delegate = nil;
        }
        NSArray *chatArray = chatList[@"messages"];
        if ([chatArray isKindOfClass:[NSArray class]] && [chatArray count] > 0) {
            blockSelf.lastMessage = chatArray[0];
            NSInteger num = 0;
            CGFloat cellHeight = 0;
            CGPoint newContentOffset = blockSelf.myTableView.contentOffset;
            NSMutableArray *newIndexPaths = [NSMutableArray array];
            
            for (AXMappedMessage *mappedMessage in chatArray) {
                NSDictionary *dict = [blockSelf mapAXMappedMessage:mappedMessage];
                if (dict) {
                    [blockSelf.identifierData insertObject:mappedMessage.identifier atIndex:num];
                    blockSelf.cellDict[mappedMessage.identifier] = dict;
                    cellHeight += [blockSelf tableView:blockSelf.myTableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                    
                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                    NSIndexPath *newPath =  [NSIndexPath indexPathForRow:0 inSection:0];
                    [insertIndexPaths addObject:newPath];
                    num++;
                    [newIndexPaths addObject:[NSIndexPath indexPathForRow:num inSection:0]];
                }
            }
            [blockSelf.myTableView reloadData];
            [blockSelf reloadDataFinish];
            for (NSIndexPath *indexPath in newIndexPaths) {
                newContentOffset.y += [blockSelf tableView:blockSelf.myTableView heightForRowAtIndexPath:indexPath];
            }
            DLog(@"newContentOffset.y:%f", newContentOffset.y);
            [blockSelf.myTableView setContentOffset:newContentOffset animated:NO];

        }
    }];
}

#pragma mark - ELCImagePickerControllerDelegate
- (void)elcImagePickerController:(BK_ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    if ([info count] == 0) {
        return;
    }
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    for (NSDictionary *dict in info) {
        
        UIImage *image = dict[UIImagePickerControllerOriginalImage];
        CGSize size = image.size;
        NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
        NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
        NSString *url = [AXPhotoManager getLibrary:path];
        
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = [self checkAccountType];
        //        mappedMessage.content = self.messageInputView.textView.text;
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = @(AXMessageTypePic);
        mappedMessage.imgUrl = url;
        [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)elcImagePickerControllerDidCancel:(BK_ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *uid =[[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    CGSize size = image.size;
    NSString *name = [NSString stringWithFormat:@"%dx%d",(int)size.width,(int)size.width];
    NSString *path = [AXPhotoManager saveImageFile:image toFolder:AXPhotoFolderName whitChatId:uid andIMGName:name];
    NSString *url = [AXPhotoManager getLibrary:path];
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = [self checkAccountType];
    //        mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = @(AXMessageTypePic);
    mappedMessage.imgUrl = url;
    [[AXChatMessageCenter defaultMessageCenter] sendImage:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
    
    //        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
    //        NSDictionary *imageData = @{@"messageType":@"image",@"content":image,@"messageSource":@"incoming"};
    //        [self.cellData addObject:imageData];
    //        [self reloadMytableView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AXChatMessageRootCellDelegate
- (void)deleteAXCell:(AXChatMessageRootCell *)axCell
{
    if (![axCell isKindOfClass:[AXChatMessageRootCell class]]) {
        return;
    }
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:axCell];
    NSInteger preRow = indexPath.row - 1;
    NSInteger nextRow = indexPath.row + 1;
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:preRow inSection:0];
    NSArray *indexPaths = @[indexPath];
    NSInteger index = 0;
    // 判断是否需要删除系统时间cell
    if (preRow >= 0) {
        NSString *preIdentifier = self.identifierData[preRow];
        NSDictionary *preData = self.cellDict[preIdentifier];
        
        if (nextRow < [self.identifierData count]) {
            NSString *nextIdentifier = self.identifierData[nextRow];
            NSDictionary *nextData = self.cellDict[nextIdentifier];
            if ([preData[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)] &&
                [nextData[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)]) {
                indexPaths = @[preIndexPath, indexPath];
                [self.cellDict removeObjectForKey:preIdentifier];
                [self.identifierData removeObjectAtIndex:preRow];
                index = 1;
                [[AXChatMessageCenter defaultMessageCenter] deleteMessageByIdentifier:preData[AXCellIdentifyTag]];
            }
        } else if (indexPath.row == [self.identifierData count] - 1) {
            if ([preData[@"messageType"] isEqualToNumber:@(AXMessageTypeSystemTime)]) {
                indexPaths = @[preIndexPath, indexPath];
                [self.cellDict removeObjectForKey:preIdentifier];
                [self.identifierData removeObjectAtIndex:preRow];
                index = 1;
                [[AXChatMessageCenter defaultMessageCenter] deleteMessageByIdentifier:preData[AXCellIdentifyTag]];
            }
        }
    }
    NSString *identifier = self.identifierData[indexPath.row - index];
    [self.cellDict removeObjectForKey:identifier];
    [self.identifierData removeObjectAtIndex:indexPath.row - index];
    //此时要先取消播放，然后删除录音文件 add by jianzhong
    if (axCell.messageType == AXMessageTypeVoice) {
        [[KKAudioComponent sharedAudioComponent] cancelPlaying];
    }
    
    [self.myTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
    [[AXChatMessageCenter defaultMessageCenter] deleteMessageByIdentifier:axCell.identifyString];
}

- (void)didOpenAXWebView:(NSString *)url
{
    AXChatWebViewController *chatWebViewController = [[AXChatWebViewController alloc] init];
    if ([url hasPrefix:@"http"]) {
        chatWebViewController.webUrl = url;
    } else {
        chatWebViewController.webUrl = [NSString stringWithFormat:@"http://%@", url];
    }
    chatWebViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatWebViewController animated:YES];
}

- (void)didMessageRetry:(AXChatMessageRootCell *)axCell
{
    if (self.friendPerson.userType == AXPersonTypePublic) {
        if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeText)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeProperty)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeLocation)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendMessageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeVoice)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendVoiceToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypePic)]){
            [[AXChatMessageCenter defaultMessageCenter] reSendImageToPublic:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
        }else {
            
        }
        // 之后必改
    } else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypePic)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendImage:axCell.identifyString withCompeletionBlock:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeText)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeLocation)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeProperty)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendMessage:axCell.identifyString willSendMessage:self.finishReSendMessageBlock];
    }else if([axCell.rowData[@"messageType"]  isEqual: @(AXMessageTypeVoice)]){
        [[AXChatMessageCenter defaultMessageCenter] reSendVoice:axCell.identifyString withCompeletionBlock:self.finishReSendMessageBlock];
    }else {
        
    }
}

- (void)cancelKKAudioPlaying
{
    // 停止播放
    if ([self.playingIdentifier isEqualToString:@""]) {
        return;
    }
    [[KKAudioComponent sharedAudioComponent] cancelPlaying];
    NSInteger index = [self.identifierData indexOfObject:self.playingIdentifier];
    self.playingIdentifier = @"";
    if (index >= 0) {
        [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didClickVoice:(AXChatMessageRootCell *)axCell
{
    if (![axCell isKindOfClass:[AXChatMessageRootCell class]]) {
        return;
    }
    // 更新数据库
    AXMappedMessage *message = axCell.rowData[@"mappedMessage"];
    NSString *preIdentifier = [self.playingIdentifier copy];
    [self cancelKKAudioPlaying];
    if ([preIdentifier isEqualToString:message.identifier]) {
        return;
    }
    // 更新数据库
    NSMutableDictionary *data = [message.content JSONValue];
    if (data && !data[@"hadDone"] && axCell.messageSource == AXChatMessageSourceDestinationIncoming) {
        data[@"hadDone"] = @"1";
        message.content = [data RTJSONRepresentation];
        NSMutableDictionary *dict = self.cellDict[message.identifier];
        if (dict) {
            dict[@"content"] = [data RTJSONRepresentation];
            self.cellDict[message.identifier] = dict;
        }
//        NSIndexPath *indexPath = [self.myTableView indexPathForCell:axCell];
//        NSArray *tempArray = [NSArray arrayWithObject:indexPath];
//        [self.myTableView reloadRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationNone];
        [[AXChatMessageCenter defaultMessageCenter] updateMessageWithIdentifier:message.identifier keyValues:@{@"content":message.content}];
    }
    
    // 播放
    self.playingIdentifier = message.identifier;
    [[KKAudioComponent sharedAudioComponent] playRecordingWithRelativeFilePath:message.imgPath];
    if (!self.playTipView) {
        UIView* view = [KKAudioComponent sharedAudioComponent].playTipView;
        [self.view addSubview:view];
        self.playTipView = YES;
    }
    __weak AXChatViewController *blockObject = self;
    [KKAudioComponent sharedAudioComponent].playDidFinishBlock = ^{
        [blockObject cancelKKAudioPlaying];
    
    };
    
}

#pragma mark - Layout message input view

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    
    BOOL isShrinking = textView.contentSize.height < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textView.contentSize.height - self.previousTextViewContentHeight;
    
    if (!isShrinking && (self.previousTextViewContentHeight == maxHeight || textView.text.length == 0 || [textView.text isEqualToString:@" "])) {
        changeInHeight = 0;
    }
    else {
        if (textView.contentSize.height == 16) {
            changeInHeight = 0;
        }else{
            changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
        }
    }
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             if (self.publicMenu.frame.origin.y == ScreenHeight - 20 - 44 - 49) {
//                                 [self setTableViewInsetsWithBottomValue:self.myTableView.contentInset.bottom];
                             }else{
                                 [self setTableViewInsetsWithBottomValue:self.myTableView.contentInset.bottom + changeInHeight];
                             }
                             
                             [self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             CGRect inputViewFrame = self.messageInputView.frame;

                             if (self.publicMenu.frame.origin.y == ScreenHeight - 20 -44 - 49) {
                                 inputViewFrame = self.messageInputView.frame;

                                 self.messageInputView.frame = CGRectMake(0.0f,
                                                                          ScreenHeight - 20 - 44,
                                                                          inputViewFrame.size.width,
                                                                          inputViewFrame.size.height + changeInHeight);
                             }else{
                                 inputViewFrame = self.messageInputView.frame;
                                 self.messageInputView.frame = CGRectMake(0.0f,
                                                                          inputViewFrame.origin.y - changeInHeight,
                                                                          inputViewFrame.size.width,
                                                                          inputViewFrame.size.height + changeInHeight);
                             }
                             
                             if (!isShrinking) {
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textView.contentSize.height, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (self.previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, textView.contentSize.height - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }

    //动态调整切换
    if (self.isMenuFlag) {
        CGRect frame = self.line.frame;
        frame.size.height = self.previousTextViewContentHeight + 13;
        self.line.frame = frame;
    }
}

- (void)setTableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = [self tableViewInsetsWithBottomValue:bottom];
    self.myTableView.contentInset = insets;
    self.myTableView.scrollIndicatorInsets = insets;
}

- (UIEdgeInsets)tableViewInsetsWithBottomValue:(CGFloat)bottom
{
    UIEdgeInsets insets = UIEdgeInsetsZero;
    
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        insets.top = self.topLayoutGuide.length;
    }else {
        insets.top = 0;
    }
    
    insets.bottom = bottom;
    
    return insets;
}

#pragma mark - Key-value observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.messageInputView.textView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
}

#pragma mark - Keyboard notifications

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification
{
    [[BrokerLogger sharedInstance] logWithActionCode:CHATVIEW_CHAT_INPUT page:CHAT note:nil];

    self.moreBackView.hidden = YES;
    self.emojiScrollView.hidden = YES;
    [self keyboardWillShowHide:notification];
    self.keyboardControl.hidden = NO;
    [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgName] forState:UIControlStateNormal];
    [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgNameHighlight] forState:UIControlStateHighlighted];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification
{
    if (!self.moreBackView.hidden || !self.emojiScrollView.hidden) {
        self.preNotification = notification;
        return;
    }
    [self keyboardWillShowHide:notification];
    self.keyboardControl.hidden = YES;
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [(notification.userInfo)[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
    CGRect inputViewFrame = self.messageInputView.frame;
    CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
    
    // for ipad modal form presentations
    CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
    if (inputViewFrameY > messageViewFrameBottom)
        inputViewFrameY = messageViewFrameBottom;
    
    self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                             inputViewFrameY,
                                             inputViewFrame.size.width,
                                             inputViewFrame.size.height);

    [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
     - self.messageInputView.top - AXNavBarHeight];
    self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                            - self.messageInputView.frame.origin.y
                                            - inputViewFrame.size.height);
    [self scrollToBottomAnimated:YES];
    [UIView commitAnimations];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)point
{
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.messageInputView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)point
{
    if (!self.tabBarController.tabBar.hidden){
        return;
    }
	
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}
- (void)sendRecored
{
    NSDictionary *dict = [[KKAudioComponent sharedAudioComponent] finishRecording];
//    self.isRecording = NO;
//    [self.recordTimer invalidate];
    
    if (!dict) {
//        self.recordErrorHUD.hidden = NO;
//        [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5f];
        return;
    }
    CGFloat cTime = [dict[@"RECORD_TIME"] floatValue];
    DLog(@"cTime:%f", cTime);
    if (cTime <= 1) {
//        self.recordErrorHUD.hidden = NO;
//        [self performSelector:@selector(hideDelayed:) withObject:[NSNumber numberWithBool:YES] afterDelay:0.5f];
    } else {
        // 发送
        AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
        mappedMessage.accountType = [self checkAccountType];
        mappedMessage.content = [@{@"jsonVersion":AXChatJsonVersion, @"length":[NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:cTime] integerValue]]} RTJSONRepresentation];
        mappedMessage.to = [self checkFriendUid];
        mappedMessage.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
        mappedMessage.isRead = YES;
        mappedMessage.isRemoved = NO;
        mappedMessage.messageType = @(AXMessageTypeVoice);
        mappedMessage.imgPath = [KKAudioComponent relativeFilePathWithFileName:dict[@"FILE_NAME"] ofType:@"wav"];
        mappedMessage.isImgDownloaded = YES;
        if (self.friendPerson && self.friendPerson.userType == AXPersonTypePublic) {
            [[AXChatMessageCenter defaultMessageCenter] sendVoiceToPublic:mappedMessage willSendMessage:self.finishSendMessageBlock];
        }else{
            [[AXChatMessageCenter defaultMessageCenter] sendVoice:mappedMessage withCompeletionBlock:self.finishSendMessageBlock];
        }
    }
}
#pragma mark - Utilities

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve
{
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

#pragma mark - Actions

- (void)didClickKeyboardControl
{
    
    [self.messageInputView.textView resignFirstResponder];
    [self hideSubmenu:^(BOOL isFinished) {
        nil;
    }];
    //允许手势
    [RTGestureLock setDisableGestureForBack:(BK_RTNavigationController *)self.navigationController disableGestureback:NO];
    
    if (!self.moreBackView.hidden || !self.emojiScrollView.hidden) {
        self.moreBackView.hidden = YES;
        self.emojiScrollView.hidden = YES;
        [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgName] forState:UIControlStateNormal];
        [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgNameHighlight] forState:UIControlStateHighlighted];
        
        
        if (self.preNotification) {
            [self keyboardWillShowHide:self.preNotification];
        }else {
            if (self.isBroker) {
                //            CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
                
//                if (self.publicMenu.frame.origin.y == AXWINDOWHEIGHT -AXNavBarHeight -AXStatuBarHeight - 49) {
//                    return;
//                }
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2f];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationBeginsFromCurrentState:YES];
                CGFloat keyboardY = AXMoreBackViewHeight;
                CGRect inputViewFrame = self.messageInputView.frame;
                CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                
                // for ipad modal form presentations
                CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
                if (inputViewFrameY > messageViewFrameBottom) {
                    inputViewFrameY = messageViewFrameBottom;
                }
                self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                         AXWINDOWHEIGHT -AXNavBarHeight -AXStatuBarHeight - inputViewFrame.size.height,
                                                         inputViewFrame.size.width,
                                                         inputViewFrame.size.height);
                
                [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
                 - self.messageInputView.top - AXNavBarHeight];
                self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                                        - self.messageInputView.frame.origin.y
                                                        - inputViewFrame.size.height + 60);
                self.keyboardControl.hidden = YES;
                [UIView commitAnimations];
            }
        }
    } else {
        [self.messageInputView.textView resignFirstResponder];
    }
}


- (void)didMoreBackView:(UIButton *)sender
{
    self.emojiScrollView.hidden = YES;
    if (self.currentText.length > 0) {
        self.messageInputView.textView.text = self.currentText;
    }
    CGRect moreRect = CGRectMake(0, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXMoreBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);
    self.moreBackView.frame = CGRectMake(moreRect.origin.x, moreRect.origin.y + AXMoreBackViewHeight, moreRect.size.width, moreRect.size.height);
    if (self.moreBackView.hidden) {//当more为消失状态时
        self.moreBackView.hidden = !self.moreBackView.hidden;
        [self.messageInputView.textView resignFirstResponder];

        [UIView animateWithDuration:0.270f animations:^{
            self.moreBackView.frame = moreRect;
            
            CGRect inputViewFrame = self.messageInputView.frame;
            CGFloat inputViewFrameY = AXWINDOWHEIGHT -AXNavBarHeight -AXStatuBarHeight - AXMoreBackViewHeight - inputViewFrame.size.height;
            self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                                    - AXMoreBackViewHeight
                                                    - inputViewFrame.size.height + 60);
            self.keyboardControl.hidden = NO;
            self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                     inputViewFrameY,
                                                     inputViewFrame.size.width,
                                                     inputViewFrame.size.height);

            if (self.isVoiceInput) {
                self.isVoiceInput = !self.isVoiceInput;
                self.pressSpeek.frame = CGRectZero;
                [self.voiceBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameVoice] forState:UIControlStateNormal];
                self.messageInputView.textView.editable = YES;
//                self.messageInputView.textView.selectable = YES;
            }
            
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.top - AXNavBarHeight];
            [self scrollToBottomAnimated:YES];
        } completion:nil];
    }else {
        self.moreBackView.hidden = !self.moreBackView.hidden;
        [self.messageInputView.textView becomeFirstResponder];
    }
    
}


- (void)sendPressed:(UIButton *)sender
{
    [self sendMessage:self.messageInputView.textView];
}

- (void)finishSend
{
    self.messageInputView.textView.text = @"";
    [self textViewDidChange:self.messageInputView.textView];
    [self.myTableView reloadData];
    [self reloadDataFinish];
}

- (void)goBrokerPage:(id)sender
{
    
}

//tableviwe加载完毕
- (void)reloadDataFinish
{
    
}

- (void)pickIMG:(id)sender {
    BK_ELCAlbumPickerController *albumPicker = [[BK_ELCAlbumPickerController alloc] initWithStyle:UITableViewStylePlain];
    BK_ELCImagePickerController *elcPicker = [[BK_ELCImagePickerController alloc] initWithRootViewController:albumPicker];
    elcPicker.maximumImagesCount = 5; //(maxCount - self.roomImageArray.count);
    elcPicker.imagePickerDelegate = self;
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)takePic:(id)sender {
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera; //拍照
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
    
}
- (void)pickHZ:(id)sender {
    
}
- (void)pickAJK:(id)sender {
    
}


- (void)locationClick {
    [self clickLocationLog];
    MapViewController *mv = [[MapViewController alloc] init];
    mv.siteDelegate = self;
    [mv setHidesBottomBarWhenPushed:YES];
    mv.mapType = RegionChoose;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:mv animated:YES];

}

- (void)speeking {
    if (self.messageInputView.textView.text.length >0) {
        self.currentText = [NSString stringWithString:self.messageInputView.textView.text];
        self.messageInputView.textView.text = @"";
    }
    
    if (!self.moreBackView.isHidden || !self.emojiScrollView.isHidden) {
        [self didClickKeyboardControl];
    }
    if (!self.isVoiceInput) {
        [self didClickKeyboardControl];
        self.isVoiceInput = !self.isVoiceInput;
        [self.voiceBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameKeyboard] forState:UIControlStateNormal];
        [self.messageInputView.textView resignFirstResponder];
        self.messageInputView.textView.editable = NO;
        self.pressSpeek.frame = self.messageInputTextViewFrame;
        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.messageInputView.top - AXNavBarHeight];
        self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                                - self.messageInputView.frame.origin.y
                                                - self.messageInputViewFrame.size.height);
        [self scrollToBottomAnimated:YES];
        
        [self switchToVoiceLog];
    } else {
        self.messageInputView.textView.text = self.currentText;
        self.isVoiceInput = !self.isVoiceInput;
        self.pressSpeek.frame = CGRectZero;
        [self.voiceBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameVoice] forState:UIControlStateNormal];
        self.messageInputView.textView.editable = YES;

        [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
         - self.messageInputView.top - AXNavBarHeight];
        self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                                - self.messageInputView.frame.origin.y
                                                - self.messageInputViewFrame.size.height);
        [self scrollToBottomAnimated:YES];
        [self.messageInputView.textView becomeFirstResponder];
        [self switchToTextLog];
    }

}

- (void)didEmojiButClick{
    [[BrokerLogger sharedInstance] logWithActionCode:CHAT_TRANSTO_EMOTICON page:CHAT note:nil];
    [self initEmojiView];
    self.moreBackView.hidden = YES;
    //禁止手势
    [RTGestureLock setDisableGestureForBack:(BK_RTNavigationController *)self.navigationController disableGestureback:YES];
    
    if (self.currentText.length > 0) {
        self.messageInputView.textView.text = self.currentText;
    }
    
    CGRect moreRect = CGRectMake(0, AXWINDOWHEIGHT - AXNavBarHeight - AXStatuBarHeight - AXMoreBackViewHeight, AXWINDOWWHIDTH, AXMoreBackViewHeight);
    self.emojiScrollView.frame = CGRectMake(moreRect.origin.x, moreRect.origin.y + AXMoreBackViewHeight, moreRect.size.width, moreRect.size.height);
    if (self.emojiScrollView.hidden) {//当emoji为消失状态时
        self.emojiScrollView.hidden = !self.emojiScrollView.hidden;
        [self.emojiBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameKeyboard] forState:UIControlStateNormal];
        [self.emojiBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameKeyboardHighlight] forState:UIControlStateHighlighted];
        [self.messageInputView.textView resignFirstResponder];
        
        [UIView animateWithDuration:0.270f animations:^{
            self.emojiScrollView.frame = moreRect;
            
            CGRect inputViewFrame = self.messageInputView.frame;
            CGFloat inputViewFrameY = AXWINDOWHEIGHT -AXNavBarHeight -AXStatuBarHeight - AXMoreBackViewHeight - inputViewFrame.size.height;
            self.keyboardControl.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height
                                                    - AXMoreBackViewHeight
                                                    - inputViewFrame.size.height + 60);
            self.keyboardControl.hidden = NO;
            self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                     inputViewFrameY,
                                                     inputViewFrame.size.width,
                                                     inputViewFrame.size.height);
            
            if (self.isVoiceInput) {
                self.isVoiceInput = !self.isVoiceInput;
                self.pressSpeek.frame = CGRectZero;
                [self.voiceBut setBackgroundImage:[UIImage imageNamed:SpeekImgNameVoice] forState:UIControlStateNormal];
                self.messageInputView.textView.editable = YES;
                //                self.messageInputView.textView.selectable = YES;
            }
            
            [self setTableViewInsetsWithBottomValue:self.view.frame.size.height
             - self.messageInputView.top - AXNavBarHeight];
            [self scrollToBottomAnimated:YES];
        } completion:nil];
        
    }else {
        self.emojiScrollView.hidden = !self.emojiScrollView.hidden;
        [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgName] forState:UIControlStateNormal];
        [self.emojiBut setBackgroundImage:[UIImage imageNamed:EmojiImgNameHighlight] forState:UIControlStateHighlighted];
        [self.messageInputView.textView becomeFirstResponder];
    }
}

- (void)didClickRecored:(id)sender
{
    __block AXChatViewController *blockSelf = self;
    PermissionBlock permissionBlock = ^(BOOL granted) {
            if (!granted) {
                blockSelf.hasMicrophonePermission = NO;
            }else{
                blockSelf.hasMicrophonePermission = YES;
            }
    };
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:permissionBlock];
    }else{
        self.hasMicrophonePermission = YES;
    }
    
}

//UIControlEventTouchDown
- (void)didBeginVoice {
    
    if (!self.hasMicrophonePermission) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在iPhone的“设置-隐私-麦克风”选项中，允许移动经纪人访问你的手机麦克风。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    self.curCount = 0;
    self.isInterrupted = NO;
    self.date = [NSDate date];
    [[KKAudioComponent sharedAudioComponent] beginRecording];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateVolumn) userInfo:nil repeats:YES];

    //延迟创建
    if (self.backgroundImageView == nil) {
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310/2, 290/2)];
        
        self.microphoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(310/2/2 - 88/2/2, 290/2/2-170/2/2 - 10, 88/2, 145/2)];
        self.highlightedMicrophoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(310/2/2 - 88/2/2, 290/2/2-170/2/2 - 10, 88/2, 145/2)];
        
        self.dustbinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(310/2/2 - 128/2/2, 290/2/2-150/2/2 - 10, 128/2, 121/2)];
        
        self.hudLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 115, 155, 20)];
        self.hudLabel.font = [UIFont systemFontOfSize:15];
        self.hudLabel.backgroundColor = [UIColor clearColor];
        self.hudLabel.textColor = [UIColor whiteColor];
        self.hudLabel.textAlignment = NSTextAlignmentCenter;
        
        self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 160, 145, 25)];
        self.countDownLabel.font = [UIFont systemFontOfSize:15];
        self.countDownLabel.layer.cornerRadius = 5;
        self.countDownLabel.layer.masksToBounds = YES;
        self.countDownLabel.alpha = 0.7;
        self.countDownLabel.backgroundColor = [UIColor blackColor];
        self.countDownLabel.textColor = [UIColor whiteColor];
        self.countDownLabel.textAlignment = NSTextAlignmentCenter;
        self.countDownLabel.hidden = YES;
        
        [self.backgroundImageView addSubview:self.microphoneImageView];
        [self.backgroundImageView addSubview:self.highlightedMicrophoneImageView];
        [self.backgroundImageView addSubview:self.dustbinImageView];
        [self.backgroundImageView addSubview:self.hudLabel];
        [self.backgroundImageView addSubview:self.countDownLabel];
        
    }
    self.dustbinImageView.image = nil;
    self.microphoneImageView.image = nil;
    self.highlightedMicrophoneImageView.image = nil;
    self.backgroundImageView.image = nil;
    
    self.microphoneImageView.image = [UIImage imageNamed:@"wl_voice_icon_voicestatu"];
    self.backgroundImageView.image = [UIImage imageNamed:@"wl_voice_tip_bg"];
    [self showHUDWithTitle:@"手指上滑, 取消发送" CustomView:self.backgroundImageView IsDim:NO]; //取消蒙版
    [self pressForVoiceLog];
    
}


//UIControlEventTouchUpInside
- (void)didCommitVoice {
    self.countDownLabel.hidden = YES;
    
    if (self.isInterrupted || !self.hasMicrophonePermission) {
        return;
    }
    
    double timeSpent = [[NSDate date] timeIntervalSinceDate:self.date];
    if (timeSpent < 1 || isnan(timeSpent)) {
        [self.timer invalidate];
        self.dustbinImageView.image = nil;
        self.microphoneImageView.image = nil;
        self.highlightedMicrophoneImageView.image = nil;
        self.backgroundImageView.image = nil;
        
        self.backgroundImageView.image = [UIImage imageNamed:@"wl_voice_tip_warn"];
        self.hudLabel.text = @"录音时间太短";
        [self.hud hide:YES afterDelay:1];
        
    }else{
//        [[KKAudioComponent sharedAudioComponent] finishRecording];
//        NSLog(@"%f", timeSpent);
        [self sendRecored];
        [self.timer invalidate];
        [self hideHUD];
    }
    
}

//UIControlEventTouchUpOutside
- (void)didCancelVoice{
    self.countDownLabel.hidden = YES;
    
    if (self.isInterrupted) {
        return;
    }
    
    self.pressSpeek.selected = NO;
    [[KKAudioComponent sharedAudioComponent] cancelRecording];
    [self.timer invalidate];
    
    [self.hud hide:YES];
    [self cancelSendingVoiceLog];
    
}

//UIControlEventTouchDragExit
- (void)willCancelVoice {
    if (self.isInterrupted) {
        return;
    }
    
    [self.timer invalidate];
    
    self.countDownLabel.hidden = YES;
    self.pressSpeek.selected = YES;
    
    self.dustbinImageView.image = nil;
    self.microphoneImageView.image = nil;
    self.highlightedMicrophoneImageView.image = nil;
    self.backgroundImageView.image = nil;

    self.dustbinImageView.image = [UIImage imageNamed:@"wl_voice_icon_dustbin"];
    self.backgroundImageView.image = [UIImage imageNamed:@"wl_voice_tip_bg2"];

    self.hudLabel.text = @"手指松开, 取消发送";
    [self.pressSpeek setTitle:@"手指松开, 取消发送" forState:UIControlStateSelected];
    
}


//UIControlEventTouchDragEnter
- (void)continueRecordVoice{
    if (self.isInterrupted) {
        return;
    }
    
    self.pressSpeek.selected = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(updateVolumn) userInfo:nil repeats:YES];
    
    self.dustbinImageView.image = nil;
    self.microphoneImageView.image = nil;
    self.highlightedMicrophoneImageView.image = nil;
    self.backgroundImageView.image = nil;
    
    self.microphoneImageView.image = [UIImage imageNamed:@"wl_voice_icon_voicestatu"];
    self.backgroundImageView.image = [UIImage imageNamed:@"wl_voice_tip_bg"];
    
    self.hudLabel.text = @"手指上滑, 取消发送";
}

//UIControlEventTouchCancel
- (void)didInterruptRecord{
    [self didCommitVoice];
}


//使用 MBProgressHUD
- (void)showHUDWithTitle:(NSString*)title CustomView:(UIView*)view IsDim:(BOOL)isDim {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.color = [UIColor clearColor];
    self.hud.customView = view;
    self.hud.yOffset = -20;
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.dimBackground = isDim;
    self.hudLabel.text = title;
    
}

//使用 MBProgressHUD 显示完成提示
- (void)showHUDWithTitle:(NSString *)title CustomView:(UIView *)view IsDim:(BOOL)isDim IsHidden:(BOOL)isHidden{
    
    [self showHUDWithTitle:title CustomView:view IsDim:isDim];
    if (isHidden) {
        [self.hud hide:YES afterDelay:1];
    }
    
}


- (void)hideHUD {
    self.countDownLabel.hidden = YES;
    [self.hud hide:YES];
}

- (void)updateVolumn
{
    
    double lowPassResults = [[KKAudioComponent sharedAudioComponent] volumnUpdated];
    int value = (0.8 - lowPassResults) * 60;
    
    if (value > 145/2) {
        value = 145/2;
    }
    if (value < 0) {
        value = 0;
    }
    
    UIImage* image = [UIImage imageNamed:@"wl_voice_icon_voicestatu1"];
    self.highlightedMicrophoneImageView.frame = CGRectMake(310/2/2 - 88/2/2, 290/2/2-170/2/2 + value -10, 88/2, 145/2 -value); //变更frame
    CGRect rect = CGRectMake(0, value*2, 88, 145 - value*2);//创建矩形框, retina图像需要*2
    self.highlightedMicrophoneImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
    
    if (self.curCount >= MAX_RECORD_TIME - 10 && self.curCount < MAX_RECORD_TIME) {
        //剩下10秒
        self.countDownLabel.hidden = NO;
        self.countDownLabel.text = [NSString stringWithFormat:@"录音时间还剩%d秒",(int)(MAX_RECORD_TIME - self.curCount)];
    }else if (self.curCount >= MAX_RECORD_TIME){
        //时间到
        [self didCommitVoice];
        self.isInterrupted = YES;//标志位表示被强制结束录音
    }
    self.curCount += 0.1f; //计时器每0.1秒调用一次, 这儿进行计时
    
}

- (void)sendMessage:(id)sender {
    
    if ([self.messageInputView.textView.text isEqualToString:@""]) {
//        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发空消息" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//        [view show];
        return;
    }
    
    if ([self.messageInputView.textView.text length] >= 2000) {
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"超出字数限制" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil];
        [view show];
        return;
    }
    
    NSString *text = [self.messageInputView.textView.text js_stringByTrimingWhitespace];
    NSData *data = [text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *asciiString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([asciiString rangeOfString:@"\\ufffc"].location != NSNotFound) {
        return;
    }
    
    AXMappedMessage *mappedMessage = [[AXMappedMessage alloc] init];
    mappedMessage.accountType = [self checkAccountType];
    mappedMessage.content = self.messageInputView.textView.text;
    mappedMessage.to = [self checkFriendUid];
    mappedMessage.from = [[AXChatMessageCenter defaultMessageCenter] fetchCurrentPerson].uid;
    mappedMessage.isRead = YES;
    mappedMessage.isRemoved = NO;
    mappedMessage.messageType = @(AXMessageTypeText);
    
    if (self.friendPerson.userType == AXPersonTypePublic) {
        [[AXChatMessageCenter defaultMessageCenter] sendMessageToPublic:mappedMessage willSendMessage:self.finishSendMessageBlock];
    } else {
        [[AXChatMessageCenter defaultMessageCenter] sendMessage:mappedMessage willSendMessage:self.finishSendMessageBlock];
    }
    [self afterSendMessage];
    [self sendPropMessage];
    
    [self finishSend];
    [self scrollToBottomAnimated:YES];
}

- (void)didClickPublicCardWithUrl:(NSString *)url
{
    AXChatWebViewController *webViewController = [[AXChatWebViewController alloc] init];
    webViewController.webUrl = url;
    webViewController.webTitle = self.friendPerson.name;
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - Scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	self.isUserScrolling = YES;
    [self.messageInputView.textView resignFirstResponder];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.isUserScrolling = NO;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.myTableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:animated];
    }
}

#pragma mark - Text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.isBroker) {
        // 检查用户是否登陆
        if (![self checkUserLogin]) {
            return NO;
        }
    }
    if (self.isBroker) {
        if (textView.text.length == 0) {
            textView.text = @" ";
            textView.text = @"";
        }
    }
    [self clickInputViewAppLog];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if (self.currentText.length > 0 ) {
        textView.text = self.currentText;
    }
	
    if (!self.previousTextViewContentHeight) {
		self.previousTextViewContentHeight = textView.contentSize.height;
    }
    [self scrollToBottomAnimated:YES];
    if (![self.messageInputView.textView.text isEqualToString:@""]) {
        self.messageInputView.sendButton.enabled = YES;
    } else {
        self.messageInputView.sendButton.enabled = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        self.currentText = @"";
        [self sendMessage:textView.text];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = [textView.text js_stringByTrimingWhitespace];
    NSData *data = [text dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *asciiString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!self.isBroker && [text length] > 0 && ![text isEqualToString:@""] && ([asciiString rangeOfString:@"\\ufffc"].location == NSNotFound || [asciiString length] == 0)) {
        self.messageInputView.sendButton.enabled = YES;
    } else {
        self.currentText = @"";
        self.messageInputView.sendButton.enabled = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    self.messageInputView.sendButton.enabled = NO;
}
- (void)didClickMapCell:(NSDictionary *)dic {

}
- (void)didClickIMG:(AXChatBaseCell *)axCell {
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:axCell];
    NSString *identifier = (self.identifierData)[[indexPath row]];
    NSDictionary *dic = self.cellDict[identifier];
    if ([dic[@"messageType"] isEqualToNumber:@(AXMessageTypePic)]) {
        NSMutableArray *imgArray = [NSMutableArray arrayWithArray:[[AXChatMessageCenter defaultMessageCenter] picMessageArrayWithFriendUid:[self checkFriendUid]]];
        
        NSArray *temparray = [[imgArray reverseObjectEnumerator] allObjects];
        NSMutableArray *photoArray = [NSMutableArray array];
        int currentPhotoIndex = 0;
        for (int i =0; i <temparray.count; i ++) {
            AXPhoto *photo = [[AXPhoto alloc] init];
            photo.picMessage = temparray[i];
            if ([dic[@"identifier"] isEqualToString:photo.picMessage.identifier]) {
                currentPhotoIndex = i;
            }
            NSLog(@"====%@", photo.picMessage.imgUrl);
            [photoArray addObject:photo];
        }
        AXPhotoBrowser *controller = [[AXPhotoBrowser alloc] init];
        controller.isBroker = YES;
        controller.backType = RTSelectorBackTypePopBack;
        controller.currentPhotoIndex = currentPhotoIndex; // 弹出相册时显示的第一张图片是？
        [controller setPhotos:photoArray]; // 设置所有的图片
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(void)loadMapSiteMessage:(NSDictionary *)mapSiteDic {

}
@end

