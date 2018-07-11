//
//  WeatherView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/3.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherView.h"
#import "JYWeatherModel.h"
#import "WeatherTool.h"
#import "JYCalendarModel.h"
#import <CoreLocation/CoreLocation.h>
#import "WeatherUtil.h"
#import "JYCity.h"
#import "WeatherViewModel.h"

#define kShowWeatherCount 5

//适配多出的块间距??旧代码中拷贝的
#define blockDis (IS_IPHONE_4_SCREEN?8:0)
#define fontForSolarCalendar()(IS_IPHONE_4_SCREEN?53:(IS_IPHONE_5_SCREEN?53:(IS_IPHONE_6_SCREEN?58:63)))
#define fontForWeek()(IS_IPHONE_4_SCREEN?13:(IS_IPHONE_5_SCREEN?13:(IS_IPHONE_6_SCREEN?15:16)))
#define fontForAqi()(IS_IPHONE_4_SCREEN?12:(IS_IPHONE_5_SCREEN?12:(IS_IPHONE_6_SCREEN?14:15)))
#define IS_SMALL_THAN_IPHONE_6_SCREEN ((double)[ [UIScreen mainScreen ] bounds ].size.height - ( double )667 < 0 )
@interface WeatherView()<CLLocationManagerDelegate>
@property (nonatomic,strong) UIImageView *rightCornerImageView;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) JYCity *currentCity;
@end

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubviews];
        [self addNotication];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupSubviews];
        [self addNotication];
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"weather view dealloc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Private
- (void)addNotication
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSkin:) name:kNotificationForChangeSkin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        BOOL flag = NO;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                flag = YES;
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                flag = YES;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                flag = YES;
                break;
            default:
                break;
        }
        if(flag&&!self.dataFetchedSuccessful){
            [self locateCity];;
        }
    }];
    [manager startMonitoring];
}
- (void)applicationWillEnterForeground
{
    [self locateCity];
}

