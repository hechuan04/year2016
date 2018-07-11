//
//  JYWeatherModel.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYWeatherModel:NSObject

@property (nonatomic ,copy)NSString *temper;
@property (nonatomic ,copy)NSString *weatherCode;
@property (nonatomic ,copy)NSString *weatherInfo;
@property (nonatomic ,copy)NSString *aqi;
@property (nonatomic ,copy)NSString *aqiinfo;
@property (nonatomic ,copy)NSString *city;
@property (nonatomic,strong) UIImage *weatherImage;

@property (nonatomic, strong) NSArray *weatherArray;//of WeatherModel，未来7天天气

@end
