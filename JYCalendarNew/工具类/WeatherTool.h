//
//  WeatherTool.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ArrForModel)(NSArray *arr);

@interface WeatherTool : NSObject

+ (WeatherTool *)shareWeatherTool;

- (void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg;

@property (nonatomic ,copy)ArrForModel arrForPassModel;

@end