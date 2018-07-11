//
//  FriendListManager.h
//  groupListManager
//
//  Created by 吴冬 on 15/12/7.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "FriendModel.h"
@interface FriendListManager : NSObject

+ (FriendListManager *)shareFriend;

/**
 *  插入数据
 */
- (BOOL)insertDataWithName:(NSString *)friend_name
                       fid:(NSInteger )fid
                   headUrl:(NSString *)head_url
                    status:(int )status
                 telIPhone:(NSString *)tel_iphone
                 keyStatus:(int )keyStatus
                remarkName:(NSString *)remarkName
                      city:(NSString *)city
                      sign:(NSString *)sign;

/**
 *  根据小秘号删除好友
 */
- (BOOL)deleDataWithFid:(NSInteger )fid;


/**
 *  根据小秘号更改好友
 */
- (BOOL )upDateWithFid:(NSInteger )fid
            friendName:(NSString *)friend_name
               headUrl:(NSString *)head_url
                status:(int )status
             telIPhone:(NSInteger )tel_iphone
             keyStatus:(int )keyStatus
            remarkName:(NSString *)remarkName;


- (BOOL)updateRemarkName:(NSString *)remark
                 withFid:(NSInteger)fid;
/**
 *  根据fid查询用户
 */
- (FriendModel *)selectDataWithFid:(NSInteger )fid;

/**
 *  查询所有用户
 */
- (NSArray *)selectAllData;

/**
 *  删除所有数据
 */
- (BOOL)deleAllData;

@end
