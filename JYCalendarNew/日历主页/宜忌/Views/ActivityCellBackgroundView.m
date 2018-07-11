//
//  ActivityCellBackgroundView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ActivityCellBackgroundView.h"

@implementation ActivityCellBackgroundView

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor
{
    self = [super initWithFrame:frame];
    if(self){
        _fillColor = fillColor;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // draw a rounded rect bezier path filled with blue
    CGContextRef aRef = UIGraphicsGetCurrentContext();
    CGContextSaveGState(aRef);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0f];
    bezierPath.lineWidth = 1.0f;
    
//    [[UIColor whiteColor] setStroke];
    
    if(!self.fillColor){
        self.fillColor = [UIColor clearColor];
    }
    [self.fillColor setFill];

    [bezierPath fill];
//    [bezierPath stroke];
    CGContextRestoreGState(aRef);
}

@end
