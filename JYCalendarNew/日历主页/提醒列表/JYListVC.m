//
//  JYListVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYListVC.h"
#import "JYListTableView.h"
#import "JYMainViewController.h"
#import "JYTodayListView.h"
#import "JYSearchTableView.h"
#import "JYListDataManager.h"
#import <objc/runtime.h>

#import "JYInvker.h"
#import "JYSelectAllCommand.h"
#import "JYDeleteCommand.h"
#import "JYShareCommand.h"
#import "JYTopCommand.h"

#import "JYBottomFrame.h"


static NSInteger kEditBtnTag = 900;
static NSInteger kShareBtnTag = 901;


@interface JYListVC ()
{
    UIButton *_selectBtn;
    UIView   *_selectLine;
    JYInvker *inveker;
    
    //三种类型的list
    JYListTableView *_listTableView;
    JYTodayListView *_todayTableView;
    JYSearchTableView *_searchTableView;
    
    //数据管理者
    JYListDataManager *_listManager;
    
    UIButton *_editBtn; //编辑
    UIButton *_shareBtn; //分享
    UIButton *_calendarBtn; //日历
    UIButton *_cancelBtn; //搜索状态下取消按钮
    UIButton *_nowSelectBtn;  //当前正在编辑的按钮

    NSArray  *_itemArr;
    NSArray  *_singleItem;
 
    
    UIButton *headerView1; //tb头视图
    UIButton *headerView2;
    CGFloat   _changeY;  //编辑状态下赋值
    
    
    TABLE_TYPE _tableType; //切换页面记录，用于搜索查询
   
    
    BOOL  _isHiddenHead1; //记录下切换tb时候head的状态
    BOOL  _isHiddenHead2;
    
    CGFloat _searchBarX;

    
}
@property (nonatomic,strong) UILabel *acceptedUnreadCountLabel;
@property (nonatomic,strong) UILabel *sharedUnreadCountLabel;
@property (nonatomic,strong) UILabel *systemUnreadCountLabel;
@end

@implementation JYListVC

#pragma mark -通知方法
- (void)changeSkin
{
    [_editBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateSelected];
    [_shareBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateSelected];
    [_calendarBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"日历按钮_%@",[JYSkinManager shareSkinManager].keywordForSkinColor]] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    //底部按钮换肤
    [self _changeBtn:self.selectAllBtn];
    [self _changeBtn:self.deleteBtn];
    [self _changeBtn:self.shareBtn];
    [self _changeBtn:self.topBtn];
    [self _changeBtn:self.cancelBtn];
    
    //列表换肤
    [_todayTableView reloadData];
    [_listTableView reloadData];
    
}

//刷新数据，今天列表展开
- (void)changeHeadViewFrame
{
    
    headerView1.origin = CGPointMake(0, 44 + _changeY);
    headerView2.origin = CGPointMake(0, 44 + 44 + _changeY);
    
    if (_todayTableView.todayRemind.count == 0) {
        _isHiddenHead1 = YES;
    }
    
    if (_todayTableView.notYetRemind.count == 0) {
        _isHiddenHead2 = YES;
    }
    
//    headerView1.hidden = YES;
//    headerView2.hidden = YES;
//
//    _isHiddenHead1 = headerView1.hidden;
//    _isHiddenHead2 = headerView2.hidden;
    
    [self _hiddenEditBtnAndSelectTb];
}

//退出登录通知
- (void)leaveAction
{
    _user_id = 0;
    [self selectAction:nil];
}


