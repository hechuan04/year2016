//
//  JYSelectManager.h
//  rilixiugai
//
//  Created by 吴冬 on 15/11/26.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYSelectManager : NSObject
+ (JYSelectManager *)shareSelectManager;
//存储之前的Label，collection
@property (nonatomic ,strong)NSArray *arrForCollection;
@property (nonatomic ,copy)NSAttributedString *strForCollectionLabel;

//存储对应的月份
@property (nonatomic ,strong)NSDictionary *dicForAllMonth;
@property (nonatomic ,strong)NSDictionary *dicForAllYear;
@property (nonatomic ,strong)NSDictionary *dicForAllDay;

//全部的月、日
@property (nonatomic ,strong)NSArray *arrForAllLunarDay;
@property (nonatomic ,strong)NSArray *arrForAllLunarMonth;

//字体适配
@property (nonatomic ,strong)UIFont *fontForSolar;
@property (nonatomic ,strong)UIFont *fontForLunar;

@property (nonatomic ,strong)NSDictionary *chineseHoliday;
@property (nonatomic ,strong)NSDictionary *noWorkHoliday;
@property (nonatomic ,strong)NSDictionary *worldHoliday;

//@property (nonatomic ,strong)NSDictionary *workDic;
//@property (nonatomic ,strong)NSDictionary *restDic;

//存储之前的label,label;
@property (nonatomic ,strong)UILabel *labelForBefore;
@property (nonatomic ,copy)NSAttributedString *strForBeforeLabel;
@property (nonatomic ,strong)UIView  *viewForPoint;
@property (nonatomic ,assign)BOOL isHiddenPoint;
@property (nonatomic ,assign)int musicId;

//记录的一直在变的时间
@property (nonatomic ,assign)int g_changeYear;
@property (nonatomic ,assign)int g_changeMonth;
@property (nonatomic ,assign)int g_changeDay;

@property (nonatomic ,assign)int g_notChangeYear;
@property (nonatomic ,assign)int g_notChangeMonth;
@property (nonatomic ,assign)int g_notChangeDay;

@property (nonatomic ,assign)int nowMonth;

//记录当天的Label tag
@property (nonatomic ,assign)int todayTag;
//记录选中的Label tag
@property (nonatomic ,assign)int selectTag;
//记录是否是刷新的结果
@property (nonatomic ,assign)BOOL isLoad;

//重复时间，记录之前选中的cell
@property (nonatomic ,strong)UITableViewCell *cell;


//更改全局时间方法
- (void)actionForChangeDateWithYear:(int )year
                              month:(int )month
                                day:(int )day;


//改变日
- (void)actionForChangeSingleDay:(int )day;


@property (nonatomic ,strong)NSString *linshiUid;





@end
