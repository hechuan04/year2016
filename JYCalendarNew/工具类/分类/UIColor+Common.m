//
//  UIColor+Common.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/6.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "UIColor+Common.h"

@implementation UIColor (Common)

+ (UIColor *)colorWithRGBHex:(UInt32)hex
{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBIntRed:(int)red green:(int)green blue:(int)blue
{
    return [self colorWithRGBIntRed:red green:green blue:blue alpha:1.f];
}

+ (UIColor *)colorWithRGBIntRed:(int)red green:(int)green blue:(int)blue alpha:(CGFloat)alpha
{
    if(red>255||green>255||blue>255){
        NSAssert(NO,@"传参错误");
    }
    return [UIColor colorWithRed:red/255.f
                           green:green/255.f
                            blue:blue/255.f
                           alpha:alpha];
}

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:random()/(CGFloat)RAND_MAX
                           green:random()/(CGFloat)RAND_MAX
                            blue:random()/(CGFloat)RAND_MAX
                           alpha:1.0f];
}
+ (UIColor *) randomDarkColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.8; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.2; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
+ (UIColor *) randomLightColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.3; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.7; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (UIImage*)image
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //CGContextRelease(context);

    return theImage;
}
@end