#pragma mark -系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //命令模式
    inveker = [JYInvker shareInvker];
    _searchBarX = 30;
    
    _user_id = [[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]intValue];
    
    _isHiddenHead1 = YES;
    _isHiddenHead2 = YES;
    
    //初始化数据管理者
    _listManager = [JYListDataManager manager];
    [_listManager addNotification];
    
    _tableType = 500;
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    //顶部选择类型按钮
    [self _createSelectBtn];
    
    //共享人界面
    [self _createShareView];

    //普通收发列表
    [self _createList];
    
    //首页待办列表
    [self _createTodayList];
    
    //搜索列表
    [self _createSearchList];
    
    //编辑按钮
    [self _createEditBtn];
    
    
    //底部按钮
    [self _createBottomBtn];
    
    //搜索框
    [self _createSearchBar];
    
    //编辑按钮添加观察者
    [self _addObserver];
    
   
    //换肤通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSkin) name:kNotificationForListSkin object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeadViewFrame) name:kNotificationForManagerUpDate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadLabelCount) name:kNotificationRefreshUnreadRemindLabel object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leaveAction) name:kNotificationForLeave object:nil];
    
    
    [self refreshUnreadLabelCount];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_nowSelectBtn.selected) {
        self.view.frame = CGRectMake(0, 64, kScreenHeight,kScreenHeight-64);
    }else{
        self.view.frame = CGRectMake(0, 64, kScreenHeight,kScreenHeight-64-49);
    }
    
    self.tabBarController.tabBar.hidden = _nowSelectBtn.selected;
    self.tabBarController.tabBar.userInteractionEnabled = !_nowSelectBtn.selected;
    
    self.searchBar.hidden = NO;
    
    if (_nowSelectBtn.tag == kShareBtnTag && _nowSelectBtn.selected) {
        
        
        JYShareCommand *shareCommand = inveker.commandList[1];
        if (self.arrForGroup.count != 0 || self.arrForFriend.count != 0) {
            self.shareBtn.selected = YES;
            shareCommand.groupArr = self.arrForGroup;
            shareCommand.friendArr = self.arrForFriend;
            
        }else{
            self.shareBtn.selected = NO;
            shareCommand.groupArr = @[];
            shareCommand.friendArr = @[];
        }
    }
    
    
   int user_id = [[[NSUserDefaults standardUserDefaults]objectForKey:kUserXiaomiID]intValue];
    if (user_id != _user_id) {
        _user_id = user_id;
        headerView2.hidden = YES;
        headerView1.hidden = YES;
        [_todayTableView leaveReloadData];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [GuideView showGuideWithImageName:@"新手引导页1"];
    [GuideView showGuideWithImageName:@"新手引导页1"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.searchBar.hidden = YES;
}

//布局
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.view.frame = CGRectMake(0, 64, kScreenHeight,kScreenHeight-64);
    
    [self.acceptedUnreadCountLabel.superview bringSubviewToFront:_acceptedUnreadCountLabel];
    [self.systemUnreadCountLabel.superview bringSubviewToFront:_systemUnreadCountLabel];
    [self.sharedUnreadCountLabel.superview bringSubviewToFront:_sharedUnreadCountLabel];
}

