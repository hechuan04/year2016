//
//  JYWeatherView.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYWeatherView : UIView

//枚举,选中的View所对应的tag
typedef NS_ENUM(NSInteger, day1){
    
    nowDay = 0,
    nextDay1 ,
    nextDay2 ,
    nextDay3 ,
    nextDay4 ,
    nextDay5 ,
    nextDay6 ,
    
};

//阳历
@property (nonatomic ,strong)UILabel *solarCalendar;
//阴历
@property (nonatomic ,strong)UILabel *lunarCalendar;
//星期
@property (nonatomic ,strong)UILabel *weekDay;
//假期
@property (nonatomic ,strong)UILabel *holiDay;
//空气质量
@property (nonatomic ,strong)UILabel *aqi;
//节气
@property (nonatomic ,strong)UILabel *pointDay;
//天气图片
@property (nonatomic ,strong)UIImageView *imageForWeather;
//天气label
@property (nonatomic ,strong)UILabel *weatherLabel;
//气温
@property (nonatomic ,strong)UILabel *temperatureLabel;
//城市
@property (nonatomic ,strong)UILabel *cityLabel;
//风
@property (nonatomic ,strong)UILabel *windLabel;

@property (nonatomic ,strong)NSArray *arrForWeather;

@property (nonatomic ,strong)UIView  *holidayPoint;

@property (nonatomic,strong) UIImageView *holidayIcon;
@property (nonatomic,strong) UIImageView *locationIcon;
//- (void)createWeatherView:(NSArray *)arrForModel andDay:(int )day;
@property (nonatomic,strong) NSString *aqiData;
@property (nonatomic,strong) NSString *weatherData;
@property (nonatomic,strong) UIImage *weatherImage;
- (void)queryWeather;

@end
