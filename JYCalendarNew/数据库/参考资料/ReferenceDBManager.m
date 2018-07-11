//
//  ReferenceDBManager.m
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/8.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ReferenceDBManager.h"

static ReferenceDBManager *sharedManager;
static sqlite3 *dataBase;

@implementation ReferenceDBManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (sharedManager == nil) {
            sharedManager = [[ReferenceDBManager alloc] init];
        }
    });
    return sharedManager;
}

- (sqlite3 *)openDB
{
    if(dataBase){
        return dataBase;
    }
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"reference" ofType:@"sqlite"];
    
    sqlite3_open([dataPath UTF8String], &dataBase);
    return dataBase;
}

- (void)closeDB
{
    sqlite3_close(dataBase);
    dataBase = nil;
}

- (NSString *)queryFoDetailWithName:(NSString *)name
{
    sqlite3 *db = [self openDB];
    if([name isEqualToString:@"释迦牟尼佛出家日"] || [name isEqualToString:@"释迦牟尼佛涅磐日"]){
        name = @"释迦牟尼";
    }else if([name isEqualToString:@"观世音菩萨成道日"] || [name isEqualToString:@"观世音菩萨出家日"]){
        name = @"观音菩萨";
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT content FROM tb_fo where name = '%@' ",name];
    
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    
    NSString *rtnStr = @"";
    
    if (result == SQLITE_OK) {
        if(sqlite3_step(stmt) == SQLITE_ROW) {
            char *detail = (char *)sqlite3_column_text(stmt, 0);
            rtnStr = [NSString stringWithUTF8String:detail];
            sqlite3_finalize(stmt);
        }else{
            sqlite3_finalize(stmt);
        }
    }else{
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    
    return rtnStr;
}

- (NSString *)queryFestivalDetailWithName:(NSString *)name
{
    sqlite3 *db = [self openDB];
    NSString *sql = [NSString stringWithFormat:@"SELECT content FROM tb_festival where name = '%@' ",name];
    
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL);
    
    NSString *rtnStr = @"";
    
    if (result == SQLITE_OK) {
        if(sqlite3_step(stmt) == SQLITE_ROW) {
            char *detail = (char *)sqlite3_column_text(stmt, 0);
            rtnStr = [NSString stringWithUTF8String:detail];
            sqlite3_finalize(stmt);
        }else{
            sqlite3_finalize(stmt);
        }
    }else{
        sqlite3_finalize(stmt);
    }
    
    [self closeDB];
    
    return rtnStr;
}
@end
