//
//  JYRemindManager.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "JYCalculateRandomTime.h"
@implementation JYRemindManager

/*
 selectMonday = 1,
 selectTuesday = 2,
 selectWednesday = 3,
 selectThursday = 4,
 selectFriday = 5,
 selectSaturday = 6,
 selectSunday = 7,
 selectEveryDay = 8,
 selectEveryMonth = 9,
 selectEveryYear = 10,
 selectDay = 11,
 selectWeek = 12,
 selectMonth = 13,
 selectYear = 14,
 selectSomeDays = 15
*/

+ (typeForRandom)modelType:(NSInteger )type
{
    //1 周日 2 周一 3周二 4周三 5周四 6周五 7周六

    typeForRandom modelType = 0;
    switch (type) {
        case 1:
        {
            modelType=selectSunday;
        } break;
        case 2:
        {
            modelType=selectMonday;
        }break;
        case 3:
        {
            modelType=selectTuesday;
        }break;
        case 4:
        {
            modelType=selectWednesday;
        }break;
        case 5:
        {
            modelType=selectThursday;
        }break;
        case 6:
        {
            modelType=selectFriday;
        }break;
        case 7:
        {
            modelType=selectSaturday;
        }break;
            
        default:
            break;
    }
    
    return modelType;
}

+ (NSInteger)isRemindWithRandomType:(typeForRandom )type
                           andModel:(RemindModel *)model
                             andCom:(NSDateComponents *)comp
                      andNScalendar:(NSInteger )calendar
{
        switch (type) {
                //每周一
            case selectMonday:
            {
                calendar = kCFCalendarUnitWeek;
            }
                break;
                //每周二
            case selectTuesday:
            {
                calendar = kCFCalendarUnitWeek;
            }
                break;
                //每周三
            case selectWednesday:
            {
                calendar = kCFCalendarUnitWeek;
            }
                break;
                //每周四
            case selectThursday:
            {
                calendar = kCFCalendarUnitWeek;
            }
                break;
                //每周五
            case selectFriday:
            {
                calendar = kCFCalendarUnitWeek;
            }
                break;
                //每周六
            case selectSaturday:
            {
                calendar = kCFCalendarUnitWeek;
            }
                break;
                //每周日
            case selectSunday:
            {
                calendar = kCFCalendarUnitWeek;
            }
                break;
                //每天
            case selectEveryDay:
            {
                calendar = NSCalendarUnitDay;
            }
                break;
                //每月
            case selectEveryMonth:
            {
                calendar = NSCalendarUnitMonth;
            }
                break;
                //每年
            case selectEveryYear:
            {
                calendar = NSCalendarUnitYear;
            }
                break;
                //自定义日
            case selectDay:
            {
                
                calendar = 0;
            }
                break;
                //自定义周
            case selectWeek:
            {
                calendar = 0;
            }
                break;
                //自定义月
            case selectMonth:
            {
                calendar = 0;
            }
                break;
                //自定义年
            case selectYear:
            {
                calendar = 0;
            }
                break;
                
            default:
                break;
        }

    return calendar;
}

+ (void)aheadTimesAddNotification:(RemindModel *)model
                       components:(NSDateComponents *)components
{
   
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger calendarUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        
        //当前提醒时间
        NSDate *remindDate = [calendar dateFromComponents:components];
        NSInteger times = [remindDate timeIntervalSince1970] - model.offsetMinute * 60;
        NSDate *aheadTime = [NSDate dateWithTimeIntervalSince1970:times];
        
        NSDateComponents *com = [[NSDateComponents alloc] init];
        com = [calendar components:calendarUnit fromDate:aheadTime];
        
        model.randomType = 0;
        model.offsetMinute = 0;
        model.year = (int)com.year;
        model.month = (int)com.month;
        model.day = (int)com.day;
        model.hour = (int)com.hour;
        model.minute = (int)com.minute;
        
        [self addNotificationWithModel:model];
   
}

