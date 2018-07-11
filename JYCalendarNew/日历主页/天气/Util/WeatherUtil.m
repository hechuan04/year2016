//
//  WeatherUtil.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherUtil.h"
@interface WeatherUtil()

@end
@implementation WeatherUtil

+ (WeatherUtil*)sharedUtil {
    static dispatch_once_t once;
    
    static WeatherUtil *sharedUtil;
    dispatch_once(&once, ^{
        sharedUtil = [[self alloc] init];
    });
    
    return sharedUtil;
}

- (instancetype)init
{
    if(self = [super init]){
        _cityDB = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]];
//        _worldCityDB = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"worldCity" ofType:@"plist"]];
    }
    return self;
}

#pragma mark - Public
- (JYCity *)findCityModelWithName:(NSString *)cityName
{
    
    if(!cityName||[cityName length]<1){
        return nil;
    }
    NSString *key = cityName;
    if([key hasSuffix:@"市"]||[key hasSuffix:@"县"]){
        key = [key substringToIndex:cityName.length-1];
    }

    __block JYCity *city;
    [self.cityDB enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *dic = obj;
        if([dic[@"city"] isEqualToString:key]){
            city = [[JYCity alloc]initWithDictionary:dic];
            *stop = YES;
        }
    }];
//    if(!city){
//        [self.worldCityDB enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSDictionary *dic = obj;
//            if([dic[@"cityNameEN"] isEqualToString:key]){
//                city = [[JYCity alloc]initWithWorldDictionary:dic];
//                *stop = YES;
//            }
//        }];
//    }
    if(!city){
        city = [[JYCity alloc]init];
        city.cityNameEN = cityName;
        city.city = cityName;
        city.cityType = JYCityTypeWorld;
    }
    return city;
}

- (NSMutableArray *)citiesManualAdded
{
    if(!_citiesManualAdded){
        
        _citiesManualAdded = [NSKeyedUnarchiver unarchiveObjectWithFile:self.pathForCityStorage];
        if(!_citiesManualAdded){
            _citiesManualAdded = [NSMutableArray array];
        }
    }
    return _citiesManualAdded;
}

- (void)addNewCity:(JYCity *)city
{
    [self.citiesManualAdded addObject:city];
    
    [NSKeyedArchiver archiveRootObject:self.citiesManualAdded toFile:self.pathForCityStorage];
}
- (void)deleteCity:(JYCity *)city
{
    if(!city){
        return;
    }
//    NSLog(@"%@",self.citiesManualAdded);
    [self.citiesManualAdded enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JYCity *jcity = obj;
        if([jcity.countyId isEqualToString:city.countyId]){
            [self.citiesManualAdded removeObject:jcity];
            *stop = YES;
        }
    }];
//    NSLog(@"%@",self.citiesManualAdded);
    [NSKeyedArchiver archiveRootObject:self.citiesManualAdded toFile:self.pathForCityStorage];
}
- (void)deleteCityAtIndex:(NSInteger)index
{
    if(index<[self.citiesManualAdded count]){
        [self.citiesManualAdded removeObjectAtIndex:index];
        [NSKeyedArchiver archiveRootObject:self.citiesManualAdded toFile:self.pathForCityStorage];
    }
}
- (NSArray *)searchCitiesWithKeyword:(NSString *)keyword
{
    if(!keyword||[keyword isEqualToString:@""]){
        return nil;
    }
    NSMutableArray *rtnArr = [NSMutableArray array];
    NSString *key = [keyword lowercaseString];
//    NSMutableString *muKeyword = [[NSMutableString alloc]init];
//    for(int i=0; i<keyword.length; i++){
//        [muKeyword appendFormat:@"%@\\w*",[keyword substringWithRange:NSMakeRange(i, 1)]];
//    }
    [self.cityDB enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSDictionary *dic = obj;
        
        if([dic[@"county"] rangeOfString:key].location != NSNotFound||
           [dic[@"city"] rangeOfString:key].location != NSNotFound||
           [dic[@"countyPinYin"] rangeOfString:key].location != NSNotFound){
            
            JYCity *city = [[JYCity alloc]initWithDictionary:dic];
            [rtnArr addObject:city];
        }
        //拼音模糊匹配：shai 匹配 shanghai
//        if([dic[@"county"] rangeOfString:muKeyword options:NSRegularExpressionSearch].location != NSNotFound||
//           [dic[@"countyPinYin"] rangeOfString:muKeyword options:NSRegularExpressionSearch].location != NSNotFound){
//            
//            JYCity *city = [[JYCity alloc]initWithDictionary:dic];
//            [rtnArr addObject:city];
//        }
        
    }];
    
    //屏蔽掉国外城市
