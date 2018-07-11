//
//  Header.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#ifndef JYCalendar_Header_h
#define JYCalendar_Header_h


/**
 *  引入的公用类
 */

#import "Tool.h"

//frame
#import "UIViewExt.h"

//日期转换类
#import "LunarCalendar.h"

//*****************************数据库******************************//

//收藏表
#import "CollectionList.h"

//事件表
#import "IncidentListManager.h"

//组表
#import "GroupListManager.h"

//好友列表
#import "FriendListManager.h"

//组和好友关系表
#import "FriendForGroupListManager.h"

//本地事件表
#import "LocalListManager.h"

//小秘数据库
#import "XiaomiDB.h"

//关联表，音乐提醒开关
#import "MusicListManager.h"

//闹钟表
#import "JYClockList.h"

//分享表
#import "JYShareList.h"

//未查看的信息
#import "JYNotReadList.h"

//系统消息表
#import "JYSystemList.h"

//密码
#import "PassWordList.h"
#import "PassWordTitleList.h"

//*****************************数据库******************************//


//提醒数据、管理
//提醒数据model

//****************************数据Model***************************//

//提醒页专用MODEL
//#import "YearAndMonthDayModel.h"

//阴历datePicker选择需要用到的数据
#import "LunarModel.h"

//事件model
#import "RemindModel.h"

//好友model
#import "FriendModel.h"

//提醒列表关联model
#import "RemindAndGFModel.h"

//组model
#import "GroupModel.h"

//闹钟model
#import "ClockModel.h"

//密码
#import "PassWordModel.h"
#import "PassWordTitleModel.h"


//****************************数据model***************************//

//增加减少通知管理者
#import "JYRemindManager.h"
#import "JYRemindManager+CompatibleForiOS10.h"

//阴阳互转第三方
#import "LunarSolarConverter.h"

//每次加载暂时存储的数据放在这里
#import "DataArray.h"

//存储当前时间
#import "DataForTime.h"

//网络管理
#import "RequestManager.h"

//管理通讯录的类
#import "AddressBook.h"

//返回日历数据的类
#import "JYToolForReturnAllArray.h"
#import "JYSelectManager.h"
#import "JYToolForCalendar.h"

//SD_WebImage
#import "UIImageView+WebCache.h"
#import "Masonry.h"

//Font和判断设备的类
#import "JYFontManager.h"

//引入Afn
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"

//引入zb
#import "QRCodeGenerator.h"
#import "ZBarSDK.h"

//引入菊花图
//#import "AppHelper.h"
#import "ProgressHUD.h"

//管理按钮的类
#import "ManagerForButton.h"

//换肤管理类
#import "JYSkinManager.h"

#import "RootTabViewController.h"

//swift头文件
#import "JYCalendarNew-swift.h"

#import "NSString+Common.h"
#import "UIColor+Common.h"
#import "UIImage+Common.h"
#import "ALAsset+Common.h"

#import "SVProgressHUD.h"
#import "GuideView.h"
#import "SinglePreview.h"

#import "NSNull+Patch.h"

#endif
