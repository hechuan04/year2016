//
//  PassWordTitleList.m
//  PassWord
//
//  Created by 吴冬 on 16/5/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PassWordTitleList.h"
static PassWordTitleList *passList = nil;
@implementation PassWordTitleList

+ (PassWordTitleList *)sharePassWordTitleList
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (passList == nil) {
            
            passList = [[PassWordTitleList alloc] init];
        }
        
    });
    
    return passList;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (passList == nil) {
            
            passList = [super allocWithZone:zone];
        }
        
    });
    
    return passList;
}

- (BOOL)insertDataWithModel:(PassWordTitleModel *)model
{
  // passWordTitleList(ID INTEGER PRIMARY KEY AUTOINCREMENT,title text,number text,top text
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        
        NSString *sql = [NSString stringWithFormat:@"insert into passWordTitleList(title,top,mid)values('%@','%@','%d')",model.title,model.top,model.mid];
        char *err;
        
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        if (result == SQLITE_OK) {
            
            sqlite3_close(data.dataBase);
            return YES;
            
        }else{
            
            sqlite3_close(data.dataBase);
            return NO;
        }
        
        
    }else{
        
        sqlite3_close(data.dataBase);
        return NO;
        
    }
    
}



- (NSArray *)selectData
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        //ID INTEGER PRIMARY KEY AUTOINCREMENT,title text,top text,mid int
        char *sql = "select count(type_id),t.id,t.mid ,t.title,t.top from passWordTitleList t left join passWordList p on t.mid = p.type_id group by t.id order by top desc";
        sqlite3_stmt *stmt = nil;
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
        
        NSMutableArray *arr = [NSMutableArray array];
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                int count = sqlite3_column_int(stmt, 0);
                int oid = sqlite3_column_int(stmt, 1);
                int mid = sqlite3_column_int(stmt, 2);
                char *title = (char *)sqlite3_column_text(stmt, 3);
                char *top = (char *)sqlite3_column_text(stmt, 4);
                
                PassWordTitleModel *model = [[PassWordTitleModel alloc] init];
                model.oid = oid;
                model.title = [NSString stringWithUTF8String:title];
                model.top = [NSString stringWithUTF8String:top];
                model.mid = mid;
                model.number = [NSString stringWithFormat:@"%d",count];
                [arr addObject:model];
                
            }
  
        }
        
        sqlite3_close(data.dataBase);
        sqlite3_finalize(stmt);
        
        return arr;
        
    }else{
     
        sqlite3_close(data.dataBase);
        return nil;
    }
    
    
}

- (BOOL)deleteWithModel:(PassWordTitleModel *)model
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from passWordTitleList where id = '%d'",model.oid];
        sqlite3_stmt *stmt = nil;
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                
                return YES;
                
            }
        
        }
        
        return YES;
        
    }else{
     
        return NO;
    }

}

- (BOOL)deleteAll
{
    
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        char *sql = "delete from passWordTitleList";
        sqlite3_stmt *stmt = nil;
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                
                return YES;
                
            }
            
        }
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}

- (BOOL)upWithModel:(PassWordTitleModel *)model
{
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"update passWordTitleList set title = '%@',top = '%@' where id = '%d'",model.title,model.top,model.oid];
        
        sqlite3_stmt *stmt = nil;
        
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
     
        sqlite3_close(data.dataBase);
        return NO;
    }
    
}










@end
