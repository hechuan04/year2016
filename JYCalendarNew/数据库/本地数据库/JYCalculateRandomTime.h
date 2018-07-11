//
//  JYCalculateRandomTime.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYCalculateRandomTime : NSObject

/**
 *  根据model计算重复提醒的下次提醒日期
 *
 *  @param model <#model description#>
 */
- (void)calculateRandomModel:(RemindModel *)model;



+ (JYCalculateRandomTime *)manager;

@property (nonatomic ,assign)int year;
@property (nonatomic ,assign)int month;
@property (nonatomic ,assign)int day;

@end
