//
//  JYRemindListVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRemindListVC.h"

#import "BaseListVC.h"



#import "JYRemindViewController.h"
#import "AcceptTB.h"
#import "JYRemindOtherVC.h"
#import "JYRemindNoPassPeopleVC.h"

#import "RemindListTB.h"



@interface JYRemindListVC ()
{
    
    NSArray *_arrForRemindModel;
    
    RemindListTB *_listTb;
    UITapGestureRecognizer *_tapG;
    
    UIBarButtonItem *_rightItme;
    
    
}
@end

@implementation JYRemindListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _noSearch = YES;
    _isNowVC  = YES;
    
    _managerForBtn = [ManagerForButton shareManagerBtn];
    
    [self actionForRightBtn];
    
    [self _createSearchBar];
    
    [self _createTableView];
    
    _arrForRemindModel = @[@"全部",@"已发",@"收到",@"共享",@"系统消息"];
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationReload) name:kNotificationRefreshUnreadRemindLabel object:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skinLoad) name:kNotificationForListSkin object:@""];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)notificationReload{
    NSDictionary *dic = [[LocalListManager shareLocalListManager]getUnreadRemindData];
    _listTb.unreadDictionary = dic;
    [_listTb reloadData];
}

- (void)skinLoad
{
 
    [_listTb reloadData];

}

//覆盖父类方法去除返回按钮
- (void)actionForSetLeftBtn
{
    
}

- (void)_createSearchBar
{
    
    self.searchBar = [[JYSearchBar alloc] initWithSuperView:self.navigationController];

}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.searchBar.hidden = NO;
    self.searchBar.tbVC = YES;
    [self.searchBar changeFrame:YES];
    //当试图将要显示的时候说明是当前VC，searchBar的代理方法不需要走
    _isNowVC = YES;
    
    [self actionForRightBtn];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    //当试图将要消失的时候说明不是当前VC，searchBar需要走代理方法
    _isNowVC = NO;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.searchBar resignFirstResponder];
    
}


//push vc
- (void)pushVCWithType:(ListType )type
                 andVC:(JYRemindListVC *)listVC
          andSearchBar:(JYSearchBar *)searchBar;
{
 
    BaseListVC *baseList = [[BaseListVC alloc] init];
    baseList.listType = type;
    baseList.hidesBottomBarWhenPushed = YES;
    baseList.searchBar = searchBar;
    [baseList.searchBar changeFrame:NO];
    listVC.searchBarDelegate = baseList;
    searchBar.tbVC = NO;
    [listVC.navigationController pushViewController:baseList animated:YES];
    

}

