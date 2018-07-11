//
//  AppDelegate.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "AppDelegate.h"
#import "JYMainViewController.h"
#import "AppDelegate+LoadData.h"
#import "NowLoginViewController.h"
#import "toBindWeiboController.h"
#import "JYLaunchVC.h"
#import "FirstLaunchVC.h"
#import <Foundation/Foundation.h>
//#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
//#import <iflyMSC/iflyMSC.h>
#import "BaseNavigationController.h"
#import "JYClockVC.h"

#import "NewFriendViewController.h"

#import "JYCalculateRandomTime.h"



#import <UserNotifications/UserNotifications.h>

#define kAlertTagPlaySound 10001



@interface AppDelegate () <UNUserNotificationCenterDelegate>{
    
    NSInteger             _second;
    NSTimer              *_requestTimer;
    NSTimer              *_timer;
    
    JYMainViewController *_jyMainVC;
    NowLoginViewController  *_loginVC;
    toBindWeiboController *tbwController;
    NSArray *_arrForMusic;
    
    
    NewFriendViewController *newFVc;
    int a;
}

@end

@interface AppDelegate (thirdLogin)

- (void)actionForThirdLogin;

@end

@implementation AppDelegate (thirdLogin)

- (void)actionForThirdLogin{

    //_loginVC = [NowLoginViewController shareNowLoginViewController];
    self.window.rootViewController = _loginVC;
    
}

//微信,微博，QQ
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if(![self.defaults objectForKey:kBindWeiBoLogin]){
        
        if ([self.defaults objectForKey:kWechatLogin]) {
            
            return [WXApi handleOpenURL:url delegate:_loginVC];

        }else if ([self.defaults objectForKey:kWeiboLogin]) {
        
            return [WeiboSDK handleOpenURL:url delegate:_loginVC];
            
        }else {
        
            return [TencentOAuth HandleOpenURL:url];
            
        }
    
    }else {
        
        tbwController = [toBindWeiboController shareToBindWeiboController];
        return [WeiboSDK handleOpenURL:url delegate:tbwController];
        
    }

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL bindWeiBoLogin = [[self.defaults objectForKey:kBindWeiBoLogin] boolValue];
    BOOL wechatLogin = [[self.defaults objectForKey:kWechatLogin] boolValue];
    BOOL weiboLogin = [[self.defaults objectForKey:kWeiboLogin] boolValue];
    BOOL qqLogin = [[self.defaults objectForKey:kQQLogin] boolValue];

    BOOL isLogin = [[self.defaults objectForKey:kIsLogin] boolValue];

    if (isLogin == NO) {
        
        if(bindWeiBoLogin == NO){
            
            if (wechatLogin == YES) {
                
                [ProgressHUD show:@"微信登录中…"];
                return [WXApi handleOpenURL:url delegate:_loginVC];
                
            }else if (weiboLogin == YES) {
                
                [ProgressHUD show:@"微博登录中…"];
                return [WeiboSDK handleOpenURL:url delegate:_loginVC];
                
            } else {
                
                [ProgressHUD show:@"QQ登录中…"];
                return [TencentOAuth HandleOpenURL:url];
                
            }
            
        }else {
            
            tbwController = [toBindWeiboController shareToBindWeiboController];
            return [WeiboSDK handleOpenURL:url delegate:tbwController];
            
        }

    }else{
 
        BOOL wechatBind = [[self.defaults objectForKey:kWechatBind] boolValue];
        BOOL weiboBind  = [[self.defaults objectForKey:kWeiboBind] boolValue];
        BOOL qqBind  = [[self.defaults objectForKey:kQQbind] boolValue];
       
        if (wechatBind) {
            
            [ProgressHUD show:@"微信绑定中..."];
            //newFVc = nil;
            return [WXApi handleOpenURL:url delegate:newFVc];

            
        }else if(weiboBind){
            
            
            [ProgressHUD show:@"微博绑定中…"];
            //newFVc = nil;
            return [WeiboSDK handleOpenURL:url delegate:newFVc];
        
        }else if(qqBind){
            
            [ProgressHUD show:@"QQ绑定中…"];
            //newFVc = nil;
            return [TencentOAuth HandleOpenURL:url];
        
        }else{
            //newFVc = nil;
            return NO;
        }

        return NO;
    }
    
}

