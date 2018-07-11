//
//  LunarModel.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/4.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunarModel : NSObject

+ (LunarModel *)shareLunarModel;

+ (NSArray *)arrForLunarMonth:(int )year; //根据年返回月份
+ (NSArray *)arrForLunarDay:(int )year;   //根据年返回日数量
+ (NSString *)strForLunarDay:(int )index; //返回当天

@end