- (void)setupSubviews
{
    JYSkinManager *manager = [JYSkinManager shareSkinManager];

    _solarDayLabel = [UILabel new];
    _solarDayLabel.text = @"24";
    _solarDayLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:fontForSolarCalendar()];
    _solarDayLabel.textColor = manager.colorForDateBg;
    [_solarDayLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:_solarDayLabel];

    _weekLabel = [UILabel new];
    _weekLabel.text = @"Monday";
    _weekLabel.font = [UIFont fontWithName:@"segoe" size:fontForWeek()];
    _weekLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_weekLabel];

    _lunarLabel = [UILabel new];
    _lunarLabel.text = @"农历 --月----";
    _lunarLabel.font = [UIFont systemFontOfSize:fontForWeek()];
    _lunarLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_lunarLabel];

    _weatherImageView = [UIImageView new];
    _weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",manager.keywordForSkinColor]];
    _weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_weatherImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [_weatherImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    [self addSubview:_weatherImageView];
    
    _weatherLabel = [UILabel new];
    _weatherLabel.text = @"晴 21°C";
    _weatherLabel.font = [UIFont systemFontOfSize:fontForWeek()];
    _weatherLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_weatherLabel];
    
    _aqiLabel = [UILabel new];
    _aqiLabel.text = @"  数据未更新  ";
    _aqiLabel.layer.cornerRadius = 6.f;
    _aqiLabel.layer.borderColor = manager.colorForDateBg.CGColor;
    _aqiLabel.layer.borderWidth = 0.5f;
    _aqiLabel.layer.masksToBounds = YES;
    _aqiLabel.textColor = [UIColor lightGrayColor];
    _aqiLabel.font = [UIFont systemFontOfSize:fontForAqi()];
    _aqiLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_aqiLabel];
    
    _festivalImageView = [UIImageView new];
    _festivalImageView.contentMode = UIViewContentModeLeft;
    _festivalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_节日_%@",manager.keywordForSkinColor]];
    [_festivalImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _festivalImageView.hidden = YES;
    [self addSubview:_festivalImageView];
    
    _festivalLabel = [UILabel new];
    _festivalLabel.text = @"无";
    _festivalLabel.font = [UIFont systemFontOfSize:fontForWeek()];
    _festivalLabel.hidden = YES;
    [self addSubview:_festivalLabel];
    
    _festivalImageView2 = [UIImageView new];
    _festivalImageView2.contentMode = UIViewContentModeLeft;
    _festivalImageView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"佛字小"]];
    [_festivalImageView2 setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _festivalImageView2.hidden = YES;
    [self addSubview:_festivalImageView2];
    
    _festivalLabel2 = [UILabel new];
    _festivalLabel2.text = @"释迦牟尼";
    _festivalLabel2.font = [UIFont systemFontOfSize:fontForWeek()];
    _festivalLabel2.hidden = YES;
    [self addSubview:_festivalLabel2];
    
    _locationImageView = [UIImageView new];
    _locationImageView.contentMode = UIViewContentModeLeft;
    _locationImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_定位_%@",manager.keywordForSkinColor]];
    [_locationImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self addSubview:_locationImageView];
    
    _locationLabel = [UILabel new];
    _locationLabel.text = @"定位失败";
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kCurrentLocationKey];
    if(city&&![city isKindOfClass:[NSNull class]]){
        _locationLabel.text = city;
    }
    _locationLabel.font = [UIFont systemFontOfSize:fontForWeek()];
    [self addSubview:_locationLabel];
    
    _rightCornerImageView = [UIImageView new];
    _rightCornerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _rightCornerImageView.image = [UIImage imageNamed:@"日历进入提示"];
    [self addSubview:_rightCornerImageView];
    
    CGFloat horPadding = 40.f/ 750.0 * kScreenWidth;//水平边距
    CGFloat horMargin = 8;
    CGFloat verPadding = (25.f / 1334.0 * kScreenHeight);//垂直边距
    CGFloat verMargin = 20.f / 1334.0 * kScreenHeight;//垂直边距
    CGFloat solarHeight = (110.f / 1334.0 * kScreenHeight + blockDis);
    CGFloat weatherImageHeight = 35.f;
    CGFloat festivalImageHeight = 16.f;
    CGFloat rightCornerViewWidth = 25.f;
    
    [_solarDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(horPadding);
        make.top.equalTo(self).offset(verPadding);
        make.height.equalTo(@(solarHeight));
    }];
    [_weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_solarDayLabel.mas_right).offset(horMargin);
        make.top.equalTo(_solarDayLabel).offset(IS_SMALL_THAN_IPHONE_6_SCREEN?0:3.f);
        make.right.equalTo(self.mas_centerX).offset(20.f); //中心靠右20点
    }];
    [_lunarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_weekLabel);
        make.bottom.equalTo(_solarDayLabel).offset(-3.f);
    }];
    [_weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_centerX).offset(20.f+horMargin); //中心靠右20点
        make.centerY.equalTo(_solarDayLabel);
        make.height.lessThanOrEqualTo(@(weatherImageHeight));
        make.width.lessThanOrEqualTo(@(weatherImageHeight));
    }];
    [_weatherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weatherImageView.mas_right).offset(horMargin);
        make.top.equalTo(_weekLabel);
        make.right.equalTo(self.rightCornerImageView.mas_left);
    }];
    [_aqiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_weatherLabel);
        make.height.equalTo(IS_SMALL_THAN_IPHONE_6_SCREEN?@(20.f):@(24.f));
        make.bottom.equalTo(_lunarLabel);
    }];
    [_festivalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_solarDayLabel);
        make.top.equalTo(_solarDayLabel.mas_bottom).offset(verMargin);
        make.height.equalTo(@(festivalImageHeight));
        make.width.equalTo(@(festivalImageHeight));
    }];
    [_festivalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_festivalImageView.mas_right).offset(horMargin);
        make.right.equalTo(_weekLabel);
        make.centerY.equalTo(_festivalImageView);
    }];
    [_festivalImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_solarDayLabel);
        make.top.equalTo(_festivalImageView.mas_bottom).offset(verMargin);
        make.height.equalTo(@(festivalImageHeight));
        make.width.equalTo(@(festivalImageHeight));
    }];
    [_festivalLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_festivalImageView2.mas_right).offset(horMargin);
        make.right.equalTo(_weekLabel);
        make.centerY.equalTo(_festivalImageView2);
    }];
    [_locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_weatherImageView);
        make.left.equalTo(_weatherImageView);
        make.centerY.equalTo(_festivalImageView);
        make.height.equalTo(@(festivalImageHeight));
        make.width.equalTo(@(festivalImageHeight));
    }];

    [_locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_locationImageView.mas_right).offset(horMargin);
        make.right.equalTo(_weatherLabel);
        make.centerY.equalTo(_locationImageView);
    }];
    [_rightCornerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(rightCornerViewWidth));
        make.right.top.equalTo(self);
    }];
