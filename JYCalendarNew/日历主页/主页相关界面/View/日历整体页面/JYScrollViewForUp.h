//
//  JYScrollViewForUp.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYCalendarView.h"
#import "JYScrollViewForCalendar.h"
@interface JYScrollViewForUp : UIScrollView<UIScrollViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame andArr:(NSArray *)arrForText andTag:(int )tag;

@property (nonatomic ,strong)JYCalendarView *calendarView;

@property (nonatomic ,strong)void (^actionForChangeData)(int year ,int month ,int day ,NSArray *arrForPoint ,int senderTag);
@property (nonatomic ,copy)void (^actionForLoad)(int tag);

@end
