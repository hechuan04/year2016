//
//  ActivityCellBackgroundView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityCellBackgroundView : UIView

@property (nonatomic,strong) UIColor *fillColor;

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor *)fillColor;

@end
