//
//  XiaomiDB.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/25.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "XiaomiDB.h"


static XiaomiDB *xiaomiDb = nil;

@implementation XiaomiDB

+ (XiaomiDB *)shareXiaomiDB
{
 
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        xiaomiDb = [[XiaomiDB alloc] init];
        
    });
    
    return xiaomiDb;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        xiaomiDb = [super allocWithZone:zone];
        
    });
    
    return xiaomiDb;
    
}

- (id)init
{
    if (self = [super init]) {
        
        //数据迁移
        [self dataTransfer];//放到数据调用 同步前
        [self openDB];
    }
    
    
    return xiaomiDb;
}
//从旧App升级过来的数据的迁移等处理方法
- (void)dataTransfer
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    
    //含有小秘id，并且app版本和build号与存储的不一致，说明进行了 升级操作。
    //4.0以前简单处理，直接删除掉数据库文件重建,后面版本更新需要考虑改变逻辑
    if([ud valueForKey:kUserXiaomiID]){
        
        if([@"4.1.6" compare:[ud valueForKey:kStoredAppVersion] options:0] == NSOrderedDescending){
            NSFileManager *manager = [NSFileManager defaultManager];
            NSString *path = self.filePath;
            BOOL isFind = [manager fileExistsAtPath:path];
            if(isFind){
                NSError *error;
                [manager removeItemAtPath:path error:&error];
                NSAssert(error==nil, @"删除旧数据出错！");
            }
            
        }
//            else if([@"4.1.1" compare:[ud valueForKey:kStoredAppVersion] options:0] == NSOrderedDescending){
//
////            if(sqlite3_open([self.filePath UTF8String], &_dataBase)== SQLITE_OK){
////                
////                char *sql = "ALTER TABLE tb_note ADD COLUMN update_time text";
////                sqlite3_stmt *stmt = nil;
////                sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
////                if(sqlite3_step(stmt)==SQLITE_DONE){
////                    NSLog(@"ok");
////                }
////                sqlite3_step(stmt);
////                sqlite3_finalize(stmt);
////            }
//            
//            [self openDB];
//            sqlite3_stmt *stmt;
//            
//            NSString *sql = [NSString stringWithFormat:@"drop table if exists tb_note"];
//            int result = sqlite3_prepare_v2(_dataBase, [sql UTF8String], -1, &stmt, NULL);
//            if (result == SQLITE_OK) {
//                if (sqlite3_step(stmt) == SQLITE_DONE) {
//                    NSLog(@"drop note table success!");
//                }
//            }
//            [self createNoteTable];
//        }
    }
    //将kStoredAppVersion置为最新版本
    if([kAppVersion compare:[ud valueForKey:kStoredAppVersion] options:0] != NSOrderedSame){
        [ud setValue:kAppVersion forKey:kStoredAppVersion];
        [ud synchronize];
    }
}

- (NSString *)filePath
{
    
    NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *pathStr = pathArr[0];
    
    
    return [pathStr stringByAppendingPathComponent:@"xiaomiDB.sqlite"];
}

- (BOOL)closeDB
{
    sqlite3_close(_dataBase);
 
    return YES;
}

- (BOOL)openDB
{
    
    NSString *path = [self filePath];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isFind = [manager fileExistsAtPath:path];
    
    if (isFind) {
        
        BOOL isOpen = sqlite3_open([path UTF8String], &_dataBase);
        
        if (isOpen == SQLITE_OK) {
            
//            sqlite3_close(_dataBase);
            return YES;
            
        }else{
            
            return NO;
        }
        
    }else{
     
        BOOL isOpen = sqlite3_open([path UTF8String], &_dataBase);
        
        [self createLocalList];
        
        [self createServerTable];
        
        [self createFriendList];
        
        [self createGroupList];
        
        [self createGroupRef];
        
        [self createOpenList];
        
        [self createCollectionList];
        
        [self createClockList];
        
        [self createShareList];
        
        [self createNoteTable];
        
        [self createPassWordList];
        
        [self createPassWordTitleList];
        
        [self createScanScanFileTable];
        [self createScanPhotoDirectoryTable];
        
        return isOpen;

    }

}

#pragma mark 密码页标题表
- (BOOL)createPassWordTitleList
{
    char *sql = "CREATE TABLE IF NOT EXISTS passWordTitleList(ID INTEGER PRIMARY KEY AUTOINCREMENT,title text,top text,mid int)";
    sqlite3_stmt *stmt= nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        
        return NO;
    }
    
    return YES;
}

