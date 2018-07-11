//
//  JYMainViewController+UI.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/5.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYMainViewController+UI.h"
#import "JYMainViewController+Action.h"
#import "JYMainViewController.h"
#import "JYMainViewController+ScrollView.h"
#import "CalendarDetailViewController.h"
#import "JYMainViewController+DatePicker.h"
#import "JYClockVC.h"
//添加按钮
#define kXRemindBtn 650 / 750.0 * kScreenWidth
#define kYRemindBtn 59  / 1334.0 * kScreenHeight
#define kWidhtRemind  85 / 750.0 * kScreenWidth

//返回今天按钮
#define kXTodayBtn  548 / 750.0 * kScreenWidth

//设置按钮
#define kXSet     10 / 750.0 * kScreenWidth

//选择时间按钮
#define kWidthForSelect 52 / 750.0 * kScreenWidth
#define kHeightForSelect 28 / 1334.0 * kScreenHeight



//无提醒按钮
#define yForNoRemindBtn 60 / 1334.0 * kScreenHeight
#define xForNoRemindBtn 616 / 750.0 * kScreenWidth


@implementation JYMainViewController (UI)

- (void)changeRightBtn
{

    //选择天数按钮
    [self.btnForSelectDay setImage:[UIImage imageNamed:@"下拉框.png"] forState:UIControlStateNormal];
    
    //今天按钮
    self.btnForToday.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    self.btnForToday.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
    
    //添加按钮
    self.btnForAdd.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;

}

- (void)changeLeftBtn
{

    [self.btnForBigBtn setImage:[JYSkinManager shareSkinManager].bigClockImage forState:UIControlStateNormal];

}

- (void )todayBtn
{
 
    UIImage *addImg = [UIImage imageNamed:@"今.png"];
    self.btnForToday = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 26, 21)];
    self.btnForToday.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    self.btnForToday.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnForToday setImage:[addImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
 
    self.btnForToday.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.btnForToday addTarget:self action:@selector(backToday:) forControlEvents:UIControlEventTouchUpInside];
    self.btnForToday.alpha = 0;


}

- (void)actionForRightBtn
{
    
    CGFloat yForRightBtn = 0;
    CGFloat xForRithgBtn = 0;
    if (IS_IPHONE_4_SCREEN) {
        
        
    }else if (IS_IPHONE_5_SCREEN){
        
        yForRightBtn = 1;
        xForRithgBtn = 12;
        
    }else if (IS_IPHONE_6_SCREEN){
        
        xForRithgBtn = 35;
        yForRightBtn = 1;
        
    }else if (IS_IPHONE_6P_SCREEN){
        
        yForRightBtn = 1;
        xForRithgBtn = 55;
        
    }

    
    NSMutableArray *arrForRight = [NSMutableArray array];
    //选择天数按钮
//    self.btnForSelectDay = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btnForSelectDay.frame = CGRectMake(0,0,28,14);
//    [self.btnForSelectDay setImage:[UIImage imageNamed:@"下拉框.png"] forState:UIControlStateNormal];
//    [self.btnForSelectDay setImageEdgeInsets:UIEdgeInsetsMake(0, -xForRithgBtn, 0, xForRithgBtn)];
//    [self.btnForSelectDay addTarget:self action:@selector(calendarAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right3 = [[UIBarButtonItem alloc] initWithCustomView:self.btnForSelectDay];
    
    //今天按钮
    [self todayBtn];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithCustomView:self.btnForToday];
        
 
//    self.btnForAdd = [UIButton buttonWithType:UIButtonTypeCustom];
////    [self.btnForAdd addTarget:self action:@selector(addNewRemind) forControlEvents:UIControlEventTouchUpInside];
//    [self.btnForAdd addTarget:self action:@selector(showNoteList:) forControlEvents:UIControlEventTouchUpInside];
//    self.btnForAdd.frame = CGRectMake(0, 0, 20, 20);
//    [self.btnForAdd setImage:[[UIImage imageNamed:@"便签"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    self.btnForAdd.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
////    [self.btnForAdd setImageEdgeInsets:UIEdgeInsetsMake(yForRightBtn, 5.0, -yForRightBtn, -5.0)];
//    self.btnForAdd.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:self.btnForAdd];
    
