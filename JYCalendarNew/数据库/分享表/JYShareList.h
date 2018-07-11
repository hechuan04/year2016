//
//  JYShareList.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYShareList : NSObject

+ (JYShareList *)shareList;

- (BOOL)insertRemindModel:(RemindModel *)model
                   fidStr:(NSString *)fidStr
                   gidStr:(NSString *)gidStr
                      mid:(int )mid;

//更新状态
- (BOOL)upDataWithModel:(RemindModel *)model;


/**
 *  删除全部
 */
- (BOOL)deleteAllData;

/**
 *  全部
 */
- (NSArray *)selectModel;

/**
 *  删除
 */
- (BOOL)deleteActionWithModel:(RemindModel *)model;

/**
 *  模糊查询分享列表
 */
- (NSArray *)searchWithStr:(NSString *)str;

/**
 *  收藏专用
 */
- (int )selectMidWithSid:(int )sid;

@end
