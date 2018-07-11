
//
//  JYColor.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/21.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#ifndef JYCalendar_JYColor_h
#define JYCalendar_JYColor_h

#define selectAndSundayColor [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1]
#define selectAndSundayColorNotThisMonth [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:0.1]

#define lineColor [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1]


#define grayTextColor [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1]
#define nameTextColor  [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1]

#define bgColor [UIColor colorWithRed: 240 / 255.0 green:240 / 255.0 blue: 240 / 255.0 alpha:1];

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//rgb
#define RGB_COLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//选中日期颜色
//红色
//#define bgRedColor [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1]
#define bgRedColor [UIColor colorWithRed:208 / 255.0 green:63 / 255.0 blue:63 / 255.0 alpha:1]

//绿色
#define bgGreenColor [UIColor colorWithRed: 9 / 255.0 green: 187 / 255.0 blue: 7 / 255.0 alpha:1]

//玫瑰粉
#define bgPinkColor [UIColor colorWithRed: 255 / 255.0 green: 96 / 255.0 blue: 143 / 255.0 alpha:1]
//蓝色
#define bgBlueColor [UIColor colorWithRed: 18 / 255.0 green: 183 / 255.0 blue: 245 / 255.0 alpha:1]

//橙色
#define bgOrangeColor [UIColor colorWithRed: 232 / 255.0 green: 57 / 255.0 blue: 23 / 255.0 alpha:1]

//随机色
#define RANDOM_COLOR [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]
#endif