+ (void)addNotificationWithModel:(RemindModel *)model
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        if (model.randomType < 0) {
            return ;
        }
        
        int year = [[Tool actionForNowYear:nil] intValue];
        int month = [[Tool actionForNowMonth:nil] intValue];
        int day = [[Tool actionForNowSingleDay:nil] intValue];
        int hour = [[Tool actionforNowHour] intValue];
        int minute = [[Tool actionforNowMinute] intValue];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        NSInteger calendarType = 0;
        
        //重复状态下的判断
        if (model.randomType != 0) {
            
            //添加提醒
            calendarType = [JYRemindManager isRemindWithRandomType:model.randomType andModel:model andCom:components andNScalendar:calendarType];
            JYCalculateRandomTime *calculate = [JYCalculateRandomTime manager];
            [calculate calculateRandomModel:model];
            
            [components setYear:model.year_random];
            [components setMonth:model.month_random];
            [components setDay:model.day_random];
            [components setHour:model.hour];
            [components setMinute:model.minute];
            
            //提前提醒
            if (model.offsetMinute != 0) {
                [self aheadTimesAddNotification:model components:components];
            }
            
        }else{
        
            
            NSInteger nowTime = [[NSString stringWithFormat:@"%d%02d%02d%02d%02d",year,month,day,hour,minute] integerValue];
            NSInteger selectTime = [[NSString stringWithFormat:@"%d%02d%02d%02d%02d",model.year,model.month,model.day,model.hour,model.minute] integerValue];
            
            //如果当前时间大于设置提醒的时间，不添加提醒
            if (nowTime >= selectTime) {
                return ;
            }else{
                
                [components setYear:model.year];
                [components setMonth:model.month];
                [components setDay:model.day];
                [components setHour:model.hour];
                [components setMinute:model.minute];
               
                //提前提醒
                if (model.offsetMinute != 0) {
                    [self aheadTimesAddNotification:model components:components];
                }
            }
        }
        
//        NSArray *arrForMusic = @[@"幻觉.m4a",@"科技.m4a",@"蓝调.m4a",@"女声.m4a",@"月光.m4a",@"别动.m4a",@"喂哎.m4a",@""];
        NSArray *arrForMusic = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3",@""];
        
        if (model.musicName >= 9) {
            
            model.musicName = 1;
            
        }
        
        NSString *musicName = arrForMusic[model.musicName - 1];
        
        if ([musicName isEqualToString:@"科技-长.mp3"]) {
            
            NSLog(@"%@",model);
        };
        //[components setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *date = [calendar dateFromComponents:components];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        if (notification != nil) {
            //通知时间
            notification.fireDate = date;
            NSLog(@"%@",date);
            //通知声音
            notification.soundName = musicName;
            
            //通知时区
            notification.timeZone = nil;
            
            NSLog(@"%@",notification.fireDate);
            
            //通知循环时间
            notification.repeatInterval = calendarType;
            
            //通知内容
            notification.alertBody = [NSString stringWithFormat:@"%@\n%@",model.title,model.content];
            //JYLog(@"%@",[NSString stringWithFormat:@"%@\n%@",model.title,model.content]);
            //给notification增加标示
            NSDictionary *dicForNotification = [NSDictionary dictionaryWithObject:model.timeorder forKey:kLocalNotification_key];
            
            notification.userInfo = dicForNotification;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
        }
        
    });

}


+ (void)cancelNotificationWithModel:(RemindModel *)model
{
    //ios10
    if(kSystemVersion>=10.0){
        [JYRemindManager removeRemindNotificationWithModel:model];
        return;
    }
    
    NSArray *notification = [[UIApplication sharedApplication]scheduledLocalNotifications];
    for (UILocalNotification *notificationLocal in notification) {
        if ([[notificationLocal.userInfo objectForKey:kLocalNotification_key]isEqualToString:model.timeorder]) {
            [[UIApplication sharedApplication]cancelLocalNotification:notificationLocal];
            break;
        }
    }
    
}

