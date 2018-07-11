//
//  JYRemindManager+CompatibleForiOS10.h
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/9/28.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRemindManager.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSInteger, AlarmRepeatsType){
    AlarmRepeatsTypeNone = 0,
    AlarmRepeatsTypeEveryMonday = 1,
    AlarmRepeatsTypeEveryTuesday = 2,
    AlarmRepeatsTypeEveryWednesday = 3,
    AlarmRepeatsTypeEveryThursday = 4,
    AlarmRepeatsTypeEveryFriday = 5,
    AlarmRepeatsTypeEverySaturday = 6,
    AlarmRepeatsTypeEverySunday = 7,
    AlarmRepeatsTypeEveryDay = 8,
};

@interface JYRemindManager (CompatibleForiOS10)

//添加提醒通知-iOS10
+ (void)addRemindNotificationsForiOS10WithModel:(RemindModel *)model;

//添加闹钟通知-iOS10
+ (void)addAlarmNotificationsForiOS10WithClockModel:(ClockModel *)model;

//重置所有提醒(闹钟和提醒)
+ (void)resetAllNotifications;

//移除提醒通知
+ (void)removeRemindNotificationWithModel:(RemindModel *)model;
//移除闹钟通知
+ (void)removeAlarmNotificationWithModel:(ClockModel *)model;
@end
