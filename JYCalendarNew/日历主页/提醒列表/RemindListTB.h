//
//  RemindListTB.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYRemindListVC.h"
@interface RemindListTB : UITableView<UITableViewDataSource,UITableViewDelegate,JYRemindViewControllerDelegate>

@property (nonatomic ,strong)NSArray *arrForModel;
@property (nonatomic ,strong)NSArray *friendArr;

@property (nonatomic,strong) NSDictionary *unreadDictionary;

@property (nonatomic ,assign)BOOL isSearch;


@property (nonatomic ,copy)void (^pushList)(NSInteger index);
@property (nonatomic ,copy)void (^pushModel)(RemindModel *model);

@property (nonatomic ,strong)JYSkinManager *skinManager;
@property (nonatomic,strong) UIImageView *emptyImageViewForSearch;

- (void)loadDataWithArr:(NSArray *)arrForModel;

@end
