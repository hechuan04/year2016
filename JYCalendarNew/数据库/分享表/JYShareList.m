//
//  JYShareList.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYShareList.h"

static JYShareList *shareList = nil;

@implementation JYShareList

+ (JYShareList *)shareList
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (shareList == nil) {
            
            shareList = [[JYShareList alloc] init];
        }
        
    });
    
    return shareList;
    
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (shareList == nil) {
            
            shareList = [super allocWithZone:zone];
        }
        
    });
    
    return shareList;
}


- (BOOL)insertRemindModel:(RemindModel *)model
                   fidStr:(NSString *)fidStr
                   gidStr:(NSString *)gidStr
                      mid:(int )mid
{

    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *content = [Tool actionForTransferredMeaning:model.content];
        NSString *title = [Tool actionForTransferredMeaning:model.title];
        NSString *friendName  = [Tool actionForTransferredMeaning:model.friendName];
        NSString *groupName = [Tool actionForTransferredMeaning:model.groupName];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO shareList(uid,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,keyStatus,gidStr,fidStr,isLook,createTime,isTop,isShare, localInfo , headUrlStr ,weekStr,sid,isSave,friendName,groupName,audioPathStr,audioDurationStr,longitudeStr,latitudeStr,offsetMinute) VALUES ('%d','%@','%d','%d','%d','%d','%d','%@','%@','%d','%d','%d','%d','%d','%@','%@','%d','%@','%@','%d','%@','%@','%@','%d','%d','%@','%@','%@','%@','%@','%@','%ld')",model.uid,model.timeorder,model.year,model.month,model.day,model.hour,model.minute,title,content,model.randomType,model.musicName,model.countNumber,model.isOther,model.keystatus,gidStr,fidStr,model.isLook,model.createTime,model.isTop,model.isShare,model.localInfo,model.headUrlStr,model.weekStr,mid,model.isSave,friendName,groupName,model.audioPathStr,model.audioDurationStr,model.longitudeStr,model.latitudeStr,model.offsetMinute];
       
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if ( result != SQLITE_OK) {
            
            sqlite3_close(data.dataBase);
            
            return NO;
            
        }
        
        sqlite3_close(data.dataBase);
        
        return YES;
        

        
    }else{
     
        return NO;
    }
    
    
    return NO;
    
}

