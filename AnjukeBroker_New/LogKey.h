//
//  LogKey.h
//  AnjukeBroker_New
//
//  Created by jianzhongliu on 11/27/13.
//  Copyright (c) 2013 Wu sicong. All rights reserved.
//

#ifndef AnjukeBroker_New_LogKey_h
#define AnjukeBroker_New_LogKey_h


/*
 所有模块: 首页
 */
#define HOME                  @"1-100000" //PageID
#define HOME_ONVIEW           @"1-100001" //页面可见（即页面打开）
#define AJK_HOME_002          @"1-100002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_HOME_003          @"1-100003" //点击发布二手房
#define AJK_HOME_004          @"1-100004" //点击发布租房
#define AJK_HOME_005          @"1-100005" //点击系统消息
#define AJK_HOME_006          @"1-100006" //点击账户资料
#define HOME_ESF              @"1-100007" //点击二手房管理
#define HOME_ZF               @"1-100008" //点击租房管理
#define HOME_MARKET           @"1-100009" //点击市场分析
#define HOME_COMMISSION       @"1-100010" //点击抢房源
#define HOME_POTENTIAL_CLIENT @"1-100011" //点击抢客户
#define HOME_SIGNIN           @"1-100012" //点击小区签到
#define HOME_DATA             @"1-100013" //点击微聊数据

//房源Tab
#define FY_TAB @"1-101000"
#define FY_TAB_001 @"1-101001" //页面可见
#define FY_TAB_002 @"1-101002" //点击二手房定价房源入口
#define FY_TAB_003 @"1-101003" //点击二手房竞价房源入口
#define FY_TAB_004 @"1-101004" //点击二手房待推广房源入口
#define FY_TAB_005 @"1-101005" //点击租房定价房源入口
#define FY_TAB_006 @"1-101006" //点击租房竞价房源入口
#define FY_TAB_007 @"1-101007" //点击租房待推广房源入口
#define FY_TAB_008 @"1-101008" //点击右上角+
#define FY_TAB_010 @"1-101010" //点击右上角+：发布二手房
#define FY_TAB_011 @"1-101011" //点击右上角+：发布租房
#define FY_TAB_017 @"1-101017" //切换tab二手房—>租房
#define FY_TAB_018 @"1-101018" //切换tab租房—>二手房

/*
 所有模块: 微聊数据页
 */
#define DATA @"1-102000"          //PageID
#define WLDATA_ONVIEW @"1-102001" //页面可见
#define WLDATA_BACK @"1-102004"   // 点击页面返回


/*
 所有模块: 综合log
 */
#define TOTAL @"1-103000"     // PageID
#define TOTAL_START @"1-103010" // 启动APP，全新启动时发送，后台运行中打开不发送

/*
 所有模块: 二手房发布页
 */
#define ESF_PUBLISH @"1-200000"     //PageID
#define ESF_PUBLISH_ONVIEW @"1-200001" //页面可见（即页面打开） 记bp值（页面id）
#define AJK_PROPERTY_002 @"1-200002" //点击返回
#define AJK_PROPERTY_003 @"1-200003" //点击取消  ------ 有问题
#define ESF_PUBLISH_SAVE @"1-200004" //点击保存
#define AJK_PROPERTY_005 @"1-200005" //点击房型图-拍照
#define AJK_PROPERTY_006 @"1-200006" //点击房型图-从相册选择
#define AJK_PROPERTY_007 @"1-200007" //点击房型图-在线房型图
#define ESF_PUBLISH_CLICK_FIX @"1-200008" //点击定价推广
#define ESF_PUBLISH_CLICK_BID @"1-200009" //点击定价且竞价推广
#define ESF_PUBLISH_CLICK_DRAFT @"1-200010" //点击暂不推广
#define AJK_PROPERTY_011 @"1-200011" //点击添加室内图
#define AJK_PROPERTY_012 @"1-200012" //点击添加室内图-拍照
#define AJK_PROPERTY_013 @"1-200013" //点击添加室内图-从相册选择
#define AJK_PROPERTY_014 @"1-200014" //点击添加房型图
#define AJK_PROPERTY_015 @"1-200015" //点击房型图-从相册选择
#define AJK_PROPERTY_016 @"1-200016" //点击房型图-在线房型图
#define AJK_PROPERTY_017 @"1-200017" //点击已添加的室内图
#define ESF_PUBLISH_CLICK_ADD_INDOORGRAPH @"1-200021" //点击添加室内图
#define ESF_PUBLISH_CLICK_TAKE_INDOORGRAPH @"1-200022" //点击添加室内图－拍照
#define ESF_PUBLISH_CLICK_SELECT_INDOORGRAPH @"1-200023" //点击添加室内图－从相册选择
#define ESF_PUBLISH_CLICK_ADD_HOUSETYPEGRAPH @"1-200024" //点击添加房型图
#define ESF_PUBLISH_CLICK_SELECT_HOUSETYPEGRAPH @"1-200025" //点击房型图－从相册选择
#define ESF_PUBLISH_CLICK_ONLINE_HOUSETYPEGRAPH @"1-200026" //点击房型图－在线房型图
#define ESF_PUBLISH_CLICK_INDOORGRAPH @"1-200027" //点击已添加的室内图


