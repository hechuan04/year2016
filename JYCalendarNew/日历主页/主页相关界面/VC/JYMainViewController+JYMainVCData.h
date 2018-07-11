//
//  JYMainViewController+JYMainVCData.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYMainViewController.h"

@interface JYMainViewController (JYMainVCData)<JYRemindViewControllerDelegate>

#pragma mark 当删除或者更新数据的时候，调用此方法更新页面
- (void)actionForloadData:(RemindModel *)model;

#pragma mark 初始化通讯录方法
- (void)actionForAddress;

#pragma mark 插入数据方法
- (void)passModel:(RemindModel *)model remindOther:(BOOL)isOther;

#pragma mark 初始化年月日数据
- (void)actionForDate;

@end
