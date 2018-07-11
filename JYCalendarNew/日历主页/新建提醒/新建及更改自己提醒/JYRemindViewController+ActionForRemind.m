//
//  JYRemindViewController+ActionForRemind.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/2.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRemindViewController+ActionForRemind.h"
#import "JYRepeatViewController.h"
#import "JYMusicViewController.h"
#import "AddRemindVC.h"

#define heightForCc 88 / 1334.0 * kScreenHeight


@implementation JYRemindViewController (ActionForRemind)

//将键盘隐藏
- (void)acitonForHiddenKeyBorad
{
    [self.titleField resignFirstResponder];
    [self.contentView resignFirstResponder];

}

//选日期方法
- (void)calendarAction {
    
    //JYLog(@"选择日期")

    [self acitonForHiddenKeyBorad];
    
    
    
    self.isSelectYearAndMonth = !self.isSelectYearAndMonth;
 
    
    if (self.isSelectYearAndMonth) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            self.yearAndMinuteView.origin = CGPointMake(0, 0);
            
        }];
        
        self.jyAllPicker.year = self.model.year;
        self.jyAllPicker.month = self.model.month;
        self.jyAllPicker.day = self.model.day;
        self.jyAllPicker.hour = self.model.hour;
        self.jyAllPicker.minute = self.model.minute;
        
        [self.jyAllPicker reloadAllComponents];
        
        //初始化一下datepicker数据
        [self.jyAllPicker selectRow:self.model.year  - 2015 inComponent:0 animated:YES];
        [self.jyAllPicker selectRow:(self.model.month  - 1) * 13 inComponent:1 animated:YES];
        [self.jyAllPicker selectRow:self.model.day - 1 inComponent:2 animated:YES];
        [self.jyAllPicker selectRow:self.model.hour   inComponent:3 animated:YES];
        [self.jyAllPicker selectRow:self.model.minute  inComponent:4 animated:YES];
        
    }else{
    
        [UIView animateWithDuration:0.3 animations:^{
            
            self.yearAndMinuteView.origin = CGPointMake(0, kScreenHeight);
            
        }];
        
    }
    
   
 
}


//选择是否重复
- (void)repeatAction{
    
    [self acitonForHiddenKeyBorad];

    
    //JYLog(@"是否重复");
    JYRepeatViewController *reVC = [[JYRepeatViewController  alloc] init];

    
    
    reVC.model = [[RemindModel alloc] init];
    
    reVC.model.randomType = self.model.randomType;
    reVC.model.weekStr = self.model.weekStr;
    reVC.model.day = self.model.day;
    reVC.model.month = self.model.month;
    reVC.model.countNumber = self.model.countNumber;
   
    __weak typeof(self) weekSelf = self;
    [reVC setRepeatAction:^void(RemindModel *model){
        
        weekSelf.model.randomType = model.randomType;
        weekSelf.model.weekStr = model.weekStr;
        weekSelf.model.strForRepeat = model.strForRepeat;
        weekSelf.model.countNumber = model.countNumber;
       
        [weekSelf.remindTb reloadData];
        
    }];
    
    
    [self.navigationController pushViewController:reVC animated:YES];


    
}

- (int )actionForReturnMonth:(int )weekDay{
 
    NSString *strForNowWeek = @"";
   
    switch (weekDay) {
        case 1:
            strForNowWeek = @"每周一";
            break;
            
        case 2:
            strForNowWeek = @"每周二";
            break;
        case 3:
            strForNowWeek = @"每周三";
            break;
        case 4:
            strForNowWeek = @"每周四";
            break;
        case 5:
            strForNowWeek = @"每周五";
            break;
        case 6:
            strForNowWeek = @"每周六";
            break;
        case 7:
            strForNowWeek = @"每周日";
            break;
            
        default:
            break;
    }
    
    for (int i = 0; i < 7; i ++) {
        
        NSDate *date = [Tool actionForReturnSelectedDateWithDay:i + 1 Year:self.model.year month:self.model.month];
        NSInteger weekNow  = [Tool actionForNowWeek:date];
            
            //周日 = 1 周一 = 2 ...周六 = 7
            NSString *strForWeek = @"";
            if (weekNow == 1) {
                
                strForWeek = @"每周日";
                
            }else if(weekNow == 2){
                
                strForWeek = @"每周一";
                
            }else if(weekNow == 3){
                
                strForWeek = @"每周二";
                
            }else if (weekNow == 4){
                
                strForWeek = @"每周三";
            }else if(weekNow == 5){
                
                strForWeek = @"每周四";
                
            }else if(weekNow == 6){
                
                strForWeek = @"每周五";
                
            }else{
                
                strForWeek = @"每周六";
            }
        
        if ([strForNowWeek isEqualToString:strForWeek]) {
            
            return i + 1;
            
          }
        
     }

    return 1000;
}

//声音选择按钮
- (void)musicAction {
    
    [self acitonForHiddenKeyBorad];

    
    //JYLog(@"声音选择");
    JYMusicViewController *musicVC = [[JYMusicViewController alloc] init];
    musicVC.model = self.model;
    __weak JYRemindViewController *vc = self;
    [musicVC setActionForMusicName:^(int musicName) {
        
        vc.model.musicName = musicName;
        vc.model.isOn      = 1;
        [vc.remindTb reloadData];
     
        
    }];
    
    [self.navigationController pushViewController:musicVC animated:YES];
    
    
    
}

