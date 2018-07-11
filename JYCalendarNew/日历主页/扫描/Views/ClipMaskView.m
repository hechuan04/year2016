//
//  ClipMaskView.m
//  ScanDemo
//
//  Created by Gaolichao on 16/6/3.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ClipMaskView.h"

#define kAnchorPointViewWidth 26.f
@interface ClipMaskView()
@property (nonatomic,assign) CGPoint touchBeginPoint;
@property (nonatomic,assign) CGPoint leftTopInitPoint;
@property (nonatomic,assign) CGPoint rightBottomInitPoint;
@end

@implementation ClipMaskView

#pragma mark - Life Cycle
- (instancetype)initWithContainerView:(UIView *)view
{
    if(!view) return nil;
    
    if(self = [super initWithFrame:view.bounds]){
        self.backgroundColor = [UIColor clearColor];
        _containerView = view;
        [self setupSubViews];
        
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
        [self addGestureRecognizer:tapGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panEvent:)];
        [self addGestureRecognizer:panGesture];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    
    CGContextMoveToPoint(context, CGRectGetMidX(self.leftTopPointView.frame), CGRectGetMidY(self.leftTopPointView.frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(self.rightTopPointView.frame), CGRectGetMidY(self.rightTopPointView.frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(self.rightBottomPointView.frame), CGRectGetMidY(self.rightBottomPointView.frame));
    CGContextAddLineToPoint(context, CGRectGetMidX(self.leftBottomPointView.frame), CGRectGetMidY(self.leftBottomPointView.frame));
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
}


#pragma mark - Public
- (void)show
{
    [self.containerView addSubview:self];
    [self resetFrame];
}

- (void)hide
{
    [self removeFromSuperview];
}
- (void)clip
{
    if([self.delegate respondsToSelector:@selector(clipMaskView:clippedWithRect:)]){
        [self.delegate clipMaskView:self clippedWithRect:self.clippedRect];
    }
}

- (void)resetFrame
{
    CGFloat width = self.containerView.bounds.size.width;
    CGFloat height = self.containerView.bounds.size.height;
    CGFloat horMargin = 30.f;
    CGFloat verMargin = 100.f;
    CGFloat pointWidth = kAnchorPointViewWidth;
    
    CGRect leftTopInitRect = CGRectMake(horMargin, verMargin, pointWidth, pointWidth);
    CGRect rightTopInitRect = CGRectMake(width-horMargin-pointWidth, verMargin, pointWidth, pointWidth);
    CGRect leftBottomInitRect = CGRectMake(horMargin, height-verMargin, pointWidth, pointWidth);
    CGRect rightBottomInitRect = CGRectMake(width-horMargin-pointWidth, height-verMargin, pointWidth, pointWidth);
    
    _leftTopPointView.frame = leftTopInitRect;
    _rightTopPointView.frame = rightTopInitRect;
    _leftBottomPointView.frame = leftBottomInitRect;
    _rightBottomPointView.frame = rightBottomInitRect;
    
    if(self.superview){
        [self setNeedsDisplay];
    }
}
#pragma mark - Private

- (void)setupSubViews
{
    _leftTopPointView = [self generateANewAnchorPointView];
    _rightTopPointView = [self generateANewAnchorPointView];
    _leftBottomPointView = [self generateANewAnchorPointView];
    _rightBottomPointView = [self generateANewAnchorPointView];
    
}
- (UIView *)generateANewAnchorPointView
{
    UIView *pointView = [[UIView alloc]init];
//    pointView.backgroundColor = [UIColor colorWithRGBHex:0x8BC9F9];
    pointView.backgroundColor = [UIColor orangeColor];
    pointView.layer.cornerRadius = kAnchorPointViewWidth/2.f;
    pointView.layer.masksToBounds = YES;
    [self addSubview:pointView];
    
    pointView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    [pointView addGestureRecognizer:gesture];
    
    return pointView;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender
{
    UIView *view = sender.view;
    CGPoint touchPoint = [sender locationInView:self];
    
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:{
            [self adjustArchorCentersWithReferenceView:view changePoint:touchPoint];
            [self setNeedsDisplay];
        }
            break;
        default:
            break;
    }
    
}

- (void)adjustArchorCentersWithReferenceView:(UIView *)view changePoint:(CGPoint)point
{
    
    if(point.x < 0 || point.x > self.containerView.bounds.size.width ||
       point.y < 0 || point.y > self.containerView.bounds.size.height){
        
        return;
    }
    
    view.center = point;
    
    if(view==self.leftTopPointView){
        
        CGPoint p = self.leftBottomPointView.center;
        p.x = point.x;
        self.leftBottomPointView.center = p;
        p = self.rightTopPointView.center;
        p.y = point.y;
        self.rightTopPointView.center = p;
        
    }else if(view==self.rightTopPointView){
        
        CGPoint p = self.rightBottomPointView.center;
        p.x = point.x;
        self.rightBottomPointView.center = p;
        p = self.leftTopPointView.center;
        p.y = point.y;
        self.leftTopPointView.center = p;
        
    }else if(view==self.rightBottomPointView){
        
        CGPoint p = self.rightTopPointView.center;
        p.x = point.x;
        self.rightTopPointView.center = p;
        p = self.leftBottomPointView.center;
        p.y = point.y;
        self.leftBottomPointView.center = p;
        
    }else if(view==self.leftBottomPointView){
        
        CGPoint p = self.leftTopPointView.center;
        p.x = point.x;
        self.leftTopPointView.center = p;
        p = self.rightBottomPointView.center;
        p.y = point.y;
        self.rightBottomPointView.center = p;
        
    }
}

//点击将被截取的矩形区域
- (void)tapSelf:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self];
    
    if([self detectionTouchPointInDestinatedRect:touchPoint]){
        [self clip];
    }
}