//二手房室内图描述页
#define ESF_INDOORGRAPH_DESCRIPTION @"1-201000" //PageID
#define ESF_INDOORGRAPH_DESCRIPTION_ONVIEW @"1-201001" //页面可见记bp值（页面id）
//#define AJK_PROPERTY_HOUSEIMG_DES_002 @"1-201002" //点击拍照按钮
#define ESF_INDOORGRAPH_DESCRIPTION_CLICK_BACK @"1-201003" //点击返回
#define ESF_INDOORGRAPH_DESCRIPTION_CLICK_DELETE @"1-201004" //点击删除
#define ESF_INDOORGRAPH_DESCRIPTION_SLIDE @"1-201005" //滑动图片（是否滑过）
#define ESF_INDOORGRAPH_DESCRIPTION_INPUT @"1-201006" //填写描述
#define ESF_INDOORGRAPH_DESCRIPTION_CLICK_SAVE @"1-201007" //点击保存


/*
 所有模块: 二手房室内图拍照页
 */
#define ESF_TAKE_INDOORGRAPH @"1-202000"     //PageID
#define ESF_TAKE_INDOORGRAPH_ONVIEW @"1-202001" //页面可见
#define ESF_TAKE_INDOORGRAPH_CLICK_PHOTO @"1-202002" //点击拍照按钮
#define ESF_TAKE_INDOORGRAPH_CLICK_DELETE @"1-202003" //点击删除
#define ESF_TAKE_INDOORGRAPH_CLICK_CANCEL @"1-202004" //点击取消
#define ESF_TAKE_INDOORGRAPH_CLICK_SAVE @"1-202005" //点击确定


/*
 所有模块: 二手房从相册选择室内图页
 */
#define ESF_SELECT_INDOORGRAPH @"1-203000" //PageID
#define ESF_SELECT_INDOORGRAPH_ONVIEW @"1-203001" //页面可见
#define ESF_SELECT_INDOORGRAPH_CLICK_SAVE @"1-203002" //点击保存
#define ESF_SELECT_INDOORGRAPH_CLICK_CANCEL @"1-203003" //点击取消


/*
 所有模块: 二手房房型图从手机相册选择页
 */
#define ESF_SELECT_HOUSETYPEGRAPH @"1-204000"     //PageID
#define ESF_SELECT_HOUSETYPEGRAPH_ONVIEW @"1-204001" //页面可见
#define ESF_SELECT_HOUSETYPEGRAPH_CLICK_SAVE @"1-204002" //点击保存


/*
 所有模块: 发房-二手房小区选择页
 */
#define ESF_PUBLISH_SELECT_XIAOQU @"1-210000"     //PageId
#define ESF_PUBLISH_SELECT_XIAOQU_ONVIEW @"1-210001" //页面可见（即页面打开）
#define AJK_COMMUNITY_002 @"1-210002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define ESF_PUBLISH_SELECT_XIAOQU_INPUT @"1-210003" //输入小区
#define ESF_PUBLISH_SELECT_XIAOQU_CLICK_FUJIN @"1-210004" //点击附近的小区
#define ESF_PUBLISH_SELECT_XIAOQU_CLICK_HISTORY @"1-210005" //点击历史小区
#define ESF_PUBLISH_SELECT_XIAOQU_CLICK_NORESULT @"1-210006" //搜索无结果页可见

/*
 所有模块: 二手房在线房型图选择页
 */
#define ESF_SELECT_ONLINE_HOUSETYPEGRAPH @"1-220000" //PageID
#define ESF_SELECT_ONLINE_HOUSETYPEGRAPH_ONVIEW @"1-220001" //页面可见（即页面打开）
#define AJK_ONLINE_002 @"1-220002" //
#define ESF_SELECT_ONLINE_HOUSETYPEGRAPH_BACK  @"1-220003" //点击返回
#define ESF_SELECT_ONLINE_HOUSETYPEGRAPH_SAVE @"1-220004" //点击确定

//二手房计划管理
#define AJK_PPC_HOME @"1-230000"
#define AJK_PPC_HOME_001 @"1-230001"
#define AJK_PPC_HOME_002 @"1-230002"
#define AJK_PPC_HOME_003 @"1-230003" //点击竞价房源
#define AJK_PPC_HOME_004 @"1-230004" //点击定价推广组
#define AJK_PPC_HOME_005 @"1-230005" //点击未推广房源
#define AJK_PPC_HOME_006 @"1-230006" //发布房源

//二手房竞价房源列表页
#define AJK_PPC_BID_DETAIL @"1-240000"
#define AJK_PPC_BID_DETAIL_001 @"1-240001" //页面可见（即页面打开）
#define AJK_PPC_BID_DETAIL_002 @"1-240002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_BID_DETAIL_003 @"1-240003" //点击返回
#define AJK_PPC_BID_DETAIL_004 @"1-240004" //点击新增
#define AJK_PPC_BID_DETAIL_005 @"1-240005" //点击修改房源信息
#define AJK_PPC_BID_DETAIL_006 @"1-240006" //点击竞价出价&预算
#define AJK_PPC_BID_DETAIL_007 @"1-240007" //点击暂停竞价推广
#define AJK_PPC_BID_DETAIL_008 @"1-240008" //点击重新开始竞价
#define AJK_PPC_BID_DETAIL_009 @"1-240009" //点击取消竞价推广

//二手房定价组房源列表页
#define AJK_PPC_FIXED_DETAIL @"1-250000"
#define AJK_PPC_FIXED_DETAIL_001 @"1-250001" //页面可见（即页面打开）
#define AJK_PPC_FIXED_DETAIL_002 @"1-250002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_FIXED_DETAIL_003 @"1-250003" //点击停止推广
#define AJK_PPC_FIXED_DETAIL_004 @"1-250004" //点击修改限额
#define AJK_PPC_FIXED_DETAIL_005 @"1-250005" //点击添加房源
#define AJK_PPC_FIXED_DETAIL_006 @"1-250006" //点击竞价推广本房源
#define AJK_PPC_FIXED_DETAIL_007 @"1-250007" //点击取消定价推广
#define AJK_PPC_FIXED_DETAIL_008 @"1-250008" //点击修改房源信息
#define AJK_PPC_FIXED_DETAIL_009 @"1-250009" //点击开始推广

