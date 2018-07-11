//
//  JYScrollViewForCalendar.m
//  rilixiugai
//
//  Created by 吴冬 on 15/11/25.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYScrollViewForCalendar.h"
typedef NS_ENUM(int , selectForLine)
{
    
    firstLine = 0,
    secondLine ,
    thirdLine ,
    fourthLine ,
    fifthLine,
    sixthLine,
    seventhLine,
};

//创建view
@interface JYScrollViewForCalendar (calendarView)

- (void)createCalendarWithArr:(NSArray *)arrForText isShow:(BOOL)isShow;

- (void)actionForChangeDateWithYear:(int )year month:(int)month day:(int)day arr:(NSArray *)arrForPoint tag:(int )senderTag;

@end



@implementation JYScrollViewForCalendar

- (instancetype)initWithFrame:(CGRect)frame
                   andTextArr:(NSArray *)arrForText
                       isShow:(BOOL)isShow
{
  
    if (self = [super initWithFrame:frame]) {
        
        width = kScreenWidth / 7.0;

        _manager = [JYSelectManager shareSelectManager];

        self.delegate = self;
        //self.decelerationRate = 0.01;
        
        [self createCalendarWithArr:arrForText isShow:isShow];
    }
    
    return self;
}
- (void)dealloc
{
    NSLog(@"JYScrollViewForCalendar  dealloc");
    
}
- (void)changeLabelTextAll:(NSArray *)arrForAll
                    isShow:(BOOL )isShow
{
 
    [_calendar1 changeLabelText:arrForAll[0] isShow:isShow withTag:100];
    [_calendar2 changeLabelText:arrForAll[1] isShow:isShow withTag:200];
    [_calendar3 changeLabelText:arrForAll[2] isShow:isShow withTag:300];
    [_calendar4 changeLabelText:arrForAll[3] isShow:isShow withTag:400];
    [_calendar5 changeLabelText:arrForAll[4] isShow:isShow withTag:500];
    [_calendar6 changeLabelText:arrForAll[5] isShow:isShow withTag:600];

    
}

- (void)changeLabelTextReload:(NSArray *)arrForAll
{
    [_calendar1 reloadDataForChangePoint:arrForAll[0]];
    [_calendar2 reloadDataForChangePoint:arrForAll[1]];
    [_calendar3 reloadDataForChangePoint:arrForAll[2]];
    [_calendar4 reloadDataForChangePoint:arrForAll[3]];
    [_calendar5 reloadDataForChangePoint:arrForAll[4]];
    [_calendar6 reloadDataForChangePoint:arrForAll[5]];
}


#pragma mark scrollView代理方法


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //NSLog(@"我听着滑动了");
    //[self actionForChangeFrame:scrollView];

}

//拖动结束调用的方法
- (void)actionForChangeFrame:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.y >= 3.5 * width) {
        
        [scrollView setContentOffset:CGPointMake(0, width * 6 + kHeightForWeek-1) animated:YES];
        
        _hiddenForCollection(NO);
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForClanderPostionChanged object:kClanderPostionHidden];
    }
    else if(scrollView.contentOffset.y > 0){

        [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _hiddenForCollection(YES);
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForClanderPostionChanged object:kClanderPostionShown];

    }else if (scrollView.contentOffset.y <= 0){
    
        _hiddenForCollection(YES);
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForClanderPostionChanged object:kClanderPostionShown];
    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    float vel = velocity.y;
    float v =  fabsf(vel);

    if (v > 1.0) {
        
        _hiddenForCollection(YES);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self actionForChangeFrame:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //当没有加速度的时候调用
    if (!decelerate) {
    
        [self actionForChangeFrame:scrollView];
    }

}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