- (BOOL)detectionTouchPointInDestinatedRect:(CGPoint)point
{
    if(CGRectContainsPoint(self.clippedRect, point)){
        return YES;
    }
    
    return NO;
}
- (CGRect)clippedRect
{
    CGFloat x = self.leftTopPointView.center.x;
    CGFloat y = self.leftTopPointView.center.y;
    CGFloat w = self.rightTopPointView.center.x - x;
    CGFloat h = self.rightBottomPointView.center.y - y;
    return CGRectMake(x, y, w, h);
}

//拖动整体平移
- (void)panEvent:(UIGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self];
    
  
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            if([self detectionTouchPointInDestinatedRect:touchPoint]){
                self.touchBeginPoint = touchPoint;
                self.leftTopInitPoint = self.leftTopPointView.center;
                self.rightBottomInitPoint = self.rightBottomPointView.center;
            }else{
                self.touchBeginPoint = CGPointZero;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:{
            [self adjustClipViewCenterTochangePoint:touchPoint];
            [self setNeedsDisplay];
        }
            break;
        default:
            break;
    }
}

- (void)adjustClipViewCenterTochangePoint:(CGPoint)point
{
    //self.touchBeginPoint == CGPointZero
    if(self.touchBeginPoint.x==0&&self.touchBeginPoint.y==0){
        return;
    }
    CGFloat xOffset = point.x - self.touchBeginPoint.x;
    CGFloat yOffset = point.y - self.touchBeginPoint.y;
    CGRect clickFrame = [self clippedRect];
    
    CGFloat leftTopX = MAX(MIN(self.leftTopInitPoint.x+xOffset,self.containerView.bounds.size.width-clickFrame.size.width),0);
    CGFloat leftTopY = MAX(MIN(self.leftTopInitPoint.y+yOffset,self.containerView.bounds.size.height-clickFrame.size.height),0);
    CGFloat rightBottomX = MIN(MAX(self.rightBottomInitPoint.x+xOffset,clickFrame.size.width),self.containerView.bounds.size.width);
    CGFloat rightBottomY = MIN(MAX(self.rightBottomInitPoint.y+yOffset,clickFrame.size.height),self.containerView.bounds.size.height);
    
    CGPoint leftTopChangedPoint = CGPointMake(leftTopX, leftTopY);
    CGPoint rightBottomChangedPoint = CGPointMake(rightBottomX, rightBottomY);
    
//    if(leftTopChangedPoint.x < 0 || rightBottomChangedPoint.x > self.containerView.bounds.size.width ||
//       leftTopChangedPoint.y < 0 || rightBottomChangedPoint.y > self.containerView.bounds.size.height){
//        
//        return;
//    }

    [self adjustArchorCentersWithReferenceView:self.leftTopPointView changePoint:leftTopChangedPoint];
    [self adjustArchorCentersWithReferenceView:self.rightBottomPointView changePoint:rightBottomChangedPoint];
}
@end