- (NSArray *)selectModel
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        char *sql = "SELECT * FROM shareList order by isLook desc, isTop desc,keyStatus desc,timeorder desc";
        
        sqlite3_stmt *stmt;
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, nil);
        NSMutableArray *arrForModel = [NSMutableArray array];
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
            
            //ID INTEGER PRIMARY KEY AUTOINCREMENT ,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text, isTop text, isShare int, localInfo text, headUrlStr text,weekStr text
                
                int oid = sqlite3_column_int(stmt, 0);
                int uid = sqlite3_column_int(stmt, 1);
                char *timeorder = (char *)sqlite3_column_text(stmt, 2);
                int year = sqlite3_column_int(stmt, 3);
                int month = sqlite3_column_int(stmt, 4);
                int day = sqlite3_column_int(stmt, 5);
                int hour = sqlite3_column_int(stmt, 6);
                int minute = sqlite3_column_int(stmt, 7);
                char *title = (char *)sqlite3_column_text(stmt, 8);
                char *content = (char *)sqlite3_column_text(stmt, 9);
                int randomType = sqlite3_column_int(stmt, 10);
                int musicName = sqlite3_column_int(stmt, 11);
                int countNumber = sqlite3_column_int(stmt, 12);
                int isOther = sqlite3_column_int(stmt, 13);
                int keyStatus = sqlite3_column_int(stmt, 14);
                char *gidStr = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr = (char *)sqlite3_column_text(stmt, 16);
                int isLook = sqlite3_column_int(stmt, 17);
                char *createTime = (char *)sqlite3_column_text(stmt, 18);
                char *isTop = (char *)sqlite3_column_text(stmt, 19);
                int isShare = sqlite3_column_int(stmt, 20);
                char *localInfo = (char *)sqlite3_column_text(stmt, 21);
                char *headUrlStr = (char *)sqlite3_column_text(stmt, 22);
                char *weekStr = (char *)sqlite3_column_text(stmt, 23);
                int sid = sqlite3_column_int(stmt, 24);
                char *audioPathStr = (char *)sqlite3_column_text(stmt, 28);
                char *audioDurationStr = (char *)sqlite3_column_text(stmt, 29);
                int offsetMinute = sqlite3_column_int(stmt, 32);
                
                RemindModel *model = [[RemindModel alloc] init];
                
                model.oid = oid;
                model.uid = uid;
                model.sid = sid;
                model.timeorder = [NSString stringWithUTF8String:timeorder];
                model.year=  year;
                model.month = month;
                model.day = day;
                model.hour=  hour;
                model.minute = minute;
                model.title = [NSString stringWithUTF8String:title];
                model.content = [NSString stringWithUTF8String:content];
                model.randomType = randomType;
                model.musicName = musicName;
                model.countNumber = countNumber;
                model.isOther = isOther;
                model.keystatus = keyStatus;
                model.gidStr = [NSString stringWithUTF8String:gidStr];
                model.fidStr = [NSString stringWithUTF8String:fidStr];
                model.isLook = isLook;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.isTop = [NSString stringWithUTF8String:isTop];
                model.isShare = isShare;
                model.localInfo = [NSString stringWithUTF8String:localInfo];
                model.headUrlStr = [NSString stringWithUTF8String:headUrlStr];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.audioPathStr = [NSString stringWithUTF8String:audioPathStr];
                model.audioDurationStr = [NSString stringWithUTF8String:audioDurationStr];
                model.offsetMinute = offsetMinute;
                
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

- (BOOL)deleteActionWithModel:(RemindModel *)model
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM shareList WHERE sid = '%d'",model.sid];
        
        sqlite3_stmt *stmt;
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    
                    sqlite3_finalize(stmt);
                    sqlite3_close(data.dataBase);
                    
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

/**
 *  计算当前时间
 */
- (NSString *)nowDay
{
    int nowYear = [[Tool actionForNowYear:nil] intValue];
    int nowMonth1 = [[Tool actionForNowMonth:nil] intValue];
    int nowDay1 = [[Tool actionForNowSingleDay:nil] intValue];
    int nowHour1 = [[Tool actionforNowHour] intValue];
    int nowMinute1 = [[Tool actionforNowMinute] intValue];
    
    NSString *nowMonth = [Tool actionForTenOrSingleWithNumber:nowMonth1];
    NSString *nowDay = [Tool actionForTenOrSingleWithNumber:nowDay1];
    NSString *nowHour = [Tool actionForTenOrSingleWithNumber:nowHour1];
    NSString *nowMinute = [Tool actionForTenOrSingleWithNumber:nowMinute1];
    NSString *timeOR = [NSString stringWithFormat:@"%d%@%@%@%@",nowYear,nowMonth,nowDay,nowHour,nowMinute];
    return timeOR;
}

- (NSArray *)searchWithStr:(NSString *)str
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        

        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
