//
//  JYClockPickerView.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYClockPickerView.h"

@implementation JYClockPickerView
{
 
    CGFloat _width;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
 
    if (self = [super initWithFrame:frame]) {
        
        
        self.dataSource = self;
        self.delegate = self;
        
        
        
        _width = kScreenWidth / 4.0;
    }

    return self;
}

- (CGFloat )pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
 
    return _width;
}

- (NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
 
    return 4;
}

- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

    if (component == 1) {
        
        return 10000;
        
    }else if(component == 2){
     
        return 10000;
    }
    
    return 0;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (component == 1) {
        
     
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 44.0)];
        
        int hour = row % 24;
        NSString *hourText = [Tool actionForTenOrSingleWithNumber:hour];
        
        label.text = hourText;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        //label.backgroundColor = [UIColor orangeColor];
        return label;
        
    }else if(component == 2){
    
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width , 44.0)];
        
        int minute = row % 60;
        NSString *minuteText = [Tool actionForTenOrSingleWithNumber:minute];
        label.text = minuteText;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        //label.backgroundColor = [UIColor yellowColor];
        return label;
        
    }
    
    return nil;
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
 
    if (component == 1) {
        
        _hourAction(row % 24);
        
    }else if(component == 2){
     
        _minuteAction(row % 60);
        
    }
    
}




@end
