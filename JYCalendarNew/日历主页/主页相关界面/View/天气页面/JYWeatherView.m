//
//  JYWeatherView.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYWeatherView.h"
#import "WeatherTool.h"
#import "JYWeatherModel.h"

//frame
//适配多出的块间距
#define blockDis()(IS_IPHONE_4_SCREEN?8:0)

//阳历
#define kXforSolarCalendar 40 / 750.0 * kScreenWidth
#define kYforSolarCalendar 15 / 1334.0 * kScreenHeight
#define kWidthForSolar    157 / 750.0 * kScreenWidth
#define kHeightForSolar   116 / 1334.0 * kScreenHeight + blockDis()
#define fontForSolarCalendar()(IS_IPHONE_4_SCREEN?52:(IS_IPHONE_5_SCREEN?53:(IS_IPHONE_6_SCREEN?58:63)))

//阴历
#define kXforLunarCalendar 200 / 750.0 * kScreenWidth
#define kYforLunarCalendar 85  / 1334.0 * kScreenHeight
#define kWidthForLunarCalendar 220 / 750.0 * kScreenWidth
#define kHeightForLunarCalendar 50 / 1334.0 * kScreenHeight
//#define fontForLunarCalendar()(IS_IPHONE_4_SCREEN?17:(IS_IPHONE_5_SCREEN?18:(IS_IPHONE_6_SCREEN?19:20)))
//#define fontForLunarCalendar()(IS_IPHONE_4_SCREEN?12:(IS_IPHONE_5_SCREEN?12:(IS_IPHONE_6_SCREEN?13:14)))

//节日那个点
#define kXforHolidayPoint 58 / 750.0 * kScreenWidth
#define kYforHolidayPoint 165 / 1334.0 * kScreenHeight
#define kHeightForPoint   9 / 1334.0 * kScreenHeight

//节日图标
#define kXforHolidayIcon  40 / 750.0 * kScreenWidth
#define kYforHolidayIcon  150 / 1334.0 * kScreenHeight + blockDis()
#define kWidthForHolidayIcon 35 / 750.0 * kScreenWidth
#define kHeightForHolidayIcon 35 / 1334.0 * kScreenHeight
#define kHorMargin 25 / 750.0 * kScreenWidth
//节日
#define kXforHoliday    85 / 750.0 * kScreenWidth
#define kYforHoliday  140 / 1334.0 * kScreenHeight + blockDis()
#define kWidthForHoliday 300 / 750.0 * kScreenWidth
#define kHeightForHoliday 55 / 1334.0 * kScreenHeight

//星期
#define kXforWeek  200 / 750.0 * kScreenWidth
#define kYforWeek  25  / 1334.0 * kScreenHeight
#define kWidthForWeek 200 / 750.0 * kScreenWidth
#define kHeightForWeekNow 40 / 1334.0 * kScreenHeight + blockDis()
#define fontForWeek()(IS_IPHONE_4_SCREEN?13:(IS_IPHONE_5_SCREEN?13:(IS_IPHONE_6_SCREEN?15:16)))

//空气质量
#define kXforAqi  530 / 750.0 * kScreenWidth
#define kYforAqi  85  / 1334.0 * kScreenHeight
#define kWidthForAqi 200 / 750.0 * kScreenWidth
#define kHeightForAqi 40 / 1334.0 * kScreenHeight + blockDis()
//#define fontForAqi()(IS_IPHONE_4_SCREEN?12:(IS_IPHONE_5_SCREEN?12:(IS_IPHONE_6_SCREEN?13:14)))

//气温
//#define kXforTemp 630 / 750.0  * kScreenWidth
//#define kYforTemp 30  / 1334.0 * kScreenHeight
//#define kWforTemp 110  / 750.0  * kScreenWidth
//#define kHforTemp 50  / 1334.0 * kScreenHeight
//#define fontForTemp()(IS_IPHONE_4_SCREEN?18:(IS_IPHONE_5_SCREEN?19:(IS_IPHONE_6_SCREEN?20:21)))

