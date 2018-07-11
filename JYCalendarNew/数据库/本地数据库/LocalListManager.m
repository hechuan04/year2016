//
//  LocalListManager.m
//  groupListManager
//
//  Created by 吴冬 on 15/12/22.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "LocalListManager.h"
#import "RemindModel.h"
#import "AppDelegate.h"
#import "JYMainViewController.h"
#import "JYCalculateRandomTime.h"

static LocalListManager *localListManager = nil;

@implementation LocalListManager

+ (LocalListManager *)shareLocalListManager
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (localListManager == nil) {
            
            localListManager = [[LocalListManager alloc] init];
            
        }
        
    });
    
    return localListManager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (localListManager == nil) {
            
            localListManager = [super allocWithZone:zone];
        }
        
    });
    
    return localListManager;
}

#pragma mark 插入数据
- (BOOL)insertDataWithremindModel:(RemindModel *)model usersID:(int )userID
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    if ([data openDB]) {
        
        
        NSString *content = [Tool actionForTransferredMeaning:model.content];
        NSString *title = [Tool actionForTransferredMeaning:model.title];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO localList(timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,keyStatus,userID,fidStr,gidStr,isOn,createTime,isTop,localInfo, headUrlStr ,weekStr,isSave,audioPathStr,audioDurationStr,offsetMinute) VALUES ('%@','%d','%d','%d','%d','%d','%@','%@','%d','%d','%d','%d','%d','%d','%@','%@','%d','%@','%@','%@','%@','%@','%d','%@','%@','%ld')",model.timeorder,model.year,model.month,model.day,model.hour,model.minute,title,content,model.randomType,model.musicName,model.countNumber,model.isOther,model.keystatus,userID,model.fidStr,model.gidStr,model.isOn,model.createTime,model.isTop,model.localInfo,model.headUrlStr,model.weekStr,model.isSave,model.audioPathStr,model.audioDurationStr,model.offsetMinute];
        
        char *err;
        
        if (sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK ) {
            
            
            return NO;
            
        }
        
        
        sqlite3_close(data.dataBase);
        
        return YES;
        
        
    }else{
        
        return NO;
    }
    
    
}

#pragma mark 删除数据
- (BOOL)deleteDataWithUid:(int )uid
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        sqlite3_stmt *stmt;
        
        NSString *sql = [NSString stringWithFormat:@"delete from localList where id = '%d'",uid];
        
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

