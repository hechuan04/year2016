//
//  MapViewController.m
//  JYCalendarNew
//
//  Created by 张静 on 16/8/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.

//  当前页面 创建提醒时发送位置 与 已发送or收到的提醒位置 显示共用该类

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import "SearchMapViewController.h"

#define kMapViewHeight 260.f

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BMKMapView *mapView;
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic,strong) BMKGeoCodeSearchOption *geocodeSearchOption;
@property (nonatomic,strong) BMKReverseGeoCodeOption *reverseGeocodeSearchOption;

@property (nonatomic) CLLocationCoordinate2D userLocation; // 接收地理坐标
@property (nonatomic) CLLocationCoordinate2D pinLocation; // 接收地理坐标
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *poiResult;//of BMKPoiInfo
@property (nonatomic,strong) UIImageView *pinView;
@property (nonatomic,assign) BOOL hasUpdateUserLocation;
@property (nonatomic,strong) UIButton *locationBtn;

@property (nonatomic,strong) UIView *whiteBgView;
@property (nonatomic,strong) UIButton *searchBtn;
@property (nonatomic,assign) BOOL isFirstPush; // 主要针对从地址条进入时，当前地址要显示地址条地址

@end

@implementation MapViewController

@synthesize whiteBgView;
@synthesize searchBtn;

-(void)dealloc
{
    NSLog(@"dealloc");
    if (_mapView) {
        _mapView = nil;
    }
    if (_geoCodeSearch != nil) {
        _geoCodeSearch = nil;
    }
    if (_locationManager) {
        _locationManager = nil;
    }
    
}

