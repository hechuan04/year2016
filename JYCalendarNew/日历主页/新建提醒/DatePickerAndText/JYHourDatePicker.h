//
//  JYHourDatePicker.h
//  textDatePicker
//
//  Created by 吴冬 on 15/11/3.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hourAction)(int hour);
typedef void(^minuteAction)(int minute);

@interface JYHourDatePicker : UIPickerView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic ,assign)int hour;
@property (nonatomic ,assign)int minute;

@property (nonatomic ,copy)hourAction hourAction;
@property (nonatomic ,copy)minuteAction minuteAction;

@end
