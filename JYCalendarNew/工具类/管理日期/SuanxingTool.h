//
//  SuanxingTool.h
//  LiuNianYunCheng
//
//  Created by 吴冬 on 15/8/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SuanxingTool : NSObject


/**
 *  工具方法，算命宫位置
 *
 *  @param month 月份
 *  @param hours 时辰
 *
 *  @return 返回命宫位置，以巳为起点开始算起
 */
+ (NSString *)minggongWithMonth:(NSInteger )month
                       andHours:(NSInteger )hours;



/**
 *  工具方法，定五行局
 *
 *  定五行局《出生年份的天干 配合 命宫地支》
 *
 *  @param mdz        地支
 *  @param chnytg     天干
 *  @param yinyangSTR 阴阳
 *
 *  @return 五行局
 */
+ (NSString * )wuxingjuDizhi:(NSString * ) mdz
                     tiangan:(NSString *)chnytg
                 withYINYANG:(NSString *)yinyangSTR;


/**
 *  算阳历年
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *  @param hours 时辰
 *
 *  @return 返回阳历的具体出生日期（阳历：2005年12月23日08时）
 */
+ (NSString *)returnActionForBornWithYear:(NSInteger)year
                                 andMonth:(NSInteger)month
                                   andDay:(NSInteger)day
                                 andHours:(NSInteger )hours;


/**
 *  获取设备型号
 *
 *  @return 返回设备型号
 */
+ (NSString *)getCurrentDeviceModel;

/**
 *  返回五行
 *
 *  @param mTgDz 壬申
 *
 *  @return 返回五行字符串
 */
- (NSString *)suanMinChuanMtgdz:(NSString * )mTgDz and:(NSString * )chushengnuanyueYangli;

/**
 *  阳历转阴历
 *
 *  阳历
 *  @param year  年份
 *  @param month 月份
 *  @param day   日期
 *  @param hours 时辰
 *
 *  @return 返回一个阴历字符串
 */
- (NSString *)turnActionWithYear:(NSInteger )year
                        andMonth:(NSInteger )month
                          andDay:(NSInteger )day
                        andHours:(NSInteger )hours;


@end
