//
//  WeatherCache.h
//  JYCalendarNew
//
//  Created by Gaolichao on 2017/1/18.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherViewModel.h"

#define kExpiredInterval 1800 //半小时

@interface WeatherCache : NSObject

@property (nonatomic,assign) NSTimeInterval cacheTimestamp;
@property (nonatomic,strong) NSDictionary *cache;

//内存缓存
+ (instancetype)sharedCache;


- (BOOL)hasExpired;
- (void)cacheWeather:(WeatherViewModel *)weather forKey:(NSString *)key;
- (WeatherViewModel *)cachedWeatherForKey:(NSString *)key;

@end
