//
//  UIImage+Common.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
CGFloat DegreesToRadians(CGFloat degrees);
@interface UIImage (Common)

- (UIImage *)fixOrientation;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
-(UIImage*)getSubImage:(CGRect)rect;
- (NSData *)imageDataBelow:(CGFloat)size;

+ (UIImage *)imageFromString:(NSString *)string attributes:(NSDictionary *)attributes size:(CGSize)size;
+ (UIImage *)imageForView:(UIView *)view;
+ (UIImage *)compressImage:(UIImage *)imgSrc toSize:(CGSize)size;
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r;
+ (UIImage *)imageFromColor:(UIColor *)color;
@end
