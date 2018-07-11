//
//  JYMainViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

//controller
#import "JYMainViewController.h"
#import "JYRemindViewController.h"


//view
#import "JYWeatherView.h"
#import "JYRightAndWrongView.h"
#import "JYScrollViewForUp.h"

//frame
//添加按钮
#define kXRemindBtn 670 / 750.0 * kScreenWidth
#define kYRemindBtn 50  / 1334.0 * kScreenHeight
#define kWidhtRemind  80 / 750.0 * kScreenWidth


//返回今天按钮
#define kXTodayBtn  600 / 750.0 * kScreenWidth

//设置按钮
#define kXSet     10 / 750.0 * kScreenWidth

//选择时间按钮
#define kWidthForSelect 52 / 750.0 * kScreenWidth
#define kHeightForSelect 28 / 1334.0 * kScreenHeight

////类目
#import "JYMainViewController+UI.h"
#import "JYMainViewController+Action.h"
#import "JYMainViewController+JYMainVCData.h"
#import "JYMainViewController+ScrollView.h"
#import "JYMainViewController+DatePicker.h"
#import "JYMainViewController+Gesture.h"


#define heigthForSliderBtn 56 / 1334.0 * kScreenHeight
#define pageForTBAndBtn 52 / 1334.0 * kScreenHeight

//*********************datePicker *******************//
#define heightForYearDatePicker 514 / 1334.0 * kScreenHeight

@interface JYMainViewController ()

{
    
//    UIView                 *_viewForLineRWB;
    UIButton               *_btnForRemind;
    UIButton               *_btnForConfirm;
    
    
    BOOL                    _isSelectTime;
    BOOL ischa;
    
}

@end

@implementation JYMainViewController


+ (JYMainViewController *)shareInstance
{
    static JYMainViewController *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[JYMainViewController alloc] init];
    });
    return shareInstance;
}

#pragma mark 接收到23~6点更改时间的方法，通知方法
- (void)changeView
{
    RemindModel *model = [[RemindModel alloc] init];
    model.month = _changeMonth;
    model.day = _changeDay;
    model.year = _changeYear;
    [self actionForloadData:model];
    
}

- (void)dealloc
{
    NSLog(@"====日历主页销毁了");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.scrollView.manager = nil;
    self.scrollView1.manager = nil;
    self.scrollView2.manager = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kChangeDisTimeForNotification];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kNotificationForLoadData];
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kNotificationForGoRootVC];
    
}

- (void)changeSelectBtn:(NSNotification *)obj
{

    //NSLog(@"%@",obj.object);
    
//    if ([obj.object intValue] == 0) {
//        _isSelectPass = NO;
//    }else{
//        _isSelectPass = YES;
//    }
    
    _isSelectPass = [obj.object boolValue];
    if (_isSelectPass) {
        if(self.jyRemindView.alreayTableView.otherArr.count == 0){
            self.jyRemindView.btnForEdit.hidden = YES;
        }else{
            self.jyRemindView.btnForEdit.hidden = NO;
        }
    }else{
        if(self.jyRemindView.awaitTableView.arrForWait.count == 0){
            self.jyRemindView.btnForEdit.hidden = YES;
        }else{
            self.jyRemindView.btnForEdit.hidden = NO;
        }
    }
    
    NSLog(@"%d",_isSelectPass);
}

- (void)changeEditBtnWithSend:(NSNotification *)obj
{
    if (!_isSelectPass) {
        if ([obj.object integerValue]>0) {
            self.jyRemindView.btnForEdit.hidden = NO;
        }else{
            self.jyRemindView.btnForEdit.hidden = YES;

        }
    }
}

- (void)changeEditBtnWithAccept:(NSNotification *)obj
{
    if (_isSelectPass) {
        if ([obj.object integerValue]>0) {
            self.jyRemindView.btnForEdit.hidden = NO;
        }else{
            self.jyRemindView.btnForEdit.hidden = YES;
            
        }
    }
}

#pragma mark 生命周期
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _canScroll = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeEditBtnWithAccept:) name:kNotificationForAcceptHiddenEditBtn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeEditBtnWithSend:) name:kNotificationForSendHiddenEditBtn object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSelectBtn:) name:kNotificationForHiddenEditBtn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout) name:kNotificationForLeave object:nil];
    
    
    //防打扰模式下接收的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeView) name:kChangeDisTimeForNotification object:nil];
    
    //刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForReloadAllData) name:kNotificationForLoadData object:@""];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSkin:) name:kNotificationForChangeSkin object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clanderPostionChanged:) name:kNotificationForClanderPostionChanged object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weatherViewHeightRefreshed:) name:kNotificationForWeatherViewRefreshHeight object:nil];

    //设置导航栏样式//移到viewappear中
    [self actionForNavType];
    
    _selectManager = [JYSelectManager shareSelectManager];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //字体适配
    [self createFontMate];
    
    _isSlip = YES;
    ischa = YES;
    
    self.width = kScreenWidth / 7.0;
    
    //初始化年月日数据
    [self actionForDate];

    //创建日历视图
    [self createCalendarScrollView];

    //日历回调方法block
    [self actionForCalendarBlock];

    //添加手势方法
    [self actionForGesture];

    //设置页面
    [self setUI];
    
    
    //初始化UPScrollView
