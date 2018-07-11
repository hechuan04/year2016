//
//  Tool.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "Tool.h"
#import "sys/sysctl.h"
#import "FriendModel.h"
#import "JYRemindManager+CompatibleForiOS10.h"

@implementation Tool

+ (NSString *)actionForNowDate
{
  
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    
    NSDate *nowDate = [date dateByAddingTimeInterval:time];
    NSString *str = [NSString stringWithFormat:@"%@",nowDate];
    
    NSString *strYear = [str substringWithRange:NSMakeRange(0, 4)];
    NSString *strMonth = [str substringWithRange:NSMakeRange(5, 2)];
    NSString *strForNow = [NSString stringWithFormat:@"%@年%@月",strYear,strMonth];
    
    return strForNow;

}

+ (NSString *)actionForNowSingleDay:(NSDate *)date
{

    if (date == nil) {
        
        date = [NSDate date];
    }
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    
    NSDate *nowDate = [date dateByAddingTimeInterval:time];
    NSString *str = [NSString stringWithFormat:@"%@",nowDate];
    
//    NSInteger intForHour = [[str substringWithRange:NSMakeRange(11, 2)] integerValue];
//    
//    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    fmt.dateFormat = @"yyyy-MM-dd HH";
//    NSString* dateString = [fmt stringFromDate:date];
    
    NSString *strForDay = [str substringWithRange:NSMakeRange(8, 2)];
    
    return strForDay;
   
}

+ (NSString *)actionForNowYear:(NSDate *)date
{

    if (date == nil) {
        
        date = [NSDate date];
    }
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    
    NSDate *nowDate = [date dateByAddingTimeInterval:time];
    NSString *str = [NSString stringWithFormat:@"%@",nowDate];
    
    //NSString *strForNowDate = [NSString stringWithFormat:@"%@",date];
    NSString *strYear = [str substringWithRange:NSMakeRange(0, 4)];
    NSString *strForNow = [NSString stringWithFormat:@"%@",strYear];
  
    return strForNow;

}

+ (NSString *)actionForNowMonth:(NSDate *)date
{
  
    if (date == nil) {
        
        date = [NSDate date];
    }
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    
    NSDate *nowDate = [date dateByAddingTimeInterval:time];
    NSString *str = [NSString stringWithFormat:@"%@",nowDate];

    
//    NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
//    fmt.dateFormat = @"yyyy-MM-dd HH";
//    NSString *strForNowDate = [fmt stringFromDate:date];
    NSString *strMonth = [str substringWithRange:NSMakeRange(5, 2)];
    NSString *strForNow = [NSString stringWithFormat:@"%@",strMonth];
    
    
    return strForNow;
}

+ (NSInteger )actionForNowWeek:(NSDate *)inputDate
{
  

 
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    //NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];

    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    
    return theComponents.weekday;

}

+ (NSInteger )actionForNowManyDay:(NSInteger )monthNow
                             year:(NSInteger )yearNow
{

    //判断这个月的总天数
    if (monthNow == 1 || monthNow == 3 || monthNow == 5 || monthNow == 7 || monthNow == 8 || monthNow == 10 || monthNow == 12) {
        
        return 31;
        
    }else if(monthNow == 2 && yearNow % 4 == 0){
     
        return 29;
        
    }else if(monthNow == 2 && yearNow % 4 != 0){
        
     
        return 28;
        
    }else{
    
        return 30;
        
    }

    
}

+ (NSDate *)actionForReturnSelectedDateWithDay:(NSInteger)day
                                          Year:(NSInteger)year
                                         month:(NSInteger)month
{

    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:year];
    [comp setMonth:month];
    [comp setDay:day];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comp];

    return date;
}

+ (NSString *)actionforNowHour;
{
  
    NSDate *date = [NSDate date];
    //NSString *str = [NSString stringWithFormat:@"%@",date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval time = [zone secondsFromGMTForDate:date];
    
    NSDate *nowDate = [date dateByAddingTimeInterval:time];
    NSString *str = [NSString stringWithFormat:@"%@",nowDate];

    NSInteger intForHour = [[str substringWithRange:NSMakeRange(11, 2)] integerValue];
    
//    NSInteger nowHour = intForHour + 8;
//    if (nowHour >= 24) {
//        
//        nowHour = nowHour - 24;
//    }
    
    NSString *strForHour = [NSString stringWithFormat:@"%ld",intForHour];
    
    return strForHour;
}

+ (NSString *)actionforNowMinute
{

    NSDate *date = [NSDate date];
    NSString *str = [NSString stringWithFormat:@"%@",date];
    
    NSString *strForMinute = [str substringWithRange:NSMakeRange(14, 2)] ;
    
    return strForMinute;

}

+ (NSString *)actionForNowSecond
{
 
    NSDate *date = [NSDate date];
    NSString *str = [NSString stringWithFormat:@"%@",date];
    
    NSString *strForSecond = [str substringWithRange:NSMakeRange(17, 2)] ;
    
    return strForSecond;
}

+ (NSDate *)actionForReturnSelectedDateWithDay:(NSInteger)day
                                          Year:(NSInteger)year
                                         month:(NSInteger)month
                                          hour:(NSInteger)hour
                                        minute:(NSInteger)minute
{

    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setYear:year];
    [comp setMonth:month];
    [comp setDay:day];
    [comp setHour:hour];
    [comp setMinute:minute];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comp];
    
    return date;

}

+ (NSArray *)actionForReturnAlreadyAndAwaitArray
{
    LocalListManager *manager = [LocalListManager shareLocalListManager];
    
    NSDate *dateNow = [NSDate date];
    
    NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;
    
    
    NSMutableArray *arrForAlready = [NSMutableArray array];
    NSMutableArray *arrForAwait   = [NSMutableArray array];
    
    int xiaomiID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]intValue];
    NSArray *arrForAll = [manager searchAllDataWithText:@""];
    
    for (int i = 0; i < arrForAll.count; i++) {
        
        RemindModel *model = arrForAll[i];
        
        NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:model.day Year:model.year month:model.month hour:model.hour minute:model.minute];
        
        NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;
        
        //说明存储时间比现在时间晚，证明还未完成
        if (_fitstDate - _secondDate > 0) {
            
            [arrForAwait addObject:model];
            
        }else {
            
            //相反
            [arrForAlready addObject:model];
        }
        
        
        
    }
    
    NSArray *arrForAwaitAndAlready = @[arrForAwait,arrForAlready];
    
    
    return arrForAwaitAndAlready;
}

+ (NSDictionary *)actionForReturnTodayRemind:(NSArray *)arrForToday
{
    
    NSMutableArray *arrForAlready = [NSMutableArray array];
    NSMutableArray *arrForAwait   = [NSMutableArray array];

    for (int i = 0; i < arrForToday.count; i++) {
        
        RemindModel *model = arrForToday[i];
 
            int year = [[Tool actionForNowYear:nil] intValue];
            int month = [[Tool actionForNowMonth:nil] intValue];
            int day = [[Tool actionForNowSingleDay:nil] intValue];
            
            //判断model存储的数据是否为当天数据
            BOOL isAwait = [Tool actionForJudgement:model year:year month:month day:day];
            
            
            if (isAwait) {
                
                [arrForAwait addObject:model];

            }else{
            
                [arrForAlready addObject:model];
                
            }
        
        
   
    }

    NSDictionary *dic = @{@"Already":arrForAlready,@"Await":arrForAwait};
    
    return dic;

}

//判断重复的记录是否过了提醒时间
+ (BOOL)isAlreadyNowYear:(int )year
                   month:(int )month
                     day:(int )day
                    hour:(int )hour
                  minute:(int )minute
{
    
    //现在时间
    NSDate *dateNow = [NSDate date];
    NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;
    
    //选中时间
    NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:day Year:year month:month hour:hour minute:minute];
    NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;
    
        //选中时间              //现在时间
    if (_fitstDate - _secondDate > 0) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}

+ (BOOL )actionForSelectWeek:(int )year
                       month:(int )month
                         day:(int )day
                  strForWeek:(int )randomWeek
{
    NSString *strForNowWeek = @"";
    switch (randomWeek) {
        case 1:
            strForNowWeek = @"每周一";
            break;
            
        case 2:
            strForNowWeek = @"每周二";
            break;
        case 3:
            strForNowWeek = @"每周三";
            break;
        case 4:
            strForNowWeek = @"每周四";
            break;
        case 5:
            strForNowWeek = @"每周五";
            break;
        case 6:
            strForNowWeek = @"每周六";
            break;
        case 7:
            strForNowWeek = @"每周日";
            break;
            
        default:
            break;
    }

    NSDate *date = [Tool actionForReturnSelectedDateWithDay:day Year:year month:month];
    
    NSInteger weekNow  = [Tool actionForNowWeek:date];
    //周日 = 1 周一 = 2 ...周六 = 7
    NSString *strForWeek = @"";
    if (weekNow == 1) {
        
        strForWeek = @"每周日";
        
    }else if(weekNow == 2){
    
       strForWeek = @"每周一";
        
    }else if(weekNow == 3){
    
        strForWeek = @"每周二";
    
    }else if (weekNow == 4){
     
        strForWeek = @"每周三";
    }else if(weekNow == 5){
    
        strForWeek = @"每周四";
    
    }else if(weekNow == 6){
    
        strForWeek = @"每周五";
    }else{
      
        strForWeek = @"每周六";
    }
    
    if ([strForNowWeek isEqualToString:strForWeek]) {
        
        return YES;
        
    }else{
    
        return NO;
    }
    
}


