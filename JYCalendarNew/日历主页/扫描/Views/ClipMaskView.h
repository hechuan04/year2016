//
//  ClipMaskView.h
//  ScanDemo
//
//  Created by Gaolichao on 16/6/3.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClipMaskView;

@protocol ClipMaskViewDelegate<NSObject>

- (void)clipMaskView:(ClipMaskView *)clipMaskView clippedWithRect:(CGRect)rect;

@end

@interface ClipMaskView : UIView

@property (nonatomic,strong) UIView *leftTopPointView;
@property (nonatomic,strong) UIView *rightTopPointView;
@property (nonatomic,strong) UIView *leftBottomPointView;
@property (nonatomic,strong) UIView *rightBottomPointView;

@property (nonatomic,weak) UIView *containerView;
@property (nonatomic,weak) id<ClipMaskViewDelegate> delegate;

@property (nonatomic,readonly) CGRect clippedRect;

- (instancetype)initWithContainerView:(UIView *)view;

- (void)show;
- (void)hide;
- (void)resetFrame;
- (void)clip;

@end
