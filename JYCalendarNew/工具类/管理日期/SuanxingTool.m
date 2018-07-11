//
//  SuanxingTool.m
//  LiuNianYunCheng
//
//  Created by 吴冬 on 15/8/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "SuanxingTool.h"
#import "sys/sysctl.h"

@implementation SuanxingTool

{
  
    NSString *_tiangan;
    NSString *_dizhi;
    NSString *_yinyang;
    NSInteger _hours;
    NSString *_sex;
    
    NSArray * tianganArray;
    NSArray * dizhiArray ;
    
    NSArray * yinliMonthDzArray;
    
    NSDictionary * Yydict;
    NSDictionary * mingShuDict;
    NSDictionary * nayinDict ;
    
    NSInteger _todayYear;
    NSInteger _todayMonth;
    NSInteger _todayDay;

}

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
 
    return self;
}

/**
 *  工具方法，算命宫位置
 *
 *  @param month 月份
 *  @param hours 时辰
 *
 *  @return 返回命宫位置，以巳为起点开始算起
 */
+ (NSString *)minggongWithMonth:(NSInteger )month andHours:(NSInteger )hours
{
    
    //命宫
    NSInteger minggong ;
    NSInteger tagGong;
    //月份和时辰相等，月份大于时辰，月份小于时辰三种情况
    if (month - hours > 0) {
        
        minggong = month - hours;
        
        //获取命宫所在的View 例如：12 1 ，所在的view就是第8个。因为寅确定为第9格
        
        
        //如果minggong加上初始的9小于12，tag直接取就可以了，如果大于12就要减去相应的
        if (9 + minggong < 12) {
            
            tagGong = 9 + minggong;
            
            
            
        }else if (9 + minggong >=12){
            
            tagGong = 9 + minggong - 12;
            
            
        }
        
        
        
    }else if(month - hours <= 0){
        
        minggong = labs(month - hours);
        
        //月份小于时辰又分为，差值大于9或小于9的情况,如果差值小于9直接取差值为命宫位置，反之用差值+12取命宫位置
        
        if (minggong < 9) {
            
            tagGong = 9 - minggong;
            
            
        }else if(minggong > 9){
            
            
            tagGong = 12 + (9 - minggong);
            
            
            
        }else if(minggong == 9){
            
            tagGong = 0;
            
            
            
        }else if(month == hours){
            
            tagGong = 9;
            
        }
        
    }
    
    NSArray *arrForMingpan = @[@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",@"子",@"丑",@"寅",@"卯",@"辰"];
    
    NSString *strForMinggongDizhi = arrForMingpan[tagGong];
    
    return strForMinggongDizhi;
}


/**
 *  算阳历年
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 *  @param hours 时辰
 *
 *  @return 返回阳历的具体出生日期（阳历：2005年12月23日08时）
 */
+ (NSString *)returnActionForBornWithYear:(NSInteger)year
                                 andMonth:(NSInteger)month
                                   andDay:(NSInteger)day
                                 andHours:(NSInteger )hours
{
    
    
    NSString *monthSTR;
    NSString *daySTR;
    NSString *hoursSTR;
    if (month > 9) {
        
        monthSTR = [NSString stringWithFormat:@"%ld月",month];
        
    }else{
        
        monthSTR = [NSString stringWithFormat:@"0%ld月",month];
        
    }
    
    if (day > 9) {
        
        daySTR = [NSString stringWithFormat:@"%ld日",day];
        
    }else{
        
        daySTR = [NSString stringWithFormat:@"0%ld日",day];
    }
    
    if (hours > 9) {
        
        hoursSTR = [NSString stringWithFormat:@"%ld时",hours];
        
    }else{
        
        hoursSTR = [NSString stringWithFormat:@"0%ld时",hours];
        
    }
    
    NSString *bornDay = [NSString stringWithFormat:@"%ld年%@%@%@",year,monthSTR,daySTR,hoursSTR];
    
    
    return bornDay;
    
}




/**
 *  工具方法，定五行局
 *
 *  定五行局《出生年份的天干 配合 命宫地支》
 *
 *  @param mdz        地支
 *  @param chnytg     天干
 *  @param yinyangSTR 阴阳
 *
 *  @return 五行局
 */
+ (NSString * )wuxingjuDizhi:(NSString * ) mdz
                    tiangan:(NSString *)chnytg
                withYINYANG:(NSString *)yinyangSTR{
    
    NSDictionary * mgdizhi  = @{
                                @"子":@[@"水二局",@"火六局",@"土五局",@"木三局",@"金四局"],
                                @"丑":@[@"水二局",@"火六局",@"土五局",@"木三局",@"金四局"],
                                @"午":@[@"土五局",@"木三局",@"金四局",@"水二局",@"火六局"],
                                @"未":@[@"土五局",@"木三局",@"金四局",@"水二局",@"火六局"],
                                @"寅":@[@"火六局",@"土五局",@"木三局",@"金四局",@"水二局"],
                                @"卯":@[@"火六局",@"土五局",@"木三局",@"金四局",@"水二局"],
                                @"申":@[@"金四局",@"水二局",@"火六局",@"土五局",@"木三局"],
                                @"酉":@[@"金四局",@"水二局",@"火六局",@"土五局",@"木三局"],
                                @"辰":@[@"木三局",@"金四局",@"水二局",@"火六局",@"土五局"],
                                @"巳":@[@"木三局",@"金四局",@"水二局",@"火六局",@"土五局"],
                                @"戌":@[@"火六局",@"土五局",@"木三局",@"金四局",@"水二局"],
                                @"亥":@[@"火六局",@"土五局",@"木三局",@"金四局",@"水二局"]};
    
    
    
    NSDictionary * mgTiangan = @{@"甲":@(0),@"乙":@(1),@"丙":@(2),@"丁":@(3),@"戊":@(4),@"己":@(0),@"庚":@(1),@"辛":@(2),@"壬":@(3),@"癸":@(4)};
    //根据传进来命宫的地支获取相应地支的数组
    NSArray  * wuxingjuArray = mgdizhi[mdz];
    
    //根据传进来的出生年月天干获取在数组中对应的位置
    NSInteger   index = [mgTiangan[chnytg] intValue];
    
    //根据位置取出数组中对应的五行局
    NSString * wuxingjuStr = wuxingjuArray[index];
    
    return wuxingjuStr;
}


/**
 *  获取设备型号
 *
 *  @return 返回设备型号
 */
+ (NSString *)getCurrentDeviceModel{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}



/**
 *  所用到的字典
 */
- (void)createWUXINGshuju
{
  
}


/**
 *  返回五行
 *
 *  @param mTgDz 壬申
 *
 *  @return 返回五行字符串
 */
- (NSString *)suanMinChuanMtgdz:(NSString * )mTgDz and:(NSString * )chushengnuanyueYangli{
    

    
    NSDictionary *nayinDict1 = @{@"癸未":@"杨柳木",
                                @"壬午":@"杨柳木",
                                
                                @"辛巳":@"白蜡金",
                                @"庚辰":@"白蜡金",
                                
                                @"己卯":@"城头土",
                                @"戊寅":@"城头土",
                                
                                @"丁丑":@"涧下水",
                                @"丙子":@"涧下水",
                                
                                @"乙亥":@"山头火",
                                @"甲戌":@"山头火",
                                
                                @"癸酉":@"剑锋金",
                                @"壬申":@"剑锋金",
                                
                                @"辛未":@"路傍土",
                                @"庚午":@"路傍土",
                                
                                @"己巳":@"大林木",
                                @"戊辰":@"大林木",
                                
                                @"丁卯":@"炉中火",
                                @"丙寅":@"炉中火",
                                
                                @"乙丑":@"海中金",
                                @"甲子":@"海中金",
                                
                                @"癸卯":@"金箔金",
                                @"壬寅":@"金箔金",
                                
                                @"辛丑":@"壁上土",
                                @"庚子":@"壁上土",
                                
                                @"己亥":@"平地木",
                                @"戊戌":@"平地木",
                                
                                @"丁酉":@"山下火",
                                @"丙申":@"山下火",
                                
                                @"乙未":@"砂中金",
                                @"甲午":@"砂中金",
                                
                                @"癸巳":@"长流水",
                                @"壬辰":@"长流水",
                                
                                @"辛卯":@"松柏木",
                                @"庚寅":@"松柏木",
                                
                                @"己丑":@"霹雳火",
                                @"戊子":@"霹雳火",
                                
                                @"丁亥":@"屋上土",
                                @"丙戌":@"屋上土",
                                
                                @"乙酉":@"泉中水",
                                @"甲申":@"泉中水",
                                
                                @"癸亥":@"大海水",
                                @"壬戌":@"大海水",
                                
                                @"辛酉":@"石榴木",
                                @"庚申":@"石榴木",
                                
                                @"己未":@"天上火",
                                @"戊午":@"天上火",
                                
                                @"丁巳":@"砂中土",
                                @"丙辰":@"砂中土",
                                
                                @"乙卯":@"大溪水",
                                @"甲寅":@"大溪水",
                                
                                @"癸丑":@"桑拓木",
                                @"壬子":@"桑拓木",
                                
                                @"辛亥":@"钗钐金",
                                @"庚戌":@"钗钐金",
                                
                                @"己酉":@"大驿土",
                                @"戊申":@"大驿土",
                                
                                @"丁未":@"天河水",
                                @"丙午":@"天河水",
                                
                                @"乙巳":@"覆灯火",
                                @"甲辰":@"覆灯火"};
    
    
    NSDictionary *Yydict1 = @{
                             @"覆灯火":@"幸运数字 2 颜色 暖色系"
                             ,@"天河水":@"幸运数字 4 颜色 白色"
                             ,@"大驿土":@"幸运数字 5 颜色 土色"
                             ,@"钗钐金":@"幸运数字 4 颜色 白色"
                             ,@"桑拓木":@"幸运数字 3 颜色 木头色"
                             ,@"大溪水":@"幸运数字 1 颜色 黑色"
                             ,@"砂中土":@"幸运数字 5 颜色 黄色"
                             ,@"天上火":@"幸运数字 7 颜色 红色"
                             ,@"石榴木":@"幸运数字 6 颜色 木头色"
                             ,@"大海水":@"幸运数字 9 颜色 黑色"
                             ,@"泉中水":@"幸运数字 1 颜色 蓝色"
                             ,@"屋上土":@"幸运数字 5 颜色 黄色"
                             ,@"霹雳火":@"幸运数字 2 颜色 红色"
                             ,@"松柏木":@"幸运数字 3 颜色 木头色"
                             ,@"长流水":@"幸运数字 1 颜色 金属色"
                             ,@"砂中金":@"幸运数字 4 颜色 白色"
                             ,@"山下火":@"幸运数字 3 颜色 红色"
                             ,@"平地木":@"幸运数字 3 颜色 绿色"
                             ,@"壁上土":@"幸运数字 5 颜色 黄色"
                             ,@"金箔金":@"幸运数字 4 颜色 白色"
                             ,@"海中金":@"幸运数字 4 颜色 金色"
                             ,@"炉中火":@"幸运数字 2 颜色 红色"
                             ,@"大林木":@"幸运数字 3 颜色 蓝色"
                             ,@"路傍土":@"幸运数字 10 颜色 红色"
                             ,@"剑锋金":@"幸运数字 4 颜色 白色"
                             ,@"山头火":@"幸运数字 2 颜色 红色"
                             ,@"涧下水":@"幸运数字 1 颜色 黑色"
                             ,@"城头土":@"幸运数字 5 颜色 黄色"
                             ,@"白蜡金":@"幸运数字 4 颜色 白色"
                             ,@"杨柳木":@"幸运数字 8 颜色 木头色"};
    
    NSDictionary *mingShuDict1 = @{@"甲":@"木",
                                  @"乙":@"木",
                                  @"丙":@"火",
                                  @"丁":@"火",
                                  @"戊":@"土",
                                  @"己":@"土",
                                  @"庚":@"金",
                                  @"辛":@"金",
                                  @"壬":@"水",
                                  @"癸":@"水"
                                  };

    NSString * wuxingMingTz = [self suanWuxingMingOne123:chushengnuanyueYangli];
    NSString * str = [wuxingMingTz substringWithRange:NSMakeRange(0, 1)];
    
    NSString * str2 = mingShuDict1[str];
    NSString * wuxingM = [NSString stringWithFormat:@"%@命",str2];
    
    NSString * nayinJiaZi = nayinDict1[mTgDz];
    
    
    NSString  * yingyunShuzYanSe = Yydict1[nayinJiaZi];
    
    return [NSString stringWithFormat:@"%@ %@ %@",wuxingM,nayinJiaZi,yingyunShuzYanSe];
}


/**
 *  阳历转阴历
 *
 *  阳历
 *  @param year  年份
 *  @param month 月份
 *  @param day   日期
 *  @param hours 时辰
 *
 *  @return 返回一个阴历字符串
 */
- (NSString *)turnActionWithYear:(NSInteger )year
                  andMonth:(NSInteger )month
                    andDay:(NSInteger )day
                  andHours:(NSInteger )hours
{
    
    //今天的阳历日期
    _todayYear = year;
    _todayMonth = month;
    _todayDay = day;
  
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    
    
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [gregorian dateFromComponents:comps];
    
    
    NSCalendar *hebrew = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSUInteger unitFlags = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [hebrew components:unitFlags fromDate:date];
    
    NSInteger year1 = [components year]; // 阴历年
    //阴历月                    //阴历日
    NSString *zongStr =  [self returnYinliString:year1 andMonth:[components month] andDays:[components day] andHours:hours withYinyang:YES];
    
    return zongStr;
}


/**
 *  工具方法，算阴历所对应的天干，地之等
 *
 *  @param years  阴历年
 *  @param months 阴历月
 *  @param days   阴历日
 *  @param hours  时辰
 *
 *  @return 返回一个阴历日期
 */
- (NSString *)returnYinliString:(NSInteger )years
                       andMonth:(NSInteger )months
                        andDays:(NSInteger )days
                       andHours:(NSInteger )hours
                    withYinyang:(BOOL)isYangli
{
    
    if (years > 60) {
        
        years = years % 60;
        
        if (years > 3 ) {
            
            years = years - 3;
        }
        
    }
    
    if (hours == 24) {
        
        hours = 24 - 1;
    }
    
    
    NSDictionary *chineseHours = @{@(0):@"子",@(1):@"丑",@(2):@"丑",@(3):@"寅",@(4):@"寅",@(5):@"卯",@(6):@"卯",@(7):@"辰",@(8):@"辰",@(9):@"巳",@(10):@"巳",@(11):@"午",@(12):@"午",@(13):@"未",@(14):@"未",@(15):@"申",@(16):@"申",@(17):@"酉",@(18):@"酉",@(19):@"戌",@(20):@"戌",@(21):@"亥",@(22):@"亥",@(23):@"子",};
    
    NSString *dizhistr = chineseHours[@(hours)]; //获取当前小时的生肖，换算成所需要的时辰时间
    
    NSDictionary *chineseHours2 = @{@"子":@(1),@"丑":@(2),@"寅":@(3),@"卯":@(4),@"辰":@(5),@"巳":@(6),@"午":@(7),@"未":@(8),@"申":@(9),@"酉":@(10),@"戌":@(11),@"亥":@(12)};
    
    _hours = [chineseHours2[dizhistr] integerValue];
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛巳",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSString *yearNow = chineseYears[years - 1];
   
    
    //（甲、丙、戊、庚、壬等年出生者的男性称为阳男，女性称为阳女；乙、丁、己、辛、癸等年出生者的男性称为阴男，女性称为阴女
   
    _tiangan = [chineseYears[years - 1] substringWithRange:NSMakeRange(0, 1)];
    _dizhi = [chineseYears[years - 1] substringWithRange:NSMakeRange(1, 1)];
    
    NSString *todayDayStr;
    NSString *todayMonthStr;
    
    if (_todayDay<10) {
        
        todayDayStr= [NSString stringWithFormat:@"0%ld",_todayDay];
    }else{
    
        todayDayStr = [NSString stringWithFormat:@"%ld",_todayDay];
    }
    
    if (_todayMonth < 10) {
        
        todayMonthStr = [NSString stringWithFormat:@"0%ld",_todayMonth];
    }else{
    
        todayMonthStr = [NSString stringWithFormat:@"%ld",_todayMonth];
    }
    
    NSString *strForYangli = [NSString stringWithFormat:@"%ld-%@-%@",_todayYear,todayMonthStr,todayDayStr];
    
    NSString *strForYinli = [NSString stringWithFormat:@"%ld",months];
    
    NSString *zongStr = [self nianTgDz:yearNow andYinliMonth:strForYinli andyangliChushengnianyue:strForYangli andyinliHour:dizhistr];
    
    return zongStr;
}

//创建Arr和字典a
- (void)createZidian
{
  tianganArray  = @[@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸"];
        dizhiArray = @[@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥"];
    
        yinliMonthDzArray  = @[@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",@"子",@"丑"];
    
    nayinDict = @{@"癸未":@"杨柳木",
                                @"壬午":@"杨柳木",
                                
                                @"辛巳":@"白蜡金",
                                @"庚辰":@"白蜡金",
                                
                                @"己卯":@"城头土",
                                @"戊寅":@"城头土",
                                
                                @"丁丑":@"涧下水",
                                @"丙子":@"涧下水",
                                
                                @"乙亥":@"山头火",
                                @"甲戌":@"山头火",
                                
                                @"癸酉":@"剑锋金",
                                @"壬申":@"剑锋金",
                                
                                @"辛未":@"路傍土",
                                @"庚午":@"路傍土",
                                
                                @"己巳":@"大林木",
                                @"戊辰":@"大林木",
                                
                                @"丁卯":@"炉中火",
                                @"丙寅":@"炉中火",
                                
                                @"乙丑":@"海中金",
                                @"甲子":@"海中金",
                                
                                @"癸卯":@"金箔金",
                                @"壬寅":@"金箔金",
                                
                                @"辛丑":@"壁上土",
                                @"庚子":@"壁上土",
                                
                                @"己亥":@"平地木",
                                @"戊戌":@"平地木",
                                
                                @"丁酉":@"山下火",
                                @"丙申":@"山下火",
                                
                                @"乙未":@"砂中金",
                                @"甲午":@"砂中金",
                                
                                @"癸巳":@"长流水",
                                @"壬辰":@"长流水",
                                
                                @"辛卯":@"松柏木",
                                @"庚寅":@"松柏木",
                                
                                @"己丑":@"霹雳火",
                                @"戊子":@"霹雳火",
                                
                                @"丁亥":@"屋上土",
                                @"丙戌":@"屋上土",
                                
                                @"乙酉":@"泉中水",
                                @"甲申":@"泉中水",
                                
                                @"癸亥":@"大海水",
                                @"壬戌":@"大海水",
                                
                                @"辛酉":@"石榴木",
                                @"庚申":@"石榴木",
                                
                                @"己未":@"天上火",
                                @"戊午":@"天上火",
                                
                                @"丁巳":@"砂中土",
                                @"丙辰":@"砂中土",
                                
                                @"乙卯":@"大溪水",
                                @"甲寅":@"大溪水",
                                
                                @"癸丑":@"桑拓木",
                                @"壬子":@"桑拓木",
                                
                                @"辛亥":@"钗钐金",
                                @"庚戌":@"钗钐金",
                                
                                @"己酉":@"大驿土",
                                @"戊申":@"大驿土",
                                
                                @"丁未":@"天河水",
                                @"丙午":@"天河水",
                                
                                @"乙巳":@"覆灯火",
                                @"甲辰":@"覆灯火"};
    
    
    Yydict = @{
                             @"覆灯火":@"幸运数字：2 颜色：暖色系"
                             ,@"天河水":@"幸运数字：4 颜色：白色"
                             ,@"大驿土":@"幸运数字：5 颜色：土色"
                             ,@"钗钐金":@"幸运数字：4 颜色：白色"
                             ,@"桑拓木":@"幸运数字：3 颜色：木头色"
                             ,@"大溪水":@"幸运数字：1 颜色：黑色"
                             ,@"砂中土":@"幸运数字：5 颜色：黄色"
                             ,@"天上火":@"幸运数字：7 颜色：红色"
                             ,@"石榴木":@"幸运数字：6 颜色：木头色"
                             ,@"大海水":@"幸运数字：9 颜色：黑色"
                             ,@"泉中水":@"幸运数字：1 颜色：蓝色"
                             ,@"屋上土":@"幸运数字：5 颜色：黄色"
                             ,@"霹雳火":@"幸运数字：2 颜色：红色"
                             ,@"松柏木":@"幸运数字：3 颜色：木头色"
                             ,@"长流水":@"幸运数字：1 颜色：金属色"
                             ,@"砂中金":@"幸运数字：4 颜色：白色"
                             ,@"山下火":@"幸运数字：3 颜色：红色"
                             ,@"平地木":@"幸运数字：3 颜色：绿色"
                             ,@"壁上土":@"幸运数字：5 颜色：黄色"
                             ,@"金箔金":@"幸运数字：4 颜色：白色"
                             ,@"海中金":@"幸运数字：4 颜色：金色"
                             ,@"炉中火":@"幸运数字：2 颜色：红色"
                             ,@"大林木":@"幸运数字：3 颜色：蓝色"
                             ,@"路傍土":@"幸运数字：10 颜色：红色"
                             ,@"剑锋金":@"幸运数字：4 颜色：白色"
                             ,@"山头火":@"幸运数字：2 颜色：红色"
                             ,@"涧下水":@"幸运数字：1 颜色：黑色"
                             ,@"城头土":@"幸运数字：5 颜色：黄色"
                             ,@"白蜡金":@"幸运数字：4 颜色：白色"
                             ,@"杨柳木":@"幸运数字：8 颜色：木头色"};
    
    mingShuDict = @{@"甲":@"木",
                                  @"乙":@"木",
                                  @"丙":@"火",
                                  @"丁":@"火",
                                  @"戊":@"土",
                                  @"己":@"土",
                                  @"庚":@"金",
                                  @"辛":@"金",
                                  @"壬":@"水",
                                  @"癸":@"水"
                                  };
}


//计算生辰八字
-(NSString * )nianTgDz:(NSString *) nTgDz andYinliMonth:(NSString *)yinliMonth andyangliChushengnianyue:(NSString *)yanglichushengnianyueriStr andyinliHour:(NSString * )yinliHour{
    
    [self createZidian];
    
    //////////////////////月八字
    NSString * str = [nTgDz substringWithRange:NSMakeRange(0, 1)];
    NSInteger tgIdex = [tianganArray indexOfObject:str];
    NSInteger mtg = (tgIdex + 1) * 2  + [yinliMonth intValue];
    if (mtg > 10) {
        mtg = mtg - (int)(mtg/10) *10;
        if (mtg == 0) {
            mtg = 10;
        }
    }else{
        mtg = mtg;
    }
    
    NSString * baziMonth = [NSString stringWithFormat:@"%@%@",tianganArray[mtg -1],yinliMonthDzArray[[yinliMonth intValue] -1]];
    
    NSLog(@"%@",baziMonth);
    
    
    
    //////////////////////日八字
    NSString * year = [yanglichushengnianyueriStr substringWithRange:NSMakeRange(0, 4)];
    NSInteger  distanceDay = [self suanShengriJu2010year01month01dayTheDay:yanglichushengnianyueriStr];
    NSString * dayTG;
    NSString * dayDZ;
    NSInteger dayTg;
    if ([year intValue] < 2000) {
        dayTg  = 10 -(distanceDay  + 5)%10;
       
        if (dayTg == 0) {
            dayTg = 10;
        }
        
        dayTG = tianganArray[dayTg -1];

        NSInteger dayDz = 12 - (distanceDay + 5)%12;
        
        dayDZ = dizhiArray[dayDz - 1];
    }else if ([year intValue] >= 2000){
        
        
        
        dayTg  = (distanceDay  - 5)%10;

        if (dayTg == 0) {
            dayTg = 10;
        }


        dayTG = tianganArray[dayTg -1];
        
        NSInteger dayDz = (distanceDay - 5)%12;
        if (dayDz == 0) {
            dayDz = 12;
        }
        dayDZ = dizhiArray[dayDz - 1];
    }
    
    NSString * baziDay = [NSString stringWithFormat:@"%@%@",dayTG,dayDZ];
    NSLog(@"%@",baziDay);
    
    
    
    
    
    //////////////////////时八字
    NSInteger hourDz = [dizhiArray indexOfObject:yinliHour] + 1;

    NSInteger hourtg = dayTg *2 + hourDz -2;
    
    if (hourtg > 10) {
        hourtg = hourtg - (int)(hourtg/10) *10;
        if (hourtg == 0) {
            hourtg = 10;
        }
    }else{
        hourtg = hourtg;
    }
    
    
    NSString * hourTG = tianganArray[hourtg -1];
    
    
    NSString * baziHour = [NSString stringWithFormat:@"%@%@",hourTG,yinliHour];
    
    NSString * zongStr = [NSString stringWithFormat:@"%@年 %@月 %@日 %@时",nTgDz,baziMonth,baziDay,baziHour];
    //zongStr = [NSString stringWithFormat:@"%@年 %@月  %@日   %@时",nTgDz];
    return zongStr;
}


-(NSInteger)suanShengriJu2010year01month01dayTheDay :(NSString *) yanglishengrii{
    
    
    NSString * str = [yanglishengrii substringWithRange:NSMakeRange(0, 4)];
    
    NSString *dateContent;
    
    if ([str intValue] < 2000) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        //结束时间
        NSDate *endDate = [dateFormatter dateFromString:@"2000-01-01"];
        
        //当前时间
        NSDate *thedate = [dateFormatter dateFromString:yanglishengrii];
        
        //得到相差秒数
        NSTimeInterval time=[endDate timeIntervalSinceDate:thedate];
        
        NSInteger days = ((NSInteger)time)/86400;
        
        
        dateContent=[[NSString alloc] initWithFormat:@"%li天",(long)days];
        NSLog(@"%@",dateContent);
        
        
        
    }else if ([str intValue] >= 2000){
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        //结束时间
        NSDate *endDate = [dateFormatter dateFromString:@"2000-01-01"];
        
        //当前时间
        NSDate *thedate = [dateFormatter dateFromString:yanglishengrii];
        
        //得到相差秒数
        NSTimeInterval time=[endDate timeIntervalSinceDate:thedate];
        
        NSInteger days = ((NSInteger)time)/86400;
        
        if (days< 0) {
            days = days * -1;
        }
        dateContent=[[NSString alloc] initWithFormat:@"%li天",(long)days];
        NSLog(@"%@",dateContent);
        
    }
    
    return [dateContent integerValue];
}


- (NSString *)suanWuxingMingOne123:(NSString * )yanglinian{
    //////////////////////日八字
    [self createZidian];
    NSString * year = [yanglinian substringWithRange:NSMakeRange(0, 4)];
    NSInteger  distanceDay = [self suanShengriJu2010year01month01dayTheDay:yanglinian];
    NSString * dayTG;
    NSString * dayDZ;
    NSInteger dayTg;
    if ([year intValue] < 2000) {
        dayTg  = 10 -(distanceDay  + 5)%10;
        
        if (dayTg == 0) {
            dayTg = 10;
        }
        
        dayTG = tianganArray[dayTg -1];
        
        NSInteger dayDz = 12 - (distanceDay + 5)%12;
        
        dayDZ = dizhiArray[dayDz - 1];
    }else if ([year intValue] >= 2000){
        
        
        
        dayTg  = (distanceDay  - 5)%10;
        
        if (dayTg == 0) {
            dayTg = 10;
        }
        
        
        dayTG = tianganArray[dayTg -1];
        
        NSInteger dayDz = (distanceDay - 5)%12;
        if (dayDz == 0) {
            dayDz = 12;
        }
        dayDZ = dizhiArray[dayDz - 1];
    }
    
    NSString * baziDay = [NSString stringWithFormat:@"%@%@",dayTG,dayDZ];
    NSLog(@"%@",baziDay);
    
    return baziDay;
}

@end