//为按钮状态添加观察者
- (void)_addObserver
{
    [_editBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [_shareBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.selectAllBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.shareBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.deleteBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    [self.topBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    
}


//KVO回调  <编辑按钮状态、底部弹出的按钮状态>
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIButton *btn = (UIButton *)object;
  
    //编辑按钮
    if (btn.tag == kEditBtnTag) {
      
        if (btn.selected) {
            NSLog(@"编辑状态");
            
            _changeY = 0;
            
            [JYBottomFrame appearBottomBtn:@[self.selectAllBtn,self.deleteBtn,self.topBtn,self.cancelBtn] lineView:self.lineView];
     
        }else{
            NSLog(@"取消编辑状态");
  
            _changeY = 0;
   
            [JYBottomFrame disAppearBottomBtn:@[self.selectAllBtn,self.deleteBtn,self.topBtn,self.cancelBtn] lineView:self.lineView];

        }

    }
    
    //共享按钮
    if (btn.tag == kShareBtnTag) {
        
        if (btn.selected) {
          
            _changeY = 44;
            [JYBottomFrame appearBottomBtn:@[self.selectAllBtn,self.shareBtn,self.cancelBtn] lineView:self.lineView];
   
            
        }else{
            
            _changeY = 0;

            [JYBottomFrame disAppearBottomBtn:@[self.selectAllBtn,self.shareBtn,self.cancelBtn] lineView:self.lineView];
            
            //共享人取消选中状态
            self.arrForGroup  = @[];
            self.arrForFriend = @[];
            [self actionForHidenOrAppearFriend];
        }
    }
    
    
    if (btn.tag == kShareBtnTag || btn.tag == kEditBtnTag) {
        
        if (btn.selected) {
            
            _listTableView.frame = CGRectMake(0, 45 + _changeY, kScreenWidth, kScreenHeight - 44 - 49 - 75 - _changeY);
            _todayTableView.frame = CGRectMake(0, 44 +_changeY, kScreenWidth, kScreenHeight - 44 - 49 - 75 - _changeY);
            
            headerView1.origin = CGPointMake(0, 44 + _changeY);
            headerView2.origin = CGPointMake(0, 44 + 44 + _changeY);

            self.view.frame = CGRectMake(0, 64, kScreenHeight,kScreenHeight-64);

            
        }else{
          
            _listTableView.frame = CGRectMake(0, 45, kScreenWidth, kScreenHeight - 44 - 49 - 75);
            _todayTableView.frame = CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44 - 49 - 75);
            
            headerView1.origin = CGPointMake(0, 44 + _changeY);
            headerView2.origin = CGPointMake(0, 44  + 44 + _changeY);
            
            
            self.view.frame = CGRectMake(0, 64, kScreenHeight,kScreenHeight-64-49);

            
            [_listTableView.selectData removeAllObjects];
            [_listTableView.boolDic removeAllObjects];
            
            [_todayTableView.selectData removeAllObjects];
            [_todayTableView.boolDic removeAllObjects];
 
      
            [inveker rollBack];
            [inveker.commandArr removeAllObjects];
        }
        
        //添加分享好友按钮状态
        self.addFriendBtn.userInteractionEnabled = btn.selected;
        
        //是否是编辑状态
        _listTableView.isEdit = btn.selected;
        _todayTableView.isEdit = btn.selected;
        
        
        [_listTableView reloadData];
        [_todayTableView reloadData];
        
        //tb状态
        self.tabBarController.tabBar.hidden = btn.selected;
        self.tabBarController.tabBar.userInteractionEnabled = !btn.selected;
    }
    

    //底部弹出的按钮状态
    if (btn.tag >= 1000 && btn.tag <= 1004) {
        
        UILabel  *label = (UILabel *)[btn viewWithTag:btn.tag+10];
        if ([[change objectForKey:@"new"]intValue] == 0) {
            
            
            btn.backgroundColor = [UIColor whiteColor];
            label.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
            
        }else{
            
            label.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
            btn.backgroundColor = [JYSkinManager shareSkinManager].btnBackGroundColor;
        }
    }

}

//复写不创建返回箭头
- (void)actionForSetLeftBtn{}

//切换tb
- (void)selectAction:(UIButton *)sender
{
    if (sender == nil) {
        sender = [self.view viewWithTag:500];
    }
    
    if (_selectBtn != sender) {
        _selectBtn.selected = NO;
        _selectBtn = sender;
        sender.selected = YES;
        
        _tableType = sender.tag;
        
        //结束搜索同时切换页面
        [self endSearchAction];
        
        
        //切换tb编辑状态取消
        _nowSelectBtn.selected = NO;
        
        [self _lineMove:sender.origin.x + 10];
    }
    //清除命令
    [inveker rollBackAll];
}

- (void)_lineMove:(CGFloat )x
{
    [UIView animateWithDuration:0.3 animations:^{
        _selectLine.origin = CGPointMake(x, _selectLine.origin.y);
    }];
}

#pragma mark -添加共享人界面
- (void)_createShareView
{
    [self createAddPeopleView:self andType:0];
    self.addFriendBtn.userInteractionEnabled = NO;
}


#pragma mark -其他列表
- (void)_createList
{
    _listTableView = [[JYListTableView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight - 44 - 49 - 75) style:UITableViewStylePlain];
    _listTableView.hidden = YES;
    [self.view addSubview:_listTableView];
    
    _listTableView.showsVerticalScrollIndicator = NO;
    
    [_listTableView setTableFooterView:[UIView new]];

    __weak typeof(self) weekSelf = self;
    //删除
    [_listTableView setDeleteBlock:^(RemindModel *model) {
        [weekSelf deleteOneRemindModel:model];
    }];
    
    //收藏
    [_listTableView setCollectionBlock:^(RemindModel *model) {
        [weekSelf collectionModel:model];
    }];
    
    //点击
    [_listTableView setClickBlock:^(RemindModel *model) {
        [weekSelf clickModel:model];
    }];
    
    //全部选中
    [_listTableView setSelectAllBlock:^(BOOL isAll) {
        [weekSelf selectAllActionNotBtn:isAll];
    }];
    
}


#pragma mark -今天列表<俩种类型: 今天 、 待办>
- (void)_createTodayList
{

    _todayTableView = [[JYTodayListView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, kScreenHeight - 44 - 49 - 75) style:UITableViewStylePlain];
    [self.view addSubview:_todayTableView];
    _todayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_todayTableView setTableFooterView:[UIView new]];
    
    _todayTableView.showsVerticalScrollIndicator = NO;
    
    
    headerView1 = [self _headerView:0 arr:_todayTableView.todayRemind];
    headerView2 = [self _headerView:1 arr:_todayTableView.notYetRemind];
    
    headerView1.origin = CGPointMake(0, 44 + _changeY);
    headerView2.origin = CGPointMake(0, 44 + 44 + _changeY);
    headerView2.hidden = YES;
    headerView1.hidden = YES;
    
    [self.view addSubview:headerView1];
    [self.view addSubview:headerView2];
    
    __block UIView *head1 = headerView1;
    __block UIView *head2 = headerView2;
    __weak typeof(self) weekSelf = self;
    //scrollView滚动改变头视图
    [_todayTableView setScrollViewDidScrollBlock:^(CGFloat y,CGFloat section1_height) {

        if (_tableType == 500) {
          
            if (y<0) {
                
                head1.hidden = YES;
                head2.hidden = YES;
                
            }else{
                
                if (y <= section1_height && y >=0) {
                    
                    head2.hidden = YES;
                    head1.hidden = YES;
                    
                }else {
                    
                    head1.hidden = NO;
                    head2.hidden = NO;
                }
            }
            _isHiddenHead1 = head1.hidden;
            _isHiddenHead2 = head2.hidden;
            
        }else{
        
            if (y<0) {
                
                _isHiddenHead1 = YES;
                _isHiddenHead2 = YES;
                
            }else{
                
                if (y <= section1_height && y >=0) {
                    
                    _isHiddenHead1 = YES;
                    _isHiddenHead2 = YES;
                    
                }else {
                    
                    _isHiddenHead1 = NO;
                    _isHiddenHead2 = NO;
                }
            }
        }
    }];
    
 
    
    [_todayTableView setClickHeadBlock:^(BOOL isHighLighted, NSInteger section) {
        
        if (section == 0) {
            
            UIImageView *arrowHead = [weekSelf.view viewWithTag:600+200];
            arrowHead.highlighted = isHighLighted;
            
            if (isHighLighted) {
             
                head2.hidden = YES;
            }else{
                
                head2.hidden = NO;
                head1.hidden = NO;
            }
            
            _isHiddenHead1 = head1.hidden;
            _isHiddenHead2 = head2.hidden;
       
        }else{
        
            UIImageView *arrowHead = [weekSelf.view viewWithTag:601+200];
            arrowHead.highlighted = isHighLighted;
        }
        
    }];
    
    //删除
    [_todayTableView setDeleteBlock:^(RemindModel *model) {
        [weekSelf deleteOneRemindModel:model];
    }];
    
    //收藏
    [_todayTableView setCollectionBlock:^(RemindModel *model) {
        [weekSelf collectionModel:model];
    }];
    
    //点击
    [_todayTableView setClickBlock:^(RemindModel *model) {
        [weekSelf clickModel:model];
    }];
    
    //全部选中
    [_todayTableView setSelectAllBlock:^(BOOL isAll) {
        [weekSelf selectAllActionNotBtn:isAll];
    }];
}


