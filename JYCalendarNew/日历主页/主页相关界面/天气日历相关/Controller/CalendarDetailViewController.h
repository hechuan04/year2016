//
//  CalendarDetailViewController.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/31.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYWeatherModel.h"
#import "JYCalendarModel.h"
#import "WeatherViewModel.h"

@interface CalendarDetailViewController : UIViewController

@property (nonatomic,strong) JYCalendarModel *calendarModel;
@property (nonatomic,strong) WeatherViewModel *weatherModel;

@end
