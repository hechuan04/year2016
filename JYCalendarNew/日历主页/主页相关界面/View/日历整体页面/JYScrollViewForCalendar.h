//
//  JYScrollViewForCalendar.h
//  rilixiugai
//
//  Created by 吴冬 on 15/11/25.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYCalendarView.h"
@class JYScrollViewForCalendar;
@protocol jyScrollViewForCalendarDelegate <NSObject>

- (void)actionForHiddenTopView:(BOOL)isHidden;

@end

@interface JYScrollViewForCalendar : UIScrollView<UIScrollViewDelegate>
{
 
    JYCalendarView *_calendar1;
    JYCalendarView *_calendar2;
    JYCalendarView *_calendar3;
    JYCalendarView *_calendar4;
    JYCalendarView *_calendar5;
    JYCalendarView *_calendar6;
    int             _typeForLine;
    UIScrollView   *_scrollView;
    
    CGFloat width;
    CGFloat         _y_begin;
    UIView       *_viewForGes;

    
    
}

- (instancetype)initWithFrame:(CGRect)frame
                   andTextArr:(NSArray *)arrForText
                       isShow:(BOOL)isShow;

@property (nonatomic ,strong)JYCalendarView *calendar1;
@property (nonatomic ,strong)JYCalendarView *calendar2;
@property (nonatomic ,strong)JYCalendarView *calendar3;
@property (nonatomic ,strong)JYCalendarView *calendar4;
@property (nonatomic ,strong)JYCalendarView *calendar5;
@property (nonatomic ,strong)JYCalendarView *calendar6;

@property (nonatomic ,strong)JYSelectManager *manager;

@property (nonatomic ,copy)void (^hiddenForCollection)(BOOL hidden);
@property (nonatomic ,copy)void (^actionForTag)(int tagSelect ,int type);
@property (nonatomic ,copy)void (^actionForChangeDay)(int year ,int month ,int day ,NSArray *arrForPoint ,int senderTag);

//星期
@property (nonatomic ,strong)UIView   *weekView;
//字体适配
@property (nonatomic ,strong)UIFont   *weekFont;

/**
 *  更改所有的label text
 */
- (void)changeLabelTextAll:(NSArray *)arrForAll
                    isShow:(BOOL )isShow;

/**
 *  单独更新是否有提醒点显示
 */
- (void)changeLabelTextReload:(NSArray *)arrForAll;
- (void)actionForChangeFrame:(UIScrollView *)scrollView;
@property (nonatomic ,assign)int tagForSender;
@property (nonatomic ,assign)int typeForLine;

@property (nonatomic ,weak)id<jyScrollViewForCalendarDelegate>scrDelegate;


@end
