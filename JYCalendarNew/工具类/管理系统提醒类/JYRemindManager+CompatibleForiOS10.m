//
//  JYRemindManager+CompatibleForiOS10.m
//  JYCalendarNew
//
//  Created by Gaolichao on 2016/9/28.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRemindManager+CompatibleForiOS10.h"

@implementation JYRemindManager (CompatibleForiOS10)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

+ (void)resetAllNotifications
{
    
    //取消掉所有的通知
    [[UNUserNotificationCenter currentNotificationCenter]removeAllPendingNotificationRequests];
    
    NSArray *arrForAccept = [[IncidentListManager shareIncidentManager] searchWithStr:@""];
    NSArray *clockArr    = [[JYClockList shareClockList] selectAllModel];
    NSArray *shareArr    = [[JYShareList shareList] searchWithStr:@""];
    NSArray *arrForSend  =  [[LocalListManager shareLocalListManager] searchLocalDataWithText:@""];
    
    
    NSMutableArray *arrForSever = [NSMutableArray arrayWithCapacity:arrForAccept.count + arrForSend.count];
    [arrForSever addObjectsFromArray:arrForAccept];
    [arrForSever addObjectsFromArray:arrForSend];
    
    //涉及到网络的,判断是否好友拼串里含有自己
    for (int i = 0; i < arrForSever.count; i++) {
        
        RemindModel *model = arrForSever[i];
        
        //无声or不提醒 略过
        if (model.isOn == 0 || model.musicName == 0) {
            
            continue;
        }
        
        NSArray *arrForFid = [model.fidStr componentsSeparatedByString:@","];
        BOOL isRemindSelf = NO;
        
        int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        
        //不等于0说明是别人给我的提醒
        if (model.isOther != 0 && model.isOther != userID) {
            
            isRemindSelf = YES;
        }
        
        //当没有设置提醒，走这个方法判断是否加提醒
        if (!isRemindSelf) {
            
            for (int j = 0; j < arrForFid.count; j++) {
                
                int Fid = [arrForFid[j] intValue];
                
                if (userID == Fid) {
                    
                    isRemindSelf = YES;
                }
            }
        }
        //根据重复类型添加提醒
        if (isRemindSelf) {
            [self addRemindNotificationsForiOS10WithModel:model];
        }
    }
    
    //分享的
    for (int i = 0; i < shareArr.count; i++) {
        
        RemindModel *model = shareArr[i];
        
        if (model.isOn == 0 || model.musicName == 0) {
            continue;
        }
        
        if (model.isOther != 0) {
            [self addRemindNotificationsForiOS10WithModel:model];
        }
    }
    
    //闹钟
    for (int i = 0; i < clockArr.count; i++) {
        
        ClockModel *model = clockArr[i];
        
        if (model.isOn == 1) {
            
            [self addAlarmNotificationsForiOS10WithClockModel:model];
        }
    }
    
    
}

