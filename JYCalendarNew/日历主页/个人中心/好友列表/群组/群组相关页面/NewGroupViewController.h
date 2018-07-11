//
//  NewGroupViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/12/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGroupViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)UIImageView *imgForNoGroup;

@end
