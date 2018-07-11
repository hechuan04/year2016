//
//  JYToolForCalendar.m
//  rilixiugai
//
//  Created by 吴冬 on 15/11/25.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYToolForCalendar.h"
#import "JYCalendarModel.h"

static JYToolForCalendar *toolForCalendar = nil;

//节假日字体
#define fontForSolarHoliday()(IS_IPHONE_4_SCREEN?13:(IS_IPHONE_5_SCREEN?14:(IS_IPHONE_6_SCREEN?15:16)))

@implementation JYToolForCalendar

+ (JYToolForCalendar *)shareTool {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        toolForCalendar = [[JYToolForCalendar alloc] init];
        
    });
    
    return toolForCalendar;
    
}


+ (NSInteger )actionForNowWeek:(NSDate *)inputDate {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return theComponents.weekday;
    
}

+ (NSInteger )actionForNowWeekUTC:(NSDate *)inputDate {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return theComponents.weekday;
    
}


+ (NSDate *)actionForReturnSelectedDateWithDay:(NSInteger)day
                                          Year:(NSInteger)year
                                         month:(NSInteger)month {
    
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    [comp setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [comp setYear:year];
    [comp setMonth:month];
    [comp setDay:day];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comp];
    
    return date;
    
}

+ (NSInteger )actionForNowManyDayWithMonth:(NSInteger )monthNow
                                      year:(NSInteger )yearNow; {
    
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


+ (NSString *)actionForNowSingleDay:(NSDate *)date {
    
    if (date == nil) {
        
        date = [NSDate date];
        
    }
    
    NSString *strForNowDate = [NSString stringWithFormat:@"%@",date];
    NSString *strForDay = [strForNowDate substringWithRange:NSMakeRange(8, 2)];
    
    return strForDay;
    
}


+ (NSString *)actionForNowYear:(NSDate *)date {
    
    if (date == nil) {
        
        date = [NSDate date];
        
    }
    
    NSString *strForNowDate = [NSString stringWithFormat:@"%@",date];
    NSString *strYear = [strForNowDate substringWithRange:NSMakeRange(0, 4)];
    NSString *strForNow = [NSString stringWithFormat:@"%@",strYear];
    
    return strForNow;
    
}

+ (NSString *)actionForNowMonth:(NSDate *)date {
    
    if (date == nil) {
        
        date = [NSDate date];
        
    }
    
    NSString *strForNowDate = [NSString stringWithFormat:@"%@",date];
    NSString *strMonth = [strForNowDate substringWithRange:NSMakeRange(5, 2)];
    NSString *strForNow = [NSString stringWithFormat:@"%@",strMonth];
    
    return strForNow;
    
}


+ (NSDictionary *)actionForReturnYear:(int )year
                                month:(int )month
                                  day:(int )day
                             isBefore:(BOOL)isBefore {

    int year1 = year;
    int month1 = month;
    int day1 = day;
    
    if (isBefore) {
        
        month1--;
        
        if (month1 <= 0) {
            
            month1 = 12;
            year1--;
            
        }
        
    }else{
    
        month1++;
        
        if (month1 > 12) {
            
            month1 = 1;
            year1++;
            
        }
        
    }
  
    NSDictionary *dic = @{@"year":@(year1),@"month":@(month1),@"day":@(day1)};
    
    return dic;
    
}

+ (NSMutableAttributedString *)actionForReturnTextWithYear:(int )year
                                                     month:(int )month
                                                       day:(int )day
                                               notNowMonth:(BOOL)notNowMonth {
   
    JYSelectManager *manager = [JYSelectManager shareSelectManager];
    
    //换肤的颜色
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    
    
    Solar *solar = [[Solar alloc] init];
    solar.solarYear = year;
    solar.solarMonth = month;
    solar.solarDay = day;
    
    Lunar *lunar = [LunarSolarConverter solarToLunar:solar];
    
    NSString *lunarDay = manager.arrForAllLunarDay[lunar.lunarDay - 1];
    
    LunarCalendar *calendar = [LunarCalendar new];
    [calendar InitializeValueForComputeSolarTerm:year :month :day];
   
    
    CGFloat alpha = 0;
    CGFloat holidayAlpha = 0;
    if (notNowMonth) {
        alpha = 0.1;
        holidayAlpha = 0.3;
    }else{
        alpha = 1;
        holidayAlpha = 1;
    }
    
    //阴历日
    NSMutableAttributedString *strForLunarDay = [[NSMutableAttributedString alloc] initWithString:lunarDay];
    [strForLunarDay addAttribute:NSFontAttributeName value:manager.fontForLunar range:NSMakeRange(0, strForLunarDay.length)];
    
    [strForLunarDay addAttribute:NSForegroundColorAttributeName value:[skinManager.colorForLunar colorWithAlphaComponent:alpha] range:NSMakeRange(0, strForLunarDay.length)];
    
    
    //阳历日
    NSString *solorDay = [NSString stringWithFormat:@"%d\n",day];
    NSMutableAttributedString *strForSolorDay = [[NSMutableAttributedString alloc] initWithString:solorDay];
    [strForSolorDay addAttribute:NSFontAttributeName value:manager.fontForSolar range:NSMakeRange(0, strForSolorDay.length)];
    
    
    NSString *week = [Tool actionForWeekWithYear:year month:month day:day];
    
    if ([week isEqualToString:@"周六"] || [week isEqualToString:@"周日"]) {
        
        [strForSolorDay addAttribute:NSForegroundColorAttributeName value:[selectAndSundayColor colorWithAlphaComponent:alpha] range:NSMakeRange(0, strForSolorDay.length)];
        
    }else{
        
        [strForSolorDay addAttribute:NSForegroundColorAttributeName value:[skinManager.colorForSolarNormal colorWithAlphaComponent:alpha]range:NSMakeRange(0, strForSolorDay.length)];
    }
    
    //节气
    NSString *solarTermTitle = calendar.SolarTermTitle;
    
    //中国节日
    NSString *chineseKey = [NSString stringWithFormat:@"%d|%d",lunar.lunarMonth,lunar.lunarDay];
    NSString *chineseHoliday = manager.chineseHoliday[chineseKey];
    
    //中国休息的节日
    NSString *noWorkKey = [NSString stringWithFormat:@"%d|%d",month,day];
    NSString *noWorkHoliday = manager.noWorkHoliday[noWorkKey];
    
    //世界节日
    NSString *worldKey = [JYToolForCalendar actionForKeyStrWithMonth:month day:day];
    NSString *worldHoliday = manager.worldHoliday[worldKey];
    //显示3个字的
    NSString *firstStr = [worldHoliday substringWithRange:NSMakeRange(0, 1)];
    
   
    JYCalendarModel *model = [[JYCalendarModel alloc] initWithYear:year month:month day:day];
    
    NSString *foDay = @"";
    if (model.foDay && model.foDay.length >= 4 &&!model.isLeap) {
        foDay = [model.foDay substringWithRange:NSMakeRange(0, 4)];
    }
    
    
    if(solarTermTitle != NULL && ![solarTermTitle isEqualToString:@""]){
        
        NSMutableAttributedString *solarTermTitleAttr = [JYToolForCalendar attributedString:solarTermTitle font:manager.fontForLunar color:skinManager.colorForNormalHoliday alpha:holidayAlpha];
        
        [strForSolorDay appendAttributedString:solarTermTitleAttr];
        
        
    }else if (chineseHoliday != NULL) {
        
        NSMutableAttributedString *chineseHolidayA = [JYToolForCalendar attributedString:chineseHoliday font:manager.fontForLunar color:skinManager.colorForChineseHoliday alpha:holidayAlpha];
        
        [strForSolorDay appendAttributedString:chineseHolidayA];
        
    }else if(noWorkHoliday != NULL){
        
        NSMutableAttributedString *noWorkHolidayA = [JYToolForCalendar attributedString:noWorkHoliday font:manager.fontForLunar color:skinManager.colorForNormalHoliday alpha:holidayAlpha];
        
        [strForSolorDay appendAttributedString:noWorkHolidayA];
        
    }else if(worldHoliday != NULL && ![firstStr isEqualToString:@" "]){
        
        NSMutableAttributedString *worldHolidayA = [JYToolForCalendar attributedString:worldHoliday font:manager.fontForLunar color:skinManager.colorForNormalHoliday alpha:holidayAlpha];
        
        [strForSolorDay appendAttributedString:worldHolidayA];
        
    }else if(![foDay isEqualToString:@""]){
        
        NSMutableAttributedString *foDayHoliday = [JYToolForCalendar attributedString:foDay font:manager.fontForLunar color:skinManager.colorForNormalHoliday alpha:holidayAlpha];
        
        [strForSolorDay appendAttributedString:foDayHoliday];
        
    }else{
        [strForSolorDay appendAttributedString:strForLunarDay];

    }
    
    return strForSolorDay;

}


+ (NSMutableAttributedString *)attributedString:(NSString *)contentStr
                                           font:(UIFont *)font
                                          color:(UIColor *)color
                                          alpha:(CGFloat )alpha
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    [attributedStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, contentStr.length)];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[color colorWithAlphaComponent:alpha]  range:NSMakeRange(0, contentStr.length)];

    return attributedStr;
}