//二手房未推广房源列表页
#define AJK_PPC_NOPLAN_GROUP @"1-260000"
#define AJK_PPC_NOPLAN_GROUP_001 @"1-260001" //页面可见（即页面打开）
#define AJK_PPC_NOPLAN_GROUP_002 @"1-260002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_NOPLAN_GROUP_003 @"1-260003" //点击返回
#define AJK_PPC_NOPLAN_GROUP_004 @"1-260004" //点击全选
#define AJK_PPC_NOPLAN_GROUP_005 @"1-260005" //点击定价推广
#define AJK_PPC_NOPLAN_GROUP_006 @"1-260006" //点击编辑
#define AJK_PPC_NOPLAN_GROUP_007 @"1-260007" //点击删除

//二手房竞价设置页
#define AJK_PPC_AUCTION @"1-270000"
#define AJK_PPC_AUCTION_001 @"1-270001" //页面可见（即页面打开）
#define AJK_PPC_AUCTION_002 @"1-270002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_AUCTION_003 @"1-270003" //点击取消
#define AJK_PPC_AUCTION_004 @"1-270004" //点击确定
#define AJK_PPC_AUCTION_005 @"1-270005" //点击估排名

//二手房选定价推广组页
#define AJK_PPC_GROUP_LIST @"1-280000"
#define AJK_PPC_GROUP_LIST_001 @"1-280001" //页面可见（即页面打开）
#define AJK_PPC_GROUP_LIST_002 @"1-280002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_GROUP_LIST_003 @"1-280003" //点击返回
#define AJK_PPC_GROUP_LIST_004 @"1-280004" //点击定价组

//二手房修改定价限额页
#define AJK_PPC_MODIFY @"1-290000"
#define AJK_PPC_MODIFY_001 @"1-290001" //页面可见（即页面打开）
#define AJK_PPC_MODIFY_002 @"1-290002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_MODIFY_003 @"1-290003" //点击确定
#define AJK_PPC_MODIFY_004 @"1-290004" //点击取消

//二手房定价添加房源页
#define AJK_PPC_SELECT @"1-300000"
#define AJK_PPC_SELECT_001 @"1-300001" //页面可见（即页面打开）
#define AJK_PPC_SELECT_002 @"1-300002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_SELECT_003 @"1-300003" //点击确定
#define AJK_PPC_SELECT_004 @"1-300004" //点击取消

//二手房竞价添加房源页
#define AJK_PPC_PROPERTY @"1-310000"
#define AJK_PPC_PROPERTY_001 @"1-310001" //页面可见（即页面打开）
#define AJK_PPC_PROPERTY_002 @"1-310002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_PPC_PROPERTY_003 @"1-310003" //点击取消
#define AJK_PPC_PROPERTY_004 @"1-310004" //点击房源

/*
 所有模块: 二手房修改房源信息页
 */
#define ESF_EDIT_PROP @"1-320000"     //PageID
#define ESF_EDIT_PROP_ONVIEW @"1-320001" //页面可见（即页面打开）
#define AJK_PPC_RESET_002 @"1-320002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define ESF_EDIT_PROP_CLICK_CANCEL @"1-320003" //点击取消
#define ESF_EDIT_PROP_CLICK_SAVE @"1-320004" //点击保存
#define AJK_PPC_RESET_005 @"1-320005" //点击删除
#define AJK_PPC_RESET_006 @"1-320006" //点击定价推广
#define AJK_PPC_RESET_007 @"1-320007" //点击定价且竞价推广
#define AJK_PPC_RESET_008 @"1-320008" //点击暂不推广
#define AJK_PPC_RESET_009 @"1-320009" //点击添加室内图
#define AJK_PPC_RESET_010 @"1-320010" //点击添加室内图-拍照
#define AJK_PPC_RESET_011 @"1-320011" //点击添加室内图-从相册选择
#define AJK_PPC_RESET_012 @"1-320012" //点击添加房型图
#define AJK_PPC_RESET_013 @"1-320013" //点击房型图-从相册选择
#define AJK_PPC_RESET_014 @"1-320014" //点击房型图-在线房型图
#define ESF_EDIT_PROP_CLICK_ADD_INDOORGRAPH @"1-320021" //点击添加室内图 reference description
#define ESF_EDIT_PROP_CLICK_TAKE_INDOORGRAPH @"1-320022" //点击添加室内图-拍照
#define ESF_EDIT_PROP_CLICK_SELECT_INDOORGRAPH @"1-320023" //点击添加室内图-从相册选择
#define ESF_EDIT_PROP_CLICK_ADD_HOUSETYPEGRAPH @"1-320024" //点击添加房型图
#define ESF_EDIT_PROP_CLICK_SELECT_HOUSETYPEGRAPH @"1-320025" //点击房型图-从相册选择
#define ESF_EDIT_PROP_CLICK_ONLINE_HOUSETYPEGRAPH @"1-320026" //点击房型图-在线房型图
#define ESF_EDIT_PROP_CLICK_INDOORGRAPH @"1-320027" //点击已添加的室内图
#define ESF_EDIT_PROP_CLICK_DELETE @"1-320028" //点击删除



//二手房房型页面
#define AJK_HOUSETYPE @"1-330000"
#define AJK_HOUSETYPE_001 @"1-330001" //页面可见（即页面打开）
#define AJK_HOUSETYPE_002 @"1-330002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_HOUSETYPE_003 @"1-330003" //点击输入房型
#define AJK_HOUSETYPE_004 @"1-330004" //点击选择朝向
#define AJK_HOUSETYPE_005 @"1-330005" //点击选择在线房型图
#define AJK_HOUSETYPE_006 @"1-330006" //点击返回
#define AJK_HOUSETYPE_007 @"1-330007" //点击确定

