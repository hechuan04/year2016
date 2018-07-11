//
//  RandomPickerView.m
//  DatePicker
//
//  Created by 吴冬 on 15/11/12.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "RandomPickerView.h"
#import "UIViewExt.h"
//屏宽
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define heightForPicker 89 / 1334.0 * kScreenHeight


@implementation RandomPickerView
{
  
    CGFloat _widthForBtn;

}
- (instancetype)initWithFrame:(CGRect)frame
{
  
    
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        
        _labelForSelect = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 + 30 ,self.height / 2.0 - 30 / 2.0, 30, 30)];
        _labelForSelect.text = @"日";
        _labelForSelect.textAlignment = NSTextAlignmentCenter;
        //_labelForSelect.backgroundColor = [UIColor purpleColor];
        [self addSubview:_labelForSelect];
    
        
        UILabel *labelForEvery = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth / 2.0 - 30 - 30, self.height / 2.0 - 30 / 2.0, 30, 30)];
        labelForEvery.text = @"每";
        labelForEvery.textAlignment = NSTextAlignmentCenter;
        //labelForEvery.backgroundColor = [UIColor purpleColor];
        [self addSubview:labelForEvery];
        
        
        [self selectRow:99 * 5 inComponent:0 animated:NO];
        
        _selectedRow = 2;
    }

    return self;
}




- (NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  
    return 1;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  
    return 10000;

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    NSInteger nowText = 0;
    
    if (_countForRow == selectDay) {
        
        nowText = row % 99 + 2;

    }else if (_countForRow == selectWeek){
        
        nowText = row % 11 + 2;
        
    }else if(_countForRow == selectMonth){
        
        nowText = row % 47 + 2;
        
    }else{
        
        nowText = row % 5 + 2;
        
    }
    
    _actionForRow(nowText);
    
    _selectedRow = nowText;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
   
    UILabel *labelForText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    labelForText.textAlignment = NSTextAlignmentCenter;
    labelForText.textColor = [UIColor grayColor];
    labelForText.font = [UIFont systemFontOfSize:24];
    
    if (_countForRow == selectDay) {
   
        NSInteger nowText = row % 99 + 2;
        labelForText.text = [NSString stringWithFormat:@"%ld",(long)nowText];
       
        
    }else if (_countForRow == selectWeek){
    
        NSInteger nowText = row % 11 + 2;

        labelForText.text = [NSString stringWithFormat:@"%ld",(long)nowText];
    
    }else if(_countForRow == selectMonth){

        NSInteger nowText = row % 47 + 2;

        labelForText.text = [NSString stringWithFormat:@"%ld",(long)nowText];
        
    }else{

        NSInteger nowText = row % 5 + 2;
        labelForText.text = [NSString stringWithFormat:@"%ld",(long)nowText];
    
    }
    
    return labelForText;

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{

    return heightForPicker;
    
}



@end
