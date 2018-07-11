//
//  JYCalculateRandomTime.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCalculateRandomTime.h"
#import "JYToolForCalendar.h"


static JYCalculateRandomTime *timeManager = nil;
@implementation JYCalculateRandomTime

+ (JYCalculateRandomTime *)manager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (timeManager == nil) {
            
            timeManager = [[JYCalculateRandomTime alloc] init];
            
        }
        
    });
    
    return timeManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (timeManager == nil) {
            
            timeManager = [super allocWithZone:zone];
        }
        
    });
    
    return timeManager;
}


- (void)calculateRandomModel:(RemindModel *)model
{
    switch (model.randomType) {
            case selectMonday:
        {
            [self selectSystem:model];
        }
            break;
            case selectTuesday:
        {
            [self selectSystem:model];
        }
            break;
            case selectWednesday:
        {
            [self selectSystem:model];
        }
            break;
            case selectThursday:
        {
            [self selectSystem:model];
        }
            break;
            case selectFriday:
        {
            [self selectSystem:model];
        }
            break;
            case selectSaturday:
        {
            [self selectSystem:model];
        }
            break;
            case selectSunday:
        {
            [self selectSystem:model];
        }
            break;
            case selectEveryDay:
        {
            [self selectEveryDay:model];
        }
            break;
            case selectEveryMonth:
        {
            [self selectEveryMonth:model];
        }
            break;
            case selectEveryYear:
        {
            [self selectEveryYear:model];
        }
            break;
            case selectDay:
        {
            [self selfDefineDay:model];
        }
            break;
            case selectWeek:
        {
            [self selfDefineWeek:model];
        }
            break;
            case selectMonth:
        {
            [self selfDefineMonth:model];
        }
            break;
            case selectYear:
        {
            [self selfDefineYear:model];
        }
            break;
            case selectSomeDays:
        {
            [self selfDefineSomeDays:model];
        }
            break;
            
        default:
            break;
    }
}


/**
 *  返回距离今天的总时间
 */
- (NSInteger )modelTime:(RemindModel *)model
{
    //周日 = 1 周一 = 2 周二 = 3 周三 = 4 周四 = 5 周五 = 6 周六 = 7
    //1, 2 ,3 ,4 ,5 ,6 ,7
    NSInteger week = [Tool actionForNowWeek:[NSDate date]];
    if (week == 1) {
        week = 7;
    }else{
        week = week - 1;
    }
    //2
    NSInteger chazhi ;
    //相同时间
    if (model.randomType == week) {
        chazhi = 0;
        //随机时间大于当前时间
    }else if(model.randomType > week){
        chazhi = model.randomType - week;
    }else{
        //随机时间小于当前时间
        chazhi = (7 - week) + model.randomType;
    }
    
    //如果随机时间正好是当天且过了提醒时间，需要置为下周
    if (chazhi == 0 && [self isNextTime:model]) {
        
        chazhi = 7;
    }
    
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970]*1;
    NSInteger modelTime = nowTime + chazhi * 24 * 60 * 60;
    
    return modelTime;

}

/**
 *  判断是当天但过了当天提醒时间
 */
- (BOOL)isNextTime:(RemindModel *)model
{
    NSInteger hour = [[Tool actionforNowHour]integerValue];
    NSInteger  minute = [[Tool actionforNowMinute]integerValue];

    BOOL isNextWeek = NO;

    if ((model.hour * 60 * 60 + model.minute * 60) <= (hour * 60 * 60 + minute * 60)) {
        isNextWeek = YES;
    }
    
    return isNextWeek;
}

/**
 *  @param dateCom 重复提醒的最近日期
 *  @param model
 */
- (void)setModelTime:(NSDateComponents *)dateCom
               model:(RemindModel *)model
{

    model.year_random = (int)dateCom.year;
    model.month_random = (int)dateCom.month;
    model.day_random = (int)dateCom.day;
}

/**
 *  间隔时间
 */
- (NSDateComponents *)dateComponents:(RemindModel *)model
                           modelTime:(NSInteger )modelTime
{
 
    NSDate *modelDate = [NSDate dateWithTimeIntervalSince1970:modelTime];
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateCom = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:modelDate];
    return dateCom;
}

