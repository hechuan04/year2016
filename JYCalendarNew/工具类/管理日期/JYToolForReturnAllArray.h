//
//  JYToolForReturnAllArray.h
//  rilixiugai
//
//  Created by 吴冬 on 15/11/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYToolForReturnAllArray : NSObject

/**
 *  返回当前的显示页面需要的TEXT
 */
+ (NSArray *)actionForReturnArrayWithYear:(int )year
                                    month:(int )month
                                      day:(int )day
                                 isNowArr:(BOOL)isNow;//确定当前arr,否则会影响唯一字典的取值
@end
