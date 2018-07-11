//
//  JYAlreadyTableView.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^actionForModel)(RemindModel *model);
typedef void(^actionForDeleteModel)(RemindModel *model);

@interface JYAlreadyTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                andAlreadyArr:(NSArray *)alreadyArr;


@property (nonatomic ,strong)NSArray *otherArr;
@property (nonatomic ,strong)NSArray *friendArr;

/**
 *  数据有变动，重新加载
 */
- (BOOL)loadData:(int )year
           month:(int )month
             day:(int )day
   isAwaysChange:(BOOL )isAwaysChange;

@property (nonatomic ,copy)actionForModel actionForModel;
@property (nonatomic ,copy)actionForDeleteModel actionForDeleteModel;

@property (nonatomic ,copy)void (^actionForChangeLookLabel)(int numberLook);

@property (nonatomic ,assign)int year;
@property (nonatomic ,assign)int month;
@property (nonatomic ,assign)int day;

@property (nonatomic ,strong)JYSkinManager *skinManager;
@property (nonatomic ,assign)int countForNotLookNumber; //没看过的信息数量

@end
