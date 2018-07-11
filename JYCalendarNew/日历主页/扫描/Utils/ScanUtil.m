//
//  ScanUtil.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/25.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ScanUtil.h"
#import "FCFileManager.h"
#import "XiaomiDB.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
@implementation ScanUtil

+ (instancetype)sharedInstance
{
    static ScanUtil *instance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
//        NSString *path = [FCFileManager pathForDocumentsDirectoryWithPath:@"scan"];
//        if(![FCFileManager existsItemAtPath:path]){
//            [FCFileManager createDirectoriesForPath:path];
//        }
//        instance.workDirectory = path;
    });
    
    return instance;
}

- (NSDateFormatter *)dateFormatterForDirectoryCell
{
    if(!_dateFormatterForDirectoryCell){
        _dateFormatterForDirectoryCell = [NSDateFormatter new];
        _dateFormatterForDirectoryCell.dateFormat = @"yyyy/MM/dd";
    }
    return _dateFormatterForDirectoryCell;
}
- (NSDateFormatter *)dateFormatterForStorage
{
    if(!_dateFormatterForStorage){
        _dateFormatterForStorage = [NSDateFormatter new];
        _dateFormatterForStorage.dateFormat = @"yyyy-MM-dd MM:mm:ss.S";
    }
    return _dateFormatterForStorage;
}

//- (ScanDirectory *)createNewScanDirectory
//{
//    
//    //计算文件夹名称
//    NSArray *dirs = [FCFileManager listDirectoriesInDirectoryAtPath:self.workDirectory];
//    int index = 1;
//    NSString *name = [NSString stringWithFormat:@"目录%d",index];
//    while ([dirs containsObject:name]) {
//        index ++;
//        name = [NSString stringWithFormat:@"目录%d",index];
//    }
//    
//    //生成文件夹对象
//    ScanDirectory *dir = [ScanDirectory new];
//    dir.userId = [[NSUserDefaults standardUserDefaults]integerForKey:@"kUserId"];
//    dir.name = name;
//    dir.createdTime = [NSDate date];
//    dir.dirId = index;
//    //创建新文件夹
//    [FCFileManager createDirectoriesForPath:[self.workDirectory stringByAppendingPathComponent:name]];
//    
//    //数据库保存文件夹对象
//    [self insertNewScanDirectory:dir];
//    return dir;
//}
//
//- (ScanFile *)savePhotoData:(NSData *)photoData inDirectory:(ScanDirectory *)dir
//{
//    //计算文件名
//    NSArray *files = [FCFileManager listFilesInDirectoryAtPath:[self.workDirectory stringByAppendingPathComponent:dir.name]];
//    int index = 1;
//    NSString *name = [NSString stringWithFormat:@"文件%d",index];
//    while ([files containsObject:name]) {
//        index ++;
//        name = [NSString stringWithFormat:@"文件%d",index];
//    }
//
//    //生成文件对象
//    ScanFile *item = [ScanFile new];
//    item.imageData = photoData;
//    item.createdTime = [NSDate date];
//    item.dirId = dir.dirId;
//    item.name = name;
//    
//    //保存图片数据到文件夹
//    NSString *path = [[self.workDirectory stringByAppendingPathComponent:dir.name] stringByAppendingPathComponent:name];
//    [FCFileManager createFileAtPath:path withContent:photoData];
//    
//    //数据库保存文件对象
//    [self insertNewScanFile:item];
//    
//    return item;
//}
//


- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
#pragma mark - DB method

#pragma mark 重置所有数据
- (BOOL)resetAllData:(NSArray *)dataArray
{
    [self deleteAllDirectoryData];
    [self deleteAllFiles];
    
    for(int i=0;i<[dataArray count];i++){
        ScanDirectory *dir = dataArray[i];
        [self insertNewScanDirectory:dir];
        for(int j=0;j<[dir.files count];j++){
            [self insertNewScanFile:dir.files[j]];
        }
    }
    return NO;
}

#pragma mark 查询数据

