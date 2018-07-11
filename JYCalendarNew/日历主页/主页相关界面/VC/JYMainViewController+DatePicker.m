//
//  JYMainViewController+DatePicker.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYMainViewController+DatePicker.h"
#import "JYMainViewController+Action.h"
#import "AppDelegate.h"

#define heightForYearDatePicker 514 / 1334.0 * kScreenHeight
@implementation JYMainViewController (DatePicker)


- (void)_createDatePickerForYearAndMonth
{
    
    self.yearAndMinuteView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    self.yearAndMinuteView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.navigationController.view addSubview:self.yearAndMinuteView];
    
    UIButton *btnForCancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight - heightForYearDatePicker)];
    [btnForCancel addTarget:self action:@selector(actionForCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.yearAndMinuteView addSubview:btnForCancel];
    
    
    
    self.jyYearAndMonth = [JYYearAndMonthPicker new];
    self.jyYearAndMonth.backgroundColor = [UIColor whiteColor];
    [self.yearAndMinuteView addSubview:self.jyYearAndMonth];
    
    [self.jyYearAndMonth mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.yearAndMinuteView.mas_bottom).offset(-30);
        make.left.equalTo(self.yearAndMinuteView.mas_left);
        make.right.equalTo(self.yearAndMinuteView.mas_right);
        
    }];
    
    
    UIView *viewForBottom = [UIView new];
    viewForBottom.backgroundColor = [UIColor whiteColor];
    [self.yearAndMinuteView addSubview:viewForBottom];
    
    [viewForBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(100.f);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.jyYearAndMonth.mas_bottom);
        
    }];
    
    
    UIView *viewForTop = [UIView new];
    viewForTop.backgroundColor = [UIColor whiteColor];
    [self.yearAndMinuteView addSubview:viewForTop];
    
    [viewForTop mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50.f);
        make.bottom.equalTo(self.jyYearAndMonth.mas_top).offset(7);
        make.left.equalTo(self.jyYearAndMonth.mas_left);
        make.right.equalTo(self.jyYearAndMonth.mas_right);
    }];
    
    self.labelForLunar = [UILabel new];
    self.labelForLunar.text = @"农历";
    self.labelForLunar.textColor = [UIColor grayColor];
    self.labelForLunar.userInteractionEnabled = YES;
    //self.labelForLunar.font = [UIFont systemFontOfSize:15];
    [viewForTop addSubview:self.labelForLunar];
    
    [self.labelForLunar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(viewForTop.mas_top).offset(20.f);
        make.left.equalTo(viewForTop.mas_left).offset(20);
        
    }];
    
    
    self.btnForLunar = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnForLunar addTarget:self action:@selector(lunarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnForLunar setImage:[UIImage imageNamed:@"农选中.png"] forState:UIControlStateSelected];
    [self.btnForLunar setImage:[UIImage imageNamed:@"农未选中.png"] forState:UIControlStateNormal];
    [viewForTop addSubview:self.btnForLunar];
    
    [self.btnForLunar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(15.5);
        make.width.mas_equalTo(15.5);
        make.top.equalTo(viewForTop.mas_top).offset(23.f);
        make.left.equalTo(self.labelForLunar.mas_right).offset(3.f);
        
    }];
    
    
    UIButton *btnForBigLunar = [UIButton new];
    [btnForBigLunar addTarget:self action:@selector(lunarAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.labelForLunar addSubview:btnForBigLunar];
    
    [btnForBigLunar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50.f);
        make.width.mas_equalTo(100.f);
        make.top.equalTo(viewForTop.mas_top);
        make.left.equalTo(viewForTop.mas_left);
        
        
    }];
    
    
    UIButton *btnForCorfim = [UIButton new];
    
    [btnForCorfim addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewForTop addSubview:btnForCorfim];
    
    [btnForCorfim mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(50.f);
        make.width.mas_equalTo(100.f);
        make.top.equalTo(viewForTop.mas_top);
        make.right.equalTo(viewForTop.mas_right);
        
    }];
    
    UILabel *querenLabel = [UILabel new];
    querenLabel.text = @"确认";
    querenLabel.textColor = [UIColor redColor];
    querenLabel.textAlignment = NSTextAlignmentRight;
    
    [viewForTop addSubview:querenLabel];
    
    [querenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(viewForTop.mas_right).offset(-20.f);
        make.top.equalTo(viewForTop.mas_top).offset(20.f);
        
    }];
    
    //datePickerBlock回调
    [self actionForDatePickerBlock];
    
    
    //初始化一下datepicker数据
    [self.jyYearAndMonth selectRow:self.changeYear  - 2015 inComponent:0 animated:YES];
    [self.jyYearAndMonth selectRow:(self.changeMonth  - 1) * 13 inComponent:1 animated:YES];
    [self.jyYearAndMonth selectRow:self.changeDay - 1 inComponent:2 animated:YES];
    
    //确认方法 confirmAction
    CGFloat pageM = 0;
    CGFloat pageY = 0;
    CGFloat pageD = 0;
    
    if (IS_IPHONE_4_SCREEN) {
        
        pageM = 40;
        pageY = 0;
        pageD = 5;
        
    }else if (IS_IPHONE_5_SCREEN){
        
        pageM = 40;
        pageY = 0;
        pageD = 5;
        
    }else if (IS_IPHONE_6_SCREEN){
        
        pageM = 49;
        pageY = 10;
        pageD = 24;
        
    }else if (IS_IPHONE_6P_SCREEN){
        
        pageM = 55;
        pageY = 15;
        pageD = 37;
        
    }
    
    self.labelForY = [UILabel new];
    self.labelForY.text = @"年";
    self.labelForY.font = [UIFont systemFontOfSize:12];
    self.labelForY.textAlignment = NSTextAlignmentRight;
    [self.jyYearAndMonth addSubview:self.labelForY];
    
    CGFloat widthForYear = kScreenWidth / 3.0;
    [self.labelForY mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.jyYearAndMonth.mas_left).offset(widthForYear - pageY);
        make.top.equalTo(self.jyYearAndMonth.mas_centerY);
        
    }];
    
    self.labelForM = [UILabel new];
    self.labelForM.text = @"月";
    self.labelForM.font = [UIFont systemFontOfSize:12];
    [self.jyYearAndMonth addSubview:self.labelForM];
    
    [self.labelForM mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.jyYearAndMonth.mas_left).offset(widthForYear * 2 - pageM);
        make.top.equalTo(self.jyYearAndMonth.mas_centerY);
        
    }];
    
    self.labelForD = [UILabel new];
    self.labelForD.text = @"日";
    self.labelForD.font = [UIFont systemFontOfSize:12];
    [self.jyYearAndMonth addSubview:self.labelForD];
    
    
    [self.labelForD mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.jyYearAndMonth.mas_right).offset(-20-15-20-10 -pageD);
        make.top.equalTo(self.jyYearAndMonth.mas_centerY);
        
        
    }];
    
    self.labelForWeek = [UILabel new];
    self.labelForWeek.text = @"周一";
    self.labelForWeek.font = [UIFont systemFontOfSize:13];
    self.labelForWeek.textColor = [UIColor colorWithRed:232 / 255.0 green:57 / 255.0 blue:23 / 255.0 alpha:1];
    self.labelForWeek.userInteractionEnabled = YES;
    [self.jyYearAndMonth addSubview:self.labelForWeek];
    
    [self.labelForWeek mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.labelForD.mas_right).offset(3);
