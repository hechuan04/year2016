//
//  LocalListManager.h
//  groupListManager
//
//  Created by 吴冬 on 15/12/22.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "RemindModel.h"
@interface LocalListManager : NSObject

+ (LocalListManager *)shareLocalListManager;


/**
 *  删除一条数据
 */
- (BOOL)deleteDataWithUid:(int )uid;


/**
 *  增加一条数据
 */
//- (BOOL)insertDataWithremindModel:(RemindModel *)model usersID:(int )userID;

/**
 *  模糊查询(发送)数据
 */
- (NSArray *)searchLocalDataWithText:(NSString *)text;

/**
 *  模糊查询(全部)数据
 */
- (NSArray *)searchAllDataWithText:(NSString *)text;

//模糊查询content 
- (NSArray *)searchDateWithContentStr:(NSString *)str;

/**
 *  查询所有数据
 */
- (NSArray *)selectAllDataWithUserID:(int )userID;

/**
 *  模糊查询所有待提醒数据
 */
- (NSDictionary *)searchAllDataWithTextNotYet:(NSString *)text;

/**
 *  更改一条数据
 */
- (BOOL)upDataWithModel:(RemindModel *)model;


/**
 *  查询所有本地数据
 */
- (NSArray *)selectAllLocalDataWithUserID:(int )userID;

/**
 *  刷新提醒列表tab角标
 */
- (void)refreshNumberLabelForAllRemind;


//返回字典的key
#define kUnreadShareKey @"kUnreadShareKey"
#define kUnreadAcceptKey @"kUnreadAcceptKey"
#define kUnreadSystemKey @"kUnreadSystemKey"
#define kUnreadAllKey @"kUnreadAllKey"

/**
 *  获取提醒列表未读数
 */
- (NSDictionary *)getUnreadRemindData;


/**
 *  删除本地语音文件
 *
 *  @param mid 路径拼串
 */
- (void)deleteLocalAudioFileWithPathStr:(NSString *)pathStr;
@end