#pragma mark 模糊查询 (全部,待提醒内容)
- (NSDictionary *)searchAllDataWithTextNotYet:(NSString *)text
{
    
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    NSMutableArray *arrForData = [NSMutableArray array];
    if ([xiaomiDb openDB]) {
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        
        NSString *sql = @"";
        
        sql = [NSString stringWithFormat:@"select * from (select s.id,s.uid,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then s.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,case when o.status is null then 1 when o.status is not null then o.status end isOn ,isLook ,createTime ,isTop , '',localInfo,headUrlStr,weekStr,'',isSave,friendName,groupName,audioPathStr,audioDurationStr,longitudeStr, latitudeStr,offsetMinute from saveIncident s left join openList o on s.uid = o.mid and o.userID = '%@' union all select id,'' uid,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,0 keyStatus,gidStr,fidStr,isOn ,0,createTime,isTop ,'',localInfo,headUrlStr,weekStr,'',isSave,friendName,groupName,audioPathStr,audioDurationStr ,longitudeStr, latitudeStr,offsetMinute from localList where userID = '%@' union all select share.id ,uid ,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then share.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,case when o.status is null then 1 when o.status is not null then o.status end isOn, isLook,createTime ,isTop ,isShare ,localInfo,headUrlStr,weekStr,sid,isSave,friendName,groupName,audioPathStr,audioDurationStr,longitudeStr, latitudeStr,offsetMinute from shareList share left join openList o on share.sid = o.mid and o.userID = '%@') where (content like \'%%%@%%\' or title like \'%%%@%%\' or timeorder like \'%%%@%%\' or friendName like \'%%%@%%\' or groupName like \'%%%@%%\') order by isTop desc,isLook desc,timeorder asc",userID,userID,userID,text,text,text,text,text];
        
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                // id,uid ,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,keyStatus,gidStr,fidStr
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
                char *gidStr = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr = (char *)sqlite3_column_text(stmt, 16);
                int isOn = sqlite3_column_int(stmt, 17);
                int isLook = sqlite3_column_int(stmt, 18);
                char *createTime = (char *)sqlite3_column_text(stmt,19);
                char *isTop = (char *)sqlite3_column_text(stmt, 20);
                int isShare = sqlite3_column_int(stmt, 21);
                char *localInfo = (char *)sqlite3_column_text(stmt, 22);
                char *headUrlStr = (char *)sqlite3_column_text(stmt, 23);
                char *weekStr = (char *)sqlite3_column_text(stmt, 24);
                int sid = sqlite3_column_int(stmt, 25);
                int isSave = sqlite3_column_int(stmt, 26);
                char *friendName = (char *)sqlite3_column_text(stmt, 27);
                char *audioPathStr = (char *)sqlite3_column_text(stmt, 29);
                char *audioDurationStr = (char *)sqlite3_column_text(stmt, 30);
                char *longitudeStr = (char *)sqlite3_column_text(stmt, 31);
                char *latitudeStr  = (char *)sqlite3_column_text(stmt, 32);
                int offsetMinute = sqlite3_column_int(stmt, 33);
                
                if (title_C == NULL) {
                    
                    title_C = "";
                }
                
                if (content_C == NULL) {
                    
                    content_C = "";
                }
                
                if (gidStr == NULL) {
                    
                    gidStr = "";
                }
                
                if (fidStr == NULL) {
                    
                    fidStr = "";
                }
                
                if (headUrlStr == NULL) {
                    
                    headUrlStr = "";
                }
                
                if (localInfo == NULL) {
                    
                    localInfo = "";
                }
                
                if (weekStr == NULL) {
                    
                    weekStr = "";
                }
                if(friendName == NULL){
                    friendName = "";
                }
                if (audioPathStr == NULL) {
                    
                    audioPathStr = "";
                }
                if (audioDurationStr == NULL) {
                    
                    audioDurationStr = "";
                }
                if (longitudeStr == NULL) {
                    
                    longitudeStr = "";
                }
                if (latitudeStr == NULL) {
                    
                    latitudeStr = "";
                }

                NSString *timeOrder = [NSString stringWithUTF8String:timeOrder_C];
                NSString *title = [NSString stringWithUTF8String:title_C];
                NSString *content = [NSString stringWithUTF8String:content_C];
                
                
                model.oid = oid;
                model.uid = uid;
                model.sid = sid;
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
                model.gidStr = [NSString stringWithUTF8String:gidStr];   //不给值有nil，不好判断
                model.fidStr = [NSString stringWithUTF8String:fidStr];
                model.isOn = isOn;
                model.isLook = isLook;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.isTop = [NSString stringWithUTF8String:isTop];
                model.isShare = isShare;
                model.headUrlStr = [NSString stringWithUTF8String:headUrlStr];
                model.localInfo = [NSString stringWithUTF8String:localInfo];
                model.isSave = isSave;
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.audioPathStr = [NSString stringWithUTF8String:audioPathStr];
                model.audioDurationStr = [NSString stringWithUTF8String:audioDurationStr];
                model.longitudeStr = [NSString stringWithUTF8String:longitudeStr];
                model.latitudeStr = [NSString stringWithUTF8String:latitudeStr];
                model.friendName = [NSString stringWithUTF8String:friendName];
                model.offsetMinute = offsetMinute;
                
                if (model.musicName == 0) {
                    
                    model.isOn = 0;
                }
                
                [model setSystemTime];

                
                if (![model.weekStr isEqualToString:@"100"] && ![model.weekStr isEqualToString:@"101"]) {
                    
                    [arrForData addObject:model];
                    
                }
                
            }
            
            sqlite3_finalize(stmt);
            sqlite3_close(xiaomiDb.dataBase);
            
        }
        
        
         NSMutableArray *notYet_list = [NSMutableArray array];
         NSMutableArray *today_list  = [NSMutableArray array];
        
         NSDictionary *dic = @{@"today":today_list,@"after":notYet_list};
        
         //排序：待提醒关键人，待提醒无关键人；已提醒关键人，已提醒无关键人
         NSString *timeOR = [self nowDay];
        
        //未提醒
        for (int i = 0; i < arrForData.count; i++) {
            
            RemindModel *model = arrForData[i];
            
            BOOL isRemindMe = YES;
            if (model.isOther == 0 && model.isShare == 0) {
                isRemindMe = [Tool isPastOtherRemind:model.fidStr gidStr:model.gidStr];
            }
            
            //发送给别人的
            if (!isRemindMe) {
                continue;
            }
            
            //我分享给别人的不显示在列表中
            if (model.isShare != 0 && model.isOther == 0) {
                continue;
            }
            
 
            //重复提醒特殊处理
            if (model.randomType != 0) {
                [self isRandomModel:model];
            }else{
                model.year_random = model.year;
                model.month_random = model.month;
                model.day_random = model.day;
            }

            
            long long selectTime = [[NSString stringWithFormat:@"%d%02d%02d%02d%02d",model.year_random,model.month_random,model.day_random,model.hour,model.minute] longLongValue];
            
            //重复提醒需要特殊处理
            if ([timeOR longLongValue] < selectTime || model.randomType != 0) {
               
                model.isRemind = NO;
         
                if ([self isToday:model]) {
          
                    [today_list addObject:model];
                    
                }else{
                  
                    [notYet_list addObject:model];
                }
                
            }
            
        }
        
   
        return dic;
        
    }else {
        
        sqlite3_close(xiaomiDb.dataBase);
        
        return nil;
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

- (BOOL )isToday:(RemindModel *)model
{
    int nowYear = [[Tool actionForNowYear:nil] intValue];
    int nowMonth1 = [[Tool actionForNowMonth:nil] intValue];
    int nowDay1 = [[Tool actionForNowSingleDay:nil] intValue];
    
    NSString *nowMonth = [Tool actionForTenOrSingleWithNumber:nowMonth1];
    NSString *nowDay = [Tool actionForTenOrSingleWithNumber:nowDay1];
  
   
    NSString *timeOR = [NSString stringWithFormat:@"%d%@%@",nowYear,nowMonth,nowDay];
    
    NSString *selectTime = [NSString stringWithFormat:@"%d%02d%02d",model.year_random,model.month_random,model.day_random];
    

    return [selectTime isEqualToString:timeOR];
}

/*]*
 *  重复情况重新设定model显示的值
 */
- (void)isRandomModel:(RemindModel *)model
{
    JYCalculateRandomTime *manager = [JYCalculateRandomTime manager];
    [manager calculateRandomModel:model];
}

#pragma mark 模糊查询 (全部)
- (NSArray *)searchAllDataWithText:(NSString *)text
{
    
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    NSMutableArray *arrForData = [NSMutableArray array];
    if ([xiaomiDb openDB]) {
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        
        NSString *sql = @"";
        
        sql = [NSString stringWithFormat:@"select * from (select s.id,s.uid,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then s.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,case when o.status is null then 1 when o.status is not null then o.status end isOn ,isLook ,createTime ,isTop , '',localInfo,headUrlStr,weekStr,'',isSave,friendName,groupName,audioPathStr,audioDurationStr, longitudeStr,latitudeStr,offsetMinute from saveIncident s left join openList o on s.uid = o.mid and o.userID = '%@' union all select id,'' uid,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,0 keyStatus,gidStr,fidStr,isOn ,0,createTime,isTop ,'',localInfo,headUrlStr,weekStr,'',isSave,friendName,groupName,audioPathStr,audioDurationStr,longitudeStr,latitudeStr,offsetMinute from localList where userID = '%@' union all select share.id ,uid ,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then share.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,case when o.status is null then 1 when o.status is not null then o.status end isOn, isLook,createTime ,isTop ,isShare ,localInfo,headUrlStr,weekStr,sid,isSave,friendName,groupName,audioPathStr,audioDurationStr, longitudeStr,latitudeStr,offsetMinute from shareList share left join openList o on share.sid = o.mid and o.userID = '%@') where (content like \'%%%@%%\' or title like \'%%%@%%\' or timeorder like \'%%%@%%\' or friendName like \'%%%@%%\' or groupName like \'%%%@%%\') order by isTop desc,isLook desc,keyStatus desc,timeorder desc ",userID,userID,userID,text,text,text,text,text];

        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        
        
        if (result == SQLITE_OK) {
            
            NSString *timeOR = [self nowDay];
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                // id,uid ,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,keyStatus,gidStr,fidStr
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
                char *gidStr = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr = (char *)sqlite3_column_text(stmt, 16);
                int isOn = sqlite3_column_int(stmt, 17);
                int isLook = sqlite3_column_int(stmt, 18);
                char *createTime = (char *)sqlite3_column_text(stmt,19);
                char *isTop = (char *)sqlite3_column_text(stmt, 20);
                int isShare = sqlite3_column_int(stmt, 21);
                char *localInfo = (char *)sqlite3_column_text(stmt, 22);
                char *headUrlStr = (char *)sqlite3_column_text(stmt, 23);
                char *weekStr = (char *)sqlite3_column_text(stmt, 24);
                int sid = sqlite3_column_int(stmt, 25);
                int isSave = sqlite3_column_int(stmt, 26);
                char *audioPathStr = (char *)sqlite3_column_text(stmt, 29);
                char *audioDurationStr = (char *)sqlite3_column_text(stmt, 30);
                char *longitudeStr = (char *)sqlite3_column_text(stmt, 31);
                char *latitudeStr  = (char *)sqlite3_column_text(stmt, 32);
                int offsetMinute = sqlite3_column_int(stmt, 33);
                if (title_C == NULL) {
                    
                    title_C = "";
                }
                
                if (content_C == NULL) {
                    
                    content_C = "";
                }
                
                if (gidStr == NULL) {
                    
                    gidStr = "";
                }
                
                if (fidStr == NULL) {
                    
                    fidStr = "";
                }
                
                if (headUrlStr == NULL) {
                    
                    headUrlStr = "";
                }
                
                if (localInfo == NULL) {
                    
                    localInfo = "";
                }
                
                if (weekStr == NULL) {
                    
                    weekStr = "";
                }
                if (audioPathStr == NULL) {
                    
                    audioPathStr = "";
                }
                if (audioDurationStr == NULL) {
                    
                    audioDurationStr = "";
                }
                if (longitudeStr == NULL) {
                    
                    longitudeStr = "";
                }
                if (latitudeStr == NULL) {
                    
                    latitudeStr = "";
                }

                NSString *timeOrder = [NSString stringWithUTF8String:timeOrder_C];
                NSString *title = [NSString stringWithUTF8String:title_C];
                NSString *content = [NSString stringWithUTF8String:content_C];
                
                
                model.oid = oid;
                model.uid = uid;
                model.sid = sid;
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
                model.gidStr = [NSString stringWithUTF8String:gidStr];   //不给值有nil，不好判断
                model.fidStr = [NSString stringWithUTF8String:fidStr];
                model.isOn = isOn;
                model.isLook = isLook;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.isTop = [NSString stringWithUTF8String:isTop];
                model.isShare = isShare;
                model.headUrlStr = [NSString stringWithUTF8String:headUrlStr];
                model.localInfo = [NSString stringWithUTF8String:localInfo];
                model.isSave = isSave;
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.audioPathStr = [NSString stringWithUTF8String:audioPathStr];
                model.audioDurationStr = [NSString stringWithUTF8String:audioDurationStr];
                model.longitudeStr = [NSString stringWithUTF8String:longitudeStr];
                model.latitudeStr = [NSString stringWithUTF8String:latitudeStr];
                model.offsetMinute = offsetMinute;
                
                if (model.musicName == 0) {
                    
                    model.isOn = 0;
                }
                
                [model setSystemTime];
                
                if (![model.weekStr isEqualToString:@"100"] && ![model.weekStr isEqualToString:@"101"]) {
                    
                    long long selectTime = [model.timeorder longLongValue];
                    
                    if ([timeOR longLongValue] >= selectTime) {
                        
                        model.isRemind = YES;
                    }

                    [arrForData addObject:model];

                }
                
            }
            
            sqlite3_finalize(stmt);
            sqlite3_close(xiaomiDb.dataBase);
            
        }
        
     
        return arrForData;
        
    }else {
        
        sqlite3_close(xiaomiDb.dataBase);
        
        return nil;
    }
    
    
}

