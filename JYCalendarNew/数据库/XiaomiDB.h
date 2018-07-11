//
//  XiaomiDB.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/25.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface XiaomiDB : NSObject

+ (XiaomiDB *)shareXiaomiDB;

@property (atomic)sqlite3 *dataBase;


- (BOOL)openDB;
- (BOOL)closeDB;

- (NSString *)filePath;
@end