+ (NSString *)actionForReturnFestialWithYear:(int)year
                                       month:(int)month
                                         day:(int)day
{
    
    JYSelectManager *manager = [JYSelectManager shareSelectManager];
    
    Solar *solar = [[Solar alloc] init];
    solar.solarYear = year;
    solar.solarMonth = month;
    solar.solarDay = day;
    
    Lunar *lunar = [LunarSolarConverter solarToLunar:solar];
    
    NSMutableString *strForSolorDay = [[NSMutableString alloc]init];
    
    LunarCalendar *calendar = [LunarCalendar new];
    [calendar InitializeValueForComputeSolarTerm:year :month :day];
    
    //节气
    NSString *solarTermTitle = calendar.SolarTermTitle;
    
    //中国节日
    NSString *chineseKey = [NSString stringWithFormat:@"%d|%d",lunar.lunarMonth,lunar.lunarDay];
    NSString *chineseHoliday = manager.chineseHoliday[chineseKey];
    
    
    
    //世界节日
    NSString *worldKey = [JYToolForCalendar actionForKeyStrWithMonth:month day:day];
    NSString *worldHoliday = manager.worldHoliday[worldKey];
    
    if(solarTermTitle != NULL && ![solarTermTitle isEqualToString:@""]){
    
        [strForSolorDay appendString:solarTermTitle];
        //增加一空行以对其
        [strForSolorDay insertString:@" " atIndex:0];
        
    }else if (chineseHoliday != NULL) {
        
        [strForSolorDay appendString:chineseHoliday];
        //增加一空行以对其
        [strForSolorDay insertString:@" " atIndex:0];
        
    }else if(worldHoliday != NULL){
        [strForSolorDay appendString:worldHoliday];
        //增加一空行以对其
        if(![[strForSolorDay substringWithRange:NSMakeRange(0, 1)] isEqualToString:@" "]){
            [strForSolorDay insertString:@" " atIndex:0];
        }
    }else{
    }
    
    return strForSolorDay;
}


+ (NSString *)actionForKeyStrWithMonth:(int )month
                                   day:(int )day {
   
    NSString *keyStr = @"";
    NSString *dayStr = @"";
    NSString *monthStr = @"";
  
    if (month < 10) {
        monthStr = [NSString stringWithFormat:@"0%d",month];
    }else{
        monthStr = [NSString stringWithFormat:@"%d",month];
    }
    
    if (day < 10) {
        dayStr = [NSString stringWithFormat:@"0%d",day];
    }else{
        dayStr = [NSString stringWithFormat:@"%d",day];
    }

    keyStr = [NSString stringWithFormat:@"%@%@",monthStr,dayStr];
    return keyStr;
    
}


+ (int)actionForChangeDic:(int )tag
             changeNumber:(int )number {
   
    switch (tag) {
        case 0:
            
            return 100 + number;
            break;
            
        case 1:
            
            return 200 + number;
            break;
            
        case 2:
            
            return 300 + number;
            break;
            
        case 3:
            
            return 400 + number;
            break;
            
        case 4:
            
            return 500 + number;
            break;
            
        case 5:
            
            return 600 + number;
            break;
            
        default:
            
            return 0;
            break;
    }

}


#pragma mark 有关UTC方面




@end