//    [self actionForUpScrollViewWithWidth:_width andArr:nil];
    
    //UPScrollView回调Block
    [self actionForUpCalendarBlock];

    //创建PickerView
    [self _createDatePickerForYearAndMonth];
 
    [self actionForloadData:nil];
    
    //是否是第一次登录
    [self actionForFirstEnter];
    
    //第一次进入页面，编辑按钮是否隐藏的判断
    if(self.jyRemindView.awaitTableView.arrForWait.count == 0){
        self.jyRemindView.btnForEdit.hidden = YES;
    }else{
        self.jyRemindView.btnForEdit.hidden = NO;
    }
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 150) / 2.0 , 10, 150, 44)];
    //btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(ca) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:btn];
}

- (void)ca{
    [self calendarAction];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [GuideView showGuideWithImageName:@"新手引导页13"];
//    [self.jyWeatherView locateCity];
//    [self.jyWeatherView queryCurrentCityWeather];
}

//*************************显示隐藏topView关键方法*********************//
//代理方法：是否隐藏顶端的topView
- (void)actionForHiddenTopView:(BOOL)isHidden
{
    
    //若果传进来的hidden情况不等于之前的情况，才去调用一次转换的方法
    
    if (_scrollViewForUp.hidden == !isHidden) {
        
        _scrollViewForUp.hidden = isHidden;
        
        if (isHidden) {
            
            UIButton *btn = [UIButton new];
            btn.tag = _x_Collection;
            //#warning 卡顿现象
            // 暂时打开，可以做到点问题消失，新问题是可能会卡顿
            [_calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
            
        }else{
            
            UIButton *btn = [UIButton new];
            
            btn.tag = 300 + _x_Collection - _selectTag;
            
            
            [_scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:_selectTag];
            [_scrollViewForUp.calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
            
        }
    }
    
    
    if (_scrollView.contentOffset.y == 0) {
        
        _scrollViewForUp.hidden = YES;
        if (_x_Collection < 200) {
            
            _scrollViewForUp.hidden = YES;
            UIButton *btn = [UIButton new];
            btn.tag = _x_Collection;
            self.lineSign = firstLine;
            _scrollView.typeForLine = firstLine;
            _calendarView = _scrollView.calendar1;
            _selectTag = 100;
            [_calendarView actionForSelectCalendar:btn isNotBtnSelect:YES isChangeTopView:NO];
            
        }
        
    }
}

#pragma mark 接收到远程通知以后调用的方法（刷新数据调用的方法）
- (void)actionForReloadAllData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        RemindModel *model = [[RemindModel alloc] init];
        model.year = _selectManager.g_changeYear;
        model.month = _selectManager.g_changeMonth;
        model.day = _selectManager.g_changeDay;
        self.changeDay = model.day;
        self.changeMonth = model.month;
        self.changeYear = model.year;
        model.oid = 1000;
        model.uid = 1000;
        NSLog(@"%d%d%d",_selectManager.g_changeYear,_selectManager.g_changeMonth,_selectManager.g_changeDay);
        [self actionForloadData:model];
        
    });
    
    
//    /**
//     *  添加本地通知到手机
//     */
//    [Tool actionForAddNotification];
//    
}
- (void)logout
{
    self.scrollView.contentOffset = CGPointMake(0,0);
}
#pragma mark 字体适配方法
- (void)createFontMate
{
    
    
    if (IS_IPHONE_4_SCREEN) {
        
        self.weekFont = [UIFont systemFontOfSize:11];
        _heightForSelectBtn = 15;
        _heightForTitleBtn = 10;
        _widhtForSelectBtn = -40;
        
        _selectManager.fontForSolar = [UIFont systemFontOfSize:17];
        _selectManager.fontForLunar = [UIFont systemFontOfSize:8];
        
    }else if (IS_IPHONE_5_SCREEN){
        
        self.weekFont = [UIFont systemFontOfSize:13];
        _heightForSelectBtn = 12;
        _heightForTitleBtn = 5;
        _widhtForSelectBtn = -20;
        
        _selectManager.fontForSolar = [UIFont systemFontOfSize:20];
        _selectManager.fontForLunar = [UIFont systemFontOfSize:9];
        
    }else if (IS_IPHONE_6_SCREEN){
        
        self.weekFont = [UIFont systemFontOfSize:13];
        _heightForSelectBtn = 6;
        _heightForTitleBtn = 0;
        _widhtForSelectBtn = -18;
        
        _selectManager.fontForSolar = [UIFont systemFontOfSize:20];
        _selectManager.fontForLunar = [UIFont systemFontOfSize:10];
        
    }else if (IS_IPHONE_6P_SCREEN){
        
        _heightForSelectBtn = 2;
        _heightForTitleBtn = -5;
        _widhtForSelectBtn = -20;
        
        _selectManager.fontForSolar = [UIFont systemFontOfSize:20];
        _selectManager.fontForLunar = [UIFont systemFontOfSize:10];
        
    }else{
        
        self.weekFont = [UIFont systemFontOfSize:11];
        _heightForSelectBtn = 10;
        _heightForTitleBtn = 0;
        _widhtForSelectBtn = -5;
        
        _selectManager.fontForSolar = [UIFont systemFontOfSize:20];
        _selectManager.fontForLunar = [UIFont systemFontOfSize:10];
        
    }
    
}