//modelTime
- (NSInteger )page_Day:(RemindModel *)model
{
    
    
    NSDateComponents *com = [[NSDateComponents alloc] init];
    [com setYear:model.year];
    [com setMonth:model.month];
    [com setDay:model.day];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *modelDate = [gregorian dateFromComponents:com];
    
    //model总秒数
    NSInteger modelTime = [modelDate timeIntervalSince1970]*1;
    
    
    return modelTime;
}



#pragma mark -计算方法


//每周一 至 每周日
- (void)selectSystem:(RemindModel *)model
{
    
    
    NSInteger modelTime = [self modelTime:model];

    NSDateComponents *dateCom = [self dateComponents:model modelTime:modelTime];
    [self setModelTime:dateCom model:model];
 
}

//每天
- (void)selectEveryDay:(RemindModel *)model
{
    if ([self isNextTime:model]) {
        
        
        NSInteger nowTime = [[NSDate date] timeIntervalSince1970]*1;
        NSInteger modelTime = nowTime + 24 * 60 * 60;
       
        
        NSDateComponents *dateCom = [self dateComponents:model modelTime:modelTime];
        
        [self setModelTime:dateCom model:model];
        
    }else{
        
        model.day_random = _day;
        model.month_random = _month;
        model.year_random = _year;
    }
    

}

//每月
- (void)selectEveryMonth:(RemindModel *)model
{
    if (model.day == _day) {
        
        if ([self isNextTime:model]) {
            
            int monthNow = _month + 1;
            int yearNow = _year;
            
            if (monthNow > 12) {
                monthNow = 1;
                yearNow ++;
            }
            
            //小于总天数，跳过赋值
            while ([JYToolForCalendar actionForNowManyDayWithMonth:monthNow year:yearNow] < model.day) {
                
                monthNow ++;
                if (monthNow > 12) {
                    monthNow = 1;
                    yearNow ++;
                }
            }
            
            model.month_random = monthNow;
            model.year_random  = yearNow;
          
            
        }else{
        
            model.year_random = _year;
            model.month_random = _month;
        }
        
    }else{
     
        //大于当天，小于当天情况
        if (model.day > _day) {
            
            int monthNow = _month;
            int yearNow = _year;
            
            //小于总天数，跳过赋值
            while ([JYToolForCalendar actionForNowManyDayWithMonth:monthNow year:yearNow] < model.day) {
                
                monthNow ++;
                if (monthNow > 12) {
                    monthNow = 1;
                    yearNow ++;
                }
            }
            
            model.month_random = monthNow;
            model.year_random  = yearNow;
            
        }else{
        
            int monthNow = _month + 1;
            int yearNow = _year;
            
            if (monthNow > 12) {
                monthNow = 1;
                yearNow ++;
            }
            
            //小于总天数，跳过赋值
            while ([JYToolForCalendar actionForNowManyDayWithMonth:monthNow year:yearNow] < model.day) {
                
                monthNow ++;
                if (monthNow > 12) {
                    monthNow = 1;
                    yearNow ++;
                }
            }

            model.month_random = monthNow;
            model.year_random  = yearNow;
        }
    }
    
    model.day_random = model.day;
}

//每年
- (void)selectEveryYear:(RemindModel *)model
{
    int nowYear = _year;
    //是否当天
    if (model.month == _month && model.day == _day) {
        
        //是否过了提醒时间
        if ([self isNextTime:model]) {
            
            model.year_random = nowYear + 1;
            
        }else{
         
            model.year_random = nowYear;
        }
        
    }else{
     
        if (model.month > _month) {
            
            model.year_random = nowYear;
            
        }else if(model.month < _month){
         
            model.year_random = nowYear + 1;
            
        }else{
        
            if (model.day > _day) {
                model.year_random = nowYear;
            }else{
                model.year_random = nowYear + 1;
            }
        }
        
    }
 
    model.month_random = model.month;
    model.day_random = model.day;
}

