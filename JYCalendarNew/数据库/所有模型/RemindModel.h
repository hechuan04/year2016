//
//  RemindModel.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/16.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#pragma mark 自定义的type在这里
typedef NS_ENUM(NSInteger ,TABLE_TYPE) {
    
    table_today = 500,
    tabel_accept,
    table_send,
    table_share,
    table_system,
};

typedef NS_ENUM(int , typeForRandom){
    
    selectNoRepeats = 0,
    selectMonday = 1,
    selectTuesday = 2,
    selectWednesday = 3,
    selectThursday = 4,
    selectFriday = 5,
    selectSaturday = 6,
    selectSunday = 7,
    selectEveryDay = 8,
    selectEveryMonth = 9,
    selectEveryYear = 10,
    selectDay = 11,
    selectWeek = 12,
    selectMonth = 13,
    selectYear = 14,
    selectSomeDays = 15

 
    
};

@interface RemindModel : NSObject


@property (nonatomic ,assign)int index; //上传排序


@property (nonatomic ,assign)int year_random;
@property (nonatomic ,assign)int month_random;
@property (nonatomic ,assign)int day_random;


@property (nonatomic ,assign)int isOn;
@property (nonatomic ,assign)int year;
@property (nonatomic ,assign)int month;
@property (nonatomic ,assign)int day;
@property (nonatomic ,assign)int hour;
@property (nonatomic ,assign)int minute;
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,copy)NSString *content;
@property (nonatomic ,copy)NSString *timeorder;
@property (nonatomic ,copy)NSString *createTime;
@property (nonatomic ,copy)NSString *isTop;
@property (nonatomic ,assign)int isShare;
@property (nonatomic ,assign)int uid;
@property (nonatomic ,assign)int oid;
@property (nonatomic ,assign)int sid;
@property (nonatomic ,assign)int isSave;
@property (nonatomic ,assign)int musicName;
@property (nonatomic ,assign)int countNumber;
@property (nonatomic ,assign)int randomType;
@property (nonatomic ,assign)int isOther;  //涉及别人的提醒
@property (nonatomic ,assign)int keystatus;
@property (nonatomic ,copy)NSString *strForRepeat;
@property (nonatomic ,assign)BOOL upData;
@property (nonatomic ,copy)NSString *localInfo;
@property (nonatomic ,copy)NSString *latitudeStr; // 纬度
@property (nonatomic ,copy)NSString *longitudeStr; // 经度
@property (nonatomic ,strong)NSArray *files;
@property (nonatomic ,strong)NSString *headUrlStr;
@property (nonatomic ,strong)NSString *weekStr;
@property (nonatomic,copy) NSString *audioPathStr;//音频路径拼串，逗号分割
@property (nonatomic,copy) NSString *audioRemoteStr;//音频远程路径拼串
@property (nonatomic,copy) NSString *audioDurationStr;//音频时长拼串，逗号分割
//id拼串
@property (nonatomic ,copy)NSString *gidStr;
@property (nonatomic ,copy)NSString *fidStr;
//姓名拼串
@property (nonatomic ,copy)NSString *friendName;
@property (nonatomic ,copy)NSString *groupName;

@property (nonatomic ,assign)BOOL isRemind;  //用于显示闹钟,是否过了提醒时间
@property (nonatomic ,assign)BOOL isOtherRemind; //用于判断是否是其他人的提醒（专用于闹钟）

//判断是否看过
@property (nonatomic ,assign)BOOL isLook;

@property (nonatomic, assign) NSInteger offsetMinute;//提前响铃分钟数

#pragma mark -数据操作方法

/**
 *  单个删除数据方法
 */
+ (void)deleteWithModel:(RemindModel *)model;


/**
 *  收藏数据方法
 */
+ (void)collectionWithModel:(RemindModel *)model;


/**
 *  push方法
 */
+ (UIViewController *)pushModel:(RemindModel *)model
                       delegate:(id )vc;

/**
 *  删除多条数据方法
 */
+ (void)deleteMoreModel:(NSArray *)data;


/**
 *  置顶数据
 */
+ (void)topAction:(NSMutableArray *)data;



/**
 *  分享方法
 */
+ (void)shareWithFriendArr:(NSArray *)arrForF
                  groupArr:(NSArray *)arrForG
                     model:(NSArray <RemindModel *>*)data
                   headStr:(NSString *)headStr;


//时差
- (void)setSystemTime;

@end
