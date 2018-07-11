//
//  WeekTemperatureView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekTemperatureView : UIView

@property (nonatomic,strong) NSArray *maxTemps;
@property (nonatomic,strong) NSArray *minTemps;

- (void)setMaxTemperatures:(NSArray *)maxTemps minTemperatures:(NSArray *)minTemps;
@end
