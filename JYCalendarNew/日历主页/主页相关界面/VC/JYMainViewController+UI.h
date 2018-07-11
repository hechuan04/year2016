//
//  JYMainViewController+UI.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/5.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYMainViewController.h"

//无提醒高度
#define kHeightForNoRemind 207 / 1334.0 * kScreenHeight

@interface JYMainViewController (UI)

//设置导航栏
- (void)actionForNavType;

//设置UI
- (void)setUI;

//设置星期
- (void)createWeekView;

//创建日历
- (void)createCalendarView;

//创建天气页面
- (void)createWeatherView;

//创建提醒页面
- (void)createRemindView;

//创建没有提醒时候的页面
- (void)createNotRemind;

//换肤改变闹钟颜色
- (void)changeLeftBtn;

//改变add按钮颜色
- (void)changeRightBtn;

/**
 *  跳转方法，跳转到选中的月份
 */
- (void)actionForTurnSelectViewWithModel:(RemindModel *)model
                                   isTop:(BOOL)isTop
;

@end
