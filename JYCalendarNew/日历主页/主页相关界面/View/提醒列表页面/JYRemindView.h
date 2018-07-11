//
//  JYRemindView.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYAlreadyTableView.h"
#import "JYAwaitTableView.h"


typedef void(^editAction)(BOOL isEdit,BOOL isUpScroll);
typedef void(^addAction)();

@interface JYRemindView : UIView

@property (nonatomic ,strong)UIButton *btnForEdit;
@property (nonatomic ,strong)UIButton *btnForAdd;

@property (nonatomic ,strong)JYAlreadyTableView *alreayTableView;
@property (nonatomic ,strong)JYAwaitTableView   *awaitTableView;

@property (nonatomic ,copy)editAction editAction;
@property (nonatomic ,copy)addAction addAction;

//编辑按钮的Label
@property (nonatomic ,strong)UILabel *label;

@property (nonatomic ,strong)UILabel *labelForLookNumber;

@property (nonatomic ,strong)AddSMSegmentView *sobj;

@property (nonatomic ,assign)BOOL isEdit;

@property (nonatomic,strong) UIImageView *dragImageView;

- (void)actionForEdit:(UIButton *)sender;


@end