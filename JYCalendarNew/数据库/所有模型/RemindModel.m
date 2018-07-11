//
//  RemindModel.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/16.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "RemindModel.h"
#import "JYSystemTitleVC.h"
#import "JYRemindNoPassPeopleVC.h"
#import "JYRemindOtherVC.h"
#import "AppHelper.h"

@implementation RemindModel

- (instancetype)copyWithZone:(NSZone *)zone
{
    RemindModel *model = [[RemindModel alloc] init];
   
    model.year = self.year;
    model.month = self.month;
    model.day = self.day;
    
    return model;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}

-(void)setValue:(id)value forKey:(NSString *)key
{
    
    if ([key isEqualToString:@"files"]) {
        
        self.files = [NSMutableArray arrayWithArray:value];
        
    }
    [super setValue:value forKey:key];
}


+ (void)deleteWithModel:(RemindModel *)model
{
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    [JYRemindManager cancelNotificationWithModel:model];
    
    if (model.uid == 0) {
        
        LocalListManager *manager = [LocalListManager shareLocalListManager];
        [manager deleteDataWithUid:model.oid];
        [manager deleteLocalAudioFileWithPathStr:model.audioPathStr];
        
        
    }else if(model.uid != 0 && model.isShare == 1){
        
        JYShareList *manager = [JYShareList shareList];
        [manager deleteActionWithModel:model];
        
        if (model.isOther == 0) {
            NSString *uid = [NSString stringWithFormat:@"%d",model.sid];
            [RequestManager actionForDeleteShareRemindWithUidStr:uid andAcceptUid:@"" modelArr:@[model]];
            
        }else {
            
            NSString *uid = [NSString stringWithFormat:@"%d",model.sid];
            [RequestManager actionForDeleteShareRemindWithUidStr:@"" andAcceptUid:uid modelArr:@[model]];
        }
        
    }else if (model.uid != 0 && model.isShare != 1){
        
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        [manager deleteDataWithUid:model.uid ownId:0 existUid:model.uid];
        if (model.isOther == 0) {
            
            NSString *uid = [NSString stringWithFormat:@"%d",model.uid];
            [RequestManager actionForDeleteMotherIncident:uid isChangeMainView:NO];
            
        }else {
            
            NSString *uid = [NSString stringWithFormat:@"%d",model.uid];
            [RequestManager actionForDeleteAccept:uid isChangeMainView:NO];
            
        }
        
    }
}


+ (void)collectionWithModel:(RemindModel *)model
{
    if ([model.weekStr isEqualToString:@"100"]||[model.weekStr isEqualToString:@"101"]) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"系统消息不能收藏！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alter show];
        
        return ;
    }
    
    if (model.isSave != 0) {
        
        
        return;
    }
    
    [SVProgressHUD showWithStatus:@"收藏中..."];
    
    if (model.uid == 0) {
        
        [RequestManager actionForCollectionForLocal:model completedBlock:^(NSString *mid) {
            
            [RequestManager saveRemindWithId:[mid integerValue] shareId:0 completedBlock:^(id data, NSError *error) {
                
                
                IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
                model.isSave = 1;
                model.uid = [mid intValue];
                [incManager upDataWithModel:model];
              
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
            }];
        }];
   
    }else {
        
        if (model.isShare == 1) {
       
            [RequestManager saveRemindWithId:0 shareId:model.sid  completedBlock:^(id data, NSError *error) {
                //NSLog(@"收藏成功");
                
                JYShareList *shareManager = [JYShareList shareList];
                model.isSave = 1;
                [shareManager upDataWithModel:model];
               
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
            }];
            
        }else{
            
            [RequestManager saveRemindWithId:model.uid shareId:0 completedBlock:^(id data, NSError *error) {
                //NSLog(@"收藏成功");
             
                IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
                model.isSave = 1;
                [incManager upDataWithModel:model];
          
                [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForUpDate object:nil];
            }];
        }
    }
}


