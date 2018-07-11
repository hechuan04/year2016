//
//  CollectionList.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "CollectionList.h"

static CollectionList *collectionList = nil;

@implementation CollectionList

+ (CollectionList *)shareCollectionList
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (collectionList == nil) {
            
            
            collectionList = [[CollectionList alloc] init];
        }
        
    });
    
    return collectionList;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (collectionList == nil) {
            
            collectionList = [super allocWithZone:zone];
        }
        
    });
    
    return collectionList;
}

- (BOOL)deleteDataWithModel:(RemindModel *)model
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sqlStr = @"";
        
        if (model.uid == 0) {
            
            sqlStr = [NSString stringWithFormat:@"DELETE FROM collectionList where uid = '%d'",model.uid];
            
        }else{
         
            sqlStr = [NSString stringWithFormat:@"DELETE FROM collectionList where oid = '%d'",model.oid];
        }
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sqlStr UTF8String], -1, &stmt, NULL);
        
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

    }
    
    
    return NO;
}


- (BOOL)insterRemindModel:(RemindModel *)model
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
   // CREATE TABLE IF NOT EXISTS collectionList(ID INTEGER PRIMARY KEY AUTOINCREMENT, timeorder text,year int,month int,day int,hour int,minute int,title text ,content text,randomType int ,musicName int ,countNumber int ,isOther int, keyStatus int, userID int ,fidStr text, gidStr text, isOn int, createTime text
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    if ([data openDB]) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO collectionList(oid,uid,timeorder ,year ,month ,day ,hour ,minute ,title ,content ,randomType ,musicName ,countNumber ,isOther ,keyStatus ,userID ,fidStr ,gidStr ,isOn ,createTime) VALUES('%d','%d','%@','%d','%d','%d','%d','%d','%@','%@','%d','%d','%d','%d','%d','%d','%@','%@','%d','%@')",model.oid,model.uid,model.timeorder,model.year,model.month,model.day,model.hour,model.minute,model.title,model.content,model.randomType,model.musicName,model.countNumber,model.isOther,model.keystatus,[userID intValue],model.fidStr,model.gidStr,model.isOn,model.createTime];
        
        char *err;
        
        if (sqlite3_exec(data.dataBase, [sqlStr UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            
            sqlite3_close(data.dataBase);

            return NO;
        }
        
        sqlite3_close(data.dataBase);
        
        return YES;
    }
 
    return NO;
}


@end
