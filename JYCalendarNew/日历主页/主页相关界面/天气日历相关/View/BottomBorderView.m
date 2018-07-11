//
//  BottomBorderView.m
//  JYCalendarNew
//
//  Created by Leo Gao on 16/4/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BottomBorderView.h"

@implementation BottomBorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat lineWidth = 1.f;
    CGFloat radius = 10.f;
    CGFloat width = rect.size.width;
    CGFloat hegith = rect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context,[JYSkinManager shareSkinManager].colorForDateBg.CGColor);
    CGContextSetLineWidth(context,lineWidth);
    CGContextSetLineJoin(context,kCGLineJoinRound);
    
    CGContextMoveToPoint(context,radius,hegith-lineWidth/2);
    CGContextAddLineToPoint(context,width-radius,hegith-lineWidth/2);
    CGContextStrokePath(context);
    
    //左1/4弧
    CGContextAddArc(context,-0.5,hegith, radius, 0, M_PI_2, 1);
    CGContextDrawPath(context,kCGPathStroke);
    //右1/4弧
    CGContextAddArc(context,width+0.5,hegith,radius,M_PI_2, M_PI, 1);
    CGContextDrawPath(context,kCGPathStroke);
}
@end
