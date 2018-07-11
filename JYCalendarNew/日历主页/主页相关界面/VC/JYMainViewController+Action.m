//
//  JYMainViewController+Action.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/5.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYMainViewController+Action.h"
#import "JYMainViewController.h"
#import "JYRemindOtherVC.h"
#import "JYRemindNoPassPeopleVC.h"  //没有提醒人的VC
#import "NoteListViewController.h"

#define pageForTBAndBtn 52 / 1334.0 * kScreenHeight
#define heigthForSliderBtn 56 / 1334.0 * kScreenHeight



@implementation JYMainViewController (Action)

//他人提醒给我的
- (void)actionForAlreadyPush
{

    __weak JYMainViewController  *mainVC = self;
    [self.jyRemindView.alreayTableView setActionForModel:^void(RemindModel *model){
        
        UIViewController *vc = [RemindModel pushModel:model delegate:mainVC];

        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }];
    
    //在这个方法里更新页面
    [self.jyRemindView.alreayTableView setActionForDeleteModel:^void(RemindModel *model){
    
        [mainVC actionForloadData:model];
        
    }];
}

//我提醒给他人的或我提醒给自己的
//通过这里说明是更改
- (void)actionForAwaitPush
{
    __weak JYMainViewController  *mainVC = self;
    
    [self.jyRemindView.awaitTableView setActionForModel:^void(RemindModel *model ,BOOL canEdit ,BOOL isLocal){
        
        UIViewController *vc = [RemindModel pushModel:model delegate:mainVC];
        
        [mainVC.navigationController pushViewController:vc animated:YES];
    }];
    
    [self.jyRemindView.awaitTableView setActionForDeleteModel:^void(RemindModel *model){
    
        [mainVC actionForloadData:model];
    
    }];
    
}


#pragma mark 返回今天方法
/**
 *  回今天
 */
- (void)backToday:(UIButton *)sender;
{
    
    self.btnForToday.alpha = 0;
    int year = [[Tool actionForNowYear:nil] intValue];
    int month = [[Tool actionForNowMonth:nil] intValue];
    int day = [[Tool actionForNowSingleDay:nil] intValue];
    
    
    self.changeYear = year;
    self.changeMonth = month;
    self.changeDay = day;

    
    self.selectManager.g_notChangeDay = day;
    self.selectManager.g_notChangeMonth = month;
    self.selectManager.g_notChangeYear = year;
    
    self.selectManager.g_changeMonth = month;
    self.selectManager.g_changeYear = year;
    
    //当返回今天的时候，重置一下上一个选中的label
    self.selectManager.labelForBefore.backgroundColor = [UIColor clearColor];
    self.selectManager.labelForBefore.layer.masksToBounds = NO;
    self.selectManager.labelForBefore = nil;
    self.selectManager.strForBeforeLabel = nil;
    self.selectManager.viewForPoint = nil;
    self.selectManager.isHiddenPoint = YES;
    
  //    if(self.changeYear>y||(self.changeYear>=y&&self.changeMonth>m)||(self.changeYear>=y&&self.changeMonth>=m&&self.changeDay>d)){
//        aqi = @"数据未更新";
//        weather = @"Weather °C";
//    }else if(y==self.changeYear&&m==self.changeMonth&&d==self.changeDay){
//        aqi = self.jyWeatherView.aqiData;
//        weather = self.jyWeatherView.weatherData;
//        weatherImage = self.jyWeatherView.weatherImage;
//
//    }
//    else{
//        aqi = @"数据已过期";
//        weather = @"Weather °C";
//        
//    }
//    self.jyWeatherView.aqi.text = aqi;
//    self.jyWeatherView.weatherLabel.text = weather;
//    self.jyWeatherView.imageForWeather.image = weatherImage;
//    
//    
    
//    self.selectManager.g_notChangeDay = day;
//    self.selectManager.g_notChangeMonth = month;
//    self.selectManager.g_notChangeYear = year;
    

    
    RemindModel *model = [[RemindModel alloc] init];
    model.month = month;
    model.day = day;
    model.year = year;
    model.oid = 1000;
    [self actionForloadData:model];
    
    
    
}

#pragma mark 更改UI
/**
 *  添加提醒方法
 */
- (void)addNewRemind
{
    
    //监测新建提醒方法
    [self addNewRemind:self];
    [self hiddenAction:YES];

//    self.viewForLine.hidden = YES;
    
    
}

/**
 *  是否第一次登录
 */
- (void)actionForFirstEnter
{
//    BOOL isFirstLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstLogin];
    
    
//    if (!isFirstLogin) {
//    
//        UIButton *btn = [UIButton new];
//        btn.tag = self.selectManager.todayTag;
//        [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
//        
//        //开始就只显示上啦状态
//        self.scrollView.hiddenForCollection(YES);
//        self.scrollView.contentOffset = CGPointMake(0,0);
//        self.scrollViewForUp.hidden = YES;
//        
//        UIImageView *imageForNew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        imageForNew.image = [UIImage imageNamed:@"新手引导页1.png"];
//        imageForNew.tag = 789;
//        [self.tabBarController.view addSubview:imageForNew];
//        
//        if (IS_IPHONE_4_SCREEN) {
//            
//            imageForNew.image = [UIImage imageNamed:@"引导页4.png"];
//            
//        }else if (IS_IPHONE_5_SCREEN){
//            
//            imageForNew.image = [UIImage imageNamed:@"引导页5.png"];
//            
//        }else if (IS_IPHONE_6_SCREEN){
//            
//            CGFloat scal = [[UIScreen mainScreen] scale];
//            
//            if (scal == 2) {
//                
//                imageForNew.image = [UIImage imageNamed:@"引导页6.png"];
//                
//            }else {
//                
//                imageForNew.image = [UIImage imageNamed:@"引导页6p-b.png"];
//            }
//            
//            
//        }else if (IS_IPHONE_6P_SCREEN){
//            
//            imageForNew.image = [UIImage imageNamed:@"引导页6p.png"];
//            
//        }
//        
//        
//        
//        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        
//        [cancelBtn addTarget:self action:@selector(removeNewAction) forControlEvents:UIControlEventTouchUpInside];
//        cancelBtn.tag = 890;
//        [self.tabBarController.view addSubview:cancelBtn];
//        
//        
//    }else {
    
        UIButton *btn = [UIButton new];
        btn.tag = self.selectManager.todayTag;
        //[self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
        
        //开始就只显示上啦状态
       // self.scrollView.hiddenForCollection(NO);
//        self.scrollView.contentOffset = CGPointMake(0,6 * self.width+kHeightForWeek-1);
        self.scrollViewForUp.hidden = NO;
        self.bgScrollView.scrollEnabled = NO;
       // self.isUp = YES;
        
//    }

}

///**
// *  闹钟页面
// */
//- (void)actionForLeft:(UIButton *)sender
//{
// 
//    [RequestManager actionForHttp:@"local_alert"];
//    
//    JYClockVC *jyclockVc = [[JYClockVC alloc] init];
//    
//    jyclockVc.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:jyclockVc animated:YES];
//    NSLog(@"弹出闹铃");
//}

- (void)removeNewAction{
    
    UIImageView *iamgeV = (UIImageView *)[self.tabBarController.view viewWithTag:789];
    UIButton *btn = (UIButton *)[self.tabBarController
                                 .view viewWithTag:890];
    [iamgeV removeFromSuperview];
    [btn removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLogin];
}

//- (void)showNoteList:(UIButton *)sender{
//    NoteListViewController *noteListVC = [NoteListViewController new];
//    noteListVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:noteListVC animated:YES];
//    
//}


@end