//提醒
+ (void)addRemindNotificationsForiOS10WithModel:(RemindModel *)model
{
    if(model.randomType==0){//不重复提醒
        
        NSDate *remindDate = [self remindDateFromModel:model];
        //提醒时间未过期,添加
        if([remindDate compare:[NSDate date]] == NSOrderedDescending){
            [self addRemindNotificationNoRepeats:model];
        }
        
    }else if(model.randomType>=selectMonday && model.randomType<=selectSunday){//单周重复
        
        //NSDate *remindDate = [self remindDateFromModel:model];
        //提醒时间未过期,并且重复周里不包含提醒日期，需要为此日期单独添加一次非重复提醒
      /*  if([remindDate compare:[NSDate date]] == NSOrderedDescending){
            
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *remindDateComponents = [gregorian components:(NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday) fromDate:remindDate];
            
            NSInteger convertedWeek = [model.weekStr integerValue]+1;
            convertedWeek = convertedWeek>7?1:convertedWeek;
            
            if(convertedWeek != remindDateComponents.weekday){
                [self addRemindNotificationNoRepeats:model];
            }
        }*/
        
        //周重复
        [self addRemindNotificationForRepeats:model repeatsType:model.randomType];
        
    }else if(model.randomType==selectSomeDays){//多周重复(eg:每周二，周四) randomType==15
        NSArray *weekArr = [model.weekStr componentsSeparatedByString:@","];
        
//        NSDate *remindDate = [self remindDateFromModel:model];
        //提醒时间未过期,并且重复周里不包含提醒日期，需要为此日期单独添加一次非重复提醒
        /*if([remindDate compare:[NSDate date]] == NSOrderedDescending){
            
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *remindDateComponents = [gregorian components:(NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitWeekday) fromDate:remindDate];
            
            NSInteger convertedWeek = remindDateComponents.weekday-1;
            convertedWeek = convertedWeek<=0?7:convertedWeek;
            if(![weekArr containsObject:[NSString stringWithFormat:@"%ld",convertedWeek]]){
                [self addRemindNotificationNoRepeats:model];
            }
        }*/
        //周重复
        for(int i=0; i<[weekArr count]; i++){
            int week = [weekArr[i] intValue];
            [self addRemindNotificationForRepeats:model repeatsType:week];
            
        }
        
    }else if(model.randomType==selectEveryDay){//每日重复
        
        [self addRemindNotificationForRepeats:model repeatsType:selectEveryDay];
        
    }else if(model.randomType==selectEveryMonth){//每月重复
        
        [self addRemindNotificationForRepeats:model repeatsType:selectEveryMonth];
        
    }else if(model.randomType==selectEveryYear){//每年重复
        
        [self addRemindNotificationForRepeats:model repeatsType:selectEveryYear];
        
    }else {//自定义提醒
        NSDate *remindDate = [self remindDateFromModel:model];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

        NSDateComponents *diffDayComponents = [gregorian components:NSCalendarUnitDay fromDate:remindDate toDate:[NSDate date] options:0];
        NSDateComponents *diffMonthComponents = [gregorian components:NSCalendarUnitMonth fromDate:remindDate toDate:[NSDate date] options:0];
        NSDateComponents *diffYearComponents = [gregorian components:NSCalendarUnitYear fromDate:remindDate toDate:[NSDate date] options:0];
        
        if([remindDate compare:[NSDate date]]==NSOrderedDescending){//提醒日还未过,在提醒日添加单次提醒
            
            [self addRemindNotificationNoRepeats:model];
            
        }else{
            
            NSDate *nextTriggerDate = remindDate;
            
            if(model.randomType==selectDay){//自定义隔几天重复
                NSInteger modDayCount = diffDayComponents.day % model.countNumber;
                NSInteger diffDayCount = model.countNumber - modDayCount;
                NSInteger addDays = (diffDayComponents.day + diffDayCount);
                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                dayComponent.day = addDays;
                nextTriggerDate = [gregorian dateByAddingComponents:dayComponent toDate:remindDate options:0];
                
            }else if(model.randomType==selectWeek){//自定义隔几周重复
                
                NSInteger modDayCount = diffDayComponents.day % (model.countNumber * 7);
                NSInteger diffDayCount = (model.countNumber * 7) - modDayCount;
                NSInteger addDays = (diffDayComponents.day + diffDayCount);
                NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                dayComponent.day = addDays;
                nextTriggerDate = [gregorian dateByAddingComponents:dayComponent toDate:remindDate options:0];

            }else if(model.randomType==selectMonth){//自定义隔几月重复
                
                NSInteger modMonthCount = diffMonthComponents.month % model.countNumber;
                NSInteger diffMonthCount = model.countNumber - modMonthCount;
                NSInteger addMonths = (diffMonthComponents.month + diffMonthCount);
                NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
                monthComponent.month = addMonths;
                nextTriggerDate = [gregorian dateByAddingComponents:monthComponent toDate:remindDate options:0];
                
            }else if(model.randomType==selectYear){//自定义隔几年重复
                
                NSInteger modyearCount = diffYearComponents.year % model.countNumber;
                NSInteger diffYearCount = model.countNumber - modyearCount;
                NSInteger addYears = (diffYearComponents.year + diffYearCount);
                NSDateComponents *yearComponent = [[NSDateComponents alloc] init];
                yearComponent.year = addYears;
                nextTriggerDate = [gregorian dateByAddingComponents:yearComponent toDate:remindDate options:0];
            }
            NSDateComponents *remindDateComponents = [gregorian components:(NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:nextTriggerDate];
            [self addRemindNotificationCustom:model dateComponents:remindDateComponents];
        }
    }
}

//闹钟
+ (void)addAlarmNotificationsForiOS10WithClockModel:(ClockModel *)model
{
    
    if(model.week==nil||[model.week isEqualToString:@""]){//不重复提醒
        
        [self addAlarmNotificationNoRepeats:model];
        
    }else{//重复
        NSArray *weekArr = [model.week componentsSeparatedByString:@","];
        
        if(weekArr.count>0 && weekArr.count<7){//周重复
            for(NSString *week in weekArr){
                switch ([week integerValue]) {
                    case 0:
                        [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEveryMonday];
                        break;
                    case 1:
                        [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEveryTuesday];
                        break;
                    case 2:
                        [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEveryWednesday];
                        break;
                    case 3:
                        [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEveryThursday];
                        break;
                    case 4:
                        [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEveryFriday];
                        break;
                    case 5:
                        [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEverySaturday];
                        break;
                    case 6:
                        [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEverySunday];
                        break;
                    default:
                        break;
                }
            }
        }else if(weekArr.count==7){//每日重复
            [self addAlarmNotifications:model repeatsType:AlarmRepeatsTypeEveryDay];
        }
    }
}

+ (void)removeRemindNotificationWithModel:(RemindModel *)model
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    if(model.randomType==selectNoRepeats){//非重复提醒
        
        NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectNoRepeats];
        if(model.offsetMinute>0){
            NSString *beforeIdentifier = [identifier stringByAppendingString:@"_before"];
            [center removePendingNotificationRequestsWithIdentifiers:@[beforeIdentifier]];
        }
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        
    }else if(model.randomType>=selectMonday && model.randomType<=selectSunday){//单周重复
         NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectNoRepeats];
         NSString *identifier2 = [self generateIdentifierForRemind:model repeatType:model.randomType];
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier,identifier2]];
        
        if(model.offsetMinute>0){
            NSString *beforeIdentifier = [identifier stringByAppendingString:@"_before"];
            NSString *beforeIdentifier2 = [identifier2 stringByAppendingString:@"_before"];
            [center removePendingNotificationRequestsWithIdentifiers:@[beforeIdentifier,beforeIdentifier2]];
        }
        
    }else if(model.randomType==selectSomeDays){//多周重复(eg:每周二，周四) randomType==15
        NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectNoRepeats];
        NSMutableArray *muIdentifiers = [NSMutableArray arrayWithCapacity:8];
        [muIdentifiers addObject:identifier];
        NSArray *weekArr = [model.weekStr componentsSeparatedByString:@","];
        //周重复
        for(int i=0; i<[weekArr count]; i++){
            int week = [weekArr[i] intValue];
            NSString *tmpIdentifier = [self generateIdentifierForRemind:model repeatType:week];
            [muIdentifiers addObject:tmpIdentifier];
            if(model.offsetMinute>0){
                NSString *beforeIdentifier = [identifier stringByAppendingString:@"_before"];
                [muIdentifiers addObject:beforeIdentifier];
            }
        }
        [center removePendingNotificationRequestsWithIdentifiers:muIdentifiers];
        
    }else if(model.randomType==selectEveryDay){//每日重复
        
        NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectEveryDay];
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        if(model.offsetMinute>0){
            NSString *beforeIdentifier = [identifier stringByAppendingString:@"_before"];
            [center removePendingNotificationRequestsWithIdentifiers:@[beforeIdentifier]];
        }
        
    }else if(model.randomType==selectEveryMonth){//每月重复
        
        NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectEveryMonth];
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        if(model.offsetMinute>0){
            NSString *beforeIdentifier = [identifier stringByAppendingString:@"_before"];
            [center removePendingNotificationRequestsWithIdentifiers:@[beforeIdentifier]];
        }
    }else if(model.randomType==selectEveryYear){//每年重复
        
        NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectEveryYear];
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        if(model.offsetMinute>0){
            NSString *beforeIdentifier = [identifier stringByAppendingString:@"_before"];
            [center removePendingNotificationRequestsWithIdentifiers:@[beforeIdentifier]];
        }
        
    }else {
        if(model.randomType==selectDay||model.randomType==selectWeek||
           model.randomType==selectMonth||model.randomType==selectYear){
            
            //自定义隔几天/几周/几月/几年重复
            NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectNoRepeats];
            [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
            if(model.offsetMinute>0){
                NSString *beforeIdentifier = [identifier stringByAppendingString:@"_before"];
                [center removePendingNotificationRequestsWithIdentifiers:@[beforeIdentifier]];
            }
        }
    }
}
+ (void)removeAlarmNotificationWithModel:(ClockModel *)model
{
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    if(model.week==nil||[model.week isEqualToString:@""]){//不重复提醒

        NSString *identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeNone];
        [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        
    }else{//重复
        NSArray *weekArr = [model.week componentsSeparatedByString:@","];
        NSMutableArray *muIdentifierArr = [NSMutableArray array];

        if(weekArr.count>0 && weekArr.count<7){//周重复
            for(NSString *week in weekArr){
                NSString *identifier = @"";
                switch ([week integerValue]) {
                    case 0:
                        identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEveryMonday];
                        break;
                    case 1:
                        identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEveryTuesday];
                        break;
                    case 2:
                        identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEveryWednesday];
                        break;
                    case 3:
                        identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEveryThursday];
                        break;
                    case 4:
                        identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEveryFriday];
                        break;
                    case 5:
                        identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEverySaturday];
                        break;
                    case 6:
                        identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEverySunday];
                        break;
                    default:
                        break;
                }
                [muIdentifierArr addObject:identifier];
            }
            
            [center removePendingNotificationRequestsWithIdentifiers:muIdentifierArr];
            
        }else if(weekArr.count==7){//每日重复
            
            NSString *identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeEveryDay];
            [center removePendingNotificationRequestsWithIdentifiers:@[identifier]];
        }
    }
}
//添加本地提醒
+ (void)addNotificationWithIdentifier:(NSString *)identifier
                              trigger:(UNNotificationTrigger *)trigger
                              content:(UNMutableNotificationContent *)content
{
    //log next trigger date
 /*   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date;
    if([trigger isKindOfClass:[UNTimeIntervalNotificationTrigger class]]){
        date = ((UNTimeIntervalNotificationTrigger*)trigger).nextTriggerDate;
    }else if([trigger isKindOfClass:[UNCalendarNotificationTrigger class]]){
        date = ((UNCalendarNotificationTrigger*)trigger).nextTriggerDate;
    }
    NSLog(@"==========next TriggerDate：%@",[formatter stringFromDate:date]);
*/
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"添加提醒成功!");
        }
    }];
}