+ (UIViewController *)pushModel:(RemindModel *)model
                       delegate:(id )vc
{
    //说明是分享的
    if (model.isLook == 1 && model.isShare == 1) {
        
        model.isLook = 0;
        JYShareList *shareList = [JYShareList shareList];
        
        [shareList upDataWithModel:model];
        
        //更新服务器事件状态
        [RequestManager actionForEditShareList:model];
   
    }
    //说明是接收事件（不是系统事件）
    else if(model.isLook == 1 && model.isOther != 0 && ![model.weekStr isEqualToString: @"100"]){
        
        model.isLook = 0;
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        [manager upDataWithModel:model];
        
        NSString *midStr = [NSString stringWithFormat:@"%d",model.uid];
        [RequestManager actionForIsHaveLook:midStr];
        
    }else if(model.isLook == 1){
        
        model.isLook = 0;
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        [manager upDataWithModel:model];
        
        NSString *midStr = [NSString stringWithFormat:@"%d",model.uid];
        [RequestManager actionForIsHaveLook:midStr];
    }
    
    //系统消息
    if ([model.weekStr isEqualToString:@"100"] || [model.weekStr isEqualToString:@"101"]) {
        
        JYSystemTitleVC *systemVC = [[JYSystemTitleVC alloc] init];
        systemVC.model = model;

        systemVC.hidesBottomBarWhenPushed = YES;
        
        return systemVC;
    }
    
    //本地消息
    if (([model.fidStr isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]] || [model.fidStr isEqualToString:@""]) && model.isOther == 0 && [model.gidStr isEqualToString:@""]) {
        
        JYRemindViewController *localRemind = [[JYRemindViewController alloc] init];
        localRemind.isCreate = NO;
        model.isOther = 0;
        model.fidStr = @"";
        model.gidStr = @"";
        model.upData = YES;
        model.strForRepeat = [Tool actionForReturnRepeatStr:model];
        localRemind.model = model;
        localRemind.delegate = vc;
        localRemind.longitudeStr = model.longitudeStr;
        localRemind.latitudeStr = model.latitudeStr;
        
        localRemind.hidesBottomBarWhenPushed = YES;
        return localRemind;
    }
    
    
    //别人发送给我的
    if (model.isOther != 0) {
        
        JYRemindNoPassPeopleVC *jyremindNop = [[JYRemindNoPassPeopleVC alloc] init];
        jyremindNop.model = model;
        model.upData = YES;
        jyremindNop.hidesBottomBarWhenPushed = YES;
        
        
        return jyremindNop;
    }
    
    
    //我发送给别人的
    if (model.isOther == 0) {
        
        if ([model.fidStr isEqualToString:@""] && [model.gidStr isEqualToString:@""]) {
            model.fidStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        }
        JYRemindOtherVC *sendVC = [[JYRemindOtherVC alloc] init];
        model.upData = YES;
        sendVC.model = model;
        sendVC.hidesBottomBarWhenPushed = YES;
        
        
        return sendVC;
    }
    
    return nil;

}