//-(void)viewWillAppear:(BOOL)animated {
//    [_mapView viewWillAppear];
//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _locService.delegate = self;
//    _locationManager.delegate = self;
//    _geoCodeSearch.delegate = self;
//
//}
//-(void)viewWillDisappear:(BOOL)animated {
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//    _locService.delegate = nil;
//    _locationManager.delegate = nil;
//    _geoCodeSearch.delegate = nil;
//}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
 
    
    /**
     *  最先进行 国内国外定位的判断
     *  页面来源是定位按钮 
     */
    if (_pageType == PageSourceLocBtn) {
        
        [self locateCity];
    }
    
    
    
    self.isFirstPush = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 创建地图view 和 附近列表table
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.tableView];
    
    [self.mapView addSubview:self.pinView];
    self.pinView.center = CGPointMake(self.mapView.frame.size.width/2.f,self.mapView.frame.size.height/2.f-10.f);
    NSLog(@"%@",[NSValue valueWithCGPoint:self.pinView.center]);
    NSLog(@"%@",[NSValue valueWithCGRect:self.mapView.frame]);
    [self.mapView addSubview:self.locationBtn];
    self.locationBtn.frame = CGRectMake(self.mapView.frame.size.width-50, self.mapView.frame.size.height-50, 32,32);
    
    // 搜索条
    whiteBgView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, kScreenWidth-20, 45)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    whiteBgView.layer.masksToBounds = YES;
    whiteBgView.layer.cornerRadius = 5.0;
    [self.view addSubview:whiteBgView];
    
    // 返回按钮
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backButton.frame = CGRectMake(0, 0, 45, 45);
    [backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    backButton.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"map_back"] forState:(UIControlStateNormal)];
    [whiteBgView addSubview:backButton];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(backButton.right + 1, 10, 0.5, 25)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [whiteBgView addSubview:lineLabel];
    
    searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    searchBtn.frame = CGRectMake(lineLabel.right + 13, 10, whiteBgView.width - 110, 25);
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;  
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0); 
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [searchBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
    [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
    searchBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    searchBtn.backgroundColor = [UIColor whiteColor];
    [searchBtn setTitle:@"搜地点" forState:(UIControlStateNormal)];
    [whiteBgView addSubview:searchBtn];
    
    
    [self startLocation];
    
    /**
     *  页面来源是地址条   当前大头针指到地址
     */
    if (_pageType == PageSourceLocLabel) {
        _pinLocation.latitude = [self.latitudeStr doubleValue];
        _pinLocation.longitude = [self.longitudeStr doubleValue];
        [self.mapView setCenterCoordinate:_pinLocation];
    }
    /**
     *  页面来源是 收到提醒 隐藏搜索按钮，创建返回按钮
     */
    if (_pageType == PageSourceReceivedRemind) {
        self.whiteBgView.hidden = YES;
        self.tableView.allowsSelection = NO; 
        _pinLocation.latitude = [self.latitudeStr doubleValue];
        _pinLocation.longitude = [self.longitudeStr doubleValue];
        [self.mapView setCenterCoordinate:_pinLocation];
        
        UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        backButton.frame = CGRectMake(15, 25, 30, 30);
        [backButton addTarget:self action:@selector(backBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        backButton.contentMode = UIViewContentModeScaleAspectFit;
        [backButton setImage:[UIImage imageNamed:@"map_white_back"] forState:(UIControlStateNormal)];
        backButton.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55];
        backButton.layer.masksToBounds = YES;
        backButton.layer.cornerRadius = 5.0;
        backButton.tintColor = [UIColor whiteColor];
        [self.view addSubview:backButton];

    }
    
}

// 搜索按钮事件
- (void)searchBtnAction:(UIButton *)sender
{
    SearchMapViewController *searchVC = [[SearchMapViewController alloc]init];
    searchVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    searchVC.keywordString = self.searchBtn.titleLabel.text;
    [self presentViewController:searchVC animated:NO completion:nil];
    
    // 传回用户选择的位置，显示到地图中间
    __weak MapViewController *weakSelf = self;
    [searchVC setActionForSelectedLoc:^(BMKPoiInfo * info) {
        
        if (info) {
            [weakSelf.mapView setCenterCoordinate:info.pt];
            [weakSelf.searchBtn setTitle:info.name forState:(UIControlStateNormal)];
            [searchBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            
        }
    }];
    
}
-(void)backBtnAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Private Method
-(void)startLocation
{
    NSLog(@"进入普通定位态");
    [self.locService startUserLocationService];
    
}

/** 逆地理编码 */
- (void)reverseLocation:(CLLocationCoordinate2D)location {
    // 定位成功后的 经纬度 -> 逆地理编码 -> 文字地址
    self.reverseGeocodeSearchOption.reverseGeoPoint = location;
    [self.geoCodeSearch reverseGeoCode:self.reverseGeocodeSearchOption];
    
}
//- (void)locationBtnClicked:(UIButton *)sender
//{
//    [self.mapView setCenterCoordinate:self.userLocation];
//    self.mapView.zoomLevel = 18;
//}

#pragma mark - Protocol

#pragma mark BMKMapView

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    NSLog(@"center:%f--%f",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    CGPoint pinPoint = CGPointMake(self.pinView.center.x, self.pinView.center.y+10);
    self.pinLocation = [mapView convertPoint:pinPoint toCoordinateFromView:self.mapView];
    //    self.pinLocation = self.mapView.centerCoordinate;
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"====didUpdateBMKUserLocation:%@",userLocation.title);
    [self.mapView updateLocationData:userLocation];
    
    if (_pageType == PageSourceLocBtn) {
        [self.mapView setCenterCoordinate:userLocation.location.coordinate];
    }
    self.userLocation = userLocation.location.coordinate;
    
    // 经纬度反编码
    self.pinLocation = self.mapView.centerCoordinate;
    
    [self.locService stopUserLocationService];
}
#pragma mark BMKGeoCodeSearchDelegate
//周边地址信息搜索结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    // 搜索结果正常返回
    if (error == 0) {
        
        // 手势移动地图 先清除之前的附近地址
        [self.poiResult removeAllObjects];
        [self.poiResult addObjectsFromArray:result.poiList];
        
        /* 
         1.判断从地址条进入页面要显示之前选中的位置
         2.不是当前位置 
         3.移动地图时当前地址还是要变换
         */
        if (_pageType == PageSourceLocLabel || _pageType == PageSourceReceivedRemind) {
            
            // 第一次进入，需要显示传入的address
            if (!_isFirstPush) {
                self.address = result.address;
            }else{
                _isFirstPush = NO;
                NSInteger sameLocIndex = 0;
                for (int i = 0; i < self.poiResult.count; i ++) {
                    BMKPoiInfo *info = self.poiResult[i];
                    if ([info.name isEqualToString:self.address]) {
                        sameLocIndex = i;
                        NSLog(@"当前选中地址:%@",info.name);
                    }
                }
                if (self.poiResult.count > 0) {
                    [self.poiResult removeObjectAtIndex:sameLocIndex];
                }
                
            }
            
        }else{
            // 移动地图时，当前地址更随结果list 联动
            self.address = result.address;
        }
        [self.tableView reloadData];
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.tableView){
        switch (section) {
            case 0:
                return 2;
                break;
            case 1:
                return [self.poiResult count] + 1;
                break;
            default:
                break;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kIdentifierForCell = @"kIdentifierForCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForCell];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kIdentifierForCell];
    }
    if(tableView==self.tableView){
        if(indexPath.section==0){
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"当前地址";
                cell.textLabel.font = [UIFont systemFontOfSize:16.f];
                cell.textLabel.textColor = [UIColor lightGrayColor];
//                cell.detailTextLabel.text = @"";
                
            }else{
                cell.textLabel.text = self.address;
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.font = [UIFont systemFontOfSize:16.f];
                cell.textLabel.textColor = [UIColor blackColor];
//                cell.detailTextLabel.text = @"";
            }
            
        }else if(indexPath.section==1){
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"附近地址";
                cell.textLabel.font = [UIFont systemFontOfSize:16.f];
                cell.textLabel.textColor = [UIColor lightGrayColor];
//                cell.detailTextLabel.text = @"";
                
            }else{
                
                cell.textLabel.font = [UIFont systemFontOfSize:16.f];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.numberOfLines = 0;
                BMKPoiInfo *info = self.poiResult[indexPath.row - 1];
                cell.textLabel.text = info.name;
//                cell.detailTextLabel.text = info.address;
            }
            
            
        }
    }
    return cell;
}
// 计算label的高度                                                                                         
- (CGFloat)labelHeightWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth-10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==0){
        if (indexPath.row == 1) {
            
            if ([self.address isEqualToString:@""]) {
                return 45;
            }
            
            CGFloat nameHeight = [self labelHeightWithText:self.address font:[UIFont systemFontOfSize:16.0]];
            CGFloat totalHeight = nameHeight + 35;
            
            return totalHeight;
            
        }
        
    }else if(indexPath.section==1){
        
        if (indexPath.row > 0) {
            
            BMKPoiInfo *info = self.poiResult[indexPath.row -1];
            NSString *nameString = info.name;
            CGFloat nameHeight = [self labelHeightWithText:nameString font:[UIFont systemFontOfSize:16.0]];
            CGFloat totalHeight = nameHeight + 25;
            if (totalHeight < 45.0) {
                return 45;
            }
            return totalHeight;
            
        }
    }
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView==self.tableView){
        if(indexPath.section == 0){
            if (indexPath.row == 1) {
                _actionForGetLocationString(self.address,self.pinLocation);
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        }else{
            if (indexPath.row > 0) {
                BMKPoiInfo *info = self.poiResult[indexPath.row -1];
                _actionForGetLocationString(info.name,info.pt);
                [self dismissViewControllerAnimated:YES completion:nil];
            } 
        }
    }
    
}
#pragma mark - Custom Accessors

