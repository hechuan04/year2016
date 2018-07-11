//
//  GroupListManager.m
//  groupListManager
//
//  Created by 吴冬 on 15/12/7.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "GroupListManager.h"

static GroupListManager *groupManager = nil;
@implementation GroupListManager

+ (GroupListManager *)shareGroup
{
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (groupManager == nil) {
            
            groupManager = [[GroupListManager alloc] init];

        }
        
        
    });
    
    return groupManager;

}

+ (id)allocWithZone:(struct _NSZone *)zone
{
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        groupManager = [super allocWithZone:zone];
        
    });

    return groupManager;
}





#pragma mark 插入数据
- (BOOL)insertDataWithGid:(NSInteger )gid
                groupName:(NSString *)group_name
              groupHeaderUrl:(NSString *)group_header
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlInster = [NSString stringWithFormat:@"INSERT INTO saveGroup(gid,group_name,group_header) VALUES ('%ld','%@','%@')",(long)gid,group_name,group_header];
        
        char *err;
        
        int result = sqlite3_exec(data.dataBase, [sqlInster UTF8String], NULL, NULL, &err);
        
        if (result != SQLITE_OK) {
            
            
            return NO;
        }
        
    
        sqlite3_close(data.dataBase);
        
        return YES;
        

    }else{
     
        return NO;
    }
    
}

#pragma mark 删除所有数据
- (BOOL)deleteAllData
{

    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        char *sql = "delete from saveGroup";
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                
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


#pragma mark 删除数据
- (BOOL)deleteDataWithFid:(NSInteger )gid
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlDelete = [NSString stringWithFormat:@"delete  from saveGroup where gid = '%ld'",(long)gid];
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlDelete UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                
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

#pragma mark 更新
- (BOOL)upDateWithGid:(NSInteger )gid
            groupName:(NSString *)group_name
          groupHeaderUrl:(NSString *)group_header

{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlUpDate = [NSString stringWithFormat:@"update saveGroup set group_name = '%@' , group_header = '%@' where gid = %ld ",group_name,group_header,(long)gid];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlUpDate UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                
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

#pragma mark 查询所有数据
- (NSArray *)selectAllData
{
  
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
 
    
    if ([data openDB]) {
        
        char *sql = "SELECT id,group_name,gid,group_header FROM saveGroup";
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
        
        NSMutableArray *arr = [NSMutableArray array];
        
        if (result == SQLITE_OK) {
 
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
          
                GroupModel *model = [[GroupModel alloc] init];
                
                int oid = sqlite3_column_int(stmt, 0);
                char *groupName = (char *)sqlite3_column_text(stmt, 1);
                int gid = sqlite3_column_int(stmt, 2);
                char *groupHeaderUrl = (char *)sqlite3_column_text(stmt, 3);
                
                model.oid = oid;
                model.gid = gid;
                model.group_name = [NSString stringWithUTF8String:groupName];
                model.groupHeaderUrl = [NSString stringWithUTF8String:groupHeaderUrl];
                
                [arr addObject:model];
                
                
            }
            
        }
        
        sqlite3_close(data.dataBase);
        
        return arr;
        
    }else{
        
        return nil;
    }

}

#pragma 根据id查询组
- (GroupModel *)selectDataWithGid:(NSInteger)gid
{
    
    if (gid == 0) {
        return nil;
    }
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        if (gid == 0) {
            
            return nil;
        }
        

        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT id,group_name,gid,group_header FROM saveGroup WHERE gid = '%ld'",(long)gid];

        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
        
        GroupModel *model;
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                model = [[GroupModel alloc] init];
                
                char *name = (char *)sqlite3_column_text(stmt, 1);
                int gid = sqlite3_column_int(stmt, 2);
                char *group_header = (char *)sqlite3_column_text(stmt, 3);
                
                model.group_name = [NSString stringWithUTF8String:name];
                model.gid = gid;
                model.groupHeaderUrl = [NSString stringWithUTF8String:group_header];
                
            }
            
        }
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        return model;
        
    }else{
     
        return nil;
    }
    
 
}




@end
