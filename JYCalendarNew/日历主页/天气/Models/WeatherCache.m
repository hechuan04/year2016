//
//  WeatherCache.m
//  JYCalendarNew
//
//  Created by Gaolichao on 2017/1/18.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherCache.h"

@implementation WeatherCache

+ (instancetype)sharedCache
{
    static dispatch_once_t once;
    
    static WeatherCache *sharedCache;
    dispatch_once(&once, ^{
        sharedCache = [[self alloc] init];
    });
    
    return sharedCache;
}

- (BOOL)hasExpired
{
    if(self.cacheTimestamp==0){
        return YES;
    }
    
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    return (now-self.cacheTimestamp)>kExpiredInterval;
}
- (void)cacheWeather:(WeatherViewModel *)weather forKey:(NSString *)key
{
    if(weather && key){
        [self.cache setValue:weather forKey:key];
    }
}

- (WeatherViewModel *)cachedWeatherForKey:(NSString *)key
{
    if(key){
        return [self.cache objectForKey:key];
    }
    return nil;
}

#pragma mark - Getter

- (NSDictionary *)cache
{
    if(!_cache){
        _cache = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _cache;
}
@end