//天气
#define kXWeather 530 / 750.0 * kScreenWidth
#define kYWeather 25  / 1334.0 * kScreenHeight
#define kWforWeather 200 / 750.0 * kScreenWidth
#define kHforWeather 50 / 1334.0 * kScreenHeight + blockDis()
#define fontForWeather()(IS_IPHONE_4_SCREEN?13:(IS_IPHONE_5_SCREEN?13:(IS_IPHONE_6_SCREEN?15:16)))

//天气图片
#define kXImageWeather 425 / 750.0 * kScreenWidth
#define kYImageWeather 30  / 1334.0 * kScreenHeight
#define kWImageWeather 82  / 750.0 * kScreenWidth
#define kHImageWeather 67  / 1334.0 * kScreenHeight

//城市图标
#define kXCityIcon        425  / 750.0 * kScreenWidth
#define kYCityIcon        150  / 1334.0 * kScreenHeight + blockDis()
#define kWCityIcon        35  / 750.0 * kScreenWidth
#define kHCityIcon        35  / 1334.0 * kScreenHeight

//城市
#define kXCity        470  / 750.0 * kScreenWidth
#define kYCity        140  / 1334.0 * kScreenHeight + blockDis()
#define kWCity        82  / 750.0 * kScreenWidth
#define kHCity        55  / 1334.0 * kScreenHeight
//#define fontForCity()(IS_IPHONE_4_SCREEN?13:(IS_IPHONE_5_SCREEN?14:(IS_IPHONE_6_SCREEN?15:16)))

//风
#define kXWind        381  / 750.0 * kScreenWidth
#define kYWind        30   / 1334.0 * kScreenHeight
#define kWWind        73   / 750.0 * kScreenWidth
#define kHWind        36   / 1334.0 * kScreenHeight

@implementation JYWeatherView

