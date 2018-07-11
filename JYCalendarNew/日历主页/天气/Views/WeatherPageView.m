//
//  WeatherPageView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherPageView.h"
#import "WeatherUtil.h"

#define kShowWeatherCount 5
#define kTopViewHeight (IS_IPHONE_5_SCREEN?220.f:260.f)
#define kWeekWeatherViewHeight (IS_IPHONE_5_SCREEN?115.f:120.f)
#define kWeekTempViewHeight (IS_IPHONE_5_SCREEN?100.f:130.f)
#define kWeekWeatherFeelHeight 50.f
@interface WeatherPageView()


@end

@implementation WeatherPageView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self setupSubViews];
    }
    return self;
}
#pragma mark - Public
- (void)setViewModel:(WeatherViewModel *)viewModel
{
    if(!viewModel){
        return;
    }
//    self.cityLabel.text = viewModel.city;
     NSString *weather = [[WeatherUtil sharedUtil] translateWeatherNameToChinese:viewModel.currentWeather];
    self.weatherLabel.text = weather;
    self.tempLabel.text = [NSString stringWithFormat:@"   %@°",viewModel.currentTemperature];
    
    NSMutableArray *maxTemps = [NSMutableArray arrayWithCapacity:[viewModel.weatherArray count]];
    NSMutableArray *minTemps = [NSMutableArray arrayWithCapacity:[viewModel.weatherArray count]];
    
    for(int i=0; i<kShowWeatherCount; i++){
        //一周天气信息
        if(i<[viewModel.weatherArray count]){
            WeatherModel *model = viewModel.weatherArray[i];
            if(i<[self.weekWeatherViews count]){
                WeekWeatherView *weekView = [self.weekWeatherViews objectAtIndex:i];
                [weekView setWeather:model.weatherStr
                        weatherImage:model.weatherIconName];
            }
            
            [maxTemps addObject:[NSNumber numberWithInteger:model.maxTemp]];
            [minTemps addObject:[NSNumber numberWithInteger:model.minTemp]];
           
            
            //穿衣指数
            UILabel *feelingLabel = [self.weekWeatherFeelViews objectAtIndex:i];
            if(feelingLabel&&!viewModel.isDataError){
                feelingLabel.text = [self getSuggestWithTemp:model.maxTemp];
            }else{
                feelingLabel.text = @"--";
            }
        }
        
    }
    //一周温度
    if(!viewModel.isDataError){
        [self.weekTempView setMaxTemperatures:maxTemps minTemperatures:minTemps];
    }else{
        [self.weekTempView setMaxTemperatures:nil minTemperatures:nil];
    }
}

