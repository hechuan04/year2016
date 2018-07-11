//
//  UIColor+Common.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/6.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithRGBIntRed:(int)red green:(int)green blue:(int)blue;
+ (UIColor *)colorWithRGBIntRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alph;
+ (UIColor *)randomColor;
+ (UIColor *)randomLightColor;
+ (UIColor *)randomDarkColor;

- (UIImage*)image;
@end
