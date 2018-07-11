//
//  MusicListManager.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/6.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "MusicListManager.h"

static MusicListManager *manager = nil;

@implementation MusicListManager

+ (MusicListManager *)shareMusicListManager
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (manager == nil) {
            
            manager = [[MusicListManager alloc] init];
            
        }
        
    });
    
    return manager;
}


+ (id)allocWithZone:(struct _NSZone *)zone
{

 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (manager == nil) {
            
            manager = [super allocWithZone:zone];
            
        }
        
    });
    
    return manager;
}

#pragma mark 删除
- (BOOL)deleteDataWithModel:(RemindModel *)model
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from openList where mid = '%d'",model.uid];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
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

#pragma mark 插入数据
- (BOOL)insertDataWithModel:(RemindModel *)model
                  musicName:(int )musicName 
{
 
    XiaomiDB *data = [XiaomiDB  shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *strForXiaomi = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        
        // openList(ID INTEGER PRIMARY KEY AUTOINCREMENT ,mid int,status int, musicName int,int userID
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO openList(mid,status,musicName,userID) VALUES ('%d','%d','%d','%@')",model.uid,model.isOn,musicName,strForXiaomi];
    
        char *err;
        
        if (sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK ) {
            
            sqlite3_close(data.dataBase);

            return NO;
            
        }
        
        
        sqlite3_close(data.dataBase);
        
        return YES;
        
        
        
    }else{
     
        
        return NO;
    }
    
    
}


@end