//        NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT shareList.id,shareList.uid,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then shareList.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,isLook,case when o.status is null then 1 when o.status is not null then o.status end isOn,createTime ,isTop ,isShare ,localInfo ,headUrlStr ,weekStr ,sid,isSave,friendName,groupName,audioPathStr,audioDurationStr ,longitudeStr, latitudeStr from shareList left join openList o On shareList.uid = o.mid and o.userID = '%@' where content like \'%%%@%%\' or title like \'%%%@%%\' or timeorder like \'%%%@%%\' or friendName like \'%%%@%%\' or groupName like \'%%%@%%\' order by isTop desc, isLook desc, keyStatus desc,timeorder desc ",str,str,str,str,str,userID];
     NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT id,uid, timeorder, year, month, day, hour, minute, title, content, randomType,musicName, countNumber, isOther, keyStatus, gidStr, fidStr, isLook, isOn, createTime , isTop , isShare , localInfo , headUrlStr , weekStr , sid, isSave, friendName, groupName, audioPathStr, audioDurationStr , longitudeStr,  latitudeStr,offsetMinute from (SELECT DISTINCT shareList.id,shareList.uid,shareList.timeorder,shareList.year,shareList.month,shareList.day,shareList.hour,shareList.minute,shareList.title,shareList.content,shareList.randomType,case when o.musicName is null then shareList.musicName when o.musicName is not null then o.musicName end musicName,shareList.countNumber,shareList.isOther,shareList.keyStatus,shareList.gidStr,shareList.fidStr,shareList.isLook,case when o.status is null then 1 when o.status is not null then o.status end isOn,shareList.createTime ,shareList.isTop ,shareList.isShare ,shareList.localInfo ,shareList.headUrlStr ,shareList.weekStr ,shareList.sid,shareList.isSave,shareList.friendName,shareList.groupName,shareList.audioPathStr,shareList.audioDurationStr ,shareList.longitudeStr, shareList.latitudeStr,shareList.offsetMinute,f.remark_name from shareList left join openList o On shareList.sid = o.mid and o.userID = '%@' left join saveFriend f on shareList.fidStr like '%%' + f.fid + '%%' where shareList.content like \'%%%@%%\' or shareList.title like \'%%%@%%\' or shareList.timeorder like \'%%%@%%\' or shareList.friendName like \'%%%@%%\' or shareList.groupName like \'%%%@%%\' or f.remark_name like '%%%@%%' order by shareList.isTop desc, shareList.isLook desc ,shareList.timeorder desc) ",userID,str,str,str,str,str,str];
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        NSMutableArray *arrForModel = [NSMutableArray array];
        if (result == SQLITE_OK) {
            
            NSString *timeOR = [self nowDay];
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
               //ID INTEGER PRIMARY KEY AUTOINCREMENT ,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text, isTop text, isShare int, localInfo text, headUrlStr text,weekStr text,mid integer,friendName text,groupName text
                RemindModel *model = [[RemindModel alloc] init];
                int oid = sqlite3_column_int(stmt, 0);
                int uid = sqlite3_column_int(stmt, 1);
                char *timeorder = (char *)sqlite3_column_text(stmt, 2);
                int year = sqlite3_column_int(stmt, 3);
                int month = sqlite3_column_int(stmt, 4);
                int day = sqlite3_column_int(stmt, 5);
                int hour = sqlite3_column_int(stmt, 6);
                int minute = sqlite3_column_int(stmt, 7);
                char *title = (char *)sqlite3_column_text(stmt, 8);
                char *count = (char *)sqlite3_column_text(stmt, 9);
                int randomType = sqlite3_column_int(stmt, 10);
                int musicName = sqlite3_column_int(stmt, 11);
                int countNumber = sqlite3_column_int(stmt, 12);
                int isOhter = sqlite3_column_int(stmt, 13);
                int keyStatus = sqlite3_column_int(stmt, 14);
                char *gidStr = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr = (char *)sqlite3_column_text(stmt, 16);
                int isLook = sqlite3_column_int(stmt, 17);
                int isOn = sqlite3_column_int(stmt, 18);
                char *createTime = (char *)sqlite3_column_text(stmt, 19);
                char *isTop = (char *)sqlite3_column_text(stmt, 20);
                int isShare = sqlite3_column_int(stmt, 21);
                char *localInfo = (char *)sqlite3_column_text(stmt, 22);
                char *headUrl = (char *)sqlite3_column_text(stmt, 23);
                char *weekStr = (char *)sqlite3_column_text(stmt, 24);
                int sid = sqlite3_column_int(stmt, 25);
                int isSave = sqlite3_column_int(stmt, 26);
                char *audioPathStr = (char *)sqlite3_column_text(stmt, 29);
                char *audioDurationStr = (char *)sqlite3_column_text(stmt, 30);
                char *longitudeStr = (char *)sqlite3_column_text(stmt, 31);
                char *latitudeStr  = (char *)sqlite3_column_text(stmt, 32);
                int offsetMinute = sqlite3_column_int(stmt, 33);
                
                
                model.oid = oid;
                model.uid = uid;
                model.sid = sid;
                model.timeorder = [NSString stringWithUTF8String:timeorder];
                model.year = year;
                model.month = month;
                model.day = day;
                model.hour = hour;
                model.minute = minute;
                model.title = [NSString stringWithUTF8String:title];
                model.content = [NSString stringWithUTF8String:count];
                model.randomType = randomType;
                model.musicName = musicName;
                model.countNumber = countNumber;
                model.isOther = isOhter;
                model.keystatus = keyStatus;
                model.gidStr = [NSString stringWithUTF8String:gidStr];
                model.fidStr = [NSString stringWithUTF8String:fidStr];
                model.isLook = isLook;
                model.isOn = isOn;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.isShare = isShare;
                model.isTop = [NSString stringWithUTF8String:isTop];
                model.localInfo = [NSString stringWithUTF8String:localInfo];
                model.headUrlStr = [NSString stringWithUTF8String:headUrl];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.isSave = isSave;
                model.audioPathStr = [NSString stringWithUTF8String:audioPathStr];
                model.audioDurationStr = [NSString stringWithUTF8String:audioDurationStr];
                model.longitudeStr = [NSString stringWithUTF8String:longitudeStr];
                model.latitudeStr = [NSString stringWithUTF8String:latitudeStr];
                model.offsetMinute = offsetMinute;
                
                [model setSystemTime];


                long long selectTime = [model.timeorder longLongValue];
                
                if ([timeOR longLongValue] >= selectTime) {
                    
                    model.isRemind = YES;
                }
                
                [arrForModel addObject:model];
                
            }
            
            sqlite3_finalize(stmt);
            sqlite3_close(data.dataBase);
            
          
            return arrForModel;
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return nil;
        
    }else{
     
        return nil;
    }
    
}

