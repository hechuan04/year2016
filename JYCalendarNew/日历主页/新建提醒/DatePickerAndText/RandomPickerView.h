//
//  RandomPickerView.h
//  DatePicker
//
//  Created by 吴冬 on 15/11/12.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RandomPickerView : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,assign)NSInteger countForRow;
@property (nonatomic ,strong)UILabel *labelForSelect;
@property (nonatomic ,strong)UIButton *btnForDay;
@property (nonatomic ,strong)UIButton *btnForWeek;
@property (nonatomic ,strong)UIButton *btnForMonth;
@property (nonatomic ,strong)UIButton *btnForYear;

@property (nonatomic ,copy)void (^actionForRow)(NSInteger row);


@property (nonatomic,assign) NSInteger selectedRow;//add 6.28
@end
