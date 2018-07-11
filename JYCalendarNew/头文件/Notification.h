//
//  Notification.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/19.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#ifndef Notification_h
#define Notification_h



//********************************通知********************************//

#define kNotificationForLeave @"kNotificationForLeave"

//列表页面操作完成加载数据的通知
#define kNotificationForListLoadData @"kNotificationForListLoadData"

//加载完成的通知
#define kNotificationForLoadData @"kNotificationForLoadData"

//列表刷新通知
#define kNotificationForUpDate @"kNotificationForUpDate"
//列表管理者刷新通知
#define kNotificationForManagerUpDate @"kNotificationForManagerUpDate"


//添加完新朋友的通知(接收方)
#define kNotificationForNewFriend @"kNotificationForNewFriend"

//添加好友请求发送成功
#define kNotificationForAddNewFriend @"kNotificationForAddNewFriend"

//通过通讯录添加新朋友(申请方)
#define kNotificationForApplyFriden @"kNotificationForApplyFriden"

//新建群组完成的通知
#define kNotificationForCreateGroup @"kNotificationForCreateGroup"

//添加朋友成功调用
#define kNotificationForAcceptFriend @"kNotificationForAcceptFriend"

//删除群组
#define kNotificationForDeleteGroup @"kNotificationForDeleteGroup"

//上传意见返回回调通知
#define kNotificationForBackSetView @"kNotificationForBackSetView"


//直接从选择组跳到提醒页面
#define kNotificationForGroupPassRemind @"kNotificationForGroupPassRemind"
#define kNotificationForGroupJumpToRemindList @"kNotificationForGroupJumpToRemindList"

//在好友列表里添加提醒界面，跳到主界面
#define kNotificationForGoRootVC @"kNotificationForGoRootVC"
//隐藏编辑按钮的通知
#define kNotificationForHiddenEditBtn @"kNotificationForHiddenEditBtn"
#define kNotificationForSendHiddenEditBtn @"kNotificationForSendHiddenEditBtn"
#define kNotificationForAcceptHiddenEditBtn @"kNotificationForAcceptHiddenEditBtn"

//改变选择蓝的颜色
#define kNotificationForChangeSelectBg @"kNotificationForChangeSelectBg"

//手机号注册时候验证时间的通知
#define kNotificationForTest @"kNotificationForTest"

//确定验证码和手机号准去无误清空手机号和验证码
#define kNotificationForTestAndIphone @"kNotificationForTestAndIphone"

//通知个人中心刷新
#define kNotificationForPersonSkin @"kNotificationForPersonSkin"

//通知设置页面刷新
#define kNotificationForSetSkin @"kNotificationForSetSkin"

//通知列表页面刷新
#define kNotificationForListSkin @"kNotificationForListSkin"

//换肤通知-通用
#define kNotificationForChangeSkin @"kNotificationForChangeSkin"

#define kLocalNotification_key @"kLocalNotification_key"

//删除本地保存文件
#define kNotificationDeleteImage @"kNotificationDeleteImage"

//刷新未读提醒角标
#define kNotificationRefreshUnreadRemindLabel @"kNotificationRefreshUnreadRemindLabel"

//总列表页刷新通知
#define kNotificationForLoadAllListRemind @"kNotificationForLoadAllListRemind"

//更改密码
#define kNotificationForChangeSecret @"kNotificationForChangeSecret"
//合并账号刷新列表
#define kNotificationForChangeSecretList @"kNotificationForCHageSecretList"

//重新加载便签列表
#define kNotificationForReloadNoteList @"kNotificationForReloadNoteList"
#define kNotificationForPopNote @"kNotificationForPopNote"

//重新刷新通讯录好友列表（更改备注）
#define kNotificationForReloadRemark @"kNotificationForReloadRemark"

#define kNotificationForClanderPostionChanged @"kNotificationForClanderPostionChanged"

#define kClanderPostionShown @"kClanderPostionShown"
#define kClanderPostionHidden @"kClanderPostionHidden"



//绑定时候换代理
#define kNotificationForChangeDelegate @"kNotificationForChangeDelegate"


#define kNotificationReloadScanFilesFromServer @"kNotificationReloadScanFilesFromServer"
#define kNotificationReloadScanFilesFromDataBase @"kNotificationReloadScanFilesFromDataBase"


#define kNotificationForChangeList @"kNotificationForChangeList"

//天气模块添加新的城市
#define kNotificationWeatherAddNewCity @"kNotificationWeatherAddNewCity"
#define kNewCityKey @"kNewCityKey"
#define kChooseCityWeatherNotification @"kChooseCityWeatherNotification"
#define kChooseCityKey @"kChooseCityKey"

//首页天气视图高度改变
#define kNotificationForWeatherViewRefreshHeight @"kNotificationForWeatherViewRefreshHeight"

#endif /* Notification_h */