//    switch (_typeForLine) {
//            
//        case firstLine:
//            
//           // [self insertSubview:_calendar1 atIndex:100];
//            
//            if (scrollView.contentOffset.y >= 0) {
//                
//
//                [_scrDelegate actionForHiddenTopView:NO];
//
//            }else{
//
//                
//                [_scrDelegate actionForHiddenTopView:YES];
//                
//            }
//
//            break;
//            
//        case secondLine:
//            
//            
//            [self actionForChangeView:scrollView.contentOffset.y change:_calendar2 before:_calendar1 andTag:1];
//            
//            break;
//            
//        case thirdLine:
//            
//            
//            [self actionForChangeView:scrollView.contentOffset.y change:_calendar3 before:_calendar2 andTag:2];
//            
//            break;
//            
//        case fourthLine:
//            
//            
//            
//            [self actionForChangeView:scrollView.contentOffset.y change:_calendar4 before:_calendar3 andTag:3];
//            
//            break;
//            
//        case fifthLine:
//            
//            
//            [self actionForChangeView:scrollView.contentOffset.y change:_calendar5 before:_calendar4 andTag:4];
//            
//            break;
//            
//        case sixthLine:
//            
//            
//            [self actionForChangeView:scrollView.contentOffset.y change:_calendar6 before:_calendar5 andTag:5];
//            break;
//            
//
//            
//        default:
//
//            break;
//            
//    }
  
   
    
}

- (void)actionForChangeView:(CGFloat )y
                     change:(UIView *)view1
                     before:(UIView *)view2
                     andTag:(int )tag
{
    
   // [self insertSubview:view1 atIndex:100];
    
    //将选中状态的View留在页面
    if (y >= width * tag) {
        
        
        [_scrDelegate actionForHiddenTopView:NO];
        
    }else{
        
       
        
        [_scrDelegate actionForHiddenTopView:YES];

    }

}

//是否隐藏topView
- (void)actionForHiddenTopView:(BOOL )isHidden
{
 
    if ([self.scrDelegate respondsToSelector:@selector(actionForHiddenTopView:)]) {
        
        [self.scrDelegate actionForHiddenTopView:isHidden];
    }
    
}

@end


#pragma mark 创建视图
@implementation JYScrollViewForCalendar (calendarView)

//传递label属性
- (void)abc:(int )tag type:( int )type
{
    _actionForTag(tag,type);
}

//改变年月日
- (void)actionForChangeDateWithYear:(int )year month:(int)month day:(int)day arr:(NSArray *)arrForPoint tag:(int )senderTag
{
  
    _actionForChangeDay(year,month,day,arrForPoint,senderTag);
    
}