//自定义日
- (void)selfDefineDay:(RemindModel *)model
{

   
    
    CGFloat  nowTime = [[NSDate date]timeIntervalSince1970]*1;
    CGFloat modelTime = [self page_Day:model];
    
    if (modelTime > nowTime) {
        model.year_random = model.year;
        model.month_random = model.month;
        model.day_random = model.day;
        
        return;
    }
    
    NSInteger page_day = (nowTime - modelTime) / 60 / 60 / 24;
    NSUInteger remindTime;

    //判断是否是当天 -> 是 -> 是否过提醒时间
    //否 -> 直接计算要显示的下个日期
    if (page_day % model.countNumber == 0) {
        
        if ([self isNextTime:model]) {
            remindTime = nowTime + model.countNumber * 24 * 60 * 60;
        }else{
            remindTime = nowTime;
        }
        
    }else{
    
        remindTime = (page_day % model.countNumber) * 24 * 60 * 60 + nowTime;
    }
    
    
    NSLog(@"%lf",nowTime - modelTime);
    //差的秒数
    //先判断是否过提醒时间
    
        
  
    NSDateComponents *com = [self dateComponents:model modelTime:remindTime];
    [self setModelTime:com model:model];
    
}

//自定义周
- (void)selfDefineWeek:(RemindModel *)model
{
    CGFloat  nowTime = [[NSDate date]timeIntervalSince1970]*1;
    CGFloat modelTime = [self page_Day:model];
    
    /*
    if (modelTime > nowTime) {
        model.year_random = model.year;
        model.month_random = model.month;
        model.day_random = model.day;
        
        return;
    }
    */
    
    NSInteger page_day = (nowTime - modelTime) / 60 / 60 / 24;
    NSUInteger remindTime;
    
    //判断是否是当天 -> 是 -> 是否过提醒时间
    //否 -> 直接计算要显示的下个日期
    if (page_day % (model.countNumber*7) == 0) {
        
        if ([self isNextTime:model]) {
            remindTime = nowTime + (model.countNumber*7) * 24 * 60 * 60;
        }else{
            remindTime = nowTime;
        }
        
    }else{
        
        remindTime = (page_day % (model.countNumber*7)) * 24 * 60 * 60 + nowTime;
    }
    
    
    NSLog(@"%lf",nowTime - modelTime);
    //差的秒数
    //先判断是否过提醒时间
    
    
    
    NSDateComponents *com = [self dateComponents:model modelTime:remindTime];
    [self setModelTime:com model:model];

}

//自定义月
- (void)selfDefineMonth:(RemindModel *)model
{
    
    NSInteger now = [[NSString stringWithFormat:@"%d%02d%02d",_year,_month,_day]integerValue];
    NSInteger select = [[NSString stringWithFormat:@"%d%02d%02d",model.year,model.month,model.day]integerValue];
    
    
    if (select > now) {
       
        model.month_random = model.month;
        model.year_random = model.year;
        
    }else if(select == now){
    
        if ([self isNextTime:model]) {
            
            model.month_random = model.month + model.countNumber;
            
            while (model.month_random > 12) {
                model.month_random = model.month_random - 12;
                model.year_random = model.year + 1;
            }
            
            
        }else{
            
            model.month_random = model.month;
            model.year_random = model.year;
        }
        
    }else{
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *select = [[NSDateComponents alloc] init];
        select.year = model.year;
        select.month = model.month;
        select.day = model.day;
        
        
        NSDate *selectDate = [calendar dateFromComponents:select];
        
        NSDateComponents *now  = [[NSDateComponents alloc] init];
        now.year = _year;
        now.month = _month;
        now.day = _day;
        
        NSDate *nowDate = [calendar dateFromComponents:now];
        
        NSInteger times = [nowDate timeIntervalSinceDate:selectDate]*1;
        
        NSInteger chazhi = times / 60 / 60 / 24 / 30;
        
        if (chazhi <= model.countNumber) {
            model.month_random = model.month + model.countNumber;
        }else{
            model.month_random = _month + chazhi % model.countNumber;
        }
        
        model.year_random = _year;
        
        while (model.month_random > 12) {
            model.month_random = model.month_random - 12;
            model.year_random = model.year_random + 1;
        }
    }
    
    
    model.day_random = model.day;

}


