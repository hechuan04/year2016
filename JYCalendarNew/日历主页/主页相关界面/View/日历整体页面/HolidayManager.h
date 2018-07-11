//
//  HolidayManager.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,dayType){
 
    holiday = 100,
    workday = 200,
};

@interface HolidayManager : NSObject

@property (nonatomic ,strong)NSDictionary *holiday2017;
@property (nonatomic ,strong)NSDictionary *holiday2016;
@property (nonatomic ,strong)NSDictionary *holiday2015;
@property (nonatomic ,strong)NSDictionary *holiday2018;
@property (nonatomic ,strong)NSDictionary *jingwen;

+ (HolidayManager *)shareManager;

- (dayType)isWork:(NSString *)dayAndMonth
             year:(int)year;

//根据佛日查找解释
- (NSString *)searchFozuText:(NSString *)name;

@end
