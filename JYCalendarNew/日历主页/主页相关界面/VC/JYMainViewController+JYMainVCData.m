//
//  JYMainViewController+JYMainVCData.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYMainViewController+JYMainVCData.h"
#import "JYMainViewController+Action.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "JYMainViewController+UI.h"

@implementation JYMainViewController (JYMainVCData)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"


#pragma mark 当删除或者更新数据的时候，调用此方法更新页面
- (void)actionForloadData:(RemindModel *)model
{
    self.bgScrollView.scrollEnabled = self.canScroll;
    //换肤变色
    [self changeLeftBtn];
    [self changeRightBtn];
    
    //从新判断是否显示红点
    //选中红点置为nil
    self.selectManager.labelForBefore.backgroundColor = [UIColor clearColor];
    self.selectManager.viewForPoint = nil;
    self.selectManager.isHiddenPoint = NO;
    self.selectManager.labelForBefore = nil;
    self.selectManager.strForBeforeLabel = nil;
    
    int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
    
    //查询所有的任务
    LocalListManager *localManager = [LocalListManager shareLocalListManager];
    NSArray *allArrayLocal = [localManager searchAllDataWithText:@""];
    DataArray *dataArr = [DataArray shareDateArray];
    dataArr.arrForAllData = allArrayLocal;
    
    
    
    NSDictionary *dicForBefore  = [JYToolForCalendar actionForReturnYear:self.changeYear month:self.changeMonth day:self.changeDay isBefore:YES];
    NSArray *arr2 = [JYToolForReturnAllArray actionForReturnArrayWithYear:[dicForBefore[@"year"] intValue] month:[dicForBefore[@"month"] intValue] day:[dicForBefore[@"day"] intValue] isNowArr:NO];
    
    
    NSDictionary *dicForNext = [JYToolForCalendar actionForReturnYear:self.changeYear month:self.changeMonth day:self.changeDay isBefore:NO];
    NSArray *arr3 = [JYToolForReturnAllArray actionForReturnArrayWithYear:[dicForNext[@"year"] intValue] month:[dicForNext[@"month"] intValue] day:[dicForNext[@"day"] intValue] isNowArr:NO];
    
    
    NSArray *arr1 = [JYToolForReturnAllArray actionForReturnArrayWithYear:self.changeYear month:self.changeMonth   day:self.changeDay isNowArr:YES];
    
    [self.scrollView changeLabelTextAll:arr1 isShow:YES];
    [self.scrollView1 changeLabelTextAll:arr2 isShow:NO];
    [self.scrollView2 changeLabelTextAll:arr3 isShow:NO];
    
    //判断是否显示红点
    [self.scrollView changeLabelTextReload:arr1];
   
   
   
    //NSLog(@"哈哈");
    self.changeArrForHidden = arr1;
    
    self.x_Collection = self.selectManager.selectTag;
    
    if (self.isUp) {
            
        
        if (self.selectManager.selectTag >=600) {
            
            
            
            self.calendarView = self.scrollView.calendar6;
            self.lineSign = sixthLine;
            self.scrollView.typeForLine = sixthLine;
            
            
            UIButton *btn = [UIButton new];
            btn.tag = self.selectManager.selectTag;
            [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
            [self actionForBackTopView:5 btnTag:600];
            
            
            
            
        }else if (self.selectManager.selectTag < 600 && self.selectManager.selectTag >= 500){
            
            self.calendarView = self.scrollView.calendar5;
            self.lineSign = fifthLine;
            self.scrollView.typeForLine = fifthLine;
            
            
            UIButton *btn = [UIButton new];
            btn.tag = self.selectManager.selectTag;
            [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
            [self actionForBackTopView:4 btnTag:500];
            
            
            
        }else if (self.selectManager.selectTag < 500 && self.selectManager.selectTag >= 400){
            
            
            self.calendarView = self.scrollView.calendar4;
            self.lineSign = fourthLine;
            self.scrollView.typeForLine = fourthLine;
            
            
            UIButton *btn = [UIButton new];
            btn.tag = self.selectManager.selectTag;
            [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
            [self actionForBackTopView:3 btnTag:400];
            
            
            
        }else if (self.selectManager.selectTag < 400 && self.selectManager.selectTag >= 300){
            
            self.calendarView = self.scrollView.calendar3;
            self.lineSign = thirdLine;
            self.scrollView.typeForLine = thirdLine;
            
            
            UIButton *btn = [UIButton new];
            btn.tag = self.selectManager.selectTag;
            [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
            [self actionForBackTopView:2 btnTag:300];
            
            
            
        }else if (self.selectManager.selectTag < 300 && self.selectManager.selectTag >= 200){
            
            self.calendarView = self.scrollView.calendar2;
            self.lineSign = secondLine;
            self.scrollView.typeForLine = secondLine;
            
            
            UIButton *btn = [UIButton new];
            btn.tag = self.selectManager.selectTag;
            [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
            [self actionForBackTopView:1 btnTag:200];
            
            
            
        }else if (self.selectManager.selectTag < 200 && self.selectManager.selectTag >= 100){
            
            self.calendarView = self.scrollView.calendar1;
            self.lineSign = firstLine;
            self.scrollView.typeForLine = firstLine;
            
            [self actionForBackTopView:0 btnTag:100];
            
            
        }
        
    }else {
        
        
        if (self.selectManager.selectTag >=600) {
            
            self.calendarView = self.scrollView.calendar6;
            self.lineSign = sixthLine;
            self.scrollView.typeForLine = sixthLine;
            
            //[self actionForBackTopView:5 btnTag:600];
            
        }else if (self.selectManager.selectTag < 600 && self.selectManager.selectTag >= 500){
            
            self.calendarView = self.scrollView.calendar5;
            self.lineSign = fifthLine;
            self.scrollView.typeForLine = fifthLine;
            
            //[self actionForBackTopView:4 btnTag:500];
            
        }else if (self.selectManager.selectTag < 500 && self.selectManager.selectTag >= 400){
            
            
            self.calendarView = self.scrollView.calendar4;
            self.lineSign = fourthLine;
            self.scrollView.typeForLine = fourthLine;
            
            //[self actionForBackTopView:3 btnTag:400];
            
        }else if (self.selectManager.selectTag < 400 && self.selectManager.selectTag >= 300){
            
            self.calendarView = self.scrollView.calendar3;
            self.lineSign = thirdLine;
            self.scrollView.typeForLine = thirdLine;
            
            //[self actionForBackTopView:2 btnTag:300];
            
        }else if (self.selectManager.selectTag < 300 && self.selectManager.selectTag >= 200){
            
            self.calendarView = self.scrollView.calendar2;
            self.lineSign = secondLine;
            self.scrollView.typeForLine = secondLine;
            
            //[self actionForBackTopView:1 btnTag:200];
            
        }else if (self.selectManager.selectTag < 200 && self.selectManager.selectTag >= 100){
            
            self.calendarView = self.scrollView.calendar1;
            self.lineSign = firstLine;
            self.scrollView.typeForLine = firstLine;
            
            //[self actionForBackTopView:0 btnTag:100];
        }
        
        //判断是否是刷新的
        self.selectManager.isLoad = YES;
        
        //不是显示topView的情况下刷新，否则会把topView上的Label覆盖(只能选中一个，领一个不显示)
        if (!self.isUp) {
            
            UIButton *btn = [UIButton new];
            btn.tag = self.selectManager.selectTag;
            
            //[self performSelector:@selector(text) withObject:nil afterDelay:1];
            
            //是点击，需要传label的值
            [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:NO isChangeTopView:NO];
        }
        
    }
    
    
    if ((model.day == self.selectManager.g_notChangeDay && model.month == self.selectManager.g_notChangeMonth && model.year == self.selectManager.g_notChangeYear)){
        self.btnForToday.alpha = 0;
    }else{
        self.btnForToday.alpha = 1;
    }
    
    
    BOOL isAwait = [self.jyRemindView.awaitTableView loadData:model.year month:model.month day:model.day isAwaysChange:NO];
    BOOL isOther = [self.jyRemindView.alreayTableView loadData:model.year month:model.month day:model.day isAwaysChange:NO];
      
    if (isAwait) {
        
        [self actionForHiddenNotRemindView:NO];
        
    }else if (isOther){
        
        
        [self actionForHiddenNotRemindView:NO];
        
    }else {
        
        [self actionForHiddenNotRemindView:YES];
        
    }
    
    self.btnForTitle.calendarTitle.text = [NSString stringWithFormat:@"%d年%d月",self.changeYear,self.changeMonth];
    
    self.jyWeatherView.calendarModel = [[JYCalendarModel alloc]initWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
    
//    self.jyWeatherView.solarCalendar.text = [NSString stringWithFormat:@"%d",self.changeDay];
//    
//    self.jyWeatherView.weekDay.text = [Tool actionForEnglishWeekWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
//    self.jyWeatherView.lunarCalendar.text = [Tool actionForLunarWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
//    
//    self.jyWeatherView.holiDay.attributedText = [JYToolForCalendar actionForReturnTextWithYear:self.changeYear month:self.changeMonth day:self.changeDay weather:self.jyWeatherView];
//    self.jyWeatherView.holidayIcon.hidden = [self.jyWeatherView.holiDay.attributedText length]==0;
    

    
    //设置多少个未读
//    LocalListManager *manager = [LocalListManager shareLocalListManager];
//    [manager searchAllDataWithText:@""];
    

    
}

#pragma mark 插入数据方法
- (void)passModel:(RemindModel *)model remindOther:(BOOL)isOther
{
    
    //当用户点击进入后，更改了时间，同时更新主界面
    [super passModel:model remindOther:isOther];

    
}

#pragma mark 初始化年月日数据
- (void)actionForDate
{
    
    self.changeYear = [[Tool actionForNowYear:nil] intValue];
    self.changeMonth = [[Tool actionForNowMonth:nil] intValue];
    self.changeDay = [[Tool actionForNowSingleDay:nil] intValue];
    
    
    self.notChangeYear = self.changeYear;
    self.notChangeMonth = self.changeMonth;
    self.notChangeDay = self.changeDay;
    
    self.btnForTitle.calendarTitle.text = [NSString stringWithFormat:@"%d年%d月",self.changeYear,self.changeMonth];
    
   
}


//屏蔽警告
#pragma clang diagnostic pop

@end
