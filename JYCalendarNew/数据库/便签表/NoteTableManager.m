//
//  NoteTableManager.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/27.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "NoteTableManager.h"
#import "JYNote.h"
#import "JYNoteImage.h"

@interface NoteTableManager()
@property (nonatomic,strong) NSDateFormatter *gmtDateFormat;
@end
@implementation NoteTableManager

+ (instancetype)sharedManager
{
    static NoteTableManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[NoteTableManager alloc] init];
        }
    });
    return instance;
}

#pragma mark 查询数据
- (BOOL)ifNoteHasExistWithTid:(NSString *)tid
{
    if(!tid){
        return NO;
    }
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    if ([data openDB]) {
        NSString *sql = [NSString stringWithFormat:@"SELECT count(id) FROM tb_note where uid=\'%@\' and tid = \'%@\'",userID,tid];
        sqlite3_stmt *stmt;
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);

        if (result == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_ROW) {
                
                int  count = (int )sqlite3_column_int(stmt, 0);
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                if(count>0){
                    return YES;
                }else{
                    return NO;
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

- (NSArray *)findAllNotes
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"SELECT id,tid,title,content,create_time,image_path_local,image_path_remote,update_time,sync_time FROM tb_note where uid = \'%@\' order by update_time desc",userID];
        
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        NSMutableArray *notes = [NSMutableArray array];
        if (result == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                JYNote *note = [[JYNote alloc] init];
                
                int  nid = (int )sqlite3_column_int(stmt, 0);
                char *tid = (char *)sqlite3_column_text(stmt, 1);
                char *title = (char *)sqlite3_column_text(stmt, 2);
                char *content = (char *)sqlite3_column_text(stmt, 3);
                char *createTime = (char *)sqlite3_column_text(stmt, 4);
                char *imagePathLocal = (char *)sqlite3_column_text(stmt, 5);
                char *imagePathRemote = (char *)sqlite3_column_text(stmt, 6);
                char *updateTime = (char *)sqlite3_column_text(stmt, 7);
                char *syncTime = (char *)sqlite3_column_text(stmt, 8);
                
                note.nId = nid;
                NSString *tId = [NSString stringWithUTF8String:tid];
                if(![tId isEqualToString:@"(null)"]){
                    note.tId = tId;
                }
                note.title = [NSString stringWithUTF8String:title];
                note.content = [NSString stringWithUTF8String:content];
                note.createTime = [self.gmtDateFormat dateFromString:[NSString stringWithUTF8String:createTime]];
                note.imagePathLocal = [NSString stringWithUTF8String:imagePathLocal];
                NSString *imgPathRemote = [NSString stringWithUTF8String:imagePathRemote];
                if(![imgPathRemote isEqualToString:@"(null)"]){
                    note.imagePathRemote = imgPathRemote;
                }
                note.updateTime = [self.gmtDateFormat dateFromString:[NSString stringWithUTF8String:updateTime]];
                note.syncTime = [self.gmtDateFormat dateFromString:[NSString stringWithUTF8String:syncTime]];
                [notes addObject:note];
            }
            sqlite3_finalize(stmt);
            sqlite3_close(data.dataBase);
            return notes;
        }
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        return nil;
        
    }else{
        return nil;
    }
}
- (NSArray *)findAllImagesOfNote:(JYNote *)note
{
    
    NSMutableArray *muArr = [NSMutableArray new];

    NSArray *remotePaths = [note.imagePathRemote componentsSeparatedByString:@","];
    for(int i=0;i<[remotePaths count];i++){
        NSString *path = remotePaths[i];
        if(path.length>0&&[path hasPrefix:@"http"]){
            JYNoteImage *image = [JYNoteImage new];
            image.imageType = JYImageTypeRemote;
            image.path = path;
            [muArr addObject:image];
        }
    }
    NSArray *localPaths = [note.imagePathLocal componentsSeparatedByString:@","];
    for(int i=0;i<[localPaths count];i++){
        NSString *path = localPaths[i];
        if(path.length>0&&![path hasPrefix:@"http"]){
            JYNoteImage *image = [JYNoteImage new];
            image.imageType = JYImageTypeLocal;
            image.path = path;
            image.hasSaved = YES;
            NSArray *pathcaches = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString* cacheDirectory  = [pathcaches objectAtIndex:0];
            NSString *imgPath = [cacheDirectory stringByAppendingPathComponent:path];
            image.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
            [muArr addObject:image];
        }
    }
    
    return muArr;
}