//二手房标题输入页面
#define ESF_PUBLISH_TITLE @"1-340000" //PageID
#define AJK_TITLE_001 @"1-340001" //页面可见（即页面打开）
#define AJK_TITLE_002 @"1-340002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_TITLE_003 @"1-340003" //点击语音输入
#define ESF_PUBLISH_TITLE_WORDS @"1-340004" //点击文字输入
#define AJK_TITLE_005 @"1-340005" //点击返回
#define AJK_TITLE_006 @"1-340006" //点击确定



//租房标题输入页面
#define HZ_TITLE @"1-540000"
#define HZ_TITLE_001 @"1-540001" //页面可见（即页面打开）
#define HZ_TITLE_002 @"1-540002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define HZ_TITLE_003 @"1-540003" //点击语音输入
#define HZ_TITLE_004 @"1-540004" //点击文字输入
#define HZ_TITLE_005 @"1-540005" //点击返回
#define HZ_TITLE_006 @"1-540006" //点击确定

//二手房描述输入页面
#define AJK_DESC @"1-350000"
#define AJK_DESC_001 @"1-350001" //页面可见（即页面打开）
#define AJK_DESC_002 @"1-350002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define AJK_DESC_003 @"1-350003" //点击语音输入
#define AJK_DESC_004 @"1-350004" //点击文字输入
#define AJK_DESC_005 @"1-350005" //点击返回
#define AJK_DESC_006 @"1-350006" //点击确定

//租房描述输入页面
#define HZ_DESC @"1-550000"
#define HZ_DESC_001 @"1-550001" //页面可见（即页面打开）
#define HZ_DESC_002 @"1-550002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define HZ_DESC_003 @"1-550003" //点击语音输入
#define HZ_DESC_004 @"1-550004" //点击文字输入
#define HZ_DESC_005 @"1-550005" //点击返回
#define HZ_DESC_006 @"1-550006" //点击确定

//租房房型页面
#define HZ_HOUSETYPE @"1-530000"
#define HZ_HOUSETYPE_001 @"1-530001" //页面可见（即页面打开）
#define HZ_HOUSETYPE_002 @"1-530002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define HZ_HOUSETYPE_003 @"1-530003" //点击输入房型
#define HZ_HOUSETYPE_004 @"1-530004" //点击选择朝向
#define HZ_HOUSETYPE_005 @"1-530005" //点击选择在线房型图
#define HZ_HOUSETYPE_006 @"1-530006" //点击返回
#define HZ_HOUSETYPE_007 @"1-530007" //点击确定

/*
 所有模块: 租房发布页
 */
#define ZF_PUBLISH @"1-400000"      //PageID
#define ZF_PUBLISH_ONVIEW @"1-400001" //页面可见（即页面打开） 记bp值（页面id)
#define HZ_PROPERTY_002 @"1-400002" //
#define HZ_PROPERTY_003 @"1-400003" //点击取消  -- 问题
#define ZF_PUBLISH_SAVE @"1-400004" //点击保存
#define HZ_PROPERTY_005 @"1-400005" //点击房型图-拍照
#define HZ_PROPERTY_006 @"1-400006" //点击房型图-从相册选择
#define HZ_PROPERTY_007 @"1-400007" //点击房型图-在线房型图
#define ZF_PUBLISH_CLICK_FIX @"1-400008" //点击定价推广
#define ZF_PUBLISH_CLICK_BID @"1-400009" //点击定价且竞价推广
#define ZF_PUBLISH_CLICK_DRAFT @"1-400010" //点击暂不推广
#define HZ_PROPERTY_011 @"1-400011" //点击添加室内图
#define HZ_PROPERTY_012 @"1-400012" //点击添加室内图-拍照
#define HZ_PROPERTY_013 @"1-400013" //点击添加室内图-从相册选择
#define HZ_PROPERTY_014 @"1-400014" //点击添加房型图
#define HZ_PROPERTY_015 @"1-400015" //点击房型图-从相册选择
#define HZ_PROPERTY_016 @"1-400016" //点击房型图-在线房型图
#define ZF_PUBLISH_CLICK_ADD_INDOORGRAPH @"1-400021" //点击添加室内图
#define ZF_PUBLISH_CLICK_TAKE_INDOORGRAPH @"1-400022" //点击添加室内图-拍照
#define ZF_PUBLISH_CLICK_SELECT_INDOORGARPH @"1-400023" //点击添加室内图-从相册选择
#define ZF_PUBLISH_CLICK_ADD_HOUSETYPEGRAPH @"1-400024" //点击添加房型图
#define ZF_PUBLISH_CLICK_SELECT_HOUSETYPEGRAPH @"1-400025" //点击房型图-从相册选择
#define ZF_PUBLISH_CLICK_ONLINE_HOUSETYPEGRAPH @"1-400026" //点击房型图-在线房型图
#define ZF_PUBLISH_CLICK_INDOORGRAPH @"1-400027" //点击已添加的室内图

//租房室内图描述页
#define HZ_PROPERTY_HOUSEIMG_DES @"1-401000"
#define HZ_PROPERTY_HOUSEIMG_DES_001 @"1-401001" //页面可见,记bp值（页面id）
#define HZ_PROPERTY_HOUSEIMG_DES_003 @"1-401003" //点击返回
#define HZ_PROPERTY_HOUSEIMG_DES_004 @"1-401004" //点击删除
#define HZ_PROPERTY_HOUSEIMG_DES_005 @"1-401005" //左右滑动切换照片
#define HZ_PROPERTY_HOUSEIMG_DES_006 @"1-401006" //填写描述
#define HZ_PROPERTY_HOUSEIMG_DES_007 @"1-401007" //点击保存