- (BMKMapView *)mapView {
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,kMapViewHeight)];
        _mapView.backgroundColor = [UIColor whiteColor];
        _mapView.zoomLevel = 18;
        _mapView.delegate = self;
        //先关闭显示的定位图层
        _mapView.showsUserLocation = NO;
        //        _mapView.showIndoorMapPoi = YES;
        //        _mapView.showMapPoi = YES;
        //        _mapView.showMapScaleBar = YES;
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
        
        BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
        displayParam.isRotateAngleValid = true;//跟随态旋转角度是否生效
        displayParam.isAccuracyCircleShow = false;//精度圈是否显示
        displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
        displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
        [_mapView updateLocationViewWithParam:displayParam];
    }
    return _mapView;
}
- (BMKLocationService *)locService
{
    if(!_locService){
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    return _locService;
}
- (BMKGeoCodeSearch *)geoCodeSearch
{
    if(!_geoCodeSearch){
        _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        _geoCodeSearch.delegate = self;
    }
    return _geoCodeSearch;
}
- (BMKGeoCodeSearchOption *)geocodeSearchOption
{
    if(!_geocodeSearchOption){
        _geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    }
    return _geocodeSearchOption;
}

- (BMKReverseGeoCodeOption *)reverseGeocodeSearchOption
{
    if(!_reverseGeocodeSearchOption){
        _reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    }
    return _reverseGeocodeSearchOption;
}
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kMapViewHeight,self.view.bounds.size.width,self.view.bounds.size.height-kMapViewHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView=[[UIView alloc]init];//关键语句
        
    }
    return _tableView;
}
- (NSMutableArray *)poiResult
{
    if(!_poiResult){
        _poiResult = [NSMutableArray array];
    }
    return _poiResult;
}
- (UIImageView *)pinView
{
    if(!_pinView){
        _pinView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pin_red"]];
    }
    return _pinView;
}
- (void)setPinLocation:(CLLocationCoordinate2D)pinLocation
{
    _pinLocation = pinLocation;
    [self reverseLocation:pinLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 定位
- (void)locateCity
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    if ([CLLocationManager locationServicesEnabled]) {
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            //提示用户无法进行定位操作
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
        }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }else{
            //开始定位，不断调用其代理方法
            [self.locationManager startUpdatingLocation];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位失败" message:@"请检查您的设备是否开启了定位功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if(status==kCLAuthorizationStatusDenied){
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0) {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //获取城市
             NSString *country = placemark.country;
             // 如果定位国外，地图功能暂不可用
             if (![country isEqualToString:@"中国"]) {
                 
                 UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"暂不支持使用该地区功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                 [errorAlert show];
                 
             }
             
         }
//         else if (error == nil && [array count] == 0){
//             NSLog(@"No results were returned.");
//             
//             UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"[array count] == 0" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//             [errorAlert show];
//             
//         }
//         else if (error != nil){
//             NSLog(@"An error occurred = %@", error);
//             
//             UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"error != nil" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//             [errorAlert show];
//         }
     }];
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (error) {
        NSLog(@"error:%@",error.localizedDescription);
        UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:nil message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [errorAlert show];
        
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
