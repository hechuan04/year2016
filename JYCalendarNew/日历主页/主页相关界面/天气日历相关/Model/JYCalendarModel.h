//
//  JYCalendarModel.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/3.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JYDateOrder){
    JYDateOrderBeforeToday = 0,
    JYDateOrderEqualToday,
    JYDateOrderAfterToday
};

@interface JYCalendarModel : NSObject

@property (nonatomic,readonly) NSInteger year;         //eg:2016
@property (nonatomic,readonly) NSInteger month;        //eg:1
@property (nonatomic,readonly) NSInteger day;          //eg:1
@property (nonatomic,readonly) NSInteger hour;         //eg:15
@property (nonatomic,readonly) NSInteger minute;       //eg:34
@property (nonatomic,readonly) NSInteger second;       //eg:43
@property (nonatomic,readonly) NSString  *weekEnString;//周英文:Sunday
@property (nonatomic,readonly) NSString  *weekCNString;//周中文:星期日
@property (nonatomic,readonly) NSString  *festival;    //节日
@property (nonatomic,readonly) NSString  *lunarYear;  //农历年
@property (nonatomic,readonly) NSString  *lunarMonth;  //农历月
@property (nonatomic,readonly) NSString  *lunarDay;    //农历日
@property (nonatomic,readonly) BOOL isLeap;//是否闰月
@property (nonatomic,readonly) NSString  *era;         //干支
@property (nonatomic,readonly) NSString  *eraYear;     //年干支
@property (nonatomic,readonly) NSString  *eraMonth;    //月干支
@property (nonatomic,readonly) NSString  *eraDay;      //日干支
@property (nonatomic,readonly) NSString  *eraHour;     //时干支(初始化参数日期中时间准确才有意义)
@property (nonatomic,readonly) NSString  *zodia;       //生肖
@property (nonatomic,readonly) NSString  *niceToDo;    //宜
@property (nonatomic,readonly) NSString  *badToDo;     //忌
@property (nonatomic,readonly) NSString  *foDay;       //佛历
@property (nonatomic,readonly) JYDateOrder dateOrder;  //日期与今日比较，是之前之后还是相等

//可赋值
@property (nonatomic,strong) NSDate *date;


//属性基本都是只读的，根据给定日期初始化后即可使用
- (instancetype)initWithDate:(NSDate *)date;

- (instancetype)initWithYear:(NSInteger)year
                       month:(NSInteger)month
                         day:(NSInteger)day;

- (instancetype)initWithYear:(NSInteger)year
                       month:(NSInteger)month
                         day:(NSInteger)day
                        hour:(NSInteger)hour;

/**
 *  返回指定格式date字符串
 *
 *  @param dateFormat 格式字符串
 *
 *  @return 指定格式的date字符串
 */
- (NSString *)dateStringWithFormat:(NSString *)dateFormat;

@end
