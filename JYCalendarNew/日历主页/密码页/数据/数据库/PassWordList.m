//
//  PassWordList.m
//  PassWord
//
//  Created by 吴冬 on 16/5/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PassWordList.h"

static PassWordList *passList = nil;

@implementation PassWordList

+ (PassWordList *)sharePassList
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (passList == nil) {
            
            passList = [[PassWordList alloc] init];
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


- (void)insertDataWithModel:(PassWordModel *)model
            completionBlock:(completionBlock)block
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        //ID INTEGER PRIMARY KEY AUTOINCREMENT ,type text,title text, userName text,passWord text,detail text,createTime text,userID text
        NSString *sql = [NSString stringWithFormat:@"insert into passWordList(mid,type_id,title,userName,passWord,detail,createTime)values ('%d','%d','%@','%@','%@','%@','%@')",model.mid,model.type_id,model.title,model.userName,model.passWord,model.detail,model.createTime];
        
        char *err;
        int result = sqlite3_exec(data.dataBase, [sql UTF8String], NULL, NULL, &err);
        
        if (result != SQLITE_OK) {
            
            sqlite3_close(data.dataBase);
            block(NO);
            
        }else{
         
            sqlite3_close(data.dataBase);
            block(YES);
        }
        
    }else{
        sqlite3_close(data.dataBase);

        block(NO);
    }
    
}

- (NSArray *)selectCountWithType:(NSArray *)typeArr
{
    NSMutableArray *mutableArr = [NSMutableArray array];
    for (int i = 0; i < typeArr.count; i++) {
        
       NSArray *arr = [self selectModelWithType:typeArr[i]];
        [mutableArr addObject:arr];
    }
    
    return mutableArr;
}

- (NSArray *)selectModelWithType:(int )mid{

    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
   // ID INTEGER PRIMARY KEY AUTOINCREMENT ,type_id int,title text, userName text,passWord text,detail text,createTime text
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"select * from passWordList where type_id = '%d' order by createTime desc",mid];
 
        sqlite3_stmt *stmt;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, nil);
        
        NSMutableArray *arrForModel = [NSMutableArray array];
        if (result == SQLITE_OK) {
            
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                
                //,type text,title text, userName text,passWord text,detail text,createTime text,userID text
                int oid = sqlite3_column_int(stmt, 0);
                int mid = sqlite3_column_int(stmt, 1);
                int type_id = sqlite3_column_int(stmt, 2);
                char *title = (char *)sqlite3_column_text(stmt, 3);
                char *userName = (char *)sqlite3_column_text(stmt, 4);
                char *passWord = (char *)sqlite3_column_text(stmt, 5);
                char *detail = (char *)sqlite3_column_text(stmt, 6);
                char *createTime = (char *)sqlite3_column_text(stmt, 7);
                
                PassWordModel *model = [[PassWordModel alloc] init];
                model.oid = oid;
                model.mid = mid;
                model.type_id = type_id;
                model.title = [NSString stringWithUTF8String:title];
                model.userName = [NSString stringWithUTF8String:userName];
                model.passWord = [NSString stringWithUTF8String:passWord];
                model.detail = [NSString stringWithUTF8String:detail];
                model.createTime = [NSString stringWithUTF8String:createTime];

                [arrForModel addObject:model];
            }
        }
        
        sqlite3_close(data.dataBase);
        
        return arrForModel;
        
    }else{
        
        sqlite3_close(data.dataBase);

        return nil;
    }
}

- (void)upDataWithModel:(PassWordModel *)model
        completionBlock:(completionBlock)block
{

    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
       // passWordList(ID INTEGER PRIMARY KEY AUTOINCREMENT ,type text,title text, userName text,passWord text,detail text,createTime text,userID text
        NSString *sql = [NSString stringWithFormat:@"update passWordList set title = '%@',userName = '%@',passWord = '%@',detail = '%@' where mid = '%d'",model.title,model.userName,model.passWord,model.detail,model.mid];
        sqlite3_stmt *stmt ;
        
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
   
                
                if (sqlite3_step(stmt) == SQLITE_DONE) {
                    
                    sqlite3_finalize(stmt);
                    sqlite3_close(data.dataBase);
                  
                    block(YES);
                    
                    return;
                }
                
       
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        block(NO);

        
    }else{
        sqlite3_close(data.dataBase);

        block(NO);

    }
    
    
    
}


- (void)deletedataWithType:(int )mid
           completionBlock:(completionBlock)block

{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from passWordList where mid = '%d'",mid];
        sqlite3_stmt *stmt;
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                
                block(YES);
                return;
                
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        
        block(NO);
        
    }else{
        
        
        sqlite3_close(data.dataBase);
        block(NO);
    }
    

}

- (void)deleteAllModel
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        char *sql = "delete from passWordList";
        sqlite3_stmt *stmt;
        int result = sqlite3_prepare_v2(data.dataBase, sql, -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                
                return;
                
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        
        
    }else{
        
        
        sqlite3_close(data.dataBase);
    }
    

}

- (void)deleteDataWithModel:(PassWordModel *)model
            completionBlock:(completionBlock)block
{
 
    XiaomiDB *data = [XiaomiDB shareXiaomiDB];
    
    if ([data openDB]) {
        
        NSString *sql = [NSString stringWithFormat:@"delete from passWordList where mid = '%d'",model.mid];
        sqlite3_stmt *stmt;
        int result = sqlite3_prepare_v2(data.dataBase, [sql UTF8String], -1, &stmt, NULL);
        
        if (result == SQLITE_OK) {
            
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                
                sqlite3_finalize(stmt);
                sqlite3_close(data.dataBase);
                
                block(YES);
                return;
                
            }
            
        }
        
        sqlite3_finalize(stmt);
        sqlite3_close(data.dataBase);
        
        
        block(NO);
        
    }else{
        
    
        sqlite3_close(data.dataBase);
        block(NO);
    }
    
}

@end
