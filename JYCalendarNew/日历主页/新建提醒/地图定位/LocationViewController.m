//
//  LocalViewController.m
//  JYCalendarNew
//
//  Created by 张静 on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "LocationViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface LocationViewController ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    bool isGeoSearch;
    BMKGeoCodeSearch* _geocodesearch;
    BMKLocationService* _locService;
    NSMutableArray *_resultArray;
    UITableView * _resultTableView;
    
}

@end

@implementation LocationViewController


- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    _locService.delegate = nil;
    _geocodesearch.delegate = nil; // 不用时，置nil
    
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    if ([error code] == kCLErrorDenied) {
        
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开系统设置中\"隐私->定位服务\",允许\"小秘\"使用您的位置" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
    }else{
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(actionForLeft:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"取消" forState:UIControlStateNormal];
    [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    
    
    // 存放城市的数组
    _resultArray = [[NSMutableArray alloc]initWithCapacity:5];
    [_resultArray addObject:@"北京市"];
    
    //初始化BMKLocationService  
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    // 反编码地理位置
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    
    // 结果列表
    _resultTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    [self.view addSubview:_resultTableView];
    
}

- (void)actionForLeft:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"result";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:identifier];
    }
    cell.textLabel.text = _resultArray[indexPath.row];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSString * locationString = _resultArray[indexPath.row];
    _actionForGetLocationString(locationString);
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //    [_mapView updateLocationData:userLocation];
    //    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //    [_mapView updateLocationData:userLocation];
    
    isGeoSearch = false;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
        [_locService stopUserLocationService];
        
    }else{
        
        NSLog(@"反geo检索发送失败");
    }
    
    
    
}

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    
    
    NSLog(@"error:%u",error);
    
    if (error == 0) {
        
        [_resultArray removeAllObjects];
        for(BMKPoiInfo *poiInfo in result.poiList)
        {
            //            NSLog(@"%@",poiInfo.address);
            [_resultArray addObject:poiInfo.address];
        }
        
        NSLog(@"附近结果:%@",_resultArray);
        [_resultTableView reloadData];
        
    }else{
        
        [_resultArray addObject:@"北京市"];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"检索无数据" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
        
        NSLog(@"检索无数据");
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
