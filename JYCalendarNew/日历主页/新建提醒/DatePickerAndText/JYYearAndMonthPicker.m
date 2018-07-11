//
//  JYYearAndMonthPicker.m
//  textDatePicker
//
//  Created by 吴冬 on 15/11/3.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYYearAndMonthPicker.h"

#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight         [UIScreen mainScreen].bounds.size.height

#define heightForCell 85 / 1334.0 * kScreenHeight


#define xForFirstCell 77 / 750.0 * kScreenWidth
#define xForSecondCell 30 / 375.0 * kScreenWidth
#define xForThreeCell  -16 / 375.0 * kScreenWidth

@implementation JYYearAndMonthPicker
{
   
    CGFloat _width;
}

- (instancetype)initWithFrame:(CGRect)frame
{
   
    if (self = [super initWithFrame:frame]) {
        
        self.delegate = self;
        self.dataSource = self;

        
        _year = [[Tool actionForNowYear:nil] intValue];
        _month = [[Tool actionForNowMonth:nil] intValue];
        _day = [[Tool actionForNowSingleDay:nil] intValue];
        
        
        _width = kScreenWidth / 3.0;
        
        _arrForMuArr = [NSMutableArray array];
        
    }

    return self;
}

- (NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
   
    return 3;

}

//在这里调整宽度

- (CGFloat )pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    _width = kScreenWidth / 3.0;


    return _width;

}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    if (_isLunar) {
        
        if (component == 0) {
           
            UIView *viewForY = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, heightForCell)];
            //viewForY.backgroundColor = [UIColor yellowColor];
            
            
            UILabel *labelForYear = [[UILabel alloc] initWithFrame:CGRectMake(xForFirstCell, 0, 200, heightForCell)];
            labelForYear.text = [NSString stringWithFormat:@"%ld",(2015 + row % 10) ];
            labelForYear.font = [UIFont systemFontOfSize:32];
            labelForYear.textAlignment = NSTextAlignmentLeft;
            [viewForY addSubview:labelForYear];
            
            
            return viewForY;
            
        }else if(component == 1){
        
            UIView *viewForM = [[UIView alloc] initWithFrame:CGRectMake(_width, 0, _width, heightForCell)];
            //viewForM.backgroundColor = [UIColor orangeColor];
            
            UILabel *labelForMonth = [[UILabel alloc] initWithFrame:CGRectMake(xForSecondCell, 0, 200, heightForCell)];
            
            

            NSArray *arrForLunarMonth = [LunarModel arrForLunarMonth:_lunarYear];
            
            if (arrForLunarMonth.count == 13) {
                
                
            }
            
            NSString *strForM = arrForLunarMonth[row % arrForLunarMonth.count];
            //_lunarMonth = (int )row % arrForLunarMonth.count;
            
            labelForMonth.text = [NSString stringWithFormat:@"%@",strForM];
            if (strForM.length > 2) {
                
                labelForMonth.font = [UIFont systemFontOfSize:25];

            }else{
               
                labelForMonth.font = [UIFont systemFontOfSize:25];
            }
            
            
            labelForMonth.textAlignment = NSTextAlignmentLeft;
            [viewForM addSubview:labelForMonth];
            
            return viewForM;
            
        }else{
          
            NSArray *dayNameArray = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一"];
            UIView *viewForD = [[UIView alloc] initWithFrame:CGRectMake(_width * 2, 0, _width, heightForCell)];
            //viewForD.backgroundColor = [UIColor blueColor];
            
            UILabel *labelForDay = [[UILabel alloc] initWithFrame:CGRectMake(xForThreeCell - 10 , 0, 200, heightForCell)];
            NSString *strForD = dayNameArray[row];
            
            labelForDay.text = [NSString stringWithFormat:@"%@",strForD];
            labelForDay.font = [UIFont systemFontOfSize:25];
            //labelForDay.backgroundColor = [UIColor orangeColor];
            labelForDay.textAlignment = NSTextAlignmentLeft;
            [viewForD addSubview:labelForDay];
            
            return viewForD;
            
        }
        
    }else{
    
        if (component == 0) {
            
            UIView *viewForY = [[UIView alloc] initWithFrame:CGRectMake(5, 0, _width, heightForCell)];
            //viewForY.backgroundColor = [UIColor yellowColor];
            
            
            UILabel *labelForYear = [[UILabel alloc] initWithFrame:CGRectMake(xForFirstCell, 0, 200, heightForCell)];
            labelForYear.text = [NSString stringWithFormat:@"%ld",(long)(2015 + row % 10)];
            
            labelForYear.font = [UIFont systemFontOfSize:32];
            labelForYear.textAlignment = NSTextAlignmentLeft;
            [viewForY addSubview:labelForYear];
            
            return viewForY;
            
        }else if(component == 1){
            
            UIView *viewForM = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, heightForCell)];
           // viewForM.backgroundColor = [UIColor orangeColor];
            
            UILabel *labelForMonth = [[UILabel alloc] initWithFrame:CGRectMake(xForSecondCell, 0, 200, heightForCell)];
            
            NSString *strForM = [self returnTime:row % 12 + 1];
            
            labelForMonth.text = [NSString stringWithFormat:@"%@",strForM];
            
            
            labelForMonth.font = [UIFont systemFontOfSize:32];
            labelForMonth.textAlignment = NSTextAlignmentLeft;
            [viewForM addSubview:labelForMonth];
            
            return viewForM;
            
        }else{
            
            
            UIView *viewForD = [[UIView alloc] initWithFrame:CGRectMake(_width * 2, 0, _width, heightForCell)];
            //viewForD.backgroundColor = [UIColor blueColor];
            
            UILabel *labelForDay = [[UILabel alloc] initWithFrame:CGRectMake(xForThreeCell - 10, 0, 200, heightForCell)];
            NSString *strForD = [self returnTime:row + 1];
            
            labelForDay.text = [NSString stringWithFormat:@"%@",strForD];
            labelForDay.font = [UIFont systemFontOfSize:32];
            labelForDay.textAlignment = NSTextAlignmentLeft;
            [viewForD addSubview:labelForDay];
            
            return viewForD;
        }

    }
 
}