//        make.top.equalTo(self.jyYearAndMonth.mas_centerY).offset(-10.f);
        make.centerY.equalTo(self.jyYearAndMonth.mas_centerY);
        
    }];
    
    self.labelForToday = [UILabel new];
    self.labelForToday.backgroundColor = [UIColor colorWithRed:232 / 255.0 green:57 / 255.0 blue:23 / 255.0 alpha:1];
    self.labelForToday.textColor = [UIColor whiteColor];
    self.labelForToday.textAlignment = NSTextAlignmentCenter;
    self.labelForToday.font = [UIFont boldSystemFontOfSize:13];
    self.labelForToday.text = @"今";
    self.labelForToday.userInteractionEnabled = YES;
    [self.jyYearAndMonth addSubview:self.labelForToday];
    
    [self.labelForToday mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(15.f);
        make.width.mas_equalTo(15.f);
        make.left.equalTo(self.labelForWeek.mas_right).offset(5);
//        make.top.equalTo(self.jyYearAndMonth.mas_centerY).offset(-10.f);
        make.centerY.equalTo(self.jyYearAndMonth.mas_centerY);
        
        
    }];
    
    UIButton *btn = [UIButton new];
    [btn addTarget:self  action:@selector(selectToday:) forControlEvents:UIControlEventTouchUpInside];
    [self.labelForToday addSubview:btn];
    
    UIButton *btnToday = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.labelForWeek.width, self.labelForWeek.height)];
    [btnToday addTarget:self  action:@selector(selectToday:) forControlEvents:UIControlEventTouchUpInside];
    //btnToday.backgroundColor = [UIColor orangeColor];
    [self.yearAndMinuteView addSubview:btnToday];
    //
    [btnToday mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(100.f);
        make.width.mas_equalTo(50.f);
        make.right.equalTo(self.jyYearAndMonth.mas_right);
        make.top.equalTo(self.jyYearAndMonth.mas_centerY).offset(-30.f);
        
        
    }];
    //
    
    
}