@end

@implementation AppDelegate

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
 
    NSString *strForDeviceToken = [NSString stringWithFormat:@"%@",deviceToken];

//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:strForDeviceToken message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//    [alert show];
    [_defaults setObject:strForDeviceToken forKey:kDeviceToken];
    [_defaults synchronize];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
 
    
    NSLog(@"%@",error);
    
}


#pragma mark 轮询调用
- (void)actionForReloadAllDataFor30minute:(NSTimer *)timer {
 
    _second++;
    
    if (_second >= 1800) {
        
        _second = 0;
        
        [RequestManager actionForReloadData];
        
    }
    
}

//登录时间统计
- (void)timeAction:(NSTimer *)timer
{
    a++;
    
   // NSLog(@"%d",a);
    
}


- (void)_setBgColor
{
    [[UITextField appearance] setTintColor:[UIColor blueColor]];
    
    //设置默认颜色
    NSString *skinColor = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSkin];
    
    if (skinColor == nil) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"红色" forKey:kUserSkin];
        
    }
    
}

- (void)changeDelegate:(NSNotification *)notification
{
    newFVc = [notification.userInfo objectForKey:@"delegate"];
    NSLog(@"%@",notification);
    
}

#pragma mark 开机启动方法
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化计算类
    JYCalculateRandomTime *randomTime = [JYCalculateRandomTime manager];
    randomTime.year = [[Tool actionForNowYear:nil]intValue];
    randomTime.month = [[Tool actionForNowMonth:nil]intValue];
    randomTime.day  = [[Tool actionForNowSingleDay:nil]intValue];
    

    if([[NSUserDefaults standardUserDefaults] integerForKey:kDefaultMusic] == 0){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kDefaultMusic];
    }
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDelegate:) name:kNotificationForChangeDelegate object:nil];
    
    //隐藏tabbat边框http://xiaomi.jyhd.com/picture/headPic/20160302151335.jpg
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    
    //设置默认颜色
    [self _setBgColor];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"time"] != nil) {
        
        NSString *strForTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"time"];
        
       [RequestManager actionForTime:strForTime];
        
    }
    
       
    _loginVC = [NowLoginViewController shareNowLoginViewController];
    
    //注册微博
    [WeiboSDK registerApp:kWeiboKey];

//    application.applicationIconBadgeNumber = 0;
    
    XiaomiDB *xiaomidb = [XiaomiDB shareXiaomiDB];
    [xiaomidb closeDB];
    
    _requestTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionForReloadAllDataFor30minute:) userInfo:nil repeats:YES];
    
    //避免阻塞timer
    [[NSRunLoop currentRunLoop] addTimer:_requestTimer forMode:NSRunLoopCommonModes];
    
       //**********************添加启动图,同事加载数据********************************//
    
    //初始化数据
    [self actionForCalendarData];
    

    FriendListManager   *friendMan = [FriendListManager shareFriend];
    GroupListManager    *groupMan = [GroupListManager shareGroup];
    LocalListManager    *localMan = [LocalListManager shareLocalListManager];

    _defaults = [NSUserDefaults standardUserDefaults];
    
    //#warning 测试外网
