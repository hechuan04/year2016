//
//  JYSkinManager.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/19.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYSkinManager.h"

static JYSkinManager *skinManager = nil;

@implementation JYSkinManager

+ (JYSkinManager *)shareSkinManager
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (skinManager == nil) {
            
            skinManager = [[JYSkinManager alloc] init];
        }
        
    });
    
    return skinManager;
    
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        if (skinManager == nil) {
            
            skinManager = [super allocWithZone:zone];
        }
        
    });

    return skinManager;
}

- (void)actionForColorArr
{
 
    _arrForRed = @[@"rl红",@"lb红",@"tj红",@"txl红",@"w红"];
    _arrForPink =  @[@"rl粉",@"lb粉",@"tj粉",@"txl粉",@"w粉"];
    _arrForBlue =  @[@"rl蓝",@"lb蓝",@"tj蓝",@"txl蓝",@"w蓝"];
    _arrForGreen =  @[@"rl绿",@"lb绿",@"tj绿",@"txl绿",@"w绿"];
    
    _arrForP_R = [self _arrForPerson:@"红"];
    _arrForP_B = [self _arrForPerson:@"蓝"];
    _arrForP_G = [self _arrForPerson:@"绿"];
    _arrForP_P = [self _arrForPerson:@"粉"];
    _arrForP_O = [self _arrForPerson:@"橙"];
    
    _arrForSet_R = [self _arrForSet:@"红"];
    _arrForSet_B = [self _arrForSet:@"蓝"];
    _arrForSet_G = [self _arrForSet:@"绿"];
    _arrForSet_P = [self _arrForSet:@"粉"];
    _arrForSet_O = [self _arrForSet:@"橙"];

    _arrForList_R = @[@"all_A",@"delete_A",@"share_A",@"top_A",@"cancel_A"];
    //_arrForList_R = @[@"all_R",@"delete_R",@"share_R",@"top_R",@"cancel_R"];
    _arrForList_B = @[@"all_B",@"delete_B",@"share_B",@"top_B",@"cancel_B"];
    _arrForList_G = @[@"all_G",@"delete_G",@"share_G",@"top_G",@"cancel_G"];
    _arrForList_P = @[@"all_P",@"delete_P",@"share_P",@"top_P",@"cancel_P"];
    _arrForList_O = @[@"all_O",@"delete_O",@"share_O",@"top_O",@"cancel_O"];
    
    
    _arrForHList_R = @[@"全部_R",@"已发_R",@"收到_R",@"分享_R",@"系统消息_R"];
    _arrForHList_B = @[@"全部_B",@"已发_B",@"收到_B",@"分享_B",@"系统消息_B"];
    _arrForHList_G = @[@"全部_G",@"已发_G",@"收到_G",@"分享_G",@"系统消息_G"];
    _arrForHList_P = @[@"全部_P",@"已发_P",@"收到_P",@"分享_P",@"系统消息_P"];

}

- (NSArray *)_arrForSet:(NSString *)color
{
    
    NSMutableArray *arrForColor = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 6; i++) {
        NSString *strForPerson = @"";
        if ([color isEqualToString:@"红"]) {
            
            strForPerson = [NSString stringWithFormat:@"设置暗红%d",i+1];
            
        }else if([color isEqualToString:@"蓝"]){
            
            strForPerson = [NSString stringWithFormat:@"设置蓝%d",i+1];
            
        }else if([color isEqualToString:@"绿"]){
            
            strForPerson = [NSString stringWithFormat:@"设置绿%d",i+1];
            
        }else if([color isEqualToString:@"粉"]){
            
            strForPerson = [NSString stringWithFormat:@"设置粉%d",i+1];
            
        }else if([color isEqualToString:@"暗红"]){
            strForPerson = [NSString stringWithFormat:@"设置暗红%d",i+1];

        }else{
            strForPerson = [NSString stringWithFormat:@"设置橙%d",i+1];

        }
        
        [arrForColor addObject:strForPerson];
    }
    
    return arrForColor;
    
}

- (NSArray *)_arrForPerson:(NSString *)color
{
   
    NSMutableArray *arrForColor = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        NSString *strForPerson = @"";
        if ([color isEqualToString:@"红"]) {
           
            strForPerson = [NSString stringWithFormat:@"暗红%d",i+1];

        }else if([color isEqualToString:@"蓝"]){
         
            strForPerson = [NSString stringWithFormat:@"蓝%d",i+1];
            
        }else if([color isEqualToString:@"绿"]){
         
            strForPerson = [NSString stringWithFormat:@"绿%d",i+1];
            
        }else if([color isEqualToString:@"橙"]){
            
            strForPerson = [NSString stringWithFormat:@"橙%d",i+1];

        }else if([color isEqualToString:@"暗红"]){
            strForPerson = [NSString stringWithFormat:@"暗红%d",i+1];

        }else{
            strForPerson = [NSString stringWithFormat:@"粉%d",i+1];

        }
        
        [arrForColor addObject:strForPerson];
    }
    
    return arrForColor;
    
}