/**
 *  datePicker回调block
 */
- (void)actionForDatePickerBlock
{
 
    __weak JYMainViewController *vc = self;
    [self.jyYearAndMonth setYearAction:^void(int year){
        
        [vc actionForYear:year];
        
    }];
    
    [self.jyYearAndMonth setMonthAction:^void(int month){
        
        [vc actionForMonth:month];
        
    }];
    
    [self.jyYearAndMonth setDayAction:^void(int day){
        
        [vc actionForDay:day];
        
    }];
    
    //农转阴
    [self.jyYearAndMonth setLunarMonthAction:^void(int lunarMonth){
        
        [vc actionForLunarMonth:lunarMonth];
        
    }];
    
    
    [self.jyYearAndMonth setLunarDayAction:^void(int lunarDay){
        
        [vc actionForLunarDay:lunarDay];
        
    }];
    
    //阴历月
    [self.jyYearAndMonth setActionForLunarYear:^(int lunarYear) {
        
        [vc changeAction];
        
        [vc actionForWeek];
    }];
    

}

//年
- (void)actionForYear:(int )year
{
    [self actionForWeek];
}

//月
- (void)actionForMonth:(int )month
{
    
    //_changeMonth = month;
    [self actionForWeek];
    
}

//天
- (void)actionForDay:(int )day
{
    
    //_changeDay = day;
    [self actionForWeek];
    
}

//阴历月
- (void)actionForLunarMonth:(int )lunarMonth
{
    /*
     _lunarMonth = lunarMonth;
     Lunar * lunar = [[Lunar alloc]init];
     
     //农
     lunar.lunarYear = self.jyYearAndMonth.lunarYear;
     lunar.lunarMonth = self.jyYearAndMonth.lunarMonth ;
     lunar.lunarDay = self.jyYearAndMonth.lunarDay;
     lunar.isleap   = self.jyYearAndMonth.isLeapNow;
     Solar * solar = [[Solar alloc]init];
     
     //农转公
     solar = [LunarSolarConverter lunarToSolar:lunar];
     
     _changeDay = solar.solarDay;
     _changeMonth = solar.solarMonth;
     _changeYear = solar.solarYear;
     */
    [self actionForWeek];
    
    
}

//阴历日
- (void)actionForLunarDay:(int)lunarDay
{
    /*
     _lunarDay = lunarDay;
     
     Lunar * lunar = [[Lunar alloc]init];
     
     //农
     lunar.lunarYear = self.jyYearAndMonth.lunarYear;
     lunar.lunarMonth = self.jyYearAndMonth.lunarMonth ;
     lunar.lunarDay = self.jyYearAndMonth.lunarDay;
     lunar.isleap = self.jyYearAndMonth.isLeapNow;
     
     Solar * solar = [[Solar alloc]init];
     //农转公
     solar = [LunarSolarConverter lunarToSolar:lunar];
     
     
     _changeDay = solar.solarDay;
     _changeMonth = solar.solarMonth;
     _changeYear = solar.solarYear;
     */
    
    [self actionForWeek];
    
}

//判断是否为闰月
- (void)changeAction
{
    
    NSArray *arrForMonthName = [LunarModel arrForLunarMonth:self.jyYearAndMonth.lunarYear];
    int indexForRun = 0;
    //闰月情况特殊
    if (arrForMonthName.count == 13) {
        
        for (int i = 0;  i< 13; i ++) {
            
            NSString *monthStr = arrForMonthName[i];
            NSString *runStr = [monthStr substringWithRange:NSMakeRange(0, 1)];
            
            if ([runStr isEqualToString:@"闰"]) {
                
                indexForRun = i;
                break;
            }
        }
        
        if (self.jyYearAndMonth.lunarMonth > indexForRun) {
            
            [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth inComponent:1 animated:NO];
            
        }else if(self.jyYearAndMonth.lunarMonth == indexForRun && self.jyYearAndMonth.isLeapNow == YES){
            
            [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth inComponent:1 animated:NO];
            
        }else{
            
            [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth - 1 inComponent:1 animated:NO];
        }
        
    }else{
        
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth - 1 inComponent:1 animated:NO];
    }
    
    [self actionForWeek];
}

