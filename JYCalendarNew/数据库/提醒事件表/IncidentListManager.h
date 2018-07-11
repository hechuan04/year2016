//
//  IncidentListManager.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface IncidentListManager : NSObject

+ (IncidentListManager *)shareIncidentManager;


/**
 *    插入数据
 */
- (BOOL)insertDataWithremindModel:(RemindModel *)model;




/**
 *  删除数据
 */
- (BOOL)deleteDataWithUid:(int )uid
                    ownId:(int )oid
                 existUid:(BOOL)exist;


/**
 *  更改数据
 */
- (BOOL)upDataWithModel:(RemindModel *)model;


/**
 *  模糊查询
 */
- (NSArray *)searchWithStr:(NSString *)str;

/**
 *  查询数据，返回所有model
 */
//- (NSArray *)selectAllData;

/**
 *  删除所有数据
 */
- (BOOL)deleteAllData;


/**
 *  全部置为0
 */
- (BOOL)upDataWithModelAll;


@end
