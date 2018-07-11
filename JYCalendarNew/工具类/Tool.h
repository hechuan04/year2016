//
//  Tool.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemindModel.h"
#import <UIKit/UIKit.h>


typedef NS_ENUM(int , typeForRemind){
    
    acceptType = 0,
    sendType = 1,
    shareType = 2,
    selfType = 3,
    
    
    
};

@interface Tool : NSObject


/**
 *  待办页左边方块内时间
 */
+ (NSString *)countDownStrWithModelTime:(RemindModel *)model;

/**
 *  待办页待办列表底部时间
 */
+ (NSString *)countDownStrWithModel:(RemindModel *)model;



/**
 *  算今天的日期
 *
 *  @return 如：2015年9月
 */
+ (NSString *)actionForNowDate;

/**
 *  返回当前的小时
 */
+ (NSString *)actionforNowHour;

/**
 *  返回当前分钟
 */
+ (NSString *)actionforNowMinute;

/**
 *  返回当前秒数
 */
+ (NSString *)actionForNowSecond;

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
 *  根据日期计算周几
 */
+ (NSInteger)actionForNowWeek:(NSDate *)inputDate;

/**
 *  当月天数
 */
+ (NSInteger )actionForNowManyDay:(NSInteger )monthNow year:(NSInteger )yearNow ;


/**
 *  根据年月日返回日期
 *
 *  @param day
 *  @param year
 *  @param month
 *
 *  @return date
 */
+ (NSDate *)actionForReturnSelectedDateWithDay:(NSInteger )day
                                          Year:(NSInteger )year
                                         month:(NSInteger )month;

/**
 *  返回精确的时间
 */
+ (NSDate *)actionForReturnSelectedDateWithDay:(NSInteger)day
                                          Year:(NSInteger)year
                                         month:(NSInteger)month
                                          hour:(NSInteger)hour
                                        minute:(NSInteger)minute;

/**
 *  返回俩个数组，0为未完成，1为完成的数组
 */
+ (NSArray *)actionForReturnAlreadyAndAwaitArray;

/**
 *  算当天的完成和未完成任务
 *
 *  @param arrForToday
 *
 *  @return 
 */
+ (NSDictionary *)actionForReturnTodayRemind:(NSArray *)arrForToday;

/**
 *  判断时间前后,传入选中时间，选中时间大为YES
 */
+ (BOOL)isAlreadyNowYear:(int )year
                   month:(int )month
                     day:(int )day
                    hour:(int )hour
                  minute:(int )minute;


/**
 *  判断是否在这周
 */
+ (BOOL )actionForSelectWeek:(int )year
                       month:(int )month
                         day:(int )day
                  strForWeek:(int )randomWeek;


/**
 *  判断是否可以加入通知
 */
+ (RemindModel *)actionForIsNowRemind:(RemindModel *)model;


/**
 *  判断是否隐藏remind
 */
+ (BOOL )actionForIsHiddenRemindView:(RemindModel *)model;


/**
 *    判断当天是否有提醒
 */
+ (BOOL)actionForJudgement:(RemindModel *)model
                      year:(int )year
                     month:(int )month
                       day:(int )day;

/**
 *  重复的情况下，重新给提醒赋值年月日
 */
+ (RemindModel *)actionForRemindModel:(RemindModel *)model;


/**
 *  返回排序好的名字字典
 */
+ (NSDictionary *)actionForReturnNameDic:(NSArray *)arrForAllName;


/**
 *  将Key排序
 */
+ (NSArray *)actionForReturnAllKey:(NSArray *)arrForAllKey;


/**
 *  返回一个01这种类型的字符串
 */
+ (NSString *)actionForTenOrSingleWithNumber:(int )number;


/**
 *  返回星期字符串
 */
+ (NSString *)actionForWeekWithYear:(int )year
                              month:(int )month
                                day:(int )day;

+ (NSString *)actionForWeekWithYearAll:(int )year
                                 month:(int )month
                                   day:(int )day;

/**
 *  返回星期字符串(英文格式)
 */
+ (NSString *)actionForEnglishWeekWithYear:(int )year
                                     month:(int )month
                                       day:(int )day;
/**
 *  根据当前时间返回年月日
 */
+ (NSString *)actionForLunarWithYear:(int )year
                              month:(int )month
                                day:(int )day;


/**
 *  通过路径删除整个数据库
 */
+ (NSString *)filePathWithSqlName:(NSString *)name;



/**
 *  返回显示的
 */
+ (NSString *)actionForReturnRepeatStr:(RemindModel *)model;


/**
 *  隐藏多余的tb
 */
+ (void)actionForHiddenMuchTable:(UITableView *)tableView;



/**
 *  返回音乐名称
 */
+ (NSString *)actionForReturnMusicWithModel:(RemindModel *)model;


/**
 *  返回时间（上午、下午。。。）
 */
+ (NSString *)actionForListTimeStr:(NSString *)timeOrder
                              type:(int)type;

/**
 *  主页返回时间(考虑的是当前点击的时间)
 */
+ (NSString *)actionForListTimeZhuStr:(NSString *)create
                                 year:(int )year
                                month:(int )month
                                  day:(int )day
                             isAccept:(BOOL )isAccept;


//返回想要的图片分辨率
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize;


//返回左边按钮
+ (UIButton *)actionForReturnLeftBtnWithTarget:(id)delegate;


//判断字符串是否为空
+ (int )actionForReturnRightIntNumber:(NSString *)str;

//光晕
+ (void)actionForGuangyunimageView:(UIImageView *)imageView
                         superView:(UIImageView *)superView;


/**
 *  重新添加通知
 */
+ (void)actionForAddNotification;

/**
 *  升序排列
 */
+ (NSArray *)actionForAscending:(NSArray *)arr;


/**
 *  名字拼串
 */
+ (NSString *)actionForFriendStr:(NSString *)fidStr;

/**
 *  组拼串
 */
+ (NSString *)actionForGroupStr:(NSString *)gidStr;

/**
 *  收藏方法
 */
+ (void)actionForCollection:(id )__sheetWindow
                remindModel:(RemindModel *)_model;

//判断是否加红点<非通知>
+ (BOOL)actionForRandomIsBeforeNotNotification:(RemindModel *)model
                                          year:(int )year
                                         month:(int )month
                                           day:(int )day;

//判断当天是否有红点<非通知>
+ (BOOL)actionForJudgementAndNotNotification:(RemindModel *)model
                                        year:(int )year
                                       month:(int )month
                                         day:(int )day;


//转义方法
+ (NSString *)actionForTransferredMeaning:(NSString *)content;
//判断是否是我发送给别人的不包含我自己
+ (BOOL )isPastOtherRemind:(NSString *)fidStr gidStr:(NSString *)gidStr;

//时差问题
+ (void)actionForChangeModelAbsoluteTime:(RemindModel *)model;


//我  -->   别人
+ (void)loadPassOtherRemind:(NSArray *)arrForMe;
//别人 -->   我
+ (void)loadPassMeRemind:(NSArray *)arrForHe;
//我   --分享-->  别人
+ (void)loadShareOtherRemind:(NSArray *)arrForShareMe;
//别人 --分享--> 我
+ (void)loadShareMeRemind:(NSArray *)arrForShareHe;

+ (void)showAlter:(id)vc title:(NSString *)title;

//比较传入的时间与比较时间
+ (BOOL)compTime:(NSInteger )modelHour other:(NSInteger )modelMinute;

@end