- (NSArray *)actionForReturnSelectSetImage:(NSString *)colorStr
{
    
    
    if ([colorStr isEqualToString:@"蓝色"]){
        
        return _arrForSet_B;
        
        
    }else if ([colorStr isEqualToString:@"绿色"]){
        
        return _arrForSet_G;
        
        
    }else if ([colorStr isEqualToString:@"粉色"]){
        
        return _arrForSet_P;
        
    }else{
        
        return _arrForSet_R;
        
    }
    
    
    return nil;
    
}

- (NSArray *)actionForReturnSelectPersonImage:(NSString *)colorStr
{
    
    
    if ([colorStr isEqualToString:@"蓝色"]){
        
        return _arrForP_B;
        
        
    }else if ([colorStr isEqualToString:@"绿色"]){
        
        return _arrForP_G;
        
    }else if ([colorStr isEqualToString:@"粉色"]){
        
        return _arrForP_P;
        
    }else if([colorStr isEqualToString:@"橙色"]){
    
        return _arrForP_O;
    }else if([colorStr isEqualToString:@"暗红"]){
     
        return _arrForP_R;

    }else{
        return _arrForP_R;
    }
    
    
    return nil;
    
}

- (NSArray *)actionForReturnSelectBtnArr:(NSString *)colorStr
{
 
   
    if ([colorStr isEqualToString:@"红色"]) {
        
        return _arrForRed;
        
    }else if ([colorStr isEqualToString:@"蓝色"]){
        
        return _arrForBlue;
        
        
    }else if ([colorStr isEqualToString:@"绿色"]){
        
        return _arrForGreen;
        
        
    }else if ([colorStr isEqualToString:@"粉色"]){
        
        return _arrForPink;
        
    }else if([colorStr isEqualToString:@"橙色"]){
    
        return nil;
    }
    
    
    return nil;

}

