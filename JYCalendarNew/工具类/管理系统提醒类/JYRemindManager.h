//
//  JYRemindManager.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYRemindManager : NSObject

//增加通知
+ (void)addNotificationWithModel:(RemindModel *)model;

//取消通知
+ (void)cancelNotificationWithModel:(RemindModel *)model;

//闹铃
+ (void)addNotificationWithClockModel:(ClockModel *)model withMusicArr:(NSArray *)arrForMusic;

//删除闹钟
+ (void)deleteLocalNotificationForClock:(ClockModel *)model;



/**
 *  自定义星期添加提醒
 *
 *  @param model
 */
+ (void)addNotificationForRandomWeek:(RemindModel *)model;




@end