#pragma mark 隐藏选择日期按钮
- (void)hiddenAction:(BOOL)isHidden
{
  
}

//视图将要出现调用的方法
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //隐藏nav的那条黑线
//    if(!self.viewForLine){
//        [self actionForNavType];
//    }

    
//    self.viewForLine.hidden = NO;

    [self hiddenAction:NO];
   
    //是否显示新事件的number
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        LocalListManager *manager = [LocalListManager shareLocalListManager];
//        int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
//        [manager selectAllDataWithUserID:userID];
        
    });

    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ((self.changeDay == self.selectManager.g_notChangeDay && self.changeMonth == self.selectManager.g_notChangeMonth && self.changeYear == self.selectManager.g_notChangeYear)){
            
            self.btnForToday.alpha = 0;
            
        }else{
            
            self.btnForToday.alpha = 1;
            
        }
        
//        self.scrollView.contentOffset = CGPointMake(0,0);
        self.bgScrollView.scrollEnabled = YES;
//        self.dragImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"上拉_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
        
        //每次进都刷新数据
        [self actionForReloadAllData];
        
    });
   
    
}



//视图将要消失调用的方法
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _jyRemindView.isEdit = YES;
    [_jyRemindView actionForEdit:nil];
//    self.viewForLine.hidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

//内存警告
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//是否隐藏RemindView
- (void)actionForHiddenNotRemindView:(BOOL )isHiddenRemindView
{
    
    if (isHiddenRemindView) {
        
        self.imageForNotRemind.hidden = NO;
        self.jyRemindView.hidden = YES;
        self.viewForWhite.hidden = NO;
        
    }else {
        
        self.imageForNotRemind.hidden = YES;
        self.jyRemindView.hidden = NO;
        self.viewForWhite.hidden = YES;
    }
    
}


//回今天改变topView
- (void)actionForBackTopView:(int )index
                      btnTag:(int )tag
{
    
    int tagForTopView = _selectManager.selectTag - tag;
    UIButton *senderB = [UIButton new];
    senderB.tag = 300 + tagForTopView;
    int tagNow = (300 + tagForTopView) / 100;
    int tagNow1 = tagNow * 100;
    
    [_scrollViewForUp.calendarView reloadDataForChangePoint:nil andTrueTag:_selectTag];
    [_scrollViewForUp.calendarView changeLabelText:self.changeArrForHidden[index] isShow:YES withTag:tagNow1];
    [_scrollViewForUp.calendarView actionForSelectCalendar:senderB isNotBtnSelect:YES isChangeTopView:NO];
    
}

//换皮肤
- (void)changeSkin:(NSNotification *)notice
{
    if(self.scrollView.contentOffset.y==0){
        self.dragImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"上拉_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    }else{
        self.dragImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"下拉_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
    }
    self.btnForMe.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [self.backButton setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    [self.jyRemindView.btnForAdd setImage:[JYSkinManager shareSkinManager].remindAddBtnImage forState:UIControlStateNormal];
    
}
//日历位置改变，上拉下拉换图
- (void)clanderPostionChanged:(NSNotification *)notice
{
    if([kClanderPostionShown isEqualToString:notice.object]){
        self.dragImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"上拉_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
 
//        if(self.tabBarController.selectedIndex == 1){
//            [GuideView showGuideWithImageName:@"新手引导页5"];
//        }
        
        _canScroll = YES;
        
    }else if([kClanderPostionHidden isEqualToString:notice.object]){
        self.dragImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"下拉_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]];
        
        _canScroll = NO;
    }
}

- (void)weatherViewHeightRefreshed:(NSNotification *)notice
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

    self.jyRemindView.frame = CGRectMake(0, self.jyWeatherView.bottom + yForRemindView, kScreenWidth, kScreenHeight);
    self.imageForNotRemind.frame = CGRectMake(self.jyRemindView.origin.x, self.jyRemindView.origin.y, kScreenWidth, kHeightForNoRemind);
//    NSLog(@"==============%@",[NSValue valueWithCGRect:self.jyWeatherView.frame]);
}
@end