#pragma mark 插入数据
- (BOOL)insertNoteByLocal:(JYNote *)note
{
    if(!note){
        return NO;
    }
    if([note.images count]>0){        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self saveNoteImages:note];
        });
    }
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *title = [note.title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *content = [note.content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tb_note(uid,tid,title,content,create_time,image_path_local,image_path_remote,update_time,sync_time) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",userID,note.tId,title,content,[self.gmtDateFormat stringFromDate:note.createTime],note.imagePathLocal,note.imagePathRemote,[self.gmtDateFormat stringFromDate:note.updateTime],[self.gmtDateFormat stringFromDate:note.syncTime]];
        
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"保存note 失败:%d---%@",result,sql);
            return NO;
        }
        
        sqlite3_close(data.dataBase);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForReloadNoteList object:nil];
        });
        return YES;
    }else{
        
        return NO;
    }
}
- (BOOL)insertNoteBySync:(JYNote *)note
{
    if(!note){
        return NO;
    }
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *title = [note.title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *content = [note.content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO tb_note(uid,tid,title,content,create_time,image_path_local,image_path_remote,update_time,sync_time) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@')",userID,note.tId,title,content,[self.gmtDateFormat stringFromDate:note.createTime],note.imagePathLocal,note.imagePathRemote,[self.gmtDateFormat stringFromDate:note.updateTime],[self.gmtDateFormat stringFromDate:note.syncTime]];
        
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"保存note 失败:%d---%@",result,sql);
            return NO;
        }
        
        sqlite3_close(data.dataBase);
        return YES;
    }else{
        
        return NO;
    }
}
//保存图片
- (void)saveNoteImages:(JYNote *)note
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD show:@"保存中…"];
    });
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* cacheDirectory  = [paths objectAtIndex:0];
    for(int i=0;i<[note.images count];i++){
        JYNoteImage *jyImg = note.images[i];
        if(jyImg.imageType==JYImageTypeLocal&&jyImg.path.length>0&&!jyImg.hasSaved){
            
            NSString * imageName = @"";
            if(![jyImg.path containsString:cacheDirectory]){
                imageName = [cacheDirectory stringByAppendingPathComponent:jyImg.path];
            }else{
                imageName = jyImg.path;
            }
            NSString *dir = [imageName stringByDeletingLastPathComponent];
            NSFileManager *fileManager=[NSFileManager defaultManager];
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                if(![fileManager fileExistsAtPath:dir]){
                    [fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
                }
            });
            UIImage *image = [jyImg.image scaledToMaxSize:CGSizeMake(1024, 1024)];
            NSData * newImageData =  UIImageJPEGRepresentation(image, 0.7);
            [UIImageJPEGRepresentation([UIImage imageWithData:newImageData],0.7) writeToFile:imageName atomically:YES];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD dismiss];
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForPopNote object:nil];
    });
}
#pragma mark 更新数据
- (BOOL)updateNoteViaLocal:(JYNote *)note
{
    
    if([note.images count]>0){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            [self deleteOldNoteImages:note];
            [self saveNoteImages:note];
        });
    }
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *title = [note.title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *content = [note.content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];

    if ([data openDB]) {
        NSString *sql = [NSString stringWithFormat:@"update tb_note set tid='%@',title = '%@', content = '%@', update_time = '%@',sync_time = '%@',image_path_local='%@',image_path_remote='%@' where id = '%ld'",note.tId,title,content,[self.gmtDateFormat stringFromDate:note.updateTime],[self.gmtDateFormat stringFromDate:note.syncTime],note.imagePathLocal,note.imagePathRemote,note.nId];
        
        sqlite3_stmt *stmt ;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForReloadNoteList object:nil];
                });
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
- (BOOL)updateNoteViaSync:(JYNote *)note
{
    if(!note){
        return NO;
    }
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    NSString *title = [note.title stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    NSString *content = [note.content stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
    if ([data openDB]) {
        NSString *sql = [NSString stringWithFormat:@"update tb_note set title = '%@',content = '%@',image_path_local='%@',image_path_remote='%@',update_time='%@',sync_time='%@',tid='%@' where id = '%ld'",title,content,note.imagePathLocal,note.imagePathRemote,[self.gmtDateFormat stringFromDate:note.updateTime],[self.gmtDateFormat stringFromDate:note.syncTime],note.tId,note.nId];
        
        sqlite3_stmt *stmt ;
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForReloadNoteList object:nil];
                });
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
#pragma mark 删除数据
- (BOOL)deleteNote:(JYNote *)note
{
    [self deleteOldNoteImages:note];
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from tb_note where id = '%ld'",note.nId];
        char *err;
        
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result != SQLITE_OK ) {
            NSLog(@"删除数据 失败:%d---%@",result,sql);
            sqlite3_close(data.dataBase);
            return NO;
        }
        
        sqlite3_close(data.dataBase);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForReloadNoteList object:nil];
//        });
        return YES;
    }else{
        
        
        return NO;
    }
}
- (BOOL)deleteNotes:(NSArray *)notes
{
    BOOL flag;
    for(JYNote *note in notes){
        flag = [self deleteNote:note];
        if(!flag){
            return NO;
        }
    }
    return YES;
}
//删除note 存的图片
- (BOOL)deleteImagesAtPath:(NSString *)imgPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isFind = [manager fileExistsAtPath:imgPath];
    if(isFind){
        NSError *error;
        [manager removeItemAtPath:imgPath error:&error];
        if(error){
            NSLog(@"error:%@",error.localizedDescription);
            return NO;
        }
    }
    return YES;
}
- (BOOL)deleteOldNoteImages:(JYNote *)note
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* cacheDirectory  = [paths objectAtIndex:0];
    NSString *localPath = note.imagePathLocal;
    NSArray *tmpArr = [localPath componentsSeparatedByString:@","];
    for(int i=0;i<[tmpArr count];i++){
        NSString *path = tmpArr[i];
        if(path&&path.length>0){
            NSString *imgPath = [cacheDirectory stringByAppendingPathComponent:path];
            if(![self deleteImagesAtPath:imgPath]){
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark getter
- (NSDateFormatter *)gmtDateFormat
{
    if(!_gmtDateFormat){
        _gmtDateFormat = [NSDateFormatter new];
        [_gmtDateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        _gmtDateFormat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _gmtDateFormat;
}
@end
