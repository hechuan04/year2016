//
//  JYCalendarModel.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/3.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCalendarModel.h"
#import "JYToolForCalendar.h"
#import "CalculateRightWrong.h"
#import "SuanxingTool.h"
#import "LunarHelper.h"

@interface JYCalendarModel()

@property (nonatomic,strong) NSString *dateString;//yyyy-MM-dd HH:mm:ss
@property (nonatomic,strong) NSDateComponents *components;
@property (nonatomic,strong) NSArray *lunarDays;
@property (nonatomic,strong) NSArray *lunarMonths;
@property (nonatomic,strong) Lunar *lunar;
@property (nonatomic,strong) CalculateRightWrong *yijiCalculator;//宜、忌
@property (nonatomic,strong) NSArray *eras;//@[年干支,月干支,日干支,时干支]
@property (nonatomic,strong) NSDictionary *foDic;

@end

@implementation JYCalendarModel
@synthesize festival = _festival;
@synthesize weekCNString = _weekCNString;
@synthesize weekEnString = _weekEnString;
@synthesize lunarYear = _lunarYear;
@synthesize lunarMonth = _lunarMonth;
@synthesize lunarDay = _lunarDay;
@synthesize era = _era;
@synthesize eraYear = _eraYear;
@synthesize eraMonth = _eraMonth;
@synthesize eraDay = _eraDay;
@synthesize eraHour = _eraHour;
@synthesize zodia = _zodia;
@synthesize niceToDo = _niceToDo;
@synthesize badToDo = _badToDo;
@synthesize foDay = _foDay;

- (instancetype)initWithDate:(NSDate *)date
{
    self = [super init];
    if(self){
        _date = date;
    }
    return self;
}
- (instancetype)initWithYear:(NSInteger)year
                       month:(NSInteger)month
                         day:(NSInteger)day
{
    return [self initWithYear:year month:month day:day hour:0];
}
- (instancetype)initWithYear:(NSInteger)year
                       month:(NSInteger)month
                         day:(NSInteger)day
                        hour:(NSInteger)hour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    return [self initWithDate:[formatter dateFromString:dateString]];
}

- (void)setDate:(NSDate *)date{
    _date = date;
    
    //清空其他属性缓存
    _components = nil;
    _dateString = nil;
    _eraYear = nil;
    _weekCNString = nil;
    _weekEnString = nil;
    _festival = nil;
    _lunar = nil;
    _lunarYear = nil;
    _lunarMonth = nil;
    _lunarDay = nil;
    _era = nil;
    _eraYear = nil;
    _eraMonth = nil;
    _eraDay = nil;
    _eraHour = nil;
    _zodia = nil;
    _niceToDo = nil;
    _badToDo = nil;
    _foDay = nil;
}

#pragma mark - Public
- (NSInteger)year
{
    return [self.components year];
}
- (NSInteger)month
{
    return [self.components month];
}
- (NSInteger)day
{
    return [self.components day];
}
- (NSInteger)hour
{
    return [self.components hour];
}
- (NSInteger)minute
{
    return [self.components minute];
}
- (NSInteger)second
{
    return [self.components second];
}

- (NSString *)festival
{
    if(!_festival){
        _festival = [JYToolForCalendar actionForReturnFestialWithYear:(int)self.year month:(int)self.month day:(int)self.day];
    }
    return _festival;
}
- (NSString *)weekCNString
{
    if(!_weekCNString){
        
        NSInteger weekNum = [self.components weekday];
        switch (weekNum) {
            case 1:
                _weekCNString = @"星期日";
                break;
            case 2:
                _weekCNString = @"星期一";
                break;
            case 3:
                _weekCNString = @"星期二";
                break;
            case 4:
                _weekCNString = @"星期三";
                break;
            case 5:
                _weekCNString = @"星期四";
                break;
            case 6:
                _weekCNString = @"星期五";
                break;
            case 7:
                _weekCNString = @"星期六";
                break;
            default:
                break;
        }
    }
    return _weekCNString;
}

