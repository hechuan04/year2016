//
//  WeatherPageView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeekWeatherView.h"
#import "WeekTemperatureView.h"
#import "WeatherGridView.h"
#import "WeatherViewModel.h"

@interface WeatherPageView : UIView

//顶部
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UILabel *weatherLabel;
@property (nonatomic,strong) UILabel *tempLabel;
//中部
@property (nonatomic,strong) UIView *weekWeatherContainerView; //一周天气
@property (nonatomic,strong) NSArray *weekWeatherViews;
@property (nonatomic,strong) WeekTemperatureView *weekTempView; //一周温度
@property (nonatomic,strong) UIView *weekWeatherFeelContainerView;//一周天气状况描述:凉爽/闷热
@property (nonatomic,strong) NSArray *weekWeatherFeelViews;
@property (nonatomic,strong) WeatherGridView *gridView;//网格线

@property (nonatomic,strong) WeatherViewModel *viewModel;


- (void)setCity:(NSString *)city
       weekStrs:(NSArray *)weekStrs
       dateStrs:(NSArray *)dateStrs;
@end
