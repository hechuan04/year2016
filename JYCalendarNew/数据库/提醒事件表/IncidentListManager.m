//
//  IncidentListManager.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "IncidentListManager.h"

static IncidentListManager *manager = nil;

@implementation IncidentListManager

+ (IncidentListManager *)shareIncidentManager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        if (manager == nil) {
            
            manager = [[IncidentListManager alloc] init];
            
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

#pragma mark 插入数据
- (BOOL)insertDataWithremindModel:(RemindModel *)model
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    if ([data openDB]) {
        
        //longitudeStr text,latitudeStr text
        NSString *content = [Tool actionForTransferredMeaning:model.content];
        NSString *title = [Tool actionForTransferredMeaning:model.title];
        NSString *friendName  = [Tool actionForTransferredMeaning:model.friendName];
        NSString *groupName = [Tool actionForTransferredMeaning:model.groupName];
        
        NSLog(@"%d",model.randomType);
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO saveIncident(uid,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,keyStatus,gidStr,fidStr,isLook,createTime,isTop,localInfo, headUrlStr ,weekStr,isSave,friendName,groupName,audioPathStr,audioDurationStr ,longitudeStr ,latitudeStr,offsetMinute) VALUES ('%d','%@','%d','%d','%d','%d','%d','%@','%@','%d','%d','%d','%d','%d','%@','%@','%d','%@','%@','%@','%@','%@','%d','%@','%@','%@','%@','%@','%@','%ld')",model.uid,model.timeorder,model.year,model.month,model.day,model.hour,model.minute,title,content,model.randomType,model.musicName,model.countNumber,model.isOther,model.keystatus,model.gidStr,model.fidStr,model.isLook,model.createTime,model.isTop,model.localInfo,model.headUrlStr,model.weekStr,model.isSave,friendName,groupName,model.audioPathStr,model.audioDurationStr,model.longitudeStr,model.latitudeStr,model.offsetMinute];
        
        char *err;
        
        if (sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK ) {
            
            
            return NO;
            
        }
        
        
        sqlite3_close(data.dataBase);
        
        return YES;
        
    }else{
        
        sqlite3_close(data.dataBase);
        
        return NO;
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
    
    char *sql = "DELETE  FROM saveIncident";
    
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

#pragma mark 删除数据
- (BOOL)deleteDataWithUid:(int )uid
                    ownId:(int )oid existUid:(BOOL)exist
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    if ([data openDB]) {
        
        sqlite3_stmt *stmt;
        NSString *sql = @"";
        if (exist) {
            
            sql = [NSString stringWithFormat:@"delete from saveIncident where uid = '%d'",uid];
            
        }else{
            
            sql = [NSString stringWithFormat:@"delete from saveIncident where id = '%d'",oid];
            
        }
        
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
        
        sqlite3_close(data.dataBase);
        
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

#pragma mark 更改数据
- (BOOL)upDataWithModel:(RemindModel *)model
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = @"";
 
        //,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text,isTop text,localInfo text, headUrlStr text,weekStr text,isSave integer,friendName text,groupName text,audioPathStr text
        sql = [NSString stringWithFormat:@"update saveIncident set timeorder = '%@', year = '%d', month = '%d', day = '%d', hour = '%d', minute = '%d', title = '%@', content = '%@', randomType = '%d', musicName = '%d', countNumber = '%d',isOther = '%d',keyStatus = '%d',gidStr = '%@', fidStr = '%@',isLook = '%d' ,isTop = '%@' ,isSave = '%d', audioPathStr = '%@',audioDurationStr = '%@', offsetMinute = '%ld' where uid = '%d'",model.timeorder,model.year,model.month,model.day,model.hour,model.minute,model.title,model.content,model.randomType,model.musicName,model.countNumber,model.isOther,model.keystatus,model.gidStr,model.fidStr,model.isLook,model.isTop,model.isSave,model.audioPathStr,model.audioDurationStr,model.offsetMinute,model.uid];
        
        
        sqlite3_stmt *stmt ;
        
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
        sqlite3_close(data.dataBase);
        
        return NO;
        
    }else{
        
        sqlite3_close(data.dataBase);
        
        return NO;
    }
    
    
}

#pragma mark 模糊查询(接收)
- (NSArray *)searchWithStr:(NSString *)str
{
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    XiaomiDB *data = [XiaomiDB  shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        //ID INTEGER PRIMARY KEY AUTOINCREMENT,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text,isTop text,localInfo text, headUrlStr text,weekStr text,isSave integer,friendName text,groupName text
       // NSString *sql = [NSString stringWithFormat:@"select DISTINCT saveIncident.id,saveIncident.uid ,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then saveIncident.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,isLook,case when o.status is null then 1 when o.status is not null then o.status end isOn ,createTime ,isTop,localInfo,headUrlStr,weekStr,isSave,friendName,groupName,audioPathStr,audioDurationStr,longitudeStr,latitudeStr from saveIncident left join openList o On saveIncident.uid = o.mid and o.userID = '%@'  where (content like \'%%%@%%\' or title like \'%%%@%%\' or timeorder like \'%%%@%%\' or friendName like \'%%%@%%\' or groupName like \'%%%@%%\') and (weekStr is not '100') and (isOther is not '0') order by isTop desc, isLook desc, keyStatus desc,timeorder desc",userID,str,str,str,str,userID];
        
        NSString *sql = [NSString stringWithFormat:@"select DISTINCT saveIncident.id,saveIncident.uid ,saveIncident.timeorder,saveIncident.year,saveIncident.month,saveIncident.day,saveIncident.hour,saveIncident.minute,saveIncident.title,saveIncident.content,saveIncident.randomType,case when o.musicName is null then saveIncident.musicName when o.musicName is not null then o.musicName end musicName,saveIncident.countNumber,saveIncident.isOther,saveIncident.keyStatus,saveIncident.gidStr,saveIncident.fidStr,saveIncident.isLook,case when o.status is null then 1 when o.status is not null then o.status end isOn ,saveIncident.createTime ,saveIncident.isTop,saveIncident.localInfo,saveIncident.headUrlStr,saveIncident.weekStr,saveIncident.isSave,saveIncident.friendName,saveIncident.groupName,saveIncident.audioPathStr,saveIncident.audioDurationStr,saveIncident.longitudeStr,saveIncident.latitudeStr,saveIncident.offsetMinute from saveIncident left join openList o On saveIncident.uid = o.mid and o.userID = '%@' LEFT JOIN saveFriend f ON saveIncident.friendName = f.friend_name where (saveIncident.content like \'%%%@%%\' or saveIncident.title like \'%%%@%%\' or saveIncident.timeorder like \'%%%@%%\' or saveIncident.friendName like \'%%%@%%\' or saveIncident.groupName like \'%%%@%%\' or f.remark_name like \'%%%@%%\') and (saveIncident.weekStr is not '100') and (saveIncident.isOther is not '0') and (saveIncident.weekStr is not '101') order by saveIncident.isTop desc, saveIncident.isLook desc,saveIncident.timeorder desc",userID,str,str,str,str,str,str];
        
        sqlite3_stmt *stmt = nil;

        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            NSString *timeOR = [self nowDay];
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                
                int oid = sqlite3_column_int(stmt, 0);
                int uid = sqlite3_column_int(stmt, 1);
                char *timeOrder_C = (char *)sqlite3_column_text(stmt, 2);
                int year = sqlite3_column_int(stmt, 3);
                int month = sqlite3_column_int(stmt, 4);
                int day = sqlite3_column_int(stmt, 5);
                int hour = sqlite3_column_int(stmt, 6);
                int minute = sqlite3_column_int(stmt, 7);
                char *title_C =  (char *)sqlite3_column_text(stmt, 8);
                char *content_C = (char *)sqlite3_column_text(stmt, 9);
                int randomType = sqlite3_column_int(stmt, 10);
                int musicName = sqlite3_column_int(stmt, 11);
                int countNumber = sqlite3_column_int(stmt, 12);
                int isOther = sqlite3_column_int(stmt, 13);
                int keyStatus = sqlite3_column_int(stmt, 14);
                char *gidStr_C = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr_C = (char *)sqlite3_column_text(stmt, 16);
                int isLook = sqlite3_column_int(stmt, 17);
                int isOn = (int )sqlite3_column_int(stmt, 18);
                char *create_Time = (char *)sqlite3_column_text(stmt, 19);
                char *isTop = (char *)sqlite3_column_text(stmt, 20);
                char *localInfo = (char *)sqlite3_column_text(stmt, 21);
                char *picUrl = (char *)sqlite3_column_text(stmt, 22);
                char *weekStr = (char *)sqlite3_column_text(stmt, 23);
                int isSave = sqlite3_column_int(stmt, 24);
                char *audioPathStr = (char *)sqlite3_column_text(stmt, 27);
                char *audioDurationStr = (char *)sqlite3_column_text(stmt, 28);
                char *longitudeStr = (char *)sqlite3_column_text(stmt, 29);
                char *latitudeStr  = (char *)sqlite3_column_text(stmt, 30);
                int offsetMinute = sqlite3_column_int(stmt, 31);
                if (title_C == NULL) {
                    
                    title_C = "";
                }
                
                if (content_C == NULL) {
                    
                    content_C = "";
                }
                
                if (gidStr_C == NULL) {
                    
                    gidStr_C = "";
                }
                
                if (fidStr_C == NULL) {
                    
                    fidStr_C = "";
                }
                
                if (audioPathStr == NULL) {
                    
                    audioPathStr = "";
                }
                if(audioDurationStr == NULL){
                    audioDurationStr = "";
                }
                if (longitudeStr == NULL) {
                    longitudeStr = "";
                }
                if(latitudeStr == NULL){
                    latitudeStr = "";
                }
                NSString *timeOrder = [NSString stringWithUTF8String:timeOrder_C];
                NSString *title = [NSString stringWithUTF8String:title_C];
                NSString *content = [NSString stringWithUTF8String:content_C];
                NSString *gidStr = [NSString stringWithUTF8String:gidStr_C];
                NSString *fidStr =[NSString stringWithUTF8String:fidStr_C];
                NSString *createTime = [NSString stringWithUTF8String:create_Time];
                
                model.oid = oid;
                model.uid = uid;
                model.timeorder = timeOrder;
                model.year = year;
                model.month = month;
                model.day = day;
                model.hour = hour;
                model.minute = minute;
                model.title = title;
                model.content = content;
                model.randomType = randomType;
                model.musicName = musicName;
                model.countNumber = countNumber;
                model.isOther = isOther;
                model.strForRepeat = [Tool actionForReturnRepeatStr:model];
                model.keystatus = keyStatus;
                model.gidStr = gidStr;
                model.fidStr = fidStr;
                model.isLook = isLook;
                model.isOn = isOn;
                model.createTime = createTime;
                model.isShare = 0;
                model.isSave = isSave;
                model.isTop = [NSString stringWithUTF8String:isTop];
                model.localInfo = [NSString stringWithUTF8String:localInfo];
                model.headUrlStr = [NSString stringWithUTF8String:picUrl];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
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
                
                [mutableArr addObject:model];
                
                
                
            }
            
        }
        
        sqlite3_close(data.dataBase);
  
        return mutableArr;
    }
    
    
    return mutableArr;
}