//租房室内图拍照页
#define ZF_TAKE_INDOORGRAPH @"1-402000"
#define ZF_TAKE_INDOORGRAPH_ONVIEW @"1-402001" //页面可见,记bp值（页面id）
#define ZF_TAKE_INDOORGRAPH_CLICK_PHOTO @"1-402002" //点击拍照按钮
#define ZF_TAKE_INDOORGRAPH_CLICK_DELETE @"1-402003" //点击删除
#define ZF_TAKE_INDOORGRAPH_CLICK_CANCEL @"1-402004" //点击取消
#define ZF_TAKE_INDOORGRAPH_CLICK_SAVE @"1-402005" //点击确定

/*
 所有模块: 租房从相册选择室内图页
 */
#define ZF_SELECT_INDOORGRAPH @"1-403000"        // PageID
#define ZF_SELECT_INDOORGRAPH_ONVIEW @"1-403001" //页面可见
#define ZF_SELECT_INDOORGRAPH_CLICK_SAVE @"1-403002" //点击保存
#define ZF_SELECT_INDOORGRAPH_CLICK_CANCEL @"1-403003" //点击取消

/*
 所有模块: 租房房型图从手机相册选择页
 */
#define ZF_SELECT_HOUSETYPEGRAPH @"1-404000"
#define ZF_SELECT_HOUSETYPEGRAPH_ONVIEW @"1-404001" //页面可见
#define ZF_SELECT_HOUSETYPEGRAPH_CLICK_SAVE @"1-404002" //点击保存


/*
 所有模块: 发房-租房小区选择页
 */
#define ZF_PUBLISH_SELECT_XIAOQU @"1-410000"     //PageId
#define ZF_PUBLISH_SELECT_XIAOQU_ONVIEW @"1-410001" //页面可见（即页面打开）
#define HZ_COMMUNITY_002 @"1-410002" //
#define ZF_PUBLISH_SELECT_XIAOQU_INPUT @"1-410003" //输入小区
#define ZF_PUBLISH_SELECT_XIAOQU_CLICK_FUJIN @"1-410004" //点击附近的小区
#define ZF_PUBLISH_SELECT_XIAOQU_CLICK_HISTORY @"1-410005" //点击历史小区
#define ZF_PUBLISH_SELECT_XIAOQU_CLICK_NORESULT @"1-410006" //搜索无结果页可见

//租房在线房型图选择页
#define ZF_SELECT_ONLINE_HOUSETYPEGRAPH @"1-420000" //PageID
#define ZF_SELECT_ONLINE_HOUSETYPEGRAPH_ONVIEW @"1-420001" //页面可见（即页面打开）
#define HZ_ONLINE_002 @"1-420002" //
#define ZF_SELECT_ONLINE_HOUSETYPEGRAPH_BACK @"1-420003" //点击返回
#define ZF_SELECT_ONLINE_HOUSETYPEGRAPH_SAVE @"1-420004" //点击确定

//租房管理页
#define HZ_PPC_HOME @"1-430000"
#define HZ_PPC_HOME_001 @"1-430001" //
#define HZ_PPC_HOME_002 @"1-430002" //
#define HZ_PPC_HOME_003 @"1-430003" //点击竞价房源
#define HZ_PPC_HOME_004 @"1-430004" //点击定价推广组
#define HZ_PPC_HOME_005 @"1-430005" //点击未推广房源
#define HZ_PPC_HOME_006 @"1-430006" //发布房源

//租房竞价房源列表页
#define HZ_PPC_BID_DETAIL @"1-440000"
#define HZ_PPC_BID_DETAIL_001 @"1-440001" //
#define HZ_PPC_BID_DETAIL_002 @"1-440002" //
#define HZ_PPC_BID_DETAIL_003 @"1-440003" //点击返回
#define HZ_PPC_BID_DETAIL_004 @"1-440004" //点击新增
#define HZ_PPC_BID_DETAIL_005 @"1-440005" //点击修改房源信息
#define HZ_PPC_BID_DETAIL_006 @"1-440006" //点击竞价出价&预算
#define HZ_PPC_BID_DETAIL_007 @"1-440007" //点击暂停竞价推广
#define HZ_PPC_BID_DETAIL_008 @"1-440008" //点击重新开始竞价
#define HZ_PPC_BID_DETAIL_009 @"1-440009" //点击取消竞价推广

//租房定价组房源列表页
#define HZ_PPC_FIXED_DETAIL @"1-450000"
#define HZ_PPC_FIXED_DETAIL_001 @"1-450001" //
#define HZ_PPC_FIXED_DETAIL_002 @"1-450002" //
#define HZ_PPC_FIXED_DETAIL_003 @"1-450003" //点击停止推广
#define HZ_PPC_FIXED_DETAIL_004 @"1-450004" //点击修改限额
#define HZ_PPC_FIXED_DETAIL_005 @"1-450005" //点击添加房源
#define HZ_PPC_FIXED_DETAIL_006 @"1-450006" //点击竞价推广本房源
#define HZ_PPC_FIXED_DETAIL_007 @"1-450007" //点击取消定价推广
#define HZ_PPC_FIXED_DETAIL_008 @"1-450008" //点击修改房源信息
#define HZ_PPC_FIXED_DETAIL_009 @"1-450009" //开始定价推广

