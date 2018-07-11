//
//  JYEmptyDatasourceAndDelegate.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/29.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYEmptyDatasourceAndDelegate.h"

@implementation JYEmptyDatasourceAndDelegate

- (instancetype)initWithControllerType:(ControllerType)type{
    self = [super init];
    if(self){
        _controllerType = type;
    }
    return self;
}
#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    return nil;
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    UIImage *image;
    
    switch (self.controllerType){
            
        case ControllerTypePhotoVC:
            image = [UIImage imageNamed:@"空视图_无相片"];
            break;
        case ControllerTypeCollectionVC:
            image = [UIImage imageNamed:@"空视图_无收藏"];
            break;
        case ControllerTypeAlarmVC:
            image = [UIImage imageNamed:@"空视图_无闹钟"];
            break;
        case ControllerTypeGroupListVC:
            image = [UIImage imageNamed:@"空视图_无群组"];
            break;
        case ControllerTypeRemindListVC:
            image = [UIImage imageNamed:@"空视图_无提醒"];
            break;
    }
    
    return image;
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -50.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return NO;
}

- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return NO;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    NSLog(@"---------didTapView");
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    NSLog(@"---------didTapView");
    
}

@end