+ (RemindModel *)actionForIsNowRemind:(RemindModel *)model
{
  
    /**
     *  添加本地通知到手机
     */
 
        //当天年月日
        int year = [[Tool actionForNowYear:nil] intValue];
        int month = [[Tool actionForNowMonth:nil] intValue];
        int day = [[Tool actionForNowSingleDay:nil] intValue];
        
 
            
            //如果为YES，说明用户打开了这个提醒
            if (model.isOn) {
                
                
                if (model.randomType != 0) {
                    
                    BOOL isOk = [Tool actionForJudgement:model year:year month:month day:day];
                    
                    if (isOk) {
                        
                        return model;
                        
                    }else{
                       
                        return nil;
                    }
   
                    
                }
    
                BOOL isInsert = [Tool actionForRandomIsBefore:model year:model.year month:model.month day:model.day];
                //普通情况
                if (isInsert) {
                    
                    return model;
                    
                }else{
                
                    return nil;
                }
                
            }
    
    return nil;
 
}

+ (BOOL)actionForIsHiddenRemindView:(RemindModel *)model
{
    /**
     *  添加本地通知到手机
     */
    
    //当天年月日
    int year = [[Tool actionForNowYear:nil] intValue];
    int month = [[Tool actionForNowMonth:nil] intValue];
    int day = [[Tool actionForNowSingleDay:nil] intValue];
    
    
    
    //如果为YES，说明用户打开了这个提醒
    if (model.isOn) {
        
        
        
        if (model.randomType != 0) {
            
            BOOL isOk = [Tool actionForJudgement:model year:year month:month day:day];
            
            if (isOk) {
                
                return YES;
                
            }else{
                
                return NO;
            }
            
            
        }
        
        //普通情况
        if (model.year == year && model.month == month && model.day == day) {
            
            return YES;
        }else{
            
            return NO;
        }
        
    }
    
    return NO;
}

+ (NSInteger )actionForReturnSecond:(RemindModel *)model
                         year:(int )year
                        month:(int )month
                          day:(int )day
{

    NSInteger nowHour = [[Tool actionforNowHour] integerValue];
    NSInteger nowMinute = [[Tool actionforNowMinute] integerValue];
    //选中时间
    NSDate *selectDate = [Tool actionForReturnSelectedDateWithDay:day Year:year month:month hour:nowHour minute:nowMinute];
    NSTimeInterval _secondDate = [selectDate timeIntervalSince1970]*1;
    
    
    //model时间
    NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:model.day Year:model.year month:model.month hour:model.hour minute:model.minute];
    NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;
    
    NSInteger second = 0;
    if (_secondDate > _fitstDate) {
        
        second = _secondDate - _fitstDate;
        
    }else{
        
        second = _fitstDate - _secondDate;
    }
    
    NSInteger nowday = second / (24 * 60 * 60);
    
    return nowday;

}


+ (BOOL)actionForRandomIsBefore:(RemindModel *)model
                           year:(int )year
                          month:(int )month
                            day:(int )day
{
    
    //今天的时间,now
    NSDate *dateNow = [NSDate date];
    NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;
    
 
    
    //选中时间，小时和分钟是model的时间
    NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:day Year:year month:month hour:model.hour minute:model.minute];
    NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;

    if (_fitstDate > _secondDate) {
        
        return YES;
        
    }else{
    
        return NO;
    }
    
}

//非通知
+ (BOOL)actionForRandomIsBeforeNotNotification:(RemindModel *)model
                                          year:(int )year
                                         month:(int )month
                                           day:(int )day
{
    
    //今天的时间,now
    NSDate *dateNow = [Tool actionForReturnSelectedDateWithDay:model.day    Year:model.year month:model.month];
    NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;
    
    
    
    //选中时间，小时和分钟是model的时间
    NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:day Year:year month:month];
    NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;
    
    if (_fitstDate >= _secondDate) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}

/**
 *  判断当天有提醒,非通知
 */
+ (BOOL)actionForJudgementAndNotNotification:(RemindModel *)model
                                        year:(int )year
                                       month:(int )month
                                         day:(int )day
{
    
    //记录时间与当前时间的差值天数
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *nowCom = [[NSDateComponents alloc] init];
    [nowCom setYear:year];
    [nowCom setMonth:month];
    [nowCom setDay:day];
    NSDateComponents *selectCom = [[NSDateComponents  alloc] init];
    [selectCom setYear:model.year];
    [selectCom setMonth:model.month];
    [selectCom setDay:model.day];
    NSDate *nowDate = [calendar dateFromComponents:nowCom];
    NSDate *selectDate = [calendar dateFromComponents:selectCom];
    int nowInteger = [nowDate timeIntervalSince1970];
    int select = [selectDate timeIntervalSince1970];
    int countNumber = abs((int)[selectDate timeIntervalSinceDate:nowDate] / (60 * 60 * 24));
    
    
    if (model.randomType == selectDay ) {
        
        if (nowInteger < select) {
            
            return NO;
        }
        
        //自定义日，是否在今天又提醒,与总天数取余
        if (countNumber == 0 || (countNumber >= model.countNumber && countNumber % model.countNumber == 0)) {
 
            return YES;
       
        }else{
        
            return NO;
        }
        
    }else if(model.randomType == selectWeek ){
        
        if (nowInteger < select) {
            
            return NO;
        }
        
        //自定义星期，与日基本相同
        if (countNumber == 0 || (countNumber >= model.countNumber * 7 && countNumber % (model.countNumber * 7) == 0)) {
            
           
            return YES;
            
        }else{
            
            return NO;
        }
        
        
    }else if(model.randomType == selectMonth ){
        
        
        if (nowInteger < select) {
            
            return NO;
        }
        
        //自定义月份
        int allMonth = model.month + model.countNumber ;
        
        int distanceMonth = abs(allMonth - month);
        
        //当天有的前提
        if (distanceMonth % model.countNumber == 0 && model.day == day) {
            
            BOOL isNext = [Tool actionForRandomIsBeforeNotNotification:model year:year month:month day:day];;
            
            //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
            return isNext;
            
        }else{
            
            return NO;
        }
        
        
        
    }else if(model.randomType == selectYear ){
        
        
        if (nowInteger < select) {
            
            return NO;
        }
        
        //自定义年，当天有的前提
        if (year == model.year + model.countNumber && model.month == month && model.day == day) {
            
            BOOL isNext = [Tool actionForRandomIsBeforeNotNotification:model year:year month:month day:day];;
            
            //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
            return isNext;
            
        }else{
            
            return NO;
        }
        
    }else if ((model.randomType >= 1) && (model.randomType <= 7)){
        
        //每周
        BOOL isOK = [Tool actionForSelectWeek:year month:month day:day strForWeek:model.randomType];
        //当天有的前提
        if (isOK) {
            
            BOOL isNext = [Tool actionForRandomIsBeforeNotNotification:model year:year month:month day:day];;
            if (model.year == year && model.month == month && model.day == day) {
                
                return YES;
                
            }else {
             
                //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
                return isNext;
            }
           
            
        }else{
            
            //判断月份那个，如果时间相同也是一条
//            if (model.year == year && model.month == month && model.day == day) {
//                
//                
//                return YES;
//                    
//            }else{
//             
//                return NO;
//            }
            
            return NO;//周重复，不包含当天，不显示红点
   
        }
        
        
    }else if(model.randomType == selectEveryDay ){
      
        //每天
        if (nowInteger < select) {
            
            return NO;
        }
        
        return YES;
        
    }else if(model.randomType == selectEveryMonth ){
        
        //每个月
        if (day == model.day) {
            
            BOOL isNext = [Tool actionForRandomIsBeforeNotNotification:model year:year month:month day:day];;
            if (model.year == year && model.month == month && model.day == day) {
                
                return YES;
                
            }else {
                
                //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
                return isNext;
            }
          
            
        }else{
            
            if (model.year == year && model.month == month && model.day == day) {
                
                return YES;
                
            }else {
                
                //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
                return NO;
            }
        }
        
        
    }else if(model.randomType == selectEveryYear ){
        
        
        //每年
        if (day == model.day && month == model.month) {
            
            BOOL isNext = [Tool actionForRandomIsBeforeNotNotification:model year:year month:month day:day];;
            if (model.year == year && model.month == month && model.day == day) {
                
                return YES;
                
            }else {
                
                //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
                return isNext;
            }
            
        }else{
            
            if (model.year == year && model.month == month && model.day == day) {
                
                return YES;
                
            }else {
                
                //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
                return NO;
            }

        }
        
        
        //没重复的情况下判断
    }else if (model.randomType == 0){
        
        //now
        if (model.year == year && model.month == month && model.day == day) {
            
            return YES;
            
        }else {
            
            //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
            return NO;
        }
        
    }else if(model.randomType == selectSomeDays ){
        
        NSString *weekStr = [Tool actionForWeekWithYear:year month:month day:day];
        
        NSArray * weekArr = [model.weekStr componentsSeparatedByString:@","];
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weekArr];
        BOOL isNext = [Tool actionForRandomIsBeforeNotNotification:model year:year month:month day:day];
        if (isNext) {
            
            if (tmpArr.count != 0) {
                
                for (int i = 0; i < tmpArr.count; i ++) {
                    
                    if ([tmpArr[i] integerValue] == 1) {
                        
                        if ([weekStr isEqualToString:@"周一"]) {
                            return YES;
                        }
                    }else if ([tmpArr[i] integerValue] == 2){
                        
                        if ([weekStr isEqualToString:@"周二"]) {
                            return YES;
                        }
                        
                    }else if ([tmpArr[i] integerValue] == 3){
                        
                        if ([weekStr isEqualToString:@"周三"]) {
                            return YES;
                        }
                        
                    }else if ([tmpArr[i] integerValue] == 4) {
                        
                        if ([weekStr isEqualToString:@"周四"]) {
                            return YES;
                        }
                    }else if ([tmpArr[i] integerValue] == 5) {
                        
                        if ([weekStr isEqualToString:@"周五"]) {
                            return YES;
                        }
                    }else if ([tmpArr[i] integerValue] == 6) {
                        
                        if ([weekStr isEqualToString:@"周六"]) {
                            return YES;
                        }
                    }else if ([tmpArr[i] integerValue] == 7) {
                        
                        if ([weekStr isEqualToString:@"周日"]) {
                            return YES;
                        }
                    }
                }
                
                
            }
            //多周重复，不包含当日，不显示红点(注掉下面逻辑)
//            if (model.year == year && model.month == month && model.day == day) {
//                
//                return YES;
//            }
            return NO;
            
        }else{
         
            return NO;
        }
        
       
        
        //没重复的情况下判断
    }else{
        
        return NO;
        
    }
    
}