//    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    spaceItem.width = 15.f;
//    
//    self.btnForBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.btnForBigBtn setImage:[JYSkinManager shareSkinManager].bigClockImage forState:UIControlStateNormal];
//    self.btnForBigBtn.frame = CGRectMake(0, 0, 23.5, 20.5);
//    [self.btnForBigBtn addTarget:self action:@selector(actionForRight:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.btnForBigBtn];
//
//    
//    [arrForRight addObject:item];
//    [arrForRight addObject:spaceItem];
    [arrForRight addObject:right2];

    

    self.navigationItem.rightBarButtonItems = arrForRight;
    
    
}

- (void)createNavBtnForMe
{
    self.btnForMe = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnForMe.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.btnForMe setImage:[[UIImage imageNamed:@"我"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
    self.btnForMe.frame = CGRectMake(0, 0, 22, 22);
    [self.btnForMe addTarget:self action:@selector(actionForPersonPage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.btnForMe];
    self.navigationItem.leftBarButtonItem = item;
}

#pragma mark - go back
- (void)popAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)actionForNavType
{
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
//    leftBtn.frame = CGRectMake(0, 0, 25, 25);
//    leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [leftBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.backButton = leftBtn;
    
//    self.viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.bottom-0.5, kScreenWidth, 1)];
//    self.viewForLine.backgroundColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar addSubview:self.viewForLine];

    //nav顶部按钮
//    [self actionForRightBtn];
//    [self actionForLeftBtn];
    
    
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //设置navigationBar颜色
    [self.navigationController.navigationBar  setBarTintColor:[UIColor whiteColor]];
    //不透明的方法
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航默认标题的颜色及字体大小
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19]};
    
    
    self.btnForTitle = [[JYTitleBtn alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth /2.0, 44) andTitle:@"2020年12月"];
    self.navigationItem.titleView = self.btnForTitle;
    __weak JYMainViewController *mainVC = self;
    [self.btnForTitle setSelectCalendarBlock:^{
        
        [mainVC calendarAction];
        
    }];
    
  
    
}



- (void)setUI
{
    
    if (IS_IPHONE_6_SCREEN) {
        
        self.yForRemindList = -3;
        
    }else {
     
        self.yForRemindList = 0;
    }
  
    
//    [self createWeekView];
    
    [self createCalendarView];
    
    [self createWeatherView];
    
    [self createRemindView];
    
    [self createNotRemind];
    
    [self createDragView];

    [self actionForRightBtn];
    [self createNavBtnForMe];
}


- (void)createWeekView
{
  
    
    self.weekView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kHeightForWeek)];
    self.weekView.backgroundColor = [UIColor whiteColor];
    CGFloat widthForWeek = kScreenWidth / 7.0;
    
    NSArray *arrForWeek = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    for (int i = 0; i < arrForWeek.count; i++) {
        
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * widthForWeek, 0, widthForWeek, kHeightForWeek)];
        weekLabel.text = arrForWeek[i];
        //weekLabel.backgroundColor = [UIColor orangeColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.font = self.weekFont;
        if (i >= 5) {
            
            weekLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue: 48 / 255.0 alpha:1];
        }
        
        [self.weekView addSubview:weekLabel];
    }
    
    [self.view addSubview:self.weekView];
    
    
    UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.weekView.bottom - 0.5, kScreenWidth, 0.5)];
    viewForLine.backgroundColor = lineColor;
    [self.weekView addSubview:viewForLine];
    
}

- (void)createCalendarView
{

    
}

#pragma mark 创建天气view
/**
 *  创建天气页面,日历点击的方法
 */
- (void)createWeatherView
{

    
    CGFloat width = kScreenWidth / 7.0;
    
    //天气页面
    self.jyWeatherView = [[WeatherView alloc] initWithFrame:CGRectMake(0, width * 6+kHeightForWeek , kScreenWidth, kHeightForWeather + 4)];
    self.jyWeatherView.backgroundColor = [UIColor whiteColor];
    [self.scrollView insertSubview:self.jyWeatherView atIndex:0];
   
    self.jyWeatherView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWeatherView:)];
    [self.jyWeatherView addGestureRecognizer:tap];

    
    