#pragma mark -搜索列表
- (void)_createSearchList
{
    _searchTableView = [[JYSearchTableView alloc] initWithFrame:CGRectMake(0, 45, kScreenWidth, kScreenHeight - 44 - 49 - 75) style:UITableViewStylePlain];
    _searchTableView.hidden = YES;
    [self.view addSubview:_searchTableView];
    
    _searchTableView.showsVerticalScrollIndicator = NO;
    [_searchTableView setTableFooterView:[UIView new]];
    
    __weak typeof(self) weekSelf = self;
    //删除
    [_searchTableView setDeleteBlock:^(RemindModel *model) {
        [weekSelf deleteOneRemindModel:model];
    }];
    
    //收藏
    [_searchTableView setCollectionBlock:^(RemindModel *model) {
        [weekSelf collectionModel:model];
    }];
    
    //点击
    [_searchTableView setClickBlock:^(RemindModel *model) {
        [weekSelf clickModel:model];
    }];
    
    //点击空白
    [_searchTableView setCancelBlock:^{
        [weekSelf endSearchAction];
    }];
}

//点击头视图方法
- (void)clickHeadAction:(UIButton *)sender
{
    UIImageView *arrowHead = [self.view viewWithTag:sender.tag+200];
    
    arrowHead.highlighted = !arrowHead.highlighted;
    
    if (sender.tag == 600) {
        
        if (arrowHead.highlighted) {
            headerView2.hidden = YES;
        }else{
            headerView2.hidden = NO;
        }
        
    }else{
    
        UIImageView *arrowHeadToday = [self.view viewWithTag:600 + 200];
        if (arrowHeadToday.highlighted) {
            headerView2.hidden = YES;
        }else{
            headerView2.hidden = NO;
        }
    }
    
    _isHiddenHead1 = headerView1.hidden;
    _isHiddenHead2 = headerView2.hidden;
    
    [_todayTableView clickHeadAction:sender isSelect:arrowHead.highlighted];
}

