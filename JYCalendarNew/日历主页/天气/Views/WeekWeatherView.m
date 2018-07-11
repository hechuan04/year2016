//
//  WeekWeatherView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeekWeatherView.h"
#import "WeatherUtil.h"

@interface WeekWeatherView()
@end
@implementation WeekWeatherView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        [self setupSubViews];
    }
    return self;
}

#pragma mark - Public
- (void)setWeather:(NSString *)weatherStr
   weatherImage:(NSString *)weatherImageName
{
    NSString *weather = [[WeatherUtil sharedUtil] translateWeatherNameToChinese:weatherStr];
    _weatherLabel.text = weather?weather:weatherStr;
    if([weatherImageName hasPrefix:@"http"]){
        [_weatherImageView sd_setImageWithURL:[NSURL URLWithString:weatherImageName]];
    }else{
        _weatherImageView.image = [UIImage imageNamed:weatherImageName];
    }
}
- (void)setWeek:(NSString *)weekStr
           date:(NSString *)dateString
{
    _weekLabel.text = weekStr;
    _dateLabel.text = dateString;
}
#pragma mark - Private
- (void)setupSubViews
{
    _weekLabel = [UILabel new];
    _weekLabel.textColor = [UIColor whiteColor];
    _weekLabel.font = [UIFont systemFontOfSize:16.f];
    _weekLabel.text = @"";
    _weekLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_weekLabel];
    
    _dateLabel = [UILabel new];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.font = [UIFont systemFontOfSize:14.f];
    _dateLabel.text = @"";
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_dateLabel];
    
    _weatherLabel = [UILabel new];
    _weatherLabel.textColor = [UIColor whiteColor];
    _weatherLabel.font = [UIFont systemFontOfSize:15.f];
    _weatherLabel.text = @"--";
    _weatherLabel.numberOfLines = 0;
    _weatherLabel.adjustsFontSizeToFitWidth = YES;
    _weatherLabel.minimumScaleFactor = 0.8;
    _weatherLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_weatherLabel];
    
    _weatherImageView = [UIImageView new];
//    _weatherImageView.image = [UIImage imageNamed:@"晴"];
    _weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_weatherImageView];
    
    [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.centerX.equalTo(self);
        make.height.equalTo(@20.f);
    }];
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_weekLabel.mas_bottom);
        make.height.equalTo(@20.f);
    }];
    [_weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5.f);
        make.right.equalTo(self).offset(-3.f);
        make.top.equalTo(_dateLabel.mas_bottom).offset(5.f);
        make.height.equalTo(@30.f);
    }];
    [_weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_weatherLabel.mas_bottom).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
}

#pragma mark - Protocol


#pragma mark - Custom Accessors

@end