//***************************点击日历方法1**************************//
    

    
    
    self.viewForLineT = [[UIView alloc] initWithFrame:CGRectMake(0, self.jyWeatherView.top, kScreenWidth, 0.5)];
    self.viewForLineT.backgroundColor = lineColor;
    [self.scrollView addSubview:self.viewForLineT];
    
    self.viewForLineT1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.jyWeatherView.top, kScreenWidth, 0.5)];
    self.viewForLineT1.backgroundColor = lineColor;
    [self.scrollView1 addSubview:self.viewForLineT1];
    
    self.viewForLineT2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.jyWeatherView.top, kScreenWidth, 0.5)];
    self.viewForLineT2.backgroundColor = lineColor;
    [self.scrollView2 addSubview:self.viewForLineT2];
    
    //初始化节日
    [self actionForChangeWeatherView:self.jyWeatherView];

    
    
    
    
}
- (void)tapWeatherView:(UIGestureRecognizer *)gesture{
    
    CalendarDetailViewController *detailVC = [[CalendarDetailViewController alloc]init];
    detailVC.calendarModel = self.jyWeatherView.calendarModel;
    detailVC.weatherModel = self.jyWeatherView.selectedWeatherModel;
    
    //进入页面可能不是 今天，需要保存当天的天气数据
//    NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc]initWithCapacity:10];
//    [tmpDic setObject:@" " forKey:@"currentWeather"];
//    [tmpDic setObject:@" " forKey:@"currentTemperature"];
//    [tmpDic setObject:@" " forKey:@"aqi"];    
//    detailVC.weatherModelDict = tmpDic;
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)actionForChangeWeatherView:(WeatherView *)weatherView
{
    weatherView.calendarModel = [[JYCalendarModel alloc]initWithDate:[NSDate date]];
    
    //注掉旧代码 2016-4-4
    
//    //当天年月
//    int month = [[Tool actionForNowMonth:[NSDate date]] intValue];
//    //初始化数据
//    self.lunarCalendar = [[LunarCalendar alloc] init];
//    [self.lunarCalendar loadWithDate:nil];
//    [self.lunarCalendar InitializeValue];
//    
//    
//    
//    int day = [[Tool actionForNowSingleDay:[NSDate date]] intValue];
//    
//    
//    //节日
//    NSString *strForHoliday = [self.lunarCalendar getWorldHoliday:month day:day];
//    if (strForHoliday == nil || strForHoliday == NULL) {
//        
//        weatherView.holiDay.text = @"";
//        weatherView.holidayIcon.hidden = YES;
//    }else{
//        
//        weatherView.holiDay.text = strForHoliday;
//        weatherView.holidayIcon.hidden = NO;
//
//    }
//    
//    //日期
//    weatherView.solarCalendar.text = [NSString stringWithFormat:@"%d",day];
//    
//    NSString *lunarMonth = [self.lunarCalendar MonthLunar];
//    NSString *lunarDay   = [self.lunarCalendar DayLunar];
//    
//    
//    //阴历
//    weatherView.lunarCalendar.text = [NSString stringWithFormat:@"%@%@",lunarMonth,lunarDay];
//    
//    
//    NSInteger weekDay = [Tool actionForNowWeek:[NSDate date]];
//    
////    NSArray *arrForWeek = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
//    NSArray *arrForWeekEnglish = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
//    
//    //星期
//    //周日 = 1 周一 = 2 ...周六 = 7
//    weatherView.weekDay.text = arrForWeekEnglish[weekDay - 1];
    

}

#pragma mark 创建编辑提醒view
/**
 *  创建提醒页面
 */
