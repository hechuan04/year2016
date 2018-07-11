//
//  JYListTableView.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JYListTableView : UITableView<UITableViewDelegate,UITableViewDataSource>


//删除、收藏、点击
@property (nonatomic ,copy)void (^deleteBlock)(RemindModel *model);
@property (nonatomic ,copy)void (^collectionBlock)(RemindModel *model);
@property (nonatomic ,copy)void (^clickBlock)(RemindModel *model);

//全部选中回调
@property (nonatomic ,copy)void (^selectAllBlock)(BOOL isSelectAll);


//换肤
@property (nonatomic ,strong)JYSkinManager *skinManager;



//四种数据
@property (nonatomic ,strong)NSArray *systemRemind;
@property (nonatomic ,strong)NSArray *acceptRemind;
@property (nonatomic ,strong)NSArray *sendRemind;
@property (nonatomic ,strong)NSArray *shareRemind;

//friendModel,没有数据或者更新数据的时候重加载
@property (nonatomic ,strong)NSArray *system_FArr;
@property (nonatomic ,strong)NSArray *accept_FArr;
@property (nonatomic ,strong)NSArray *send_FArr;
@property (nonatomic ,strong)NSArray *share_FArr;


//显示到页面的数据
@property (nonatomic ,strong)NSArray *showArr;
@property (nonatomic ,strong)NSArray *showFriendArr;


//编辑状态
@property (nonatomic ,assign)BOOL isEdit;

//查询状态
@property (nonatomic ,assign)BOOL isSearch;


//编辑状态下，存储选中数据
@property (nonatomic ,strong)NSMutableArray <RemindModel *>*selectData;
@property (nonatomic ,strong)NSMutableDictionary *boolDic;

//列表类型
@property (nonatomic ,assign)TABLE_TYPE listType;
//空视图状态
@property (nonatomic ,strong)UIImageView *imgForNoRemind;


//切换列表方法
- (void)selectTbWithType:(TABLE_TYPE )type;


//子类需要调用
- (NSArray *)_showFriendArr:(NSArray *)arr;

@end
