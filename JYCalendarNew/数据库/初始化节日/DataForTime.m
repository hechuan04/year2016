//
//  DataForTime.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "DataForTime.h"

static DataForTime *dataForTime = nil;

@implementation DataForTime

+ (DataForTime *)shareDataForTime
{
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (dataForTime == nil) {
            
            dataForTime = [[DataForTime alloc] init];
            
            
        }
        
    });

    return dataForTime;
}

- (instancetype)init
{
  
    if (self = [super init]) {
        
        [self createDic];
    }

    return dataForTime;
}

- (void)createDic
{
    
    _dicForWork = [NSMutableDictionary dictionary];
    
    //元旦
    [_dicForWork setObject:@(holiDay) forKey:@"0101"];
    [_dicForWork setObject:@(holiDay) forKey:@"0102"];
    [_dicForWork setObject:@(holiDay) forKey:@"0103"];
    
  
    
    
    //劳动节
    [_dicForWork setObject:@(holiDay) forKey:@"0501"];
    [_dicForWork setObject:@(holiDay) forKey:@"0502"];
    [_dicForWork setObject:@(holiDay) forKey:@"0503"];


    
    //胜利日
    [_dicForWork setObject:@(holiDay) forKey:@"0903"];
    [_dicForWork setObject:@(holiDay) forKey:@"0904"];
    [_dicForWork setObject:@(holiDay) forKey:@"0905"];


    
    
    //国庆
    [_dicForWork setObject:@(holiDay) forKey:@"1001"];
    [_dicForWork setObject:@(holiDay) forKey:@"1002"];
    [_dicForWork setObject:@(holiDay) forKey:@"1003"];
    [_dicForWork setObject:@(holiDay) forKey:@"1004"];
    [_dicForWork setObject:@(holiDay) forKey:@"1005"];
    [_dicForWork setObject:@(holiDay) forKey:@"1006"];
    [_dicForWork setObject:@(holiDay) forKey:@"1007"];


 //****************************上班日*******************************//
    
    //元旦调休
    [_dicForWork setObject:@(workDay) forKey:@"0224"];


 
    //胜利日
    [_dicForWork setObject:@(workDay) forKey:@"0906"];
    [_dicForWork setObject:@(workDay) forKey:@"1010"];
    [_dicForWork setObject:@(workDay) forKey:@"1008"];
    [_dicForWork setObject:@(workDay) forKey:@"1009"];


    [self createLunarDay];
}

- (void )createLunarDay{

    
    //端午节
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0620"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0621"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0622"];
    
    //中秋节
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0926"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0927"];
   
    //除夕
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0218"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0219"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0220"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0221"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0222"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0223"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0224"];
    
    //春节调休
    [_dicForLunarWork setObject:@(workDay) forKey:@"0225"];
    [_dicForLunarWork setObject:@(workDay) forKey:@"0226"];
    [_dicForLunarWork setObject:@(workDay) forKey:@"0227"];
    [_dicForLunarWork setObject:@(workDay) forKey:@"0228"];
    
    //清明
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0404"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0405"];
    [_dicForLunarWork setObject:@(holiDay) forKey:@"0406"];
  
}


- (int )actionForReturnDay:(int )month
                       day:(int )day
                      year:(int )year
{
 
    Solar *solar = [[Solar alloc] init];
    solar.solarDay = day;
    solar.solarMonth = month;
    solar.solarYear = year;
    
    Lunar *lunar = [[Lunar alloc] init];
    lunar = [LunarSolarConverter solarToLunar:solar];
    
    int isWork = [self isWork:month day:day];
    
    return isWork;
    
}

- (BOOL )isWork:(int )month
            day:(int )day
{

    NSString *monthStr = @"";
    NSString *dayStr = @"";
    
    if (month >= 10) {
        
        monthStr = [NSString stringWithFormat:@"%d",month];
        
    }else{
        
        monthStr = [NSString stringWithFormat:@"0%d",month];
    }
    
    if (day >= 10) {
        
        dayStr = [NSString stringWithFormat:@"%d",day];
        
    }else{
        
        
        dayStr = [NSString stringWithFormat:@"0%d",day];
        
    }
    
    NSString *keyStr = [NSString stringWithFormat:@"%@%@",monthStr,dayStr];
    
    int isWork = [[_dicForWork objectForKey:keyStr] intValue];

    return isWork;

}

- (int )actionForReturnDay:(int )month
                       day:(int )day
{

    NSString *monthStr = @"";
    NSString *dayStr = @"";
    
    if (month >= 10) {
        
        monthStr = [NSString stringWithFormat:@"%d",month];
        
    }else{
    
        monthStr = [NSString stringWithFormat:@"0%d",month];
    }
    
    if (day >= 10) {
        
        dayStr = [NSString stringWithFormat:@"%d",day];
        
    }else{
    
      
        dayStr = [NSString stringWithFormat:@"0%d",day];
        
    }
    
    NSString *keyStr = [NSString stringWithFormat:@"%@%@",monthStr,dayStr];
    
   int isWork = [[_dicForLunarWork objectForKey:keyStr] intValue];
    
    return isWork;
    
}













@end
