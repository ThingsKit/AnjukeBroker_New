//
//  FangYuanTableViewCell.m
//  AnjukeBroker_New
//
//  Created by leozhu on 14-5-13.
//  Copyright (c) 2014年 Wu sicong. All rights reserved.
//

#import "PropertyTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "PropertyModel.h"
#import "UIViewExt.h"
#import "LoginManager.h"
#import "UIView+ChainViewController.h"
#import "RushPropertyViewController.h"
#import "Util_UI.h"

@interface PropertyTableViewCell ()

@property (nonatomic, retain) UIImageView* icon;
@property (nonatomic, retain) UILabel* commName;   //小区名字
@property (nonatomic, retain) UILabel* houseType;
@property (nonatomic, retain) UILabel* area;
@property (nonatomic, retain) UILabel* price;
@property (nonatomic, retain) UILabel* publishTime; //发布时间
@property (nonatomic, retain) UIButton* button; //右侧的按钮

@end


@implementation PropertyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initCell];
    }
    return self;
}


#pragma mark -
#pragma mark UI相关

- (void)initCell {
    
    //小区名称
    self.commName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.commName.backgroundColor = [UIColor clearColor];
    self.commName.font = [UIFont boldSystemFontOfSize:15.0];
    [self.commName setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.commName];
    
    //租售icon
    self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.icon.backgroundColor = [UIColor clearColor];
    self.icon.layer.cornerRadius = 1.0;
    self.icon.layer.masksToBounds = YES;
    [self.contentView addSubview:self.icon];
    
    //户型
    self.houseType = [[UILabel alloc] initWithFrame:CGRectZero];
    self.houseType.backgroundColor = [UIColor clearColor];
    self.houseType.font = [UIFont systemFontOfSize:12.0];
    [self.houseType setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.houseType];
    
    //面积
    self.area = [[UILabel alloc] initWithFrame:CGRectZero];
    self.area.backgroundColor = [UIColor clearColor];
    self.area.font = [UIFont systemFontOfSize:12.0];
    [self.area setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.area];
    
    //租金或售价
    self.price = [[UILabel alloc] initWithFrame:CGRectZero];
    self.price.backgroundColor = [UIColor clearColor];
    self.price.font = [UIFont systemFontOfSize:12.0];
    [self.price setTextColor:[Util_UI colorWithHexString:@"#3D4245"]];
    [self.contentView addSubview:self.price];
    
    //发布时间
    self.publishTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self.publishTime.backgroundColor = [UIColor clearColor];
    self.publishTime.font = [UIFont systemFontOfSize:12.0];
    [self.publishTime setTextColor:[Util_UI colorWithHexString:@"#B2B2B2"]];
    [self.contentView addSubview:self.publishTime];
    
    
    //右侧的按钮
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.cornerRadius = 2.0f;
    self.button.layer.masksToBounds = YES;
    [self.button.titleLabel setFont:[UIFont ajkH3Font]];
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.button];
    
    //cell的背景视图
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    backgroundView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    self.selectedBackgroundView = backgroundView;
    
}