- (NSString *)weekEnString
{
    if(!_weekEnString){
        
        NSInteger weekNum = [self.components weekday];
        switch (weekNum) {
            case 1:
                _weekEnString = @"Sunday";
                break;
            case 2:
                _weekEnString = @"Monday";
                break;
            case 3:
                _weekEnString = @"Tuesday";
                break;
            case 4:
                _weekEnString = @"Wednesday";
                break;
            case 5:
                _weekEnString = @"Thursday";
                break;
            case 6:
                _weekEnString = @"Friday";
                break;
            case 7:
                _weekEnString = @"Saturday";
                break;
            default:
                break;
        }
    }
    return _weekEnString;
}
- (NSString *)lunarYear
{
    if(!_lunarYear){
        _lunarYear = [self convertYearToChinese:self.lunar.lunarYear];
    }
    return _lunarYear;
}
- (NSString *)lunarMonth
{
    if(!_lunarMonth){
        NSInteger index = self.lunar.lunarMonth-1;
        if(index<[self.lunarMonths count]){
            _lunarMonth = self.lunarMonths[index];
        }
    }
    return _lunarMonth;
}
- (NSString *)lunarDay
{
    if(!_lunarDay){
        NSInteger index = self.lunar.lunarDay-1;
        if(index<[self.lunarDays count]){
            _lunarDay = self.lunarDays[index];
        }
    }
    return _lunarDay;
}
- (NSString *)niceToDo
{
    if(!_niceToDo){
        
        NSDictionary *dic = [self.yijiCalculator suanYijiWithDate:self.date];
        _niceToDo = dic[@"宜"];
    }
    return _niceToDo;
}
- (NSString *)badToDo
{
    if(!_badToDo){
        NSDictionary *dic = [self.yijiCalculator suanYijiWithDate:self.date];
        _badToDo = dic[@"忌"];
    }
    return _badToDo;
}
- (NSString *)zodia
{
    if(!_zodia){
        _zodia = [[LunarHelper sharedInstance]getZodia:self.year month:self.month day:self.day];
    }
    return _zodia;
}
- (NSString *)era
{
    if(!_era){
        SuanxingTool *tool = [[SuanxingTool alloc]init];
        _era = [tool turnActionWithYear:self.year andMonth:self.month andDay:self.day andHours:self.hour];
    }
    return _era;
}
- (NSString *)eraYear
{
    if(!_eraYear){
//        if([self.eras count]>1){
//            _eraYear = self.eras[0];
//        }
        _eraYear = [[LunarHelper sharedInstance]calculateYearGanZhiWithYear:self.year month:self.month day:self.day];
    }
    return _eraYear;
}
- (NSString *)eraMonth
{
    if(!_eraMonth){
//        if([self.eras count]>2){
//            _eraMonth = self.eras[1];
//        }
        _eraMonth = [[LunarHelper sharedInstance]calculateMonthGanZhiWithYear:self.year month:self.month day:self.day];
    }
    return _eraMonth;
}
- (NSString *)eraDay
{
    if(!_eraDay){
        if([self.eras count]>3){
            _eraDay = self.eras[2];
        }
    }
    return _eraDay;
}
- (NSString *)eraHour
{
    if(!_eraHour){
        if([self.eras count]>4){
            _eraHour = self.eras[3];
        }
    }
    return _eraHour;
}
- (JYDateOrder)dateOrder
{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate];
    NSInteger m = [components month];
    NSInteger d = [components day];
    NSInteger y = [components year];
    
    if(self.year>y||(self.year>=y&&self.month>m)||(self.year>=y&&self.month>=m&&self.day>d)){
        return JYDateOrderAfterToday;
    }else if(self.year==y&&self.month==m&&self.day==d){
        return JYDateOrderEqualToday;
    }else{
        return JYDateOrderBeforeToday;
    }

}
- (NSString *)dateStringWithFormat:(NSString *)dateFormat
{
    if(!_dateString){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = dateFormat;
        _dateString = [formatter stringFromDate:self.date];
    }
    return _dateString;
}
- (NSString *)foDay
{
    if(!_foDay){
        if(!self.isLeap){
            NSString *key = [NSString stringWithFormat:@"%@%@",self.lunarMonth,self.lunarDay];
            _foDay = self.foDic[key];
        }
    }
    return _foDay;
}
- (BOOL)isLeap
{
    return self.lunar.isleap;
}
#pragma mark - Private
- (NSDateComponents *)components
{
    if(!_components){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        _components = [calendar components:unitFlags fromDate:self.date];
    }
    return _components;
}

