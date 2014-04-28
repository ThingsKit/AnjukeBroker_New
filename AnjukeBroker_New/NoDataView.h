//
//  NoDataView.h
//  AiFang
//
//  Created by lh liu on 12-4-10.
//  Copyright (c) 2012年 anjuke. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NoDataImg_Tuangou @"anjuke_icon_no_message.png"
#define NoDataImg_NetWorkError @""

#define NoDataTitle_Tuangou @"很抱歉，暂无团购"
#define NoDataTitle_Favourite_Community @"你还没有收藏任何楼盘"
#define NoDataTitle_Comment @"很抱歉，暂无评论"
#define NoDataTitle_History @"很抱歉，暂无历史记录"
#define NoDataTitle_CommunityList @"很抱歉，暂无新盘数据"
#define NoDataTitle_PropertyList @"很抱歉，暂无新房数据"
#define NoDataTitle_TuangouList @"很抱歉，当前城市暂无团购"
#define NoDataTitle_Connected @"很抱歉，暂无电话记录"
#define NoDataTitle_Activity @"很抱歉，暂无活动记录"
#define NoDataTitle_CommunityNearBy @"很抱歉，定位城市未开通"
#define NoDataTitle_GSP_Error @"您的定位功能未开通"

typedef enum ShowType {
    TypeWithNoData = 0,
    TypeWithNoNetWork
} ShowType;

@interface NoDataView : UIView

@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UIImageView *imageView;
@property CGRect selfFrame; //指定的自身frame
@property (nonatomic, assign) ShowType show_Type;

@property (nonatomic, copy) NSString *noDataImgName;
@property CGSize noDataImgSize; //每次指定的无数据图面size
@property (nonatomic, copy) NSString *showTitle; //指定的无数据提示

@property (nonatomic, assign) UIView *showSuperview; //底层图，用于提示图的显示与隐藏
@property (nonatomic, assign) UIView *listView; //与提示图互动的view指针

- (id)initWithImgName:(NSString *)imgName AndTitle:(NSString *)title;
- (void)setShowType:(ShowType)showType;
- (void)showNoDataView:(BOOL)show; //显示或隐藏提示图

@end