- (void)setButtonAble{
    [self.button setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_weituo_button_on"] forState:UIControlStateNormal];
    [self.button setBackgroundImage:[UIImage imageNamed:@"anjuke_icon_weituo_button_ on_press"] forState:UIControlStateHighlighted];
    [self.button setTitle:@"抢委托" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.enabled = YES;
    self.propertyModel.rushable = @"1";
}


- (void)setButtonDisable{
    [self.button setTitle:@"抢完了" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.button.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.button.layer.borderWidth = 1.0f;
    self.button.enabled = NO;
    self.propertyModel.rushable = @"0";
}

//加载数据
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //小区名称
    CGSize commNameSize = [self.propertyModel.commName sizeWithFont:self.commName.font constrainedToSize:CGSizeMake(ScreenWidth-120, 20)];
    self.commName.frame = CGRectMake(15, 15, commNameSize.width, 17);
//    self.commName.textAlignment = NSTextAlignmentLeft;
    self.commName.text = self.propertyModel.commName;
//    self.commName.backgroundColor = [UIColor redColor];
//    [self.commName sizeToFit]; //自适应文字大小
    
    //租售icon
    if (commNameSize.width == ScreenWidth-120) {
        self.icon.frame = CGRectMake(self.commName.right - 10, 16.5f, 16, 16);
    }else{
        self.icon.frame = CGRectMake(self.commName.right, 16.5f, 16, 16);
    }
    if ([self.propertyModel.type isEqualToString:@"1"]) {
        self.icon.image = [UIImage imageNamed:@"anjuke_icon_weituo_esf"]; //售
    }else{
        self.icon.image = [UIImage imageNamed:@"anjuke_icon_weituo_zf"]; //租
    }
    
    //户型
    self.houseType.frame = CGRectMake(15, self.commName.bottom + 6, 100, 20);
    self.houseType.text = [NSString stringWithFormat:@"%@室%@厅%@卫", self.propertyModel.room, self.propertyModel.hall, self.propertyModel.toilet];
    [self.houseType sizeToFit];
    
    //面积
    self.area.frame = CGRectMake(self.houseType.right + 6, self.commName.bottom + 6, 60, 20);
    self.area.text = [NSString stringWithFormat:@"%@平", self.propertyModel.area];
    [self.area sizeToFit];
    
    //租金或售价
    self.price.frame = CGRectMake(self.area.right + 6, self.commName.bottom + 6, 60, 20);
    self.price.text = [NSString stringWithFormat:@"%@%@", self.propertyModel.price, self.propertyModel.priceUnit];
    [self.price sizeToFit];
    
    //显示发布时间
    self.publishTime.hidden = NO;
    self.publishTime.frame = CGRectMake(15, self.houseType.bottom, ScreenWidth/2, 20);
    if (self.propertyModel.publishTime.length == 19) {
        self.propertyModel.publishTime = [self.propertyModel.publishTime substringToIndex:self.propertyModel.publishTime.length-3];
    }
    self.publishTime.text = [NSString stringWithFormat:@"%@ 发布", self.propertyModel.publishTime];
    
    //右侧的按钮
    self.button.frame = CGRectMake(ScreenWidth-85, 30, 70, 30);
    
    if([self.propertyModel.rushable isEqual: @"1"]){ //该房源可抢
        [self setButtonAble];
    }else{ //改房源抢光了
        [self setButtonDisable];
    }
    
}



#pragma mark -
#pragma mark 按钮点击时间

//右侧按钮点击事件
- (void)buttonClicked:(UIButton*)button{
    
    RushPropertyViewController* viewController = (RushPropertyViewController*)self.viewController;
    
    self.button.enabled = NO;
    [self.button setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.button.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.button.layer.borderWidth = .5;
    
    if ([viewController isNetworkOkay]) { //如果当前网络ok
        if (self.propertyModel.propertyId) { //如果房源id不空
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:self.propertyModel.propertyId forKey:@"propertyId"];
            [self rushProperty:dict];
        }
    }else{ //如果当前网络不通
        //        [viewController displayHUDWithStatus:nil Message:nil ErrCode:nil];  //使用自定义的浮层显示网络不良
        [self.button setBackgroundColor:[UIColor colorWithRed:79.0/255 green:164.0/255 blue:236.0/255 alpha:1]];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.button.enabled = YES;
        
    }
    
    
}

#pragma mark -
#pragma mark 请求相关 需要附带 propertyId

- (void)rushProperty:(NSMutableDictionary*)params{
    NSString *method = @"commission/rush/";
    //    [params setObject:@"pgdir" forKey:@"pgpmt20865"]; //测试用后门
    [params setObject:[LoginManager getToken] forKey:@"token"];
    [params setObject:[LoginManager getUserID] forKey:@"brokerId"];
//    [params setObject:@"147468" forKey:@"brokerId"]; //测试用
    [[RTRequestProxy sharedInstance] asyncRESTPostWithServiceID:RTBrokerRESTServiceID methodName:method params:params target:self action:@selector(onRequestFinished:)];
    
}

//请求完毕,回调
- (void)onRequestFinished:(RTNetworkResponse*)response{
    
    RTNetworkResponseStatus status = response.status; //这次请求的状态
    RushPropertyViewController* viewController = (RushPropertyViewController*)self.viewController; //获取cell所属的ViewController, 以调用其方法
    
    //数据请求成功
    if (status == RTNetworkResponseStatusSuccess) {
        NSString* status = [response.content objectForKey:@"status"];
        NSString* message = [response.content objectForKey:@"message"];
        NSString* errcode = [response.content objectForKey:@"errcode"];
//        NSString* errcode = @"5003"; //测试用
//        status = @"ok";
        
        if ([status isEqualToString:@"ok"]) {
            //删除当前cell, 将其添加到myPropertyList中, 但其实不需要添加, 因为myPropertyList每次都自动请求最新的(点击tab, 自动下拉)
            
            //播放飞入动画
            UIImageView* snapshot = [[UIImageView alloc] initWithImage:[self capture]];
            snapshot.frame = CGRectMake(0, self.bottom - 20, snapshot.width, snapshot.height);
            if ([snapshot superview] == nil) {
                [self.window addSubview:snapshot];
                
                [UIView animateWithDuration:1 animations:^{
                    snapshot.frame = CGRectMake(280, 35, 1, 1);
                }completion:^(BOOL finished) {
                    if (finished) {
                        [snapshot removeFromSuperview]; //动画结束后移除
                    }
                }];
            }
            
            //计数器加1
            viewController.propertyListBadgeLabel.text = [NSString stringWithFormat:@"%d", ++viewController.badgeNumber];
            viewController.propertyListBadgeLabel.hidden = NO;
            
            [viewController removeCellFromPropertyTableViewWithCell:self]; //删除对应indexPath的cell
            
            
            
            
        }else{//请求失败
            NSLog(@"%@", errcode);
            
            if ([errcode isEqualToString:@"5001"]) { //已被房东删除,或已过期
                //删除当前cell
                [viewController removeCellFromPropertyTableViewWithCell:self];
            }else if ([errcode isEqualToString:@"5002"]){ //经纪人已经抢过
                //删除当前cell
                [viewController removeCellFromPropertyTableViewWithCell:self];
            }else if ([errcode isEqualToString:@"5003"]){ //改房源抢完了
                //按钮变更为 抢完了 不可交互, cell不删除
                [self setButtonDisable];
                [viewController updateCellWithCell:self];
            }else{
                //其他错误处理逻辑, 还有什么其他情况在这里处理
            }
        }
        
        [viewController displayHUDWithStatus:status Message:message ErrCode:errcode];  //最终都会显示改自动以浮层
        
    }else{ //数据请求失败
        [viewController displayHUDWithStatus:nil Message:nil ErrCode:nil]; //
    }
    
    
}


//获取当前屏幕视图的快照图片
- (UIImage *)capture {
    
    UIView *view = self; //cell本身
    if (view == nil) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    NSLog(@"%f,%f",img.size.height,img.size.width);
    UIGraphicsEndImageContext();
    
    return img;
}


@end
