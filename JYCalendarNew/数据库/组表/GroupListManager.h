//
//  GroupListManager.h
//  groupListManager
//
//  Created by 吴冬 on 15/12/7.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GroupModel.h"
@interface GroupListManager : NSObject

+ (GroupListManager *)shareGroup;

/**
 *  插入数据，根据小秘号存入组中
 */
- (BOOL)insertDataWithGid:(NSInteger )gid
                groupName:(NSString *)group_name
              groupHeaderUrl:(NSString *)group_header;


/**
 *  删除数据
 */
- (BOOL)deleteDataWithFid:(NSInteger )gid;


/**
 *  清空表
 */
- (BOOL)deleteAllData;

/**
 *  更新数据（组名,头像）
 */
- (BOOL)upDateWithGid:(NSInteger )gid
            groupName:(NSString *)group_name
          groupHeaderUrl:(NSString *)group_header;


#pragma mark 查询所有数据
/**
 *  查询所有数据
 */
- (NSArray *)selectAllData;

/**
 *  根据GID查询单条MODEL
 */
- (GroupModel *)selectDataWithGid:(NSInteger)gid;

@end
