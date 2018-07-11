//
//  JYSelectManager.m
//  rilixiugai
//
//  Created by 吴冬 on 15/11/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYSelectManager.h"

JYSelectManager *selectManager = nil;

@implementation JYSelectManager

+ (JYSelectManager *)shareSelectManager
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (selectManager == nil) {
            selectManager = [[JYSelectManager alloc] init];
        }
    });
    
    return selectManager;
}

- (void)actionForChangeDateWithYear:(int )year
                              month:(int )month
                                day:(int )day
{
   
    _g_changeYear = year;
    _g_changeMonth = month;
    _g_changeDay = day;

}

- (void)actionForChangeSingleDay:(int )day
{

    _g_changeDay = day;
  
}



@end
