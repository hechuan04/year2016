//
//  AppDelegate.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/10.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger,ForceTouchType){
    ForceTouchTypeNone = 0,
    ForceTouchTypeNewRemind,
    ForceTouchTypeAlarmList,
    ForceTouchTypeContactList
};

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) NSUserDefaults *defaults;

@property (nonatomic,assign) ForceTouchType forceTouchArgument;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,copy) NSString *soundName;
@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundTask;

@property (nonatomic,strong) AVAudioPlayer *audioPlayer;

@property (nonatomic,assign) BOOL logout;

- (void)logoutIfRequestServer:(BOOL)flag;

- (void)playSound:(NSString *)soundName atTimeIntervalSinceNow:(NSTimeInterval)time;
@end