//头视图
- (UIButton *)_headerView:(NSInteger )section arr:(NSArray *)arr
{
    
    UIButton *bgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.f)];
    bgView.tag = section + 600;
    [bgView addTarget:self action:@selector(clickHeadAction:) forControlEvents:UIControlEventTouchUpInside];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLine.backgroundColor = lineColor;
    [bgView addSubview:topLine];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = lineColor;
    [bgView   addSubview:bottomLine];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth - 30, 44.f)];
    label.userInteractionEnabled = NO;
    [bgView addSubview:label];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((30 - 11)/2.0, (44 - 11)/2.0, 11, 11)];
    [imageView setImage:[UIImage imageNamed:@"左.png"]];
    imageView.tag = section + 800;
    imageView.userInteractionEnabled = NO;
    [imageView setHighlightedImage:[UIImage imageNamed:@"下.png"]];
    imageView.highlighted = YES;
    [bgView addSubview:imageView];

    if (section == 0) {
        
        if (arr.count == 0) {
            imageView.highlighted = NO;
        }
        label.text = @"今天";
        
    }else{
        
        if (arr.count == 0) {
            imageView.highlighted = NO;
        }
        label.text = @"待办";
    }
    
    return bgView;
}


#pragma mark -列表统一操作
//取消编辑、分享方法
- (void)cancelAction:(UIButton *)sender
{
    _nowSelectBtn.selected = NO;
    //清除命令
    [inveker rollBackAll];
}

//删除内容
- (void)deleteOneRemindModel:(RemindModel *)model
{
    JYDeleteCommand *command = [[JYDeleteCommand alloc] initWithSingleDelete:model editBtn:_editBtn];
    [inveker addCommand:command];

}

//多条删除方法
- (void)deleteAction:(UIButton *)sender
{
    sender.selected = YES;
    [inveker executeWithIndex:1];
}

//收藏内容
- (void)collectionModel:(RemindModel *)model
{
    [RequestManager actionForHttp:@"new_save"];
    [RemindModel collectionWithModel:model];
}

//点击内容
- (void)clickModel:(RemindModel *)model
{
    [self endSearchAction];
    
    if (model.musicName == 0) {
        model.isOn = 0;
        model.musicName = 1;
    }
    
    UIViewController *vc = [RemindModel pushModel:model delegate:self];
    
    [self.navigationController pushViewController:vc animated:YES];
}

//全选方法
- (void)selectAllAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [inveker executeWithIndex:0];
    }else{
        [inveker rollBack:0];
    }
}

//非按钮选中全部
- (void)selectAllActionNotBtn:(BOOL)isAll
{
    self.selectAllBtn.selected = isAll;
    
}

//共享提醒
- (void)shareAction:(UIButton *)sender
{
    
    sender.selected = YES;
    [inveker executeWithIndex:1];
}

