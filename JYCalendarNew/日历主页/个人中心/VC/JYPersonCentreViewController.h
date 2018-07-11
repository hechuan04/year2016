//
//  JYPersonCentreViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYMainViewController.h"
#import "BaseViewController.h"

@interface JYPersonCentreViewController : BaseViewController

@property (nonatomic ,strong)UIImageView *userHead;
@property (nonatomic ,strong)UILabel     *userName;
@property (nonatomic ,strong)UILabel     *userNumber;
@property (nonatomic ,strong)UIImage     *barImage;

@property (nonatomic ,copy)void(^actionForHiddenToday)();

@property (nonatomic ,strong)ManagerForButton *managerForBtn;
@property (nonatomic ,strong) UITableView *setTableView;
@property (nonatomic ,strong)UIImage *imageForBg;


@end
