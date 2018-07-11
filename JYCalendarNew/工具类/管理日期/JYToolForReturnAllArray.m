//
//  JYToolForReturnAllArray.m
//  rilixiugai
//
//  Created by 吴冬 on 15/11/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYToolForReturnAllArray.h"

@implementation JYToolForReturnAllArray

+ (NSArray *)actionForReturnArrayWithYear:(int )year
                                    month:(int )month
                                      day:(int )day
                                 isNowArr:(BOOL)isNow
                       
{
    NSMutableArray *arrForReturn = [NSMutableArray arrayWithCapacity:7];
 
    //当前月
    int nowYear = year;
    int nowMonth = month;
    
    //上个月
    int beforeYear = year;
    int beforeMonth = month;
    beforeMonth--;
    if (beforeMonth <=0) {
        
        beforeMonth = 12;
        beforeYear--;
    }
    
    //下个月
    int nextYear = year;
    int nextMonth = month;
    nextMonth++;
    if (nextMonth > 12) {
        
        nextMonth = 1;
        nextYear ++;
    }
    
    
    //上个月总天数
    NSInteger beforeManayDay = [JYToolForCalendar actionForNowManyDayWithMonth:beforeMonth year:beforeYear];
    
    //当前月总天数
    NSInteger nowManayDay = [JYToolForCalendar actionForNowManyDayWithMonth:nowMonth year:nowYear];
    
    //下个月总天数
    //NSInteger nextManayDay = [JYToolForCalendar actionForNowManyDayWithMonth:nextMonth year:nextYear];
    
    //判断当前月的1号在周几
    //周日 = 1 周一 = 2 ...周六 = 7
    //将周几转换为index
    NSDate *date = [JYToolForCalendar actionForReturnSelectedDateWithDay:1 Year:nowYear month:nowMonth];
    NSInteger weekNow  = [JYToolForCalendar actionForNowWeekUTC:date];
    
    
    if (weekNow == 1) {
        
        weekNow = 6;
        
    }else{
       
        weekNow -= 2;
    }
   
    int nowMonthChangeDay = 0;
    
    NSMutableDictionary *dicForMonth = [NSMutableDictionary  dictionaryWithCapacity:42];
    NSMutableDictionary *dicForYear = [NSMutableDictionary dictionaryWithCapacity:42];
    NSMutableDictionary *dicForDay = [NSMutableDictionary dictionaryWithCapacity:42];
    
    for (int i = 0; i < 6; i++) {
        
        NSMutableArray *arrForLineText = [NSMutableArray arrayWithCapacity:7];
        
        for (int j = 0; j < 7; j++) {
           
            NSInteger selectDay = 0;
            nowMonthChangeDay++;
            NSMutableAttributedString *strForText = nil;
            
            int key = [JYToolForCalendar actionForChangeDic:i changeNumber:j];
            //上个月
            if (nowMonthChangeDay - weekNow <= 0) {
                
                selectDay = beforeManayDay - weekNow + nowMonthChangeDay;
                strForText = [JYToolForCalendar actionForReturnTextWithYear:beforeYear month:beforeMonth day:(int)selectDay notNowMonth:YES];
    
                [dicForMonth setObject:@(beforeMonth) forKey:@(key)];
                [dicForYear setObject:@(beforeYear) forKey:@(key)];
            }
            
            //这个月
            if (nowMonthChangeDay - weekNow <= nowManayDay && nowMonthChangeDay - weekNow > 0) {
                
                selectDay = nowMonthChangeDay - weekNow ;
                strForText = [JYToolForCalendar actionForReturnTextWithYear:nowYear month:nowMonth day:(int )selectDay notNowMonth:NO];
           
                [dicForMonth setObject:@(nowMonth) forKey:@(key)];
                [dicForYear setObject:@(nowYear) forKey:@(key)];
                
                //确定今天的tag值
                JYSelectManager *manager = [JYSelectManager shareSelectManager];
                if (selectDay == manager.g_notChangeDay && nowMonth == manager.g_notChangeMonth && nowYear == manager.g_notChangeYear) {
       
                    manager.todayTag = j + (i + 1) * 100;
                    
                }
                
                //确定选中的tag值
                if (selectDay == day && isNow) {
                    
                    manager.selectTag = j + (i + 1) * 100;
                }
                
                                
            }
            
            //下个月
            if (nowMonthChangeDay - weekNow > nowManayDay) {
                
                selectDay = nowMonthChangeDay - nowManayDay - weekNow;
                strForText = [JYToolForCalendar actionForReturnTextWithYear:nextYear month:nextMonth day:(int )selectDay notNowMonth:YES];
                
                [dicForMonth setObject:@(nextMonth) forKey:@(key)];
                [dicForYear setObject:@(nextYear) forKey:@(key)];
            }
    
            [dicForDay setObject:@(selectDay) forKey:@(key)];
            [arrForLineText addObject:strForText];

        }
        
        [arrForReturn addObject:arrForLineText];
    }
    
//******************************
    
    if (isNow) {
        
        //将月份赋值
        JYSelectManager *manager = [JYSelectManager shareSelectManager];
        
        manager.nowMonth = nowMonth;
        
       // NSLog(@"%d",nowMonth);
        
        manager.dicForAllMonth = [NSDictionary dictionaryWithDictionary:dicForMonth];
        manager.dicForAllYear = [NSDictionary dictionaryWithDictionary:dicForYear];
        manager.dicForAllDay = [NSDictionary dictionaryWithDictionary:dicForDay];
 
    }

    return arrForReturn;

}




@end
