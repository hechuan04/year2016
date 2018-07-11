//
//  Logs.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#ifndef JYCalendar_Logs_h
#define JYCalendar_Logs_h

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif

/*****************
 *
 * 调试期间Log的统一管理
 *
 *****************/

//配置2
#define kAppDebug 1

#if kAppDebug
#define JYLog(fmt, ...)                             NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define JYLog(...) 

#endif



#define kChangeDisTimeForNotification @"kChangeDisTimeForNotification"
#define kisDistrubation @"isDistrubation"
#define kSystemVersion [[UIDevice currentDevice].systemVersion floatValue]

#endif