- (void)_createTableView
{
    
    _listTb = [[RemindListTB alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66 - 49) style:UITableViewStylePlain];
    [self.view addSubview:_listTb];
    
    NSDictionary *dic = [[LocalListManager shareLocalListManager]getUnreadRemindData];
    _listTb.unreadDictionary = dic;
    
    __block JYSearchBar *searchBar = self.searchBar;
    __block JYRemindListVC *nowVC = self;
    //push model
    [_listTb setPushModel:^(RemindModel *model) {
        
        searchBar.text = @"";
        [searchBar resignFirstResponder];
        
        
        BOOL isLocal = NO;
        BOOL canEdit = YES;
        
        NSString *strForFid = [NSString stringWithFormat:@",%@,",model.fidStr];
        
        NSString *xiaomi = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
        NSString *xiaomiID = [NSString stringWithFormat:@",%@,",xiaomi];
        
        /**
         *  判断是否能修改
         */
        if ((![model.gidStr isEqualToString:@""] || ![model.fidStr isEqualToString:@""]) && ([strForFid rangeOfString:xiaomiID].location == NSNotFound)) {
            
            canEdit = NO;
            isLocal = NO;
            
        }else if((![model.gidStr isEqualToString:@""] || ![model.fidStr isEqualToString:@""]) && ([strForFid rangeOfString:xiaomiID].location != NSNotFound)){
            
            isLocal = NO;
            canEdit = YES;
            
        }else{
            
            isLocal = YES;
        }
        
        
        
        if (canEdit) {
            
            if (isLocal) {
                
                JYRemindViewController *vc = [[JYRemindViewController alloc] init];
                vc.isCreate = NO;
                
                model.isOther = 0;
                model.upData = YES;
                model.strForRepeat = [Tool actionForReturnRepeatStr:model];
                vc.model = model;
                
                vc.hidesBottomBarWhenPushed = YES;
                
                searchBar.hidden = YES;
                
                [searchBar resignFirstResponder];
                
                [nowVC.navigationController pushViewController:vc animated:YES];
                
            }else {
                
                JYRemindOtherVC *vc = [[JYRemindOtherVC alloc] init];
                model.upData = YES;
                vc.model = model;
                vc.hidesBottomBarWhenPushed = YES;
                searchBar.hidden = YES;
                
                [searchBar resignFirstResponder];
                
                [nowVC.navigationController pushViewController:vc animated:YES];
            }
            
            
        } else {
            
            if ((![model.fidStr isEqualToString:@""] || ![model.fidStr isEqualToString:@""]) && model.uid == 0) {
                
                //[nowVC passModel:model remindOther:YES];
                
            }else {
                
                if (model.isOther != 0) {
                    
                    JYRemindNoPassPeopleVC *jyremindNop = [[JYRemindNoPassPeopleVC alloc] init];
                    jyremindNop.model = model;
                    model.upData = YES;
                    jyremindNop.hidesBottomBarWhenPushed = YES;
                    searchBar.hidden = YES;
                    [searchBar resignFirstResponder];
                    
                    [nowVC.navigationController pushViewController:jyremindNop animated:YES];
                    
                }else{
                    
                    JYRemindOtherVC *vc = [[JYRemindOtherVC alloc] init];
                    model.upData = YES;
                    vc.model = model;
                    vc.hidesBottomBarWhenPushed = YES;
                    searchBar.hidden = YES;
                    
                    [searchBar resignFirstResponder];
                    
                    [nowVC.navigationController pushViewController:vc animated:YES];
                    
                }
                
                
            }
            
        }

    }];
    
    //pushVc
    [_listTb setPushList:^(NSInteger index) {
        
        switch (index) {
            case 0:
            {
                
                [nowVC pushVCWithType:all_list andVC:nowVC andSearchBar:searchBar];
                
            }
                break;
            case 1:
            {
                [nowVC pushVCWithType:send_list andVC:nowVC andSearchBar:searchBar];

            }
                break;
            case 2:
            {
                
                [nowVC pushVCWithType:accept_list andVC:nowVC andSearchBar:searchBar];

                
            }
                break;
            case 3:
            {
                [nowVC pushVCWithType:share_list andVC:nowVC andSearchBar:searchBar];

           
            }
                break;
               case 4:
            {
             
                [nowVC pushVCWithType:system_list andVC:nowVC andSearchBar:searchBar];

                
            }
                break;
            default:
                break;
                
        }
        
    }];
    
    
    
    [Tool actionForHiddenMuchTable:_listTb];
    
    _tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignFirstRes:)];
    _tapG.enabled = NO;
    [_listTb addGestureRecognizer:_tapG];
    
    //触发搜索
    [self beginEdit];
    
    //结束编辑
    [self endEdit];
    
    //编辑过程中传递
    [self editIng];
    
    
}

- (void)resignFirstRes:(UITapGestureRecognizer *)tap
{
    
    [self.searchBar resignFirstResponder];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)rightAction
{
    
    _arrForRemindModel = @[@"全部",@"已发送",@"已接收",@"共享",@"系统消息"];
    _noSearch = YES;
    _rightItme = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self endEdit];
}

