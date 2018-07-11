//
//  SliderBtn.h
//  POP
//
//  Created by 吴冬 on 15/10/22.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^isSelect)(BOOL isSelected);

@interface SliderBtn : NSObject

//传进要加载的父视图上，默认frame  CGRectMake(100, 200, 100, 30)
- (instancetype)initWithView:(UIView *)superView;

//给你的按钮设置frame,相对于传进来的父视图
@property (nonatomic , assign)CGRect  btnRect;

//更改俩个label的大小
@property (nonatomic , strong)UIFont *fontForLabel;

//设置滑动块的颜色
@property (nonatomic , strong)UIColor *bgViewColor;

//设置俩个label字体的颜色 1为第一个Label颜色
@property (nonatomic , strong)NSArray *arrForLabelColor;

//设置按钮圆角
@property (nonatomic , assign)CGFloat cornerRadius;

//设置按钮俩个Label文字
@property (nonatomic , strong)NSArray *arrForLabelText;

//回调方法
@property (nonatomic , strong)isSelect isSelectedBlock;

@end