/**
 *  判断当天有提醒，且存储小时和分钟是否超过当前时间
 */
+ (BOOL)actionForJudgement:(RemindModel *)model
                      year:(int )year
                     month:(int )month
                       day:(int )day
{
 
    //记录时间与当前时间的差值天数
    NSInteger distanceDay = [Tool actionForReturnSecond:model year:year month:month day:day];
 
    
    if (model.randomType == selectDay ) {

        //自定义日，是否在今天又提醒,与总天数取余
        if (distanceDay % model.countNumber == 0) {
            
            BOOL isNext = [Tool actionForRandomIsBefore:model year:year month:month day:day];
            
            //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
            return isNext;
            
            
        }else{
            
    
            return NO;
        }
        
    }else if(model.randomType == selectWeek ){
    
        //自定义星期，与日基本相同
        if (distanceDay % (model.countNumber * 7) == 0) {
            
            BOOL isNext = [Tool actionForRandomIsBefore:model year:year month:month day:day];
            
            //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
            return isNext;
            
        }else{
        
            return NO;
        }
        

    }else if(model.randomType == selectMonth ){
    
        //自定义月份
        int allMonth = model.month + model.countNumber ;
        
        int distanceMonth = abs(allMonth - month);
        
           //当天有的前提
            if (distanceMonth % model.countNumber == 0 && model.day == day) {
                
                BOOL isNext = [Tool actionForRandomIsBefore:model year:year month:month day:day];
                
                //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
                return isNext;
                
            }else{
              
                return NO;
            }
    
        
        
    }else if(model.randomType == selectYear ){
    
        //自定义年，当天有的前提
        if (year == model.year + model.countNumber && model.month == month && model.day == day) {
          
            BOOL isNext = [Tool actionForRandomIsBefore:model year:year month:month day:day];
            
            //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
            return isNext;
            
        }else{
         
            return NO;
        }
        
    }else if ((model.randomType >= 1) && (model.randomType <= 7)){
 
        //每周
        BOOL isOK = [Tool actionForSelectWeek:year month:month day:day strForWeek:model.randomType];
        //当天有的前提
        if (isOK) {
            
            BOOL isNext = [Tool actionForRandomIsBefore:model year:year month:month day:day];
            
            //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
            return isNext;
            
        }else{
            
            //判断月份那个，如果时间相同也是一条
            if (model.year == year && model.month == month && model.day == day) {
                
               
                if (model.hour > [[Tool actionforNowHour] intValue]) {
                    
                    return YES;
                    
                }else if(model.hour == [[Tool actionforNowHour] intValue] && model.minute > [[Tool actionforNowMinute] intValue]){
                 
                    return YES;
                    
                }else{
                 
                    return NO;

                }
                
                
            }else{
             
                return NO;
            }
          
            
        }
        
        
    }else if(model.randomType == selectEveryDay ){
    
        //每天
        int hour = [[Tool actionforNowHour] intValue];
        int minute = [[Tool actionforNowMinute] intValue];
        
        NSString *nowDate = [NSString stringWithFormat:@"%02d%02d",hour,minute];
        NSString *selectDate = [NSString stringWithFormat:@"%02d%02d",model.hour,model.minute];

        
        if ([nowDate intValue] < [selectDate intValue]) {
            
            return YES;
            
        }else{
         
            return NO;
        }
        
        
        
    }else if(model.randomType == selectEveryMonth ){
    
           //每个月
            if (day == model.day) {
                
                BOOL isNext = [Tool actionForRandomIsBefore:model year:year month:month day:day];
                
                //之前判断确定试今天，这个判断是确定Model的小时和分钟超过当前分钟
                return isNext;
                
            }else{
                
                return NO;
            }
        
    
    }else if(model.randomType == selectEveryYear ){
    
       
           //每年
            if (day == model.day && month == model.month) {
                
                BOOL isNext = [Tool actionForRandomIsBefore:model year:year month:month day:day];
                
                //之前天，这个判断是确定Model的小时和分钟超过当前分钟
                return isNext;
                
            }else{
                
                return NO;
            }
            
        
          //没重复的情况下判断
    }else if (model.randomType == 0){
    
        //now
        NSDate *dateNow = [NSDate date];
        NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;

        //model
        NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:model.day Year:model.year month:model.month hour:model.hour minute:model.minute];
        NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;
        
        if (_fitstDate > _secondDate){
            
            return YES;
            
        }else{
        
            return NO;
        }

    }else if(model.randomType == selectSomeDays ){
        
        NSString *weekStr = [Tool actionForWeekWithYear:year month:month day:day];
        
        NSArray * weekArr = [model.weekStr componentsSeparatedByString:@","];
        NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:weekArr];
        
        if (tmpArr.count != 0) {
            
            for (int i = 0; i < tmpArr.count; i ++) {
                
                if ([tmpArr[i] integerValue] == 1) {
                    
                    if ([weekStr isEqualToString:@"周一"]) {
                        return YES;
                    }
                }else if ([tmpArr[i] integerValue] == 2){
                
                    if ([weekStr isEqualToString:@"周二"]) {
                        return YES;
                    }
                
                }else if ([tmpArr[i] integerValue] == 3){
                    
                    if ([weekStr isEqualToString:@"周三"]) {
                        return YES;
                    }
                    
                }else if ([tmpArr[i] integerValue] == 4) {
                    
                    if ([weekStr isEqualToString:@"周四"]) {
                        return YES;
                    }
                }else if ([tmpArr[i] integerValue] == 5) {
                    
                    if ([weekStr isEqualToString:@"周五"]) {
                        return YES;
                    }
                }else if ([tmpArr[i] integerValue] == 6) {
                    
                    if ([weekStr isEqualToString:@"周六"]) {
                        return YES;
                    }
                }else if ([tmpArr[i] integerValue] == 7) {
                    
                    if ([weekStr isEqualToString:@"周日"]) {
                        return YES;
                    }
                }
            }
            
            
        }
        
        if (model.year == year && model.month == month && model.day == day) {
            
            return YES;
        }
        return NO;

        //没重复的情况下判断
    }else{
    
        return NO;

    }
   
}


+ (RemindModel *)actionForRemindModel:(RemindModel *)model
{
   
    int year = [[Tool actionForNowYear:nil] intValue];
    int month = [[Tool actionForNowMonth:nil] intValue];
    int day = [[Tool actionForNowSingleDay:nil] intValue];
    
    

        
        model.year = year;
        model.month = month;
        model.day = day;
        
        return model;


}


+ (NSArray *)actionForReturnAllKey:(NSArray *)arrForAllKey
{
   NSArray *arrForAllAbc = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    NSMutableArray *arrForNew = [NSMutableArray array];
    for (int i = 0; i < arrForAllAbc.count; i++) {
        
        NSString *key = arrForAllAbc[i];
        
        for (int j = 0; j <arrForAllKey.count; j++) {
            
            if ([arrForAllKey[j] isEqualToString:key]) {
                
                [arrForNew addObject:key];
            }
            
        }
        
    }
    
    return arrForNew;
}

+ (NSDictionary *)actionForReturnNameDic:(NSArray *)arrForAllName
{
  NSArray *arrForAllAbc = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    //存数组的
    NSMutableArray *arrForAllArr = [NSMutableArray array];
    //返回的字典
    NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < arrForAllAbc.count; i++) {
        
        NSMutableArray *arrForName = [NSMutableArray array];
        
        //把所有arr添加到总的里边
        [arrForAllArr addObject:arrForName];
        
    }
    
    
    
    
    for (int i = 0; i < arrForAllName.count; i ++) {
        
        FriendModel *model = arrForAllName[i];
        NSString *hanziText = model.friend_name;
        if([model.remarkName length]>0){
            hanziText = model.remarkName;
        }
       
        if (![hanziText isKindOfClass:[NSNull class]]) {
            
            if ([hanziText length]) {
                NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
                
                
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                    
                    
                }
                
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                    
                    
                    NSString *strForFirst = [ms substringWithRange:NSMakeRange(0, 1)];
                    
                    for (int j = 0; j < arrForAllAbc.count; j++) {
                        
                        if ([strForFirst compare:arrForAllAbc[j] options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            
                            //添加名字到对应的arr；
                            NSMutableArray *arrForAddArr = arrForAllArr[j];
                            [arrForAddArr addObject:model];
                            
                            
                            break;
                            
                        }
                        
                        //没有找到对应的字母，放在#里边
                        if (j == arrForAllAbc.count - 1) {
                            
                            NSMutableArray *arrForAddArr = arrForAllArr[j];
                            [arrForAddArr addObject:model];
                            
                        }
                        
                    }

                }
                
                
        }
        
}
        
    }
    
    
    for (int i = 0; i < arrForAllArr.count; i++) {
        
        NSMutableArray *arr = arrForAllArr[i];
        
        if (arr.count > 0) {
            
            NSString *strForKey = arrForAllAbc[i];
            
            [returnDic setObject:arr forKey:strForKey];
            
        }
        
    }
    
    NSMutableArray *arr = arrForAllArr[0];
    
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FriendModel *model = obj;
        NSString *hanziText = model.friend_name;
        if([hanziText isEqualToString:@"俺自己"]){
            [arr replaceObjectAtIndex:idx withObject:arr[0]];
            [arr replaceObjectAtIndex:0 withObject:model];
            *stop = YES;
        }
    }];
    
    return returnDic;
    
}



