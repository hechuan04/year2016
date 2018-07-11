//
//  MapViewController.h
//  JYCalendarNew
//
//  Created by 张静 on 16/8/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.

//  当前页面 创建提醒时发送位置 与 已发送or收到的提醒位置 显示共用该类

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#define IOS [[[UIDevice currentDevice]systemVersion]floatValue]

typedef enum{
    PageSourceLocLabel = 0,  ///点击地址条 进入当前页面
    PageSourceLocBtn,        ///点击定位按钮 进入当前页面
    PageSourceReceivedRemind,///从收到的提醒进入该页面 进入当前页面
    
}PageSourceType;


@interface MapViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>

@property (nonatomic ,strong)NSString *latitudeStr;  // <! 纬度
@property (nonatomic ,strong)NSString *longitudeStr; // <! 经度
@property (nonatomic,strong) NSString *address;
@property (nonatomic, assign)PageSourceType pageType;
@property (nonatomic ,copy)void (^actionForGetLocationString)(NSString *remindLoaction,CLLocationCoordinate2D remindLoc);

@property (nonatomic,strong) CLLocationManager* locationManager;// 定位

@end
