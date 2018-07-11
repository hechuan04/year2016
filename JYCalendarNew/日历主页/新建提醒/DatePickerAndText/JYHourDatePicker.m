//
//  JYHourDatePicker.m
//  textDatePicker
//
//  Created by 吴冬 on 15/11/3.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYHourDatePicker.h"
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight         [UIScreen mainScreen].bounds.size.height

#define heightForPicker 89 / 1334.0 * kScreenHeight

#define xForHour 223 / 750.0 * kScreenWidth
#define xForMinute 55 / 750.0 * kScreenWidth

@implementation JYHourDatePicker
{
  
    CGFloat _width;
    CGFloat _xForMinute;
}

- (instancetype)initWithFrame:(CGRect)frame
{
   
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.dataSource = self;
        _width = kScreenWidth / 2.0;
        
     
        _hour = [[Tool actionforNowHour] intValue];
        _minute = [[Tool actionforNowMinute] intValue];
        
        [self selectRow:_hour - 1 inComponent:0 animated:YES];
        [self selectRow:_minute - 1 inComponent:1 animated:YES];
        
        [self frameAction];
        
    }

    
    return self;
}

//增加适配方法
- (void)frameAction
{

    NSString *str = [JYFontManager getCurrentDeviceModel];
    NSInteger type = [JYFontManager returnType:str];

    if (type == Type_iPhone6p) {
        
        _xForMinute = 0;
        
    }else{
     
        _xForMinute = 0;
    }

}

- (NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
   
    
    if (component == 0) {
        
        UIView *hourV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, heightForPicker)];
       // hourV.backgroundColor = [UIColor orangeColor];
        
        UILabel *labelH = [[UILabel alloc] initWithFrame:CGRectMake(xForHour + _xForMinute, 0, 100, heightForPicker)];
    
        NSString *rowStr = [self returnTime:row % 24 ];
        labelH.text = [NSString stringWithFormat:@"%@",rowStr];
        labelH.font = [UIFont systemFontOfSize:34];
       // labelH.backgroundColor = [UIColor whiteColor];
        labelH.textAlignment = NSTextAlignmentLeft;
        [hourV addSubview:labelH];
        
        return hourV;
        
    }else{
    
        
        
        UIView *minuteV = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, heightForPicker)];
       // minuteV.backgroundColor = [UIColor yellowColor];
        
        
        UILabel *minute = [[UILabel alloc] initWithFrame:CGRectMake(xForMinute, 0, 100, heightForPicker)];
        minute.textAlignment = NSTextAlignmentLeft;
        minute.font = [UIFont systemFontOfSize:34];
       // minute.backgroundColor = [UIColor orangeColor];
        NSString *rowStr = [self returnTime:row % 60 ];
        minute.text = [NSString stringWithFormat:@"%@",rowStr];
        
        [minuteV addSubview:minute];
        
        return minuteV;
    }
    

}

- (NSString *)returnTime:(NSInteger )row
{
    NSString *rowStr = nil;
    if (row >= 10) {
        
        rowStr = [NSString stringWithFormat:@"%ld",(long)row];
        
        return rowStr;
    }else{
    
        rowStr = [NSString stringWithFormat:@"0%ld",(long)row];
        
        return rowStr;
        
    }
    
}

- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
 
    if (component == 0) {
        
        return 10000 ;
        
    }else{
    
        return 10000 ;
    }
    

}

//选中时间的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  
    
    if (component == 0) {
        
        _hour = row % 24 ;
        _hourAction(row % 24 );
        
    }else{
    
        _minute = row % 60 ;
        _minuteAction(row % 60 );
    }

}



- (CGFloat )pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
   
    return heightForPicker;

}

@end