//    [self.worldCityDB enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        NSDictionary *dic = obj;
//        
//        if([[dic[@"cityNameCN"] lowercaseString] rangeOfString:key].location != NSNotFound||
//           [[dic[@"cityNameEN"] lowercaseString] rangeOfString:key].location != NSNotFound){
//            
//            JYCity *city = [[JYCity alloc]initWithWorldDictionary:dic];
//            [rtnArr addObject:city];
//        }
//    }];
    return rtnArr;
}
- (NSString *)translateWeatherNameToChinese:(NSString *)weatherEN
{
    if(!weatherEN){
        return @"";
    }
    for(NSString *key in self.weatherNameDic.allKeys){
        if([key compare:weatherEN options:NSCaseInsensitiveSearch]==NSOrderedSame){
            return self.weatherNameDic[key];
        }
    }
    return weatherEN;
}
#pragma mark - Private
- (NSString *)pathForCityStorage
{
    if(!_pathForCityStorage){
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _pathForCityStorage = [paths lastObject];
        _pathForCityStorage = [_pathForCityStorage stringByAppendingPathComponent:kCityListName];
    }
    return _pathForCityStorage;
}
- (NSDictionary *)weatherNameDic
{
    if(!_weatherNameDic){
        _weatherNameDic = @{@"Sunny Clear":@"晴",@"Sunny，Clear":@"晴",@"Cloudy":@"多云",@"Few Clouds":@"少云",
                            @"Partly Cloudy":@"晴间多云",@"Overcast":@"阴",@"Windy":@"有风",
                            @"Calm":@"平静",@"Light Breeze":@"微风",@"Moderate":@"和风",
                            @"Gentle Breeze":@"和风",@"Fresh Breeze":@"清风",@"Strong Breeze":@"强风",
                            @"High Wind":@"疾风",@"Gale":@"大风",@"Strong Gale":@"烈风",
                            @"Storm":@"风暴",@"Violent Storm":@"狂爆风",@"Hurricane":@"飓风",
                            @"Tornado":@"龙卷风",@"Tropical Storm":@"热带风暴",@"Shower Rain":@"阵雨",
                            @"Heavy Shower Rain":@"强阵雨",@"Thundershower":@"雷阵雨",@"Heavy Thunderstorm":@"强雷阵雨",
                            @"Hail":@"雷阵雨",@"Light Rain":@"小雨",@"Moderate Rain":@"中雨",
                            @"Heavy Rain":@"大雨",@"Extreme Rain":@"极端降雨",@"Drizzle Rain":@"小雨",
                            @"Storm":@"暴雨",@"Heavy Storm":@"大暴雨",@"Severe Storm":@"特大暴雨",
                            @"Freezing Rain":@"冻雨",@"Light Snow":@"小雪",@"Moderate Snow":@"中雪",
                            @"Heavy Snow":@"大雪",@"Snowstorm":@"暴雪",@"Sleet":@"雨夹雪",
                            @"Rain And Snow":@"雨雪天气",@"Shower Snow":@"阵雨夹雪",@"Snow Flurry":@"阵雪",
                            @"Mist":@"薄雾",@"Foggy":@"雾",@"Haze":@"	霾",
                            @"Sand":@"扬沙",@"Dust":@"浮尘",@"Volcanic Ash":@"火山灰",
                            @"Duststorm":@"沙尘暴",@"Sandstorm":@"强沙尘暴",
                            @"Hot":@"热",@"Cold":@"冷",@"Unknown":@"未知"
                            };
    }
    return _weatherNameDic;
}
@end
