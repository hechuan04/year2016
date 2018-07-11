//
//  WidthOrHeight.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#ifndef JYCalendar_WidthOrHeight_h
#define JYCalendar_WidthOrHeight_h

//屏宽
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kNavbarHeight self.navigationController.navigationBar.bounds.size.height
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//星期表格高度
#define kHeightForWeek 44 / 1334.0 * kScreenHeight

//日历表格高度
#define kHeightForCalendar kScreenWidth / 7.0

//天气视图高度
#define kHeightForWeather 206 / 1334.0 * kScreenHeight
#define kHeightForWeatherBig 246 / 1334.0 * kScreenHeight

//宜忌视图高度
#define kHeightForWringAndWrong 191 / 1334.0 * kScreenHeight

//与日历间隔
#define kPageForCalendar 0


//适配
#define CGFrameMake(x,y,width,height) CGRectMake(kScreenWidth*((float)(x)/750), kScreenHeight*((float)(y)/1334), kScreenWidth*((float)(width)/750), kScreenHeight*((float)(height)/1334))

#define Alert(_message_,...) [[[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:(_message_)] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show]

#define kIphone6_Height 1334.0
#define kIphone6_Width 750.0

#endif
