//
//  JYPickerViewForRemind.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/25.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYPickerViewForRemind.h"

static JYPickerViewForRemind *picker = nil;

@implementation JYPickerViewForRemind
{
 
    CGFloat _width;
    UIFont  *_fontForLabel;
    NSArray *_dayNameArray;
    int _numberForDay;
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
 
    if (self = [super initWithFrame:frame]) {
        
   _dayNameArray = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一"];
        
        
        _width = kScreenWidth / 5.0;
        self.delegate = self;
        self.dataSource = self;
        
        if (IS_IPHONE_4_SCREEN) {
            
            
        }else if(IS_IPHONE_5_SCREEN){
         
            
        }else if(IS_IPHONE_6_SCREEN){
         
            _cellHeight = 50;
            _fontForLabel = [UIFont systemFontOfSize:22];
            
        }else if(IS_IPHONE_6P_SCREEN){
         
        }
        
    
        _cellHeight = 50;
    }
    
    return self;
}

- (void)dealloc
{
    NSLog(@"JYPickerViewForRemind----dealloc");
}

- (CGFloat )pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    
    return _width;
}

- (CGFloat )pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
 
    return _cellHeight;
    
}

/**
 *  返回一个lunarMonth
 */
- (int)actionForLunarMonth:(NSString *)isRun
{
    
    NSArray *arr = [isRun componentsSeparatedByString:@"闰"];
    
    NSString *keyStr = arr[0];
    if (arr.count == 2) {
        
        self.isLeap = YES;
        keyStr = arr[1];
        
    }else{
        
        self.isLeap = NO;
    }
    
    NSDictionary *dicForLunar = @{@"正月":@"1",@"二月":@"2",@"三月":@"3",@"四月":@"4",@"五月":@"5",@"六月":@"6",@"七月":@"7",@"八月":@"8",@"九月":@"9",@"十月":@"10",@"冬月":@"11",@"腊月":@"12"};
    
    int lunarMonth = [dicForLunar[keyStr] intValue];
    
    return lunarMonth;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
 
    if (_isLunar) {
        
        
        switch (component) {
            case 0:
            {
                _lunarYear = row % 10 + 2015;
                
                
                
                [self reloadComponent:1];
                [self reloadComponent:2];
                
//                NSArray *arrForDayNumber = [LunarModel arrForLunarDay:_lunarYear];
//                NSArray *arrForMonthName = [LunarModel arrForLunarMonth:_lunarYear];
//                
//                int indexForLunar = (int )row % (int )arrForDayNumber.count;
//                NSString *lunarMonth = arrForMonthName[indexForLunar];
//                
//                _lunarMonth = [self actionForLunarMonth:lunarMonth];
                
                
                
                //_yearAction(_lunarYear);
                _actionForLunarYear(_lunarYear);
                
            }
                break;
            case 1:
                
            {
                NSArray *arrForDayNumber = [LunarModel arrForLunarDay:_lunarYear];
                NSArray *arrForMonthName = [LunarModel arrForLunarMonth:_lunarYear];
                
                int indexForLunar = (int )row % (int )arrForDayNumber.count;
                NSString *lunarMonth = arrForMonthName[indexForLunar];
                
                _lunarMonth = [self actionForLunarMonth:lunarMonth];
                
                
                
                
                [self reloadComponent:2];
                
                _actionForLunarMonth(_lunarMonth);
            
            }
                break;
            case 2:
                
            {
                _lunarDay = (int )(row + 1);

                _actionForLunarDay(_lunarDay);
                
            }
                break;
                
            case 3:
            {
                _hour = row % 24;
                _actionForHour(_hour);
            }
                break;
                
            case 4:
            {
                
                _minute = row % 60;
                _actionForMinute(_minute);
            }
                break;
                
                
            default:
                break;
        }
        
        
    }else{
     
        switch (component) {
            case 0:
            {
                _year = 2015 + row % 10;
                _actionForYear(_year);
                
                [self reloadComponent:1];
                [self reloadComponent:2];
                
            }
                break;
            case 1:
            {
             
                _month = row % 12 + 1;
                _actionForMonth(_month);
          
                
                [self reloadComponent:2];
                
                if (_day > _numberForDay) {
                    
                    _day = _numberForDay;
                    [self selectRow:_day - 1 inComponent:2 animated:NO];

                }

            }
                
                break;
            case 2:
                
            {
                
                _day = row % _numberForDay + 1;
            
                _actionForDay(_day);
                
                
            }
                break;
                
            case 3:
            {
                
                _hour = row % 24;
                _actionForHour(_hour);
                
            }
                break;
                
            case 4:
            {
                
                _minute = row % 60;
                _actionForMinute(_minute);
                
            }
                break;
                
                
            default:
                break;
        }
    }
    
}