//置顶方法
- (void)topAction:(UIButton *)sender
{
    sender.selected = YES;
    [inveker executeWithIndex:2];
}


#pragma mark -编辑、日历、取消按钮
- (void)_createEditBtn
{
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"编辑" forState:UIControlStateSelected];
    [_editBtn addTarget:self action:@selector(editOrShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_editBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -0)];
    
    _editBtn.tag = kEditBtnTag;
    [_editBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateSelected];
    [_editBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    if (_todayTableView.todayRemind.count == 0 && _todayTableView.notYetRemind.count == 0) {
        _editBtn.hidden = YES;
    }
    
    _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_shareBtn setTitle:@"共享" forState:UIControlStateNormal];
    [_shareBtn setTitle:@"共享" forState:UIControlStateSelected];
    [_shareBtn addTarget:self action:@selector(editOrShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -0)];
    _shareBtn.tag = kShareBtnTag;
    [_shareBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateSelected];
    [_shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (_todayTableView.todayRemind.count == 0 && _todayTableView.notYetRemind.count == 0 ) {
        _shareBtn.hidden = YES;
    }
    
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:_shareBtn];

    
    _itemArr = @[shareItem,editItem];
    _singleItem = @[editItem];
    self.navigationItem.rightBarButtonItems = _itemArr;
    
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(endSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [_cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_cancelBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
}

- (void)editOrShareAction:(UIButton *)sender
{
    if (sender.selected) {
        return;
    }
    
    self.arrForFriend = @[];
    self.arrForGroup  = @[];
    [inveker rollBackAll];
    [inveker.commandList addObjectsFromArray:[self createCommand:sender.tag]];

    
    if (sender.tag == kEditBtnTag) {
        _shareBtn.selected = NO;
        
        
    }else {
        _editBtn.selected  = NO;
        if(_tableType!=table_system){
            [GuideView showGuideWithImageName:@"新手引导页3"];
        }
    }
  
    sender.selected = YES;
    _nowSelectBtn = sender;
    inveker.commandBtn = sender;
}

- (NSArray *)createCommand:(NSInteger )type
{
   //删除
   JYDeleteCommand *delete = [[JYDeleteCommand alloc] initWithTodayList:_todayTableView normalList:_listTableView btn:self.deleteBtn editBtn:_editBtn];
    
   //全选
   JYSelectAllCommand *all = [[JYSelectAllCommand alloc] initWithTodayList:_todayTableView normalList:_listTableView sender:self.selectAllBtn];
    
   //共享
   JYShareCommand *share = [[JYShareCommand alloc] initWithFriendArr:self.arrForFriend groupArr:self.arrForGroup todayTb:_todayTableView listTb:_listTableView btn:self.shareBtn editBtn:_shareBtn];
    
   //置顶
   JYTopCommand *top = [[JYTopCommand alloc] initWithTodayList:_todayTableView normalList:_listTableView editBtn:_editBtn btn:self.topBtn];
    
    
    if (type == kEditBtnTag) {
        return @[all,delete,top];
    }else{
        return @[all,share];
    }
    
}

//弹出日历界面
- (void)pushToCalendarVC
{
    JYMainViewController *jyCalendarVC = [JYMainViewController shareInstance];
    jyCalendarVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:jyCalendarVC animated:YES];
}


