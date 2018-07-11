//
//  JYMainViewController+Action.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/5.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYMainViewController.h"
#import "JYMainViewController+JYMainVCData.h"

@interface JYMainViewController (Action)

//点击cell push出选择时间页面
- (void)actionForAlreadyPush;
- (void)actionForAwaitPush;

//新建提醒方法
- (void)addNewRemind;

//是否是第一次登录
- (void)actionForFirstEnter;

//跳转便签
- (void)showNoteList:(UIButton *)sender;
@end