//    [self queryWeather];
    
//    [self locateCity];
    //定时刷新天气雨空气，1小时重复一次，永不停止/改半小时
    [NSTimer scheduledTimerWithTimeInterval:30*60 target:self selector:@selector(queryCurrentCityWeather) userInfo:nil repeats:YES];
    
}
//- (void)queryWeather
//{
//    //旧代码原有逻辑拷贝
//    WeatherTool *weatherT = [WeatherTool shareWeatherTool];
//    [weatherT request:kWeatherUrl withHttpArg:@"city=beijing"];
//    
//    __weak typeof(self) weakSelf = self;
//    [weatherT setArrForPassModel:^void(NSArray *arr){
//        if([arr isKindOfClass:[NSArray class]]){
//            weakSelf.weatherModel = arr[0];
//        }else{
//            weakSelf.weatherModel = nil;
//        }
//    }];
//}
- (void)changeSkin:(NSNotification *)notice
{
    _aqiLabel.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
    _solarDayLabel.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    if(self.calendarModel.festival){//节日不为空那_festivalImageView肯定放的是节日图片
        _festivalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_节日_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    }
    _locationImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_定位_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    _weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    
}
- (void)didMoveToSuperview
{
    NSLog(@"didMoveToSuperview===");
    [self locateCity];
}
- (void)locateCity
{
    if(!self.locationManager){
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }

    if ([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            //提示用户无法进行定位操作
            if(![[NSUserDefaults standardUserDefaults]boolForKey:kHasAlertLocationSettingKey]){
                //提示用户无法进行定位操作
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kHasAlertLocationSettingKey];
            }
            [self loadCacheData];
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }else{
             [self.locationManager startUpdatingLocation];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查您的设备是否开启了定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
//查询当前定位城市天气
- (void)queryCurrentCityWeather
{
    if(!self.isQuerying){
        self.isQuerying = YES;
        //旧代码原有逻辑拷贝
//        WeatherTool *weatherT = [WeatherTool shareWeatherTool];
//        NSString *arg = [NSString stringWithFormat:@"cityid=%@",self.currentCity.countyId];
//        [weatherT request:kWeatherUrl withHttpArg:arg];
//        
//        __weak typeof(self) weakSelf = self;
//        [weatherT setArrForPassModel:^void(NSArray *arr){
//            weakSelf.isQuerying = NO;
//            if([arr isKindOfClass:[NSArray class]]){
//                weakSelf.weatherModel = arr[0];
//                weakSelf.dataFetchedSuccessful = YES;
//            }else{
//                weakSelf.weatherModel = nil;
//                weakSelf.dataFetchedSuccessful = NO;
//            }
//        }];
        
        @weakify(self)
        [RequestManager queryWeatherDataWithCity:self.currentCity completed:^(id data, NSError *error) {
            @strongify(self)
            if([data isKindOfClass:[NSDictionary class]]){
                
                WeatherViewModel *model = [[WeatherViewModel alloc] initWithDictionary:data];
                if(model){
                    self.weatherModel = model;
                    self.dataFetchedSuccessful = YES;
                }else{
                    self.dataFetchedSuccessful = NO;
                }
            }
            
        }];
    }

}
- (void)loadCacheData
{
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kCurrentLocationKey];
    if(city&&![city isKindOfClass:[NSNull class]]){
        self.locationLabel.text = city;
        self.currentCity = [[WeatherUtil sharedUtil]findCityModelWithName:city];
        [self queryCurrentCityWeather];
    }
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status==kCLAuthorizationStatusDenied){
        //提示用户无法进行定位操作
        if(![[NSUserDefaults standardUserDefaults]boolForKey:kHasAlertLocationSettingKey]){
            //提示用户无法进行定位操作
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kHasAlertLocationSettingKey];
        }

    }else{
        [self.locationManager startUpdatingLocation];
    }
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    //    CLLocationCoordinate2D coordinate = location.coordinate;
    //    NSLog(@"纬度:%f 经度:%f", coordinate.latitude, coordinate.longitude);
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             if(city){
//                 if(!self.currentCity){
                     self.currentCity = [[WeatherUtil sharedUtil]findCityModelWithName:city];
                     self.locationLabel.text = self.currentCity.city;
                     [[NSUserDefaults standardUserDefaults]setObject:self.currentCity.city forKey:kCurrentLocationKey];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     [self queryCurrentCityWeather];
//                 }
             }else{
                 [self loadCacheData];
             }
         }else if (error == nil && [array count] == 0){
             NSLog(@"No results were returned.");
             [self loadCacheData];
         }else if (error != nil){
             [self loadCacheData];
             NSLog(@"An error occurred = %@", error);
         }
     }];
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error) {
        NSLog(@"error:%@",error.localizedDescription);
        [self loadCacheData];
    }
}
#pragma mark - Custom Accessors

