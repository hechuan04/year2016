//
//  JYMainViewController+Gesture.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/15.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYMainViewController+Gesture.h"

@implementation JYMainViewController (Gesture)

/**
 *  手势方法创建
 */
- (void)actionForGesture
{
    //添加手势方法
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionForSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionForSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionForSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    //设置完UI在添加手势方法的view
    [self.view addGestureRecognizer:swipeDown];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
    
}

//手势方法

//*************************更改以后的界面方法***********************//
//是否需要换下一个view

- (void)actionForChangeView:(BOOL )isAdd
{
    
    if (isAdd) {
        
        switch (self.lineSign) {
            case firstLine:
                
                if (self.x_Collection - 100 >= 7) {
                    
                    self.x_Collection = 200;
                    self.selectTag = 200;
                    self.lineSign = secondLine;
                    self.calendarView = self.scrollView.calendar2;
                    
                    //滚动时候需要变换选中
                    self.scrollView.typeForLine = secondLine;
                    
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:200];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                }
                
                break;
                
            case secondLine:
                
                if (self.x_Collection - 200 >= 7) {
                    
                    self.x_Collection = 300;
                    self.selectTag = 300;
                    self.lineSign = thirdLine;
                    self.calendarView = self.scrollView.calendar3;
                    
                    self.scrollView.typeForLine = thirdLine;
                    
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:300];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                }
                break;
                
            case thirdLine:
                
                if (self.x_Collection - 300 >= 7) {
                    
                    self.x_Collection = 400;
                    self.selectTag = 400;
                    self.lineSign = fourthLine;
                    self.calendarView = self.scrollView.calendar4;
                    
                    self.scrollView.typeForLine = fourthLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:400];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                }
                
                break;
                
            case fourthLine:
                
                
                if (self.x_Collection - 400 >= 7) {
                    
                    self.x_Collection = 500;
                    self.selectTag = 500;
                    self.lineSign = fifthLine;
                    self.calendarView = self.scrollView.calendar5;
                    self.scrollView.typeForLine = fifthLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:500];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                }
                
                break;
                
            case fifthLine:
                
                if (self.x_Collection - 500 >= 7) {
                    
                    self.x_Collection = 600;
                    self.selectTag = 600;
                    self.lineSign = sixthLine;
                    self.calendarView = self.scrollView.calendar6;
                    self.scrollView.typeForLine = sixthLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:600];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                    
                }
                
                break;
                
            case sixthLine:
                
                if (self.x_Collection - 600 >= 7) {
                    
                    NSDictionary *dicForYear = [JYToolForCalendar actionForReturnYear:self.changeYear month:self.changeMonth day:self.changeDay isBefore:NO];
                    
                    NSInteger month123 = [dicForYear[@"month"] integerValue];
                    NSInteger year123 = [dicForYear[@"year"] integerValue];
                    
                    //加载数据
                    NSArray *arrNow = [JYToolForReturnAllArray actionForReturnArrayWithYear:(int )year123 month:(int )month123 day:2 isNowArr:YES];
                    [self.scrollView changeLabelTextAll:arrNow isShow:YES];
                    //暂时存储
                    self.changeArrForHidden = arrNow;
                    
                    
                    NSArray *arrBefore = [JYToolForReturnAllArray actionForReturnArrayWithYear:self.changeYear month:self.changeMonth day:1 isNowArr:NO];
                    [self.scrollView1 changeLabelTextAll:arrBefore isShow:NO];
                    
                    NSDictionary *dicNext = [JYToolForCalendar actionForReturnYear:(int )year123 month:(int )month123 day:2 isBefore:NO];
                    
                    int yearNext = [dicNext[@"year"] intValue];
                    int monthNext = [dicNext[@"month"] intValue];
                    
                    NSArray *arrNext = [JYToolForReturnAllArray actionForReturnArrayWithYear:yearNext month:monthNext day:1 isNowArr:NO];
                    [self.scrollView2 changeLabelTextAll:arrNext isShow:NO];
                    
                    
                    
                    
                    NSDate *date = [JYToolForCalendar actionForReturnSelectedDateWithDay:1 Year:self.changeYear month:self.changeMonth];
                    NSInteger weekNow  = [JYToolForCalendar actionForNowWeek:date];
                    NSInteger manyDays = [JYToolForCalendar actionForNowManyDayWithMonth:self.changeMonth year:self.changeYear];
                    
                    
                    //判断当前月的1号在周几
                    //周日 = 1 周一 = 2 ...周六 = 7
                    //将周几转换为index
                    if (weekNow == 1 || weekNow == 7 || (weekNow == 6 && manyDays == 31) ) {
                        
                        self.x_Collection = 200;
                        self.selectTag = 200;
                        self.lineSign = secondLine;
                        //                        _calendarView.origin = CGPointMake(0, width * 5);
                        self.calendarView = self.scrollView.calendar2;
                        //                        _calendarView.origin = CGPointMake(0, width * 6 + width );
                        
                        self.scrollView.typeForLine = secondLine;
                        UIButton *sender = [UIButton new];
                        sender.tag =  self.x_Collection;
                        [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                        
                        
                    }else{
                        
                        self.x_Collection = 300;
                        self.selectTag = 300;
                        self.lineSign = thirdLine;
                        
                        //                        _calendarView.origin = CGPointMake(0, width * 5);
                        self.calendarView = self.scrollView.calendar3;
                        //                        _calendarView.origin = CGPointMake(0, width * 6 + width );
                        
                        self.scrollView.typeForLine = thirdLine;
                        UIButton *sender = [UIButton new];
                        sender.tag =  self.x_Collection;
                        [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                        
                        
                    }
                    
                    self.changeMonth = (int)month123;
                    self.changeYear = (int )year123;
                    NSDate *date123 = [JYToolForCalendar actionForReturnSelectedDateWithDay:1 Year:self.changeYear month:self.changeMonth];
                    NSInteger weekNow123  = [JYToolForCalendar actionForNowWeek:date123];
                    self.weekForSelectMonth = (int)weekNow123;
                    
                    
                    //更改全局时间
                    [self.selectManager actionForChangeDateWithYear:self.changeYear month:self.changeMonth day:1];
                    
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:200];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                }
                
                break;
                
            default:
                break;
        }
        
    }else{
        
        switch (self.lineSign) {
            case firstLine:
                
                if (self.x_Collection - 100 < 0) {
                    
                    //判断当前月的1号在周几
                    //周日 = 1 周一 = 2 ...周六 = 7
                    //将周几转换为index
                    
                    NSDictionary *dicForYear = [JYToolForCalendar actionForReturnYear:self.changeYear month:self.changeMonth day:self.changeDay isBefore:YES];
                    
                    NSInteger month123 = [dicForYear[@"month"] integerValue];
                    NSInteger year123 = [dicForYear[@"year"] integerValue];
                    
                    NSDate *dateBefore = [JYToolForCalendar actionForReturnSelectedDateWithDay:1 Year:self.changeYear month:self.changeMonth];
                    NSInteger weekBefore = [JYToolForCalendar actionForNowWeek:dateBefore];
                    
                    NSDate *date = [JYToolForCalendar actionForReturnSelectedDateWithDay:1 Year:[dicForYear[@"year"] integerValue] month:[dicForYear[@"month"] integerValue]];
                    NSInteger weekNow  = [JYToolForCalendar actionForNowWeek:date];
                    //判断当前月的1号在周几
                    //周日 = 1 周一 = 2 ...周六 = 7
                    //将周几转换为index
                    NSInteger manyDays = [JYToolForCalendar actionForNowManyDayWithMonth:month123 year:year123];
                    
                    
                    //加载数据
                    NSArray *arrNow = [JYToolForReturnAllArray actionForReturnArrayWithYear:[dicForYear[@"year"] intValue] month:[dicForYear[@"month"] intValue] day:2 isNowArr:YES];
                    [self.scrollView changeLabelTextAll:arrNow isShow:YES];
                    self.changeArrForHidden = arrNow;
                    
                    NSArray *nextArr = [JYToolForReturnAllArray actionForReturnArrayWithYear:self.changeYear month:self.changeMonth day:1 isNowArr:NO];
                    [self.scrollView2 changeLabelTextAll:nextArr isShow:NO];
                    
                    
                    NSDictionary *dicBefore = [JYToolForCalendar actionForReturnYear:(int )year123 month:(int)month123 day:1 isBefore:YES];
                    int beforeYear = [dicBefore[@"year"] intValue];
                    int beforeMonth = [dicBefore[@"month"] intValue];
                    NSArray *beforeArr = [JYToolForReturnAllArray actionForReturnArrayWithYear:beforeYear month:beforeMonth day:1 isNowArr:NO];
                    [self.scrollView1 changeLabelTextAll:beforeArr isShow:NO];
                    
                    
                    if ((weekNow == 1 && manyDays >= 30) || (weekNow == 7 && manyDays == 31) || (weekBefore == 2)) {
                        
                        self.x_Collection = 506;
                        self.selectTag = 500;
                        self.lineSign = fifthLine;
                        self.calendarView = self.scrollView.calendar5;
                        
                        //滚动时候需要变换选中
                        self.scrollView.typeForLine = fifthLine;
                        
                        UIButton *sender = [UIButton new];
                        sender.tag =  self.x_Collection;
                        [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                        
                        
                        
                    }else{
                        
                        
                        self.x_Collection = 406;
                        self.selectTag = 400;
                        self.lineSign = fourthLine;
                        self.calendarView = self.scrollView.calendar4;
                        
                        //滚动时候需要变换选中
                        self.scrollView.typeForLine = fourthLine;
                        
                        UIButton *sender = [UIButton new];
                        sender.tag =  self.x_Collection;
                        [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                        
                        
                        
                    }
                    
                    self.changeMonth = (int)month123;
                    self.changeYear = (int )year123;
                    
                    NSDate *date123 = [JYToolForCalendar actionForReturnSelectedDateWithDay:1 Year:self.changeYear month:self.changeMonth];
                    NSInteger weekNow123  = [JYToolForCalendar actionForNowWeek:date123];
                    self.weekForSelectMonth = (int)weekNow123;
                    
                    
                    //更改全局时间
                    [self.selectManager actionForChangeDateWithYear:self.changeYear month:self.changeMonth day:1];
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:400];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                    
                }
                
                break;
                
            case secondLine:
                
                if (self.x_Collection - 200 < 0) {
                    
                    self.x_Collection = 106;
                    self.selectTag = 100;
                    self.lineSign = firstLine;
                    self.calendarView = self.scrollView.calendar1;
                    self.scrollView.typeForLine = firstLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:100];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                }
                
                break;
                
            case thirdLine:
                
                if (self.x_Collection - 300 < 0) {
                    
                    self.x_Collection = 206;
                    self.selectTag = 200;
                    self.lineSign = secondLine;
                    self.calendarView = self.scrollView.calendar2;
                    self.scrollView.typeForLine = secondLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:200];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                }
                
                break;
                
            case fourthLine:
                
                
                if (self.x_Collection - 400 < 0) {
                    
                    self.x_Collection = 306;
                    self.selectTag = 300;
                    self.lineSign = thirdLine;
                    self.calendarView = self.scrollView.calendar3;
                    self.scrollView.typeForLine = thirdLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:300];
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                    
                }
                
                break;
                
            case fifthLine:
                
                if (self.x_Collection - 500 < 0) {
                    
                    self.x_Collection = 406;
                    self.selectTag = 400;
                    self.lineSign = fourthLine;
                    self.calendarView = self.scrollView.calendar4;
                    self.scrollView.typeForLine = fourthLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:400];
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                    
                }
                
                break;
                
            case sixthLine:
                
                if (self.x_Collection - 600 < 0) {
                    
                    self.x_Collection = 506;
                    self.selectTag = 500;
                    self.lineSign = fifthLine;
                    self.calendarView = self.scrollView.calendar5;
                    self.scrollView.typeForLine = fifthLine;
                    UIButton *sender = [UIButton new];
                    sender.tag =  self.x_Collection;
                    [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
                    
                    [self.scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[self.selectTag / 100 - 1] isShow:YES withTag:500];
                    
                    
                    [self.scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:self.selectTag];
                }
                
                break;
                
            default:
                break;
        }
        
        
    }
    
}

