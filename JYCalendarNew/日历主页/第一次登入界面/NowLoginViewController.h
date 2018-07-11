//
//  NowLoginViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/9.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "ShowScrollView.h"

@interface NowLoginViewController:UIViewController<UITextFieldDelegate>

+ (NowLoginViewController *)shareNowLoginViewController;

@property (nonatomic ,assign)CGFloat heightForBtn;
@property (nonatomic ,strong)UIFont  *btnTitleFontl;

@end