//    [_defaults setObject:@"121" forKey:kUserXiaomiID];
//    [_defaults setBool:YES forKey:kIsLogin];
    
    int userID = [[_defaults objectForKey:kUserXiaomiID] intValue];
 
    NSArray *allFriend = [friendMan selectAllData]; //好友
    NSArray *arrGroup = [groupMan selectAllData];  //组
    NSArray *arrForAllData = [localMan searchAllDataWithText:@""];
    
    DataArray *dataArr = [DataArray shareDateArray];
    dataArr.arrForAllData = arrForAllData;
    dataArr.arrForAllFriend = allFriend;
    dataArr.arrForAllGroup = arrGroup;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
   
    //3d touch
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=9) {
        
        if([launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey]){
            UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
            if([shortcutItem.type isEqualToString:@"NewRemind"]){
                self.forceTouchArgument = ForceTouchTypeNewRemind;
            }else if([shortcutItem.type isEqualToString:@"AlarmList"]){
                self.forceTouchArgument = ForceTouchTypeAlarmList;
            }else if([shortcutItem.type isEqualToString:@"ContactList"]){
                self.forceTouchArgument = ForceTouchTypeContactList;
            }
        }
    }

    
    if(![_defaults boolForKey:kFirstLoginFor411]){
        
        FirstLaunchVC *firstVC = [[FirstLaunchVC alloc] init];
        _window.rootViewController = firstVC;
        
        @weakify(self)
        [firstVC setPushForLogin:^{
            @strongify(self)
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLoginFor411];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self setRootView];
        }];
    }else{
        
        [self setRootView];
    }
    
    
    //***********************开机之前加载数据方法********************************//
    if(kSystemVersion>=10.0){
        
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  if(granted){
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  }else if (error) {
                                      NSLog(@"request authorization succeeded!");
                                  }
                              }];
        
    }else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {

        UIUserNotificationSettings *set = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
            
        [[UIApplication sharedApplication] registerUserNotificationSettings:set];
        [application registerForRemoteNotifications];

        
    }else {

        UIRemoteNotificationType types =(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert);
            
        [[UIApplication sharedApplication]registerForRemoteNotificationTypes:types];
        
    }
    
    

    
    
    // 注册百度账号key
    
    // 添加对BMKMapManager的初始化，并填入您申请的授权Key
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定generalDelegate参数
    BOOL ret = [mapManager start:@"pVKGaeDuzIA0epSPbDIgzd1N" generalDelegate:nil];
    if (!ret) {
        NSLog(@"地图管理器初始化失败!");
    }
    
    
    //向微信注册
    [WXApi registerApp:@"wx2b07116467d44615" withDescription:@"小秘"];
    
    
    
    //设置sdk的log等级，log保存在下面设置的工作路径中
//    [IFlySetting setLogFile:LVL_ALL];
//    
//    //打开输出在console的log开关
//    [IFlySetting showLogcat:YES];
//    
//    //设置sdk的工作路径
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [paths objectAtIndex:0];
//    [IFlySetting setLogFilePath:cachePath];
//    
//    //创建语音配置,appid必须要传入，仅执行一次则可
//    //NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
//    NSString *initString =@"appid=56ea1654";
//    //所有服务启动前，需要确保执行createUtility
//    [IFlySpeechUtility createUtility:initString];
    
    
    [[SDImageCache sharedImageCache]setShouldDecompressImages:NO];
    [[SDImageCache sharedImageCache] setMaxMemoryCountLimit:50];
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
  
    
    NSString *xmId = [[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID];
    if(!xmId||[xmId isKindOfClass:[NSNull class]]||[xmId isEqualToString:@""]){
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }

    return YES;
}
- (void)setRootView
{
    //**********************************判断是否有登录情*********************************//
    
    NSString *key = [_defaults objectForKey:kUserXiaomiID];
    if ([[_defaults objectForKey:kIsLogin] boolValue] && ![key isEqualToString:@""] && key != nil) {
        
        
        JYLaunchVC *launchVc = [[JYLaunchVC alloc] init];
        self.window.rootViewController = launchVc;
        
    }else {
        //未登录，取消所有通知
        UIApplication *app = [UIApplication sharedApplication];
        app.applicationIconBadgeNumber = 0;
        [app cancelAllLocalNotifications];
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        if(kSystemVersion>=10){
            [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
        }
#endif
        //调用第三方登录，如果没有登录的情况
        [self actionForThirdLogin];
    }

}

#pragma mark 接收到本地的消息处理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {

    NSLog(@"===------%@",notification.soundName);
    
    if([notification.soundName length]>0){
        [self playSound:notification.soundName atTimeIntervalSinceNow:0];
    }
    
    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"通知" message:notification.alertBody delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alterView.delegate = self;
    alterView.tag = kAlertTagPlaySound;
    [alterView show];
    
    NSLog(@"吊我了！！！1");
    
    [self didReceiveLocalNotifications];
}

