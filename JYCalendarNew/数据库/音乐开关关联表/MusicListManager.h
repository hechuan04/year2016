//
//  MusicListManager.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/6.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicListManager : NSObject

+ (MusicListManager *)shareMusicListManager;

/**
 *  删除
 */
- (BOOL)deleteDataWithModel:(RemindModel *)model;

/**
 *  插入
 */
- (BOOL)insertDataWithModel:(RemindModel *)model
                  musicName:(int )musicName;

@end
