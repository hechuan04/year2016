//
//  WeatherView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/3.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYWeatherModel;
@class JYCalendarModel;
@class WeatherViewModel;
@interface WeatherView : UIView

@property (nonatomic,strong) UILabel     *solarDayLabel;//阳历-日
@property (nonatomic,strong) UILabel     *lunarLabel;//农历
@property (nonatomic,strong) UILabel     *weekLabel;//星期
@property (nonatomic,strong) UIImageView *weatherImageView;//天气图标
@property (nonatomic,strong) UILabel     *weatherLabel;//天气
@property (nonatomic,strong) UILabel     *aqiLabel;//空气质量
@property (nonatomic,strong) UIImageView *festivalImageView;//节日图标
@property (nonatomic,strong) UILabel     *festivalLabel;//节日
@property (nonatomic,strong) UIImageView *festivalImageView2;//如果有节日，佛历显示在这里
@property (nonatomic,strong) UILabel     *festivalLabel2;//佛历
@property (nonatomic,strong) UIImageView *locationImageView;//定位图标
@property (nonatomic,strong) UILabel     *locationLabel;//位置

@property (nonatomic,strong) WeatherViewModel *weatherModel;
@property (nonatomic,strong) JYCalendarModel *calendarModel;

@property (nonatomic,strong) WeatherViewModel *selectedWeatherModel;

@property (nonatomic,assign) BOOL dataFetchedSuccessful;
@property (nonatomic,assign) BOOL isQuerying;
//- (void)queryWeather;
- (void)queryCurrentCityWeather;
- (void)locateCity;

@end