#pragma mark - 提醒相关
//单一提醒，不重复
+ (void)addRemindNotificationNoRepeats:(RemindModel *)model
{
    //提醒时间
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.calendar = cal;
    dateComponents.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.year = model.year;
    dateComponents.month = model.month;
    dateComponents.day = model.day;
    dateComponents.hour = model.hour;
    dateComponents.minute = model.minute;
    dateComponents.second = 0;
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
    //标识
    NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectNoRepeats];
    //内容
    UNMutableNotificationContent *content = [self generateContentForRemind:model];
    
    [self addNotificationWithIdentifier:identifier trigger:trigger content:content];
   

    //为提前响铃的提醒增加提醒
    if(model.offsetMinute>0){
        NSDate *date = [cal dateFromComponents:dateComponents];
        NSDateComponents *offsetComp = [[NSDateComponents alloc]init];
        offsetComp.minute = - model.offsetMinute;
        NSDate *remindDate = [cal dateByAddingComponents:offsetComp toDate:date options:0];
        dateComponents = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:remindDate];
        NSString *identifierBefore = [identifier stringByAppendingString:@"_before"];
        UNCalendarNotificationTrigger *triggerBefore = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
        [self addNotificationWithIdentifier:identifierBefore trigger:triggerBefore content:content];
    }
}