//租房未推广房源列表页
#define HZ_PPC_NO_PLAN @"1-460000"
#define HZ_PPC_NO_PLAN_01 @"1-460001" //
#define HZ_PPC_NO_PLAN_02 @"1-460002" //
#define HZ_PPC_NO_PLAN_03 @"1-460003" //点击返回
#define HZ_PPC_NO_PLAN_04 @"1-460004" //点击全选
#define HZ_PPC_NO_PLAN_05 @"1-460005" //点击定价推广
#define HZ_PPC_NO_PLAN_06 @"1-460006" //点击编辑
#define HZ_PPC_NO_PLAN_07 @"1-460007" //点击删除

//租房竞价设置页
#define HZ_PPC_AUCTION @"1-470000"
#define HZ_PPC_AUCTION_001 @"1-470001" //
#define HZ_PPC_AUCTION_002 @"1-470002" //
#define HZ_PPC_AUCTION_003 @"1-470003" //点击取消
#define HZ_PPC_AUCTION_004 @"1-470004" //点击确定
#define HZ_PPC_AUCTION_005 @"1-470005" //点击估排名

//租房选定价推广组页
#define HZ_PPC_GROUP_LIST @"1-480000"
#define HZ_PPC_GROUP_LIST_001 @"1-480001" //
#define HZ_PPC_GROUP_LIST_002 @"1-480002" //
#define HZ_PPC_GROUP_LIST_003 @"1-480003" //点击返回
#define HZ_PPC_GROUP_LIST_004 @"1-480004" //点击定价组

//租房修改定价限额页
#define HZ_PPC_MODIFY @"1-490000"
#define HZ_PPC_MODIFY_001 @"1-490001" //
#define HZ_PPC_MODIFY_002 @"1-490002" //
#define HZ_PPC_MODIFY_003 @"1-490003" //点击确定
#define HZ_PPC_MODIFY_004 @"1-490004" //点击取消

//租房定价添加房源页
#define HZ_PPC_SELECT @"1-500000"
#define HZ_PPC_SELECT_001 @"1-500001" //
#define HZ_PPC_SELECT_002 @"1-500002" //
#define HZ_PPC_SELECT_003 @"1-500003" //点击确定
#define HZ_PPC_SELECT_004 @"1-500004" //点击取消

//租房竞价添加房源页
#define HZ_PPC_BID_NOPLAN @"1-510000"
#define HZ_PPC_BID_NOPLAN_001 @"1-510001" //
#define HZ_PPC_BID_NOPLAN_002 @"1-510002" //
#define HZ_PPC_BID_NOPLAN_003 @"1-510003" //点击确定
#define HZ_PPC_BID_NOPLAN_004 @"1-510004" //点击取消

/*
 所有模块: 租房修改房源信息页
 */
#define ZF_EDIT_PROP @"1-520000"     //PageID
#define ZF_EDIT_PROP_ONVIEW @"1-520001" //页面可见（即页面打开） 记bp值（页面id）
#define HZ_PPC_RESET_002 @"1-520002" //
#define ZF_EDIT_PROP_CLICK_CANCEL @"1-520003" //点击取消
#define ZF_EDIT_PROP_CLICK_SAVE @"1-520004" //点击保存
#define HZ_PPC_RESET_005 @"1-520005" //点击删除
#define HZ_PPC_RESET_006 @"1-520006" //点击定价推广
#define HZ_PPC_RESET_007 @"1-520007" //点击定价且竞价推广
#define HZ_PPC_RESET_008 @"1-520008" //点击暂不推广
#define HZ_PPC_RESET_009 @"1-520009" //点击添加室内图
#define HZ_PPC_RESET_010 @"1-520010" //点击添加室内图-拍照
#define HZ_PPC_RESET_011 @"1-520011" //点击添加室内图-从相册选择
#define HZ_PPC_RESET_012 @"1-520012" //点击添加房型图
#define HZ_PPC_RESET_013 @"1-520013" //点击房型图-从相册选择
#define HZ_PPC_RESET_014 @"1-520014" //点击房型图-在线房型图
#define ZF_EDIT_PROP_CLICK_ADD_INDOORGRAPH @"1-520021" //点击添加室内图
#define ZF_EDIT_PROP_CLICK_TAKE_INDOORGRAPH @"1-520022" //点击添加室内图-拍照
#define ZF_EDIT_PROP_CLICK_SELECT_INDOORGRAPH @"1-520023" //点击添加室内图-从相册选择
#define ZF_EDIT_PROP_CLICK_ADD_HOUSETYPEGRAPH @"1-520024" //点击添加房型图
#define ZF_EDIT_PROP_CLICK_SELECT_HOUSETYPEGRAPH @"1-520025" //点击房型图-从相册选择
#define ZF_EDIT_PROP_CLICK_ONLINE_HOUSETYPEGRAPH @"1-520026" //点击房型图-在线房型图
#define ZF_EDIT_PROP_CLICK_INDOORGRAPH @"1-520027" //点击已添加的室内图
#define ZF_EDIT_PROP_CLICK_DELETE @"1-520028" //点击删除


//系统消息页
#define HZ_SYSTEM @"1-600000"
#define HZ_SYSTEM_001 @"1-600001" //
#define HZ_SYSTEM_002 @"1-600002" //
#define HZ_SYSTEM_003 @"1-600003" //点击返回
#define HZ_SYSTEM_004 @"1-600004" //点击全文
#define HZ_SYSTEM_005 @"1-600005" //点击删除

