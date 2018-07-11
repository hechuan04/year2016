//
//  DataForTime.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataForTime : NSObject

typedef NS_ENUM(int , isWorkDay) {

    workDay = 1,
    holiDay = 2,
    nothingDay = 3,
    

};


+ (DataForTime *)shareDataForTime;


- (int )actionForReturnDay:(int )month
                       day:(int )day;

- (int )actionForReturnDay:(int )month
                       day:(int )day
                      year:(int )year;

@property (nonatomic ,assign)int year;
@property (nonatomic ,assign)int month;
@property (nonatomic ,assign)int day;
@property (nonatomic ,strong)NSMutableDictionary *dicForWork;
@property (nonatomic ,strong)NSMutableDictionary *dicForLunarWork;
@property (nonatomic ,assign)BOOL isHiddenNow;

@property (nonatomic ,strong)NSArray *arrForAllPeople;

@end
