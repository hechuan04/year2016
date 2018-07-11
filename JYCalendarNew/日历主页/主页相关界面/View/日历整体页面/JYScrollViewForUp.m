//
//  JYScrollViewForUp.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYScrollViewForUp.h"
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
@implementation JYScrollViewForUp

- (instancetype)initWithFrame:(CGRect)frame andArr:(NSArray *)arrForText andTag:(int)tag
{
 
    if (self = [super initWithFrame:frame]) {
       CGFloat width = kScreenWidth / 7.0;

        _calendarView = [[JYCalendarView alloc] initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, width) arrForLabel:arrForText[tag] andBtnTag:300 isShow:YES];
        _calendarView.isTop = YES;
        //_calendarView.backgroundColor = [UIColor blueColor];
        [_calendarView setActionForSendDay:^(int tag) {
            
            //_actionForLoad(tag);
        }];
        
        __weak JYScrollViewForUp *scr = self;
        [_calendarView setActionForChangeDay:^(int year, int month , int day,NSArray *arrForPoint,int senderTag) {
            
            scr.actionForChangeData(year,month,day,arrForPoint,senderTag);
            
        }];
        
        [self addSubview:_calendarView];
        
    }
    
    return self;
}


#pragma mark scrollView代理方法

//拖动结束调用的方法
- (void)actionForChangeFrame:(UIScrollView *)scrollView
{
    
    
    
  
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}



@end