#pragma mark 手势方法
- (void)actionForSwipe:(UISwipeGestureRecognizer *)swipe
{
    
    self.jyRemindView.isEdit = YES;
    [self.jyRemindView actionForEdit:nil];
    
    //如果没有划上去，不能相应手势方法
//    if (!self.isUp) {
//        
//        return;
//    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        
        
        self.x_Collection--;
        
        UIButton *sender = [UIButton new];
        sender.tag =  self.x_Collection;
        
        
        
        [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
        
        [self actionForChangeView:NO];
        
        UIButton *topSender = [UIButton new];
        topSender.tag = self.x_Collection - self.selectTag + 300;
        [self.scrollViewForUp.calendarView actionForSelectCalendar:topSender isNotBtnSelect:YES isChangeTopView:NO];
        
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        
        
        self.x_Collection++;
        
        UIButton *sender = [UIButton new];
        sender.tag =  self.x_Collection;
        
        
        
        
        [self.calendarView actionForSelectCalendar:sender isNotBtnSelect:YES isChangeTopView:NO];
        
        [self actionForChangeView:YES];
        
        UIButton *topSender = [UIButton new];
        topSender.tag = self.x_Collection - self.selectTag + 300;
        
        [self.scrollViewForUp.calendarView actionForSelectCalendar:topSender isNotBtnSelect:YES isChangeTopView:NO];
        
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionDown){
        
        //当向下滑动的时候，隐藏加载手势的页面
        self.scrollView.hiddenForCollection(YES);
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

@end
