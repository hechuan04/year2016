//
//  BaseLoad.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/24.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseLoad.h"

@implementation BaseLoad

+ (void)load
{
    //初始化皮肤管家单例
    [BaseLoad skinAction];

}

+ (void)skinAction
{
 
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    //初始化tb按钮颜色
    [skinManager actionForColorArr];
    //初始化选中日期背景颜色
    [skinManager actionForBgColor:[[NSUserDefaults standardUserDefaults] objectForKey:kUserSkin]];
    

    
    skinManager.colorForLunar = [UIColor blackColor];
    skinManager.colorForNormalHoliday = [UIColor colorWithRed:84 / 255.0 green:119 / 255.0 blue:171 / 255.0 alpha:1];
    skinManager.colorForChineseHoliday = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
    
    skinManager.colorForSolarHoliday = skinManager.colorForDateBg;
    skinManager.colorForSolarNormal = [UIColor blackColor];
    NSString *colorStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSkin];
    if(colorStr.length>0 && ![colorStr isKindOfClass:[NSNull class]]){
        if([colorStr isEqualToString:@"红色"]){
            skinManager.keywordForSkinColor = @"暗红";
        }else{
            skinManager.keywordForSkinColor = colorStr;
        }
    }else{
        skinManager.keywordForSkinColor = @"暗红";
    }
  

    
}

@end
