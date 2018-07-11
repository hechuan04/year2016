//
//  JYRepeatViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/1.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^RepeatAction)(RemindModel *model);

@interface JYRepeatViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic ,strong)UITableView *timeTableView;

@property (nonatomic ,copy)RepeatAction repeatAction;
@property (nonatomic ,strong)RemindModel *model;
@property (nonatomic ,strong)NSString * weekString;
@property (nonatomic ,strong)NSMutableArray * weekArray;

@property (nonatomic ,strong)UIButton *btnForDay;
@property (nonatomic ,strong)UIButton *btnForWeek;
@property (nonatomic ,strong)UIButton *btnForMonth;
@property (nonatomic ,strong)UIButton *btnForYear;

@property (nonatomic ,strong)JYSelectManager *manager;

@end