//闹钟提醒
/*****************************************************************/
+ (void)addNotificationWithClockModel:(ClockModel *)model withMusicArr:(NSArray *)arrForMusic
{
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        if(model.musicID==0){
            model.musicID += 1;
        }
        
        NSString *musicName = arrForMusic[model.musicID - 1];
        int year = [[Tool actionForNowYear:nil] intValue];
        int month = [[Tool actionForNowMonth:nil] intValue];
        int day = [[Tool actionForNowSingleDay:nil] intValue];
        int hour = [[Tool actionforNowHour] intValue];
        int minute = [[Tool actionforNowMinute] intValue];

        
        if (model.week == nil || [model.week isEqualToString:@""]) {
         
            NSInteger createDay = [[model.timeOrder substringWithRange:NSMakeRange(0, 8)] integerValue];
            NSInteger nowDay = [[NSString stringWithFormat:@"%d%02d%02d",year,month,day] integerValue];
            
            //如果设定时间超过当天时间，过期不再提醒
            if ([Tool compTime:model.hour other:model.minute] && (nowDay == createDay)) {
                day++;
            }
            
            if (nowDay > createDay) {
                return ;
            }
            
            NSDateComponents *components = [[NSDateComponents alloc] init];
            [components setYear:year];
            [components setMonth:month];
            [components setDay:day];
            [components setHour:model.hour];
            [components setMinute:model.minute];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *date = [calendar dateFromComponents:components];
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            
            if (localNotification != nil) {
                
                //时间
                localNotification.fireDate = date;
                
                //音乐
                localNotification.soundName = musicName;
                //时区
//                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                //循环
                localNotification.repeatInterval = NSCalendarUnitEra;
                //通知内容
                localNotification.alertBody = [NSString stringWithFormat:@"%@",model.textStr];
                //标示
                NSDictionary *dicForNoti = [NSDictionary dictionaryWithObject:model.timeOrder forKey:kLocalNotification_key];
                
                localNotification.userInfo = dicForNoti;
                
                //添加通知
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            }
            
        }else{
           
            NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *nowCom = [[NSDateComponents alloc] init];
            [nowCom setYear:year];
            [nowCom setMonth:month];
            [nowCom setDay:day];
      
            NSDate *nowDate = [calendar1 dateFromComponents:nowCom];
            
            NSInteger nowTime = [[NSString stringWithFormat:@"%02d%02d",hour,minute]integerValue];
            NSInteger selectTime = [[NSString stringWithFormat:@"%02d%02d",model.hour,model.minute]integerValue];
            NSInteger nowDay = [Tool actionForNowWeek:nowDate];

            typeForRandom nowRandom   = [JYRemindManager modelType:nowDay];
            NSArray *weekArr = [model.week componentsSeparatedByString:@","];
          
            
            int setNFmonth = 0;
            int setNFyear  = 0;
            int setNFday   = 0;
            int addDay     = 0;
            
            typeForRandom setNFrandom = 0;
            
            //设置每周提醒
    
                setNFyear  = year;
                setNFmonth = month;
                setNFday   = day;
                setNFrandom = nowRandom;
          
            for (id randomType in weekArr) {
                
                int type = [randomType intValue] + 1;
                
                //相同时间
                if (type == setNFrandom) {
                    addDay = 0;
                    //随机时间大于当前时间
                }else if(type > setNFrandom){
                    addDay = type - setNFrandom;
                }else{
                    //随机时间小于当前时间
                    addDay = (7 - setNFrandom) + type;
                }
                
                //如果随机时间正好是当天且过了提醒时间，需要置为下周
                if (addDay == 0 && nowTime >= selectTime) {
                    addDay = 7;
                }
         
                NSDateComponents *comp = [[NSDateComponents alloc]init];
                [comp setYear:setNFyear];
                [comp setMonth:setNFmonth];
                [comp setDay:setNFday+addDay];
                [comp setHour:model.hour];
                [comp setMinute:model.minute];
                
                [JYRemindManager localNotificationForWeek:comp andModel:model musicArray:arrForMusic];
                
            }
        
        }
        
//    });
}



