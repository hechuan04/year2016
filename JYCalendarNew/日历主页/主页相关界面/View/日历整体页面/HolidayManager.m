//
//  HolidayManager.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/11/9.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "HolidayManager.h"
static HolidayManager *manager = nil;
@implementation HolidayManager

+ (HolidayManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[HolidayManager alloc] init];
            [manager initialHolidayDic];
        }
    });
    
    return manager;
}

- (void)initialHolidayDic
{
    _holiday2015 = @{@"0101":@(100),@"0102":@(100),@"0103":@(100),@"0104":@(200),@"0218":@(100),@"0219":@(100),@"0220":@(100),@"0221":@(100),@"0222":@(100),@"0223":@(100),@"0224":@(100),@"0215":@(200),@"0228":@(200),@"0405":@(100),@"0406":@(100),@"0501":@(100),@"0502":@(100),@"0503":@(100),@"0620":@(100),@"0621":@(100),@"0622":@(100),@"0927":@(100),@"1001":@(100),@"1002":@(100),@"1003":@(100),@"1004":@(100),@"1005":@(100),@"1006":@(100),@"1007":@(100),@"1010":@(200)};
    
    _holiday2016 = @{@"0101":@(100),@"0102":@(100),@"0103":@(100),@"0207":@(100),@"0208":@(100),@"0209":@(100),@"0210":@(100),@"0211":@(100),@"0212":@(100),@"0213":@(100),@"0206":@(200),@"0214":@(200),@"0402":@(100),@"0403":@(100),@"0404":@(100),@"0430":@(100),@"0501":@(100),@"0502":@(100),@"0609":@(100),@"0611":@(100),@"0610":@(100),@"0612":@(200),@"0915":@(100),@"0916":@(100),@"0917":@(100),@"0918":@(200),@"1001":@(100),@"1002":@(100),@"1003":@(100),@"1004":@(100),@"1005":@(100),@"1006":@(100),@"1007":@(100),@"1008":@(200),@"1009":@(200),@"1231":@(100)};
    
    _holiday2017 = @{@"0101":@(100),@"0102":@(100),@"0122":@(200),@"0127":@(100),@"0128":@(100),@"0129":@(100),@"0130":@(100),@"0131":@(100),@"0201":@(100),@"0202":@(100),@"0204":@(200),@"0401":@(200),@"0402":@(100),@"0403":@(100),@"0404":@(100),@"0429":@(100),@"0430":@(100),@"0501":@(100),@"0527":@(200),@"0528":@(100),@"0529":@(100),@"0530":@(100),@"0930":@(200),@"1001":@(100),@"1002":@(100),@"1003":@(100),@"1004":@(100),@"1005":@(100),@"1006":@(100),@"1007":@(100),@"1008":@(100)};
    
    _holiday2018 = @{@"0101":@(100),@"0211":@(200),@"0215":@(100),@"0216":@(100),@"0217":@(100),@"0218":@(100),@"0219":@(100),@"0220":@(100),@"0221":@(100),@"0224":@(200),@"0405":@(100),@"0406":@(100),@"0407":@(100),@"0408":@(200),@"0428":@(200),@"0429":@(100),@"0430":@(100),@"0501":@(100),@"0616":@(100),@"0617":@(100),@"0618":@(100),@"0922":@(100),@"0923":@(100),@"0924":@(100),@"0929":@(200),@"0930":@(200),@"1001":@(100),@"1002":@(100),@"1003":@(100),@"1004":@(100),@"1005":@(100),@"1006":@(100),@"1007":@(100)};

}

- (NSString *)readyDatebase
{
    NSString * defaultDBPath = [[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:@"foZu.sqlite"];
   
    return defaultDBPath;
}

- (NSString *)searchFozuText:(NSString *)name
{
    NSString * dataFilePath = [self readyDatebase];
    sqlite3 * database;
    if (sqlite3_open([dataFilePath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"failen to open database");
    }
    NSString * query =[NSString stringWithFormat:@"SELECT * FROM foZudata where name = '%@'",name];
    sqlite3_stmt * statement;
    int rest = (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil));
    NSString  * str;
    if (sqlite3_step(statement) == SQLITE_ROW  ) {
        
        //int rownum = sqlite3_column_int(statement, 0);
        char  * rowdata = (char *)sqlite3_column_text(statement, 1);
        str = [[NSString alloc]initWithUTF8String:rowdata];
        NSLog(@"%@",str);
    }
    
    return str;
}

- (dayType)isWork:(NSString *)dayAndMonth year:(int)year
{
    NSInteger dayType = 0;
    if (year == 2015) {
        if ([_holiday2015 objectForKey:dayAndMonth]) {
            dayType = [[_holiday2015 objectForKey:dayAndMonth]integerValue];
        }
    }else if(year == 2016){
        if ([_holiday2016 objectForKey:dayAndMonth]) {
            dayType = [[_holiday2016 objectForKey:dayAndMonth]integerValue];
        }
    }else if(year == 2017){
        if ([_holiday2017 objectForKey:dayAndMonth]) {
            dayType = [[_holiday2017 objectForKey:dayAndMonth]integerValue];
        }
    }else if(year == 2018){
        if ([_holiday2018 objectForKey:dayAndMonth]) {
            dayType = [[_holiday2018 objectForKey:dayAndMonth]integerValue];
        }
    }
    
    return dayType;
}


@end
