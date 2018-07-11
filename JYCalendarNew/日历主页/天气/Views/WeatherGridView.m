//
//  WeatherGridView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherGridView.h"

#define kPartitionCount 5

@interface WeatherGridView()

@property (nonatomic,assign) CGFloat topLineY;
@property (nonatomic,assign) CGFloat bottomLineY;

@end

@implementation WeatherGridView


- (void)drawRect:(CGRect)rect {
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    CGFloat partitionWidth =  ceilf(width / kPartitionCount);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:1 alpha:0.4].CGColor);
    CGContextSetLineWidth(context, 0.5);

    //竖线
    for(int i=0; i<kPartitionCount-1; i++){
        CGFloat startX = partitionWidth*(i+1);
        CGFloat startY = 0;
        CGFloat endY = height;
        CGContextMoveToPoint(context, startX, startY);
        CGContextAddLineToPoint(context, startX, endY);
    }
    
    //水平两条线
    CGContextMoveToPoint(context, 0, self.topLineY);
    CGContextAddLineToPoint(context, width, self.topLineY);

    CGContextMoveToPoint(context, 0, self.bottomLineY);
    CGContextAddLineToPoint(context, width, self.bottomLineY);
    
    CGContextStrokePath(context);
}

#pragma mark - Public
- (void)setTopLineCoordY:(CGFloat)topY BottomLineCoordY:(CGFloat)bottomY
{
    _topLineY = topY;
    _bottomLineY = bottomY;
    [self setNeedsDisplay];
}

@end