+ (NSString *)actionForTenOrSingleWithNumber:(int )number
{
  
    NSString *strForReturn = @"";
    
    if (number >= 10) {
        
        strForReturn = [NSString stringWithFormat:@"%d",number];
        
    }else{
    
        strForReturn = [NSString stringWithFormat:@"0%d",number];
    }

    return strForReturn;
}

+ (NSString *)actionForWeekWithYear:(int )year
                         month:(int )month
                           day:(int )day
{

    //判断当前月的1号在周几
    //周日 = 1 周一 = 2 ...周六 = 7
    //将周几转换为index
    NSDate *date = [JYToolForCalendar actionForReturnSelectedDateWithDay:day Year:year month:month];
    NSInteger weekNow  = [JYToolForCalendar actionForNowWeek:date];

    switch (weekNow) {
        case 1:
            
            return @"周日";
            break;
            
        case 2:
            
            return @"周一";
            break;
            
        case 3:
            
            return @"周二";
            break;
            
        case 4:
            
            return @"周三";
            
            break;
            
        case 5:
            
            return @"周四";
            
            break;
            
        case 6:
            
            return @"周五";
            
            break;
            
        case 7:
            
            return @"周六";
            
            break;
            
        default:
            
            return @"错误";
            
            break;
    }
    
    
}
+ (NSString *)actionForEnglishWeekWithYear:(int )year
                              month:(int )month
                                day:(int )day
{
    
    //判断当前月的1号在周几
    //周日 = 1 周一 = 2 ...周六 = 7
    //将周几转换为index
    NSDate *date = [JYToolForCalendar actionForReturnSelectedDateWithDay:day Year:year month:month];
    NSInteger weekNow  = [JYToolForCalendar actionForNowWeek:date];
    
    switch (weekNow) {
        case 1:
            
            return @"Sunday";
            break;
            
        case 2:
            
            return @"Monday";
            break;
            
        case 3:
            
            return @"Tuesday";
            break;
            
        case 4:
            
            return @"Wednesday";
            
            break;
            
        case 5:
            
            return @"Thursday";
            
            break;
            
        case 6:
            
            return @"Friday";
            
            break;
            
        case 7:
            
            return @"Saturday";
            
            break;
            
        default:
            
            return @"Error";
            
            break;
    }
    
    
}
+ (NSString *)actionForWeekWithYearAll:(int )year
                              month:(int )month
                                day:(int )day
{
    
    //判断当前月的1号在周几
    //周日 = 1 周一 = 2 ...周六 = 7
    //将周几转换为index
    NSDate *date = [JYToolForCalendar actionForReturnSelectedDateWithDay:day Year:year month:month];
    NSInteger weekNow  = [JYToolForCalendar actionForNowWeek:date];
    
    switch (weekNow) {
        case 1:
            
            return @"星期日";
            break;
            
        case 2:
            
            return @"星期一";
            break;
            
        case 3:
            
            return @"星期二";
            break;
            
        case 4:
            
            return @"星期三";
            
            break;
            
        case 5:
            
            return @"星期四";
            
            break;
            
        case 6:
            
            return @"星期五";
            
            break;
            
        case 7:
            
            return @"星期六";
            
            break;
            
        default:
            
            return @"错误";
            
            break;
    }
    
    
}


+ (NSString *)actionForLunarWithYear:(int )year
                               month:(int )month
                                 day:(int )day
{
  
    JYSelectManager *manager = [JYSelectManager shareSelectManager];
    
    Solar *nowSolar = [[Solar alloc] init];
    nowSolar.solarYear = year;
    nowSolar.solarMonth = month;
    nowSolar.solarDay = day;
    
    
    Lunar *lunar = [LunarSolarConverter solarToLunar:nowSolar];
    
    NSString *dayStr = [NSString stringWithFormat:@"%@",manager.arrForAllLunarDay[lunar.lunarDay - 1]];
    NSString *monthStr = [NSString stringWithFormat:@"%@",manager.arrForAllLunarMonth[lunar.lunarMonth - 1]];
    
    NSString *strForLunar = [NSString stringWithFormat:@"%@%@",monthStr,dayStr];
        
    return strForLunar;

}

+ (NSString *)filePathWithSqlName:(NSString *)name{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *str = name;
    return [documentsDir stringByAppendingPathComponent:str];
    
}


+ (NSString *)actionForReturnRepeatStr:(RemindModel *)model
{

    
    NSString *strForRepeat = @"";
    if (model.randomType > 0 && model.randomType <= 7) {
        
        NSString *week = [self actionForReturnWeek:model.randomType - 1];
        strForRepeat = [NSString stringWithFormat:@"每周%@",week];

    }else if(model.randomType == 8){
    
      strForRepeat = @"每天";
        
    }else if(model.randomType == 9){
    
        strForRepeat = [NSString stringWithFormat:@"每月 %d日",model.day];
        
    }else if(model.randomType == 10){
    
        strForRepeat = [NSString stringWithFormat:@"每年 %d月 %d日",model.month,model.day];
        
    }else if(model.randomType >= 11 && model.randomType <= 14){
    
       
        strForRepeat = [NSString stringWithFormat:@"每 %d %@",model.countNumber,[Tool strForType:model.randomType]];
        
    }else if (model.randomType == 15){
            
            if (![model.weekStr isEqualToString:@""] && ![model.weekStr isEqualToString:@"(null)"] && ![model.weekStr isKindOfClass:[NSNull class]]&& ![model.weekStr isEqualToString:@"<null>"] && model.weekStr != nil) {
                
                NSArray * array = [model.weekStr componentsSeparatedByString:@","];
                
                // 拼接选择重复时间的上一个页面 显示的数据，
                NSMutableArray * tmpArray = [NSMutableArray array];
                for (int i = 0; i < array.count; i ++) {
                    NSString *week = [self actionForReturnWeek:[array[i] integerValue] - 1];
                    NSString *strForTime = [NSString stringWithFormat:@"每周%@",week];
                    [tmpArray addObject:strForTime];
                }
                NSString * repeatStr = [tmpArray componentsJoinedByString:@" "];
                if ([repeatStr isEqualToString:@"每周一 每周二 每周三 每周四 每周五"]) {
                    strForRepeat = @"工作日";
                    
                }else if ([repeatStr isEqualToString:@"每周六 每周日"]){
                    
                    strForRepeat = @"每周末";
                    
                }else if ([repeatStr isEqualToString:@"每周一 每周二 每周三 每周四 每周五 每周六 每周日"]){
                    
                    strForRepeat = @"每天";
                    
                }else{
                    strForRepeat = repeatStr;
                    
                }
        }
    }
   
    return strForRepeat;
}

+ (NSString *)actionForReturnWeek:(NSInteger )index
{
   
    NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    NSString *week = nil;
    for (int i = 0; i < 7; i++) {
        
        if (index == i ) {
            
            week = arr[i];
            
        }
    }
    
    return week;
}

+ (NSString *)strForType:(int )type
{
    
    if (type == selectWeek) {
        
        return @"周";
        
    }else if(type == selectDay){
        
        
        return @"日";
        
    }else if(type == selectMonth){
        
        
        return @"月";
        
    }else if(type == selectYear){
        
        return @"年";
        
    }else{
      
        return @"未知";
    }
    
}

+ (void)actionForHiddenMuchTable:(UITableView *)tableView
{
  
    UIView *viewF = [UIView new];
    viewF.backgroundColor = [UIColor whiteColor];
    [tableView setTableFooterView:viewF];

}

+ (NSString *)actionForReturnMusicWithModel:(RemindModel *)model
{
  
//    NSArray *Arr = @[@"幻觉",@"科技",@"蓝调",@"女声",@"月光",@"别动",@"喂哎",@"无声"];
    NSArray *Arr = @[@"科技",@"月光",@"电动",@"古筝",@"铃铛",@"小号",@"洋琴",@"无声"];
    if (model.musicName == 0) {
        
        return @"关闭";
        
    }else{
        NSString *musicName = Arr[0];
        if(model.musicName<=8){
            musicName = Arr[model.musicName - 1];
        }
        return musicName;
    }
}

+ (NSString *)actionForListTimeZhuStr:(NSString *)createTime
                                 year:(int )year
                                month:(int )month
                                  day:(int )day
                             isAccept:(BOOL)isAccept

{
 
    NSString *returnStr = @"";
    
    NSString *nowYear = [NSString stringWithFormat:@"%d",year];
//    NSString *nowMonth = [NSString stringWithFormat:@"%d",month];
//    NSString *nowDay = [NSString stringWithFormat:@"%d",day];
    
    NSString *yearStr = [createTime substringWithRange:NSMakeRange(0, 4)];
    NSString *monthStr = [createTime substringWithRange:NSMakeRange(4, 2)];
    NSString *dayStr = [createTime substringWithRange:NSMakeRange(6, 2)];
    NSString *hourStr = [createTime substringWithRange:NSMakeRange(8, 2)];
    NSString *minuteStr = [createTime substringWithRange:NSMakeRange(10, 2)];

    if (isAccept) {
        
        if ([nowYear isEqualToString:yearStr]) {
            
            returnStr = [NSString stringWithFormat:@"接收于%@/%@ %@:%@",monthStr,dayStr,hourStr,minuteStr];
            
        }else{
            
            returnStr = [NSString stringWithFormat:@"接收于%@/%@/%@ %@:%@",yearStr,monthStr,dayStr,hourStr,minuteStr];
        }
        
    }else{
     
        if ([nowYear isEqualToString:yearStr]) {
            
            returnStr = [NSString stringWithFormat:@"发送于%@/%@ %@:%@",monthStr,dayStr,hourStr,minuteStr];
            
        }else{
            
            returnStr = [NSString stringWithFormat:@"发送于%@/%@/%@ %@:%@",yearStr,monthStr,dayStr,hourStr,minuteStr];
        }
    }
    
 
    
    
   
    return returnStr;

    
}