- (void)createRemindView
{
    
    //适配
    CGFloat yForRemindView = 0;
    if (IS_IPHONE_4_SCREEN) {
        
        yForRemindView = 15;
        
    }else if (IS_IPHONE_5_SCREEN){
    
        yForRemindView = 3;
        
    }else if (IS_IPHONE_6_SCREEN){
     
        yForRemindView = 3;
        
    }else if (IS_IPHONE_6P_SCREEN){
     
        yForRemindView = 3;
    }
    
    self.jyRemindView = [[JYRemindView alloc] initWithFrame:CGRectMake(0, self.jyWeatherView.bottom + yForRemindView, kScreenWidth, kScreenHeight )];
    self.jyRemindView.hidden = YES;
    self.jyRemindView.backgroundColor = [UIColor whiteColor];
    [self.scrollView insertSubview:self.jyRemindView atIndex:0];
    
    
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 0.5)];
    topV.backgroundColor = lineColor;
    [self.jyRemindView addSubview:topV];
    
    
    //是否隐藏remind,以及点cellpush出添加的页面
    [self actionForAwaitPush];
    [self actionForAlreadyPush];
    
    
        
    //******************************编辑方法**************************//
    //编辑方法
    
    __weak JYRemindView *remindView = self.jyRemindView;
    __weak JYMainViewController *weekMain = self;
    [self.jyRemindView setEditAction:^void(BOOL isEdit,BOOL isUpScroll){
        
        // JYLog(@"主页编辑方法");
     
        [remindView.alreayTableView setEditing:isEdit animated:YES];
        [remindView.awaitTableView setEditing:isEdit animated:YES];
        
        
//        if(isEdit){
//            [weekMain.scrollView setContentOffset:CGPointMake(0, weekMain.jyWeatherView.frame.origin.y-1) animated: YES];
            weekMain.bgScrollView.scrollEnabled = NO;
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForClanderPostionChanged object:kClanderPostionHidden];
//        }

        
//            [weekMain.scrollView setContentOffset:CGPointMake(0, kScreenWidth) animated:YES];
//        }
    
    }];
    
    //*****************************增加提醒页面代理方法***********************//
    __weak JYMainViewController   *mainVC = self;
    [self.jyRemindView setAddAction:^void{
        
        
        [mainVC addNewRemind];

    }];
    
}

- (void)createNotRemind
{
 
    self.imageForNotRemind = [[UIImageView alloc] initWithFrame:CGRectMake(self.jyRemindView.origin.x, self.jyRemindView.origin.y, kScreenWidth, kHeightForNoRemind)];
    self.imageForNotRemind.backgroundColor = [UIColor whiteColor];
    self.imageForNotRemind.userInteractionEnabled = YES;
    self.imageForNotRemind.image = [UIImage imageNamed:@"无提醒.png"];
    
    DataArray *data = [DataArray shareDateArray];
    
    for (int i = 0; i < data.arrForAllData.count; i++) {
        
        RemindModel *model = data.arrForAllData[i];
        
        
        
        BOOL isHidden = NO;
        
        if (model.randomType != 0) {
            
            //重复情况下
            isHidden =  [Tool actionForJudgementAndNotNotification:model year:self.notChangeYear month:self.notChangeMonth day:self.notChangeDay];
            
        }else {
         
            if (model.randomType == 0 && model.year == self.notChangeYear && model.month == self.notChangeMonth && model.day == self.notChangeDay) {
                
                //在没有重复的情况下判断是否超过当天时间
                isHidden = YES;
            }
        }
        

        if (isHidden) {
            
            self.imageForNotRemind.hidden = YES;
            break;
        }
        
    }
    
    [self.scrollView insertSubview:self.imageForNotRemind atIndex:0];
    
    UIView *topV = [[UIView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 0.5)];
    topV.backgroundColor = lineColor;
    [self.imageForNotRemind addSubview:topV];
    
    self.btnForAddNotRemind = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnForAddNotRemind.frame = CGRectMake(xForNoRemindBtn, yForNoRemindBtn, 91 / 2.0, 91 / 2.0);
    [self.btnForAddNotRemind setImage:[UIImage imageNamed:@"无提醒添加.png"] forState:UIControlStateNormal];
    [self.btnForAddNotRemind addTarget:self action:@selector(addNewRemind) forControlEvents:UIControlEventTouchUpInside];
    [self.imageForNotRemind insertSubview:self.btnForAddNotRemind atIndex:100];
    
    

    
}
- (void)createDragView
{
    self.dragImageView = [[UIImageView alloc]init];
    self.dragImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"上拉_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    [self.scrollView addSubview:self.dragImageView];
    [self.dragImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.imageForNotRemind);
    }];
    
    self.dragImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDragView:)];
    [self.dragImageView addGestureRecognizer:tap];
}

