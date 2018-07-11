//
//  CollectionList.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionList : NSObject

+ (CollectionList *)shareCollectionList;

/**
 *  插入
 */
- (BOOL)insterRemindModel:(RemindModel *)model;

@end