//单(日/周/月/年)重复提醒
+ (void)addRemindNotificationForRepeats:(RemindModel *)model repeatsType:(typeForRandom)type
{
    //提醒时间
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.calendar = cal;
    dateComponents.hour = model.hour;
    dateComponents.minute = model.minute;
    dateComponents.second = 0;
    //标识
    NSString *identifier = [self generateIdentifierForRemind:model repeatType:type];
    switch (type) {
        case selectEveryDay:{ //每日
            break;
        }
        case selectEveryMonth:{//每月
            dateComponents.day = model.day;
            break;
        }
        case selectEveryYear:{ //每年
            dateComponents.day = model.day;
            dateComponents.month = model.month;
            break;
        }
        case selectMonday:{//每周一
            dateComponents.weekday = 2;
            break;
        }
        case selectTuesday:{//每周二
            dateComponents.weekday = 3;
            break;
        }
        case selectWednesday:{//每周三
            dateComponents.weekday = 4;
            break;
        }
        case selectThursday:{//每周四
            dateComponents.weekday = 5;
            break;
        }
        case selectFriday:{//每周五
            dateComponents.weekday = 6;
            break;
        }
        case selectSaturday:{//每周六
            dateComponents.weekday = 7;
            break;
        }
        case selectSunday:{//每周日
            dateComponents.weekday = 1;
            break;
        }
        default:
            break;
    }
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];

    //内容
    UNMutableNotificationContent *content = [self generateContentForRemind:model];
    
    [self addNotificationWithIdentifier:identifier trigger:trigger content:content];
    
    
    //为提前响铃的提醒增加提醒
    if(model.offsetMinute>0){
        NSInteger hourOffset = model.offsetMinute / 60;
        NSInteger minOffset = model.offsetMinute % 60;
        BOOL shouldAddRemindForEveryMonth = YES;
        dateComponents.hour -= hourOffset;
        dateComponents.minute -= minOffset;
        if(dateComponents.minute<0){
            dateComponents.minute += 60;
            dateComponents.hour -= 1;
        }
        if(dateComponents.hour<0){
            dateComponents.hour += 24;
            
            switch (type) {
                case selectEveryDay:{ //每日
                    break;
                }
                case selectEveryMonth:{//每月
                    dateComponents.day -= 1;
                    if(dateComponents.day==0){
                        //上个月最后一天不定，这种情况不能确定准确的循环日期，只能每次重置提醒时单独添加一次提醒
                        shouldAddRemindForEveryMonth = NO;
                        
                        NSDateComponents *com = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:[NSDate date]];
                        if(com.month==1||com.month==3||com.month==5||com.month==7||com.month==8||com.month==10||com.month==12){
                            dateComponents.day = 31;
                        }else if(com.month==4||com.month==6||com.month==9||com.month==11){
                            dateComponents.day = 30;
                        }else if(com.month==2){
                            if ((com.year%4==0 && com.year%100!=0) || com.year%400==0) {
                                dateComponents.day = 29;
                            }else{
                                dateComponents.day = 28;
                            }
                        }
                        NSString *identifierBefore = [identifier stringByAppendingString:@"_before"];
                        UNCalendarNotificationTrigger *triggerBefore = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
                        [self addNotificationWithIdentifier:identifierBefore trigger:triggerBefore content:content];
                    }
                    break;
                }
                case selectEveryYear:{ //每年
                    dateComponents.day -= 1;
                    if(dateComponents.day==0){
                        
                        //取上一月的最后一天
                        if(model.month==2||model.month==4||model.month==6||model.month==8||model.month==9||model.month==11||model.month==1){
                            dateComponents.day = 31;
                        }else if(model.month==5||model.month==7||model.month==10||model.month==12){
                            dateComponents.day = 30;
                        }else if(model.month==3){
                            if ((model.year%4==0 && model.year%100!=0) || model.year%400==0) {
                                dateComponents.day = 29;
                            }else{
                                dateComponents.day = 28;
                            }
                        }
                        
                        dateComponents.month -= 1;
                        if(dateComponents.month==0){
                            dateComponents.month = 12;
                        }
                    }
                    break;
                }
                case selectMonday:
                case selectTuesday:
                case selectWednesday:
                case selectThursday:
                case selectFriday:
                case selectSaturday:
                case selectSunday:{
                    dateComponents.weekday -= 1;
                    if(dateComponents.weekday==0){
                        dateComponents.weekday = 7;
                    }
                    break;
                }
                default:
                    break;
            }
            
        }

        if(type!=selectEveryMonth||shouldAddRemindForEveryMonth){
            NSString *identifierBefore = [identifier stringByAppendingString:@"_before"];
            UNCalendarNotificationTrigger *triggerBefore = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];
            [self addNotificationWithIdentifier:identifierBefore trigger:triggerBefore content:content];
        }
    }

}
//单次自定义提醒
+ (void)addRemindNotificationCustom:(RemindModel *)model dateComponents:(NSDateComponents *)dateComponents
{
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
    //标识
    NSString *identifier = [self generateIdentifierForRemind:model repeatType:selectNoRepeats];
    //内容
    UNMutableNotificationContent *content = [self generateContentForRemind:model];
    
    [self addNotificationWithIdentifier:identifier trigger:trigger content:content];
    
    
    //为提前响铃的提醒增加提醒
    if(model.offsetMinute>0){
        NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        cal.timeZone = [NSTimeZone defaultTimeZone];
        NSDate *date = [cal dateFromComponents:dateComponents];
        NSDateComponents *offsetComp = [[NSDateComponents alloc]init];
        offsetComp.minute = - model.offsetMinute;
        NSDate *remindDate = [cal dateByAddingComponents:offsetComp toDate:date options:0];
        dateComponents = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:remindDate];
        NSString *identifierBefore = [identifier stringByAppendingString:@"_before"];
        UNCalendarNotificationTrigger *triggerBefore = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
        [self addNotificationWithIdentifier:identifierBefore trigger:triggerBefore content:content];
    }
}
//生成提醒标示
+ (NSString *)generateIdentifierForRemind:(RemindModel *)model repeatType:(typeForRandom)type
{
    NSString *identifier = @"";
    switch (type) {
        case selectNoRepeats:{//不重复
            identifier = [NSString stringWithFormat:@"%d_NoRepeats",model.uid];
            break;
        }case selectEveryDay:{ //每日
            identifier = [NSString stringWithFormat:@"%d_EveryDay",model.uid];
            break;
        }
        case selectEveryMonth:{//每月
            
            identifier = [NSString stringWithFormat:@"%d_EveryMonth",model.uid];
            break;
        }
        case selectEveryYear:{ //每年
            identifier = [NSString stringWithFormat:@"%d_EveryYear",model.uid];
            break;
        }
        case selectMonday:{//每周一
            identifier = [NSString stringWithFormat:@"%d_EveryMonday",model.uid];
            break;
        }
        case selectTuesday:{//每周二
            identifier = [NSString stringWithFormat:@"%d_EveryTuesday",model.uid];
            break;
        }
        case selectWednesday:{//每周三
            identifier = [NSString stringWithFormat:@"%d_EveryWednesday",model.uid];
            break;
        }
        case selectThursday:{//每周四
            identifier = [NSString stringWithFormat:@"%d_EveryThursday",model.uid];
            break;
        }
        case selectFriday:{//每周五
            identifier = [NSString stringWithFormat:@"%d_EveryFriday",model.uid];
            break;
        }
        case selectSaturday:{//每周六
            identifier = [NSString stringWithFormat:@"%d_EverySaturday",model.uid];
            break;
        }
        case selectSunday:{//每周日
            identifier = [NSString stringWithFormat:@"%d_EverySunday",model.uid];
            break;
        }
            
        default:
            break;
    }
    return identifier;
}
+ (UNMutableNotificationContent *)generateContentForRemind:(RemindModel *)model
{
    //提醒内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = model.title;
    content.body = model.content;
    
//    NSArray *musicArr = @[@"幻觉.m4a",@"科技.m4a",@"蓝调.m4a",@"女声.m4a",@"月光.m4a",@"别动.m4a",@"喂哎.m4a",@""];
    NSArray *musicArr = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3",@""];
    NSInteger musicIndex = model.musicName - 1;
    NSString *musicName = @"幻觉.m4a";
    if(musicIndex>=0 && musicIndex<[musicArr count]){
       musicName = musicArr[musicIndex];
    }

    content.sound = [UNNotificationSound soundNamed:musicName];
    //    content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    content.userInfo = @{kAlarmSoundNamaKey:musicName};
    
    return content;
}