//创建pickerView
//选中日期的方法
- (void)actionForCancel:(UIButton *)sender
{
    
    [self confirmAction:nil];
    
}

//确定按钮
- (void)confirmAction:(UIButton *)sender
{
    
    //取消
    if (sender == nil) {
        
        self.jyYearAndMonth.isLunar = NO;
        [self.jyYearAndMonth reloadAllComponents];
        
        self.btnForLunar.selected = NO;
        self.isLunar = NO;
        self.labelForLunar.textColor = [UIColor grayColor];
        self.labelForD.hidden = NO;
        self.labelForM.hidden = NO;
        
        [self calendarAction];
        
        return;
    }
    
    if (self.jyYearAndMonth.isLunar) {
        
        Lunar *lunar = [[Lunar alloc] init];
        lunar.lunarYear = self.jyYearAndMonth.lunarYear;
        lunar.lunarMonth = self.jyYearAndMonth.lunarMonth;
        lunar.lunarDay = self.jyYearAndMonth.lunarDay;
        lunar.isleap = self.jyYearAndMonth.isLeapNow;
        
        Solar *solar = [LunarSolarConverter lunarToSolar:lunar];
        
        self.changeYear = solar.solarYear;
        self.changeMonth = solar.solarMonth;
        self.changeDay = solar.solarDay;
        
    }
    
    self.jyYearAndMonth.isLunar = NO;
    [self.jyYearAndMonth reloadAllComponents];
    
    //    NSLog(@"阳历日:%d",self.jyYearAndMonth.day);
    //    NSLog(@"阳历月:%d",self.jyYearAndMonth.month);
    //    NSLog(@"阳历年:%d",self.jyYearAndMonth.year);
    //
    //    NSLog(@"阴历月----：%d",self.jyYearAndMonth.lunarMonth);
    //    NSLog(@"阴历日----：%d",self.jyYearAndMonth.lunarDay);
    
    self.btnForLunar.selected = NO;
    self.isLunar = NO;
    self.labelForLunar.textColor = [UIColor grayColor];
    self.labelForD.hidden = NO;
    self.labelForM.hidden = NO;
    
    self.changeYear = self.jyYearAndMonth.year;
    self.changeMonth = self.jyYearAndMonth.month;
    self.changeDay = self.jyYearAndMonth.day;
    
    [self calendarAction];
    
}

- (void)_isHiddenTb:(BOOL )isHidden
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
//    JYTabBarVC *tbVc = (JYTabBarVC *)appdelegate.window.rootViewController;
    RootTabViewController *tbVc = (RootTabViewController*)appdelegate.window.rootViewController;
    
    tbVc.tabBar.hidden = isHidden;
}

//选日期方法
- (void)calendarAction {
    
   
    
    self.isSelectYearAndMonth = !self.isSelectYearAndMonth;
    
    if (self.isSelectYearAndMonth) {
        
        
        self.jyYearAndMonth.day = self.changeDay;
        self.jyYearAndMonth.month = self.changeMonth;
        self.jyYearAndMonth.year = self.changeYear;
        
        
        
        [self.jyYearAndMonth selectRow:self.changeYear  - 2015 inComponent:0 animated:YES];
        [self.jyYearAndMonth selectRow:self.changeMonth  - 1 inComponent:1 animated:YES];
        [self.jyYearAndMonth selectRow:self.changeDay - 1 inComponent:2 animated:YES];
        
        [self actionForWeek];
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.yearAndMinuteView.origin = CGPointMake(0, 0);
            
        }];
        
        [self _isHiddenTb:YES];
        
    }else{
        
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.yearAndMinuteView.origin = CGPointMake(0, kScreenHeight);
            
            self.btnForSelectDay.userInteractionEnabled = NO;
            
        } completion:^(BOOL finished) {
            
            [self _isHiddenTb:NO];
            self.btnForSelectDay.userInteractionEnabled = YES;

        }];
        

        

        self.btnForTitle.calendarTitle.text = [NSString stringWithFormat:@"%d年%d月",self.changeYear,self.changeMonth];
        
     
        
        //当选择时间的时候，重置一下之前存储的点和label
        self.selectManager.labelForBefore.backgroundColor = [UIColor clearColor];
        self.selectManager.labelForBefore = nil;
        self.selectManager.strForBeforeLabel = nil;
        self.selectManager.viewForPoint = nil;
        self.selectManager.isHiddenPoint = YES;
        
        
        self.selectManager.g_changeYear = self.changeYear;
        self.selectManager.g_changeMonth = self.changeMonth;
        self.selectManager.g_changeDay = self.changeDay;
        
        RemindModel *model = [[RemindModel alloc] init];
        model.month = self.changeMonth;
        model.day = self.changeDay;
        model.year = self.changeYear;
        model.oid = 10000;
        model.uid = 10000;
        [self actionForloadData:model];
        
        
    }
    
    
    
}

