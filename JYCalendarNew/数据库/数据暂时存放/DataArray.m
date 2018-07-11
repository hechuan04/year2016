//
//  DataArray.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/6.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "DataArray.h"

static DataArray *dataArray = nil;

@implementation DataArray

+ (DataArray *)shareDateArray
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataArray = [[DataArray alloc] init];
        
    });
    
    return dataArray;
}

@end