/************************************ios10*****************************/
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//前台收到
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"远程推送");
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:notification.request.content.userInfo];
//        completionHandler(UNNotificationPresentationOptionSound);
        
    }else{
        NSLog(@"本地通知");
        NSString *noti = [NSString stringWithFormat:@"%@\n%@",notification.request.content.title,notification.request.content.body];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"通知" message:noti delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alterView.delegate = self;
        alterView.tag = kAlertTagPlaySound;
        [alterView show];
        
        
        NSString *soundName = notification.request.content.userInfo[kAlarmSoundNamaKey];
        if([soundName length]>0){
            [self playSound:soundName atTimeIntervalSinceNow:0];
        }
        [self didReceiveLocalNotifications];
        
        //本地通知手动播放铃音
    }
    completionHandler(UNNotificationPresentationOptionNone);
}

//点击提醒
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"远程推送");
        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:response.notification.request.content.userInfo];
        
    }else{
        NSLog(@"本地通知");
        NSString *noti = [NSString stringWithFormat:@"%@\n%@",response.notification.request.content.title,response.notification.request.content.body];
        [self showAlert:noti];
        
        [self didReceiveLocalNotifications];
    }
    
    completionHandler();
}
#endif
- (void)showAlert:(NSString *)info
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"通知" message:info delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
- (void)didReceiveLocalNotifications
{
    UIApplication *application = [UIApplication sharedApplication];
    id vc = application.delegate.window.rootViewController;
    
    if ([vc isKindOfClass:[NowLoginViewController class]]) {
        
        
    return;
    }
    
    RootTabViewController *jyMainvc = (RootTabViewController*)vc;
    for (int i = 0; i < jyMainvc.viewControllers.count; i++) {
        
        UINavigationController *nav = jyMainvc.viewControllers[i];
        BaseViewController *nowVC = nil;
        
        nowVC = nav.viewControllers[0];
        
        if ([nowVC isKindOfClass:[JYMainViewController class]]) {
            
            JYMainViewController *mainVC = (JYMainViewController *)nowVC;
            //如果本地提醒触发，说明一定是今天，年月日取今天
            mainVC.changeYear = [[Tool actionForNowYear:nil] intValue];
            mainVC.changeMonth = [[Tool actionForNowMonth:nil] intValue];
            mainVC.changeDay = [[Tool actionForNowSingleDay:nil] intValue];
            
            
            LocalListManager *manager = [LocalListManager shareLocalListManager];
            
            //当触发本地通知，需要重新排序
            int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
            
            DataArray *data = [DataArray shareDateArray];
            data.arrForAllData = [manager searchAllDataWithText:@""];
      
            [mainVC.jyRemindView.alreayTableView loadData:0 month:0 day:0 isAwaysChange:NO];
            [mainVC.jyRemindView.awaitTableView loadData:0 month:0 day:0 isAwaysChange:NO];
            
            [mainVC actionForReloadAllData];
            
            continue;
            
        }
        
        // NSLog(@"%@",[nav.viewControllers lastObject]);
        
    }
    
    
    
    //刷新未读提醒label
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRefreshUnreadRemindLabel object:@""];
    
    //刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForUpDate object:@""];
}
#pragma mark 点击确定方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self performSelector:@selector(actionForReloadMainView) withObject:nil afterDelay:3];
    
    if(alertView.tag==kAlertTagPlaySound){
        if([self.audioPlayer isPlaying]){
            [self.audioPlayer stop];
        }
    }
}


- (void)actionForReloadMainView {

    [_jyMainVC.jyRemindView.alreayTableView loadData:_jyMainVC.changeYear month:_jyMainVC.changeMonth day:_jyMainVC.changeDay isAwaysChange:NO];
    [_jyMainVC.jyRemindView.awaitTableView loadData:_jyMainVC.changeYear month:_jyMainVC.changeMonth day:_jyMainVC.changeDay isAwaysChange:NO];
    
}


#pragma mark 接受到远程的消息处理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
  