#pragma mark 模糊查询 (匹配内容搜索)
- (NSArray *)searchDateWithContentStr:(NSString *)str
{
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    NSMutableArray *arrForData = [NSMutableArray array];
    if ([xiaomiDb openDB]) {
        
        if ([str isEqualToString:@""]) {
            str = @"";
            return nil;
        }
        NSString *sql = @"";
        
        sql = [NSString stringWithFormat:@"select * from (select year,month,day,hour,minute,content ,weekStr from saveIncident union all select year,month,day,hour,minute,content ,weekStr from localList union all select year,month,day,hour,minute,content , weekStr from shareList) where content like \'%%%@%%\' and weekStr != 100 and weekStr != 101",str];
        
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        
        
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
             
                RemindModel *model = [RemindModel new];
                
                int year = sqlite3_column_int(stmt, 0);
                int month = sqlite3_column_int(stmt, 1);
                int day = sqlite3_column_int(stmt, 2);
                int hour = sqlite3_column_int(stmt, 3);
                int minute = sqlite3_column_int(stmt, 4);
                
                char *content = (char *)sqlite3_column_text(stmt, 5);
                
                model.year = year;
                model.month = month;
                model.day = day;
                model.hour = hour;
                model.minute = minute;
                model.content = [NSString stringWithUTF8String:content];

                [arrForData addObject:model];
            }
            
            sqlite3_finalize(stmt);
            sqlite3_close(xiaomiDb.dataBase);
        return arrForData;

    }else {
        
        sqlite3_close(xiaomiDb.dataBase);
        
        return nil;
        }
    }
    return arrForData;

}

