//
//  BaseViewController.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYSearchBar.h"
#import "JYRemindViewController.h"


@interface BaseViewController : UIViewController<JYRemindViewControllerDelegate>

@property (nonatomic ,strong)UIButton *selectAllBtn;
@property (nonatomic ,strong)UIButton *deleteBtn;
@property (nonatomic ,strong)UIButton *shareBtn;
@property (nonatomic ,strong)UIButton *topBtn;
@property (nonatomic ,strong)UIButton *cancelBtn;
@property (nonatomic ,strong)UIView   *lineView;

@property (nonatomic ,strong)UIView *viewForSelectFriend;
@property (nonatomic ,strong)UIImageView *image1;
@property (nonatomic ,strong)UIImageView *image2;
@property (nonatomic ,strong)UIImageView *image3;
@property (nonatomic ,strong)UIImageView *image4;
@property (nonatomic ,strong)UIImageView *image5;

@property (nonatomic ,strong)UIButton *editBtn;
@property (nonatomic ,strong)UILabel  *editLabel;
@property (nonatomic ,strong)UIButton *addFriendBtn;

@property (nonatomic ,strong)NSArray *arrForFriend;
@property (nonatomic ,strong)NSArray *arrForGroup;
@property (nonatomic ,strong)JYSearchBar *searchBar;

@property (nonatomic ,strong)NSMutableString *shareHeadUrl;

@property (nonatomic ,assign)int g_pageRight;


- (void)addNewRemind:(id)selectVC;

- (void)actionForLeft:(UIButton *)sender;
- (void)actionForRightBtn;
- (void)actionForSetLeftBtn;

#pragma mark 底部按钮

- (void)createBottomBtn:(UIViewController *)vc
                andType:(int )type;

//列表页
- (void)createBottomBtn:(UIViewController *)vc;
- (void)editActionList;



- (void)editAction;
- (void)systemEditAction;

- (void)cancelAction;
- (void)systemCancelAction;


//删除方法、分享方法、置顶方法
- (void)deleteAction:(UIButton *)sender;
- (void)shareAction:(UIButton *)sender;
- (void)topAction:(UIButton *)sender;

- (void)topActionWithArr:(NSArray *)arrForModel;

//选人按钮
- (void)createAddPeopleView:(UIViewController *)vc
                    andType:(int )type;

- (void)actionForAddFriend:(UIButton *)sender;

//添加新提醒
- (void)actionForPushNewRemind:(BaseViewController *)pasVC;

//编辑按钮
- (void)_editBtn;

//编辑方法
- (void)actionForEditAll:(UIButton *)sender;

//tb动画
- (void)tbIsOpen:(BOOL )isOpen andTb:(UITableView *)tb;

- (void)selectAllAction:(UIButton *)sender;

- (void)actionForHidenOrAppearFriend;//刷新共享人
- (void)_changeBtn:(UIButton *)sender;
@end