//**************************点击阴阳历的转换的按钮***************************//
//阴阳历
- (void)lunarAction:(UIButton *)sender
{
    
    self.btnForLunar.selected = !self.btnForLunar.selected;
    
    self.isLunar = !self.isLunar;
    
    if (self.isLunar) {
        
        //点击以后确保阴历也发生变化
        [self lunarActionForLunar];
        
        self.jyYearAndMonth.isLunar = YES;
        
        
        //在刷新之前加，先取到这个月的正确天数显示
        [self.jyYearAndMonth reloadAllComponents];
        
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarYear - 2015 inComponent:0 animated:NO];
        
        NSArray *arrForMonthName = [LunarModel arrForLunarMonth:self.jyYearAndMonth.lunarYear];
        
        int runNext = 0;
        
        //判断阴历月份跳转的问题，取决于index
        if (arrForMonthName.count == 13) {
            
            for (int i = 0; i < arrForMonthName.count; i++) {
                
                NSString *runStr1 = arrForMonthName[i];
                
                NSString *runStr = [runStr1 substringWithRange:NSMakeRange(0, 1)];
                
                if ([runStr isEqualToString:@"闰"]) {
                    
                    runNext = i+1;
                }
                
            }
            
            if (self.jyYearAndMonth.lunarMonth >= runNext || self.jyYearAndMonth.isLeapNow) {
                
                [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth inComponent:1 animated:NO];
                
            }else {
                
                [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth - 1 inComponent:1 animated:NO];
            }
            
            
        }else {
            
            [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth - 1 inComponent:1 animated:NO];
        }
        
        
        
        
        
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarDay - 1 inComponent:2 animated:NO];
        
        self.labelForM.hidden = YES;
        self.labelForD.hidden = YES;
        
        self.labelForLunar.textColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
        
    }else{
        
        
        [self solorAction];
        
        self.jyYearAndMonth.isLunar = NO;
        [self.jyYearAndMonth reloadAllComponents];
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.year - 2015 inComponent:0 animated:NO];
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.month - 1 inComponent:1 animated:NO];
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.day - 1 inComponent:2 animated:NO];
        
        self.labelForM.hidden = NO;
        self.labelForD.hidden = NO;
        
        self.labelForLunar.textColor = [UIColor grayColor];
        
    }
    
}

//阳历转阴历
- (void)lunarActionForLunar
{
    Solar * solor = [[Solar alloc]init];
    
    //公
    solor.solarYear = self.jyYearAndMonth.year;
    solor.solarMonth = self.jyYearAndMonth.month;
    solor.solarDay = self.jyYearAndMonth.day;
    
    
    Lunar * lunar = [[Lunar alloc]init];
    
    
    //公转弄
    lunar = [LunarSolarConverter solarToLunar:solor];
    self.lunarMonth = lunar.lunarMonth;
    self.lunarDay = lunar.lunarDay;
    self.jyYearAndMonth.lunarDay = lunar.lunarDay;
    self.jyYearAndMonth.lunarMonth = lunar.lunarMonth;
    self.jyYearAndMonth.lunarYear = lunar.lunarYear;
    
    if (lunar.isleap) {
        
        self.jyYearAndMonth.isLeapNow = YES;
        
    }else {
        
        self.jyYearAndMonth.isLeapNow = NO;
    }
    
}

