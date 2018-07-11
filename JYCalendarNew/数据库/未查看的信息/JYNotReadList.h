//
//  JYNotReadList.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/23.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYNotReadList : NSObject

+ (JYNotReadList *)shareNotReadList;

/**
 *  未读信息（事件）
 */
- (void)selectNotReadRemind;

@end