//阳历
- (void)returnLabel:(NSString *)text superView:(UIView *)superView
{
    
    UILabel *labelForYear = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, _width, _cellHeight)];
    
    labelForYear.text = text;
    labelForYear.textAlignment = NSTextAlignmentCenter;
    labelForYear.font = _fontForLabel;
    [superView addSubview:labelForYear];
    
    //return labelForYear;
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
 
    UIView *viewForBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (_isLunar) {
        
        switch (component) {
            case 0:
            {
                
                int yearNow = 2015 + row % 10;
                NSString *yearStr = [NSString stringWithFormat:@"%d年",yearNow];
                [self returnLabel:yearStr superView:viewForBg];

                
            }
                break;
            case 1:
            {
                
                NSArray *arrForLunarMonth = [LunarModel arrForLunarMonth:_lunarYear];
                NSString *strForM = arrForLunarMonth[row % arrForLunarMonth.count];
                
                [self returnLabel:strForM superView:viewForBg];


                
            }
                break;
            case 2:
                
            {
                
                NSString *strForD = _dayNameArray[row];
                //NSLog(@"%@",strForD);
                [self returnLabel:strForD superView:viewForBg];

                
            }
                break;
                
            case 3:
            {
                int hourNow = row % 24;
                NSString *hourStr = [Tool actionForTenOrSingleWithNumber:hourNow];
                [self returnLabel:hourStr superView:viewForBg];
            }
                break;
                
            case 4:
            {
                int minuteNow = row % 60;
                NSString *minuteStr = [Tool actionForTenOrSingleWithNumber:minuteNow];
                UILabel *labelForYear = [[UILabel alloc] initWithFrame:CGRectMake(-15, 0, _width, _cellHeight)];
                
                labelForYear.text = minuteStr;
                labelForYear.textAlignment = NSTextAlignmentCenter;
                labelForYear.font = _fontForLabel;
                [viewForBg addSubview:labelForYear];
            }
                break;
                
                
            default:
                break;
        }
        
    }else{
     
        switch (component) {
            case 0:
            {
                int yearNow = 2015 + row % 10;
                NSString *yearStr = [NSString stringWithFormat:@"%d年",yearNow];
                [self returnLabel:yearStr superView:viewForBg];
                
                
            }
                break;
            case 1:
            {
                int monthNow = row % 12 + 1;
                NSString *monthStr = [NSString stringWithFormat:@"%d月",monthNow];
                [self returnLabel:monthStr superView:viewForBg];
                
            }
                break;
            case 2:
                
            {
                int dayNow = row % _numberForDay + 1;
                NSString *dayStr = [NSString stringWithFormat:@"%d日",dayNow];
                [self returnLabel:dayStr superView:viewForBg];
                
                if (_day > _numberForDay ) {
                    
                    _day = _numberForDay;
                    [self selectRow:_numberForDay - 1 inComponent:2 animated:NO];
                    
                }
                
            }
                break;
                
            case 3:
            {
                int hourNow = row % 24;
                NSString *hourStr = [Tool actionForTenOrSingleWithNumber:hourNow];
                [self returnLabel:hourStr superView:viewForBg];
            }
                break;
                
            case 4:
            {
                int minuteNow = row % 60;
                NSString *minuteStr = [Tool actionForTenOrSingleWithNumber:minuteNow];
                UILabel *labelForYear = [[UILabel alloc] initWithFrame:CGRectMake(-15, 0, _width, _cellHeight)];
                
                labelForYear.text = minuteStr;
                labelForYear.textAlignment = NSTextAlignmentCenter;
                labelForYear.font = _fontForLabel;
                [viewForBg addSubview:labelForYear];
                
                
            }
                break;
                
                
            default:
                break;
        }
    }
    
    return viewForBg;
}

- (NSInteger )numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
 
    return 5;
}

- (NSInteger )pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{

   
    if (_isLunar) {
 /************************************阴历******************************/
        switch (component) {
            case 0:
            {
                
                return 10000;
            }
                break;
            case 1:
            {
                
                NSArray *arr = [LunarModel arrForLunarDay:_lunarYear];
                
                return arr.count;
            }
                break;
            case 2:
                
            {
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
                    
                    if (self.isLeap) {
                        
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
                break;
                
            case 3:
            {
                return 10000;
            }
                break;
                
            case 4:
            {
                return 10000;
            }
                break;
                
                
            default:
                break;
        }
        
    }else{

/*****************************阳历***************************************/
        
        switch (component) {
            case 0:
            {
                
                return 10000;
            }
                break;
            case 1:
            {
                return 10000;
            }
                break;
            case 2:
                
            {                
                if (_month == 1 || _month == 3 || _month == 5 || _month == 7 || _month == 8 || _month == 10 || _month == 12) {
                    
                    _numberForDay = 31;
                    
                    
                }else if(_month == 2 && _year % 4 != 0){
                
                    _numberForDay = 28;
                    
                }else if(_month == 2 && _year % 4 == 0){
                    
             
                    _numberForDay = 29;
                  
                    
                }else{
                
                    _numberForDay = 30;
              

                }
           
                return 10000;
                
            }
                break;
                
            case 3:
            {
                return 10000;
            }
                break;
                
            case 4:
            {
                
                return 10000;
            }
                break;
                
                
            default:
                break;
        }
        
        
    }
    
    return 0;
    
}

@end
