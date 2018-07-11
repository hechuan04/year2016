//
//  JYRemindNoPassPeopleVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/1/13.
//  Copyright (c) 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYContentTexgFiled.h"
#import "JYContentTextView.h"
#import "SDPhotoBrowser.h"
#import "MapViewController.h"

@interface JYRemindNoPassPeopleVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SDPhotoBrowserDelegate>


@property (nonatomic ,strong)RemindModel *model;

@property (nonatomic ,strong)JYContentTexgFiled *titleField;

@property (strong, nonatomic)JYContentTextView*contentView;

@property (nonatomic ,assign)int ringID;
@property (nonatomic ,assign)int isOn;

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic,assign) NSInteger mid;//提醒id 说明跳转自收藏列表
@property (nonatomic,assign) BOOL isFromOther;//接受的提醒,显示收藏详情用

@end