+ (NSDate *)remindDateFromModel:(RemindModel *)model
{
    //提醒时间
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.calendar = cal;
    dateComponents.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.year = model.year;
    dateComponents.month = model.month;
    dateComponents.day = model.day;
    dateComponents.hour = model.hour;
    dateComponents.minute = model.minute;
    dateComponents.second = 0;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *remindDate = [gregorian dateFromComponents:dateComponents];

    return remindDate;
}

#pragma mark - 闹钟相关
//闹钟-不重复
+ (void)addAlarmNotificationNoRepeats:(ClockModel *)model
{
    //提醒时间
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.calendar = cal;
    dateComponents.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.year = model.year;
    dateComponents.month = model.month;
    dateComponents.day = model.day;
    dateComponents.hour = model.hour;
    dateComponents.minute = model.minute;
    dateComponents.second = 0;
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:NO];
   
    //标识
    NSString *identifier = [self generateIdentifierForAlarm:model repeatType:AlarmRepeatsTypeNone];
    //内容
    UNMutableNotificationContent *content = [self generateContentForAlarm:model];
    
    NSDate *remindDate = [self alarmDateFromModel:model];
    
    //提醒时间未过期,添加
    if([remindDate compare:[NSDate date]] == NSOrderedDescending){
        [self addNotificationWithIdentifier:identifier trigger:trigger content:content];
    }
}
//闹钟-重复
+ (void)addAlarmNotifications:(ClockModel *)model repeatsType:(AlarmRepeatsType)repeatsType
{
    
    //提醒时间
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    cal.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.timeZone = [NSTimeZone defaultTimeZone];
    dateComponents.calendar = cal;
    dateComponents.hour = model.hour;
    dateComponents.minute = model.minute;
    dateComponents.second = 0;
    
    //标识
    NSString *identifier = [self generateIdentifierForAlarm:model repeatType:repeatsType];
    //内容
    UNMutableNotificationContent *content = [self generateContentForAlarm:model];
    
    switch (repeatsType) {
        case AlarmRepeatsTypeEveryMonday:{//每周一
            dateComponents.weekday = 2;
        }
            break;
        case AlarmRepeatsTypeEveryTuesday:{//每周二
            
            dateComponents.weekday = 3;
        }
            break;
        case AlarmRepeatsTypeEveryWednesday:{//每周三
            
            dateComponents.weekday = 4;
        }
            break;
        case AlarmRepeatsTypeEveryThursday:{//每周四
            
            dateComponents.weekday = 5;
        }
            break;
        case AlarmRepeatsTypeEveryFriday:{//每周五
           
            dateComponents.weekday = 6;
        }
            break;
        case AlarmRepeatsTypeEverySaturday:{//每周六
            
            dateComponents.weekday = 7;
        }
            break;
        case AlarmRepeatsTypeEverySunday:{//每周日
            
            dateComponents.weekday = 1;
        }
            break;
        case AlarmRepeatsTypeEveryDay:{//每日
            //不设值
        }
            break;
        default:
            break;
    }
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateComponents repeats:YES];
    [self addNotificationWithIdentifier:identifier trigger:trigger content:content];
}