//    {
//        aps =     {
//            alert = "\U4e36\U6960:\U63d0\U63d0OMG";
//            badge = 1;
//            sound = default;
//        };
//        remind = "2016,5,11,11,20";
//        sex = 1;
//    }
    

    int sex = [userInfo[@"sex"] intValue];
    if (sex == 1) {

        NSString *strForDate = [userInfo objectForKey:@"remind"];
        
        NSArray *arrForDate = [strForDate componentsSeparatedByString:@","];
        
        NSString *name = [userInfo[@"aps"] objectForKey:@"alert"];
        
        NSString *nameStr = [name componentsSeparatedByString:@":"][0];
        NSString *titleStr = [name componentsSeparatedByString:@":"][1];
        NSString *minuteStr = arrForDate[4];
        if(minuteStr.length==1){
            minuteStr = [NSString stringWithFormat:@"0%@",arrForDate[4]];
        }
        NSString *strForSelectDate = [NSString stringWithFormat:@"%@年%@月%@日 %@:%@",arrForDate[0],arrForDate[1],arrForDate[2],arrForDate[3],minuteStr];
        NSString *nowName = [NSString stringWithFormat:@"%@:%@\n闹铃:%@",nameStr,titleStr,strForSelectDate];
        
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:nowName delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alter.tag = 300;
        [alter show];
        
        _jyMainVC.changeYear = [arrForDate[0] intValue];
        _jyMainVC.changeMonth = [arrForDate[1] intValue];
        _jyMainVC.changeDay = [arrForDate[2] intValue];
  
        //刷新提醒列表
        [RequestManager actionForReloadData];
 
    }else if (sex == 2){

        
//        _jyMainVC.managerForBtn.haveNewFriend = YES;
        
        //刷新待接受好友,刷新点就没有了。
        [RequestManager actionForSelectLoginFriendIsNew:YES];
        [RequestManager actionForSelectFriendIsNewFriend:YES];
  
        
    }else if(sex == 3){
     
        //确认接收好友
        AddressBook *boo = [AddressBook shareAddressBook];
        
        NSString *name = userInfo[@"sendId"];
        NSString *tel  = userInfo[@"sendTel"];
        
        AddressBook *addbook = [AddressBook shareAddressBook];
        NSString *telNameStr = [addbook.dicForAllTelAndName objectForKey:tel];
        NSString *nameStr = @"";
        if (telNameStr != nil) {
            nameStr = [NSString stringWithFormat:@"%@ (%@)通过了你的好友申请",name,telNameStr];
        }else{
            nameStr = [NSString stringWithFormat:@"%@通过了你的好友申请",name];
        }

        UIAlertView *alterV = [[UIAlertView alloc] initWithTitle:nameStr message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterV show];
        
        //区分是否通过接收好友接口调用
        [RequestManager actionForSelectFriendIsNewFriend:YES];
        [RequestManager actionForAddressBookWithArr:boo.arrForBeforeA isNewFriend:YES];
        
        //刷新提醒列表
        [RequestManager actionForReloadData];
    
    }else if (sex == 4){
    
        NSString *name = [userInfo[@"aps"] objectForKey:@"alert"];
   
        UIAlertView *alterV = [[UIAlertView alloc] initWithTitle:name message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterV show];

        NSLog(@"接到他人的分享");
        //刷新提醒列表
        [RequestManager actionForReloadData];
        
    }else if(sex==6){//踢人推送
        NSString *name = [userInfo[@"aps"] objectForKey:@"alert"];
        
        UIAlertView *alterV = [[UIAlertView alloc] initWithTitle:name message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alterV.delegate = self;
        [alterV show];
        
        [self logoutIfRequestServer:NO];
        
    }else if(sex == 8){//合并账号推送
    
        //区分是否通过接收好友接口调用
        [RequestManager actionForSelectFriendIsNewFriend:NO];
//        //刷新提醒列表
//        [RequestManager actionForReloadData];
        
    }
    
//        NSString *oldToken = [_defaults objectForKey:kDeviceToken];
//        NSString *deviceToken = userInfo[@"deviceToken"];
//        if([deviceToken isEqualToString:oldToken]){
//            [self logout];
//        }
//        
    
}
- (void)logoutIfRequestServer:(BOOL)flag{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
        //注销登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    GroupListManager *manager = [GroupListManager shareGroup];
    
    [manager deleteAllData];
    
    int xmId = [[defaults objectForKey:kUserXiaomiID] intValue];
    LocalListManager *lm = [LocalListManager shareLocalListManager];
    [lm deleteDataWithUid:xmId];

    JYShareList *sl = [JYShareList shareList];
    [sl deleteAllData];
    
    IncidentListManager *il = [IncidentListManager shareIncidentManager];
    [il deleteAllData];
    
    //页面注销
    [[RootTabViewController shareInstance]logout];
    [[JYMainViewController shareInstance] backToday:nil];
    if(flag){
        self.logout = YES;
        //注销方法
        [RequestManager actionForCancelDevicetoken];
    }
    
        //[defaults setObject:@"" forKey:kDeviceToken];
    [defaults setObject:@"" forKey:kUserXiaomiID];
    [defaults setObject:@"" forKey:kThirdOpenID];
    [defaults setBool:NO forKey:kIsLogin];
    [defaults setBool:NO forKey:kTiUpTel];
    [defaults setObject:@(0) forKey:newFriendCount];
    [defaults setObject:@"" forKey:@"passWord"];
    [defaults setObject:@"" forKey:kUserLocal];
    [defaults setObject:@"" forKey:kUserSex];
    [defaults setObject:@"" forKey:kUserSign];
    [defaults setInteger:1 forKey:kDefaultMusic];
    [defaults setObject:@"" forKey:kWeibo_third_id];
    [defaults setObject:@"" forKey:kWx_third_id];
    [defaults setObject:@"" forKey:kQq_third_id];
    [defaults setObject:@"" forKey:kTimeInterval];

    [defaults synchronize];
    
    
        UIApplication *app = [UIApplication sharedApplication];
    
        app.applicationIconBadgeNumber = 0;
    //什么意思
//        UINavigationController *jyMainvc = (UINavigationController *)app.delegate.window.rootViewController;
//        for (int i = 0; i < jyMainvc.viewControllers.count; i++) {
//            id jymainA = jyMainvc.viewControllers[i];
//            if ([jymainA isKindOfClass:[JYMainViewController class]]) {
//                break;
//            }
//        }
    
    NowLoginViewController *nowVc = [NowLoginViewController shareNowLoginViewController];
    [app cancelAllLocalNotifications];
    app.delegate.window.rootViewController = nowVc;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if(kSystemVersion>=10){
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    }
#endif

}