#pragma mark 模糊查询（发送）
- (NSArray *)searchLocalDataWithText:(NSString *)text
{
    
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    NSMutableArray *arrForData = [NSMutableArray array];
    if ([xiaomiDb openDB]) {
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        NSString *sql = @"";
        
//        sql = [NSString stringWithFormat:@"select * from (select s.id,s.uid,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then s.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,case when o.status is null then 1 when o.status is not null then o.status end isOn ,isLook ,createTime ,isTop ,localInfo,headUrlStr ,weekStr,isSave,friendName,groupName,audioPathStr,audioDurationStr,longitudeStr,latitudeStr from saveIncident s left join openList o on s.uid = o.mid and o.userID = '%@' union all select id,'' uid,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,0 keyStatus,gidStr,fidStr,isOn ,'',createTime ,isTop ,localInfo,headUrlStr ,weekStr,isSave,friendName,groupName,audioPathStr,audioDurationStr,longitudeStr,latitudeStr from localList where userID = '%@' ) where (content like \'%%%@%%\' or title like \'%%%@%%\' or timeorder like \'%%%@%%\' or friendName like \'%%%@%%\' or groupName like \'%%%@%%\') and (isOther = 0) order by isTop desc,isLook desc, keyStatus desc,timeorder desc",userID,userID,text,text,text,text,text];
        //instr(s.fidStr,f.fid)>0
        sql = [NSString stringWithFormat:@"select DISTINCT result.id,result.uid,result.timeorder,result.year,result.month,result.day,result.hour,result.minute,result.title,result.content,result.randomType,result.musicName,result.countNumber,result.isOther,result.keyStatus,result.gidStr,result.fidStr,result.isOn ,result.isLook,result.createTime ,result.isTop ,result.localInfo,result.headUrlStr ,result.weekStr,result.isSave,result.friendName,result.groupName,result.audioPathStr,result.audioDurationStr,result.longitudeStr,result.latitudeStr,result.offsetMinute from (select s.id,s.uid,s.timeorder,s.year,s.month,s.day,s.hour,s.minute,s.title,s.content,s.randomType,case when o.musicName is null then s.musicName when o.musicName is not null then o.musicName end musicName,s.countNumber,s.isOther,s.keyStatus,s.gidStr,s.fidStr,case when o.status is null then 1 when o.status is not null then o.status end isOn ,s.isLook ,s.createTime ,s.isTop ,s.localInfo,s.headUrlStr ,s.weekStr,s.isSave,s.friendName,s.groupName,s.audioPathStr,s.audioDurationStr,s.longitudeStr,s.latitudeStr,s.offsetMinute,f.remark_name remark_name from saveIncident s left join openList o on s.uid = o.mid and o.userID = '%@' left join saveFriend f on s.fidStr like '%%' + f.fid + '%%'  union all select l.id,'' uid,l.timeorder,l.year,l.month,l.day,l.hour,l.minute,l.title,l.content,l.randomType,l.musicName,l.countNumber,l.isOther,0 keyStatus,l.gidStr,l.fidStr,l.isOn ,'',l.createTime ,l.isTop ,l.localInfo,l.headUrlStr ,l.weekStr,l.isSave,l.friendName,l.groupName,l.audioPathStr,l.audioDurationStr,l.longitudeStr,l.latitudeStr,l.offsetMinute,f.remark_name remark_name from localList l left join saveFriend f on l.fidStr like '%%' + f.fid + '%%'  where userID = '%@' ) result where (content like \'%%%@%%\' or title like \'%%%@%%\' or timeorder like \'%%%@%%\' or friendName like \'%%%@%%\' or groupName like \'%%%@%%\' or title like \'%%%@%%\' or remark_name like \'%%%@%%\') and (isOther = 0) order by isTop desc,isLook desc ,timeorder desc",userID,userID,text,text,text,text,text,text,text];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            NSString *timeOR = [self nowDay];

            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                // id,uid ,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,keyStatus,gidStr,fidStr
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
                char *gidStr = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr = (char *)sqlite3_column_text(stmt, 16);
                int isOn = sqlite3_column_int(stmt, 17);
                int isLook = sqlite3_column_int(stmt, 18);
                char *createTime = (char *)sqlite3_column_text(stmt,19);
                char *isTop = (char *)sqlite3_column_text(stmt, 20);
                char *localInfo = (char *)sqlite3_column_text(stmt, 21);
                char *headUrlStr = (char *)sqlite3_column_text(stmt, 22);
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
                
                if (gidStr == NULL) {
                    
                    gidStr = "";
                }
                
                if (fidStr == NULL) {
                    
                    fidStr = "";
                }
                
                if (headUrlStr == NULL) {
                    
                    headUrlStr = "";
                }
                
                if (localInfo == NULL) {
                    
                    localInfo = "";
                }
                
                if (weekStr == NULL) {
                    
                    weekStr = "";
                }
                
                if (audioPathStr == NULL) {
                    
                    audioPathStr = "";
                }
                if (audioDurationStr == NULL) {
                    
                    audioDurationStr = "";
                }
                if (longitudeStr == NULL) {
                    
                    longitudeStr = "";
                }
                if (latitudeStr == NULL) {
                    
                    latitudeStr = "";
                }

                
                
                NSString *timeOrder = [NSString stringWithUTF8String:timeOrder_C];
                NSString *title = [NSString stringWithUTF8String:title_C];
                NSString *content = [NSString stringWithUTF8String:content_C];
                
                
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
                model.gidStr = [NSString stringWithUTF8String:gidStr];   //不给值有nil，不好判断
                model.fidStr = [NSString stringWithUTF8String:fidStr];
                model.isOn = isOn;
                model.isLook = isLook;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.isTop = [NSString stringWithUTF8String:isTop];
                model.headUrlStr = [NSString stringWithUTF8String:headUrlStr];
                model.localInfo = [NSString stringWithUTF8String:localInfo];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.isSave = isSave;
                model.audioPathStr = [NSString stringWithUTF8String:audioPathStr];
                model.audioDurationStr = [NSString stringWithUTF8String:audioDurationStr];
                model.longitudeStr = [NSString stringWithUTF8String:longitudeStr];
                model.latitudeStr = [NSString stringWithUTF8String:latitudeStr];
                model.offsetMinute = offsetMinute;
                
                [model setSystemTime];
                
                if (model.musicName == 0) {
                    
                    model.isOn = 0;
                }
                
                long long selectTime = [model.timeorder longLongValue];
                
                if ([timeOR longLongValue] >= selectTime) {
                    
                    model.isRemind = YES;
                }
                
                [arrForData addObject:model];
                
            }
            
            sqlite3_finalize(stmt);
            sqlite3_close(xiaomiDb.dataBase);
            
        }

        return arrForData;
        
    }else {
        
        sqlite3_close(xiaomiDb.dataBase);
        return nil;
    }
    
    
}

