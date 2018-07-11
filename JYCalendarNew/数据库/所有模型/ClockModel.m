//
//  ClockModel.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ClockModel.h"

@implementation ClockModel

- (void)convertTimeToGMT
{
    //优先调用
    [self convertWeekRepeatToGMT];
    
    NSDateComponents *localDateComponents = [[NSDateComponents alloc] init];
    localDateComponents.year = _year;
    localDateComponents.month = _month;
    localDateComponents.day = _day;
    localDateComponents.hour = _hour;
    localDateComponents.minute = _minute;
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateFromComponents:localDateComponents];
    
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateComponents *gmtDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    
    _year = (int)gmtDateComponents.year;
    _month = (int)gmtDateComponents.month;
    _day = (int)gmtDateComponents.day;
    _hour = (int)gmtDateComponents.hour;
    _minute = (int)gmtDateComponents.minute;
//    int second = (int)gmtDateComponents.second;
//    _timeOrder = [NSString stringWithFormat:@"%d%2d%2d%2d%2d%2d",_year,_month,_day,_hour,_minute,second];
    
}

- (void)convertTimeToLocal
{
    [self convertWeekRepeatToLocal];
    
    NSDateComponents *gmtDateComponents = [[NSDateComponents alloc] init];
    gmtDateComponents.year = _year;
    gmtDateComponents.month = _month;
    gmtDateComponents.day = _day;
    gmtDateComponents.hour = _hour;
    gmtDateComponents.minute = _minute;
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [calendar dateFromComponents:gmtDateComponents];
    
    calendar.timeZone = [NSTimeZone localTimeZone];
    NSDateComponents *localDateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
    
    _year = (int)localDateComponents.year;
    _month = (int)localDateComponents.month;
    _day = (int)localDateComponents.day;
    _hour = (int)localDateComponents.hour;
    _minute = (int)localDateComponents.minute;
//    int second = (int)gmtDateComponents.second;
//    _timeOrder = [NSString stringWithFormat:@"%d%2d%2d%2d%2d%2d",_year,_month,_day,_hour,_minute,second];
}

- (void)convertWeekRepeatToGMT
{
    if([_timeDescribe isEqualToString:@"每天"]){
        return;
    }
    
    //重复
    if(_week.length>0){
        NSArray *weeks = [_week componentsSeparatedByString:@","];
        NSMutableArray *convertWeeks = [NSMutableArray arrayWithCapacity:7];
        NSMutableArray *convertWeekStrs = [NSMutableArray arrayWithCapacity:7];
        for(int i=0; i<[weeks count]; i++){
            if([weeks[i] length]>0){
                
                NSInteger week = [weeks[i] integerValue];
                NSInteger timeZoneOffset = [[NSTimeZone localTimeZone] secondsFromGMT]/3600;
                NSInteger convertWeek = week;
                if(_hour-timeZoneOffset<0){
                    convertWeek = week - 1;
                    convertWeek = convertWeek<0?convertWeek+7:convertWeek;
                }else if(_hour-timeZoneOffset>=24){
                    convertWeek = week + 1;
                    convertWeek = convertWeek>6?convertWeek-7:convertWeek;
                }
                
                [convertWeeks addObject:[NSString stringWithFormat:@"%ld",convertWeek]];
                switch (convertWeek) {
                    case 0:{
                        [convertWeekStrs addObject:@"每周一"];
                    }
                        break;
                    case 1:{
                        [convertWeekStrs addObject:@"每周二"];
                    }
                        break;
                    case 2:{
                        [convertWeekStrs addObject:@"每周三"];
                    }
                        break;
                    case 3:{
                        [convertWeekStrs addObject:@"每周四"];
                    }
                        break;
                    case 4:{
                        [convertWeekStrs addObject:@"每周五"];
                    }
                        break;
                    case 5:{
                        [convertWeekStrs addObject:@"每周六"];
                    }
                        break;
                    case 6:{
                        [convertWeekStrs addObject:@"每周日"];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        _week = [convertWeeks componentsJoinedByString:@","];
        _timeDescribe = [convertWeekStrs componentsJoinedByString:@","];
    }
}

//此方法优先调用
- (void)convertWeekRepeatToLocal
{
    if([_timeDescribe isEqualToString:@"每天"]){
        return;
    }
    //重复
    if(_week.length>0){
        NSArray *weeks = [_week componentsSeparatedByString:@","];
        NSMutableArray *convertWeeks = [NSMutableArray arrayWithCapacity:7];
        NSMutableArray *convertWeekStrs = [NSMutableArray arrayWithCapacity:7];
        for(int i=0; i<[weeks count]; i++){
            if([weeks[i] length]>0){
                
                NSInteger week = [weeks[i] integerValue];
                NSInteger timeZoneOffset = [[NSTimeZone localTimeZone] secondsFromGMT]/3600;
                NSInteger convertWeek = week;
                if(_hour+timeZoneOffset>=24){
                    convertWeek = week + 1;
                    convertWeek = convertWeek>6?convertWeek-7:convertWeek;
                }else if(_hour+timeZoneOffset<0){
                    convertWeek = week - 1;
                    convertWeek = convertWeek<0?convertWeek+7:convertWeek;
                }
                
                [convertWeeks addObject:[NSString stringWithFormat:@"%ld",convertWeek]];
                switch (convertWeek) {
                    case 0:{
                        [convertWeekStrs addObject:@"每周一"];
                    }
                        break;
                    case 1:{
                        [convertWeekStrs addObject:@"每周二"];
                    }
                        break;
                    case 2:{
                        [convertWeekStrs addObject:@"每周三"];
                    }
                        break;
                    case 3:{
                        [convertWeekStrs addObject:@"每周四"];
                    }
                        break;
                    case 4:{
                        [convertWeekStrs addObject:@"每周五"];
                    }
                        break;
                    case 5:{
                        [convertWeekStrs addObject:@"每周六"];
                    }
                        break;
                    case 6:{
                        [convertWeekStrs addObject:@"每周日"];
                    }
                        break;
                    default:
                        break;
                }
            }
        }
        _week = [convertWeeks componentsJoinedByString:@","];
        _timeDescribe = [convertWeekStrs componentsJoinedByString:@","];
    }
}
@end
