//
//  JYClockList.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYClockList.h"

static JYClockList *jyClockList = nil;

@implementation JYClockList

+ (JYClockList *)shareClockList
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (jyClockList == nil) {
            
            jyClockList = [[JYClockList alloc] init];
            
        }
        
    });
    
    return jyClockList;
    
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (jyClockList == nil) {
            
            jyClockList = [super allocWithZone:zone];
        }
    });
    
    return jyClockList;
}

- (BOOL)upDataWithClockModel:(ClockModel *)model
{
    
    [model convertTimeToGMT];
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        //ID INTEGER PRIMARY KEY AUTOINCREMENT ,timeDescribe text,hour int, minute int ,isOn int,musicID int,week text,userID text, timeOrder text, textStr text
        NSString *sql = [NSString stringWithFormat:@"UPDATE clockList set timeDescribe = '%@', year = '%d',month = '%d',day = '%d',hour = '%d',minute = '%d', isOn = '%d', musicID = '%d', week = '%@', userID = '%@' ,timeOrder = '%@', textStr = '%@' where ID = '%d'",model.timeDescribe,model.year,model.month,model.day,model.hour,model.minute,model.isOn,model.musicID,model.week,userID,model.timeOrder,model.textStr,model.mid];
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    
                    sqlite3_finalize(stmt);
                    sqlite3_close(data.dataBase);
                    [model convertTimeToLocal];
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

- (BOOL)insertClockWithClockModel:(ClockModel *)model
{
 
    [model convertTimeToGMT];
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        //ID INTEGER PRIMARY KEY AUTOINCREMENT ,timeDescribe text,hour int, minute int ,isOn int,musicID int,week text,userID text
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO clockList(timeDescribe,year,month,day,hour,minute,isOn,musicID,week,userID,timeOrder,textStr) VALUES ('%@','%d','%d','%d','%d','%d','%d','%d','%@','%@','%@','%@')",model.timeDescribe,model.year,model.month,model.day,model.hour,model.minute,model.isOn,model.musicID,model.week,userID,model.timeOrder,model.textStr];
        char *err;
        
        if (sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            
            sqlite3_close(data.dataBase);
            
            return NO;
            
        }
        
        sqlite3_close(data.dataBase);
        
        return YES;
        
        
    }else {
        
        return NO;
    }
    
    
}

- (BOOL)deleteClockWithModel:(ClockModel *)model
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        sqlite3_stmt *stmt ;
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM clockList where ID = '%d'",model.mid];
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, nil);
        
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

- (NSArray *)selectAllModel
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSMutableArray *arrForModel = [NSMutableArray array];
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM clockList where userID = '%@' order by hour ASC, minute ASC",userID];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, nil);
        
        if (result == SQLITE_OK) {
            
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
//                ID INTEGER PRIMARY KEY AUTOINCREMENT ,timeDescribe text,year int,month int,day int,hour int, minute int ,isOn int,musicID int,week text,userID text, timeOrder text, textStr text
                
                int mid = sqlite3_column_int(stmt, 0);
                char *timeDe = (char *)sqlite3_column_text(stmt, 1);
                int year = sqlite3_column_int(stmt, 2);
                int month = sqlite3_column_int(stmt, 3);
                int day = sqlite3_column_int(stmt, 4);
                int hour = sqlite3_column_int(stmt, 5);
                int minute = sqlite3_column_int(stmt, 6);
                int isOn = sqlite3_column_int(stmt, 7);
                int musicID = sqlite3_column_int(stmt, 8);
                char *week = (char *)sqlite3_column_text(stmt, 9);
                char *timeorder = (char *)sqlite3_column_text(stmt, 11);
                char *textStr = (char *)sqlite3_column_text(stmt, 12);
                
                ClockModel *model = [[ClockModel alloc] init];
                
                model.mid = mid;
                model.timeDescribe = [NSString stringWithUTF8String:timeDe];
                model.year = year;
                model.month = month;
                model.day = day;
                model.hour = hour;
                model.minute = minute;
                model.isOn = isOn;
                model.musicID = musicID;
                model.week = [NSString stringWithUTF8String:week];
                model.timeOrder = [NSString stringWithUTF8String:timeorder];
                model.textStr = [NSString stringWithUTF8String:textStr];
                
                [model convertTimeToLocal];
                
                [arrForModel addObject:model];
                
            }
            
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return arrForModel;
        
        
        
    }else{
        
        return nil;
    }
    
}

@end