#pragma mark 查询本地数据方法
- (NSArray *)selectAllLocalDataWithUserID:(int )userID
{
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    
    if ([xiaomiDb openDB]) {
        
        
        
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM localList  where userID = '%d'",userID];
       
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
        NSMutableArray *arrForAllModel = [NSMutableArray array];
        
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                //ID INTEGER PRIMARY KEY AUTOINCREMENT,timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,userID int,fidStr text,gidStr text,isOn int,createTime text, isTop text,localInfo text, headUrlStr text,weekStr text,friendName text,groupName text
                int oid = sqlite3_column_int(stmt, 0);
                //int uid = sqlite3_column_int(stmt, 1);
                char *timeOrder_C = (char *)sqlite3_column_text(stmt, 1);
                int year = sqlite3_column_int(stmt, 2);
                int month = sqlite3_column_int(stmt, 3);
                int day = sqlite3_column_int(stmt, 4);
                int hour = sqlite3_column_int(stmt, 5);
                int minute = sqlite3_column_int(stmt, 6);
                char *title_C =  (char *)sqlite3_column_text(stmt, 7);
                char *content_C = (char *)sqlite3_column_text(stmt, 8);
                int randomType = sqlite3_column_int(stmt, 9);
                int musicName = sqlite3_column_int(stmt, 10);
                int countNumber = sqlite3_column_int(stmt, 11);
                int isOther = sqlite3_column_int(stmt, 12);
                int keyStatus = sqlite3_column_int(stmt, 13);
                //userID
                char *fidStr = (char *)sqlite3_column_text(stmt, 15);
                char *gidStr = (char *)sqlite3_column_text(stmt, 16);
                int isOn = sqlite3_column_int(stmt, 17);
                char *createTime = (char *)sqlite3_column_text(stmt, 18);
                char *weekStr = (char *)sqlite3_column_text(stmt, 22);
                if (title_C == NULL) {
                    
                    title_C = "";
                }
                
                if (content_C == NULL) {
                    
                    content_C = "";
                }
                
                if (gidStr == NULL) {
                    
                    gidStr = "";
                }
                
                if (fidStr == NULL) {
                    
                    fidStr = "";
                }
                
                
                
                NSString *timeOrder = [NSString stringWithUTF8String:timeOrder_C];
                NSString *title = [NSString stringWithUTF8String:title_C];
                NSString *content = [NSString stringWithUTF8String:content_C];
                
                
                model.oid = oid;
                model.uid = 0;
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
                model.gidStr = [NSString stringWithUTF8String:gidStr];   //不给值有nil，不好判断
                model.fidStr = [NSString stringWithUTF8String:fidStr];
                model.isOn = isOn;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                if (model.musicName == 0) {
                    
                    model.isOn = 0;
                }
                
                [arrForAllModel addObject:model];
                
            }
            
        }
        
        
        sqlite3_finalize(stmt);
        sqlite3_close(xiaomiDb.dataBase);
        
        return arrForAllModel;
        
    }else{
        
        sqlite3_close(xiaomiDb.dataBase);
        
        return nil;
    }
    
    
}