#pragma mark -顶部按钮
- (void)_createSelectBtn
{
    
    NSArray *btnArr = @[@"待办",@"收到",@"已发",@"共享",@"系统"];
    CGFloat width = kScreenWidth / 5.0;
    CGFloat lineWidth = width - 10 * 2;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    bottomLine.backgroundColor = lineColor;
    [self.view addSubview:bottomLine];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5.0];
    for (int i = 0; i < btnArr.count; i++) {
        
        UIButton *selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, 44.f)];
        selectBtn.tag = 500 + i;
        [selectBtn setTitle:btnArr[i] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateSelected];
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectBtn];
        
        //换肤
        [arr addObject:selectBtn];
        
        if (i == 0) {
            
            _selectBtn = selectBtn;
            _selectLine = [[UIView alloc] initWithFrame:CGRectMake(10, 43.0, lineWidth, 1)];
            _selectLine.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
            [self.view addSubview:_selectLine];
            [JYSkinManager shareSkinManager].lineView = _selectLine;
            _selectBtn.backgroundColor = [UIColor whiteColor];
            selectBtn.selected = YES;
            
        }
        
       
        if(i==1){//收到
            _acceptedUnreadCountLabel = [self createUnreadCountLabelForButton:selectBtn];
        }else if(i==3){//共享
            _sharedUnreadCountLabel = [self createUnreadCountLabelForButton:selectBtn];
        }else if(i==4){//系统
            _systemUnreadCountLabel = [self createUnreadCountLabelForButton:selectBtn];
        }
    }
    
    [JYSkinManager shareSkinManager].selectBtnList = arr;
    
}
#pragma  mark - 未读提醒相关
- (UILabel *)createUnreadCountLabelForButton:(UIButton *)sender
{
    CGFloat width = kScreenWidth / 5.0;
    CGFloat unreadLabelWidth = 12.f;
    CGFloat unreadLabelHeight = 15.f;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width-unreadLabelWidth,5.f,unreadLabelWidth,unreadLabelHeight)];
    label.backgroundColor = [UIColor redColor];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = unreadLabelHeight/2.f;
    label.layer.masksToBounds =  YES;
    label.hidden = YES;
    label.textAlignment = NSTextAlignmentCenter;
    [label setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [sender addSubview:label];
    [sender bringSubviewToFront:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sender).offset(-3);
        make.height.equalTo(@(unreadLabelHeight));
        make.top.equalTo(sender).offset(5);
        make.width.greaterThanOrEqualTo(@(unreadLabelWidth));
        make.width.lessThanOrEqualTo(@25.f);
    }];
    return label;
}
//未读消息刷新
- (void)refreshUnreadLabelCount{
    NSDictionary *dic = [[LocalListManager shareLocalListManager]getUnreadRemindData];
    NSLog(@"%@",dic);
    
    NSString *acceptCount = [NSString stringWithFormat:@"%@",[dic objectForKey:kUnreadAcceptKey]];
    NSString *sharedCount = [NSString stringWithFormat:@"%@",[dic objectForKey:kUnreadShareKey]];
    NSString *systemCount = [NSString stringWithFormat:@"%@",[dic objectForKey:kUnreadSystemKey]];
    
    [self setUnreadCount:acceptCount forLabel:_acceptedUnreadCountLabel];
    [self setUnreadCount:sharedCount forLabel:_sharedUnreadCountLabel];
    [self setUnreadCount:systemCount forLabel:_systemUnreadCountLabel];
}
- (void)setUnreadCount:(NSString *)countStr forLabel:(UILabel *)label
{
    if([countStr isEqualToString:@"0"]){
        label.hidden = YES;
    }else{
        label.hidden = NO;
    }
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.headIndent = 4.f;
    style.tailIndent = 4.f;
    label.attributedText = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@  ",countStr] attributes:@{NSFontAttributeName:label.font,NSParagraphStyleAttributeName:style}];
}

#pragma mark -底部按钮
- (void)_createBottomBtn
{
    [self createBottomBtn:self];
}


#pragma mark -搜索框
- (void)_createSearchBar
{

    //self.searchBar = [[JYSearchBar alloc] initWithSuperView:self.navigationController andEditBtnX:_editBtn.origin.x calendarX:_calendarBtn.origin.x];
    self.searchBar = [[JYSearchBar alloc] initWithSuperView:self.navigationController andEditBtnX:_editBtn.width*2 calendarX:0];
    NSLog(@"%lf",_editBtn.origin.x);
    
    [self _hiddenEditBtnAndSelectTb];
    
    __weak typeof(self) weekSelf = self;
    [self.searchBar setBeginSearch:^{
        
        [weekSelf beginEdit];
    }];
    
    [self.searchBar setSearchBarText:^(NSString *text) {
        
        [weekSelf editing:text];
    }];
    
    [self.searchBar setEndSearch:^(NSString *text) {
        
        [weekSelf endEdit:text];
    }];
    
}