//创建视图**********************************************
- (void)createCalendarWithArr:(NSArray *)arrForAllArr isShow:(BOOL )isShow
{
    if (IS_IPHONE_4_SCREEN) {
        self.weekFont = [UIFont systemFontOfSize:11];
    }else if (IS_IPHONE_5_SCREEN){
        self.weekFont = [UIFont systemFontOfSize:13];
    }else if (IS_IPHONE_6_SCREEN){
        self.weekFont = [UIFont systemFontOfSize:13];
    }else if (IS_IPHONE_6P_SCREEN){
        self.weekFont = [UIFont systemFontOfSize:13];
    }else{
        self.weekFont = [UIFont systemFontOfSize:11];
    }
    self.weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeightForWeek)];
    self.weekView.backgroundColor = [UIColor whiteColor];
    CGFloat widthForWeek = kScreenWidth / 7.0;
    
    NSArray *arrForWeek = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i < arrForWeek.count; i++) {
        
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * widthForWeek, 0, widthForWeek, kHeightForWeek)];
        weekLabel.text = arrForWeek[i];
        //weekLabel.backgroundColor = [UIColor orangeColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = self.weekFont;
        if (i >= 5) {
            
            weekLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue: 48 / 255.0 alpha:1];
        }
        
        [self.weekView addSubview:weekLabel];
    }
    
    [self addSubview:self.weekView];
    
    
    UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.weekView.bottom - 0.5, kScreenWidth, 0.5)];
    viewForLine.backgroundColor = lineColor;
    [self.weekView addSubview:viewForLine];


    _calendar1 = [[JYCalendarView alloc] initWithFrame:CGRectMake(0,kHeightForWeek, kScreenWidth, width) arrForLabel:arrForAllArr[0] andBtnTag:100 isShow:isShow];
    _calendar1.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendar1];

    
    __weak JYScrollViewForCalendar *scrVC = self;
    [_calendar1 setActionForSendDay:^(int tag) {
        
        _typeForLine = firstLine;
        [scrVC abc:tag type:firstLine];

    }];
    
    [_calendar1 setActionForChangeDay:^(int year, int month , int day ,NSArray *arrForPoint,int senderTag) {
        
        [scrVC actionForChangeDateWithYear:year month:month day:day arr:arrForPoint tag:senderTag];
        
    }];
 
    
    _calendar2 = [[JYCalendarView alloc] initWithFrame:CGRectMake(0, _calendar1.bottom, kScreenWidth, width) arrForLabel:arrForAllArr[1] andBtnTag:200 isShow:isShow];
    _calendar2.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendar2];
    [_calendar2 setActionForSendDay:^(int tag) {
        
        _typeForLine = secondLine;
        [scrVC abc:tag type:secondLine];

    }];
    
    [_calendar2 setActionForChangeDay:^(int year, int month , int day,NSArray *arrForPoint,int senderTag) {
        
        [scrVC actionForChangeDateWithYear:year month:month day:day arr:arrForPoint tag:senderTag];
        
    }];
    
    _calendar3 = [[JYCalendarView alloc] initWithFrame:CGRectMake(0, _calendar2.bottom, kScreenWidth, width) arrForLabel:arrForAllArr[2] andBtnTag:300 isShow:isShow];
    _calendar3.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendar3];
    [_calendar3 setActionForSendDay:^(int tag) {
        
        _typeForLine = thirdLine;
        [scrVC abc:tag type:thirdLine];
    }];
    
    [_calendar3 setActionForChangeDay:^(int year, int month , int day,NSArray *arrForPoint,int senderTag) {
        
        [scrVC actionForChangeDateWithYear:year month:month day:day arr:arrForPoint tag:senderTag];
        
    }];
    
    _calendar4 = [[JYCalendarView alloc] initWithFrame:CGRectMake(0, _calendar3.bottom, kScreenWidth, width) arrForLabel:arrForAllArr[3] andBtnTag:400 isShow:isShow];
    _calendar4.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendar4];
    [_calendar4 setActionForSendDay:^(int tag) {
        
        _typeForLine = fourthLine;
        [scrVC abc:tag type:fourthLine];

    }];
    
    [_calendar4 setActionForChangeDay:^(int year, int month , int day,NSArray *arrForPoint,int senderTag) {
        
        [scrVC actionForChangeDateWithYear:year month:month day:day arr:arrForPoint tag:senderTag];
        
    }];
    
    
    _calendar5 = [[JYCalendarView alloc] initWithFrame:CGRectMake(0, _calendar4.bottom, kScreenWidth, width) arrForLabel:arrForAllArr[4] andBtnTag:500 isShow:isShow];
    _calendar5.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendar5];
    
    [_calendar5 setActionForSendDay:^(int tag) {
        
        _typeForLine = fifthLine;
        [scrVC abc:tag type:fifthLine];

    }];
    
    [_calendar5 setActionForChangeDay:^(int year, int month , int day,NSArray *arrForPoint,int senderTag) {
        
        [scrVC actionForChangeDateWithYear:year month:month day:day arr:arrForPoint tag:senderTag];
        
    }];
    
    
    _calendar6 = [[JYCalendarView alloc] initWithFrame:CGRectMake(0, _calendar5.bottom, kScreenWidth, width) arrForLabel:arrForAllArr[5] andBtnTag:600 isShow:isShow];
    _calendar6.backgroundColor = [UIColor whiteColor];
    [self addSubview:_calendar6];
    [_calendar6 setActionForSendDay:^(int tag) {
        
        _typeForLine = sixthLine;
        [scrVC abc:tag type:sixthLine];

    }];
    
    [_calendar6 setActionForChangeDay:^(int year, int month , int day,NSArray *arrForPoint,int senderTag) {
        
        [scrVC actionForChangeDateWithYear:year month:month day:day arr:arrForPoint tag:senderTag];
    }];

}



@end

