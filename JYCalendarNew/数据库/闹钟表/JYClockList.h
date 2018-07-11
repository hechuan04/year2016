//
//  JYClockList.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClockModel.h"
@interface JYClockList : NSObject

+ (JYClockList *)shareClockList;

/**
 *  插入数据
 */
- (BOOL)insertClockWithClockModel:(ClockModel *)model;

/**
 *  查询数据
 */
- (NSArray *)selectAllModel;

/**
 *  更新数据
 */
- (BOOL)upDataWithClockModel:(ClockModel *)model;

/**
 *  删除数据
 */
- (BOOL)deleteClockWithModel:(ClockModel *)model;

@end