#pragma mark 删除所有数据
- (BOOL)deleteAllData
{
    XiaomiDB *data = [XiaomiDB  shareXiaomiDB];
    BOOL isSuccess = [data openDB];
    
    if (!isSuccess) {
        
        return NO;
    }
    
    char *sql = "DELETE  FROM shareList";
    
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
    
    if (result == SQLITE_OK) {
        
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            
            sqlite3_finalize(stmt);
            sqlite3_close(data.dataBase);
            
            return YES;
            
            
        }
        
    }
    
    sqlite3_finalize(stmt);
    sqlite3_close(data.dataBase);
    
    return NO;
    
}


- (BOOL)upDataWithModel:(RemindModel *)model
{
 
    XiaomiDB *data = [XiaomiDB  shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"UPDATE shareList set musicName = '%d' ,isLook = '%d' ,isTop = '%@',isSave = '%d' where sid = '%d'",model.musicName,model.isLook,model.isTop,model.isSave,model.sid];
        
        sqlite3_stmt *stmt;
        
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

        
    }else {
    
     
        return NO;
    }
    
}

- (int )selectMidWithSid:(int )sid
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
  

        
        NSString *sql = [NSString stringWithFormat:@"SELECT mid FROM shareList WHERE uid = '%d'",sid];
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        int mid = 0;
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                mid = sqlite3_column_int(stmt, 0);
                
            }
            
            sqlite3_finalize(stmt);
            sqlite3_close(data.dataBase);
            
            return mid;
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        return mid;
        
    }else{
        
        return 0;
    }
    
}


@end