//每周
+ (void)localNotificationForWeek:(NSDateComponents *)components andModel:(ClockModel *)model musicArray:(NSArray *)arrForMusic
{
    
    
    
//    NSArray *arrForMusic = @[@"幻觉-长.mp3",@"科技-长.mp3",@"蓝调-长.mp3",@"女声-长.mp3",@"月光-长.mp3",@"别动-长.mp3",@"喂哎-长.mp3"];
//    NSArray *arrForMusic = @[@"幻觉.m4a",@"科技.m4a",@"蓝调.m4a",@"女声.m4a",@"月光.m4a",@"别动.m4a",@"喂哎.m4a"];
    if(model.musicID==0){
        model.musicID += 1;
    }
    NSString *musicName = arrForMusic[model.musicID - 1];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    
    NSDate *date = [calendar dateFromComponents:components];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    
    localNotification.soundName = musicName;
    
    localNotification.repeatInterval = kCFCalendarUnitWeek;
    
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = [NSString stringWithFormat:@"%@",model.textStr];
    //标示
    NSDictionary *dicForNoti = [NSDictionary dictionaryWithObject:model.timeOrder forKey:kLocalNotification_key];
    
    localNotification.userInfo = dicForNoti;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

//每天
+ (void)localNotificationForEveryDay:(ClockModel *)model musicArray:(NSArray *)arrForMusic
{
    
    int year = [[Tool actionForNowYear:nil] intValue];
    int month = [[Tool actionForNowMonth:nil] intValue];
    int day = [[Tool actionForNowSingleDay:nil] intValue];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:model.hour];
    [components setMinute:model.minute];
    
    
//    NSArray *arrForMusic = @[@"幻觉.m4a",@"科技.m4a",@"蓝调.m4a",@"女声.m4a",@"月光.m4a",@"别动.m4a",@"喂哎.m4a"];
    if(model.musicID==0){
        model.musicID += 1;
    }
    NSString *musicName = arrForMusic[model.musicID - 1];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    
    
    NSDate *date = [calendar dateFromComponents:components];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    localNotification.fireDate = date;
    
    localNotification.soundName = musicName;
    
    localNotification.repeatInterval = kCFCalendarUnitDay;
    
//    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = [NSString stringWithFormat:@"%@",model.textStr];
    //标示
    NSDictionary *dicForNoti = [NSDictionary dictionaryWithObject:model.timeOrder forKey:kLocalNotification_key];
    
    localNotification.userInfo = dicForNoti;
    
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

//删除提醒
+ (void)deleteLocalNotificationForClock:(ClockModel *)model
{
    
    NSArray *arrForLocal = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (int i = 0; i < arrForLocal.count; i ++) {
        
        UILocalNotification *localNotification = arrForLocal[i];
        
        NSDictionary *dic = localNotification.userInfo;
        
        if ([[dic objectForKey:kLocalNotification_key] isEqualToString:model.timeOrder]) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            
        }
        
    }
}