- (void)playSound:(NSString *)soundName atTimeIntervalSinceNow:(NSTimeInterval)time
{
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback  error:nil];
    NSError *error;
    BOOL success = [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
    if(!success){
        NSLog(@"error doing outputaudioportoverride - %@", [error localizedDescription]);
    }
    [audioSession setActive:YES error:nil];
    
    if(_audioPlayer.isPlaying){
        [_audioPlayer stop];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:@""];
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_audioPlayer prepareToPlay];
//    _audioPlayer.numberOfLoops = -1;
    _audioPlayer.delegate = self;
    [_audioPlayer setVolume:1.0];

    if(time>0){
        [_audioPlayer playAtTime:time+_audioPlayer.deviceCurrentTime];
    }else{
        [_audioPlayer play];
    }
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"====finish");
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
//    [BMKMapView willBackGround];//当应用即将后台时调用，停止一切调用opengl相关的操作

//    if(!self.timer){
    
//        [self.timer fire];
//        NSLog(@"init timer========");
//    }
    
//    self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(refreshClock) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    JYNotReadList *notReadList = [JYNotReadList shareNotReadList];
    [notReadList selectNotReadRemind];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(refreshClock) userInfo:nil repeats:NO];
//    
//    self.backgroundTask = [application beginBackgroundTaskWithExpirationHandler:^{
//        [self endBackgroundTask];
//    }];
}
- (void) endBackgroundTask
{
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundTask];
    self.backgroundTask = UIBackgroundTaskInvalid;
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //检查是否在其他设备登陆
    if([[[NSUserDefaults standardUserDefaults] objectForKey:kIsLogin] boolValue]){
        [RequestManager checkIfShuldLogout];
    }
    
//    [self endBackgroundTask];
    
//    if(self.timer){
//        [self.timer invalidate];
//        self.timer = nil;
//    }

}