- (void)setCity:(NSString *)city
       weekStrs:(NSArray *)weekStrs
       dateStrs:(NSArray *)dateStrs
{
    self.cityLabel.text = city;
    for(int i=0; i<[self.weekWeatherViews count]; i++){
        WeekWeatherView *view = self.weekWeatherViews[i];
        if(i<[weekStrs count]&&i<[dateStrs count]){
            [view setWeek:weekStrs[i] date:dateStrs[i]];
        }
    }
}
#pragma mark - Private
#pragma mark UI
- (void)setupSubViews
{
    [self addSubview:self.topView];
    [self addSubview:self.weekWeatherContainerView];
    [self addSubview:self.weekTempView];
    [self addSubview:self.weekWeatherFeelContainerView];
    [self addSubview:self.gridView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@kTopViewHeight);
    }];
    [self.weekWeatherContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@kWeekWeatherViewHeight);
    }];
    [self.weekTempView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekWeatherContainerView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@kWeekTempViewHeight);
    }];
    [self.weekWeatherFeelContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekTempView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@kWeekWeatherFeelHeight);
    }];
    [self.gridView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weekWeatherContainerView);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.weekWeatherFeelContainerView);
    }];

}
- (NSString *)getSuggestWithTemp:(NSInteger)temp
{
    NSString *suggest = @"";
    
    if(temp>25){
        suggest = @"短裙\nT恤";
    }else if(temp>15){
        suggest = @"单衣\n夹克";
    }else if(temp>5){
        suggest = @"外套\n大衣";
    }else{
        suggest = @"羽绒服\n棉衣";
    }
    return suggest;
}
#pragma mark - Custom Accessors
- (UIView *)topView
{
    if(!_topView){
        _topView = [UIView new];
        [_topView addSubview:self.cityLabel];
        [_topView addSubview:self.weatherLabel];
        [_topView addSubview:self.tempLabel];
        
        [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView).offset(IS_IPHONE_5_SCREEN?60.f:70.f);
            make.height.equalTo(@40.f);
            make.left.equalTo(_topView).offset(10);
            make.right.equalTo(_topView).offset(-10);
        }];
        [self.weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_topView);
            make.top.equalTo(self.cityLabel.mas_bottom);
            make.height.equalTo(@25.f);
        }];
        [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(_topView);
            make.top.equalTo(self.weatherLabel.mas_bottom);
        }];
    }
    return _topView;
}
- (UILabel *)cityLabel
{
    if(!_cityLabel){
        _cityLabel = [[UILabel alloc]init];
        _cityLabel.textColor = [UIColor whiteColor];
        _cityLabel.font = [UIFont systemFontOfSize:33];
        _cityLabel.text = @"未知城市";
        _cityLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cityLabel;
}
- (UILabel *)weatherLabel
{
    if(!_weatherLabel){
        _weatherLabel = [[UILabel alloc]init];
        _weatherLabel.textColor = [UIColor whiteColor];
        _weatherLabel.font = [UIFont systemFontOfSize:18];
        _weatherLabel.text = @"未更新";
        _weatherLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weatherLabel;
}
- (UILabel *)tempLabel
{
    if(!_tempLabel){
        _tempLabel = [[UILabel alloc]init];
        _tempLabel.textColor = [UIColor whiteColor];
        _tempLabel.font = [UIFont fontWithName:@"FZLanTingHeiS-UL-GB" size:90];
//        _tempLabel.font = [UIFont systemFontOfSize:110];
        _tempLabel.text = @"   0°";
        _tempLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tempLabel;
}

- (UIView *)weekWeatherContainerView
{
    if(!_weekWeatherContainerView){
        _weekWeatherContainerView = [UIView new];
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:kShowWeatherCount];
        UIView *lastView;
        for(int i=0;i<kShowWeatherCount;i++){
            WeekWeatherView *view = [[WeekWeatherView alloc] init];
            [_weekWeatherContainerView addSubview:view];
            //单日天气小图
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.equalTo(_weekWeatherContainerView);
                if(!lastView){
                    make.left.equalTo(_weekWeatherContainerView);
                }else{
                    make.left.equalTo(lastView.mas_right);
                    make.width.equalTo(lastView);
                }
                if(i==kShowWeatherCount-1){
                    make.right.equalTo(_weekWeatherContainerView);
                }
            }];
            lastView = view;
            [views addObject:view];
        }
        _weekWeatherViews = [NSArray arrayWithArray:views];
    }
    return _weekWeatherContainerView;
}

- (WeekTemperatureView *)weekTempView
{
    if(!_weekTempView){
        _weekTempView = [WeekTemperatureView new];
        _weekTempView.backgroundColor = [UIColor clearColor];
    }
    return _weekTempView;
}
- (UIView *)weekWeatherFeelContainerView
{
    if(!_weekWeatherFeelContainerView){
        _weekWeatherFeelContainerView = [UIView new];
        _weekWeatherFeelContainerView.backgroundColor = [UIColor clearColor];
        NSMutableArray *views = [NSMutableArray arrayWithCapacity:kShowWeatherCount];
        UIView *lastView;
        for(int i=0; i<kShowWeatherCount; i++){
            UILabel *label = [UILabel new];
            label.text = @"--";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 2;
            [_weekWeatherFeelContainerView addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.height.equalTo(_weekWeatherFeelContainerView);
                if(!lastView){
                    make.left.equalTo(_weekWeatherFeelContainerView);
                }else{
                    make.left.equalTo(lastView.mas_right);
                    make.width.equalTo(lastView);
                }
                if(i==kShowWeatherCount-1){
                    make.right.equalTo(_weekWeatherFeelContainerView);
                }
            }];
            lastView = label;
            [views addObject:label];
        }
        _weekWeatherFeelViews = [NSArray arrayWithArray:views];
    }
    return _weekWeatherFeelContainerView;
}
- (WeatherGridView *)gridView
{
    if(!_gridView){
        _gridView = [WeatherGridView new];
        _gridView.backgroundColor = [UIColor clearColor];
        [_gridView setTopLineCoordY:kWeekWeatherViewHeight BottomLineCoordY:kWeekWeatherViewHeight+kWeekTempViewHeight];
    }
    return _gridView;
}

@end
