//
//  DashEdgeView.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "DashEdgeView.h"

@implementation DashEdgeView

//- (instancetype)init
//{
//    if(self = [super init]){
//        [self.layer addSublayer:self.dashLayer];
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if(self = [super initWithCoder:aDecoder]){
//        [self.layer addSublayer:self.dashLayer];
//    }
//    return self;
//}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if(self = [super initWithFrame:frame]){
//        [self.layer addSublayer:self.dashLayer];
//    }
//    return self;
//}
//
//- (CAShapeLayer *)dashLayer
//{
//    if(!_dashLayer){
//        CAShapeLayer *border = [CAShapeLayer layer];
//        border.strokeColor = [UIColor lightGrayColor].CGColor;
//        border.fillColor = nil;
//        border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
//        border.frame = self.bounds;
//        border.lineWidth = 1.f;
//        border.lineCap = @"square";
//        border.lineDashPattern = @[@4];
//        _dashLayer = border;
//    }
//    return _dashLayer;
//}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.5);
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGFloat lengths[] = {5};
    CGContextSetLineDash(context, 0, lengths, 1);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextBeginPath(context);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, width, 0);
    CGContextAddLineToPoint(context, width, height);
    CGContextAddLineToPoint(context, 0, height);
    CGContextClosePath(context);
    
    CGContextStrokePath(context);
    
}
@end