#pragma mark 查询所有数据方法
- (NSArray *)selectAllDataWithUserID:(int )userID
{
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    
    if ([xiaomiDb openDB]) {
        
        
        
        //    NSString *sqlSelect = [NSString stringWithFormat:@"SELECT * FROM localList WHERE userID = '%d' order by timeorder",userID];
        
        NSString *sqlSelect = [NSString stringWithFormat:@"select * from (select s.id,s.uid,timeorder,year,month,day,hour,minute,title,content,randomType,case when o.musicName is null then s.musicName when o.musicName is not null then o.musicName end musicName,countNumber,isOther,keyStatus,gidStr,fidStr,case when o.status is null then 1 when o.status is not null then o.status end isOn ,isLook ,createTime ,isTop, localInfo,headUrlStr ,weekStr,isSave,audioPathStr,audioDurationStr from saveIncident s left join openList o on s.uid = o.mid and o.userID = '%d' union all select id,'' uid,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,0 keyStatus,gidStr,fidStr,isOn ,'',createTime ,isTop, localInfo,headUrlStr ,weekStr,isSave,audioPathStr,audioDurationStr,offsetMinute from localList where userID = '%d' ) order by isLook desc, keyStatus desc,timeorder desc",userID,userID];
        
        
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
        NSMutableArray *arrForAllModel = [NSMutableArray array];
        
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                // id,uid ,timeorder,year,month,day,hour,minute,title,content,randomType,musicName,countNumber,isOther,keyStatus,gidStr,fidStr
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
                char *gidStr = (char *)sqlite3_column_text(stmt, 15);
                char *fidStr = (char *)sqlite3_column_text(stmt, 16);
                int isOn = sqlite3_column_int(stmt, 17);
                int isLook = sqlite3_column_int(stmt, 18);
                char *createTime = (char *)sqlite3_column_text(stmt,19);
                char *isTop = (char *)sqlite3_column_text(stmt, 20);
                char *localInfo = (char *)sqlite3_column_text(stmt, 21);
                char *headUrlStr = (char *)sqlite3_column_text(stmt, 22);
                char *weekStr = (char *)sqlite3_column_text(stmt, 23);
                int  isSave = sqlite3_column_int(stmt, 24);
                char *audioPathStr = (char *)sqlite3_column_text(stmt, 25);
                char *audioDurationStr = (char *)sqlite3_column_text(stmt, 26);
                int  offsetMinute = sqlite3_column_int(stmt, 27);
                
                if (title_C == NULL) {
                    
                    title_C = "";
                }
                
                if (content_C == NULL) {
                    
                    content_C = "";
                }
                
                if (gidStr == NULL) {
                    
                    gidStr = "";
                }
                
                if (fidStr == NULL) {
                    
                    fidStr = "";
                }
                
                if (headUrlStr == NULL) {
                    
                    headUrlStr = "";
                }
                
                if (localInfo == NULL) {
                    
                    localInfo = "";
                }
                
                if (weekStr == NULL) {
                    
                    weekStr = "";
                }
                
                if (audioPathStr == NULL) {
                    
                    audioPathStr = "";
                }
                if (audioDurationStr == NULL) {
                    
                    audioDurationStr = "";
                }
                NSString *timeOrder = [NSString stringWithUTF8String:timeOrder_C];
                NSString *title = [NSString stringWithUTF8String:title_C];
                NSString *content = [NSString stringWithUTF8String:content_C];
                
                
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
                model.gidStr = [NSString stringWithUTF8String:gidStr];   //不给值有nil，不好判断
                model.fidStr = [NSString stringWithUTF8String:fidStr];
                model.isOn = isOn;
                model.isLook = isLook;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.isTop = [NSString stringWithUTF8String:isTop];
                model.isShare = 0;
                model.headUrlStr = [NSString stringWithUTF8String:headUrlStr];
                model.localInfo = [NSString stringWithUTF8String:localInfo];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.isSave = isSave;
                model.audioPathStr = [NSString stringWithUTF8String:audioPathStr];
                model.audioDurationStr = [NSString stringWithUTF8String:audioDurationStr];
                model.offsetMinute = offsetMinute;
                
                if (model.musicName == 0) {
                    
                    model.isOn = 0;
                }
                
                
                [arrForAllModel addObject:model];
                
            }
            
        }
        
        
        sqlite3_finalize(stmt);
        sqlite3_close(xiaomiDb.dataBase);
        
        NSMutableArray *returnArr = [NSMutableArray array];
        //排序：待提醒关键人，待提醒无关键人；已提醒关键人，已提醒无关键人
        
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
        
        //未提醒
        int haveLookNumber = 0;
        for (int i = 0; i < arrForAllModel.count; i++) {
            
            RemindModel *model = arrForAllModel[i];
            
            long long selectTime = [model.timeorder longLongValue];
            
            //NSLog(@"当前:%lld",[timeOR longLongValue]);
            //NSLog(@"")
            
            if ([timeOR longLongValue] < selectTime) {
                
                [returnArr addObject:model];
            }
            
            if (model.isLook) {
                
                haveLookNumber++;
            }
            
        }
        
        //已提醒
        for (int i = 0; i < arrForAllModel.count; i++) {
            
            RemindModel *model = arrForAllModel[i];
            
            long long selectTime = [model.timeorder longLongValue];
            
            if ([timeOR longLongValue] >= selectTime) {
                
                [returnArr addObject:model];
            }
            
        }
        
        
        return returnArr;
        
    }else{
        
        return nil;
    }
    
    
}


