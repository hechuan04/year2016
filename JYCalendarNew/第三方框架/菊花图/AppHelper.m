//
//  AppHelper.m
//  faceSocial
//
//  Created by 何川 on 14-7-21.
//  Copyright (c) 2014年 西三环科技有限公司. All rights reserved.
//

#import "AppHelper.h"

static AppHelper *managerHelper = nil;
@implementation AppHelper


+ (AppHelper *)helperManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (managerHelper == nil) {
            managerHelper = [[AppHelper alloc] init];
        }
    });
    
    return managerHelper;
}


//MBProgressHUD 的使用方式，只对外两个方法，可以随时使用(但会有警告！)，其中窗口的 alpha值 可以在源程序里修改。
+ (void)showHUD:(NSString *)msg{
    
    /*
    if ([AppHelper helperManager].HUD == nil) {
    
        managerHelper.HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
        [[UIApplication sharedApplication].keyWindow addSubview:managerHelper.HUD];
        managerHelper.HUD.dimBackground = YES;
        managerHelper.HUD.labelText = msg;
        [managerHelper.HUD show:YES];
        
    }
    */
	
}

+ (void)changeAndRemoveHudText:(NSString *)text time:(CGFloat )time
{
    /*
    managerHelper.HUD.labelText = text;
    [AppHelper performSelector:@selector(removeHUD) withObject:nil afterDelay:time];
     */
}

+ (void)removeHUD{
    
	[managerHelper.HUD hide:YES];
	[managerHelper.HUD removeFromSuperViewOnHide];
	[managerHelper.HUD release];
    managerHelper.HUD = nil;
    
    NSLog(@"%@",managerHelper.HUD);
    
}

@end