//#warning 选择提醒对象
//选择提醒对象
- (void)remindPeopleAction
{
  
    [self acitonForHiddenKeyBorad];

    AddRemindVC *remindVc = [[AddRemindVC alloc] init];
    

       
    remindVc.arrForFriend = self.arrForFriend;
    remindVc.arrForGroup = self.arrForGroup;
                
    

    __weak JYRemindViewController *vc = self;
 
//*******************************回调的数据*******************************
    
    [remindVc setActionForSendArr:^(NSArray *arrForFriend, NSArray *arrForGroup) {
        
        vc.arrForFriend = arrForFriend;
        vc.arrForGroup  = arrForGroup;
        
        [vc actionForHidenOrAppearFriend];
        
        //fid拼串。gid拼串
        NSMutableString *fidStr = [NSMutableString string];
        NSMutableString *gidStr = [NSMutableString string];
        
        for (int i = 0; i < arrForFriend.count; i ++) {
            
            FriendModel *model = arrForFriend[i];
            
            NSString *idStr = @"";
            
            if (i == arrForFriend.count - 1) {
                
                idStr = [NSString stringWithFormat:@"%ld",(long)model.fid];
                
            }else{
              
                idStr = [NSString stringWithFormat:@"%ld,",(long)model.fid];
            }
            
            [fidStr appendString:idStr];
        }
        
        for (int i = 0; i < arrForGroup.count; i ++) {
            
            GroupModel *model = arrForGroup[i];
            
            NSString *idStr = @"";
            
            if (i == arrForGroup.count - 1) {
                
                idStr = [NSString stringWithFormat:@"%d",model.gid];
                
            }else{
                
                idStr = [NSString stringWithFormat:@"%d,",model.gid];
            }
            
            [gidStr appendString:idStr];
        }
        
        if (arrForFriend.count != 0 || arrForGroup.count != 0) {
            
            vc.model.isOther = 1;
            
        }else{
        
            vc.model.isOther = 0;
            
        }
        
        vc.model.fidStr = fidStr;
        vc.model.gidStr = gidStr;
        
        NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        if ((![gidStr isEqualToString:@""] || ![fidStr isEqualToString:@""]) && ![fidStr isEqualToString:userID]) {
            
            UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnView addTarget:self action:@selector(confirmActionForPop:) forControlEvents:UIControlEventTouchUpInside];
            btnView.frame = CGRectMake(0, 0, 50, 50);
            [btnView setTitle:@"发送" forState:UIControlStateNormal];
            
            [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
            UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
            self.navigationItem.rightBarButtonItem = right;
        }
        
        [vc.remindTb reloadData];
        
    }];
    
    remindVc.title = @"添加联系人";
    
    [self.navigationController pushViewController:remindVc animated:YES];
    
    
}

//是否打开
- (void)openAction:(UISwitch *)sender {

    [self acitonForHiddenKeyBorad];

    
    //JYLog(@"%d",sender.isOn);
    self.isOpen = sender.isOn;
    self.model.isOn = sender.isOn;
    [self performSelector:@selector(_loadTableView) withObject:nil afterDelay:0.3];
    self.model.musicName = self.isOpen;
    
}

- (void)_loadTableView
{

    [self.remindTb reloadData];
    
}



- (NSString *)_returnStrForWeek:(NSInteger )week
{
   
    if (week == 1) {
        
        return @"周日";
        
    }else if(week == 2){
       
        return @"周一";

    }else if(week == 3){
        
        return @"周二";

    }else if(week == 4){
        
        return @"周三";

    }else if(week == 5){
      
        return @"周四";

    }else if(week == 6){
        
        return @"周五";

    }else{
        
        return @"周六";

    }
 
}


- (void)confirmAction:(UIButton *)sender
{
    
    //JYLog(@"%d",sender.selected);
    
   
    self.model.randomType = 0;
    
    [self calendarAction];
    [self.remindTb reloadData];

    
    
}

//返回阴历月的行数
- (NSDictionary *)lunarMonth
{

    LunarCalendar *lunar = [[LunarCalendar alloc] init];
    
    NSDate *dateForNow = [Tool actionForReturnSelectedDateWithDay:self.model.day Year:self.model.year month:self.model.month];
    [lunar loadWithDate:dateForNow];
    [lunar InitializeValue];
    
    NSArray *arrForLunar = [LunarModel arrForLunarMonth:self.model.year];
    
    
    NSString *strForMonth = [lunar MonthLunar];
    NSString *strForDay = [lunar DayLunar];
    NSMutableDictionary *dicForLunar = [NSMutableDictionary dictionary];
    //判断当前这个阴历月在哪行
    for (int i = 0 ; i < arrForLunar.count; i++) {
        
        if ([strForMonth isEqualToString:arrForLunar[i]]) {
            
            [dicForLunar setObject:@(i) forKey:@"阴历月"];
            
        }
        
    }
    
    //判断当前这个日在哪行
    for (int i = 0; i < self.dayNameArray.count; i++) {
        
        if ([strForDay isEqualToString:self.dayNameArray[i]]) {
            
            [dicForLunar setObject:@(i) forKey:@"阴历日"];
            
        }
        
    }

    return dicForLunar;
}








@end
