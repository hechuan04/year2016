//
//  JYMusicViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/1.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemindModel.h"

@interface JYMusicViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *musicTabelView;

@property (nonatomic ,copy)void(^actionForMusicName)(int MusicName);

@property (nonatomic ,strong)RemindModel *model;

@property (nonatomic ,assign)BOOL isClock;

@end
