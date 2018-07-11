//
//  JYPersonMeansViewController.h
//  JYCalendar
//
//  Created by 吴冬 on 15/11/19.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYPersonMeansViewController : UIViewController

@property (nonatomic ,strong)UIImage *userHead;
@property (nonatomic ,strong)UIImage *bar;
@property (nonatomic ,copy)NSString *name;
@property (nonatomic ,assign)BOOL isChangePic;
@property (nonatomic ,assign)BOOL isChangeName;

@property (nonatomic,assign)BOOL sexChanged;
@property (nonatomic,assign)BOOL locationChanged;
@property (nonatomic,assign)BOOL signChanged;

@property (nonatomic ,copy)void (^acitonForReloadTb)(UIImage *image ,NSString *nowName);

@end