//自定义年
- (void)selfDefineYear:(RemindModel *)model
{
    NSInteger year_page = _year - model.year;
    
    //判断当天是否有提醒
    if (model.day == _day && model.month == _month && year_page % model.countNumber == 0) {
        
        if ([self isNextTime:model]) {
            model.year_random = _year + model.countNumber;
        }else{
            model.year_random = _year;
        }
        
        
    }else{
       
        NSInteger selectDays = [[NSString stringWithFormat:@"%02d%02d",model.month,model.day]integerValue];
        NSInteger nowDays    = [[NSString stringWithFormat:@"%02d%02d",_month,_day]integerValue];
        
        if (year_page % model.countNumber == 0 && nowDays > selectDays) {

            model.year_random = _year + model.countNumber;

        }else{
            
            model.year_random = _year + year_page % model.countNumber;

        }
    }
    
    model.day_random = model.day;
    model.month_random = model.month;
}


//自定义星期
- (void)selfDefineSomeDays:(RemindModel *)model
{
 
    NSArray *weekArr = [model.weekStr componentsSeparatedByString:@","];
    //周日 = 1 周一 = 2 周二 = 3 周三 = 4 周四 = 5 周五 = 6 周六 = 7
    //1, 2 ,3 ,4 ,5 ,6 ,7
    NSInteger week = [Tool actionForNowWeek:[NSDate date]];
    if (week == 1) {
        week = 7;
    }else{
        week = week - 1;
    }
    
    BOOL isTodayRemind = NO;
    for (NSString *weekStr in weekArr) {
        
        if ([weekStr integerValue] == week) {
            isTodayRemind = YES;
            break;
        }
    }
    

    if (isTodayRemind) {
        
        if ([self isNextTime:model]) {
            
            [self randomWeek:weekArr week:week model:model];
            
        }else{
         
            model.year_random = _year;
            model.month_random = _month;
            model.day_random = _day;
        }
        
    }else{
    
        
        [self randomWeek:weekArr week:week model:model];
        
    }
    
}


/**
 *  自定义星期
 *
 *  @param weekArr 定义的具体星期   如(1,2,3)周一，周二，周三重复
 *  @param week    当前星期
 *  @param model   model
 */
- (void)randomWeek:(NSArray *)weekArr
              week:(NSInteger )week
             model:(RemindModel *)model
{
    NSInteger bigWeek = 0;
    NSInteger smallWeek = 0;
    for (NSString *weekStr in weekArr) {
        if ([weekStr integerValue] > week) {
            bigWeek = [weekStr integerValue];
            break;
        }
    }
    
    if (bigWeek != 0) {
        
        NSInteger modelTime = [self modelTimeForMore:bigWeek];
        
        NSDateComponents *dateCom = [self dateComponents:model modelTime:modelTime];
        [self setModelTime:dateCom model:model];
        
    }else{
        
        for (NSString *weekStr in weekArr) {
            if ([weekStr integerValue] < week) {
                smallWeek = [weekStr integerValue];
                break;
            }
        }
        
        NSInteger modelTime = [self modelTimeForMore:smallWeek];
        
        NSDateComponents *dateCom = [self dateComponents:model modelTime:modelTime];
        [self setModelTime:dateCom model:model];
    }
}


/**
 *  返回距离今天的总时间(星期多选)
 */
- (NSInteger )modelTimeForMore:(NSInteger )timeWeek
{
    //周日 = 1 周一 = 2 周二 = 3 周三 = 4 周四 = 5 周五 = 6 周六 = 7
    //1, 2 ,3 ,4 ,5 ,6 ,7
    NSInteger week = [Tool actionForNowWeek:[NSDate date]];
    if (week == 1) {
        week = 7;
    }else{
        week = week - 1;
    }
    
    NSInteger chazhi ;
    //相同时间
    if (timeWeek == week) {
        chazhi = 0;
        //随机时间大于当前时间
    }else if(timeWeek > week){
        chazhi = timeWeek - week;
    }else{
        //随机时间小于当前时间
        chazhi = (7 - week) + timeWeek;
    }
    

    
    NSInteger nowTime = [[NSDate date] timeIntervalSince1970]*1;
    NSInteger modelTime = nowTime + chazhi * 24 * 60 * 60;
    
    return modelTime;
    
}

@end
