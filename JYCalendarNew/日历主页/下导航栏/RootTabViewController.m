//
//  RootTabViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "RootTabViewController.h"
#import "JYMainViewController.h"
#import "JYMainViewController+Action.h"
#import "JYRemindViewController.h"
#import "JYFriendListVC.h"
#import "JYPersonCentreViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"
#import "JYClockVC.h"
#import "FunctionViewController.h"

#import "JYListVC.h"
#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

//#import "UINavigationController+FDFullscreenPopGesture.h"



#define heightForTabbar 58.f

@interface RootTabViewController ()
@property (nonatomic,strong) UIButton *centerTabButton;
@end

@implementation RootTabViewController

#pragma mark - Life Cycle

+ (RootTabViewController *)shareInstance
{
    static RootTabViewController *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[RootTabViewController alloc] init];
    });
    return shareInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    
    if (_isFirstLogin) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"登录成功!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alter show];
    }
    
    [self setupSubControllers];
    [self setupNotification];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 7) {
        
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication]   currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(![[NSUserDefaults standardUserDefaults]boolForKey:kHasAlertNotificationSettingKey]){
                  
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请打开系统设置中\"通知\",允许\"小秘\"给您推送消息" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alter show];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kHasAlertNotificationSettingKey];
                }
            });
            
            return;
        }
    }
    
    [self handle3DTouch];
    //上传deviceToken
    [RequestManager actionForDeviceToken];

    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kWechatBind];
    [defaults setBool:NO forKey:kWeiboBind];
    [defaults setBool:NO forKey:kQQbind];
    [defaults synchronize];
    
    JYNotReadList *notReadList = [JYNotReadList shareNotReadList];
    [notReadList selectNotReadRemind];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = heightForTabbar;
    tabFrame.origin.y = self.view.frame.size.height - heightForTabbar;
    
    self.tabBar.frame = tabFrame;
    UIView *transitionView = [[self.view subviews] objectAtIndex:0];
    transitionView.height = kScreenHeight - heightForTabbar;
    
}
- (void)dealloc
{
    NSLog(@"dealloc ============== root vc");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Public
- (void)logout
{
    for(int i=0; i<[self.viewControllers count];i++){
        BaseNavigationController *baseNav = self.viewControllers[i];
        [baseNav popToRootViewControllerAnimated:NO];
    }
    self.selectedIndex = 0;
}
#pragma mark - Private
- (void)setupSubControllers{
    
    self.tabBar.shadowImage = [UIImage new];
    self.tabBar.backgroundImage = [UIImage new];
    self.tabBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    self.delegate = self;
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 49 - heightForTabbar,kScreenWidth, heightForTabbar)];
    bgView.image = [UIImage imageNamed:@"tab_bg_all"];
    [self.tabBar addSubview:bgView];
    
    JYMainViewController *jymainVC = [JYMainViewController shareInstance];
    //JYRemindListVC *remindVC = [[JYRemindListVC alloc] init];
    //ListViewController *remindVC = [[ListViewController alloc] init];
    JYListVC           *remindVC = [[JYListVC alloc] init];
    JYFriendListVC *addressBook = [[JYFriendListVC alloc] init];
    FunctionViewController *functionVC = [[FunctionViewController alloc] init];
    //    JYPersonCentreViewController *personVC = [[JYPersonCentreViewController alloc] init];
    
    NSArray *arrForVC = @[jymainVC,remindVC,[UIViewController new],addressBook,functionVC];
    NSArray *arrForBtnName = @[@"日历",@"提醒",@"",@"通讯录",@"工具"];
    NSArray *tabBarItemImages = @[@"日历",@"提醒",@"",@"通讯录",@"功能"];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:[arrForVC count]];
    for(int i=0;i<[arrForVC count];i++){
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:arrForVC[i]];
//        if(i!=1){
//            nav.fd_fullscreenPopGestureRecognizer.enabled = NO;
//        }
        
        if(i!=2){
            nav.tabBarItem.title = arrForBtnName[i];
            nav.tabBarItem.imageInsets = UIEdgeInsetsMake(-3,0,3,0);
            nav.tabBarItem.image = [UIImage imageNamed:tabBarItemImages[i]];
            nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-6);
            [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]} forState:UIControlStateNormal];
        }
         
        if(i==2){
            nav.tabBarItem.enabled = NO;
            [self.tabBar addSubview:self.centerTabButton];
        }
        [viewControllers addObject:nav];
    }
    [self setViewControllers:viewControllers];
    
