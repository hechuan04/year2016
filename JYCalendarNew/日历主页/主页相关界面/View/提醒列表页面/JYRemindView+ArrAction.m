//
//  JYRemindView+ArrAction.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/16.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindView+ArrAction.h"

@implementation JYRemindView (ArrAction)

/**
 *  算优先级的方法
 *
 *  @return 
 */
- (NSArray *)actionForReturnAlreadyAndAwaitArray
{
    LocalListManager *manager = [LocalListManager shareLocalListManager];
    
    NSDate *dateNow = [NSDate date];
    
    NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;

    
    NSMutableArray *arrForAlready = [NSMutableArray array];
    NSMutableArray *arrForAwait   = [NSMutableArray array];
    
    //查询action
     NSArray *arrForAll = [manager searchAllDataWithText:@""];
    
    for (int i = 0; i < arrForAll.count; i++) {
        
        RemindModel *model = arrForAll[i];
  
        NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:model.day Year:model.year month:model.month hour:model.hour minute:model.minute];
       
        NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;

        //说明存储时间比现在时间晚，证明还未完成
        if (_fitstDate - _secondDate > 0) {
            
            [arrForAwait addObject:model];
            
        }else {
        
            //相反
            [arrForAlready addObject:model];
        }

    }
    
    NSArray *arrForAwaitAndAlready = @[arrForAwait,arrForAlready];

    return arrForAwaitAndAlready;
}

@end
