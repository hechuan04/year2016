//
//  JYToolForCalendar.h
//  rilixiugai
//
//  Created by 吴冬 on 15/11/25.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYWeatherView.h"

@interface JYToolForCalendar : NSObject

+ (NSInteger )actionForNowWeek:(NSDate *)inputDate;
+ (NSInteger )actionForNowWeekUTC:(NSDate *)inputDate;



+ (NSDate *)actionForReturnSelectedDateWithDay:(NSInteger)day
                                          Year:(NSInteger)year
                                         month:(NSInteger)month;

/**
 *  当月天数
 */
+ (NSInteger )actionForNowManyDayWithMonth:(NSInteger )monthNow
                             year:(NSInteger )yearNow;

/**
 *  返回当天日期
 *
 *  @param date
 *
 *  @return 如13号
 */
+ (NSString *)actionForNowSingleDay:(NSDate *)date;

/**
 *  算当前月份
 */
+ (NSString *)actionForNowMonth:(NSDate *)date;

/**
 *  当前年份
 */
+ (NSString *)actionForNowYear:(NSDate *)date;


/**
 *  返回想要的年月日
 */
+ (NSDictionary *)actionForReturnYear:(int )year
                                month:(int )month
                                  day:(int )day
                             isBefore:(BOOL)isBefore;

/**
 *  返回label显示的字符串
 */
+ (NSMutableAttributedString *)actionForReturnTextWithYear:(int )year
                                                     month:(int )month
                                                       day:(int )day
                                               notNowMonth:(BOOL)notNowMonth;



/**
 *  是否大于10
 */
+ (NSString *)actionForKeyStrWithMonth:(int )month
                                   day:(int )day;


/**
 *  返回对应tag 如101 ，102...
 */
+ (int)actionForChangeDic:(int )tag changeNumber:(int )number;


+ (NSMutableAttributedString *)attributedString:(NSString *)contentStr
                                           font:(UIFont *)font
                                          color:(UIColor *)color
                                          alpha:(CGFloat )alpha;

/**
 *  选中天数的假期 按旧方法简单修改的
 */
+ (NSString *)actionForReturnFestialWithYear:(int)year
                                       month:(int)month
                                         day:(int)day;
@end