- (NSArray *)findAllDirsWithUserId:(NSInteger)userID
{
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    
    if ([xiaomiDb openDB]) {
        
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT did,name,status,create_time,(select image_url from tb_scan_file where did = dir.did ORDER BY ROWID DESC LIMIT 1) as thumb_url,(select count(*) from tb_scan_file where did = dir.did) as file_count FROM tb_scan_directory dir where uid = '%ld'",userID];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
       
        NSMutableArray *arr = [NSMutableArray array];
        
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                int did = sqlite3_column_int(stmt, 0);
                char *name = (char *)sqlite3_column_text(stmt, 1);
                int status = sqlite3_column_int(stmt, 2);
                char *create_time = (char *)sqlite3_column_text(stmt, 3);
                char *thumb_url = (char *)sqlite3_column_text(stmt, 4);
                int count = sqlite3_column_int(stmt, 5);
                
                if (name == NULL) {
                    name = "";
                }
                if (create_time == NULL) {
                    create_time = "";
                }
                if (thumb_url == NULL) {
                    thumb_url = "";
                }
                NSString *dname = [NSString stringWithUTF8String:name];
                NSString *dtime = [NSString stringWithUTF8String:create_time];
                NSString *thumb = [NSString stringWithUTF8String:thumb_url];
                
                ScanDirectory *dir = [ScanDirectory new];
                dir.name = dname;
                dir.createdTime = [self.dateFormatterForStorage dateFromString:dtime];
                dir.status = status;
                dir.dirId = did;
                dir.thumbUrlStr = thumb;
                dir.fileCount = count;
                [arr addObject:dir];
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(xiaomiDb.dataBase);
        
        return arr;
        
    }else{
        
        sqlite3_close(xiaomiDb.dataBase);
        
        return nil;
    }
    
    return nil;
}
- (NSArray *)findAllFilesWithDirId:(NSInteger)dirId
{
    XiaomiDB *xiaomiDb = [XiaomiDB shareXiaomiDB];
    
    if ([xiaomiDb openDB]) {
        
        NSString *sqlSelect = [NSString stringWithFormat:@"SELECT fid,did,name,file_type,image_url,text_content,file_size,status,create_time FROM tb_scan_file where did = '%ld'",dirId];
        
        sqlite3_stmt *stmt = nil;
        
        int result = sqlite3_prepare_v2(xiaomiDb.dataBase, [sqlSelect UTF8String], -1, &stmt, NULL);
        
        NSMutableArray *arr = [NSMutableArray array];
        
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                int fid = sqlite3_column_int(stmt, 0);
                int did = sqlite3_column_int(stmt, 1);
                char *name = (char *)sqlite3_column_text(stmt, 2);
                int type = sqlite3_column_int(stmt, 3);
                char *image_url = (char *)sqlite3_column_text(stmt, 4);
                char *text_content = (char *)sqlite3_column_text(stmt, 5);
                char *file_size = (char *)sqlite3_column_text(stmt, 6);
                int status = sqlite3_column_int(stmt, 7);
                char *create_time = (char *)sqlite3_column_text(stmt, 8);
                
                if (name == NULL) {
                    name = "";
                }
                if (create_time == NULL) {
                    create_time = "";
                }
                if (image_url == NULL) {
                    image_url = "";
                }
                if (text_content == NULL) {
                    text_content = "";
                }
                if (file_size == NULL) {
                    file_size = "";
                }
                
                NSString *dname = [NSString stringWithUTF8String:name];
                NSString *dtime = [NSString stringWithUTF8String:create_time];
                NSString *imageUrl = [NSString stringWithUTF8String:image_url];
                NSString *content = [NSString stringWithUTF8String:text_content];
                NSString *fileSize = [NSString stringWithUTF8String:file_size];
                
                ScanFile *file = [ScanFile new];
                file.fileId = fid;
                file.dirId = did;
                file.name = dname;
                file.type = type;
                file.imageUrlStr = imageUrl;
                file.textContent = content;
                file.fileSize = fileSize;
                file.createdTime = [self.dateFormatterForStorage dateFromString:dtime];
                file.status = status;
                [arr addObject:file];
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(xiaomiDb.dataBase);
        
        return arr;
        
    }else{
        
        sqlite3_close(xiaomiDb.dataBase);
        
        return nil;
    }
    
    return nil;
}

