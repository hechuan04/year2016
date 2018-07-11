//
//  FriendForGroupListManager.m
//  groupListManager
//
//  Created by 吴冬 on 15/12/8.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "FriendForGroupListManager.h"

#define kFriendForG @"saveFriendForG"

static FriendForGroupListManager *friendForGroupManager = nil;

@implementation FriendForGroupListManager

+ (FriendForGroupListManager *)shareFriendGroup
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (friendForGroupManager == nil) {
            
            friendForGroupManager = [[FriendForGroupListManager alloc ] init];
            
        }
        
    });

    return friendForGroupManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        friendForGroupManager = [super allocWithZone:zone];
        
    });
    
    return friendForGroupManager;
}


#pragma mark 插入数据
- (BOOL)insertDataWithGid:(NSInteger )gid
                      fid:(NSInteger )fid
{

    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlInsert = [NSString stringWithFormat:@"insert into %@(gid,fid) values ('%ld','%ld')",kFriendForG,(long)gid,(long)fid];
        
        char *err;
        
        int result = sqlite3_exec(data.dataBase, [sqlInsert UTF8String], NULL, NULL, &err);
        
        if (result != SQLITE_OK) {
                        
            return NO;
        }
        
        sqlite3_close(data.dataBase);
        
        return YES;

    }else{
     
        return NO;
    }
    
}

#pragma mark 删除数据
- (BOOL)deleteDataWithGid:(NSInteger )gid fid:(NSInteger )fid{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where gid = '%ld' and fid = '%ld'",kFriendForG,(long)gid,(long)fid];
        sqlite3_stmt *stmt = nil;
        int result = sqlite3_prepare_v2(data.dataBase, [sqlDelete UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW){
                
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    
                    sqlite3_finalize(stmt);
                    sqlite3_close(data.dataBase);
                    
                    return YES;
                }
                
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return NO;

    }else{
     
        return NO;
    }
    
   
}

#pragma mark 清表
- (BOOL)deleteAllData
{
  
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        
        char *sql = "delete from saveFriendForG";
        sqlite3_stmt *stmt = nil;
        int result = sqlite3_prepare_v2(data.dataBase,sql, -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW){
                
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    
                    sqlite3_finalize(stmt);
                    sqlite3_close(data.dataBase);
                    
                    return YES;
                }
                
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return NO;
        

    }else{
    
        return NO;
    }
    
    
}

#pragma mark 修改数据
- (BOOL )deleteAllDateWithGid:(NSInteger )gid
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        
        NSString *sqlDelete = [NSString stringWithFormat:@"delete from %@ where gid = '%ld'",kFriendForG,(long)gid];
        sqlite3_stmt *stmt = nil;
        int result = sqlite3_prepare_v2(data.dataBase, [sqlDelete UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW){
                
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    
                    sqlite3_finalize(stmt);
                    sqlite3_close(data.dataBase);
                    
                    return YES;
                }
                
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return NO;
    }else{
     
        return NO;
    }
    
 
    
}

#pragma mark 查询数据
- (NSArray *)selectDataWithGid:(NSInteger )gid
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE gid = '%ld'",kFriendForG,(long)gid];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
        NSMutableArray *arrForFid = [NSMutableArray array];
        
        if (result == SQLITE_OK) {
            
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                int fid = (int )sqlite3_column_int(stmt, 2);
                
                
                [arrForFid addObject:@(fid)];
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return arrForFid;

    }else{
     
        return nil;
    }

}

- (BOOL)ifGroupNameHasExist:(NSString *)groupName
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
     int count = 0;
    if ([data openDB]) {
        
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT count(*) FROM saveGroup WHERE group_name = '%@'",groupName];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
       
        if (result == SQLITE_OK) {
            if(sqlite3_step(stmt) == SQLITE_ROW) {
                count = (int )sqlite3_column_int(stmt, 0);
            }
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
    }
    return (count>0);
}
@end