//开始搜索
- (void)beginEdit
{
    _editBtn.hidden = YES;
    _shareBtn.hidden = YES;
    _calendarBtn.hidden = YES;
    _cancelBtn.hidden = NO;
    
  
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_cancelBtn];
    
  
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    _nowSelectBtn.selected = NO;
    NSLog(@"开始搜索");
    _listTableView.hidden = YES;
    _todayTableView.hidden = YES;
    _searchTableView.hidden = NO;
    
    [self.searchBar changeSearchBar:CGRectMake(20, self.searchBar.origin.y, 271 - 40, 30)];
    
}

//搜索中
- (void)editing:(NSString *)text
{
    NSArray *dataArr ;
    if ([text isEqualToString:@""]) {
        dataArr = @[];
    }else{
        switch (_tableType) {
            case table_today:
            {
                NSDictionary *dic = [_listManager todayData:text];
                NSArray *today = dic[@"today"];
                NSArray *notYet = dic[@"after"];
                NSMutableArray *arr = [NSMutableArray array];
                [arr addObjectsFromArray:today];
                [arr addObjectsFromArray:notYet];
                
                dataArr = arr;
            }
                break;
            case tabel_accept:
            {
                dataArr = [_listManager acceptData:text];
            }
                break;
            case table_send:
            {
                dataArr = [_listManager sendData:text];
            }
                break;
            case table_share:
            {
                dataArr = [_listManager shareData:text];
            }
                break;
            case table_system:
            {
                dataArr = [_listManager systemData:text];
            }
                break;
                
            default:
                break;
        }
    }

    //改变
    [_searchTableView changeData:dataArr type:_tableType];
    NSLog(@"搜索中");
}

//结束搜索
- (void)endEdit:(NSString *)text
{
    _searchTableView.hidden = YES;
    [_searchTableView removeData];
    
    //停止搜索
    [self endSearchAction];
    //[self.searchBar isHiddenEditBtn:_editBtn.hidden];
    
    NSLog(@"搜索结束");
}


- (void)endSearchAction
{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItems = _itemArr;
    
    _calendarBtn.hidden = NO;
    _cancelBtn.hidden = YES;
    
    [self _hiddenEditBtnAndSelectTb];
}

/**
 *  根据数据判断是否隐藏编辑按钮并切换tb
 */
- (void)_hiddenEditBtnAndSelectTb
{
   
    //清除命令
 
    CGRect rect;
    if (_searchTableView.hidden) {
        if (_tableType == 500) {
            _todayTableView.hidden = NO;
            _listTableView.hidden = YES;
            
            headerView1.hidden = _isHiddenHead1;
            headerView2.hidden = _isHiddenHead2;
            
            if (_todayTableView.todayList.count == 0 && _todayTableView.notyetList.count == 0) {
                
                _editBtn.hidden = YES;
                _shareBtn.hidden = YES;
                rect = CGRectMake(_searchBarX, self.searchBar.origin.y, kScreenWidth - _searchBarX * 2, 30);
                
            }else{
                
                rect = CGRectMake(_searchBarX, self.searchBar.origin.y, 271 - _searchBarX * 2, 30);
                
                _editBtn.hidden = NO;
                _shareBtn.hidden = NO;
            }
            
        }else{
            
            _todayTableView.hidden = YES;
            _listTableView.hidden = NO;
            
            headerView1.hidden = YES;
            headerView2.hidden = YES;
            
            [_listTableView selectTbWithType:_tableType];
            
            if (_listTableView.showArr.count == 0) {
             
                _shareBtn.hidden = YES;
                _editBtn.hidden = YES;
                rect = CGRectMake(_searchBarX, self.searchBar.origin.y, kScreenWidth - _searchBarX * 2, 30);
                
            }else{
                
                if (_tableType == table_system) {
                    _shareBtn.hidden = YES;
                    self.navigationItem.rightBarButtonItems = _singleItem;
                 
                    
                }else{
                    _shareBtn.hidden = NO;
                    self.navigationItem.rightBarButtonItems = _itemArr;
                   
                }
              
                 rect = CGRectMake(_searchBarX, self.searchBar.origin.y, 271 - _searchBarX * 2, 30);
                _editBtn.hidden = NO;
            }
            
        }
    
        //改变SearchFrame
        //[self.searchBar isHiddenEditBtn:_editBtn.hidden];
        [self.searchBar changeSearchBar:rect];
   
    }else{
    
        [self editing:self.searchBar.text];
    }

}

@end