//点击今天那个按钮
- (void)selectToday:(UIButton *)sender
{
    NSInteger year = [[Tool actionForNowYear:nil] integerValue];
    NSInteger month = [[Tool actionForNowMonth:nil] integerValue];
    NSInteger day = [[Tool actionForNowSingleDay:nil] integerValue];
    
    self.jyYearAndMonth.year = (int )year;
    self.jyYearAndMonth.month = (int )month;
    self.jyYearAndMonth.day = (int )day;
    
    
    if (self.jyYearAndMonth.isLunar) {
        
        [self lunarActionForLunar];
        self.jyYearAndMonth.isLunar = YES;
        [self.jyYearAndMonth reloadAllComponents];
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarYear - 2015 inComponent:0 animated:YES];
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarMonth - 1 inComponent:1 animated:YES];
        [self.jyYearAndMonth selectRow:self.jyYearAndMonth.lunarDay - 1 inComponent:2 animated:YES];
        
        self.labelForM.hidden = YES;
        self.labelForD.hidden = YES;
        
        [self actionForWeek];
        
    }else{
        
        
        
        
        [self.jyYearAndMonth selectRow:year - 2015 inComponent:0 animated:YES];
        [self.jyYearAndMonth selectRow:month - 1 inComponent:1 animated:YES];
        [self.jyYearAndMonth selectRow:day - 1 inComponent:2 animated:YES];
        
        
        [self actionForWeek];
        
        
    }
    
    self.labelForToday.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
    
}

//返回阳历日期
- (Solar *)solorAction
{
    
    Lunar * lunar = [[Lunar alloc]init];
    
    //农
    lunar.lunarYear = self.jyYearAndMonth.lunarYear;
    lunar.lunarMonth = self.jyYearAndMonth.lunarMonth ;
    lunar.lunarDay = self.jyYearAndMonth.lunarDay;
    lunar.isleap = self.jyYearAndMonth.isLeapNow;
    Solar * solar = [[Solar alloc]init];
    
    //        solar.solarDay = 9;
    //        solar.solarMonth = 4;
    //        solar.solarYear = 2004;
    
    //农转公
    solar = [LunarSolarConverter lunarToSolar:lunar];
    
    self.jyYearAndMonth.day = solar.solarDay;
    self.jyYearAndMonth.month = solar.solarMonth;
    self.jyYearAndMonth.year = solar.solarYear;
    
    [self actionForWeek];
    
    return solar;
    
}

/**
 *  改变星期
 */
- (void)actionForWeek
{
    
    if (self.jyYearAndMonth.isLunar) {
        
        Lunar *lunar = [[Lunar alloc] init];
        lunar.lunarYear = self.jyYearAndMonth.lunarYear;
        lunar.lunarMonth = self.jyYearAndMonth.lunarMonth;
        lunar.lunarDay = self.jyYearAndMonth.lunarDay;
        lunar.isleap = self.jyYearAndMonth.isLeapNow;
        Solar *solar = [LunarSolarConverter lunarToSolar:lunar];
        self.jyYearAndMonth.year = solar.solarYear;
        self.jyYearAndMonth.month = solar.solarMonth;
        self.jyYearAndMonth.day = solar.solarDay;
        
    }
    
    NSDate *date = [Tool actionForReturnSelectedDateWithDay:self.jyYearAndMonth.day Year:self.jyYearAndMonth.year month:self.jyYearAndMonth.month];
    
    NSInteger weekNow  = [Tool actionForNowWeek:date];
    
    //周日 = 1 周一 = 2 ...周六 = 7
    self.labelForWeek.text = [self _returnStrForWeek:weekNow];
    
    int year = [[Tool actionForNowYear:nil] intValue];
    int month = [[Tool actionForNowMonth:nil] intValue];
    int day = [[Tool actionForNowSingleDay:nil] intValue];
    
    if (year == self.jyYearAndMonth.year && month == self.jyYearAndMonth.month && day == self.jyYearAndMonth.day) {
        
        self.labelForToday.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
        
    }else{
        
        self.labelForToday.backgroundColor = [UIColor grayColor];
        
    }
    
    
    
    
}

- (NSString *)_returnStrForWeek:(NSInteger )week
{
    
    if (week == 1) {
        
        return @"周日";
        
    }else if(week == 2){
        
        return @"周一";
        
    }else if(week == 3){
        
        return @"周二";
        
    }else if(week == 4){
        
        return @"周三";
        
    }else if(week == 5){
        
        return @"周四";
        
    }else if(week == 6){
        
        return @"周五";
        
    }else{
        
        return @"周六";
        
    }
    
}

@end