#pragma mark 更改数据
- (BOOL)upDataWithModel:(RemindModel *)model
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    if ([data openDB]) {
        
        //localInfo text, headUrlStr text,weekStr text,friendName text,groupName text
        NSString *sql = [NSString stringWithFormat:@"update localList set timeorder = '%@', year = '%d', month = '%d', day = '%d', hour = '%d', minute = '%d', title = '%@', content = '%@', randomType = '%d', musicName = '%d', countNumber = '%d',isOther = '%d',isOn = '%d' ,isTop = '%@', localInfo = '%@',headUrlStr = '%@', weekStr = '%@' ,isSave = '%d',audioPathStr = '%@',audioDurationStr = '%@',offsetMinute = '%ld' where id = '%d'",model.timeorder,model.year,model.month,model.day,model.hour,model.minute,model.title,model.content,model.randomType,model.musicName,model.countNumber,model.isOther,model.isOn,model.isTop,model.localInfo,model.headUrlStr,model.weekStr,model.isSave,model.audioPathStr,model.audioDurationStr,model.offsetMinute,model.oid];
        
        
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
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        return NO;
        
    }else{
        
        return NO;
    }
    
    
}

#pragma mark 刷新列表tab角标---废弃不用了，逻辑合并到了-getUnreadRemindData中，减少一次查询
- (void)refreshNumberLabelForAllRemind{
    //设置icon 角标
    JYNotReadList *notReadList = [JYNotReadList shareNotReadList];
    [notReadList selectNotReadRemind];
    
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
    
        if ([xiaomiDb openDB]) {
            
            NSString *sql = [NSString stringWithFormat:@"select sum(a) from (select count(*) a from shareList where isLook = 1 union all select count(*) a from  saveIncident where isLook = 1)"];
            
            sqlite3_stmt *stmt = nil;
            
            int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sql UTF8String], -1, &stmt, NULL);
            if (result == SQLITE_OK) {
                if (sqlite3_step(stmt) == SQLITE_ROW) {
                    int sumCount = sqlite3_column_int(stmt, 0);
                    
                    sqlite3_finalize(stmt);
                    sqlite3_close(xiaomiDb.dataBase);
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        id jytabBarVc = [UIApplication sharedApplication].delegate.window.rootViewController;
                        if([jytabBarVc isKindOfClass:[RootTabViewController class]]){
                            if(sumCount>0){
                                ((RootTabViewController *)jytabBarVc).tabBar.items[1].badgeValue = [NSString stringWithFormat:@"%d",sumCount];
                            }else{
                                ((RootTabViewController *)jytabBarVc).tabBar.items[1].badgeValue = nil;
                            }
                        }
                        
//                    });
                    
                }
            }
        }