/*******************************************************************/
#pragma mark 自定义星期相关 //weekStr = @"1,2,3"
+ (void)addNotificationForRandomWeek:(RemindModel *)model
{
    
    int year = [[Tool actionForNowYear:nil] intValue];
    int month = [[Tool actionForNowMonth:nil] intValue];
    int day = [[Tool actionForNowSingleDay:nil] intValue];
    int hour = [[Tool actionforNowHour] intValue];
    int minute = [[Tool actionforNowMinute] intValue];
    
    NSInteger nowTime = [[NSString stringWithFormat:@"%02d%02d",hour,minute]integerValue];
    NSInteger selectTime = [[NSString stringWithFormat:@"%02d%02d",model.hour,model.minute]integerValue];
    
    
    NSInteger now = [[NSString stringWithFormat:@"%d%02d%02d",year,month,day]integerValue];
    NSInteger select = [[NSString stringWithFormat:@"%d%02d%02d",model.year,model.month,model.day]integerValue];
    
    //当前时间大于、等于设置时间才有提醒
    BOOL isRemind = now > select ? YES:NO;
    
    //记录时间与当前时间的差值天数
    NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nowCom = [[NSDateComponents alloc] init];
    [nowCom setYear:year];
    [nowCom setMonth:month];
    [nowCom setDay:day];
    NSDateComponents *selectCom = [[NSDateComponents  alloc] init];
    [selectCom setYear:model.year];
    [selectCom setMonth:model.month];
    [selectCom setDay:model.day];
    NSDate *nowDate = [calendar1 dateFromComponents:nowCom];
    NSDate *selectDate = [calendar1 dateFromComponents:selectCom];
    
    
    NSInteger setRemindDay = [Tool actionForNowWeek:selectDate];
    NSInteger nowDay = [Tool actionForNowWeek:nowDate];
    
    typeForRandom modelRandom = [JYRemindManager modelType:setRemindDay];
    typeForRandom nowRandom   = [JYRemindManager modelType:nowDay];
    
    NSArray *weekArr = [model.weekStr componentsSeparatedByString:@","];
    
    BOOL isSameType = NO;
    
    for (id randomType in weekArr) {
        
        if ([randomType intValue] == modelRandom) {
            isSameType = YES;
        }
    }
    

    //设置提醒日期单独添加
    if (!isRemind && !isSameType) {
        RemindModel *noReaptModel = [[RemindModel alloc] init];
        noReaptModel.randomType = 0;
        noReaptModel.year = model.year;
        noReaptModel.month = model.month;
        noReaptModel.day = model.day;
        noReaptModel.hour = model.hour;
        noReaptModel.minute = model.minute;
        noReaptModel.title = model.title;
        noReaptModel.content = model.content;
        noReaptModel.musicName = model.musicName;
        noReaptModel.isOn = model.isOn;
        noReaptModel.timeorder = model.timeorder;
        [JYRemindManager addNotificationWithModel:noReaptModel];
    }
    
    int setNFmonth = 0;
    int setNFyear  = 0;
    int setNFday   = 0;
    int addDay     = 0;
    typeForRandom setNFrandom = 0;
    
    //设置每周提醒
    if (isRemind) {
        
        setNFyear  = model.year;
        setNFmonth = model.month;
        setNFday   = model.day;
        setNFrandom = modelRandom;
        
    }else{
       
        setNFyear  = year;
        setNFmonth = month;
        setNFday   = day;
        setNFrandom = nowRandom;
    }
    
    
    for (id randomType in weekArr) {
        
        int type = [randomType intValue];
        
        //相同时间
        if (type == setNFrandom) {
            addDay = 0;
            //随机时间大于当前时间
        }else if(type > setNFrandom){
            addDay = type - setNFrandom;
        }else{
            //随机时间小于当前时间
            addDay = (7 - setNFrandom) + type;
        }
        
        //如果随机时间正好是当天且过了提醒时间，需要置为下周
        if (addDay == 0 && nowTime >= selectTime) {
            addDay = 7;
        }
        
        
        
       NSInteger calendar = kCFCalendarUnitWeek;
        
        NSDateComponents *comp = [[NSDateComponents alloc]init];
        [comp setYear:setNFyear];
        [comp setMonth:setNFmonth];
        [comp setDay:setNFday+addDay];
        [comp setHour:model.hour];
        [comp setMinute:model.minute];
    
        [JYRemindManager addNotificationWithModel:model com:comp calendar:calendar];
        
    }
    

}

+ (void)addNotificationWithModel:(RemindModel *)model com:(NSDateComponents *)components calendar:(NSInteger )calendarType
{
//    NSArray *arrForMusic = @[@"幻觉.m4a",@"科技.m4a",@"蓝调.m4a",@"女声.m4a",@"月光.m4a",@"别动.m4a",@"喂哎.m4a",@""];
    NSArray *arrForMusic = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3",@""];
    
    if (model.musicName >= 9) {
        
        model.musicName = 1;
        
    }
    

    
    NSString *musicName = arrForMusic[model.musicName - 1];
    

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateFromComponents:components];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if (notification != nil) {
        
        //通知时间
        notification.fireDate = date;
        
        //通知声音
        notification.soundName = musicName;
        
        //通知时区
//        notification.timeZone = [NSTimeZone defaultTimeZone];
        
        //通知循环时间
        notification.repeatInterval = calendarType;
        
        //通知内容
        notification.alertBody = [NSString stringWithFormat:@"%@\n%@",model.title,model.content];
        //JYLog(@"%@",[NSString stringWithFormat:@"%@\n%@",model.title,model.content]);
        //给notification增加标示
        NSDictionary *dicForNotification = [NSDictionary dictionaryWithObject:model.timeorder forKey:kLocalNotification_key];
        
        notification.userInfo = dicForNotification;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        //JYLog(@"添加本地通知成功");
    }
}


@end
