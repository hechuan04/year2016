//
//  NSString+Common.h
//  JYCalendarNew
//
//  Created by Leo Gao on 16/4/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Common)

//去掉首尾空格
- (NSString *)trimWhitespace;

//空字符
- (BOOL)isEmpty;

//判断是否为整形
- (BOOL)isPureInt;

//是否浮点型
- (BOOL)isPureFloat;

- (NSString *)transformToPinyin;

//含有emoji表情是截取字符可能不全
-(NSString *)subEmojiStringToIndex:(NSInteger)index;

- (NSString *)transformToSqlString;
@end
