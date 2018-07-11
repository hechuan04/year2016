//
//  TopBorderView.m
//  JYCalendarNew
//
//  Created by Leo Gao on 16/4/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "TopBorderView.h"

@implementation TopBorderView

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
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context,[JYSkinManager shareSkinManager].colorForDateBg.CGColor);
    CGContextSetLineWidth(context,lineWidth);
    CGContextSetLineJoin(context,kCGLineJoinRound);
    
    CGContextMoveToPoint(context,radius,lineWidth/2);
    CGContextAddLineToPoint(context,width-radius,lineWidth/2);
    CGContextStrokePath(context);
    
    //左1/4弧
    CGContextAddArc(context,-0.5,0, radius, 0, M_PI_2, 0);
    CGContextDrawPath(context,kCGPathStroke);
    
    //右1/4弧
    CGContextAddArc(context,width+0.5,0,radius,M_PI_2, M_PI, 0);
    CGContextDrawPath(context,kCGPathStroke);
}


@end