- (void )actionForBgColor:(NSString *)colorStr
{
    
    _detailArr = nil;

    if ([colorStr isEqualToString:@"蓝色"]){

        
        _detailArr = @[@"bt_B",@"yh_B",@"mm_B",@"ms_B"];
        _addPassDetail = [UIImage imageNamed:@"xj_B"];
        _xitongImage = [UIImage imageNamed:@"系统消息_B.png"];
        _colorForDateBg = bgBlueColor;
        self.arrForListImage = _arrForList_B;
        
        self.clockImage = [UIImage imageNamed:@"蓝闹钟"];

        self.remindEditLabel.textColor = bgBlueColor;
        self.remindAddBtnImage = [UIImage imageNamed:@"蓝添加"];
        self.backImage = [UIImage imageNamed:@"返回蓝"];
        self.bigClockImage = [UIImage imageNamed:@"闹钟大蓝"];
        self.addImage = [UIImage imageNamed:@"蓝添加"];
        
        self.locationImage = [UIImage imageNamed:@"蓝位置"];
        self.voiceImage = [UIImage imageNamed:@"蓝语音"];
        self.cameraImage = [UIImage imageNamed:@"蓝相机"];
     
        self.collectionImageAlready = [UIImage imageNamed:@"sc蓝实心"];
        self.btnBackGroundColor = [UIColor colorWithRed:201 / 255.0 green:237 / 255.0 blue:251 / 255.0 alpha:1];
        self.keyImage = [UIImage imageNamed:@"ys_B"];
        self.confirmImage = [UIImage imageNamed:@"bc_B"];
        self.deleteImage  = [UIImage imageNamed:@"sc_pass_B"];
        self.putKeyBoardImage = [UIImage imageNamed:@"收回键盘蓝.png"];
        
    }else if ([colorStr isEqualToString:@"绿色"]){
        
        _detailArr = @[@"bt_G",@"yh_G",@"mm_G",@"ms_G"];
        _addPassDetail = [UIImage imageNamed:@"xj_G"];
        _xitongImage = [UIImage imageNamed:@"系统消息_G.png"];

        
        _colorForDateBg = bgGreenColor;
        self.arrForListImage = _arrForList_G;
        self.clockImage = [UIImage imageNamed:@"绿闹钟"];
     
        self.remindEditLabel.textColor = bgGreenColor;
        self.remindAddBtnImage = [UIImage imageNamed:@"绿添加"];
      
        self.backImage = [UIImage imageNamed:@"返回绿"];
        self.locationImage = [UIImage imageNamed:@"绿位置"];
        self.voiceImage = [UIImage imageNamed:@"绿语音"];
        self.cameraImage = [UIImage imageNamed:@"绿相机"];
        
        self.bigClockImage = [UIImage imageNamed:@"闹钟大绿"];
        self.addImage = [UIImage imageNamed:@"绿添加"];
        
        self.collectionImageAlready = [UIImage imageNamed:@"sc绿实心"];
        self.btnBackGroundColor = [UIColor colorWithRed:205 / 255.0 green:243 / 255.0 blue:205 / 255.0 alpha:1];
        self.keyImage = [UIImage imageNamed:@"ys_G"];
        self.confirmImage = [UIImage imageNamed:@"bc_G"];
        self.deleteImage  = [UIImage imageNamed:@"sc_pass_G"];
        self.putKeyBoardImage = [UIImage imageNamed:@"收回键盘绿.png"];


    }else if ([colorStr isEqualToString:@"粉色"]){
        
        _detailArr = @[@"bt_P",@"yh_P",@"mm_P",@"ms_P"];
        _addPassDetail = [UIImage imageNamed:@"xj_P"];
        _xitongImage = [UIImage imageNamed:@"系统消息_P.png"];

        _colorForDateBg = bgPinkColor;
        self.arrForListImage = _arrForList_P;
        self.clockImage = [UIImage imageNamed:@"粉闹钟"];
    
        self.remindEditLabel.textColor = bgPinkColor;
        self.remindAddBtnImage = [UIImage imageNamed:@"粉添加"];
        self.backImage = [UIImage imageNamed:@"返回粉"];
        
        self.locationImage = [UIImage imageNamed:@"粉位置"];
        self.voiceImage = [UIImage imageNamed:@"粉语音"];
        self.cameraImage = [UIImage imageNamed:@"粉相机"];
        
        self.bigClockImage = [UIImage imageNamed:@"闹钟大粉"];
        self.addImage = [UIImage imageNamed:@"粉添加"];

   
        self.collectionImageAlready = [UIImage imageNamed:@"sc粉实心"];
 self.btnBackGroundColor = [UIColor colorWithRed:255 / 255.0 green:222 / 255.0 blue:232 / 255.0 alpha:1];
        self.keyImage = [UIImage imageNamed:@"ys_P"];
        self.confirmImage = [UIImage imageNamed:@"bc_P"];
        self.deleteImage  = [UIImage imageNamed:@"sc_pass_P"];
        self.putKeyBoardImage = [UIImage imageNamed:@"收回键盘粉.png"];

    }else if([colorStr isEqualToString:@"红色"]){
        
        //_detailArr = @[@"bt_R",@"yh_R",@"mm_R",@"ms_R"];
        _detailArr = @[@"bt_A",@"yh_A",@"mm_A",@"ms_A"];

        _addPassDetail = [UIImage imageNamed:@"xj_A"];
        _xitongImage = [UIImage imageNamed:@"系统消息_A.png"];

        _colorForDateBg = bgRedColor;
        self.arrForListImage = _arrForList_R;
        self.clockImage = [UIImage imageNamed:@"暗红闹钟"];
     
        self.remindEditLabel.textColor = bgRedColor;
        self.remindAddBtnImage = [UIImage imageNamed:@"暗红添加"];
        self.backImage = [UIImage imageNamed:@"返回暗红"];
        
        self.locationImage = [UIImage imageNamed:@"暗红位置"];
        self.voiceImage = [UIImage imageNamed:@"暗红语音"];
        self.cameraImage = [UIImage imageNamed:@"暗红相机"];

        self.bigClockImage = [UIImage imageNamed:@"闹钟大暗红"];
        self.addImage = [UIImage imageNamed:@"暗红添加"];
 
//        self.collectionImageAlready = [UIImage imageNamed:@"sc红实心"];
        self.collectionImageAlready = [UIImage imageNamed:@"sc暗红实心"];

 self.btnBackGroundColor = [UIColor colorWithRed:251 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
//        self.keyImage = [UIImage imageNamed:@"ys_R"];
//        self.confirmImage = [UIImage imageNamed:@"bc_R"];
//        self.deleteImage  = [UIImage imageNamed:@"sc_pass_R"];
        //self.putKeyBoardImage = [UIImage imageNamed:@"收回键盘红.png"];
        
        self.keyImage = [UIImage imageNamed:@"ys_A"];
        self.confirmImage = [UIImage imageNamed:@"bc_A"];
        self.deleteImage  = [UIImage imageNamed:@"sc_pass_A"];
        self.putKeyBoardImage = [UIImage imageNamed:@"收回键盘暗红.png"];

    }else{
    
        _detailArr = @[@"bt_O",@"yh_O",@"mm_O",@"ms_O"];
        _addPassDetail = [UIImage imageNamed:@"xj_R"];
        _xitongImage = [UIImage imageNamed:@"系统消息_R.png"];
        
        _colorForDateBg = bgOrangeColor;
        self.arrForListImage = _arrForList_O;
        self.clockImage = [UIImage imageNamed:@"橙闹钟"];
     
        self.remindEditLabel.textColor = bgOrangeColor;
        self.remindAddBtnImage = [UIImage imageNamed:@"橙添加"];
        self.backImage = [UIImage imageNamed:@"返回橙"];
        
        self.locationImage = [UIImage imageNamed:@"橙位置"];
        self.voiceImage = [UIImage imageNamed:@"橙语音"];
        self.cameraImage = [UIImage imageNamed:@"橙相机"];
        
        self.bigClockImage = [UIImage imageNamed:@"闹钟大橙"];
        self.addImage = [UIImage imageNamed:@"橙添加"];
        
        self.collectionImageAlready = [UIImage imageNamed:@"sc橙实心"];
        self.btnBackGroundColor = [UIColor colorWithRed:251 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
        self.keyImage = [UIImage imageNamed:@"ys_O"];
        self.confirmImage = [UIImage imageNamed:@"bc_O"];
        self.deleteImage  = [UIImage imageNamed:@"sc_pass_O"];
        self.putKeyBoardImage = [UIImage imageNamed:@"收回键盘橙.png"];
    }

    self.collectionImage = [UIImage imageNamed:@"sc蓝"];

}

//换肤方法
- (void)actionForChangeSkin:(NSString *)colorStr
{
 
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    
    [self actionForBgColor:colorStr];
    if([colorStr isEqualToString:@"红色"]){
        _keywordForSkinColor = @"暗红";
    }else{
        _keywordForSkinColor = colorStr;
    }
    
    
    NSArray *_arrForSelect = [self actionForReturnSelectBtnArr:colorStr];
    
    
    //改变选中的label颜色
    JYSelectManager *selectManager = [JYSelectManager shareSelectManager];
    
    selectManager.labelForBefore.backgroundColor = _colorForDateBg;
    
    
   
    
    //列表按钮
    for (UIButton *selectBtn in self.selectBtnList) {
        
        [selectBtn setTitleColor:self.colorForDateBg forState:UIControlStateSelected];
    }

    
    //今天按钮
    [self.todayBtn setImage:self.todayImage forState:UIControlStateNormal];
    
    _weatherSoloarLabel.textColor = self.colorForDateBg;
    _weatherTemLabel.textColor = self.colorForDateBg;
    self.colorForSolarHoliday = self.colorForDateBg;

    self.lineView.backgroundColor = self.colorForDateBg;

    
    
    //更改点的颜色
    [notification postNotificationName:kNotificationForLoadData object:@""];
    
    NSDictionary *dic = @{@"bgColor":self.colorForDateBg};
    
    //改变发送、接受栏的颜色
    [notification postNotificationName:kNotificationForChangeSelectBg object:nil userInfo:dic];
   
    //改变个人中心按钮颜色
    NSArray *arrForPer = [self actionForReturnSelectPersonImage:colorStr];
    NSDictionary *dic1 = @{@"arr":arrForPer};

    //更改个人中心颜色
    [notification postNotificationName:kNotificationForPersonSkin object:@"" userInfo:dic1];
    
    //更改设置页面颜色
    NSArray *arrForSet = [self actionForReturnSelectSetImage:colorStr];
    NSDictionary *dic2 = @{@"arr":arrForSet};
    
    [notification postNotificationName:kNotificationForSetSkin object:@"" userInfo:dic2];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForListSkin object:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForChangeSkin object:nil];
}

- (NSString *)keywordForSkinColor
{
    if(!_keywordForSkinColor){
        NSString *colorStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserSkin];
        if(colorStr.length>0 && ![colorStr isKindOfClass:[NSNull class]]){
            if([colorStr isEqualToString:@"红色"]){
                _keywordForSkinColor = @"暗红";
            }else{
                _keywordForSkinColor = colorStr;
            }
        }else{
            _keywordForSkinColor = @"暗红";
        }
    }
    return _keywordForSkinColor;
}
@end
