//
//  JYListDataManager.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYListDataManager.h"
static JYListDataManager *manager = nil;
@implementation JYListDataManager

{
    LocalListManager *_sendManager;
    IncidentListManager *_acceptManager;
    JYShareList *_shareManager;
    JYSystemList *_systemManager;
}

+ (JYListDataManager *)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[JYListDataManager alloc] init];
        }
    });
    
    return manager;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    
    return manager;
}

- (void)addNotification
{
    
    _systemManager = [JYSystemList shareList];
    _sendManager = [LocalListManager shareLocalListManager];
    _acceptManager = [IncidentListManager shareIncidentManager];
    _shareManager = [JYShareList shareList];
    
    _systemRemind = [_systemManager selectAllModelWithStr:@""];//普通4个列表
    _sendRemind = [_sendManager searchLocalDataWithText:@""];
    _acceptRemind = [_acceptManager searchWithStr:@""];
    _shareRemind = [_shareManager searchWithStr:@""];
    
    NSDictionary *dic = [_sendManager searchAllDataWithTextNotYet:@""];//今天列表
    
    NSArray *today = [self sequence:dic[@"today"]];
    NSArray *notYet = [self sequenceNotYet:dic[@"after"]];
    
    _dataDic = @{@"today":today,@"after":notYet};
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upData) name:kNotificationForUpDate object:nil];
    
}

- (NSInteger )componentsWithModel:(RemindModel *)model
{
    NSDateComponents *com = [[NSDateComponents alloc] init];
    [com setYear:model.year_random];
    [com setMonth:model.month_random];
    [com setDay:model.day_random];
    [com setHour:model.hour];
    [com setMinute:model.minute];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *date = [calendar dateFromComponents:com];
    NSInteger times = [date timeIntervalSinceDate:[NSDate date]]*1;
    
    return times;
}

- (NSArray *)sequenceNotYet:(NSArray *)arr
{
    NSMutableArray *arrForNotYet = [NSMutableArray arrayWithArray:arr];
    
    for (int i = 0 ; i < arrForNotYet.count; i ++ ) {
        //排序<重复提醒排序问题>
        for (int j = 0; j < arrForNotYet.count - i-1; j++) {
            
            RemindModel *model1 = arrForNotYet[j];
            RemindModel *model2 = arrForNotYet[j+1];
            
            NSInteger time1 = [self componentsWithModel:model1];
            NSInteger time2 = [self componentsWithModel:model2];
            
            if (time1 > time2) {
                
                [arrForNotYet exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
    return arrForNotYet;
}

- (NSArray *)sequence:(NSArray *)arr
{
    NSMutableArray *arrForToday = [NSMutableArray arrayWithArray:arr];
    
    for (int i = 0 ; i < arrForToday.count; i ++ ) {
        
        //排序<重复提醒排序问题>
        
        for (int j = 0; j < arrForToday.count - i-1; j++) {
            
            RemindModel *model1 = arrForToday[j];
            RemindModel *model2 = arrForToday[j+1];
            
            int time1 = model1.hour * 60 + model1.minute;
            int time2 = model2.hour * 60 + model2.minute;
            
            if (time1 > time2) {
                
                [arrForToday exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
            
        }
    }
    
    return arrForToday;
}

//数据更新
- (void)upData
{
    _systemRemind = [_systemManager selectAllModelWithStr:@""];//普通4个列表
    _sendRemind = [_sendManager searchLocalDataWithText:@""];
    _acceptRemind = [_acceptManager searchWithStr:@""];
    _shareRemind = [_shareManager searchWithStr:@""];
    
    NSDictionary *dic = [_sendManager searchAllDataWithTextNotYet:@""];//今天列表
    
    NSArray *today = [self sequence:dic[@"today"]];
    NSArray *notYet = [self sequenceNotYet:dic[@"after"]];
    
    _dataDic = @{@"today":today,@"after":notYet};

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForManagerUpDate object:nil];
    
    //避免删除通知还提醒的情况
    //[Tool actionForAddNotification];
}

- (NSArray *)systemData:(NSString *)text
{
    if (_systemRemind.count == 0) {
        _systemRemind = [_systemManager selectAllModelWithStr:@""];
    }
    
    return _systemRemind;
}

- (NSArray *)acceptData:(NSString *)text
{
    
    return [_acceptManager searchWithStr:text];
;
}

- (NSArray *)shareData:(NSString *)text
{
    
    return [_shareManager searchWithStr:text];

}

- (NSArray *)sendData:(NSString *)text
{

    return  [_sendManager searchLocalDataWithText:text];

}

- (NSDictionary *)todayData:(NSString *)text
{
   
    return [_sendManager searchAllDataWithTextNotYet:text];
}

@end