//    });
}

#pragma mark 获取提醒列表未读数

- (NSDictionary *)getUnreadRemindData{
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    int acceptCount,shareCount,systemCount,sumCount;
    if ([xiaomiDb openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"select sum(a),sum(b),sum(c) from (select count(*) a,0 b,0 c from saveIncident sa where sa.isLook=1 and  sa.weekStr != '100' and sa.weekStr != '101'  union all select 0 a,count(*) b,0 c from shareList sh where sh.isLook=1 union all select 0 a,0 b,count(*) c from saveIncident sa1 where sa1.isLook=1 and (sa1.weekStr = '100' or sa1.weekStr='101'))"];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sql UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                acceptCount = sqlite3_column_int(stmt, 0);
                shareCount = sqlite3_column_int(stmt, 1);
                systemCount = sqlite3_column_int(stmt, 2);
                
                sqlite3_finalize(stmt);
                sqlite3_close(xiaomiDb.dataBase);
            }
        }
    }
    //防止出现显示 1297938880的bug(无法复现)
    acceptCount = acceptCount>10000?0:acceptCount;
    shareCount = shareCount>10000?0:shareCount;
    systemCount = systemCount>10000?0:systemCount;
    sumCount = acceptCount+shareCount+systemCount;
    
    //设置tabbar未读角标
    id jytabBarVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([jytabBarVc isKindOfClass:[RootTabViewController class]]){
        if(sumCount>0){
            ((RootTabViewController *)jytabBarVc).tabBar.items[1].badgeValue = [NSString stringWithFormat:@"%d",sumCount];
        }else{
            ((RootTabViewController *)jytabBarVc).tabBar.items[1].badgeValue = nil;
        }
    }
    return @{kUnreadAcceptKey:@(acceptCount),kUnreadShareKey:@(shareCount),kUnreadSystemKey:@(systemCount),kUnreadAllKey:@(acceptCount+shareCount+systemCount)};
}

#pragma mark 删除本地语音文件

- (void)deleteLocalAudioFileWithPathStr:(NSString *)pathStr
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    if([pathStr length]>0){
        NSArray *audioPathArr = [pathStr componentsSeparatedByString:@","];
        if([audioPathArr count]>0){
            for (int i = 0; i < [audioPathArr count]; i ++) {
                NSString *tmpPath = audioPathArr[i];
                if([tmpPath length]>0){
                    NSString *fullPath = [path stringByAppendingPathComponent:tmpPath];
                    if([fileManager fileExistsAtPath:fullPath]){
                        NSError *error;
                        [fileManager removeItemAtPath:fullPath error:&error];
                        NSLog(@"fullPath:%@",fullPath);
                        if(error){
                            NSLog(@"delete Local Audio file error:%@",error.localizedDescription);
                        }
                    }                    
                }
            }
        }
    }
}
@end
