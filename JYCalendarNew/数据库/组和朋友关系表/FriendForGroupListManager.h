//
//  FriendForGroupListManager.h
//  groupListManager
//
//  Created by 吴冬 on 15/12/8.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface FriendForGroupListManager : NSObject

+ (FriendForGroupListManager *)shareFriendGroup;



/**
 *  删除组
 */
- (BOOL )deleteAllDateWithGid:(NSInteger )gid;

/**
 *  删除单条数据
 */
- (BOOL)deleteDataWithGid:(NSInteger )gid fid:(NSInteger )fid;

/**
 *  删除全部数据
 */
- (BOOL)deleteAllData;

/**
 *  插入数据
 */
- (BOOL)insertDataWithGid:(NSInteger )gid
                      fid:(NSInteger )fid;


/**
 *  查询当前组下所有用户fid
 */
- (NSArray *)selectDataWithGid:(NSInteger )gid;

/**
 *  群组名称是否已存在
 */
- (BOOL)ifGroupNameHasExist:(NSString *)groupName;

@end
