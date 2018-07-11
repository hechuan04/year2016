//
//  WeekWeatherView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekWeatherView : UIView

@property (nonatomic,strong) UILabel *weekLabel;
@property (nonatomic,strong) UILabel *dateLabel;
@property (nonatomic,strong) UILabel *weatherLabel;
@property (nonatomic,strong) UIImageView *weatherImageView;

- (void)setWeather:(NSString *)weatherStr
      weatherImage:(NSString *)weatherImageName;

- (void)setWeek:(NSString *)weekStr
           date:(NSString *)dateString;
@end
