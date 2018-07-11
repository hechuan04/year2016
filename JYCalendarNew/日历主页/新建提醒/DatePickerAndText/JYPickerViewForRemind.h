//
//  JYPickerViewForRemind.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface JYPickerViewForRemind : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>



@property (nonatomic ,assign)BOOL isLunar;

//阴历
@property (nonatomic ,assign)BOOL isLeap;


//阳历
@property (nonatomic ,assign)int year;
@property (nonatomic ,assign)int month;
@property (nonatomic ,assign)int day;
@property (nonatomic ,assign)int hour;
@property (nonatomic ,assign)int minute;

//阴历
@property (nonatomic ,assign)int lunarYear;
@property (nonatomic ,assign)int lunarMonth;
@property (nonatomic ,assign)int lunarDay;

//阳历传值方法
@property (nonatomic ,copy)void (^actionForYear)(int year);
@property (nonatomic ,copy)void (^actionForMonth)(int month);
@property (nonatomic ,copy)void (^actionForDay)(int day);
@property (nonatomic ,copy)void (^actionForHour)(int hour);
@property (nonatomic ,copy)void (^actionForMinute)(int minute);


//阴历传值方法
@property (nonatomic ,copy)void (^actionForLunarYear)(int lunarYear);
@property (nonatomic ,copy)void (^actionForLunarMonth)(int lunarMonth);
@property (nonatomic ,copy)void (^actionForLunarDay)(int lunarDay);


//cell高度
@property (nonatomic ,assign)CGFloat cellHeight;


@end