#pragma mark 插入数据

- (BOOL)insertNewScanDirectory:(ScanDirectory *)dir
{
    if(!dir){
        return NO;
    }

    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *name = [dir.name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    if ([data openDB]) {
        NSString *time = [self.dateFormatterForStorage stringFromDate:dir.createdTime];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tb_scan_directory (did,uid,name,status,create_time) VALUES ('%ld','%ld','%@','%ld','%@')",dir.dirId,dir.userId,name,dir.status,time];
        
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"保存 失败:%d---%@",result,sql);
            return NO;
        }
        
        sqlite3_close(data.dataBase);

        return YES;
    }else{
        
        return NO;
    }

}
- (BOOL)insertNewScanFile:(ScanFile *)item
{
    if(!item){
        return NO;
    }
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *name = [item.name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *text = @"";
    if(![item.textContent isKindOfClass:[NSNull class]]){
        text = [item.textContent stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    }

    if ([data openDB]) {
        NSString *time = [self.dateFormatterForStorage stringFromDate:item.createdTime];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tb_scan_file (fid,did,name,file_type,image_url,text_content,file_size,status,create_time) VALUES ('%ld','%ld','%@','%ld','%@','%@','%@','%ld','%@')",item.fileId,item.dirId,name,item.type,item.imageUrlStr,text,item.fileSize,item.status,time];
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"保存 失败:%d---%@",result,sql);
            return NO;
        }
        
        sqlite3_close(data.dataBase);
        
        return YES;
    }else{
        return NO;
    }

}
#pragma mark 更新数据
- (BOOL)updateDirWithId:(NSInteger)did name:(NSString *)name
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *dname = [name stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"update tb_scan_directory set name = '%@' where did = '%ld' ",dname,did];
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"删除数据 失败:%d---%@",result,sql);
            return NO;
        }
        
        sqlite3_close(data.dataBase);
        
        return NO;
        
    }else{
        
        return NO;
    }
}

#pragma mark 删除数据
- (BOOL)deleteDirectoriesWithDidStr:(NSString *)didStr
{
    if(!didStr){
        return NO;
    }
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        //待优化，用事物处理
        for(NSString *did in [didStr componentsSeparatedByString:@","]){
            
            NSString *sql = [NSString stringWithFormat:@"delete from tb_scan_directory where did = '%@' ",did];
            char *err;
            int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
            if (result != SQLITE_OK ) {
                NSLog(@"删除数据 失败:%d---%@",result,sql);
                return NO;
            }
        }
        
        sqlite3_close(data.dataBase);
        
        return NO;
        
    }else{
        
        return NO;
    }
}
- (BOOL)deleteFilesWithFidStr:(NSString *)fidStr
{
    if(!fidStr){
        return NO;
    }
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        //待优化，用事物处理
        for(NSString *fid in [fidStr componentsSeparatedByString:@","]){
            
            NSString *sql = [NSString stringWithFormat:@"delete from tb_scan_file where fid = '%@' ",fid];
            char *err;
            int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
            if (result != SQLITE_OK ) {
                NSLog(@"删除数据 失败:%d---%@",result,sql);
                return NO;
            }
        }
        
        sqlite3_close(data.dataBase);
        
        return NO;
        
    }else{
        
        return NO;
    }
}
- (BOOL)deleteAllDirectoryData
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from tb_scan_directory"];
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"删除数据 失败:%d---%@",result,sql);
            return NO;
        }
        
        sqlite3_close(data.dataBase);

        return NO;
    
    }else{
        
        return NO;
    }
}
- (BOOL)deleteAllFiles
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from tb_scan_file"];
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"删除数据 失败:%d---%@",result,sql);
            return NO;
        }
        sqlite3_close(data.dataBase);
        
        return YES;
    }else{
        
        return NO;
    }

}
@end
