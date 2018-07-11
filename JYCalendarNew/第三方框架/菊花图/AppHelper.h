//
//  AppHelper.h
//  faceSocial
//
//  Created by 何川 on 14-7-21.
//  Copyright (c) 2014年 西三环科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface AppHelper : NSObject

+ (void)showHUD:(NSString *)msg;

+ (void)removeHUD;

+ (void)changeAndRemoveHudText:(NSString *)text
                          time:(CGFloat )time;

@property (nonatomic ,strong)MBProgressHUD *HUD;

@end
