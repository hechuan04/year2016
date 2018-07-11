//
//  WeekTemperatureView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeekTemperatureView.h"

#define kOffsetY 30.f
#define kShowCount 5
#define kPointRadius 3

@interface WeekTemperatureView()

@property (nonatomic,assign) NSInteger maxTemperature;
@property (nonatomic,assign) NSInteger minTemperature;

@end

@implementation WeekTemperatureView


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.f);
    
    if(self.maxTemps){
        [self drawLineWithTempArray:self.maxTemps isHighTemp:YES context:context];
    }
    if(self.minTemps){
        [self drawLineWithTempArray:self.minTemps isHighTemp:NO context:context];
    }
    
    //未加载数据
    if(!self.maxTemps&&!self.minTemps){
        self.maxTemperature = 10;
        self.minTemperature = -10;
        [self drawLineWithTempArray:@[@0,@0,@0,@0,@0,@0] isHighTemp:NO context:context];
    }
}

#pragma mark - private
- (NSInteger)realYCoordFromTemperature:(NSInteger)temp
{
    return (self.maxTemperature-temp) * (self.bounds.size.height-kOffsetY*2)/(self.maxTemperature-self.minTemperature) + kOffsetY;
}
- (void)drawLineWithTempArray:(NSArray *)temps isHighTemp:(BOOL)isHigh context:(CGContextRef)context
{
    CGFloat partitionWidth =  ceilf(self.bounds.size.width / kShowCount);
    
    if(temps){
        CGPoint aPoints[[temps count]];//坐标点
        for(int i=0; i<[temps count]; i++){
            NSInteger y = [self realYCoordFromTemperature:[temps[i] integerValue]];
            NSInteger x = i*partitionWidth+partitionWidth/2;
            CGContextAddArc(context, x, y, kPointRadius, 0, 2*M_PI, 0);
            CGContextDrawPath(context, kCGPathFill);
            aPoints[i] = CGPointMake(x, y);
            
            CGPoint textPosition;
            if(isHigh){//高温线,温度字符在线之上
                textPosition = CGPointMake(x-8, y-20);
            }else{
                textPosition = CGPointMake(x-8, y+5);
            }
            NSString *temp = [NSString stringWithFormat:@"%ld°",[temps[i] integerValue]];
            [temp drawAtPoint:textPosition withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        }
        CGContextAddLines(context, aPoints, [temps count]);
        CGContextDrawPath(context, kCGPathStroke);
    }
}
- (void)calculateMaxTemperature
{
    self.maxTemperature = -1000;
    for(NSNumber *num in self.maxTemps){
        self.maxTemperature = MAX(num.integerValue, self.maxTemperature);
    }
}
- (void)calculateMinTemperature
{
    self.minTemperature = 1000;
    for(NSNumber *num in self.minTemps){
        self.minTemperature = MIN(num.integerValue, self.minTemperature);
    }
}
#pragma mark - Public
- (void)setMaxTemperatures:(NSArray *)maxTemps minTemperatures:(NSArray *)minTemps
{
    _maxTemps = maxTemps;
    _minTemps = minTemps;
    [self calculateMaxTemperature];
    [self calculateMinTemperature];
    [self setNeedsDisplay];
}

- (void)setMaxTemps:(NSArray *)maxTemps
{
    _maxTemps = maxTemps;
    [self calculateMaxTemperature];
    [self setNeedsDisplay];
}
- (void)setMinTemps:(NSArray *)minTemps
{
    _minTemps = minTemps;
    [self calculateMinTemperature];
    [self setNeedsDisplay];
}
#pragma mark - Custom Accessors

@end