+ (NSString *)generateIdentifierForAlarm:(ClockModel *)model repeatType:(AlarmRepeatsType)repeatsType
{
    NSString *identifier = @"";
    
    switch (repeatsType) {
        case AlarmRepeatsTypeNone:
            identifier = [NSString stringWithFormat:@"%@_NoRepeats",model.timeOrder];
            break;
        case AlarmRepeatsTypeEveryMonday:
            identifier = [NSString stringWithFormat:@"%@_EveryMonday",model.timeOrder];
            break;
        case AlarmRepeatsTypeEveryTuesday:
            identifier = [NSString stringWithFormat:@"%@_EveryTuesday",model.timeOrder];
            break;
        case AlarmRepeatsTypeEveryWednesday:
            identifier = [NSString stringWithFormat:@"%@_EveryWednesday",model.timeOrder];
            break;
        case AlarmRepeatsTypeEveryThursday:
            identifier = [NSString stringWithFormat:@"%@_EveryThursday",model.timeOrder];
            break;
        case AlarmRepeatsTypeEveryFriday:
            identifier = [NSString stringWithFormat:@"%@_EveryFriday",model.timeOrder];
            break;
        case AlarmRepeatsTypeEverySaturday:
            identifier = [NSString stringWithFormat:@"%@_EverySaturday",model.timeOrder];
            break;
        case AlarmRepeatsTypeEverySunday:
            identifier = [NSString stringWithFormat:@"%@_EverySunday",model.timeOrder];
            break;
        case AlarmRepeatsTypeEveryDay:
            identifier = [NSString stringWithFormat:@"%@_EveryDay",model.timeOrder];
            break;
        default:
            break;
    }
    
    return identifier;
}


+ (UNMutableNotificationContent *)generateContentForAlarm:(ClockModel *)model
{
    //提醒内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"";
    content.body = model.textStr;
    NSArray *arrForMusic = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3"];
    NSInteger musicIndex = model.musicID - 1;
    NSString *musicName = @"幻觉-长.mp3";
    if(musicIndex>=0 && musicIndex<[arrForMusic count]){
        musicName = arrForMusic[musicIndex];
    }
    content.sound = [UNNotificationSound soundNamed:musicName];
    //    content.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);
    content.userInfo = @{kAlarmSoundNamaKey:musicName};
    
    return content;
}

+ (NSDate *)alarmDateFromModel:(ClockModel *)model
{
    //提醒时间
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = model.year;
    dateComponents.month = model.month;
    dateComponents.day = model.day;
    dateComponents.hour = model.hour;
    dateComponents.minute = model.minute;
    dateComponents.second = 0;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *remindDate = [gregorian dateFromComponents:dateComponents];
    
    return remindDate;
}

#endif
@end