//初始化方法
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        JYSkinManager *manager = [JYSkinManager shareSkinManager];
        
        _holidayPoint = [[UIView  alloc] initWithFrame:CGRectMake(kXforHolidayPoint, kYforHolidayPoint, kHeightForPoint, kHeightForPoint)];
        _holidayPoint.backgroundColor = [UIColor grayColor];
        _holidayPoint.layer.cornerRadius = 3.0;
        _holidayPoint.layer.masksToBounds = YES;
        _holidayPoint.hidden = YES;
        //[self addSubview:_holidayPoint];
        
        _solarCalendar = [[UILabel alloc] initWithFrame:CGRectMake(kXforSolarCalendar, kYforSolarCalendar, kWidthForSolar, kHeightForSolar)];
        _solarCalendar.text = @"－";
        _solarCalendar.font = [UIFont fontWithName:@"STHeitiSC-Light" size:fontForSolarCalendar()];
        _solarCalendar.textColor = manager.colorForDateBg;
        [self addSubview:_solarCalendar];
        [_solarCalendar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(kXforSolarCalendar);
            make.top.equalTo(self).offset(kYforSolarCalendar);
            make.height.mas_equalTo(kHeightForSolar);
        }];

        //改变主题用
        manager.weatherSoloarLabel = _solarCalendar;
        
        
        _weekDay = [[UILabel alloc] initWithFrame:CGRectMake(kXforWeek, kYforWeek, kWidthForWeek, kHeightForWeekNow)];
        //_weekDay.backgroundColor = [UIColor orangeColor];
        _weekDay.text = @"Monday";
        _weekDay.font = [UIFont fontWithName:@"segoe" size:fontForWeek()];
        _weekDay.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_weekDay];
        [_weekDay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_solarCalendar.mas_trailing).offset(kHorMargin);
            make.top.equalTo(self).offset(kYforWeek);
        }];
        
        _lunarCalendar = [[UILabel alloc] initWithFrame:CGRectMake(kXforLunarCalendar, kYforLunarCalendar, kWidthForLunarCalendar, kHeightForLunarCalendar)];
        _lunarCalendar.text = @"－月－";
        _lunarCalendar.font = [UIFont systemFontOfSize:fontForWeather()];
        _lunarCalendar.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lunarCalendar];
        [_lunarCalendar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_solarCalendar.mas_trailing).offset(kHorMargin);
            make.bottom.equalTo(_solarCalendar).offset(-5.f);
        }];
        
   
        
        _holidayIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kXforHolidayIcon, kYforHolidayIcon, kWidthForHolidayIcon, kHeightForHolidayIcon)];
        _holidayIcon.contentMode = UIViewContentModeScaleAspectFit;
        _holidayIcon.image = [UIImage imageNamed:@"首页_节日"];
        [self addSubview:_holidayIcon];
        
        _holiDay = [[UILabel alloc] initWithFrame:CGRectMake(kXforHoliday, kYforHoliday, kWidthForHoliday, kHeightForHoliday)];
        //_holiDay.backgroundColor = [UIColor orangeColor];
        _holiDay.text = @" ";
        _holiDay.font = [UIFont systemFontOfSize:fontForWeather()];
        _holiDay.numberOfLines = 0;
        _holiDay.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_holiDay];
        
        _aqi = [[UILabel alloc] initWithFrame:CGRectMake(kXWeather, kYforAqi, kWidthForAqi, kHeightForAqi)];
        _aqi.text = @" －  －";
        _aqi.font = [UIFont systemFontOfSize:fontForWeather()];
        _aqi.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_aqi];
        
        /*_pointDay = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 100 / 2.0, 0, 100, 40)];
        _pointDay.backgroundColor = [UIColor orangeColor];
        _pointDay.text = @"春分";
        _pointDay.font = [UIFont boldSystemFontOfSize:20];
        _pointDay.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_pointDay];*/
        
        _imageForWeather = [[UIImageView alloc] initWithFrame:CGRectMake(kXImageWeather, kYImageWeather, kWImageWeather, kWImageWeather)];
        // _imageForWeather.backgroundColor = [UIColor orangeColor];
        _imageForWeather.image = [UIImage imageNamed:@"温度计"];
        _imageForWeather.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageForWeather];
        
        _locationIcon = [[UIImageView alloc]initWithFrame:CGRectMake(kXCityIcon, kYCityIcon, kWCityIcon, kHCityIcon)];
        _locationIcon.contentMode = UIViewContentModeScaleAspectFit;
        _locationIcon.image = [UIImage imageNamed:@"首页_定位"];
        [self addSubview:_locationIcon];
        
        _cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(kXCity, kYCity, 200, kHCity)];
        _cityLabel.text = @"北京市";
        _cityLabel.textAlignment = NSTextAlignmentLeft;
        _cityLabel.font = [UIFont systemFontOfSize:fontForWeather()];
        //_cityLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_cityLabel];
        
        //注掉单独显示温度的label
//        _temperatureLabel = [[UILabel alloc ] initWithFrame:CGRectMake(kXforTemp, kYforTemp, kWforTemp, kHforTemp)];
//        _temperatureLabel.text = @"－°C";
//        _temperatureLabel.textAlignment = NSTextAlignmentLeft;
////        _temperatureLabel.font = [UIFont systemFontOfSize:fontForTemp()];
//        //        _temperatureLabel.textColor = manager.colorForDateBg;
//        _temperatureLabel.font = [UIFont systemFontOfSize:fontForWeather()];
//        [self addSubview:_temperatureLabel];
        
        
        manager.weatherTemLabel = _temperatureLabel;
        
        
        _weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(kXWeather, kYWeather, kWforWeather, kHforWeather)];
        _weatherLabel.text = @"Weather °C";
        _weatherLabel.textAlignment = NSTextAlignmentLeft;
        _weatherLabel.font = [UIFont systemFontOfSize:fontForWeather()];
        //_weatherLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_weatherLabel];
        
        /*_windLabel = [[UILabel alloc]initWithFrame:CGRectMake(kXWind, kYWind, kWWind, kHWind)];
        //_windLabel.text = @"微风";
        _windLabel.textAlignment = NSTextAlignmentCenter;
        _windLabel.font = [UIFont boldSystemFontOfSize:16];
        // _windLabel.backgroundColor = [UIColor orangeColor];
        [self addSubview:_windLabel];*/
        
        [self queryWeather];
        //定时刷新天气雨空气，1小时重复一次，永不停止
        [NSTimer scheduledTimerWithTimeInterval:60*60 target:self selector:@selector(queryWeather) userInfo:nil repeats:YES];
        
    }
    
    return self;
}