//更多
#define HZ_MORE @"1-700000"
#define HZ_MORE_001 @"1-700001" //
#define HZ_MORE_002 @"1-700002" //
#define HZ_MORE_003 @"1-700003" //点击账户信息
#define HZ_MORE_004 @"1-700004" //提醒设置on到off
#define HZ_MORE_005 @"1-700005" //提醒设置off到on
#define HZ_MORE_006 @"1-700006" //点击检查更新
#define HZ_MORE_007 @"1-700007" //点击关于网络经纪人
#define HZ_MORE_008 @"1-700008" //点击联系客户主任
#define HZ_MORE_009 @"1-700009" //点击客服热线
#define HZ_MORE_010 @"1-700010" //短信通知on到off
#define HZ_MORE_011 @"1-700011" //短信通知off到on
#define HZ_MORE_012 @"1-700012" //点击呼叫客户主任
#define HZ_MORE_013 @"1-700013" //点击呼叫客服热线

//我的页
#define USER_CENTER @"1-701000"
#define USER_CENTER_001 @"1-701001" //页面可见
#define USER_CENTER_003 @"1-701003" //点击微聊达人icon
#define USER_CENTER_004 @"1-701004" //点击我的二维码
#define USER_CENTER_005 @"1-701005" //点击个人信息
#define USER_CENTER_006 @"1-701006" //点击联系客户主任
#define USER_CENTER_007 @"1-701007" //确定呼叫客户主任
#define USER_CENTER_008 @"1-701008" //点击客服热线
#define USER_CENTER_009 @"1-701009" //确定呼叫客服热线
#define USER_CENTER_010 @"1-701010" //点击系统设置

//系统设置页
#define SYSTEM_SETTING @"1-702000"
#define SYSTEM_SETTING_001 @"1-702001" //页面可见
#define SYSTEM_SETTING_004 @"1-702004" //短信通知on到off
#define SYSTEM_SETTING_005 @"1-702005" //短信通知off到on
#define SYSTEM_SETTING_006 @"1-702006" //点击版本更新
#define SYSTEM_SETTING_007 @"1-702007" //点击关于移动经纪人
//#define SYSTEM_SETTING_008 @"1-702008" //点击联系客户主任
//#define SYSTEM_SETTING_009 @"1-702009" //确定呼叫客户主任
//#define SYSTEM_SETTING_010 @"1-702010" //点击客服热线
//#define SYSTEM_SETTING_011 @"1-702011" //点击客服热线
#define SYSTEM_SETTING_012 @"1-702012" //点击退出登录

//发现页
#define FIND_PAGE @"1-801000"
#define FIND_PAGE_001 @"1-801001" //页面可见
#define FIND_PAGE_003 @"1-801003" //点击市场分析
#define FIND_PAGE_004 @"1-801004" //点击小区签到
#define FIND_PAGE_005 @"1-801005" //点击抢委托房源

//市场分析页
#define MARKET_ANALYSIS @"1-802000"
#define MARKET_ANALYSIS_001 @"1-802001" //页面可见
#define MARKET_ANALYSIS_003 @"1-802003" //下拉刷新

//小区签到页
#define COMMUNITY_CHECK @"1-803000"
#define COMMUNITY_CHECK_001 @"1-803001" //页面可见
#define COMMUNITY_CHECK_003 @"1-803003" //点击小区
#define COMMUNITY_CHECK_004 @"1-803004" //点击刷新
#define COMMUNITY_CHECK_005 @"1-803005" //上拉加载更多小区
#define COMMUNITY_CHECK_006 @"1-803006" //点击返回
#define COMMUNITY_CHECK_007 @"1-803007" //点击右上角【规则】

//签到单页
#define CHECK_PAGE @"1-804000"
#define CHECK_PAGE_001 @"1-804001" //页面可见
#define CHECK_PAGE_003 @"1-804003" //点击立即签到
#define CHECK_PAGE_004 @"1-804004" //点击右上角【规则】/【了解签到规则】

//业主委托-抢委托页
#define ENTRUST_ROB_PAGE @"1-805000"
#define ENTRUST_ROB_PAGE_001 @"1-805001" //页面可见记录bp值（页面id）；从通知栏过来，记为push
#define ENTRUST_ROB_PAGE_003 @"1-805003" //点击抢委托记房源编号（propid）
#define ENTRUST_ROB_PAGE_004 @"1-805004" //下拉刷新
#define ENTRUST_ROB_PAGE_005 @"1-805005" //上拉加载房源
#define ENTRUST_ROB_PAGE_006 @"1-805006" //点击返回

//业主委托-我的委托
#define ENTRUST_ME_PAGE @"1-806000"
#define ENTRUST_ME_PAGE_001 @"1-806001" //页面可见
#define ENTRUST_ME_PAGE_003 @"1-806003" //点击拨打电话记房源编号（propid）
#define ENTRUST_ME_PAGE_004 @"1-806004" //确定呼出电话
#define ENTRUST_ME_PAGE_005 @"1-806005" //上拉加载更多
#define ENTRUST_ME_PAGE_006 @"1-806006" //点击返回



//发现
#define FIND_001 @"1-800001" //页面可见（即页面打开）
#define FIND_002 @"1-800002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)

//消息列表页
#define MESSAGE_LIST_001 @"1-900001" //页面可见（即页面打开）
#define MESSAGE_LIST_002 @"1-900002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define MESSAGE_LIST_003 @"1-900003" //点击右上角“+”
#define MESSAGE_LIST_004 @"1-900004" //点击查看对话
#define MESSAGE_LIST_005 @"1-900005" //点击删除对话
#define MESSAGE_LIST_006 @"1-900006" //点击【移动经纪人】

