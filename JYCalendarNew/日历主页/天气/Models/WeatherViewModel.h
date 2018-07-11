//
//  WeatherViewModel.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherModel.h"

@interface WeatherViewModel : NSObject

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *currentWeather;
@property (nonatomic, copy) NSString *currentTemperature;
@property (nonatomic, strong) NSArray *weatherArray;//of WeatherModel
@property (nonatomic, assign)  BOOL isDataError;
@property (nonatomic, copy) NSString *aqi;//空气质量
@property (nonatomic, copy) NSString *aqiInfo;
@property (nonatomic, strong) UIImage *weatherImage;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
