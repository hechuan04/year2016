//
//  WeatherUtil.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYCity.h"

#define kCityListName @"cityList.db" //天气地点字典key

@interface WeatherUtil : NSObject

@property (nonatomic, strong) NSMutableArray *cityDB;
//@property (nonatomic, strong) NSMutableArray *worldCityDB;
@property (nonatomic, strong) NSMutableArray *citiesManualAdded;
@property (nonatomic, strong) NSString *pathForCityStorage;
@property (nonatomic,strong) NSDictionary *weatherNameDic;

+ (WeatherUtil*)sharedUtil;

- (JYCity *)findCityModelWithName:(NSString *)cityName;
- (void)addNewCity:(JYCity *)city;
- (void)deleteCity:(JYCity *)city;
- (void)deleteCityAtIndex:(NSInteger)index;

- (NSArray *)searchCitiesWithKeyword:(NSString *)keyword;

- (NSString *)translateWeatherNameToChinese:(NSString *)weatherEN;
@end
