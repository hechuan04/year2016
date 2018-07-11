//
//  FriendListManager.m
//  groupListManager
//
//  Created by 吴冬 on 15/12/7.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "FriendListManager.h"
#import "FriendModel.h"

static FriendListManager *friendManager = nil;

@implementation FriendListManager

+ (FriendListManager *)shareFriend{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (friendManager == nil) {
            
            friendManager = [[FriendListManager alloc] init];

        }
  
    });
  
    return friendManager;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        friendManager = [super allocWithZone:zone];
        
    });
    
    return friendManager;
    
}






#pragma mark 插入数据
- (BOOL)insertDataWithName:(NSString *)friend_name
                       fid:(NSInteger )fid
                   headUrl:(NSString *)head_url
                    status:(int )status
                 telIPhone:(NSString *)tel_iphone
                 keyStatus:(int)keyStatus
                 remarkName:(NSString *)remarkName
                      city:(NSString *)city
                      sign:(NSString *)sign
{
  
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    friend_name = [friend_name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    remarkName = [remarkName stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    city = [city stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    sign = [sign stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO saveFriend(fid,friend_name,head_url,status,tel_iphone ,keyStatus,remark_name,city,sign) VALUES ('%ld','%@','%@','%d','%@','%d','%@','%@','%@')",(long)fid,friend_name,head_url,status,tel_iphone,keyStatus,remarkName,city,sign];
        
        char *err;
        
        if (sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
                        
            return NO;
        }
        
        sqlite3_close(data.dataBase);
        
        
        
        return YES;

    }else{
     
        return NO;
    }
    
    

}

#pragma mark 清空列表
- (BOOL)deleAllData
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        sqlite3_stmt *stmt = nil;
        
        char *sql = "delete from saveFriend";
        
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW) { //如果有删除这行
                
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
- (BOOL)deleDataWithFid:(NSInteger )fid
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        sqlite3_stmt *stmt = nil;
        
        NSString *sqlDele = [NSString stringWithFormat:@"delete from saveFriend where fid = '%ld'",(long)fid];
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlDele UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_ROW) { //如果有删除这行
                
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

    }else {
     
        
        return NO;
    }
    
   
    
}


#pragma mark 更改数据
- (BOOL )upDateWithFid:(NSInteger )fid
            friendName:(NSString *)friend_name
               headUrl:(NSString *)head_url
                status:(int )status
             telIPhone:(NSInteger )tel_iphone
             keyStatus:(int)keyStatus
            remarkName:(NSString *)remarkName
{

    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlChange = [NSString stringWithFormat:@"update saveFriend set friend_name = '%@',head_url = '%@',status = '%d', tel_iphone = '%ld' , keyStatus = '%d',remark_name='%@' where fid = '%ld'",friend_name,head_url,status,(long)tel_iphone,keyStatus,remarkName,(long)fid];
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlChange UTF8String], -1, &stmt, NULL);
        
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
- (BOOL)updateRemarkName:(NSString *)remark
                 withFid:(NSInteger)fid
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    remark = [remark stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    if ([data openDB]) {
        
        NSString *sqlChange = [NSString stringWithFormat:@"update saveFriend set remark_name='%@' where fid = '%ld'",remark,(long)fid];
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlChange UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
 
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForReloadRemark object:nil];
                });
                return YES;
            }
                    
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return NO;
        
    }else{
        
        return NO;
    }

}
#pragma mark 

#pragma mark 查询用户
- (FriendModel *)selectDataWithFid:(NSInteger)fid
{
    if (fid == 0) {
        return nil;
    }

    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        //ID INTEGER PRIMARY KEY AUTOINCREMENT,fid integer,friend_name text,head_url text,status int,tel_iphone text,keyStatus int
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM saveFriend WHERE fid = '%ld'",(long)fid];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
        FriendModel *model;
        if (result == SQLITE_OK) {
            
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                model = [[FriendModel alloc] init];
                
                int fid = sqlite3_column_int(stmt, 1);
                char *name = (char *)sqlite3_column_text(stmt, 2);
                char *headUrl = (char *)sqlite3_column_text(stmt, 3);
                int status = sqlite3_column_int(stmt, 4);
                char *tel_iphone = (char *)sqlite3_column_text(stmt, 5);
                int keyStatus = sqlite3_column_int(stmt, 6);
                char *remark = (char *)sqlite3_column_text(stmt, 7);
                char *city = (char *)sqlite3_column_text(stmt, 8);
                char *sign = (char *)sqlite3_column_text(stmt, 9);
                
                model.fid = (NSInteger )fid;
                model.friend_name = [NSString stringWithUTF8String:name];
                model.head_url = [NSString stringWithUTF8String:headUrl];
                model.status = status;
                model.tel_phone = [NSString stringWithUTF8String:tel_iphone];
                model.keystatus = keyStatus;
                model.remarkName = [NSString stringWithUTF8String:remark];
                model.local = [NSString stringWithUTF8String:city];
                model.sign = [NSString stringWithUTF8String:sign];
               // ID INTEGER PRIMARY KEY AUTOINCREMENT,fid integer,friend_name text,head_url text,status int,tel_iphone text,keyStatus int)
                
            }
            
            
        }
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        
        return model;

    }else{
     
        return nil;
    }
    
}


#pragma mark 查询所有用户
- (NSArray *)selectAllData{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    if ([data openDB]) {
        
        char *sql = "SELECT * FROM saveFriend";
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
        
        NSMutableArray *arr = [NSMutableArray array];
        
        if (result == SQLITE_OK) {

            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                FriendModel *model = [[FriendModel alloc] init];
                
                NSInteger fid = (NSInteger )sqlite3_column_int(stmt, 1);
                char *friendName = (char *)sqlite3_column_text(stmt, 2);
                char *headUrl = (char *)sqlite3_column_text(stmt, 3);
                int status = sqlite3_column_int(stmt, 4);
                char *tel_phone = (char *)sqlite3_column_text(stmt, 5);
                char *remark = (char *)sqlite3_column_text(stmt, 7);
                char *city = (char *)sqlite3_column_text(stmt, 8);
                char *sign = (char *)sqlite3_column_text(stmt, 9);
                
                model.fid = fid;
                model.friend_name = [NSString stringWithUTF8String:friendName];
                model.head_url = [NSString stringWithUTF8String:headUrl];
                model.status = status;
                model.tel_phone = [NSString stringWithUTF8String:tel_phone];
                model.remarkName = [NSString stringWithUTF8String:remark];
                model.local = [NSString stringWithUTF8String:city];
                model.sign = [NSString stringWithUTF8String:sign];
                [arr addObject:model];
                
                
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return arr;
        
    }else{
    
        return nil;
    }
    
}


@end
