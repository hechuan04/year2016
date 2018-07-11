//
//  JYAwaitTableView.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^actionForDeleteModel)(RemindModel *model);

@interface JYAwaitTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                   andWaitArr:(NSArray *)arrForWait;

@property (nonatomic ,strong)NSArray *arrForWait;

/**
 *  数据有变动，重新加载
 *
 *  @param year  <#year description#>
 *  @param month <#month description#>
 *  @param day   <#day description#>
 */
- (BOOL)loadData:(int )year
           month:(int )month
             day:(int )day
   isAwaysChange:(BOOL )isAwaysChange;

@property (nonatomic ,copy)actionForDeleteModel actionForDeleteModel;

@property (nonatomic ,copy)void (^actionForModel)(RemindModel *model,BOOL canEdit ,BOOL isLocal);

@property (nonatomic ,assign)int year;
@property (nonatomic ,assign)int month;
@property (nonatomic ,assign)int day;

@end