+ (NSString *)actionForListTimeStr:(NSString *)timeOrder
                              type:(int)type
{
 
    NSString *nowYear = [Tool actionForNowYear:nil];
    NSString *nowMonth = [Tool actionForNowMonth:nil];
    NSString *nowDay = [Tool actionForNowSingleDay:nil];
    
    NSString *strForNow = [NSString stringWithFormat:@"%@%@%@",nowYear,nowMonth,nowDay];
    
    NSString *passStr = [timeOrder substringWithRange:NSMakeRange(0, 8)];
    NSString *yearStr = [timeOrder substringWithRange:NSMakeRange(0, 4)];
    NSString *monthStr = [timeOrder substringWithRange:NSMakeRange(4, 2)];
    NSString *dayStr = [timeOrder substringWithRange:NSMakeRange(6, 2)];
    NSString *hourStr = [timeOrder substringWithRange:NSMakeRange(8, 2)];
    NSString *minuteStr = [timeOrder substringWithRange:NSMakeRange(10, 2)];
    NSString *returnStr = @"";
    
    NSString *remindType = @"";
    if (type == acceptType) {
        
        remindType = @"收到于";
        
    }else if(type == sendType){
        
        remindType = @"发送于";
        
    }else if(type == selfType){
       
        remindType = @"设置于";

    }else{
     
        remindType = @"分享于";
    }
    
  

    //今天的情况
    if ([strForNow isEqualToString:passStr]) {
        
        if ([hourStr intValue] >= 12) {
            
            returnStr = [NSString stringWithFormat:@"%@下午 %@:%@",remindType,hourStr,minuteStr];
            
            
        }else{
            
            returnStr = [NSString stringWithFormat:@"%@上午 %@:%@",remindType,hourStr,minuteStr];
            
        }
        
    }else{
        
        NSInteger nowDay = [strForNow integerValue];
        NSInteger pasDay = [passStr integerValue];
        //非今天的情况①不在同一年②在同一年
        if ([yearStr isEqualToString:nowYear]) {
            
            if (nowDay - pasDay == 1) {
                
                returnStr = [NSString stringWithFormat:@"%@昨天 %@:%@",remindType,hourStr,minuteStr];
                
                
                
            }else if(nowDay - pasDay == -1){
                
                returnStr = [NSString stringWithFormat:@"%@明天 %@:%@",remindType,hourStr,minuteStr];
                
            }else{
                
                
                returnStr = [NSString stringWithFormat:@"%@%@/%@ %@:%@",remindType,monthStr,dayStr,hourStr,minuteStr];
            }
            
        }else{
            
            NSString *yearS = [yearStr substringWithRange:NSMakeRange(2, 2)];
            
            returnStr = [NSString stringWithFormat:@"%@%@/%@/%@ %@:%@",remindType,yearS,monthStr,dayStr,hourStr,minuteStr];
            
        }
        
    }
    
    
       return returnStr;
    
}

+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }

    return imageData;
}


+ (UIButton *)actionForReturnLeftBtnWithTarget:(id)delegate
{
 
    UIButton *btnForLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnForLeft setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    btnForLeft.frame = CGRectMake(0, 0, 23.5, 20.5);
    [btnForLeft addTarget:delegate action:@selector(actionForLeft:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnForLeft;
    
}


+ (int )actionForReturnRightIntNumber:(NSString *)str
{

    if ([str isKindOfClass:[NSNull class]]) {
        
        return 0;
        
    }else{
     
        return [str intValue];
    }
    
}

+ (void)actionForGuangyunimageView:(UIImageView *)imageView
                         superView:(UIImageView *)superView
{
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(64);
        make.width.mas_equalTo(64);
        
        if (IS_IPHONE_4_SCREEN) {
            
            
        }else if (IS_IPHONE_5_SCREEN){
            
            make.left.mas_equalTo(superView.mas_left).offset(-7.f);
            make.top.mas_equalTo(superView.mas_top).offset(10.f);
            
        }else if (IS_IPHONE_6_SCREEN){
            
            
        }else if (IS_IPHONE_6P_SCREEN){
            
            make.left.mas_equalTo(superView.mas_left).offset(0.f);
            make.top.mas_equalTo(superView.mas_top).offset(10.f);
            
        }
        
        
        
    }];
    
}


+ (void)actionForAddNotification
{
    //ios10以上系统添加通知方式改变
    if(kSystemVersion>=10.0){
        [JYRemindManager resetAllNotifications];
        return;
    }
    
    //取消掉所有的通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
 
    
    int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
    LocalListManager *localMan = [LocalListManager shareLocalListManager];
    IncidentListManager *manager = [IncidentListManager shareIncidentManager];
    JYClockList *clockManager = [JYClockList shareClockList];
    
    NSArray *arrForLocal = [localMan selectAllLocalDataWithUserID:userID];
    NSArray *arrForAccept = [manager searchWithStr:@""];
    NSArray *arrForSend  =  [localMan searchLocalDataWithText:@""];
    
    
    NSMutableArray *arrForSever = [NSMutableArray arrayWithCapacity:arrForAccept.count + arrForSend.count];
    [arrForSever addObjectsFromArray:arrForAccept];
    [arrForSever addObjectsFromArray:arrForSend];
    
    NSArray *clockArr    = [clockManager selectAllModel];
    NSArray *shareArr    = [[JYShareList shareList] searchWithStr:@""];
   
    int hour = [[Tool actionforNowHour] intValue];
    int minute = [[Tool actionforNowMinute] intValue];
    NSInteger now = [[NSString stringWithFormat:@"%02d%02d",hour,minute]integerValue];
    

    //本地
    for (int i = 0; i < arrForLocal.count; i++) {
        
        RemindModel *model = arrForLocal[i];
        
        if (model.isOn == 0) {
            
            continue;
        }
        
        //没有发送出去的情况，不添加提醒
        if ((![model.fidStr isEqualToString:@""]&&![model.fidStr isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]] ) || ![model.gidStr isEqualToString:@""]) {
            
            continue;
        }
        
            
        if (model.randomType == 15) {
                
            ClockModel *cModel = [[ClockModel alloc] init];
            NSInteger select = [[NSString stringWithFormat:@"%02d%02d",model.hour,model.minute]integerValue];
            if (select <= now) {
                
                continue;
            }
            
                cModel.hour = model.hour;
                cModel.minute = model.minute;
                cModel.musicID = model.musicName;
                cModel.textStr = [NSString stringWithFormat:@"%@\n%@",model.title,model.content];;
                
                NSArray *arrForWeek = [model.weekStr componentsSeparatedByString:@","];
                NSMutableString *weekStr = [NSMutableString string];
                for (int i = 0; i < arrForWeek.count; i++) {
                    
                    int a = [arrForWeek[i] intValue] - 1;
                    
                    NSString *str = [NSString stringWithFormat:@"%d,",a];
                    [weekStr appendString:str];
                }
                cModel.week = [weekStr substringWithRange:NSMakeRange(0, weekStr.length - 1)];
                
                cModel.timeOrder = model.timeorder;
//                NSArray *arrForMusic = @[@"幻觉.m4a",@"科技.m4a",@"蓝调.m4a",@"女声.m4a",@"月光.m4a",@"别动.m4a",@"喂哎.m4a"];
                NSArray *arrForMusic = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3"];
                [JYRemindManager addNotificationWithClockModel:cModel withMusicArr:arrForMusic];
                
            }else{
                
                [JYRemindManager addNotificationWithModel:model];
                
            }
        
    }
    
    //涉及到网络的,判断是否好友拼串里含有自己
    for (int i = 0; i < arrForSever.count; i++) {
        
        RemindModel *model = arrForSever[i];
        
        if (model.isOn == 0 || model.musicName == 0) {
            
            continue;
        }
        
        NSArray *arrForFid = [model.fidStr componentsSeparatedByString:@","];
        BOOL isRemindSelf = NO;
        
        int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        
        //不等于0说明是别人给我的提醒
        if (model.isOther != 0 && model.isOther != userID) {
            
            isRemindSelf = YES;
            
        }
        
        /*
        //分享给别人以后，本地变成远程数据，需要加提醒的判断
        if (model.isOther == 0 && arrForFid.count == 1 && ![arrForFid[0] isEqualToString:@""]) {
            
            isRemindSelf = YES;
        }
        */
        
        //当没有设置提醒，走这个方法判断是否加提醒
        if (!isRemindSelf) {
            
            for (int j = 0; j < arrForFid.count; j++) {
                
                int Fid = [arrForFid[j] intValue];
                
                if (userID == Fid) {
                    
                    isRemindSelf = YES;
                }
            }
        }
        
        //在这里在判断提醒时间问题，加提醒
        if (isRemindSelf) {
            
            
            
            if (model.randomType == 15) {
                    
               
                [JYRemindManager addNotificationForRandomWeek:model];
                
                }else{
     
                    [JYRemindManager addNotificationWithModel:model];

                }
   
        }
 
    }
    
    //闹钟
    for (int i = 0; i < clockArr.count; i++) {
        
        ClockModel *model = clockArr[i];
        
        if (model.isOn == 1) {
            
//            NSArray *arrForMusic = @[@"幻觉-长.mp3",@"科技-长.mp3",@"蓝调-长.mp3",@"女声-长.mp3",@"月光-长.mp3",@"别动-长.mp3",@"喂哎-长.mp3"];
           NSArray *arrForMusic = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3"];
            [JYRemindManager addNotificationWithClockModel:model withMusicArr:arrForMusic];
        }
    }

    
    //分享的
    for (int i = 0; i < shareArr.count; i++) {
        
        RemindModel *model = shareArr[i];
        
        if (model.isOn == 0 || model.musicName == 0) {
            
            continue;
        }
        
        if (model.isOther != 0) {
            
            if (model.randomType == 15 ) {
                
                [JYRemindManager addNotificationForRandomWeek:model];
                
            }else{
                
                [JYRemindManager addNotificationWithModel:model];
            }
        }
    }
    
}