//    jymainVC.view.backgroundColor = [UIColor whiteColor];

}
- (void)setupNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSkin:) name:kNotificationForChangeSkin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCornerLabel) name:kNotificationRefreshUnreadRemindLabel object:nil];
    
    //刷新数据的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForReloadAllData) name:kNotificationForLoadData object:@""];
}

- (void)centerTabButtonClicked:(UIButton *)sender{
    BaseNavigationController *baseNav = self.viewControllers[self.selectedIndex];
    BaseViewController *baseVC = baseNav.viewControllers[0];
    [baseVC addNewRemind:baseVC];
}

- (void)actionForReloadAllData
{
    /**
     *  添加本地通知到手机
     */
    [Tool actionForAddNotification];
}

- (void)changeSkin:(NSNotification *)notice
{
    self.tabBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    self.centerTabButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    self.centerTabButton.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
}
- (void)refreshCornerLabel{
    [[LocalListManager shareLocalListManager]getUnreadRemindData];
}

- (void)handle3DTouch
{
    //3Dtouch触发
    if(kAppDelegate.forceTouchArgument==ForceTouchTypeNewRemind){//跳新建提醒
        kAppDelegate.forceTouchArgument = ForceTouchTypeNone;
        BaseNavigationController *baseNav = self.viewControllers[self.selectedIndex];
        BaseViewController *baseVC = baseNav.viewControllers[0];
        int year = [[Tool actionForNowYear:nil] intValue];
        int month = [[Tool actionForNowMonth:nil] intValue];
        int day = [[Tool actionForNowSingleDay:nil] intValue];
        
        [JYSelectManager shareSelectManager].g_changeDay = day;
        [JYSelectManager shareSelectManager].g_changeMonth = month;
        [JYSelectManager shareSelectManager].g_changeYear = year;
        
        [baseVC addNewRemind:baseVC];
    }else if(kAppDelegate.forceTouchArgument==ForceTouchTypeAlarmList){//跳闹钟页
        self.selectedIndex = 4;
        kAppDelegate.forceTouchArgument = ForceTouchTypeNone;
        JYClockVC *jyclockVc = [[JYClockVC alloc] init];
        jyclockVc.hidesBottomBarWhenPushed = YES;
        BaseNavigationController *baseNav = self.viewControllers[4];
        [baseNav pushViewController:jyclockVc animated:YES];
    }else if(kAppDelegate.forceTouchArgument==ForceTouchTypeContactList){//跳通讯录
        kAppDelegate.forceTouchArgument = ForceTouchTypeNone;
        self.selectedIndex = 3;
    }else{
        self.selectedIndex = 0;
    }
    
}
#pragma mark - UITabBarControllerDelegate
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//{
//    UINavigationController *nav = (UINavigationController *)viewController;
//    if ([nav.viewControllers[0] isKindOfClass:[JYFriendListVC class]]) {
//        
//        [RequestManager actionForSelectFriendIsNewFriend:YES];
//        
//    }
//    
//    return YES;
//}

#pragma mark - Custom Accessors
- (UIButton *)centerTabButton{
    if(!_centerTabButton){
        UIImage *addImg = [UIImage imageNamed:@"新建"];
        CGFloat btnWidth = addImg.size.width;
        _centerTabButton = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-btnWidth)/2.f,9.f, btnWidth, btnWidth)];
        _centerTabButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        [_centerTabButton setBackgroundImage:[addImg imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _centerTabButton.layer.cornerRadius = btnWidth/2.f;
        _centerTabButton.layer.masksToBounds = YES;
        _centerTabButton.layer.borderColor = [JYSkinManager shareSkinManager].colorForDateBg.CGColor;
        _centerTabButton.layer.borderWidth = 0.5f;
        _centerTabButton.adjustsImageWhenHighlighted = NO;
        _centerTabButton.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_centerTabButton addTarget:self action:@selector(centerTabButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerTabButton;
}
@end