#pragma mark 编辑方法
- (void)beginEdit
{
    
    __block RemindListTB *table = _listTb;
    __block UITapGestureRecognizer *tap = _tapG;
    __block UIBarButtonItem *rightItem = _rightItme;
    __block JYRemindListVC *remindList = self;
    __block ManagerForButton *manager = _managerForBtn;
    [self.searchBar setBeginSearch:^{
        
        
        if ([remindList.searchBarDelegate respondsToSelector:@selector(beginEdit)] && !_isNowVC) {
            
            [remindList.searchBarDelegate beginEdit];
            
            UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnView addTarget:remindList action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
            btnView.frame = CGRectMake(0, 0, 50, 50);
            [btnView setTitle:@"取消" forState:UIControlStateNormal];
            [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
            rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnView];
            BaseViewController *baseVC = (BaseViewController *)remindList.searchBarDelegate;
            manager.leftAndRightPage = -10;
            [baseVC.navigationItem setRightBarButtonItem:rightItem];
            baseVC.navigationItem.rightBarButtonItem = rightItem;
            return ;
            //0x1602ea450
        }
        
        
        UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnView addTarget:remindList action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        btnView.frame = CGRectMake(0, 0, 50, 50);
        [btnView setTitle:@"取消" forState:UIControlStateNormal];
        [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        rightItem = [[UIBarButtonItem alloc] initWithCustomView:btnView];
        [remindList.navigationItem setRightBarButtonItem:rightItem];
        remindList.navigationItem.rightBarButtonItem = rightItem;
        
        tap.enabled = YES;
        
        table.isSearch = YES;
        table.arrForModel = @[];
        
        [table reloadData];
              
    }];
    
}

- (void)editIng
{
    //搜索内容
    
    __block UITapGestureRecognizer *tap = _tapG;
    __block RemindListTB *table = _listTb;
    __block JYRemindListVC *remindList = self;
    
    [self.searchBar setSearchBarText:^(NSString *text) {
        
        if ([remindList.searchBarDelegate respondsToSelector:@selector(editing:)] && !_isNowVC) {
            
            [remindList.searchBarDelegate editing:text];
            
            return ;
        }
        
        if ([text isEqualToString:@""]) {
            
            _noSearch = YES;
            tap.enabled = YES;
            table.isSearch = YES;//为了不显示搜索结果为空
            [table loadDataWithArr:nil];
//            [table reloadData];
            
        }else{
            
            _noSearch = NO;
            LocalListManager *manager = [LocalListManager shareLocalListManager];
            
            NSArray *arrForModel = [manager searchAllDataWithText:text];
            table.isSearch = YES;
            [table loadDataWithArr:arrForModel];
            tap.enabled = NO;
            
        }
        
        NSLog(@"输入框内容 %@",text);
        
    }];
    
}

- (void)endEdit
{
    
    //结束搜索
    __block RemindListTB *tbView = _listTb;
    __block UITapGestureRecognizer *tap = _tapG;
    __block UIBarButtonItem *rightItem = _rightItme;
    __block JYRemindListVC *remindList = self;
    [self.searchBar setEndSearch:^(NSString *text){
        
        if ([remindList.searchBarDelegate respondsToSelector:@selector(endEdit:)] && !_isNowVC) {
            
            [remindList.searchBarDelegate endEdit:text];
            
            BaseViewController *baseVC = (BaseViewController *)remindList.searchBarDelegate;

            [baseVC actionForRightBtn];
            
            return ;
        }
        
        tap.enabled = NO;
        
        if ([text isEqualToString:@""]) {
            
            NSArray *arr = @[@"全部",@"已发送",@"已接收",@"共享",@"系统消息"];
            _noSearch = YES;
            rightItem = nil;
            tbView.isSearch = NO;
            tbView.arrForModel = arr;
            [remindList actionForRightBtn];
            tbView.emptyImageViewForSearch.hidden = YES;
            [tbView reloadData];
            
        }
        
        NSLog(@"结束搜索");
        
    }];
    
}

@end