#pragma mark 密码页详情表
- (BOOL)createPassWordList
{
    
    
    char *sql = "CREATE TABLE IF NOT EXISTS passWordList(ID INTEGER PRIMARY KEY AUTOINCREMENT ,mid int,type_id int,title text, userName text,passWord text,detail text,createTime text)";
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
        
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark 分享表
- (BOOL)createShareList
{
    
    char *sql = "CREATE TABLE IF NOT EXISTS shareList(ID INTEGER PRIMARY KEY AUTOINCREMENT ,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text, isTop text, isShare int, localInfo text, headUrlStr text,weekStr text,sid integer,isSave integer,friendName text,groupName text,audioPathStr text,audioDurationStr text,longitudeStr text,latitudeStr text,offsetMinute int)";
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark 闹钟表
- (BOOL)createClockList
{
    //"CREATE TABLE IF NOT EXISTS clockList(ID INTEGER PRIMARY KEY AUTOINCREMENT ,timeDescribe text,hour int, minute int ,isOn int,musicID int,week text,userID text, timeOrder text, textStr text)"
 
    char *sql = "CREATE TABLE IF NOT EXISTS clockList(ID INTEGER PRIMARY KEY AUTOINCREMENT ,timeDescribe text,year int,month int,day int,hour int, minute int ,isOn int,musicID int,week text,userID text, timeOrder text, textStr text)";
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        return NO;
    }
    
    return YES;
}

#pragma mark 开关关联表
- (BOOL)createOpenList
{
 
    
    char *sql = "CREATE TABLE IF NOT EXISTS openList(ID INTEGER PRIMARY KEY AUTOINCREMENT ,mid int,status int, musicName int,userID int)";
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {

        return NO;
        
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark 收藏列表
- (BOOL)createCollectionList
{
 
    char *sql = "CREATE TABLE IF NOT EXISTS collectionList(ID INTEGER PRIMARY KEY AUTOINCREMENT, oid integer,uid integer,timeorder text,year int,month int,day int,hour int,minute int,title text ,content text,randomType int ,musicName int ,countNumber int ,isOther int, keyStatus int, userID int ,fidStr text, gidStr text, isOn int, createTime text)";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        return NO;
    }
    
    return YES;
}



#pragma mark 创建本地提醒数据表
- (BOOL)createLocalList
{
    
    char *sql = "CREATE TABLE IF NOT EXISTS localList(ID INTEGER PRIMARY KEY AUTOINCREMENT,timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,userID int,fidStr text,gidStr text,isOn int,createTime text, isTop text,localInfo text, headUrlStr text,weekStr text,isSave integer,friendName text,groupName text,audioPathStr text,audioDurationStr text,longitudeStr text,latitudeStr text,offsetMinute int)";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark 创建远程数据表
- (BOOL)createServerTable
{
    
    
    
    char *sql = "CREATE TABLE IF NOT EXISTS saveIncident(ID INTEGER PRIMARY KEY AUTOINCREMENT,uid integer, timeorder text, year int, month int, day int, hour int, minute int, title text,content text, randomType int, musicName int, countNumber int, isOther int, keyStatus int ,gidStr text, fidStr text, isLook int,createTime text,isTop text,localInfo text, headUrlStr text,weekStr text,isSave integer,friendName text,groupName text,audioPathStr text,audioDurationStr text,longitudeStr text,latitudeStr text,offsetMinute int)";
    
    sqlite3_stmt *stmt;
    
    int sqlReturn = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (sqlReturn != SQLITE_OK) {
        
        
        return NO;
        
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark 创建好友表
- (BOOL)createFriendList
{
    
    char *sql = "CREATE TABLE IF NOT EXISTS saveFriend(ID INTEGER PRIMARY KEY AUTOINCREMENT,fid integer,friend_name text,head_url text,status int,tel_iphone text,keyStatus int,remark_name text,city text,sign text)";
    sqlite3_stmt *statement;
    
    int sqlReturn = sqlite3_prepare_v2(_dataBase, sql, -1, &statement, nil);
    
    if (sqlReturn != SQLITE_OK) {
        
        
        return NO;
    }
    
    int success = sqlite3_step(statement);
    
    sqlite3_finalize(statement);
    
    
    if (success != SQLITE_OK) {
        
        
        return NO;
    }
    
    return YES;
    
}

#pragma mark 创建组表
- (BOOL)createGroupList
{
    
    char *sql = "CREATE TABLE IF NOT EXISTS saveGroup(ID INTEGER PRIMARY KEY AUTOINCREMENT,group_name text ,gid integer,group_header text)";
    
    
    
    sqlite3_stmt *stmt = nil;
    
    int sqliteReturn = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, nil);
    
    if (sqliteReturn != SQLITE_OK ) {
        
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        return NO;
    }
    
    return YES;
    
}


- (BOOL)createGroupRef
{
    
    char *sql = "CREATE TABLE IF NOT EXISTS saveFriendForG(ID INTEGER PRIMARY KEY AUTOINCREMENT ,gid integer ,fid integer)";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
                
        return NO;
    }
    
    return YES;
}

- (BOOL)createNoteTable
{
    char *sql = "CREATE TABLE IF NOT EXISTS tb_note(ID INTEGER PRIMARY KEY AUTOINCREMENT,tid text,uid integer,title text,content text,create_time text,image_path_local text,image_path_remote text,update_time text,sync_time text)";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        return NO;
    }
    
    return YES;

}

- (BOOL)createScanPhotoDirectoryTable
{
    char *sql = "CREATE TABLE IF NOT EXISTS tb_scan_directory(ID INTEGER PRIMARY KEY AUTOINCREMENT,did integer,uid integer,name text,status text,create_time text)";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        return NO;
    }
    
    return YES;
    
}

- (BOOL)createScanScanFileTable
{
    char *sql = "CREATE TABLE IF NOT EXISTS tb_scan_file(ID INTEGER PRIMARY KEY AUTOINCREMENT,fid integer,did integer,name text,file_type int,image_url text,text_content text,file_size text,status integer,create_time text)";
    
    sqlite3_stmt *stmt = nil;
    
    int result = sqlite3_prepare_v2(_dataBase, sql, -1, &stmt, NULL);
    
    if (result != SQLITE_OK) {
        
        return NO;
    }
    
    int success = sqlite3_step(stmt);
    
    sqlite3_finalize(stmt);
    
    if (success != SQLITE_OK) {
        
        return NO;
    }
    
    return YES;
    
}

@end