+ (NSString *)nowTime{
 
    int nowYear = [[Tool actionForNowYear:nil] intValue];
    int nowMonth1 = [[Tool actionForNowMonth:nil] intValue];
    int nowDay1 = [[Tool actionForNowSingleDay:nil] intValue];
    int nowHour1 = [[Tool actionforNowHour] intValue];
    int nowMinute1 = [[Tool actionforNowMinute] intValue];
    
    NSString *nowMonth = [Tool actionForTenOrSingleWithNumber:nowMonth1];
    NSString *nowDay = [Tool actionForTenOrSingleWithNumber:nowDay1];
    NSString *nowHour = [Tool actionForTenOrSingleWithNumber:nowHour1];
    NSString *nowMinute = [Tool actionForTenOrSingleWithNumber:nowMinute1];
    NSString *timeOR = [NSString stringWithFormat:@"%d%@%@%@%@",nowYear,nowMonth,nowDay,nowHour,nowMinute];
    
    return timeOR;
}


+ (NSArray *)actionForAscending:(NSArray *)arr
{
    NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:arr];
    for (int i = 0; i < arr.count; i++) {
        
        for (int j = 0; j < arr.count - i - 1; j++) {
            
            int obj1 = [mutableArr[j] intValue];
            int obj2 = [mutableArr[j+1] intValue];
            
            if (obj1 > obj2) {
                
                [mutableArr exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        
        }
        
    }
    
    return mutableArr;
}

+ (NSString *)actionForFriendStr:(NSString *)fidStr
{
    FriendListManager *friendManager = [FriendListManager shareFriend];
    NSArray *fidArr = [fidStr componentsSeparatedByString:@","];
    NSMutableString *nameStr = [NSMutableString string];
    for (int j = 0; j < fidArr.count; j++) {
        
        FriendModel *fModel = [friendManager selectDataWithFid:[fidArr[j] intValue]];
        
        if (fModel.friend_name) {
            
            [nameStr appendString:fModel.friend_name];
        }
        
    }

    return nameStr;
}

+ (NSString *)actionForGroupStr:(NSString *)gidStr
{
 
    GroupListManager *groupManager = [GroupListManager shareGroup];
    NSArray *gidArr = [gidStr componentsSeparatedByString:@","];
    NSMutableString *nameStr = [NSMutableString string];
    for (int j = 0; j < gidArr.count; j ++) {
        
        GroupModel *gModel = [groupManager selectDataWithGid:[gidArr[j] intValue]];
        if (gModel&&gModel.group_name) {
            
            [nameStr appendString:gModel.group_name];
        }
    }
    
    return nameStr;
}

+ (void)actionForCollection:(id )__sheetWindow
                remindModel:(RemindModel *)_model
{
 
    if (_model.uid == 0) {
        
        [RequestManager actionForCollectionForLocal:_model completedBlock:^(NSString *mid) {
            
            [RequestManager saveRemindWithId:[mid integerValue] shareId:0 completedBlock:^(id data, NSError *error) {

                [Tool showAlter:self title:@"收藏成功"];

                    IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
                    _model.isSave = 1;
                    _model.uid = [mid intValue];
                    [incManager upDataWithModel:_model];
                
                   // [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];

                NSLog(@"收藏成功");
            }];
            
        }];
   
    }else {
        
        if (_model.isShare == 1) {
            
            [RequestManager saveRemindWithId:0 shareId:_model.sid completedBlock:^(id data, NSError *error) {
                NSLog(@"收藏成功");
 
                [Tool showAlter:self title:@"收藏成功"];

                    JYShareList *shareManager = [JYShareList shareList];
                    _model.isSave = 1;
                    [shareManager upDataWithModel:_model];
                    //[RequestManager actionForReloadData];
                
                   // [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
            }];
            
        }else{
            
          
            [RequestManager saveRemindWithId:_model.uid shareId:0 completedBlock:^(id data, NSError *error) {

                [Tool showAlter:self title:@"收藏成功"];

                    IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
                    _model.isSave = 1;
                    [incManager upDataWithModel:_model];
                    //[RequestManager actionForReloadData];

                //  [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
  
            }];
        }
 
    }
    
}

//转义方法
+ (NSString *)actionForTransferredMeaning:(NSString *)content
{
 
//    keyWord = keyWord.replace("/", "//");
//    keyWord = keyWord.replace("'", "''");
//    keyWord = keyWord.replace("[", "/[");
//    keyWord = keyWord.replace("]", "/]");
//    keyWord = keyWord.replace("%", "/%");
//    keyWord = keyWord.replace("&","/&");
//    keyWord = keyWord.replace("_", "/_");
//    keyWord = keyWord.replace("(", "/(");
//    keyWord = keyWord.replace(")", "/)");
    
    if ([content isKindOfClass:[NSNull class]]) {
        return nil;
    }
    
    NSString *str1 = [content stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
    NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
    NSString *str5 = [str4 stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
    NSString *str6 = [str5 stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
    NSString *str7 = [str6 stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
    NSString *str8 = [str7 stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
    NSString *str9 = [str8 stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    
    return str9;
}


+ (void)loadPassOtherRemind:(NSArray *)arrForMe
{
    
    //清空表
    IncidentListManager *manager = [IncidentListManager shareIncidentManager];
    [manager deleteAllData];
    
    //我给别人的提醒
    for (int i = 0; i < arrForMe.count; i++) {
        
        RemindModel *model = [[RemindModel alloc] init];
        
        
        NSDictionary *dic = arrForMe[i];
        NSString *yearMonthDay = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][0];
        NSString *hourMinute = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][1];
        
        NSString *year = [yearMonthDay substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [yearMonthDay substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [yearMonthDay substringWithRange:NSMakeRange(8, 2)];
        NSString *hour = [hourMinute substringWithRange:NSMakeRange(0, 2)];
        NSString *minute = [hourMinute substringWithRange:NSMakeRange(3, 2)];
        model.createTime = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
        
        NSString *isTop = [dic objectForKey:@"isTop"];
        if ([isTop isEqual:[NSNull null]]) {
            model.isTop = @"0";
        }else {
            model.isTop = isTop;
        }
        
        model.isSave = [[dic objectForKey:@"isSave"] intValue];
        model.countNumber = [Tool actionForReturnRightIntNumber:[dic objectForKey:@"countNumber"]];
        model.day = [Tool actionForReturnRightIntNumber:[dic objectForKey:@"day"]];
        model.hour = [Tool actionForReturnRightIntNumber:[dic objectForKey:@"hour"]];
        model.keystatus = [[dic objectForKey:@"keystatus"] intValue];
        model.content = [dic objectForKey:@"message"];
        model.uid = [[dic objectForKey:@"mid"] intValue];
        model.minute = [[dic objectForKey:@"min"] intValue];
        model.month = [[dic objectForKey:@"month"] intValue];
        model.randomType = [[dic objectForKey:@"randomType"] intValue];
        model.musicName = [[dic objectForKey:@"ringId"] intValue];
        model.year = [[dic objectForKey:@"year"] intValue];
        model.title = [dic objectForKey:@"title"];
        model.isOther = 0;
        model.headUrlStr = [dic objectForKey:@"headUrlStr"];
        model.localInfo = [dic objectForKey:@"localInfo"];
        model.latitudeStr = [dic objectForKey:@"latitudeStr"];
        model.longitudeStr = [dic objectForKey:@"longitudeStr"];
        model.isShare = 0;
        model.audioPathStr = [dic objectForKey:@"audioStr"];
        
        model.audioDurationStr = [dic objectForKey:@"audioDurationStr"];
        model.offsetMinute = [Tool actionForReturnRightIntNumber:[dic objectForKey:@"offsetMinute"]];
        NSString *timeMonth = [Tool actionForTenOrSingleWithNumber:model.month];
        NSString *timeDay = [Tool actionForTenOrSingleWithNumber:model.day];
        
        NSString *timeHour = [Tool actionForTenOrSingleWithNumber:model.hour];
        
        NSString *timeMinut = [Tool actionForTenOrSingleWithNumber:model.minute];
        
        model.timeorder = [NSString stringWithFormat:@"%d%@%@%@%@",model.year,timeMonth,timeDay,timeHour,timeMinut];
        
        
        model.weekStr = [dic objectForKey:@"weekStr"];
        NSArray *arrForObjc = [dic objectForKey:@"objList"];
        
        //            if (arrForObjc.count == 0) {
        //
        //                continue;
        //            }
        
        NSMutableString *fidStr = [NSMutableString string];
        NSMutableString *gidStr = [NSMutableString string];
        
        
        //拼串，拼好友或组的串
        for (int j = 0; j < arrForObjc.count; j++) {
            
            NSDictionary *dicForType = arrForObjc[j];
            
            int type = [dicForType[@"remindObyType"] intValue];
            int nowId = [dicForType[@"acceptUId"] intValue];
            
            NSString *strForId = @"";
            
            //拼组和朋友id
            if (j == arrForObjc.count - 1) {
                
                strForId = [NSString stringWithFormat:@"%d",nowId];
                
            }else {
                
                strForId = [NSString stringWithFormat:@"%d,",nowId];
            }
            
            //2是组ID,1是好友ID
            if (type == 2) {
                
                [gidStr appendString:strForId];
                
            }else {
                
                [fidStr appendString:strForId];
            }
            
        }
        
        model.fidStr = fidStr;
        model.gidStr = gidStr;
        
        //name拼串
        model.friendName = [Tool actionForFriendStr:fidStr];
        model.groupName = [Tool actionForGroupStr:gidStr];
        
        [manager insertDataWithremindModel:model];
   
    }
 
}

+ (void)loadPassMeRemind:(NSArray *)arrForHe
{
    //用来判断是否为给自己提醒
    IncidentListManager *manager = [IncidentListManager shareIncidentManager];
    
    NSUserDefaults *standDef = [NSUserDefaults standardUserDefaults];
    int xiaomiId = [[standDef objectForKey:kUserXiaomiID] intValue];
    

    for (int i = 0; i < arrForHe.count; i++) {
        
        RemindModel *model = [[RemindModel alloc] init];
        
        NSDictionary *dic = arrForHe[i];
        
        model.weekStr = [dic objectForKey:@"weekStr"];
        
        if (![model.weekStr isEqual:[NSNull null]]) {
            NSString *isTop = [dic objectForKey:@"isTop"];

            if ([model.weekStr isEqualToString:@"100"]) {
                
                if ([isTop isEqual:[NSNull null]]) {
                    model.isTop = @"0";
                }else {
                    model.isTop = isTop;
                }
                
                model.uid = [[dic objectForKey:@"mid"] intValue];
                model.title = [dic objectForKey:@"title"];
                model.friendName = [dic objectForKey:@"sendUname"];
                model.isOther = [[dic objectForKey:@"sendUid"] intValue];
                model.isLook = [[dic objectForKey:@"isLook"] intValue];
                NSString *yearMonthDay = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][0];
                NSString *hourMinute = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][1];
                NSString *year = [yearMonthDay substringWithRange:NSMakeRange(0, 4)];
                NSString *month = [yearMonthDay substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [yearMonthDay substringWithRange:NSMakeRange(8, 2)];
                NSString *hour = [hourMinute substringWithRange:NSMakeRange(0, 2)];
                NSString *minute = [hourMinute substringWithRange:NSMakeRange(3, 2)];
                model.createTime = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
                model.weekStr = @"100";
                
                [manager insertDataWithremindModel:model];
                
                continue;
                
            }else if([model.weekStr isEqualToString:@"101"]){
               
                if ([isTop isEqual:[NSNull null]]) {
                    model.isTop = @"0";
                }else {
                    model.isTop = isTop;
                }
                
                NSString *yearMonthDay = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][0];
                NSString *hourMinute = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][1];
                NSString *year = [yearMonthDay substringWithRange:NSMakeRange(0, 4)];
                NSString *month = [yearMonthDay substringWithRange:NSMakeRange(5, 2)];
                NSString *day = [yearMonthDay substringWithRange:NSMakeRange(8, 2)];
                NSString *hour = [hourMinute substringWithRange:NSMakeRange(0, 2)];
                NSString *minute = [hourMinute substringWithRange:NSMakeRange(3, 2)];
                model.createTime = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
                model.title = [dic objectForKey:@"title"];
                model.timeorder = [dic objectForKey:@"month"];
                model.content = [dic objectForKey:@"hour"];
                model.year  = [[dic objectForKey:@"year"]intValue];
                model.day   = [[dic objectForKey:@"day"]intValue];
                model.uid   = [[dic objectForKey:@"mid"] intValue];
                model.isLook = [[dic objectForKey:@"isLook"] intValue];
                model.isOther = [[dic objectForKey:@"sendUid"] intValue];
                [manager insertDataWithremindModel:model];

                //年 ：变更前id
                //月 ：变更前昵称
                //日 ：变更后id
                //时 ：变更后昵称
                NSLog(@"%@",dic);
                continue;

                
            }
            
        }
        
        
        
        NSString *yearMonthDay = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][0];
        NSString *hourMinute = [[dic objectForKey:@"createTime"] componentsSeparatedByString:@" "][1];
        NSString *year = [yearMonthDay substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [yearMonthDay substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [yearMonthDay substringWithRange:NSMakeRange(8, 2)];
        NSString *hour = [hourMinute substringWithRange:NSMakeRange(0, 2)];
        NSString *minute = [hourMinute substringWithRange:NSMakeRange(3, 2)];
        model.createTime = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
        
        model.isShare = 0;
        NSString *isTop = [dic objectForKey:@"isTop"];
        if ([isTop isEqual:[NSNull null]]) {
            model.isTop = @"0";
        }else {
            model.isTop = isTop;
        }
        
        model.isSave = [[dic objectForKey:@"isSave"] intValue];
        model.countNumber = [Tool actionForReturnRightIntNumber:[dic objectForKey:@"countNumber"]];
        model.day = [[dic objectForKey:@"day"] intValue];
        model.hour = [[dic objectForKey:@"hour"] intValue];
        model.content = [dic objectForKey:@"message"];
        model.uid = [[dic objectForKey:@"mid"] intValue];
        model.minute = [[dic objectForKey:@"min"] intValue];
        model.month = [[dic objectForKey:@"month"] intValue];
        model.randomType = [[dic objectForKey:@"randomType"] intValue];
        model.keystatus = [[dic objectForKey:@"keystatus"] intValue];
        model.musicName = [[dic objectForKey:@"ringId"] intValue];
        model.year = [[dic objectForKey:@"year"] intValue];
        model.title = [dic objectForKey:@"title"];
        model.isOther = [[dic objectForKey:@"sendUid"] intValue];
        model.isLook = [[dic objectForKey:@"isLook"] intValue];
        model.headUrlStr = [dic objectForKey:@"headUrlStr"];
        model.localInfo = [dic objectForKey:@"localInfo"];
        model.audioPathStr = [dic objectForKey:@"audioStr"];
        model.audioDurationStr = [dic objectForKey:@"audioDurationStr"];
        model.latitudeStr = [dic objectForKey:@"latitudeStr"];
        model.longitudeStr = [dic objectForKey:@"longitudeStr"];
        model.offsetMinute =  [Tool actionForReturnRightIntNumber:[dic objectForKey:@"offsetMinute"]];;
        NSString *timeMonth = [Tool actionForTenOrSingleWithNumber:model.month];
        NSString *timeDay = [Tool actionForTenOrSingleWithNumber:model.day];
        NSString *timeHour = [Tool actionForTenOrSingleWithNumber:model.hour];
        NSString *timeMinut = [Tool actionForTenOrSingleWithNumber:model.minute];
        model.timeorder = [NSString stringWithFormat:@"%d%@%@%@%@",model.year,timeMonth,timeDay,timeHour,timeMinut];
        
        
        //给自己发的情况
        if (model.isOther != xiaomiId) {
            
            NSString *fidStr = [NSString stringWithFormat:@"%d",model.isOther];
            model.friendName = [Tool actionForFriendStr:fidStr];
            
            [manager insertDataWithremindModel:model];
            
        }
        
    }
}

+ (void)loadShareOtherRemind:(NSArray *)arrForShareMe
{
   
    JYShareList *shareList = [JYShareList shareList];
    for (int i = 0; i < arrForShareMe.count; i++) {
        
        NSDictionary *dic = arrForShareMe[i];
        RemindModel *model = [[RemindModel alloc] init];
        model.isShare = 1;
        model.isOther = 0;
        NSString *createTime = [dic objectForKey:@"createTime"];
        NSString *year = [createTime substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [createTime substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [createTime substringWithRange:NSMakeRange(8, 2)];
        NSString *hour = [createTime substringWithRange:NSMakeRange(11, 2)];
        NSString *minute = [createTime substringWithRange:NSMakeRange(14, 2)];
        model.isSave = [[dic objectForKey:@"isSave"] intValue];
        model.createTime = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
        model.day = [[dic objectForKey:@"day"] intValue];
        model.hour = [[dic objectForKey:@"hour"] intValue];
        model.isLook = 0;
        model.keystatus = [[dic objectForKey:@"keystatus"] intValue];
        model.content = [dic objectForKey:@"message"];
        model.minute = [[dic objectForKey:@"min"] intValue];
        model.month = [[dic objectForKey:@"month"] intValue];
        model.randomType = [[dic objectForKey:@"randomType"] intValue];
        model.musicName = [[dic objectForKey:@"ringId"] intValue];
        model.uid = [[dic objectForKey:@"mid"] intValue];
        model.year = [[dic objectForKey:@"year"] intValue];
        model.title = [dic objectForKey:@"title"];
        model.headUrlStr = [dic objectForKey:@"headUrlStr"];
        model.localInfo = [dic objectForKey:@"localInfo"];
        model.latitudeStr = [dic objectForKey:@"latitudeStr"];
        model.longitudeStr = [dic objectForKey:@"longitudeStr"];
        model.weekStr = [dic objectForKey:@"weekStr"];
        model.audioPathStr = [dic objectForKey:@"audioStr"];
        model.audioDurationStr = [dic objectForKey:@"audioDurationStr"];
        model.offsetMinute =  [Tool actionForReturnRightIntNumber:[dic objectForKey:@"offsetMinute"]];;
        
        NSArray *acceptArr = [dic objectForKey:@"objList"];  //分享好友、群组表
        NSMutableString *gidStr = [NSMutableString string];
        NSMutableString *fidStr = [NSMutableString string];
        
        for (int i = 0; i < acceptArr.count; i++) {
            
            NSDictionary *dic = acceptArr[i];
            NSString *nowid = [dic objectForKey:@"acceptUId"];
         
            if (![nowid isKindOfClass:[NSNull class]]) {
                
                //type为2是分享给群组，1为好友
                if ([[dic objectForKey:@"remindObyType"] isEqualToString:@"2"]) {
                    
                    [gidStr appendFormat:@"%@,",nowid];
                    
                }else{
                 
                    [fidStr appendFormat:@"%@,",nowid];
                }
            }
        }
        
        if (fidStr.length > 0) {
            
            model.fidStr = [fidStr substringWithRange:NSMakeRange(0, fidStr.length - 1)];
            
        }else{
            
            model.fidStr = @"";
        }
        
        if (gidStr.length > 0) {
            
            model.gidStr = [gidStr substringWithRange:NSMakeRange(0, gidStr.length - 1)];
        }else{
            
            model.gidStr = @"";
        }
        NSString *year1 = [Tool actionForTenOrSingleWithNumber:model.year];
        NSString *month1 = [Tool actionForTenOrSingleWithNumber:model.month];
        NSString *day1 = [Tool actionForTenOrSingleWithNumber:model.day];
        NSString *hour1 = [Tool actionForTenOrSingleWithNumber:model.hour];
        NSString *minute1 = [Tool actionForTenOrSingleWithNumber:model.minute];
        
        model.timeorder = [NSString stringWithFormat:@"%@%@%@%@%@",year1,month1,day1,hour1,minute1];
        model.friendName = [Tool actionForFriendStr:model.fidStr];
        model.groupName = [Tool actionForGroupStr:model.gidStr];
        NSString *isTop = [dic objectForKey:@"isTop"];
        if ([isTop isEqual:[NSNull null]]) {
            model.isTop = @"0";
        }else {
            model.isTop = isTop;
        }
        
        [shareList insertRemindModel:model fidStr:model.fidStr gidStr:model.gidStr mid:[[dic objectForKey:@"sid"] intValue]];
        
    }
}

+ (void)loadShareMeRemind:(NSArray *)arrForShareHe
{
    JYShareList *shareList = [JYShareList shareList];
    [shareList deleteAllData];
    for (int i = 0; i < arrForShareHe.count; i++) {
        
        NSDictionary *dic = arrForShareHe[i];
        RemindModel *model = [[RemindModel alloc] init];
        model.countNumber = [[dic objectForKey:@"countNumber"] intValue];
        NSString *createTime = [dic objectForKey:@"createTime"];
        NSString *year = [createTime substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [createTime substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [createTime substringWithRange:NSMakeRange(8, 2)];
        NSString *hour = [createTime substringWithRange:NSMakeRange(11, 2)];
        NSString *minute = [createTime substringWithRange:NSMakeRange(14, 2)];
        
        model.isSave = [[dic objectForKey:@"isSave"] intValue];
        model.createTime = [NSString stringWithFormat:@"%@%@%@%@%@",year,month,day,hour,minute];
        model.isOther = [[dic objectForKey:@"sendUid"] intValue];
        model.day = [[dic objectForKey:@"day"] intValue];
        model.isLook = [[dic objectForKey:@"isLook"] intValue];
        model.keystatus = [[dic objectForKey:@"keystatus"] intValue];
        model.content = [dic objectForKey:@"message"];
        model.minute = [[dic objectForKey:@"min"] intValue];
        model.month = [[dic objectForKey:@"month"] intValue];
        model.randomType = [[dic objectForKey:@"randomType"] intValue];
        model.hour = [[dic objectForKey:@"hour"] intValue];
        model.musicName = [[dic objectForKey:@"ringId"] intValue];
        model.uid = [[dic objectForKey:@"mid"] intValue];
        model.title = [dic objectForKey:@"title"];
        model.year = [[dic objectForKey:@"year"]intValue];
        model.headUrlStr = [dic objectForKey:@"headUrlStr"];
        model.localInfo = [dic objectForKey:@"localInfo"];
        model.latitudeStr = [dic objectForKey:@"latitudeStr"];
        model.longitudeStr = [dic objectForKey:@"longitudeStr"];
        model.isShare = 1;
        model.audioPathStr = [dic objectForKey:@"audioStr"];
        model.audioDurationStr = [dic objectForKey:@"audioDurationStr"];
        model.offsetMinute =  [Tool actionForReturnRightIntNumber:[dic objectForKey:@"offsetMinute"]];;
        
        NSString *year1 = [Tool actionForTenOrSingleWithNumber:model.year];
        NSString *month1 = [Tool actionForTenOrSingleWithNumber:model.month];
        NSString *day1 = [Tool actionForTenOrSingleWithNumber:model.day];
        NSString *hour1 = [Tool actionForTenOrSingleWithNumber:model.hour];
        NSString *minute1 = [Tool actionForTenOrSingleWithNumber:model.minute];
        model.weekStr = [dic objectForKey:@"weekStr"];
        
        model.timeorder = [NSString stringWithFormat:@"%@%@%@%@%@",year1,month1,day1,hour1,minute1];
        NSString *fidStr = [NSString stringWithFormat:@"%d",model.isOther];
        model.friendName = [Tool actionForFriendStr:fidStr];
        NSString *isTop = [dic objectForKey:@"isTop"];
        if ([isTop isEqual:[NSNull null]]) {
            model.isTop = @"0";
        }else {
            model.isTop = isTop;
        }
        [shareList insertRemindModel:model fidStr:model.fidStr gidStr:model.gidStr mid:[[dic objectForKey:@"sid"] intValue]];
        
    }
}

+ (void)showAlter:(id)vc title:(NSString *)title;
{
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:vc cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
    });
}

+ (BOOL)compTime:(NSInteger )modelHour other:(NSInteger )modelMinute
{
 
    int hour = [[Tool actionforNowHour] intValue];
    int minute = [[Tool actionforNowMinute] intValue];
    
    NSString *nowDate = [NSString stringWithFormat:@"%02d%02d",hour,minute];
    NSString *selectDate = [NSString stringWithFormat:@"%02ld%02ld",modelHour,modelMinute];
    
    if ([nowDate integerValue] >= [selectDate integerValue]) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}

+ (NSString *)countDownStrWithModel:(RemindModel *)model
{
    NSString *countDownStr = [NSString stringWithFormat:@"%d年%02d月%02d日 %02d:%02d",model.year,model.month,model.day,model.hour,model.minute];
    
    return countDownStr;
}

+ (NSString *)countDownStrWithModelTime:(RemindModel *)model
{
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSInteger nowDate = [[formatter stringFromDate:[NSDate date]]integerValue];
    NSInteger selectTime = [[NSString stringWithFormat:@"%d%02d%02d",model.year_random,model.month_random,model.day_random]integerValue];
    NSString *returnStr ;

        if (nowDate == selectTime) {
            returnStr = [NSString stringWithFormat:@"%02d:%02d",model.hour,model.minute];
        }else if(selectTime - nowDate == 1){
            returnStr = @"明天";
        }else if(selectTime - nowDate == 2){
            returnStr = @"后天";
        }else{
            
            returnStr = [Tool laterDate:model];
        }
 
    return returnStr;
    
    

    
}

+ (NSString *)laterDate:(RemindModel *)model
{
    NSDate *nowDate = [NSDate date];
    NSDateComponents *com = [[NSDateComponents alloc] init];
    [com setTimeZone:[NSTimeZone systemTimeZone]];
    [com setYear:model.year_random];
    [com setMonth:model.month_random];
    [com setDay:model.day_random];
    [com setHour:model.hour];
    [com setMinute:model.minute];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *selectDate = [gregorian dateFromComponents:com];
    
    NSInteger times = [selectDate timeIntervalSinceDate:nowDate]*1;
    
    CGFloat days  = (times / (24 * 60 * 60)) / 365.0;
    NSInteger day = round(days);
    NSString *returnStr = @"";
    
    if (day != 0) {
        returnStr = [NSString stringWithFormat:@"%ld年",day];
    }else{
        
        NSInteger afterDay = round(times / (24.0 * 60.0 * 60.0));
        returnStr = [NSString stringWithFormat:@"%ld天",afterDay];
    }
    
    return returnStr;
}

+ (BOOL )isPastOtherRemind:(NSString *)fidStr gidStr:(NSString *)gidStr
{
    //我发送给自己的
    if ([fidStr isEqualToString:@""] && [gidStr isEqualToString:@""]) {
        return YES;
    }
    
    //我发送给群组好友的
    if (![gidStr isEqualToString:@""] && [fidStr isEqualToString:@""]) {
        return NO;
    }
    
    
    //我发送给好友，其中包括我返回YES
    NSArray *fid = [fidStr componentsSeparatedByString:@","];
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID];
    for (NSString *fidStr in fid) {
        if ([fidStr isEqualToString:userID]) {
            return YES;
        }
    }
    
    
    return NO;
}


+ (void)actionForChangeModelAbsoluteTime:(RemindModel *)model
{
  
    //本地时区
    NSDateComponents *com = [[NSDateComponents alloc] init];
    [com setTimeZone:[NSTimeZone systemTimeZone]];
    [com setYear:model.year];
    [com setMonth:model.month];
    [com setDay:model.day];
    [com setHour:model.hour];
    [com setMinute:model.minute];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDate *selectDate = [gregorian dateFromComponents:com];
    
    //UTC时区
    NSDateComponents *utcCom = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:selectDate];
    [utcCom setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSCalendar *gregorian1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian1 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
    NSDate *selectDate1 = [gregorian1 dateFromComponents:utcCom];
    
    
    //北京时区
    NSDateComponents *beijingCom1 = [gregorian1 components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:selectDate1];
   
    
    model.year = (int)beijingCom1.year;
    model.month = (int)beijingCom1.month;
    model.day  = (int)beijingCom1.day;
    model.hour = (int)beijingCom1.hour;
    model.minute = (int)beijingCom1.minute;
    
}

@end
