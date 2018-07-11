//
//  WeatherViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherPageView.h"
#import "WeatherViewModel.h"
#import <CoreLocation/CoreLocation.h>
#import "JYCity.h"
#import "WeatherUtil.h"
#import "DXPopover.h"
#import "WeatherMenuView.h"
#import "AddNewCityViewController.h"
#import "SwipeView.h"
#import "WeatherCache.h"

#define kBottomViewHeight 80.f

#define kLastShowIndexKey @"kLastShowIndexKey" //最后一次查看时的索引未知
@interface WeatherViewController()<UIScrollViewDelegate,CLLocationManagerDelegate,SwipeViewDataSource,SwipeViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) NSMutableDictionary *weatherModelDict;
//底部
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *optionBtn;
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) DXPopover *popover;
@property (nonatomic,strong) WeatherMenuView *menuView;
@property (nonatomic,strong) JYCity *currentCity;
@property (nonatomic,strong) NSArray *menus;
@property (nonatomic,strong) SwipeView *swipeView;

@property (nonatomic,strong) NSArray *weekStrs;
@property (nonatomic,strong) NSArray *dateStrs;

@property (nonatomic,assign) BOOL enterFlag;
@property (nonatomic,assign) BOOL isQuerying;
@end

@implementation WeatherViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xD18787);
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addCity:) name:kNotificationWeatherAddNewCity object:nil];
    [self setupSubviews];
    
//    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentLocationKey];
//    if(city&&![city isKindOfClass:[NSNull class]]){
//        self.currentCity = [[WeatherUtil sharedUtil]findCityModelWithName:city];
//        [self queryCurrentCityWeather];
//    }else{
        
