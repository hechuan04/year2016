//
//  JYRemindOtherVC.h
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/18.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYContentTexgFiled.h"
#import "JYContentTextView.h"
#import "SDPhotoBrowser.h"

@interface JYRemindOtherVC : UIViewController<UITableViewDataSource,UITableViewDelegate,SDPhotoBrowserDelegate>

@property (nonatomic ,strong)RemindModel *model;

@property (nonatomic ,strong)JYContentTexgFiled*titleField;

@property (strong, nonatomic)JYContentTextView*contentView;

@property (nonatomic ,assign)int ringID;
@property (nonatomic ,assign)int isOn;

@property (nonatomic ,strong)UITableView *tableView;

@end