//- (void)setWeatherModel:(JYWeatherModel *)model
//{
//    _weatherModel = model;
//    
//    if(model&&self.calendarModel.dateOrder==JYDateOrderEqualToday){
//        
//        //天气图片
//        if([model.weatherInfo isEqual: @"晴"]){
//            _weatherImageView.image = [UIImage imageNamed:@"晴.png"];
//        }else if([model.weatherInfo isEqual: @"阴"]){
//            _weatherImageView.image = [UIImage imageNamed:@"阴.png"];
//        }else if([model.weatherInfo isEqual: @"雾"]||[model.weatherInfo isEqual: @"霾"]){
//            _weatherImageView.image = [UIImage imageNamed:@"雾.png"];
//        }else if([model.weatherInfo isEqual: @"雨夹雪"]){
//            _weatherImageView.image = [UIImage imageNamed:@"雨夹雪.png"];
//        }else if([model.weatherInfo rangeOfString:@"冰雹"].location != NSNotFound){
//            _weatherImageView.image = [UIImage imageNamed:@"冰雹.png"];
//        }else if([model.weatherInfo rangeOfString:@"风"].location != NSNotFound){
//            _weatherImageView.image = [UIImage imageNamed:@"暴风.png"];
//        }else if([model.weatherInfo rangeOfString:@"雪"].location != NSNotFound){
//            _weatherImageView.image = [UIImage imageNamed:@"暴雪.png"];
//        }else if([model.weatherInfo rangeOfString:@"雨"].location != NSNotFound){
//            _weatherImageView.image = [UIImage imageNamed:@"小雨.png"];
//        }else if([model.weatherInfo rangeOfString:@"云"].location != NSNotFound){
//            _weatherImageView.image = [UIImage imageNamed:@"多云.png"];
//        }else if([model.weatherInfo rangeOfString:@"沙"].location != NSNotFound || [model.weatherInfo rangeOfString:@"尘"].location != NSNotFound){
//            _weatherImageView.image = [UIImage imageNamed:@"沙尘暴.png"];
//        }else{
//            NSString *urlStr = [[NSString alloc] initWithFormat:@"%@%@.png", kWeatherPng, model.weatherCode];
//            NSURL *url = [NSURL URLWithString:urlStr];
//            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
//            [_weatherImageView sd_setImageWithURL:url placeholderImage:img completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                _weatherModel.weatherImage = image;
//            }];
//        }
//        _weatherModel.weatherImage = _weatherImageView.image;
//        
//        //空气质量信息取前两位
//        if(model.aqiinfo.length > 2){
//            model.aqiinfo = [model.aqiinfo substringWithRange:NSMakeRange(0,2)];
//        }
//        
//        NSString *kongge;
//        if(model.aqiinfo.length + model.aqi.length < 5) {
//            kongge = @"  ";
//        }else {
//            kongge = @" ";
//        }
//        if(model.aqiinfo&&model.aqi){
//            _aqiLabel.textColor = [UIColor blackColor];
//            _aqiLabel.text = [[NSString alloc] initWithFormat:@"  %@%@%@  ",model.aqiinfo, kongge, model.aqi];
//        }else{
//            _aqiLabel.textColor = [UIColor lightGrayColor];
//            _aqiLabel.text = @"  数据未更新  ";
//        }
////        _aqiLabel.text = [[NSString alloc] initWithFormat:@"  %@%@%@  ",model.aqiinfo, kongge, model.aqi];
////        _aqiLabel.textColor = [UIColor blackColor];
//        _weatherLabel.text = [[NSString alloc] initWithFormat:@"%@%@%@°C", model.weatherInfo,kongge,model.temper];
//        _locationLabel.text = model.city;
//        
//    }else{
//        _weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
//        _aqiLabel.text = @"  数据未更新  ";
//        _aqiLabel.textColor = [UIColor lightGrayColor];
//        _weatherLabel.text = @"Weather °C";
//    }
//}
- (void)setWeatherModel:(WeatherViewModel *)model
{
    _weatherModel = model;
    
    if(model&&self.calendarModel.dateOrder==JYDateOrderEqualToday){
        
        //天气图片
        if([model.currentWeather isEqual: @"晴"]){
            _weatherImageView.image = [UIImage imageNamed:@"晴.png"];
        }else if([model.currentWeather isEqual: @"阴"]){
            _weatherImageView.image = [UIImage imageNamed:@"阴.png"];
        }else if([model.currentWeather isEqual: @"雾"]||[model.currentWeather isEqual: @"霾"]){
            _weatherImageView.image = [UIImage imageNamed:@"雾.png"];
        }else if([model.currentWeather isEqual: @"雨夹雪"]){
            _weatherImageView.image = [UIImage imageNamed:@"雨夹雪.png"];
        }else if([model.currentWeather rangeOfString:@"冰雹"].location != NSNotFound){
            _weatherImageView.image = [UIImage imageNamed:@"冰雹.png"];
        }else if([model.currentWeather rangeOfString:@"风"].location != NSNotFound){
            _weatherImageView.image = [UIImage imageNamed:@"暴风.png"];
        }else if([model.currentWeather rangeOfString:@"雪"].location != NSNotFound){
            _weatherImageView.image = [UIImage imageNamed:@"暴雪.png"];
        }else if([model.currentWeather rangeOfString:@"雨"].location != NSNotFound){
            _weatherImageView.image = [UIImage imageNamed:@"小雨.png"];
        }else if([model.currentWeather rangeOfString:@"云"].location != NSNotFound){
            _weatherImageView.image = [UIImage imageNamed:@"多云.png"];
        }else if([model.currentWeather rangeOfString:@"沙"].location != NSNotFound || [model.currentWeather rangeOfString:@"尘"].location != NSNotFound){
            _weatherImageView.image = [UIImage imageNamed:@"沙尘暴.png"];
        }else{
            _weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
        }
        _weatherModel.weatherImage = _weatherImageView.image;
        
        //空气质量信息取前两位
        if([model.aqi integerValue]<50){
            model.aqiInfo = @"优";
        }else if([model.aqi integerValue]<100){
            model.aqiInfo = @"良";
        }else if([model.aqi integerValue]<200){
            model.aqiInfo = @"轻度";
        }else if([model.aqi integerValue]<300){
            model.aqiInfo = @"中度";
        }else{
            model.aqiInfo = @"重度";
        }
        
        NSString *kongge;
        if(model.aqiInfo.length + model.aqi.length < 5) {
            kongge = @"  ";
        }else {
            kongge = @" ";
        }
        if(model.aqiInfo&&model.aqi){
            _aqiLabel.textColor = [UIColor blackColor];
            _aqiLabel.text = [[NSString alloc] initWithFormat:@"  %@%@%@  ",model.aqiInfo, kongge, model.aqi];
        }else{
            _aqiLabel.textColor = [UIColor lightGrayColor];
            _aqiLabel.text = @"  数据未更新  ";
        }
        _weatherLabel.text = [[NSString alloc] initWithFormat:@"%@%@%@°C", model.currentWeather,kongge,model.currentTemperature];
        _locationLabel.text = model.city;
        
    }else{
        _weatherImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
        _aqiLabel.text = @"  数据未更新  ";
        _aqiLabel.textColor = [UIColor lightGrayColor];
        _weatherLabel.text = @"Weather °C";
    }
}
- (void)setCalendarModel:(JYCalendarModel *)calendarModel
{
    _calendarModel = calendarModel;
    
    _solarDayLabel.text = [NSString stringWithFormat:@"%ld",calendarModel.day];
    _lunarLabel.text = [NSString stringWithFormat:@"农历 %@%@",calendarModel.lunarMonth,calendarModel.lunarDay];
    _weekLabel.text = calendarModel.weekEnString;
    
    
    /*
     节日和佛历：
     1.只有节日，weatherView高度正常，_festivalImageView和_festivalLabel显示节日图片文字
     2.只有佛历，weatherView高度正常，_festivalImageView和_festivalLabel显示佛历图片文字
     3.都有，weatherView高度加大，_festivalImageView和_festivalLabel显示节日图片文字，_festivalImageView2和_festivalLabel2显示佛历图片文字
     4.都没有
     */
    int festivalCount = 0;
    if(calendarModel.festival&&![calendarModel.festival isEmpty]){
        festivalCount += 1;
    }
    if(calendarModel.foDay){
        festivalCount += 1;
    }
    if(festivalCount==0){//不显示节日
        _festivalImageView.hidden = YES;
        _festivalLabel.hidden = YES;
        _festivalImageView2.hidden = YES;
        _festivalLabel2.hidden = YES;
    }if(festivalCount==1){//显示一排节日
        _festivalImageView.hidden = NO;
        _festivalLabel.hidden = NO;
        _festivalImageView2.hidden = YES;
        _festivalLabel2.hidden = YES;
        if(![calendarModel.festival isEmpty]){
            _festivalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_节日_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
            _festivalLabel.text = [calendarModel.festival trimWhitespace];
            _festivalLabel.textColor = [UIColor blackColor];
       }else if(calendarModel.foDay){
            _festivalImageView.image = [UIImage imageNamed:@"佛字小"];
            _festivalLabel.text = [calendarModel.foDay trimWhitespace];
            _festivalLabel.textColor = UIColorFromRGB(0xAE7B06);
        }
        
    }if(festivalCount==2){//显示两排节日
        _festivalImageView.hidden = NO;
        _festivalLabel.hidden = NO;
        _festivalImageView2.hidden = NO;
        _festivalLabel2.hidden = NO;
       
        _festivalImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_节日_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
        _festivalLabel.text = [calendarModel.festival trimWhitespace];
        _festivalLabel.textColor = [UIColor blackColor];
        
        _festivalImageView2.image = [UIImage imageNamed:@"佛字小"];
        _festivalLabel2.text = [calendarModel.foDay trimWhitespace];
       _festivalLabel2.textColor = UIColorFromRGB(0xAE7B06);
    }
    
    if(festivalCount<=1){//矮高度
        CGRect frame = self.frame;
        frame.size.height = kHeightForWeather;
        self.frame = frame;
    }else{//高度需要加大
        CGRect frame = self.frame;
        frame.size.height = kHeightForWeatherBig;
        self.frame = frame;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForWeatherViewRefreshHeight object:nil];
    
    UIImage *weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    JYDateOrder order = calendarModel.dateOrder;
    
    
    if(order==JYDateOrderAfterToday){
        NSDate *today = [NSDate date];
        NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:today];
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        today = [cal dateFromComponents:components];//今日0点时间
        NSDateComponents *diffComp = [cal components:NSCalendarUnitDay fromDate:today toDate:calendarModel.date options:0];
        self.aqiLabel.text = @"  数据未更新  ";
        self.aqiLabel.textColor = [UIColor lightGrayColor];
        self.weatherImageView.image = weatherImage;
        _weatherLabel.text = @"Weather °C";
        if(diffComp.day<kShowWeatherCount){
            WeatherModel *wmodel = self.weatherModel.weatherArray[diffComp.day];
            if(wmodel){
                _weatherLabel.text = [[NSString alloc] initWithFormat:@"%@  %ld/%ld°C", wmodel.weatherStr,wmodel.minTemp,wmodel.maxTemp];
                if([wmodel.weatherIconName hasPrefix:@"http"]){
                    [_weatherImageView sd_setImageWithURL:[NSURL URLWithString:wmodel.weatherIconName] placeholderImage:weatherImage];
                }else{
                    _weatherImageView.image = [UIImage imageNamed:wmodel.weatherIconName];
                }
            }
        }
    }else if(order==JYDateOrderEqualToday){//今天
        
        [self setWeatherModel:self.weatherModel];
        
    }else if(order==JYDateOrderBeforeToday){
        self.aqiLabel.text = @"  数据已过期  ";
        self.weatherLabel.text = @"Weather °C";
        self.aqiLabel.textColor = [UIColor lightGrayColor];
        self.weatherImageView.image = weatherImage;
    }
    
}
- (WeatherViewModel *)selectedWeatherModel{
    
    _selectedWeatherModel = [WeatherViewModel new];
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kCurrentLocationKey];
    if(city){
        _selectedWeatherModel.city = city;
    }else{
        _selectedWeatherModel.city = @"定位失败";
    }
    
    JYDateOrder order = self.calendarModel.dateOrder;
    UIImage *weatherImage = [UIImage imageNamed:[NSString stringWithFormat:@"温度计_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    if(order==JYDateOrderAfterToday){
        NSDate *today = [NSDate date];
        NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:today];
        components.hour = 0;
        components.minute = 0;
        components.second = 0;
        today = [cal dateFromComponents:components];//今日0点时间
        NSDateComponents *diffComp = [cal components:NSCalendarUnitDay fromDate:today toDate:self.calendarModel.date options:0];
        _selectedWeatherModel.currentTemperature = @"";
        _selectedWeatherModel.currentWeather = @"Weather";
        _selectedWeatherModel.weatherImage = weatherImage;
        
        
        if(diffComp.day<kShowWeatherCount){//未来6日天气
            WeatherModel *wmodel = self.weatherModel.weatherArray[diffComp.day];
            if(wmodel){
                _selectedWeatherModel.currentWeather = [[NSString alloc] initWithFormat:@"%@", wmodel.weatherStr];
                _selectedWeatherModel.currentTemperature = [NSString stringWithFormat:@"%ld/%ld",wmodel.minTemp,wmodel.maxTemp];
                _selectedWeatherModel.weatherImage = self.weatherImageView.image==nil?weatherImage:self.weatherImageView.image;
            }
        }
        _selectedWeatherModel.aqiInfo = @"数据未更新";
        _selectedWeatherModel.aqi = @"";
        
    }else if(order==JYDateOrderEqualToday){
        _selectedWeatherModel.aqiInfo = (self.weatherModel.aqiInfo==nil||[self.weatherModel.aqiInfo isKindOfClass:[NSNull class]]||[self.weatherModel.aqiInfo isEqualToString:@"(null)"])?@"数据未更新":self.weatherModel.aqiInfo;
        _selectedWeatherModel.aqi = (self.weatherModel.aqi==nil||[self.weatherModel.aqi isKindOfClass:[NSNull class]]||[self.weatherModel.aqi isEqualToString:@"(null)"])?@"":self.weatherModel.aqi;
        _selectedWeatherModel.currentTemperature = self.weatherModel.currentTemperature==nil?@"":self.weatherModel.currentTemperature;
        _selectedWeatherModel.currentWeather = self.weatherModel.currentWeather==nil?@"Weather":self.weatherModel.currentWeather;
        _selectedWeatherModel.weatherImage = self.weatherModel.weatherImage==nil?weatherImage:self.weatherModel.weatherImage;
        
    }else if(order==JYDateOrderBeforeToday){
        
        _selectedWeatherModel.aqiInfo = @"数据已过期";_selectedWeatherModel.aqi = @"";
        _selectedWeatherModel.currentTemperature = @"";
        _selectedWeatherModel.currentWeather = @"Weather";
        _selectedWeatherModel.weatherImage = weatherImage;

    }
    _selectedWeatherModel.weatherArray = [NSArray arrayWithArray:self.weatherModel.weatherArray];// 传入未来5天天气
    
    return _selectedWeatherModel;
}
@end
