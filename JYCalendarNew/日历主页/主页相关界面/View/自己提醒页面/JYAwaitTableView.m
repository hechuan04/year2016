//
//  JYAwaitTableView.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYAwaitTableView.h"
#import "JYAwaitTableViewCell.h"
#import "JYRemindView.h"

static NSString *strForAlreadyCell = @"strForAlreadyCell";

@implementation JYAwaitTableView
{
   
    UIWindow *__sheetWindow;
    
}

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                   andWaitArr:(NSArray *)arrForWait
{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
        //[self loadData:0 month:0 day:0];
        [self registerNib:[UINib nibWithNibName:@"JYAwaitTableViewCell" bundle:nil] forCellReuseIdentifier:strForAlreadyCell];
        
    }
    
    
    return self;
}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{        
        return _arrForWait.count;
  
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 60;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYAwaitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strForAlreadyCell];
    if (!cell) {
        
        cell = [[JYAwaitTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForAlreadyCell];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.selectImage.hidden = YES;
    
    if (_arrForWait.count > 0) {
        
        RemindModel *model = _arrForWait[indexPath.row];
        
        
        
        cell.timeAndCount.text = [NSString stringWithFormat:@"%@",model.title];
        

        //判断是否显示重复时间
//        if (model.randomType != 0) {
//            
//            cell.everyDayLabel.hidden = NO;
//  
//        }else{
//            
//            cell.everyDayLabel.hidden = YES;
//        }
        
        NSString *timeStr = [Tool actionForListTimeZhuStr:model.createTime year:_year month:_month day:_day isAccept:NO];
        
        //判断是否显示他人发送图标
        if (![model.gidStr isEqualToString:@""] || ![model.fidStr isEqualToString:@""]) {
            
            cell.otherClock.hidden = NO;
            cell.timeLabel.text = timeStr;
            
        }else{
         
            cell.otherClock.hidden = YES;
            NSString *timeStrLocal1 = [timeStr substringWithRange:NSMakeRange(3, timeStr.length - 3)];
            NSString *timeStrLocal2 = [NSString stringWithFormat:@"创建于%@",timeStrLocal1];
            cell.timeLabel.text = timeStrLocal2;
        }
      
      
        
        //判断是否显示闹钟(1)
        if (model.isOn) {
            
            cell.clockImage.hidden = NO;
            
            //判断提醒他人情况下是否显示闹钟(2)①
            if (![model.fidStr isEqualToString:@""] || ![model.gidStr isEqualToString:@""]) {
                
                if (model.isOtherRemind) {
                    
                    cell.clockImage.hidden = NO;
                    cell.centerClock.hidden = NO;
                    
                }else{
                 
                    cell.clockImage.hidden = YES;
                    cell.centerClock.hidden = YES;

                }
                
            }else{
             
               //本地提醒显示闹钟(2)②
                cell.clockImage.hidden = NO;
                cell.centerClock.hidden = NO;
            }
   
        }else{
            
            cell.clockImage.hidden = YES;
            cell.centerClock.hidden = YES;
        }
        
        //判断本地没有发送出去的情况
        if ((![model.fidStr isEqualToString:@""] || ![model.gidStr isEqualToString:@""]) && (model.uid == 0)) {
            
            cell.markImage.hidden = NO;
            cell.timeAndCount.origin = CGPointMake(50, 17);
            
            //这一步取决于上一步
            if (cell.clockImage.hidden == NO) {
                
                cell.centerClock.hidden = NO;

            }else{
             
                cell.centerClock.hidden = YES;
            }
            
            if (cell.otherClock.hidden == NO) {
                
                cell.centerOtherClock.hidden = NO;

            }else{
             
                cell.centerOtherClock.hidden = YES;
            }
            
            
            
            cell.clockImage.hidden = YES;
            cell.otherClock.hidden = YES;
            cell.timeLabel.hidden = YES;

        }else{
            
            cell.timeAndCount.origin = CGPointMake(20, 17);
            cell.markImage.hidden = YES;
            
            cell.centerClock.hidden = YES;
            cell.centerOtherClock.hidden = YES;
            
            if (cell.clockImage.hidden == NO) {
                
                cell.clockImage.hidden = NO;

            }else{
             
                cell.clockImage.hidden = YES;
            }
            
            if (cell.otherClock.hidden == NO) {
                
                cell.otherClock.hidden = NO;
                
            }else{
             
                cell.otherClock.hidden = YES;
            }
            
            cell.timeLabel.hidden = NO;

        }
        
        if (model.musicName == 8) {
            cell.clockImage.hidden = YES;
        }
        
        //判断闹钟的显示样式
        if (model.isRemind) {
            
            cell.clockImage.image = [UIImage imageNamed:@"闹钟完成状态.png"];
            cell.timeAndCount.textColor = grayTextColor;
            cell.timeLabel.textColor = grayTextColor;
            
        }else{
         
            cell.clockImage.image = [JYSkinManager shareSkinManager].clockImage;
            cell.timeAndCount.textColor = [UIColor blackColor];
            cell.timeLabel.textColor = nameTextColor;
         
        }
        
    }

    return cell;
    
}

//在这里边做删除数据的调整
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RemindModel *model = _arrForWait[indexPath.row];
    
    
    if (model.uid != 0) {
        
        NSString *midStr = [NSString stringWithFormat:@"%d",model.uid];
        
        JYSelectManager *selectManager = [JYSelectManager shareSelectManager];
        selectManager.labelForBefore.backgroundColor = [UIColor clearColor];
        selectManager.labelForBefore = nil;
        selectManager.strForBeforeLabel = nil;
        selectManager.viewForPoint = nil;
        selectManager.isHiddenPoint = YES;
        
        [RequestManager actionForDeleteMotherIncident:midStr isChangeMainView:YES];
        
        
        /*本地删除
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        [manager deleteDataWithUid:model.uid ownId:model.oid existUid:model.uid];
        
        NSArray *allArray = [manager selectAllData];
        DataArray *dataArr = [DataArray shareDateArray];
        dataArr.arrForAllData = allArray;
        */
        //更新UI
        //_actionForDeleteModel(model);
        
        //[self loadData:model.year month:model.month day:model.day isAwaysChange:NO];
    

    }else {
    
        LocalListManager *manager = [LocalListManager shareLocalListManager];
        [manager deleteDataWithUid:model.oid];
        int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        NSArray *allArray = [manager searchAllDataWithText:@""];
        DataArray *dataArr = [DataArray shareDateArray];
        dataArr.arrForAllData = allArray;
        //更新UI
        //_actionForDeleteModel(model);
        [self loadData:model.year month:model.month day:model.day isAwaysChange:NO];
        
        JYSelectManager *selectManager = [JYSelectManager shareSelectManager];
        selectManager.labelForBefore.backgroundColor = [UIColor clearColor];

        selectManager.labelForBefore = nil;
        selectManager.strForBeforeLabel = nil;
        selectManager.viewForPoint = nil;
        selectManager.isHiddenPoint = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
        
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}



//加载数据
- (BOOL)loadData:(int )year
           month:(int )month
             day:(int )day
   isAwaysChange:(BOOL)isAwaysChange
{
    
    if (year == 0 && month == 0 && day == 0) {
        
        year = [[Tool actionForNowYear:nil] intValue];
        month = [[Tool actionForNowMonth:nil] intValue];
        day = [[Tool actionForNowSingleDay:nil] intValue];
        
    }else if(_year == year && _month == month && _day == day && isAwaysChange){
        
        
        if (_arrForWait.count > 0) {
            
            return YES;
            
        }else{
            
            return NO;
        }
        
    }
    
 
    
    _year = year;
    _month = month;
    _day = day;
 
    
    DataArray *dataArr = [DataArray shareDateArray];
   
    NSArray *arr = dataArr.arrForAllData;
    
    NSMutableArray *alr = [NSMutableArray array];
    
    for (int m = 0; m < arr.count; m++) {
        
        RemindModel *model =  arr[m];
        
        //如果别人发的不显示
        if (model.isOther != 0 || model.isShare == 1) {
            
            continue;
        }
        
        //判断提醒他人里边是否有提醒自己
        if (![model.fidStr isEqualToString:@""]) {
            
            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
            
            NSArray *arrForFid = [model.fidStr componentsSeparatedByString:@","];
            
            for (int i = 0; i < arrForFid.count; i ++) {
                
                NSString *fid = arrForFid[i];
                
                if ([userID isEqualToString:fid]) {
                    
                    model.isOtherRemind = YES;
                    break;
                }
            }
            
        }
        
        //重复情况下判断是否是当天
        BOOL isNowDay = NO;
        
        if (model.randomType != 0) {
            
            
            BOOL isAlready = [Tool isAlreadyNowYear:year month:month day:day hour:model.hour minute:model.minute];
            
            if (isAlready) {
                
                model.isRemind = NO;
       
                
            }else{
                
                model.isRemind = YES;
            }
            
        isNowDay = [Tool actionForJudgementAndNotNotification:model year:year month:month day:day];
            
        }
        
        //没有选中重复的情况，是否超过提醒时间,且是否与选中天数相等
        BOOL isNotReapeat = NO;
        
        if (model.randomType == 0 && model.year == year && model.month == month && model.day == day) {
            
            //在没有重复的情况下判断是否超过当天时间
            BOOL isAlready = [Tool isAlreadyNowYear:model.year month:model.month day:model.day hour:model.hour minute:model.minute];
            if (isAlready) {
                
                model.isRemind = NO;
                
            }else{
                
                model.isRemind = YES;
            }
            
            isNotReapeat = YES;
            
        }
        
      
        
        //判断是否需要增加显示的cell
        if (isNotReapeat || isNowDay){

            [alr addObject:model];
            
        }
        
    }
    
    
    
    _arrForWait = alr;
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForSendHiddenEditBtn object:@(_arrForWait.count)];
    if (_arrForWait.count > 0) {
        

        return YES;
        
    }else{
   
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindModel *model = _arrForWait[indexPath.row];

    JYAwaitTableViewCell *cell = (JYAwaitTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.markImage.hidden == NO) {
        
        [ProgressHUD show:@"发送中…"];
        
        //在这里发送给其他人提醒
        __block JYAwaitTableView *weekSelf = self;
        [RequestManager actionForSendOtherRemind:model sendSuccessBlock:^(BOOL sendSuccess) {
            
            if (sendSuccess) {
                
                [Tool showAlter:weekSelf title:@"发送成功"];

                
            }else {
                
//                __sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"温馨提示" detail:@"网络异常，请检查您的网络" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
//                    
//                    //Window隐藏，并置为nil，释放内存 不能少
//                    __sheetWindow.hidden = YES;
//                    __sheetWindow = nil;
//                    
//                }];
                
                [Tool showAlter:self title:@"网络异常，请检查您的网络"];

            }
            
        }];
        
        return;
    }
    
    BOOL canEdit = YES;
    
    NSString *strForFid = [NSString stringWithFormat:@",%@,",model.fidStr];
    
    NSString *xiaomi = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *xiaomiID = [NSString stringWithFormat:@",%@,",xiaomi];
    
    BOOL isLocal = NO;
    /**
     *  判断是否能修改
     */
    if ((![model.gidStr isEqualToString:@""] || ![model.fidStr isEqualToString:@""]) && ([strForFid rangeOfString:xiaomiID].location == NSNotFound)) {
        
        canEdit = NO;
        isLocal = NO;
        
    }else if((![model.gidStr isEqualToString:@""] || ![model.fidStr isEqualToString:@""]) && ([strForFid rangeOfString:xiaomiID].location != NSNotFound)){
    
        isLocal = NO;
        canEdit = YES;
        
    }else{
     
        isLocal = YES;
    }
    
    
    _actionForModel(model,canEdit,isLocal);

}


- (NSString *)returnStrForDate:(int )time
{
   NSString *strForDate = @"";
    if (time < 10) {
        
        strForDate = [NSString stringWithFormat:@"0%d",time];
        
    }else{

        strForDate = [NSString stringWithFormat:@"%d",time];
    }

    return strForDate;
}


//判断重复的记录是否过了提醒时间
- (BOOL)isAwaitNowYear:(int )year
                 month:(int )month
                   day:(int )day
                  hour:(int )hour
                minute:(int )minute
{
    
    
    NSDate *dateNow = [NSDate date];
    NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;
    
    NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:day Year:year month:month hour:hour minute:minute];
    
    NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;
    
    if (_fitstDate - _secondDate > 0) {
        
        return YES;
        
    }else{
        
        return NO;
    }
    
}


@end
