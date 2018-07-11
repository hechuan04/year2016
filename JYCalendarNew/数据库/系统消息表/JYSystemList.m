//
//  JYSystemList.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSystemList.h"

static JYSystemList *systemList = nil;

@implementation JYSystemList

+ (JYSystemList *)shareList
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (systemList == nil) {
            
            systemList = [[JYSystemList alloc] init];
        }
        
    });

    return systemList;
}

- (NSArray *)selectAllModelWithStr:(NSString *)str
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
//        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM saveIncident where weekStr = '100'and (title like \'%%%@%%\' or (select fid from saveFriend where friend_name like \'%%%@%%\'))",str,str];
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM saveIncident where weekStr = '100' and (title like \'%%%@%%\' or friendName like \'%%%@%%\') or weekStr = '101' and (title like \'%%%@%%\' or friendName like \'%%%@%%\') order by isTop desc,isLook desc,keyStatus desc,createTime desc",str,str,str,str];
        
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        NSMutableArray *arrForModel = [NSMutableArray array];
        if (result == SQLITE_OK) {
            
            //ID INTEGER PRIMARY KEY AUTOINCREMENT,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text,isTop text,localInfo text, headUrlStr text,weekStr text
            //年 ：变更前id
            //月 ：变更前昵称
            //日 ：变更后id
            //时 ：变更后昵称
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                
                int uid = (int )sqlite3_column_int(stmt, 1);
                int year = (int)sqlite3_column_int(stmt, 3);
                int day  = (int )sqlite3_column_int(stmt, 5);
                char *title = (char *)sqlite3_column_text(stmt, 8);
                char *content = (char *)sqlite3_column_text(stmt, 9);
                int isOther = sqlite3_column_int(stmt, 13);
                int isLook = sqlite3_column_int(stmt, 17);
                char *createTime = (char *)sqlite3_column_text(stmt, 18);
                char *weekStr = (char *)sqlite3_column_text(stmt,22);
                char *fname = (char *)sqlite3_column_text(stmt,24);
                char *timerOrder = (char *)sqlite3_column_text(stmt, 2);
                
                
                NSLog(@"======%@",[NSString stringWithUTF8String:fname]);
                model.uid = uid;
                model.title = [NSString stringWithUTF8String:title];
                model.isOther = isOther;
                model.isLook = isLook;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                model.year = year;
                model.content = [NSString stringWithUTF8String:content];
                model.day = day;
                model.timeorder = [NSString stringWithUTF8String:timerOrder];
                [arrForModel addObject:model];
                
            }
            
        }
        
        
        return arrForModel;
        
    }else{
        
        return nil;
    }
    
}

- (NSArray *)selectAllModel
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM saveIncident where weekStr = '100' , weekStr = '101' order by isTop desc,isLook desc,keyStatus desc,timeorder desc"];
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        NSMutableArray *arrForModel = [NSMutableArray array];
        if (result == SQLITE_OK) {
            
            //ID INTEGER PRIMARY KEY AUTOINCREMENT,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text,isTop text,localInfo text, headUrlStr text,weekStr text
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                RemindModel *model = [[RemindModel alloc] init];
                
                int uid = (int )sqlite3_column_int(stmt, 1);
                char *title = (char *)sqlite3_column_text(stmt, 8);
                int isOther = sqlite3_column_int(stmt, 13);
                int isLook = sqlite3_column_int(stmt, 17);
                char *createTime = (char *)sqlite3_column_text(stmt, 18);
                char *weekStr = (char *)sqlite3_column_text(stmt,22);
                
                
                model.uid = uid;
                model.title = [NSString stringWithUTF8String:title];
                model.isOther = isOther;
                model.isLook = isLook;
                model.createTime = [NSString stringWithUTF8String:createTime];
                model.weekStr = [NSString stringWithUTF8String:weekStr];
                
                
                [arrForModel addObject:model];
                
            }
            
        }
        
        
        return arrForModel;
        
    }else{
     
        return nil;
    }
    
}

@end
