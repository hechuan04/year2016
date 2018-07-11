//
//  JYMainViewController+ScrollView.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYMainViewController.h"
#import "JYMainViewController+Gesture.h"

@interface JYMainViewController (ScrollView)

#pragma mark 创建日历三个滑动视图
- (void)createCalendarScrollView;


#pragma mark 日子点击回调block
- (void)actionForCalendarBlock;

#pragma mark 创建UpScrollView
- (void)actionForUpScrollViewWithWidth:(CGFloat )width
                                andArr:(NSArray *)arr1;

#pragma mark upScrollView回调Block
- (void)actionForUpCalendarBlock;

#pragma mark 提前加载前后页面数据
- (void)changeFrameNextisZeroVelocity:(BOOL)isZero;
- (void)changeFrameBeforeisZeroVelocity:(BOOL)isZero;


@end
