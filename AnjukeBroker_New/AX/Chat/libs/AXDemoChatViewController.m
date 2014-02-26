//
//  AJKChatViewController.m
//  X
//
//  Created by 杨 志豪 on 2/13/14.
//  Copyright (c) 2014 williamYang. All rights reserved.
//

#import "AXDemoChatViewController.h"
#import "AXChatMessageRoomSourceCell.h"
#import "AXChatViewController.h"
#import "AXUserChatViewController.h"

@interface AXDemoChatViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *myTextView;
@end

@implementation AXDemoChatViewController

#pragma mark - setters and getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320,CGRectGetHeight(self.view.frame)- 44 ) style:UITableViewStylePlain];
        }
    return _tableView;
}

#pragma mark - lifeCyle
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
    self.CellData = [NSMutableArray array];
    NSDictionary *roomSource = @{@"title": @"中房二期花园，地理位置好",@"price":@"12000",@"roomType":@"3房两厅",@"area":@"200",@"floor":@"13/14",@"year":@"2005",@"messageType":@"roomTye"};
    
    NSDictionary *textData = @{@"messageType":@"text",@"content":@"jsdljflasjdjlfas"};
    
    NSDictionary *imageData = @{@"messageType":@"image",@"content":[UIImage imageNamed:@"bubble-default-incoming-green.png"]};
    
    
    [self.CellData addObject:imageData];
    [self.CellData addObject:textData];
    [self.CellData addObject:roomSource];
    
    
    UIButton *but= [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(0, 0, 300, 200);
    but.backgroundColor = [UIColor blueColor];
    [but addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    
    UIButton *userBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    userBtn.frame = CGRectMake(0, 200, 300, 400);
    userBtn.backgroundColor = [UIColor greenColor];
    [userBtn addTarget:self action:@selector(clickUserChat) forControlEvents:UIControlEventTouchDown];

    [self.view addSubview:but];
    [self.view addSubview:userBtn];

    self.myTextView = [[UITextView alloc] init];
    self.myTextView.editable = NO;
    self.myTextView.frame = CGRectMake(0, 400, 320, 200);
    self.myTextView.text = @"asdfasdf是大方几克拉数据的弗兰克123456789手机阿里肯定放假了凯撒http://www.baidu.com";
    self.myTextView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
    [self.view addSubview:self.myTextView];
    
	// Do any additional setup after loading the view.
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES;
}
- (void)click {
    AXChatViewController *controller = [[AXChatViewController alloc] init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:^{
        
    }];

}

- (void)clickUserChat
{
    AXUserChatViewController *controller = [[AXUserChatViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    nav.navigationBar.translucent = NO;
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.CellData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = (self.CellData)[[indexPath row]];
    if (dic[@"messageType"] && [dic[@"messageType"] isEqualToString:@"roomType"]) {
        return 100;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToString:@"text"])
    {
        return 30;
    }else if (dic[@"messageType"] && [dic[@"messageType"] isEqualToString:@"image"])
    {
        return 70;
    }else
        return 0;
}
#pragma makr - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *roomSourceIdentity = @"RoomSourceCell";
    AXChatMessageRoomSourceCell *roomSourceCell = [tableView dequeueReusableCellWithIdentifier:roomSourceIdentity];
    if (roomSourceCell == nil) {
        roomSourceCell = [[AXChatMessageRoomSourceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:roomSourceIdentity];
    }
    return roomSourceCell;
}
@end
