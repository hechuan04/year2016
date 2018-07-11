//
//  JYRemindViewController+ActionForRemind.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindViewController.h"

@interface JYRemindViewController (ActionForRemind)

//选日期方法
- (void)calendarAction;

//选择是否重复
- (void)repeatAction;

//声音选择按钮
- (void)musicAction;

//选择提醒对象
- (void)remindPeopleAction;

//是否打开
- (void)openAction:(UISwitch *)sender;


- (void)lunarActionForLunar;
- (Solar *)solorAction;
@end
