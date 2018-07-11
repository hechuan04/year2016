//
//  JYClockPickerView.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYClockPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,copy)void (^hourAction)(int hour);
@property (nonatomic ,copy)void (^minuteAction)(int minute);

@end