#pragma mark 查询所有数据
- (NSArray *)selectAllData
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    if ([data openDB]) {
        
        NSString *sql = @"";
        
        //ID INTEGER PRIMARY KEY AUTOINCREMENT,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text,isTop text,localInfo text, headUrlStr text,weekStr text
        
        int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        sql = [NSString stringWithFormat:@"select s.id,s.uid,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then s.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,isLook,case when o.status is null then 1 when o.status is not null then o.status end isOn ,createTime,isTop,localInfo,headUrlStr,weekStr,audioPathStr,audioDurationStr,longitudeStr,latitudeStr,offsetMinute  from saveIncident s left join openList o on s.uid = o.mid and o.userID = '%d'",userID];
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        NSMutableArray *arrForAllModel = [NSMutableArray array];
        
        if (result == SQLITE_OK) {
            
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                
               
                int oid = sqlite3_column_int(stmt, 0);
                int uid = sqlite3_column_int(stmt, 1);
                char *timeOrder_C = (char *)sqlite3_column_text(stmt, 2);
                int year = sqlite3_column_int(stmt, 3);
                int month = sqlite3_column_int(stmt, 4);
                int day = sqlite3_column_int(stmt, 5);
                int hour = sqlite3_column_int(stmt, 6);
                int minute = sqlite3_column_int(stmt, 7);
                char *title_C =  (char *)sqlite3_column_text(stmt, 8);
                char *content_C = (char *)sqlite3_column_text(stmt, 9);
                int randomType = sqlite3_column_int(stmt, 10);
                int musicName = sqlite3_column_int(stmt, 11);
                int countNumber = sqlite3_column_int(stmt, 12);
                int isOther = sqlite3_column_int(stmt, 13);
                int keyStatus = sqlite3_column_int(stmt, 14);
                char *gidStr_C = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr_C = (char *)sqlite3_column_text(stmt, 16);
                int isLook = sqlite3_column_int(stmt, 17);
                int isOn = (int )sqlite3_column_int(stmt, 18);
                char *weekStr = (char *)sqlite3_column_text(stmt, 23);
                char *longitudeStr = (char *)sqlite3_column_text(stmt, 24);
                char *latitudeStr  = (char *)sqlite3_column_text(stmt, 25);
                int offsetMinute = sqlite3_column_int(stmt, 26);
                if (title_C == NULL) {
                    
                    title_C = "";
                }
                
                if (content_C == NULL) {
                    
                    content_C = "";
                }
                
                if (gidStr_C == NULL) {
                    
                    gidStr_C = "";
                }
                
                if (fidStr_C == NULL) {
                    
                    fidStr_C = "";
                }
                
                NSString *timeOrder = [NSString stringWithUTF8String:timeOrder_C];
                NSString *title = [NSString stringWithUTF8String:title_C];
                NSString *content = [NSString stringWithUTF8String:content_C];
                NSString *gidStr = [NSString stringWithUTF8String:gidStr_C];
                NSString *fidStr =[NSString stringWithUTF8String:fidStr_C];
                
                model.oid = oid;
                model.uid = uid;
                model.timeorder = timeOrder;
                model.year = year;
                model.month = month;
                model.day = day;
                model.hour = hour;
                model.minute = minute;
                model.title = title;
                model.content = content;
                model.randomType = randomType;
                model.musicName = musicName;
                model.countNumber = countNumber;
                model.isOther = isOther;
                model.strForRepeat = [Tool actionForReturnRepeatStr:model];
                model.keystatus = keyStatus;
                model.gidStr = gidStr;
                model.fidStr = fidStr;
                model.isLook = isLook;
                model.isOn = isOn;
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.longitudeStr = [NSString stringWithUTF8String:longitudeStr];
                model.latitudeStr = [NSString stringWithUTF8String:latitudeStr];
                model.offsetMinute = offsetMinute;
                
                if (musicName == 0) {
                    
                    model.isOn = 0;
                }
                
                [arrForAllModel addObject:model];
                
            }
            
        }
        
        sqlite3_close(data.dataBase);
        return arrForAllModel;
        
    }else{
        
        sqlite3_close(data.dataBase);
        
        return nil;
    }
    
}

#pragma mark 全部至0
#pragma mark 更改数据
- (BOOL)upDataWithModelAll
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = @"";
        
        
        
        sql = [NSString stringWithFormat:@"update saveIncident set isLook = '0'"];
        
        
        sqlite3_stmt *stmt ;
        
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
        sqlite3_close(data.dataBase);
        
        return NO;
        
    }else{
        
        sqlite3_close(data.dataBase);
        
        return NO;
    }
    
    
}


@end