//点Home键重新进入调用的方法
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //重新初始化计算重复之前的对比数据，
    JYCalculateRandomTime *randomTime = [JYCalculateRandomTime manager];
    randomTime.year = [[Tool actionForNowYear:nil]intValue];
    randomTime.month = [[Tool actionForNowMonth:nil]intValue];
    randomTime.day  = [[Tool actionForNowSingleDay:nil]intValue];
    

    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] != nil && ![[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] isEqualToString:@""]) {
        
        //请求后台数据，同步
        [RequestManager actionForReloadData];
        [RequestManager loadAllPassWordWithResult:^(id responseObject) {
            
        }];
        
        //请求好友列表
        [RequestManager actionForSelectFriendIsNewFriend:NO];
        [RequestManager actionForSelectLoginFriendIsNew:YES];
    }
    
    //更新weather
//    [nowMainVC.jyWeatherView queryWeather];
  
//    application.applicationIconBadgeNumber = 0;
    
    
//    [BMKMapView didForeGround];//当应用恢复前台状态时调用，回复地图的渲染和opengl相关的操作

    if(self.audioPlayer.isPlaying){
//        NSLog(@"xxxxxxxxx");
        [self.audioPlayer stop];
    }
    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if(kSystemVersion>=10){
        [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    }
//#endif
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
     [[NSUserDefaults standardUserDefaults] setObject:@(a) forKey:@"time"];
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kTimeInterval];
}

//3D touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if([shortcutItem.type isEqualToString:@"NewRemind"]){
        self.forceTouchArgument = ForceTouchTypeNewRemind;
    }else if([shortcutItem.type isEqualToString:@"AlarmList"]){
        self.forceTouchArgument = ForceTouchTypeAlarmList;
    }else if([shortcutItem.type isEqualToString:@"ContactList"]){
        self.forceTouchArgument = ForceTouchTypeContactList;
    }else{
        self.forceTouchArgument = ForceTouchTypeNone;
    }
    //说明已经启动进入主页了，简单处理，重新进入主页
    if([self.window.rootViewController isKindOfClass:[RootTabViewController class]]&&self.forceTouchArgument != ForceTouchTypeNone){
        RootTabViewController *rootVC = (RootTabViewController*)self.window.rootViewController;
        
        
        for(UINavigationController *navVC in rootVC.viewControllers){
            [navVC.presentedViewController dismissViewControllerAnimated:NO completion:nil];
            [navVC.visibleViewController dismissViewControllerAnimated:NO completion:nil];
            [navVC popToRootViewControllerAnimated:NO];
            rootVC.selectedIndex = 0;
        }
        [rootVC handle3DTouch];
       
//        if(self.forceTouchArgument==ForceTouchTypeNewRemind){//跳新建提醒
//            self.forceTouchArgument = ForceTouchTypeNone;
//            BaseNavigationController *baseNav = rootVC.viewControllers[0];
//            BaseViewController *baseVC = baseNav.viewControllers[0];
//            int year = [[Tool actionForNowYear:nil] intValue];
//            int month = [[Tool actionForNowMonth:nil] intValue];
//            int day = [[Tool actionForNowSingleDay:nil] intValue];
//            
//            [JYSelectManager shareSelectManager].g_changeDay = day;
//            [JYSelectManager shareSelectManager].g_changeMonth = month;
//            [JYSelectManager shareSelectManager].g_changeYear = year;
//            
//            [baseVC addNewRemind:baseVC];
//        }else if(self.forceTouchArgument==ForceTouchTypeAlarmList){//跳闹钟页
//            self.forceTouchArgument = ForceTouchTypeNone;
//            rootVC.selectedIndex = 3;
//            JYClockVC *jyclockVc = [[JYClockVC alloc] init];
//            jyclockVc.hidesBottomBarWhenPushed = YES;
//            BaseNavigationController *baseNav = rootVC.viewControllers[3];
//            [baseNav pushViewController:jyclockVc animated:YES];
//        }else if(self.forceTouchArgument==ForceTouchTypeContactList){//跳通讯录
//            self.forceTouchArgument = ForceTouchTypeNone;
//            rootVC.selectedIndex = 1;
//        }
//       

    }

    if (completionHandler) {
        completionHandler(YES);
    }
}

@end
