//
//  YiJiDetailViewController.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePushViewController.h"
#import "BaseViewController.h"

@interface YiJiDetailViewController : BaseViewController

@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,copy) NSArray *activities;

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate activities:(NSArray *)activities;

@end
