//
//  JYSkinManager.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/19.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSkinManager : NSObject

+ (JYSkinManager *)shareSkinManager;



@property (nonatomic ,strong)NSArray *arrForRed;
@property (nonatomic ,strong)NSArray *arrForPink;
@property (nonatomic ,strong)NSArray *arrForBlue;
@property (nonatomic ,strong)NSArray *arrForGreen;

@property (nonatomic ,strong)NSArray *arrForP_O;
@property (nonatomic ,strong)NSArray *arrForP_R;
@property (nonatomic ,strong)NSArray *arrForP_P;
@property (nonatomic ,strong)NSArray *arrForP_B;
@property (nonatomic ,strong)NSArray *arrForP_G;


@property (nonatomic ,strong)NSArray *arrForSet_R;
@property (nonatomic ,strong)NSArray *arrForSet_P;
@property (nonatomic ,strong)NSArray *arrForSet_B;
@property (nonatomic ,strong)NSArray *arrForSet_G;
@property (nonatomic ,strong)NSArray *arrForSet_O;

//列表底部按钮
@property (nonatomic ,strong)NSArray *arrForList_R;
@property (nonatomic ,strong)NSArray *arrForList_P;
@property (nonatomic ,strong)NSArray *arrForList_B;
@property (nonatomic ,strong)NSArray *arrForList_G;
@property (nonatomic ,strong)NSArray *arrForList_O;


//列表首页按钮
@property (nonatomic ,strong)NSArray *arrForHList_R;
@property (nonatomic ,strong)NSArray *arrForHList_P;
@property (nonatomic ,strong)NSArray *arrForHList_B;
@property (nonatomic ,strong)NSArray *arrForHList_G;


#pragma mark 日历字体颜色
@property (nonatomic ,strong)UIColor *colorForLunar;
@property (nonatomic ,strong)UIColor *colorForSolarHoliday;
@property (nonatomic ,strong)UIColor *colorForSolarNormal;

@property (nonatomic ,strong)UIColor *colorForChineseHoliday;
@property (nonatomic ,strong)UIColor *colorForNormalHoliday;

@property (nonatomic ,strong)UIColor *colorForDateBg;
@property (nonatomic ,strong)UIColor *colorForSelectBg;
@property (nonatomic ,strong)UIColor *btnBackGroundColor;



#pragma mark 天气页面
@property (nonatomic ,strong)UILabel *weatherSoloarLabel;
@property (nonatomic ,strong)UILabel *weatherTemLabel;

#pragma mark 提醒列表
@property (nonatomic ,strong)UIImage *clockImage;
@property (nonatomic ,strong)UIImage *bigClockImage;

@property (nonatomic ,strong)UIImage *addImage;
@property (nonatomic ,strong)UIImage *xitongImage;

@property (nonatomic ,strong)UILabel  *remindEditLabel;
@property (nonatomic ,strong)UIImage  *remindAddBtnImage;

@property (nonatomic ,strong)UIImage *locationImage;
@property (nonatomic ,strong)UIImage *voiceImage;
@property (nonatomic ,strong)UIImage *cameraImage;
@property (nonatomic ,strong)UIImage *putKeyBoardImage;

@property (nonatomic ,strong)UIImage *collectionImage;
@property (nonatomic ,strong)UIImage *collectionImageAlready;
#pragma mark 今天
@property (nonatomic ,strong)UIImage *todayImage;
@property (nonatomic ,strong)UIButton *todayBtn;

#pragma mark 返回按钮
@property (nonatomic ,strong)UIImage *backImage;

#pragma mark 个人中心
@property (nonatomic ,strong)NSArray *arrForPersonImage;

#pragma mark 清单列表
@property (nonatomic ,strong)NSArray *arrForListImage;  //清单底部

@property (nonatomic ,strong)NSArray *selectBtnList;
@property (nonatomic ,strong)UIView  *lineView;


@property (nonatomic,strong) NSString *keywordForSkinColor;//皮肤颜色字: 粉/红...

#pragma mark 密码页钥匙换肤
@property (nonatomic ,strong)UIImage *keyImage;
@property (nonatomic ,strong)NSArray  *detailArr;
@property (nonatomic ,strong)UIImage  *addPassDetail;
@property (nonatomic ,strong)UIImage  *deleteImage;
@property (nonatomic ,strong)UIImage  *confirmImage;


/**
 *  初始化选中按钮颜色
 */
- (void)actionForColorArr;

/**
 *  tb初始化颜色
 */
- (NSArray *)actionForReturnSelectBtnArr:(NSString *)colorStr;

/**
 *  个人中心初始化颜色
 */
- (NSArray *)actionForReturnSelectPersonImage:(NSString *)colorStr;

/**
 *  设置初始化
 */
- (NSArray *)actionForReturnSelectSetImage:(NSString *)colorStr;


/**
 *  更改选中日历背景颜色
 */
- (void)actionForBgColor:(NSString *)colorStr;

/**
 *  改变主题
 */
- (void)actionForChangeSkin:(NSString *)colorStr;


@end
