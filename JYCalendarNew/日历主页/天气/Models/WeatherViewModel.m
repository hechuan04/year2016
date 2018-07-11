//
//  WeatherViewModel.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherViewModel.h"
#import "WeatherModel.h"

@implementation WeatherViewModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        if(!dic){
            return self;
        }
//        NSDictionary *data = [[dic objectForKey:@"HeWeather data service 3.0"] lastObject];
//if(!data||data.count==1){//未获取到正常无数据
        /* "HeWeather data service 3.0" =     (
         //             {
         //             status = "unknown city";
         //             }
         //             );*/
        NSDictionary *data = [dic objectForKey:@"data"];
        if(data.count>3){
            _city = [data valueForKey:@"city"];
            _aqi = [data valueForKey:@"aqi"];
            _currentTemperature = [NSString stringWithFormat:@"%@",[data valueForKey:@"wendu"]];
            NSArray *forecast = [data objectForKey:@"forecast"];
            NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:[forecast count]];
            for(int i=0; i<forecast.count; i++){
                WeatherModel *model = [[WeatherModel alloc]initWithDictionary:forecast[i]];
                [muArr addObject:model];
            }
            _weatherArray = [NSArray arrayWithArray:muArr];
            _currentWeather = [forecast[0] valueForKey:@"type"];
            
        }else{

            _cityId = @"";
            _city = @"未知城市";
            _currentWeather = @"未知!";
            _currentTemperature = @"--°";
            NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:7];
            for(int i=0;i<7;i++){
                WeatherModel *m = [[WeatherModel alloc]init];
                m.maxTemp = 0;
                m.minTemp = 0;
                m.weatherStr = @"未知";
                m.weatherIconName = @"";
                m.weatherCode = @"";
                m.feeling = @"未知";
                [muArr addObject:m];
            }
            _weatherArray = [NSArray arrayWithArray:muArr];
            _isDataError = YES;
        }
        
//        
//        {
//            _cityId = [data valueForKeyPath:@"basic.id"];
//            _city = [data valueForKeyPath:@"basic.city"];
//            _currentWeather = [data valueForKeyPath:@"now.cond.txt"];
//            _currentTemperature = [NSString stringWithFormat:@"%@°",[data valueForKeyPath:@"now.tmp"]];
//            
//            NSArray *tmp = [data objectForKey:@"daily_forecast"];
//            NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:[tmp count]];
//            for(int i=0; i<[tmp count]; i++){
//                WeatherModel *model = [[WeatherModel alloc]initWithDictionary:tmp[i]];
//                [muArr addObject:model];
//            }
//            _weatherArray = [NSArray arrayWithArray:muArr];
//        }
    }
    return self;
}


@end