+ (void)deleteMoreModel:(NSArray *)data
{
    [SVProgressHUD showWithStatus:@"删除中..."];
    
    //别人给我发的
    NSMutableString *acceptIdStr = [NSMutableString string];
    //我给别人发的
    NSMutableString *sendIdStr = [NSMutableString string];
    
    //分享我给别人和别人给我的
    NSMutableString *sSendStr = [NSMutableString string];
    NSMutableString *aScceptStr = [NSMutableString string];
    
    
    IncidentListManager *serverManager = [IncidentListManager shareIncidentManager];
    LocalListManager    *localManager = [LocalListManager shareLocalListManager];
    JYShareList *shareList = [JYShareList shareList];
    
  
    
    for (int i = 0; i < data.count; i++) {
        
        RemindModel *model = data[i];
        
        [JYRemindManager cancelNotificationWithModel:model];

        //我给别人发的
        if (model.isOther == 0 && model.uid != 0 && model.isShare != 1) {
            
            [serverManager deleteDataWithUid:model.uid ownId:0 existUid:model.uid];
            
            NSString *midStr = [NSString stringWithFormat:@"%d,",model.uid];
            [sendIdStr appendString:midStr];
            
            
            //本地的
        }else if(model.isOther == 0 && model.uid == 0 && model.isShare != 1){
            
            [localManager deleteDataWithUid:model.oid];
            [localManager deleteLocalAudioFileWithPathStr:model.audioPathStr];
            //别人发给我的
        }else if(model.isShare != 1){
            
            //[serverManager deleteDataWithUid:model.uid ownId:0 existUid:model.uid];
            NSString *midStr = [NSString stringWithFormat:@"%d,",model.uid];
            [acceptIdStr appendString:midStr];
            
        }
        
        
        NSString *uid = [NSString stringWithFormat:@"%d,",model.sid];
        
        if (model.isOther == 0 && model.isShare == 1) {
            
            [sSendStr appendString:uid];
            
        }else{
            
            [aScceptStr appendString:uid];
            
        }
        
        [shareList deleteActionWithModel:model];
        
    }
    
    
    
    //同步后台(别人发给我的)
    if (acceptIdStr.length > 0) {
        
        NSString *passMidStr = [acceptIdStr substringWithRange:NSMakeRange(0, acceptIdStr.length - 1)];
        
        [RequestManager actionForDeleteAccept:passMidStr isChangeMainView:NO];
        
    }
    
    //同步后台(我发给别人的)
    if (sendIdStr.length > 0) {
        
        NSInteger len = sendIdStr.length;
        
        NSString *passMidStr = [sendIdStr substringWithRange:NSMakeRange(0, len - 1)];
        
        [RequestManager actionForDeleteMotherIncident:passMidStr isChangeMainView:NO];
    }
    
    
    NSString *sendUid = @"";
    NSString *acceptUid = @"";
    if (sSendStr.length > 0) {
        
        sendUid = [sSendStr substringWithRange:NSMakeRange(0, sSendStr.length - 1)];
    }
    
    if (aScceptStr.length > 0) {
        
        acceptUid = [aScceptStr substringWithRange:NSMakeRange(0, aScceptStr.length - 1)];
    }
    
    [RequestManager actionForDeleteShareRemindWithUidStr:sendUid andAcceptUid:acceptUid modelArr:data];
    
    
   
}


