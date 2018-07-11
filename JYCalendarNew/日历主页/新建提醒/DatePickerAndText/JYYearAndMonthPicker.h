//
//  JYYearAndMonthPicker.h
//  textDatePicker
//
//  Created by 吴冬 on 15/11/3.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^yearAction)(int year);
typedef void(^monthAction)(int month);
typedef void(^dayAction)(int day);

typedef void(^lunarMonthAction)(int month);
typedef void(^lunarDayAction)(int day);

@interface JYYearAndMonthPicker : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,assign)BOOL isLunar;

@property (nonatomic ,assign)int year;
@property (nonatomic ,assign)int month;
@property (nonatomic ,assign)int day;

@property (nonatomic ,assign)int lunarMonth;
@property (nonatomic ,assign)int lunarDay;
@property (nonatomic ,assign)int lunarYear;
@property (nonatomic ,assign)BOOL isLeapNow;

@property (nonatomic ,copy)yearAction yearAction;
@property (nonatomic ,copy)monthAction monthAction;
@property (nonatomic ,copy)dayAction   dayAction;

@property (nonatomic ,copy)lunarMonthAction lunarMonthAction;
@property (nonatomic ,copy)lunarDayAction lunarDayAction;
@property (nonatomic ,copy)void (^actionForLunarYear)(int lunarYear);

@property (nonatomic ,strong)NSArray *arrForLunarMonth;
@property (nonatomic ,strong)NSMutableArray *arrForMuArr;


@end