//聊天单页
#define CHATVIEW_001 @"1-910001" //页面可见（即页面打开）
#define CHATVIEW_002 @"1-910002" //页面不可见(按home，锁屏，应用切换,打电话不包括按返回键)
#define CHATVIEW_003 @"1-910003" //点击输入框
#define CHATVIEW_004 @"1-910004" //点击“+”
#define CHATVIEW_005 @"1-910005" //点击拍照
#define CHATVIEW_006 @"1-910006" //点击从相册选择
#define CHATVIEW_007 @"1-910007" //点击发二手房
#define CHATVIEW_008 @"1-910008" //点击发租房
#define CHATVIEW_009 @"1-910009" //点击右上角icon进入客户单页
#define CHATVIEW_010 @"1-910010" //点击电话号码
#define CHATVIEW_011 @"1-910011" //点击拨打电话
#define CHATVIEW_012 @"1-910012" //点击保存电话至客户资料
#define CHATVIEW_013 @"1-910013" //点击返回
#define CHATVIEW_014 @"1-910014" //消息发送失败

#define CHATVIEW_015 @"1-910015" //点击发位置
#define CHATVIEW_016 @"1-910016" //点击切换至语言
#define CHATVIEW_017 @"1-910017" //点击切换至文字
#define CHATVIEW_018 @"1-910018" //按住说话
#define CHATVIEW_019 @"1-910019" //取消发送语音
#define CHATVIEW_020 @"1-910020" //点击查看位置
#define CHATVIEW_021 @"1-910021" //点击切换至表情

//位置选择页
#define LOCATION_CHOOSE_001 @"1-960001" //页面可见
#define LOCATION_CHOOSE_002 @"1-960002" //页面不可见
#define LOCATION_CHOOSE_003 @"1-960003" //点击发送
#define LOCATION_CHOOSE_004 @"1-960004" //点击返回
#define LOCATION_CHOOSE_005 @"1-960005" //移动标点

//位置查看页
#define LOCATION_VIEW_001 @"1-970001" //页面可见
#define LOCATION_VIEW_002 @"1-970002" //页面不可见
#define LOCATION_VIEW_003 @"1-970003" //点击导航
#define LOCATION_VIEW_004 @"1-970004" //点击返回
#define LOCATION_VIEW_005 @"1-970005" //点击显示路线
#define LOCATION_VIEW_006 @"1-970006" //点击第三方地图导航
#define LOCATION_VIEW_007 @"1-970007" //点击查看全景地图(Android)


//二手房小区选择页
#define ESF_COMMUNITY_CHAT_001 @"1-920001"
#define ESF_COMMUNITY_CHAT_002 @"1-920002"
#define ESF_COMMUNITY_CHAT_003 @"1-920003"
#define ESF_COMMUNITY_CHAT_004 @"1-920004"

//租房小区选择页
#define ZF_COMMUNITY_CHAT_001 @"1-940001"
#define ZF_COMMUNITY_CHAT_002 @"1-940002"
#define ZF_COMMUNITY_CHAT_003 @"1-940003"
#define ZF_COMMUNITY_CHAT_004 @"1-940004"

//二手房房源选择页
#define ESF_PROPERTY_CHAT_001 @"1-930001"
#define ESF_PROPERTY_CHAT_002 @"1-930002"
#define ESF_PROPERTY_CHAT_003 @"1-930003"
#define ESF_PROPERTY_CHAT_004 @"1-930004"

//租房房源选择页
#define ZF_PROPERTY_CHAT_001 @"1-950001"
#define ZF_PROPERTY_CHAT_002 @"1-950002"
#define ZF_PROPERTY_CHAT_003 @"1-950003"
#define ZF_PROPERTY_CHAT_004 @"1-950004"

//客户列表
#define CLIENT_LIST_001 @"1-1000001"
#define CLIENT_LIST_002 @"1-1000002"
#define CLIENT_LIST_003 @"1-1000003"
#define CLIENT_LIST_004 @"1-1000004"
#define CLIENT_LIST_005 @"1-1000005"
#define CLIENT_LIST_006 @"1-1000006"
//点击公众账号【移动经纪人】
#define CLIENT_LIST_008 @"1-1000008" //点击公众账号【移动经纪人】

//客户单页
#define CLIENT_DETAIL_001 @"1-1100001"
#define CLIENT_DETAIL_002 @"1-1100002"
#define CLIENT_DETAIL_003 @"1-1100003"
#define CLIENT_DETAIL_004 @"1-1100004"
#define CLIENT_DETAIL_005 @"1-1100005"
#define CLIENT_DETAIL_006 @"1-1100006"
#define CLIENT_DETAIL_007 @"1-1100007"
#define CLIENT_DETAIL_008 @"1-1100008"
#define CLIENT_DETAIL_009 @"1-1100009"
#define CLIENT_DETAIL_010 @"1-1100010"
#define CLIENT_DETAIL_011 @"1-1100011"
#define CLIENT_DETAIL_012 @"1-1100012"

//备注页面
#define CLIENT_EDIT_001 @"1-1200001"
#define CLIENT_EDIT_002 @"1-1200002"
#define CLIENT_EDIT_003 @"1-1200003"
#define CLIENT_EDIT_004 @"1-1200004"
#define CLIENT_EDIT_005 @"1-1200005"

//登录页
#define APP_LOGIN @"1-1300000"
#define APP_LOGIN_001 @"1-1300001"
#define APP_LOGIN_002 @"1-1300002"
#define APP_LOGIN_003 @"1-1300003"
#define APP_LOGIN_004 @"1-1300004"
//选择客户页
#define CUSTOM_CHOOSE @"1-980000"
#define CUSTOM_CHOOSE_001 @"1-980001"
#define CUSTOM_CHOOSE_002 @"1-980002"
#define CUSTOM_CHOOSE_003 @"1-980003"
#define CUSTOM_CHOOSE_004 @"1-980004"

#endif
 // //