- (void)queryWeather {
    
    WeatherTool *weatherT = [WeatherTool shareWeatherTool];
    
    [weatherT request:kWeatherUrl withHttpArg:@"city=beijing"];
    
    [weatherT setArrForPassModel:^void(NSArray *arr){
        
        JYWeatherModel *model = arr[0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //天气图片
            if([model.weatherInfo isEqual: @"晴"]){
                _imageForWeather.image = [UIImage imageNamed:@"晴.png"];
            }else if([model.weatherInfo isEqual: @"阴"]){
                _imageForWeather.image = [UIImage imageNamed:@"阴.png"];
            }else if([model.weatherInfo isEqual: @"雾"]||[model.weatherInfo isEqual: @"霾"]){
                _imageForWeather.image = [UIImage imageNamed:@"雾.png"];
            }else if([model.weatherInfo isEqual: @"雨夹雪"]){
                _imageForWeather.image = [UIImage imageNamed:@"雨夹雪.png"];
            }else if([model.weatherInfo rangeOfString:@"冰雹"].location != NSNotFound){
                _imageForWeather.image = [UIImage imageNamed:@"冰雹.png"];
            }else if([model.weatherInfo rangeOfString:@"风"].location != NSNotFound){
                _imageForWeather.image = [UIImage imageNamed:@"暴风.png"];
            }else if([model.weatherInfo rangeOfString:@"雪"].location != NSNotFound){
                _imageForWeather.image = [UIImage imageNamed:@"暴雪.png"];
            }else if([model.weatherInfo rangeOfString:@"雨"].location != NSNotFound){
                _imageForWeather.image = [UIImage imageNamed:@"小雨.png"];
            }else if([model.weatherInfo rangeOfString:@"云"].location != NSNotFound){
                _imageForWeather.image = [UIImage imageNamed:@"多云.png"];
            }else if([model.weatherInfo rangeOfString:@"沙"].location != NSNotFound || [model.weatherInfo rangeOfString:@"尘"].location != NSNotFound){
                _imageForWeather.image = [UIImage imageNamed:@"沙尘暴.png"];
            }else{
                NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@.png", kWeatherPng, model.weatherCode];
                NSURL *url = [NSURL URLWithString:urlStr];
                [_imageForWeather sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _weatherImage = _imageForWeather.image;
                    
                }];
                
               
            }
            _weatherImage = _imageForWeather.image;
            //空气质量信息取前两位
            if(model.aqiinfo.length > 2){
                model.aqiinfo = [model.aqiinfo substringWithRange:NSMakeRange(0,2)];
            }
            
            NSString *kongge;
            if(model.aqiinfo.length + model.aqi.length < 5) {
                kongge = @"  ";
            }else {
                kongge = @" ";
            }
            
            _aqi.text = [[NSString alloc] initWithFormat:@"%@%@%@",model.aqiinfo, kongge, model.aqi];
            _aqiData = _aqi.text;
//            _temperatureLabel.text = [[NSString alloc] initWithFormat:@"%@°C", model.temper];
            
            //ui改动后天气，温度字体效果一样合并到一起了
            _weatherLabel.text = [[NSString alloc] initWithFormat:@"%@%@%@°C", model.weatherInfo,kongge,model.temper];
            _weatherData = _weatherLabel.text;
            _cityLabel.text = model.city;
            
        });
        
    }];
}

@end