/**
 *  跳转
 */
- (void)actionForTurnSelectViewWithModel:(RemindModel *)model
                                   isTop:(BOOL)isTop
{
  
    [self.jyRemindView.alreayTableView loadData:model.year month:model.month day:model.day isAwaysChange:NO];
    [self.jyRemindView.awaitTableView loadData:model.year month:model.month day:model.day isAwaysChange:NO];
    
    
    //当用户点击进入后，更改了时间，同时更新主界面
    self.changeDay = model.day;
    self.changeYear = model.year;
    self.changeMonth = model.month;
    
    
    NSArray *arr = [JYToolForReturnAllArray actionForReturnArrayWithYear:model.year month:model.month day:model.day isNowArr:YES];
    [self.scrollView changeLabelTextAll:arr isShow:YES];
    
    
    self.changeArrForHidden = arr;
    
    if (self.weekForSelectMonth == 1) {
        
        self.weekForSelectMonth = 6;
        
    }else{
        self.weekForSelectMonth -= 2;
    }
    
    
    //选中以后背景颜色跟着更改
    self.x_Collection = self.selectManager.selectTag;
    int type = self.selectManager.selectTag / 100 - 1;
    self.scrollView.typeForLine = type;
    self.lineSign = type;
    
    self.scrollView.actionForTag(self.x_Collection,type);
    
    //从新判断是否显示红点
    [self.scrollView changeLabelTextReload:arr];
    
    UIButton *btn = [UIButton new];
    btn.tag = self.x_Collection;
    self.selectManager.isLoad = YES;
    [self.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
    

   
    if (model.year == self.notChangeYear && model.month == self.notChangeMonth && model.day == self.notChangeDay) {
        
        self.btnForToday.alpha = 0;
        
    }else {
        
        self.btnForToday.alpha = 1;
    }
    
    
    self.btnForTitle.calendarTitle.text = [NSString stringWithFormat:@"%d年%d月",model.year,model.month];

    
    [self.selectManager actionForChangeDateWithYear:self.changeYear month:self.changeMonth day:self.changeDay];
    
    
    //同时更改前后俩个view
    [self changeFrameBeforeisZeroVelocity:YES];
    [self changeFrameNextisZeroVelocity:YES];
    
    if (isTop) {
        
        UIButton *topSender = [UIButton new];
        topSender.tag = self.x_Collection - self.selectTag + 300;
        [self.scrollViewForUp.calendarView actionForSelectCalendar:topSender isNotBtnSelect:YES isChangeTopView:NO];

    }
  
//    self.selectManager.viewForPoint = nil;
//    self.selectManager.isHiddenPoint = NO;

}


- (void)tapDragView:(UIGestureRecognizer *)recognizer
{
    CGPoint offset = self.scrollView.contentOffset;
    if(offset.y>0){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForClanderPostionChanged object:kClanderPostionShown];
            [self.scrollView actionForChangeFrame:self.scrollView];
        }];
    }else{

        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.contentOffset = CGPointMake(0,self.jyWeatherView.frame.origin.y-1);
        } completion:^(BOOL finished) {
//            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForClanderPostionChanged object:kClanderPostionHidden];
            [self.scrollView actionForChangeFrame:self.scrollView];
        }];
    }
}

////弹出我页面
- (void)actionForPersonPage:(UIButton *)sender
{
    JYPersonCentreViewController *personVC = [[JYPersonCentreViewController alloc] init];
    personVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personVC animated:YES];
}
/**
 *  弹出闹钟页面
 */
//- (void)actionForRight:(UIButton *)sender
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

@end