- (NSString *)returnTime:(NSInteger )row {
    NSString *rowStr = nil;
    if (row >= 10) {
        
        rowStr = [NSString stringWithFormat:@"%ld",(long)row];
        
        return rowStr;
        
    }else{
        
        rowStr = [NSString stringWithFormat:@"0%ld",(long)row];
        
        return rowStr;
        
    }
    
}

- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
    //阴历,阳历
    if (_isLunar) {
        
        if (component == 0) {
            
            return 10000;
            
            
        }else if(component == 1){
        
            NSArray *arr = [LunarModel arrForLunarDay:_lunarYear];

            return arr.count;
            
        }else{
        
            
            NSArray *arrForDayNumber = [LunarModel arrForLunarDay:_lunarYear];
            NSArray *arrForLunar = [LunarModel arrForLunarMonth:_lunarYear];
            
            int indexForRun = 0;
            
            //从大于闰月的那天起，index需要增加1
            for (int i = 0; i < arrForLunar.count; i++) {
                
                NSString *runStr = [arrForLunar[i] substringWithRange:NSMakeRange(0, 1)];
                if ([runStr isEqualToString:@"闰"]) {
                    
                    indexForRun = i;
                    break;
                }
            }
            
            
            
            int indexForLunar = 0;
            
            if (arrForLunar.count == 13) {
                
                if (self.isLeapNow) {
                    
                    indexForLunar = _lunarMonth + 1;
                    
                }else if(_lunarMonth > indexForRun){
                    
                    indexForLunar = _lunarMonth + 1;
                    
                }else{
                    
                    indexForLunar = _lunarMonth;
                }
                
            }else{
                
                indexForLunar = _lunarMonth;
            }
            
            
            
            int dayNumber = [arrForDayNumber[indexForLunar - 1] intValue];
            
            if (dayNumber < _lunarDay) {
                
                _lunarDay = dayNumber;
            }
            
            return dayNumber;
            
        }
        
        
        
    }else{
    
        if (component == 0) {
            
            return 10000;
            
        }else if(component == 1){
            
            return 10000;
            
        }else{
            
            
            if (_month == 1 || _month == 3 || _month == 5 || _month == 7 || _month == 8 || _month == 10 || _month == 12) {
                
                
                return 31;
                
            }else if(_month == 2 && _year % 4 != 0){
                
                if (_day > 28) {
                    
                    _day = 28;
                }
                
                if (_dayAction) {
                    
                    _dayAction(_day);
                }
                
                return  28;
                
            }else if(_month == 2 && _year % 4 == 0){
                
                if (_day > 29) {
                    
                    _day = 29;
                }
                
                if (_dayAction) {
                    
                    _dayAction(_day);
                }
                
                return  29;
                
            }else{
                
                if (_day > 30) {
                    
                    _day = 30;
                }
                
                if (_dayAction) {
                    
                    _dayAction(_day);
                }
                
                return  30;
                
            }

            
        }
    
    }
    
    

}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   //阴历选中
    if (_isLunar) {
        
        if (component == 0) {
            
            _lunarYear = row % 10 + 2015;

            [self reloadComponent:1];
            [self reloadComponent:2];
            
            NSArray *arrForMonth = [LunarModel arrForLunarMonth:_lunarYear];
            
            
            if (arrForMonth.count != 13) {
                
                self.isLeapNow = NO;
                
            }else if(arrForMonth.count == 13){
             
                self.isLeapNow = YES;
            }
            
            _actionForLunarYear(_lunarYear);
            
        }else if(component == 1){
        
            NSArray *arrForDayNumber = [LunarModel arrForLunarDay:_lunarYear];
            NSArray *arrForMonthName = [LunarModel arrForLunarMonth:_lunarYear];
            
            int indexForLunar = (int )row % (int )arrForDayNumber.count;
            NSString *lunarMonth = arrForMonthName[indexForLunar];
            
            _lunarMonth = [self actionForLunarMonth:lunarMonth];
            
            
          

            [self reloadComponent:2];
            
            _lunarMonthAction(_lunarMonth);


        
        }else{
        
            _lunarDay = (int )(row + 1);
            _lunarDayAction(_lunarDay);
            
        }
        
    }else{
    
    //阳历选中
        if (component == 0) {
            
            _year = row % 10 + 2015;
            _yearAction(_year);
            [self reloadComponent:2];
            
        }else if(component == 1){
            
            _month = row % 12 + 1;
            _monthAction(_month);
            [self reloadComponent:2];
            
        }else{
            
            _day = (int )(row + 1);
            _dayAction(_day);
            
        }
        
    }
   
    
    
}


/**
 *  返回一个lunarMonth
 */
- (int)actionForLunarMonth:(NSString *)isRun
{
 
    NSArray *arr = [isRun componentsSeparatedByString:@"闰"];
    
    NSString *keyStr = arr[0];
    if (arr.count == 2) {
        
        self.isLeapNow = YES;
        keyStr = arr[1];
        
    }else{
     
        self.isLeapNow = NO;
    }
    
    NSDictionary *dicForLunar = @{@"正月":@"1",@"二月":@"2",@"三月":@"3",@"四月":@"4",@"五月":@"5",@"六月":@"6",@"七月":@"7",@"八月":@"8",@"九月":@"9",@"十月":@"10",@"冬月":@"11",@"腊月":@"12"};
    
    int lunarMonth = [dicForLunar[keyStr] intValue];
    
    return lunarMonth;
    
}


- (CGFloat )pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
   
    return heightForCell;

}

@end
