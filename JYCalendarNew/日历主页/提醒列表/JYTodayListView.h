//
//  JYTodayListView.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYTodayListView : UITableView<UITableViewDelegate,UITableViewDataSource>

//滚动改变head
@property (nonatomic ,copy)void (^scrollViewDidScrollBlock)(CGFloat y,CGFloat section1_heigth);

//点击改变head1
@property (nonatomic ,copy)void (^clickChangeHeadBlock)(BOOL isSelectToday,CGFloat height_section1);
//点击改变head2
@property (nonatomic ,copy)void (^clickChangeHead2Block)(BOOL isSelectToday,CGFloat height_section2);

//改变箭头
@property (nonatomic ,copy)void (^clickHeadBlock)(BOOL isHighLighted,NSInteger section);


//删除、收藏、点击
@property (nonatomic ,copy)void (^deleteBlock)(RemindModel *model);
@property (nonatomic ,copy)void (^collectionBlock)(RemindModel *model);
@property (nonatomic ,copy)void (^clickBlock)(RemindModel *model);

//全部选中回调
@property (nonatomic ,copy)void (^selectAllBlock)(BOOL isSelectAll);

//今天Model
@property (nonatomic ,strong)NSArray *todayRemind;
@property (nonatomic ,strong)NSArray *today_Farr;
@property (nonatomic ,assign)BOOL isTodayEmpty;

//待办Model
@property (nonatomic ,strong)NSArray *notYetRemind;
@property (nonatomic ,strong)NSArray *notYet_Farr;
@property (nonatomic ,assign)BOOL isNotYetEmpty;



@property (nonatomic ,strong)NSArray *todayList; //点击隐藏关闭时用到的数组
@property (nonatomic ,strong)NSArray *notyetList;




//编辑状态
@property (nonatomic ,assign)BOOL isEdit;

//查询状态
@property (nonatomic ,assign)BOOL isSearch;


//编辑状态下，存储选中数据
@property (nonatomic ,strong)NSMutableArray <RemindModel *> *selectData;
@property (nonatomic ,strong)NSMutableDictionary *boolDic;

//存储timer的字典
@property (nonatomic ,copy)NSMutableDictionary *timerDic;
//空视图状态
@property (nonatomic ,strong)UIImageView *imgForNoRemind;

//点击头视图方法
- (void)clickHeadAction:(UIButton *)sender
               isSelect:(BOOL)select;

//切换列表在显示回来使用
- (void)reloadArrData;

/**
 *  注销在进入，更新数据
 */
- (void)leaveReloadData;

@end