+ (void)topAction:(NSMutableArray *)data
{
    
    [SVProgressHUD showWithStatus:@"置顶中..."];
    
    NSInteger arrCount = data.count;
    for (int i = 0; i < arrCount; i++) {
        
        for (int j = 0; j < arrCount - i; j++) {
            
            if (j+1 < arrCount) {
                
                RemindModel *firstModel = data[j];
                RemindModel *secondModel = data[j+1];
                
                if (firstModel.index > secondModel.index) {
                    
                    [data exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                }
            }
            
        }
        
    }
    
    NSInteger time = 0;
    for (int i = 0; i < arrCount; i++) {
        
        RemindModel *model = data[i];
        
        model.isTop = [RemindModel topTime:time];
        time ++;
        
        //NSLog(@"%@",model.isTop);
    }
    
    LocalListManager *locManager = [LocalListManager shareLocalListManager];
    IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
    JYShareList *shareList = [JYShareList shareList];
    NSMutableString *mAStr = [NSMutableString string];
    NSMutableString *mSStr = [NSMutableString string];
    NSMutableString *sAStr = [NSMutableString string];
    NSMutableString *sSStr = [NSMutableString string];
    NSMutableString *isTopStr = [NSMutableString string];
    
    //本地
    for (int i = 0; i < arrCount; i++) {
        RemindModel *model = data[i];
        if (model.uid == 0) {
            
            [locManager upDataWithModel:model];
        }
    }
    
    //接收
    for (int i = 0; i < arrCount; i ++) {
        
        RemindModel *model = data[i];
        if(model.isOther != 0 && model.isShare != 1 && model.uid != 0){
            
            [incManager upDataWithModel:model];
            [mAStr appendFormat:@"%d,",model.uid];
            [isTopStr appendFormat:@"%@,",model.isTop];
        }
    }
    
    //发送
    for (int i = 0; i < arrCount; i++) {
        RemindModel *model = data[i];
        if(model.isOther == 0 && model.isShare != 1 && model.uid != 0){
            
            [incManager upDataWithModel:model];
            [mSStr appendFormat:@"%d,",model.uid];
            [isTopStr appendFormat:@"%@,",model.isTop];
        }
        
    }
    
    //接收共享
    for (int i = 0; i < arrCount; i++) {
        RemindModel *model = data[i];
        if(model.isOther != 0 && model.isShare == 1 && model.uid != 0){
            
            [shareList upDataWithModel:model];
            [sAStr appendFormat:@"%d,",model.sid];
            [isTopStr appendFormat:@"%@,",model.isTop];
            
        }
    }
    
    //发送共享
    for (int i = 0; i < arrCount; i++) {
        RemindModel *model = data[i];
        if (model.isOther == 0 && model.isShare == 1 && model.uid != 0) {
            
            [shareList upDataWithModel:model];
            [sSStr appendFormat:@"%d,",model.sid];
            [isTopStr appendFormat:@"%@,",model.isTop];
            
        }
    }
    
    
    /*
     for (int i = 0; i < _listTb.arrForSelectCell.count; i ++) {
     
     
     RemindModel *model = _listTb.arrForSelectCell[i];
     
     
     if (model.uid == 0) {
     
     model.isTop = [self topTime:time];
     [locManager upDataWithModel:model];
     
     }else{
     
     //我分享给他人的
     if (model.isOther == 0 && model.isShare == 1) {
     
     model.isTop = [self topTime:time];
     [shareList upDataWithModel:model];
     
     [sSStr appendFormat:@"%d,",model.sid];
     
     //别人分享给我的
     }else if(model.isOther != 0 && model.isShare == 1){
     
     model.isTop = [self topTime:time];
     [shareList upDataWithModel:model];
     [sAStr appendFormat:@"%d,",model.sid];
     
     
     //我发送给别人的
     }else if(model.isOther == 0 && model.isShare != 1){
     
     model.isTop = [self topTime:time];
     [incManager upDataWithModel:model];
     [mSStr appendFormat:@"%d,",model.uid];
     
     
     }else{
     
     model.isTop = [self topTime:time];
     [incManager upDataWithModel:model];
     [mAStr appendFormat:@"%d,",model.uid];
     
     }
     
     }
     [isTopStr appendFormat:@"%@,",model.isTop];
     
     time++;
     }
     */
    
    
    NSString *rmidStr = @"";
    if (mAStr.length > 0) {
        
        rmidStr = [mAStr substringWithRange:NSMakeRange(0, mAStr.length - 1)];
        
    }
    
    NSString *smidStr = @"";
    if (mSStr.length > 0) {
        
        smidStr = [mSStr substringWithRange:NSMakeRange(0, mSStr.length - 1)];
        
    }
    
    NSString *rsidStr = @"";
    if (sAStr.length > 0) {
        
        rsidStr = [sAStr substringWithRange:NSMakeRange(0, sAStr.length - 1)];
    }
    
    NSString *ssidStr = @"";
    if (sSStr.length > 0) {
        
        ssidStr = [sSStr substringWithRange:NSMakeRange(0, sSStr.length - 1)];
    }
    
    NSString *isTop = @"";
    if (isTopStr.length > 0) {
        
        isTop = [isTopStr substringWithRange:NSMakeRange(0, isTopStr.length - 1)];
    }
    
    [RequestManager actionForTopWithRmidStr:rmidStr andSmidStr:smidStr andRsidStr:rsidStr andSsidStr:ssidStr isTop:isTop];
    


}


+ (NSString *)topTime:(NSInteger )time
{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    NSInteger topTime =[[formatter stringFromDate:date] integerValue];
    topTime -= time;
    
    return [NSString stringWithFormat:@"%ld",topTime];
}


+ (void)shareWithFriendArr:(NSArray *)arrForF
                  groupArr:(NSArray *)arrForG
                     model:(NSArray <RemindModel *>*)data
                   headStr:(NSString *)headStr
{
 
    [SVProgressHUD showWithStatus:@"共享中..."];

    
        NSMutableString *midStr = [NSMutableString string];
        NSMutableString *ringIdStr = [NSMutableString string];
        NSMutableString *fidStr = [NSMutableString string];
        NSMutableString *gidStr = [NSMutableString string];
        
        
        for (int i = 0; i < arrForF.count; i ++) {
            
            FriendModel *model = arrForF[i];
            
            NSString *fidS = [NSString stringWithFormat:@"%ld,",model.fid];
            
            [fidStr appendString:fidS];
            
        }
        
        for (int i = 0; i < arrForG.count ; i++) {
            
            GroupModel *model = arrForG[i];
            
            NSString *gidS = [NSString stringWithFormat:@"%d,",model.gid];
            
            [gidStr appendString:gidS];
            
        }
        
        //上传的fid拼串
        NSString *fid = @"";
        if (fidStr.length > 0) {
            
            fid = [fidStr substringWithRange:NSMakeRange(0, fidStr.length  - 1)];
        }
        
        //上传的gid拼串
        NSString *gid = @"";
        if (gidStr.length > 0) {
            
            
            gid = [gidStr substringWithRange:NSMakeRange(0, gidStr.length - 1)];
            
        }
        
        
        //NSString *urlHeadStr = [headStr substringWithRange:NSMakeRange(0, headStr.length - 1)];

        NSMutableArray *arrForModel = [NSMutableArray array];
        for (int i = 0; i < data.count; i++) {
            
            RemindModel *model = data[i];
            //model.headUrlStr = urlHeadStr;
            
            if ([model.weekStr isEqualToString:@"100"] || [model.weekStr isEqualToString:@"101"]) {
                
                //系统消息不能分享
                
                continue;
            }
            
            if (model.uid == 0) {
                
                
                NSString *musicID = [NSString stringWithFormat:@"%d",model.musicName];
                
                //本地事件先要同步给后台在分享
                [RequestManager actionForShareRemindWithLocalModel:model andUidStr:nil ringID:musicID fidStr:fid gidStr:gid];
                
            }else{
                
                NSString *mids = [NSString stringWithFormat:@"%d,",model.uid];
                
                [midStr appendString:mids];
                
                
                NSString *rings = [NSString stringWithFormat:@"%d,",model.musicName];
                
                [ringIdStr appendString:rings];
                
                [arrForModel addObject:model];
            }
            
            
        }
        
        NSString *mid = @"";
        if (midStr.length > 0) {
            
            mid = [midStr substringWithRange:NSMakeRange(0, midStr.length - 1)];
        }
        
        NSString *ringId = @"";
        if (ringIdStr.length > 0) {
            
            ringId = [ringIdStr substringWithRange:NSMakeRange(0, ringIdStr.length - 1)];
        }
        
        if (midStr.length > 0) {
            
            //分享
            [RequestManager actionForSendShareRemindWithUidStr:mid rindId:ringId fidStr:fid gidStr:gid andModelArr:arrForModel comBlock:^(id data, NSError *error) {
                
                
                if ([[data objectForKey:@"flag"]isEqualToString:@"succ"]) {
                    
                    [SVProgressHUD showSuccessWithStatus:@"共享成功！"];
                    [SVProgressHUD dismissWithDelay:0.5];
                    
                }else{
                 
                    [SVProgressHUD showErrorWithStatus:@"网络异常,共享失败！"];
                    [SVProgressHUD dismissWithDelay:0.5];

                }
            }];
        }
    
}


- (void)setSystemTime
{
    NSDateComponents *utcCom = [[NSDateComponents alloc] init];
    [utcCom setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
    utcCom.year = _year;
    utcCom.month = _month;
    utcCom.day = _day;
    utcCom.hour = _hour;
    utcCom.minute = _minute;
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *selectDate = [gregorian dateFromComponents:utcCom];
    
    
    
    NSDateComponents *localCom = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:selectDate];
    
    _year = (int)localCom.year;
    _month = (int)localCom.month;
    _day = (int)localCom.day;
    _hour = (int)localCom.hour;
    _minute = (int)localCom.minute;
    _timeorder = [NSString stringWithFormat:@"%d%02d%02d%02d%02d",_year,_month,_day,_hour,_minute];
    
    //2003 10 25 21 13
    int create_year = [[_createTime substringWithRange:NSMakeRange(0, 4)]intValue];
    int create_month = [[_createTime substringWithRange:NSMakeRange(4, 2)] intValue];
    int create_day  = [[_createTime substringWithRange:NSMakeRange(6, 2)] intValue];
    int create_hour = [[_createTime substringWithRange:NSMakeRange(8, 2)]intValue];
    int create_minute = [[_createTime substringWithRange:NSMakeRange(10, 2)]intValue];
    
    NSDateComponents *com2 = [[NSDateComponents alloc] init];
    [com2 setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8 * 3600]];
    com2.year = create_year;
    com2.month = create_month;
    com2.day = create_day;
    com2.hour = create_hour;
    com2.minute = create_minute;
    
    NSCalendar *gregorian2 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian2 setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *selectDate2 = [gregorian2 dateFromComponents:com2];
    
    NSDateComponents *dateCom2 = [gregorian2 components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:selectDate2];
    
    _createTime = [NSString stringWithFormat:@"%ld%02ld%02ld%02ld%02ld",(long)dateCom2.year,(long)dateCom2.month,(long)dateCom2.day,(long)dateCom2.hour,(long)dateCom2.minute];
    
    //重复问题
    if (![_weekStr isEqualToString:@""] && ![_weekStr isEqualToString:@"100"] && _weekStr && ![_weekStr isEqualToString:@"101"]) {
       
        NSArray *weeks = [_weekStr componentsSeparatedByString:@","];
        
        NSMutableString *localWeekStr = [NSMutableString string];
        
        
        if (utcCom.day > localCom.day) {
            
            for (int i = 0; i < weeks.count; i++) {
                
                int number = [weeks[i]intValue] - 1;
                if (number < 1) {
                    number = 7;
                }
                
                if (i != weeks.count - 1) {
                    [localWeekStr appendFormat:@"%d,",number];
                }else{
                    [localWeekStr appendFormat:@"%d",number];
                }
                
            }
            
        }else if(utcCom.day < localCom.day){
        
            for (int i = 0; i < weeks.count; i++) {
                
                int number = [weeks[i]intValue] + 1;
                if (number > 7) {
                    number = 1;
                }
                
                if (i != weeks.count - 1) {
                    [localWeekStr appendFormat:@"%d,",number];
                }else{
                    [localWeekStr appendFormat:@"%d",number];
                }
                
            }
            
        }else{
          
            [localWeekStr appendString:_weekStr];
        }
        
        _weekStr = localWeekStr;
        
    }else if(_randomType >= 1 && _randomType <= 7){
    
        
        if (utcCom.day > localCom.day) {
            
            _randomType --;
            if (_randomType <= 0) {
                _randomType = 7;
            }
            
        }else if(utcCom.day < localCom.day){
            
            _randomType ++;
            if (_randomType > 7) {
                _randomType = 1;
            }
            
        }else{
            
            
        }
    }
    
    
    
}



@end