//    }
    if ([_cityString isEqualToString:@"定位失败"] || [_cityString isEqualToString:@""] || _cityString == nil) {
        [self locateCity];
    }else{
        
        NSArray *arr = [[WeatherUtil sharedUtil] searchCitiesWithKeyword:_cityString];
        for (JYCity * city in arr) {
            if ([city.county isEqualToString:_cityString]) {
                self.currentCity = city;
                NSLog(@"%@",self.currentCity);
                [self queryCurrentCityWeather]; 
            }
        }
    }
    [self queryWeatherData];
    
    [self.swipeView reloadData];
    if(!self.enterFlag){
        NSInteger lastShowPage = [[NSUserDefaults standardUserDefaults]integerForKey:kLastShowIndexKey];
        self.pageControl.currentPage = lastShowPage;
//        [self.swipeView scrollToPage:lastShowPage duration:0];
        self.swipeView.scrollOffset = lastShowPage+[[WeatherUtil sharedUtil].citiesManualAdded count];
        self.enterFlag = YES;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //navigationBar透明
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - Public


#pragma mark - Private
#pragma mark UI
- (void)setupSubviews
{
    [self customNav];
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.swipeView];
    [self.view addSubview:self.bottomView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@kBottomViewHeight);
    }];

}
- (void)customNav
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tintColor = [UIColor whiteColor];
    [leftBtn setImage:[[JYSkinManager shareSkinManager].backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}
#pragma mark Event Handler
- (void)popAction:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults]setInteger:self.pageControl.currentPage forKey:kLastShowIndexKey];
    
    //恢复navigationBar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)menuBtnClicked:(UIButton *)sender
{
    CGRect rect = [self.view convertRect:sender.frame fromView:self.bottomView];
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)-10);
    CGFloat height = [self.menus count]*kMenuRowHeight;
    self.menuView.frame = CGRectMake(0, 0,80, height);
    self.menuView.menuNames = self.menus;
    
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionUp
              withContentView:self.menuView
                       inView:self.navigationController.view];
}
- (void)pushToAddNewCityVC
{
    if([[WeatherUtil sharedUtil].citiesManualAdded count]>=5){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，城市数量已达上限！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    AddNewCityViewController *newCityVC = [[AddNewCityViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:newCityVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}
- (void)deleteCurrentCity
{
    NSInteger page = self.pageControl.currentPage;
    [[WeatherUtil sharedUtil]deleteCityAtIndex:page-1];
    [self.swipeView reloadData];
    self.pageControl.numberOfPages = [[WeatherUtil sharedUtil].citiesManualAdded count]+1;
    if(page>[[WeatherUtil sharedUtil].citiesManualAdded count]){
        self.pageControl.currentPage = [[WeatherUtil sharedUtil].citiesManualAdded count];
    }
    
}
- (void)addCity:(NSNotification *)notification
{
    JYCity *city = notification.userInfo[kNewCityKey];
    if([[WeatherUtil sharedUtil].citiesManualAdded count]>=5){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"抱歉，城市数量已达上限！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [[WeatherUtil sharedUtil]addNewCity:city];
    [self.swipeView reloadData];
    
    NSInteger cityCount = [[WeatherUtil sharedUtil].citiesManualAdded count]+1;
    self.pageControl.numberOfPages = cityCount;
    self.pageControl.currentPage = cityCount - 1;
    [self.swipeView scrollToPage:cityCount-1 duration:0.35];
    __weak typeof(self) ws = self;
    [RequestManager queryWeatherDataWithCity:city completed:^(id data, NSError *error) {
        
        if([data isKindOfClass:[NSDictionary class]]){
            WeatherViewModel *model = [[WeatherViewModel alloc] initWithDictionary:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(city.cityType==JYCityTypeInland){
                    [ws.weatherModelDict setObject:model forKey:city.countyId];
                }else{
                    [ws.weatherModelDict setObject:model forKey:city.cityNameEN];
                }
                UIView *view = [ws.swipeView itemViewAtIndex:cityCount-1];
                for(WeatherPageView *pageView in view.subviews){
                    pageView.viewModel = model;
                    if(city.cityType==JYCityTypeInland){
                        pageView.cityLabel.text = city.county;
                    }else{
                        pageView.cityLabel.text = city.city;
                    }
                }
                //缓存
                WeatherCache *cache = [WeatherCache sharedCache];
                if(city.cityType==JYCityTypeInland){
                    [cache cacheWeather:model forKey:city.countyId];
                }else{
                    [cache cacheWeather:model forKey:city.cityNameEN];
                }
            });
        }
    }];
}
- (void)pageControlClicked:(UIPageControl *)pageControl
{
    NSInteger page = pageControl.currentPage;
    [self.swipeView scrollToPage:page duration:0.35];

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
#pragma mark Net/Data
- (void)queryWeatherData
{
    NSArray *cities = [[WeatherUtil sharedUtil]citiesManualAdded];
    
    //读缓存
    for(int i=0; i<[cities count]; i++){
        JYCity *city = cities[i];
        WeatherCache *cache = [WeatherCache sharedCache];
        WeatherViewModel *model;
        if(![cache hasExpired]){
            if(city.cityType==JYCityTypeInland){
                model = [cache cachedWeatherForKey:city.countyId];
            }else{
                model = [cache cachedWeatherForKey:city.cityNameEN];
            }
        }
        if(model){
            if(city.cityType==JYCityTypeInland){
                [self.weatherModelDict setObject:model forKey:city.countyId];
            }else{
                [self.weatherModelDict setObject:model forKey:city.cityNameEN];
            }
            UIView *view = [self.swipeView itemViewAtIndex:i+1];
            for(WeatherPageView *pageView in view.subviews){
                pageView.viewModel = model;
                if(city.cityType==JYCityTypeInland){
                    pageView.cityLabel.text = city.county;
                }else{
                    pageView.cityLabel.text = city.city;
                }
            }
            
        }else{
            //网络加载
            __weak typeof(self) ws = self;
            [RequestManager queryWeatherDataWithCity:city completed:^(id data, NSError *error) {
                
                if([data isKindOfClass:[NSDictionary class]]){
                    WeatherViewModel *model = [[WeatherViewModel alloc] initWithDictionary:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(city.cityType==JYCityTypeInland){
                            [ws.weatherModelDict setObject:model forKey:city.countyId];
                        }else{
                            [ws.weatherModelDict setObject:model forKey:city.cityNameEN];
                        }
                        //                    [ws.swipeView reloadItemAtIndex:i+1];
                        UIView *view = [ws.swipeView itemViewAtIndex:i+1];
                        for(WeatherPageView *pageView in view.subviews){
                            pageView.viewModel = model;
                            if(city.cityType==JYCityTypeInland){
                                pageView.cityLabel.text = city.county;
                            }else{
                                pageView.cityLabel.text = city.city;
                            }
                        }
                    });
                    
                    //缓存
                    WeatherCache *cache = [WeatherCache sharedCache];
                    if(city.cityType==JYCityTypeInland){
                        [cache cacheWeather:model forKey:city.countyId];
                    }else{
                        [cache cacheWeather:model forKey:city.cityNameEN];
                    }
                    if(i==[cities count]-1){
                        cache.cacheTimestamp = [NSDate timeIntervalSinceReferenceDate];
                    }
                }
            }];
        }
    }
}

//查询当前定位城市天气
- (void)queryCurrentCityWeather
{
    //读缓存
    WeatherCache *cache = [WeatherCache sharedCache];
    WeatherViewModel *model;
    if(![cache hasExpired]){
        if(self.currentCity.cityType==JYCityTypeInland){
            model = [cache cachedWeatherForKey:self.currentCity.countyId];
        }else{
            model = [cache cachedWeatherForKey:self.currentCity.cityNameEN];
        }
    }
    if(model){
        
        if(self.currentCity.cityType==JYCityTypeInland){
            [self.weatherModelDict setObject:model forKey:self.currentCity.countyId];
        }else{
            [self.weatherModelDict setObject:model forKey:self.currentCity.cityNameEN];
        }
        UIView *view = [self.swipeView itemViewAtIndex:0];
        for(WeatherPageView *pageView in view.subviews){
            pageView.viewModel = model;
            pageView.cityLabel.text = self.currentCity.county;
        }
    }else{
        //网络加载
        if(self.currentCity&&!self.isQuerying){
            __weak typeof(self) ws = self;
            self.isQuerying = YES;
            [RequestManager queryWeatherDataWithCity:self.currentCity completed:^(id data, NSError *error) {
                if([data isKindOfClass:[NSDictionary class]]){
                    WeatherViewModel *model = [[WeatherViewModel alloc] initWithDictionary:data];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(self.currentCity.cityType==JYCityTypeInland){
                            [ws.weatherModelDict setObject:model forKey:self.currentCity.countyId];
                        }else{
                            [ws.weatherModelDict setObject:model forKey:self.currentCity.cityNameEN];
                        }
                        
                        //缓存
                        WeatherCache *cache = [WeatherCache sharedCache];
                        if(self.currentCity.cityType==JYCityTypeInland){
                            [cache cacheWeather:model forKey:self.currentCity.countyId];
                        }else{
                            [cache cacheWeather:model forKey:self.currentCity.cityNameEN];
                        }
                        cache.cacheTimestamp = [NSDate timeIntervalSinceReferenceDate];
                        
                        
                        //                    [ws.swipeView reloadItemAtIndex:0];
                        UIView *view = [ws.swipeView itemViewAtIndex:0];
                        for(WeatherPageView *pageView in view.subviews){
                            pageView.viewModel = model;
                            pageView.cityLabel.text = self.currentCity.county;
                        }
                        self.isQuerying = NO;
                    });
                }
            }];
        }
        
    }
    
    
}
- (void)setupDataForPageView:(WeatherPageView *)pageView atIndex:(NSInteger)index
{
    if(index==0){//定位页
        if(self.currentCity.cityType==JYCityTypeInland){
            pageView.viewModel = [self.weatherModelDict objectForKey:self.currentCity.countyId];
        }else{
            pageView.viewModel = [self.weatherModelDict objectForKey:self.currentCity.cityNameEN];
        }
        if(self.currentCity){
            pageView.cityLabel.text = self.currentCity.county;
        }else{
            pageView.cityLabel.text = @"未知城市";
        }
    }else{
        NSArray *cities = [[WeatherUtil sharedUtil]citiesManualAdded];
        JYCity *city = cities[index-1];
        if(city.cityType==JYCityTypeInland){
            pageView.viewModel = [self.weatherModelDict objectForKey:city.countyId];
            pageView.cityLabel.text = city.county;
        }else{
            pageView.viewModel = [self.weatherModelDict objectForKey:city.cityNameEN];
            pageView.cityLabel.text = city.city;
        }
    }
    
}
- (void)loadCacheData
{
    NSString *city = [[NSUserDefaults standardUserDefaults]objectForKey:kCurrentLocationKey];
    if(city&&![city isKindOfClass:[NSNull class]]){
        self.currentCity = [[WeatherUtil sharedUtil]findCityModelWithName:city];
        [self queryCurrentCityWeather];
    }
}
#pragma mark - Protocol
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status==kCLAuthorizationStatusDenied){
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
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
//    location = [[CLLocation alloc] initWithLatitude:35.42 longitude:139.46];
    NSLog(@"%@",location);
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
//             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:city message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//             [alert show];
             NSLog(@"city = %@", city);
             if(city&&!self.currentCity){
                 self.currentCity = [[WeatherUtil sharedUtil]findCityModelWithName:city];
                 NSLog(@"%@",self.currentCity);
                 [self queryCurrentCityWeather];
             }else{
                 [self loadCacheData];
             }
         }else if (error == nil && [array count] == 0){
             NSLog(@"No results were returned.");
             [self loadCacheData];
         }else if (error != nil){
             NSLog(@"An error occurred = %@", error);
             [self loadCacheData];
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
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    NSArray *cities = [[WeatherUtil sharedUtil]citiesManualAdded];
    return [cities count]+1;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if(!view){
        view = [UIView new];
        WeatherPageView *pageView = [[WeatherPageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kBottomViewHeight)];
        if(index==0){
            [pageView setCity:@"未知城市" weekStrs:self.weekStrs dateStrs:self.dateStrs];
        }else{
            NSArray *cities = [[WeatherUtil sharedUtil]citiesManualAdded];
            if(index<=[cities count]){
                JYCity *city = cities[index-1];
                if(city.cityType==JYCityTypeInland){
                    [pageView setCity:city.county weekStrs:self.weekStrs dateStrs:self.dateStrs];
                }else{
                    [pageView setCity:city.city weekStrs:self.weekStrs dateStrs:self.dateStrs];
                }
            }
        }
        [self setupDataForPageView:pageView atIndex:index];
        [view addSubview:pageView];
    }
    else
    {
        for(WeatherPageView *pageView in view.subviews){
            [self setupDataForPageView:pageView atIndex:index];
            break;
        }
    }
    return view;
}

- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
//    return CGSizeMake(kScreenWidth, kScreenHeight-kBottomViewHeight);
}
- (void)swipeViewDidEndScrollingAnimation:(SwipeView *)swipeView
{
    self.pageControl.currentPage = swipeView.currentPage;
}
- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView
{
    [self swipeViewDidEndScrollingAnimation:swipeView];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1){
        [self deleteCurrentCity];
    }
}

#pragma mark - Custom Accessors
- (UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
        
        _pageControl = [UIPageControl new];
        _pageControl.currentPage = 0;
        NSArray *cities = [[WeatherUtil sharedUtil]citiesManualAdded];
        _pageControl.numberOfPages = [cities count]+1;
        _pageControl.hidesForSinglePage = YES;
        [_pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
        [_bottomView addSubview:_pageControl];
        
        _optionBtn = [UIButton new];
        [_optionBtn setImage:[UIImage imageNamed:@"天气_功能"] forState:UIControlStateNormal];
        _optionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_optionBtn addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_optionBtn];
        
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(_bottomView);
            make.width.equalTo(@180);
            make.height.equalTo(@30.f);
        }];
        [_optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_bottomView).offset(-20);
            make.centerY.equalTo(_bottomView);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
    }
    return _bottomView;
}
//- (UIScrollView *)scrollView
//{
//    if(!_scrollView){
//        _scrollView = [UIScrollView new];
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.pagingEnabled = YES;
//        _scrollView.delegate = self;
//        NSArray *cities = [[WeatherUtil sharedUtil]citiesManualAdded];
//        NSMutableArray *views = [NSMutableArray arrayWithCapacity:[cities count]+1];
//        
//        //定位的城市+手动添加城市的所以多一个view
//        for(int i=0; i<[cities count]+1; i++){
//            WeatherPageView *pageView = [[WeatherPageView alloc]initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight-kBottomViewHeight)];
//            [pageView setCity:self.cityNames[i] weekStrs:self.weekStrs dateStrs:self.dateStrs];
//            [self.scrollView addSubview:pageView];
//            [views addObject:pageView];
//            [self.weatherPageViews setObject:pageView forKey:@(i)];
//        }
//        
//        _scrollView.contentSize = CGSizeMake(kScreenWidth * ([cities count]+1), kScreenHeight-kBottomViewHeight);
//    }
//    return _scrollView;
//}
- (NSArray *)weekStrs
{
    if(!_weekStrs){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
        NSArray *array;
        switch ([components weekday]) {
            case 1:
                array = @[@"今天",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
                break;
            case 2:
                array = @[@"今天",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
                break;
            case 3:
                array = @[@"今天",@"周三",@"周四",@"周五",@"周六",@"周日",@"周一"];
                break;
            case 4:
                array = @[@"今天",@"周四",@"周五",@"周六",@"周日",@"周一",@"周二"];
                break;
            case 5:
                array = @[@"今天",@"周五",@"周六",@"周日",@"周一",@"周二",@"周三"];
                break;
            case 6:
                array = @[@"今天",@"周六",@"周日",@"周一",@"周二",@"周三",@"周四"];
                break;
            case 7:
                array = @[@"今天",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五"];
                break;
            default:
                break;
        }
        _weekStrs = array;
    }
    return _weekStrs;
}
- (NSArray *)dateStrs
{
    if(!_dateStrs){
        NSDate *today = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"MM/dd";
        NSString *d1 = [formatter stringFromDate:today];
        NSString *d2 = [formatter stringFromDate:[today dateByAddingTimeInterval:86400]];
        NSString *d3 = [formatter stringFromDate:[today dateByAddingTimeInterval:86400 * 2]];
        NSString *d4 = [formatter stringFromDate:[today dateByAddingTimeInterval:86400 * 3]];
        NSString *d5 = [formatter stringFromDate:[today dateByAddingTimeInterval:86400 * 4]];
        NSString *d6 = [formatter stringFromDate:[today dateByAddingTimeInterval:86400 * 5]];
        _dateStrs = @[d1,d2,d3,d4,d5,d6];
    }
    return _dateStrs;
}
- (NSMutableDictionary *)weatherModelDict
{
    if(!_weatherModelDict){
        _weatherModelDict = [NSMutableDictionary dictionary];
    }
    return _weatherModelDict;
}
- (DXPopover *)popover
{
    if(!_popover){
        _popover = [DXPopover new];
        _popover.contentInset = UIEdgeInsetsZero;
        _popover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    return _popover;
}
- (WeatherMenuView *)menuView
{
    if(!_menuView){
        CGFloat height = [self.menus count]*kMenuRowHeight;
        _menuView = [[WeatherMenuView alloc]initWithFrame:CGRectMake(0, 0,80, height)];
        _menuView.rowHeight = kMenuRowHeight;
        _menuView.menuNames = self.menus;
        _menuView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) ws = self;
        _menuView.selectRowBlock = ^(NSInteger selectedRow){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(){
                
                switch (selectedRow) {
                    case 0:{//跳转添加
                        [ws pushToAddNewCityVC];
                    }
                        break;
                    case 1:{//删除
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除城市" message:@"是否确认删除当前城市？" delegate:ws cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                            [alertView show];
                        });
                    }
                        break;
                    default:
                        break;
                }
                
                [ws.popover dismiss];
            });
        };
    }
    return _menuView;
}
- (NSArray *)menus
{
    if(self.swipeView.currentPage>0){
        return @[@"添加",@"删除"];
    }else{
        return @[@"添加"];
    }
}
- (SwipeView *)swipeView
{
    if(!_swipeView){
        _swipeView = [[SwipeView alloc]init];
        _swipeView.dataSource = self;
        _swipeView.delegate = self;
        _swipeView.pagingEnabled = YES;
    }
    return _swipeView;
}
- (UIImageView *)backgroundView
{
    if(!_backgroundView){
        _backgroundView = [UIImageView new];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imageName = @"天气_背景";
        if(IS_IPHONE_4_SCREEN){
            imageName = [imageName stringByAppendingString:@"_4"];
        }else if(IS_IPHONE_5_SCREEN){
            imageName = [imageName stringByAppendingString:@"_5"];
        }else if(IS_IPHONE_6_SCREEN){
            imageName = [imageName stringByAppendingString:@"_6"];
        }else if(IS_IPHONE_6P_SCREEN){
            imageName = [imageName stringByAppendingString:@"_6p"];
        }
        _backgroundView.image = [UIImage imageNamed:imageName];
    }
    return _backgroundView;
}
@end
