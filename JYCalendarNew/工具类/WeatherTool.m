//
//  WeatherTool.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "WeatherTool.h"
#import "JYWeatherModel.h"
#import "WeatherModel.h"

static WeatherTool *_weatherTool = nil;

@implementation WeatherTool

+ (WeatherTool *)shareWeatherTool {
 
    if (_weatherTool == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            _weatherTool = [[WeatherTool alloc] init];
            
        });
    }
    
    return _weatherTool;
    
}

/**
 *  请求天气的方法
 *
 *  @param httpUrl url
 *  @param HttpArg 城市id
 */
- (void)request:(NSString*)httpUrl withHttpArg:(NSString*)HttpArg {
    
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:kWeatherKey forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (error) {
            if(_arrForPassModel){
                _arrForPassModel(nil);
            }
        }else{
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *dicForWeather = [self returnCityAndWeatherAndTem:result];

            //Block传值
            if(dicForWeather.count > 0) {
                _arrForPassModel(dicForWeather);
            }
        }
    }];
    
}
     
- (NSArray *)returnCityAndWeatherAndTem:(id )result {
    NSMutableArray *arr = [NSMutableArray array];
    JYWeatherModel *model = [[JYWeatherModel alloc] init];
    
    NSArray *dicForWeather = [result objectForKey:@"HeWeather data service 3.0"];
    NSDictionary *dicAqi = dicForWeather[0];
    
    //判断天气接口成功与否
    NSString *apiStatus = [dicAqi objectForKey:@"status"];
    if(![apiStatus isEqualToString:@"ok"]){
        NSArray *arrForModel = arr;
        return arrForModel;
    }
    
    //查询空气质量
    NSDictionary *dicCity = [dicAqi objectForKey:@"aqi"];
    NSDictionary *dicInfo = [dicCity objectForKey:@"city"];
    
    if(dicInfo&&dicCity){
        model.aqi = dicInfo[@"aqi"];
        model.aqiinfo = dicInfo[@"qlty"];
    }else{
        model.aqi = @"";
        model.aqiinfo = @"";
    }
    
    //查询地点
    dicCity = [dicAqi objectForKey:@"basic"];
    
    model.city = dicCity[@"city"];
    
    //查询天气
    dicCity = [dicAqi objectForKey:@"now"];
    dicInfo = [dicCity objectForKey:@"cond"];
    
    model.temper = dicCity[@"tmp"];
    model.weatherInfo = dicInfo[@"txt"];
    model.weatherCode = dicInfo[@"code"];
    
    //新需求，未来7天天气保存下来
    NSArray *tmp = [dicAqi objectForKey:@"daily_forecast"];
    NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:[tmp count]];
    for(int i=0; i<[tmp count]; i++){
        WeatherModel *model = [[WeatherModel alloc]initWithDictionary:tmp[i]];
        [muArr addObject:model];
    }
    model.weatherArray = [NSArray arrayWithArray:muArr];

    
    [arr addObject:model];
    
    NSArray *arrForModel = arr;
    return arrForModel;
}

@end
