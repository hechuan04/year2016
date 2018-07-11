//
//  YiJiDatePickerView.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DateChooseCompletedBlock)(NSDate *selectedDate);

@interface YiJiDatePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIButton *confirmButton;

@property (nonatomic,strong) NSArray *years;
@property (nonatomic,strong) NSArray *months;
@property (nonatomic,strong) NSArray *days;

@property (nonatomic,copy) DateChooseCompletedBlock completedBlock;

@property (nonatomic,strong) MASConstraint *bottomConstraint;

+ (YiJiDatePickerView*)sharedView;

- (void)showWithDate:(NSDate *)date completed:(DateChooseCompletedBlock)block;
- (void)dismiss;

@end
