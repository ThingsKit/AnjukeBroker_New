//
//  AlbumDetailViewController.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-21.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "AlbumDetailViewController.h"
#import "AlbumData.h"
#import "UIViewExt.h"

@interface AlbumDetailViewController ()

@property (nonatomic, strong) NSMutableArray* params;
@property (nonatomic, assign) BOOL hasTextView;
@property (nonatomic, assign) BOOL isRemoteImage; //图片是否网络下载, 默认从本地取出

@property (nonatomic, strong) UIView* viewAbove; //scrollView的外围视图
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* viewBelow; //textView的外围视图
@property (nonatomic, strong) UITextView* textView;

@end

@implementation AlbumDetailViewController

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
    
    UIButton* right = [UIButton buttonWithType:UIButtonTypeCustom];
    [right setTitle:@"删除" forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 45, 45);
    [right addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [label setText:@"查看大图"];
    [label setTextColor:[UIColor whiteColor]];
    self.navigationItem.titleView = label;
    
    [self initUI];
    
}

#pragma mark -
#pragma mark UI相关

- (void)initUI{
    self.hasTextView = [AlbumData sharedAlbumData].hasTextView;
    self.isRemoteImage = [AlbumData sharedAlbumData].isRemoteImage;
    
    if (self.hasTextView) {
        self.params = [AlbumData sharedAlbumData].albumDicts;
        [self initScrollViewWithHeight:(ScreenHeight-20-44)/2];
        
        self.viewBelow = [[UIView alloc] initWithFrame:CGRectMake(0, self.viewAbove.bottom, ScreenWidth, (ScreenHeight-20-44)/2)];
        self.textView = [[UITextView alloc] initWithFrame:self.viewBelow.bounds];
        [self.viewBelow addSubview:self.textView];
        [self.view addSubview:self.viewBelow];
        
    }else{
        self.params = [AlbumData sharedAlbumData].albumArray;
        [self initScrollViewWithHeight:(ScreenHeight-20-44)];
    }
    
    [self initArrowImageView];
    
}


- (void)initScrollViewWithHeight:(CGFloat)height{
    self.viewAbove = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, height)];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.viewAbove.bounds];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*self.params.count, height);
    self.scrollView.pagingEnabled = YES;
    [self.viewAbove addSubview:self.scrollView];
    [self.view addSubview:self.viewAbove];
    
    for (int i=0; i<self.params.count; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*ScreenWidth, 0, ScreenWidth, height)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
//        NSString* urlString = [[self.params objectAtIndex:i] objectForKey:@"img"];
        if (self.isRemoteImage) { //网络下载图片
            //                [imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"page_image_loading"]];
        }else{ //本地图片
//            imageView.image = [UIImage imageWithContentsOfFile:urlString];
            imageView.image = [[self.params objectAtIndex:i] objectForKey:@"img"];
        }
        
        [self.scrollView addSubview:imageView];
        
    }
}

- (void)initArrowImageView{

    UIImageView* leftArrow = [[UIImageView alloc] initWithFrame:CGRectMake(30, self.scrollView.height/2, 17/2, 26/2)];
    leftArrow.image = [UIImage imageNamed:@"details_arrow_left"]; // 17*26 @2x
    leftArrow.backgroundColor = [UIColor clearColor];
    
    UIImageView* rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-30, self.scrollView.height/2, 17/2, 26/2)];
    rightArrow.image = [UIImage imageNamed:@"details_arrow_right"];
    rightArrow.backgroundColor = [UIColor clearColor];
    
    [self.viewAbove addSubview:leftArrow];
    [self.viewAbove addSubview:rightArrow];
  
}


#pragma mark -
#pragma mark Button Action
- (void)deleteAction:(UIButton*)button{
    NSLog(@"delete");
    if (self.hasTextView) {
//        self.scrollView.contentOffset.x
        
        
    }else{
        
    }
    
    
}



#pragma mark -
#pragma mark 内存管理

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