- (NSArray *)lunarDays
{
    if(!_lunarDays){
        _lunarDays = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    }
    return _lunarDays;
}
- (NSArray *)lunarMonths
{
    if(!_lunarMonths){
        _lunarMonths = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
    }
    return _lunarMonths;
}
- (Lunar *)lunar
{
    if(!_lunar){
        Solar *solar = [[Solar alloc] init];
        solar.solarYear = (int)self.year;
        solar.solarMonth = (int)self.month;
        solar.solarDay = (int)self.day;
        _lunar = [LunarSolarConverter solarToLunar:solar];
    }
    return _lunar;
}
- (CalculateRightWrong *)yijiCalculator
{
    if(!_yijiCalculator){
        _yijiCalculator = [[CalculateRightWrong alloc]init];
    }
    return _yijiCalculator;
}
- (NSArray *)eras
{
    if(!_eras){
        _eras = [self.era componentsSeparatedByString:@" "];
    }
    return _eras;
}
- (NSString *)convertYearToChinese:(NSInteger)year
{
    NSArray *zh = @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];
    NSMutableString *muStr = [[NSMutableString alloc]init];
    NSInteger tmp;
    while (year>0) {
        tmp = year % 10;
        [muStr insertString:zh[tmp] atIndex:0];
        year = year / 10;
    }
    [muStr appendString:@"年"];
    return [muStr copy];
}
- (NSString *)convertMonthToChinese:(NSInteger)month
{
    NSArray *zh = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二"];
    if(month>0&&month<=[zh count]){
        return zh[month-1];
    }
    return @"";
}
- (NSString *)convertDayToChinese:(NSInteger)day
{
    NSArray *zh = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二十一",@"二十二",@"二十三",@"二十四",@"二十五",@"二十六",@"二十七",@"二十八",@"二十九",@"三十",@"三十一"];
    
    if(day>0&&day<=[zh count]){
        return zh[day-1];
    }
    return @"";
}
- (NSDictionary *)foDic
{
    if(!_foDic){
        _foDic = @{@"正月初一":@"弥勒菩萨",
                     @"正月初六":@"定光佛",
                     @"正月初八":@"释迦牟尼佛出家日",
                     @"二月十五":@"释迦牟尼佛涅磐日",
                     @"二月十九":@"观音菩萨",
                     @"二月廿一":@"普贤菩萨",
                     @"三月十六":@"准提菩萨",
                     @"三月廿五":@"多宝佛",
                     @"四月初六":@"文殊菩萨",
                     @"四月初八":@"释迦牟尼",
                     @"四月廿八":@"药王菩萨",
                     @"五月十三":@"伽蓝菩萨",
                     @"六月初三":@"韦驮菩萨",
                     @"六月初九":@"观世音菩萨成道日",
                     @"七月十三":@"大势至",
                     @"七月十五":@"诸佛欢喜",
                     @"七月廿一":@"普庵菩萨",
                     @"七月三十":@"地藏菩萨",
                     @"九月十九":@"观世音菩萨出家日",
                     @"九月三十":@"药师佛",
                     @"十月初五":@"达摩祖师",
                     @"冬月十七":@"阿弥陀佛",
                     @"腊月初八":@"成道日",
                     @"腊月廿九":@"华严菩萨"
                     };
    }
    return _foDic;
}

@end
