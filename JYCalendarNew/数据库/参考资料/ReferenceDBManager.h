//
//  ReferenceDBManager.h
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/12/8.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReferenceDBManager : NSObject

+ (instancetype)sharedManager;
- (sqlite3 *)openDB;
- (void)closeDB;

- (NSString *)queryFoDetailWithName:(NSString *)name;
- (NSString *)queryFestivalDetailWithName:(NSString *)name;
@end
