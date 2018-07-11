//
//  BaseViewController.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/16.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "JYRemindViewController.h"
#import "AddRemindVC.h"
#import "JYSystemTitleVC.h"

#define heightForSelectBtn 108 / 1334.0 * kScreenHeight




@interface BaseViewController ()
{
    UIWindow *__sheetWindow;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏样式
    [self navigationType];
    
    //设置左按钮
    [self actionForSetLeftBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNotification:) name:kNotificationForGroupJumpToRemindList object:@""];
    
    
}

//显示添加分享人动画
- (void)tbIsOpen:(BOOL )isOpen andTb:(UITableView *)tb
{
 
    if (isOpen) {
        
        [UIView animateWithDuration:0.5 animations:^{
           
            tb.origin = CGPointMake(0, 44 + 44);
            tb.size = CGSizeMake(kScreenWidth, kScreenHeight - 44 - 49 - 64 - 60);
        }];
        
    }else{
     
        [UIView animateWithDuration:0.5 animations:^{
            
            tb.origin = CGPointMake(0, 45);
            tb.size = CGSizeMake(kScreenWidth, kScreenHeight - 44 - 49 - 64);

        }];
    
    }
}

//创建编辑按钮
- (void)_editBtn
{
    
    //编辑按钮
    CGFloat xForEditBtn = 0;

    
    UIFont *editFont = nil;
    
    if (IS_IPHONE_4_SCREEN) {
        
        xForEditBtn = 220;
      
        
        editFont = [UIFont systemFontOfSize:18];
        
    }else if(IS_IPHONE_5_SCREEN){
        
        xForEditBtn = 10;
   
        
        editFont = [UIFont systemFontOfSize:18];
        
    }else if(IS_IPHONE_6_SCREEN){
        
        xForEditBtn = 0;
 
        
        editFont = [UIFont systemFontOfSize:18];
        
        
    }else if(IS_IPHONE_6P_SCREEN){
        
        xForEditBtn = 0;
 
        
    }
    
    
    
    //编辑按钮
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(0, 0, 50, 50);
    
    [_editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //_editBtn.backgroundColor = [UIColor blackColor];
    [_editBtn addTarget:self action:@selector(actionForEditAll:) forControlEvents:UIControlEventTouchUpInside];
    //[self.navigationController.view addSubview:_editBtn];
    
    _editLabel = [[UILabel alloc] initWithFrame:CGRectMake(xForEditBtn, 0, 50, 50)];
    _editLabel.text = @"编辑";
    _editLabel.textAlignment = NSTextAlignmentCenter;
    _editLabel.textColor = [JYSkinManager shareSkinManager].colorForDateBg;
    _editLabel.font = editFont;
    [_editBtn addSubview:_editLabel];
}

//编辑方法
- (void)actionForEditAll:(UIButton *)sender
{
 
    if (sender.selected) {
  
    }else {
        //避免选中后没有取消全选效果
        [self performSelector:@selector(_selectBtnColor) withObject:nil afterDelay:1];
    }
    
}

- (void)_selectBtnColor
{
    self.selectAllBtn.selected = NO;
    self.deleteBtn.selected = NO;
    self.shareBtn.selected = NO;
    self.topBtn.selected = NO;
    [self _changeBtn:self.selectAllBtn];
    [self _changeBtn:self.deleteBtn];
    [self _changeBtn:self.shareBtn];
    [self _changeBtn:self.topBtn];
}

- (void)addAction:(UIButton *)sender
{
    
    [self actionForPushNewRemind:self];
    //NSLog(@"base添加提醒");
}

#pragma mark 新建提醒
//代理方法
- (void)passModel:(RemindModel *)model remindOther:(BOOL)isOther
{
    
    int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
    
    LocalListManager *localManager = [LocalListManager shareLocalListManager];
    
    //在这里增加判断是否是更改还是添加数据
    if (isOther && model.upData == NO) {
        
        model.isOther = 0;
        
        [ProgressHUD show:@"发送中…"];
        
        //在这里发送给其他人提醒
        __block BaseViewController *weekSelf = self;
        [RequestManager actionForSendOtherRemind:model sendSuccessBlock:^(BOOL sendSuccess) {
            
            if (sendSuccess) {
                
                [Tool showAlter:weekSelf title:@"发送成功"];

                
            }else {
             
                /*
                __sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"温馨提示" detail:@"网络异常，请检查您的网络" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
                    
                    //Window隐藏，并置为nil，释放内存 不能少
                    __sheetWindow.hidden = YES;
                    __sheetWindow = nil;
                    
                }];
                 */
                [Tool showAlter:weekSelf title:@"网络异常，请检查您的网络"];
            }
            
        }];
        
        
        
    }else if(model.upData == YES && isOther){
        
        model.isOther = 0;
        
        //更新发给其他人的提醒
        //在这里发送给其他人提醒
        __block BaseViewController *weekSelf = self;
        [RequestManager actionForUpDataRemind:model sendSuccessBlock:^(BOOL sendSuccess) {
            
            if (sendSuccess) {
                
                [Tool showAlter:weekSelf title:@"发送成功"];
               
            }else {
                
                /*
                 __sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"温馨提示" detail:@"网络异常，请检查您的网络" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
                 
                 //Window隐藏，并置为nil，释放内存 不能少
                 __sheetWindow.hidden = YES;
                 __sheetWindow = nil;
                 
                 }];
                 */
                [Tool showAlter:weekSelf title:@"网络异常，请检查您的网络"];
            }
            
        }];
        
    }
    
    //如果uid为空，说明是本地数据，增加在本地数据库
    if (model.upData == NO && !isOther) {
        
        model.gidStr = @"";
        model.fidStr = @"";
        model.isOther = 0;
        model.isTop = @"0";
        //[localManager insertDataWithremindModel:model usersID:userID];
        
        
    }else if(!isOther  && model.upData == YES){
        
        model.isOther = 0;
//        [localManager upDataWithModel:model];
        
    }
    
    [[JYSelectManager shareSelectManager] actionForChangeDateWithYear:model.year month:model.month day:model.day];
    
    //刷新通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
    
}

//新建提醒
- (void)actionForPushNewRemind:(BaseViewController *)pasVC
{
    //监测新建提醒方法
    
    pasVC.searchBar.hidden = YES;
    JYSelectManager *manager = [JYSelectManager shareSelectManager];
    JYRemindViewController *vc = [[JYRemindViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    vc.isCreate = YES;
    RemindModel *model = [[RemindModel alloc] init];
    model.year = manager.g_changeYear;
    model.month = manager.g_changeMonth;
    model.day = manager.g_changeDay;
    model.hour = [[Tool actionforNowHour] intValue];
    model.minute = [[Tool actionforNowMinute] intValue];
    model.musicName = 1;
    model.upData = NO;
    model.fidStr = @"";   //避免出现Nil情况
    model.gidStr = @"";
    model.isOn = YES;


    vc.model = model;
    
    [pasVC.navigationController pushViewController:vc animated:YES];
    

    
}

#pragma mark 创建右按钮、左按钮

- (void)actionForRightBtn
{
    
    CGFloat yForRightBtn = 0;
    
    if (IS_IPHONE_4_SCREEN) {
        
        
    }else if (IS_IPHONE_5_SCREEN){
        
        yForRightBtn = 1;
        
    }else if (IS_IPHONE_6_SCREEN){
        
        
    }else if (IS_IPHONE_6P_SCREEN){
        
        yForRightBtn = 1;

    }
    
    ManagerForButton *manager = [ManagerForButton shareManagerBtn];
    manager.leftAndRightPage = 0;
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, -5, 23.5, 20.5);
    [btnView setImage:[JYSkinManager shareSkinManager].addImage forState:UIControlStateNormal];
    [btnView setImageEdgeInsets:UIEdgeInsetsMake(yForRightBtn, 5.0, -yForRightBtn, -5.0)];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithCustomView:_editBtn];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    NSArray *itemArr = @[right,editItem];
    self.navigationItem.rightBarButtonItems = itemArr;



}

- (void)actionForSetLeftBtn
{
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
}

#pragma mark 左按钮方法

- (void)actionForLeft:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark navType

- (void)navigationType
{
    
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //设置navigationBar颜色
    [self.navigationController.navigationBar  setBarTintColor:[UIColor whiteColor]];
    //不透明的方法
    self.navigationController.navigationBar.translucent = NO;
    
    //设置导航默认标题的颜色及字体大小
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19]};
}

/**
 *  添加提醒方法
 */
- (void)addNewRemind:(id)selectVC
{
    
    //监测新建提醒方法
    
    JYSelectManager *manager = [JYSelectManager shareSelectManager];
    JYRemindViewController *vc = [[JYRemindViewController alloc] init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    self.searchBar.hidden = YES;
    vc.delegate = selectVC;
    vc.isCreate = YES;
    RemindModel *model = [[RemindModel alloc] init];
    model.year = manager.g_changeYear;
    model.month = manager.g_changeMonth;
    model.day = manager.g_changeDay;
    model.hour = [[Tool actionforNowHour] intValue];
    model.minute = [[Tool actionforNowMinute] intValue];
    model.musicName = (int)[[NSUserDefaults standardUserDefaults]integerForKey:kDefaultMusic];
    model.upData = NO;
    model.fidStr = @"";   //避免出现Nil情况
    model.gidStr = @"";
    model.isOn = YES;
    FriendModel *model1 = [[FriendModel alloc] init];
    
    model1.head_url = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
    
    //vc.arrForFriend = @[model1];
    
    Solar * solor = [[Solar alloc]init];
    
    //公
    solor.solarYear = model.year;
    solor.solarMonth = model.month ;
    solor.solarDay = model.day;
    
    vc.model = model;
 
    //选中红点置为nil
    JYSelectManager *selectManager = [JYSelectManager shareSelectManager];
    selectManager.viewForPoint = nil;
    selectManager.isHiddenPoint = NO;
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 底部按钮及方法

- (void)createBottomBtn:(UIViewController *)vc
{
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    CGFloat width = kScreenWidth / 4.0;
    
    //全选按钮
    _selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight, width, 60)];
    [_selectAllBtn addTarget:vc action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
    _selectAllBtn.backgroundColor = [UIColor whiteColor];
    _selectAllBtn.tag = 1000;
    
    UIImageView *allImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    allImage.image = [UIImage imageNamed:skinManager.arrForListImage[_selectAllBtn.tag-1000]];
    allImage.tag = _selectAllBtn.tag + 20;
    
    UILabel *selectAll = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    selectAll.text = @"全选";
    selectAll.font = [UIFont systemFontOfSize:12];
    selectAll.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    selectAll.textAlignment = NSTextAlignmentCenter;
    selectAll.tag = _selectAllBtn.tag+10;
    
    [vc.view addSubview:_selectAllBtn];
    [_selectAllBtn addSubview:allImage];
    [_selectAllBtn addSubview:selectAll];
    
  
    
    //删除按钮
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_topBtn.right, kScreenHeight, width, 60)];
    [_deleteBtn addTarget:vc action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    _deleteBtn.tag = 1001;
    
    
    UIImageView *deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    deleteImage.image = [UIImage imageNamed:skinManager.arrForListImage[_deleteBtn.tag-1000]];
    deleteImage.tag = _deleteBtn.tag + 20;
    
    UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    deleteLabel.text = @"删除";
    deleteLabel.font = [UIFont systemFontOfSize:12];
    deleteLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    deleteLabel.textAlignment = NSTextAlignmentCenter;
    deleteLabel.tag = _deleteBtn.tag+10;
    
    
    
    [vc.view addSubview:_deleteBtn];
    [_deleteBtn addSubview:deleteImage];
    [_deleteBtn addSubview:deleteLabel];
    
    
    
    //分享按钮
    _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60)];
    [_shareBtn addTarget:vc action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.backgroundColor = [UIColor whiteColor];
    _shareBtn.tag = 1002;
    
    
    
    UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    shareImage.image =  [UIImage imageNamed:skinManager.arrForListImage[_shareBtn.tag-1000]];
    shareImage.tag = _shareBtn.tag + 20;
    
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    shareLabel.text = @"共享";
    shareLabel.font = [UIFont systemFontOfSize:12];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    shareLabel.tag = _shareBtn.tag+10;
    
    
    [vc.view addSubview:_shareBtn];
    [_shareBtn addSubview:shareImage];
    [_shareBtn addSubview:shareLabel];
    
    
    
    
    //置顶按钮
    _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60)];
    [_topBtn addTarget:vc action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
    _topBtn.backgroundColor = [UIColor whiteColor];
    _topBtn.tag = 1003;

    
    UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    topImage.image =  [UIImage imageNamed:skinManager.arrForListImage[_topBtn.tag-1000]];
    topImage.tag = _topBtn.tag + 20;
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    topLabel.text = @"置顶";
    topLabel.font = [UIFont systemFontOfSize:12];
    topLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.tag = _topBtn.tag+10;
    
    
    [vc.view addSubview:_topBtn];
    [_topBtn addSubview:topImage];
    [_topBtn addSubview:topLabel];
    
    
    
   
    //取消按钮
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60)];
    [_cancelBtn addTarget:vc action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.backgroundColor = [UIColor whiteColor];
    _cancelBtn.tag = 1004;
    
    
    
    UIImageView *cancelImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
    cancelImage.image =  [UIImage imageNamed:skinManager.arrForListImage[_cancelBtn.tag-1000]];
    cancelImage.tag = _cancelBtn.tag + 20;
    
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
    cancelLabel.text = @"取消";
    cancelLabel.font = [UIFont systemFontOfSize:12];
    cancelLabel.textAlignment = NSTextAlignmentCenter;
    cancelLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    cancelLabel.tag = _cancelBtn.tag+10;
    
    
    [vc.view addSubview:_cancelBtn];
    [_cancelBtn addSubview:cancelImage];
    [_cancelBtn addSubview:cancelLabel];
    
   
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 1)];
    _lineView.backgroundColor = lineColor;
    [vc.view addSubview:_lineView];
    
}

/**
 *  创建底部按钮
 */
- (void)createBottomBtn:(UIViewController *)vc
                andType:(int )type;
{
    
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];

    if (type == 5) {
      
        CGFloat width = kScreenWidth / 3.0;
        _selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight, width, 60)];
        [_selectAllBtn addTarget:vc action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllBtn.backgroundColor = [UIColor whiteColor];
        _selectAllBtn.tag = 1000;
        UIView *top1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        top1.backgroundColor = lineColor;
        
        UIImageView *allImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
        allImage.image = [UIImage imageNamed:skinManager.arrForListImage[_selectAllBtn.tag-1000]];
        allImage.tag = _selectAllBtn.tag + 20;
        
        UILabel *selectAll = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
        selectAll.text = @"全选";
        selectAll.font = [UIFont systemFontOfSize:12];
        selectAll.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        selectAll.textAlignment = NSTextAlignmentCenter;
        selectAll.tag = _selectAllBtn.tag+10;
        
        
        [vc.view addSubview:_selectAllBtn];
        [_selectAllBtn addSubview:top1];
        [_selectAllBtn addSubview:allImage];
        [_selectAllBtn addSubview:selectAll];

        
        
        
        _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60)];
        [_topBtn addTarget:vc action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.backgroundColor = [UIColor whiteColor];
        _topBtn.tag = 1003;
        
        UIView *top4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        top4.backgroundColor = lineColor;
        
        UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
        topImage.image =  [UIImage imageNamed:skinManager.arrForListImage[_topBtn.tag-1000]];
        topImage.tag = _topBtn.tag + 20;
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
        topLabel.text = @"置顶";
        topLabel.font = [UIFont systemFontOfSize:12];
        topLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.tag = _topBtn.tag+10;
        
        
        [vc.view addSubview:_topBtn];
        [_topBtn addSubview:top4];
        [_topBtn addSubview:topImage];
        [_topBtn addSubview:topLabel];

        
        
        
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_topBtn.right, kScreenHeight, width, 60)];
        [_deleteBtn addTarget:vc action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.tag = 1001;
        
        UIView *top2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        top2.backgroundColor = lineColor;
        
        UIImageView *deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
        deleteImage.image = [UIImage imageNamed:skinManager.arrForListImage[_deleteBtn.tag-1000]];
        deleteImage.tag = _deleteBtn.tag + 20;
        
        UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
        deleteLabel.text = @"删除";
        deleteLabel.font = [UIFont systemFontOfSize:12];
        deleteLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        deleteLabel.tag = _deleteBtn.tag+10;
        
       
        
        [vc.view addSubview:_deleteBtn];
        [_deleteBtn addSubview:top2];
        [_deleteBtn addSubview:deleteImage];
        [_deleteBtn addSubview:deleteLabel];

        
    }else{
        
        CGFloat width = kScreenWidth / 4.0;

        _selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight, width, 60)];
        [_selectAllBtn addTarget:vc action:@selector(selectAllAction:) forControlEvents:UIControlEventTouchUpInside];
        _selectAllBtn.backgroundColor = [UIColor whiteColor];
        _selectAllBtn.tag = 1000;
        
        UIView *top1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        top1.backgroundColor = lineColor;
        top1.tag = 1000 / 2.0;
        
        UIImageView *allImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
        allImage.image = [UIImage imageNamed:skinManager.arrForListImage[_selectAllBtn.tag-1000]];
        allImage.tag = _selectAllBtn.tag + 20;
        
        UILabel *selectAll = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
        selectAll.text = @"全选";
        selectAll.font = [UIFont systemFontOfSize:12];
        selectAll.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        selectAll.textAlignment = NSTextAlignmentCenter;
        selectAll.tag = _selectAllBtn.tag+10;
        
        
        
        [vc.view addSubview:_selectAllBtn];
        [_selectAllBtn addSubview:top1];
        [_selectAllBtn addSubview:allImage];
        [_selectAllBtn addSubview:selectAll];

        
        
        
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60)];
        [_shareBtn addTarget:vc action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.backgroundColor = [UIColor whiteColor];
        _shareBtn.tag = 1002;
        
        UIView *top3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        top3.backgroundColor = lineColor;
        top3.tag = 1002 / 2.0;
        
        UIImageView *shareImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
        shareImage.image =  [UIImage imageNamed:skinManager.arrForListImage[_shareBtn.tag-1000]];
        shareImage.tag = _shareBtn.tag + 20;
        
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
        shareLabel.text = @"共享";
        shareLabel.font = [UIFont systemFontOfSize:12];
        shareLabel.textAlignment = NSTextAlignmentCenter;
        shareLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        shareLabel.tag = _shareBtn.tag+10;
        
        
        [vc.view addSubview:_shareBtn];
        [_shareBtn addSubview:top3];
        [_shareBtn addSubview:shareImage];
        [_shareBtn addSubview:shareLabel];

        
        
        
        
        _topBtn = [[UIButton alloc] initWithFrame:CGRectMake(_shareBtn.right, kScreenHeight, width, 60)];
        [_topBtn addTarget:vc action:@selector(topAction:) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.backgroundColor = [UIColor whiteColor];
        _topBtn.tag = 1003;
        
        UIView *top4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        top4.backgroundColor = lineColor;
        top4.tag = 1003 / 2.0;
        
        UIImageView *topImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
        topImage.image =  [UIImage imageNamed:skinManager.arrForListImage[_topBtn.tag-1000]];
        topImage.tag = _topBtn.tag + 20;
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
        topLabel.text = @"置顶";
        topLabel.font = [UIFont systemFontOfSize:12];
        topLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.tag = _topBtn.tag+10;
        
        [vc.view addSubview:_topBtn];
        [_topBtn addSubview:top4];
        [_topBtn addSubview:topImage];
        [_topBtn addSubview:topLabel];

        
        
        
        
        _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_topBtn.right, kScreenHeight, width, 60)];
        [_deleteBtn addTarget:vc action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.tag = 1001;
        
        UIView *top2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
        top2.backgroundColor = lineColor;
        top2.tag = 1001 / 2.0;
        
        UIImageView *deleteImage = [[UIImageView alloc] initWithFrame:CGRectMake((width - 20) / 2.0, 10, 20, 20)];
        deleteImage.image = [UIImage imageNamed:skinManager.arrForListImage[_deleteBtn.tag-1000]];
        deleteImage.tag = _deleteBtn.tag + 20;
        
        UILabel *deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, allImage.bottom + 6, width, 20)];
        deleteLabel.text = @"删除";
        deleteLabel.font = [UIFont systemFontOfSize:12];
        deleteLabel.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
        deleteLabel.textAlignment = NSTextAlignmentCenter;
        deleteLabel.tag = _deleteBtn.tag+10;

        
        
        [vc.view addSubview:_deleteBtn];
        [_deleteBtn addSubview:top2];
        [_deleteBtn addSubview:deleteImage];
        [_deleteBtn addSubview:deleteLabel];

    }

}


- (void)cancelAction
{

    CGFloat width = kScreenWidth / 4.0;
    CGFloat y = kScreenHeight;
    [UIView animateWithDuration:0.5 animations:^{
        _selectAllBtn.frame = CGRectMake(0, y, width, 60);
        _deleteBtn.frame = CGRectMake(_selectAllBtn.right, y, width, 60);
        _shareBtn.frame = CGRectMake(_deleteBtn.right, y, width, 60);
        _topBtn.frame = CGRectMake(_shareBtn.right, y, width, 60);
    } completion:^(BOOL finished) {
        _selectAllBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _shareBtn.backgroundColor = [UIColor whiteColor];
        _topBtn.backgroundColor = [UIColor whiteColor];
    }];
    
}

- (void)systemCancelAction
{
 
    CGFloat width = kScreenWidth / 3.0;
    CGFloat y = kScreenHeight;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _selectAllBtn.frame = CGRectMake(0, y, width, 60);
        _topBtn.frame = CGRectMake(_selectAllBtn.right, y, width, 60);
        _deleteBtn.frame = CGRectMake(_topBtn.right, y, width, 60);
    } completion:^(BOOL finished) {
        _selectAllBtn.backgroundColor = [UIColor whiteColor];
        _deleteBtn.backgroundColor = [UIColor whiteColor];
        _shareBtn.backgroundColor = [UIColor whiteColor];
        _topBtn.backgroundColor = [UIColor whiteColor];
    }];
}

- (void)editActionList
{
    CGFloat width = kScreenWidth / 4.0;
    CGFloat y     = kScreenHeight - 60 - 64;
    
    _selectAllBtn.frame = CGRectMake(0, kScreenHeight, width, 60);
    
    
}

- (void)editAction
{
    
    CGFloat width = kScreenWidth / 4.0;
    CGFloat y = kScreenHeight - 60 - 64;
    
 
    //系统消息和普通列表frame不一样
    [self changeLabelAndImageFrame:width];
    
    _selectAllBtn.frame = CGRectMake(0, kScreenHeight, width, 60);
    _deleteBtn.frame = CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60);
    _shareBtn.frame = CGRectMake(_deleteBtn.right, kScreenHeight, width, 60);
    _topBtn.frame = CGRectMake(_shareBtn.right, kScreenHeight, width, 60);
    [UIView animateWithDuration:0.5 animations:^{
        
        _selectAllBtn.frame = CGRectMake(0, y, width, 60);
        _deleteBtn.frame = CGRectMake(_selectAllBtn.right, y, width, 60);
        _shareBtn.frame = CGRectMake(_deleteBtn.right, y, width, 60);
        _topBtn.frame = CGRectMake(_shareBtn.right, y, width, 60);
    }];
    
}

- (void)systemEditAction
{
    CGFloat width = kScreenWidth / 3.0;
    CGFloat y = kScreenHeight - 60 - 64;
    
    //系统消息和普通列表frame不一样
    [self changeLabelAndImageFrame:width];
    
    _selectAllBtn.frame = CGRectMake(0, kScreenHeight, width, 60);
    _topBtn.frame = CGRectMake(_selectAllBtn.right, kScreenHeight, width, 60);
    _deleteBtn.frame = CGRectMake(_topBtn.right, kScreenHeight, width, 60);
    [UIView animateWithDuration:0.5 animations:^{
        
        _selectAllBtn.frame = CGRectMake(0, y, width, 60);
        _topBtn.frame = CGRectMake(_selectAllBtn.right, y, width, 60);
        _deleteBtn.frame = CGRectMake(_topBtn.right, y, width, 60);
    }];
    
}


// 1 / 3 宽度   1 / 4 宽度
- (void)changeLabelAndImageFrame:(CGFloat )width
{
    UIView *top1 = [_selectAllBtn viewWithTag:_selectAllBtn.tag / 2.0];
    UIView *top2 = [_deleteBtn viewWithTag:_deleteBtn.tag / 2.0];
    UIView *top3 = [_shareBtn viewWithTag:_shareBtn.tag / 2.0];
    UIView *top4 = [_topBtn viewWithTag:_topBtn.tag / 2.0];
    
    top1.frame = CGRectMake(0, 0, width, 1);
    top2.frame = CGRectMake(0, 0, width, 1);
    top3.frame = CGRectMake(0, 0, width, 1);
    top4.frame = CGRectMake(0, 0, width, 1);
    
    UILabel *lab1 = [_selectAllBtn viewWithTag:_selectAllBtn.tag + 10];
    UILabel *lab2 = [_deleteBtn viewWithTag:_deleteBtn.tag + 10];
    UILabel *lab3 = [_topBtn viewWithTag:_topBtn.tag + 10];
    
    lab1.size = CGSizeMake(width, 20);
    lab2.size = CGSizeMake(width, 20);
    lab3.size = CGSizeMake(width, 20);
    
    
    UIImageView *img1 = [_selectAllBtn viewWithTag:_selectAllBtn.tag + 20];
    UIImageView *img2 = [_deleteBtn viewWithTag:_deleteBtn.tag + 20];
    UIImageView *img3 = [_topBtn viewWithTag:_topBtn.tag + 20];
    
    
    img1.origin = CGPointMake((width - 20) / 2.0, 10);
    img2.origin = CGPointMake((width - 20) / 2.0, 10);
    img3.origin = CGPointMake((width - 20) / 2.0, 10);
}

/**
 *  直接从组跳转过来
 */
- (void)addNotification:(NSNotification *)text
{
    
    
    _arrForFriend = text.userInfo[@"friend"];
    _arrForGroup  = text.userInfo[@"group"];
    
    [self actionForHidenOrAppearFriend];
    
}

//添加提醒人方法
- (void)actionForAddFriend:(UIButton *)sender
{
    
    
    AddRemindVC *remindVc = [[AddRemindVC alloc] init];
    
    remindVc.isShare = YES;
    
    
    remindVc.arrForFriend = self.arrForFriend;
    remindVc.arrForGroup = self.arrForGroup;
    
    
    
    __block BaseViewController *vc = self;
    
    //*******************************回调的数据*******************************
    
    [remindVc setActionForSendArr:^(NSArray *arrForFriend, NSArray *arrForGroup) {
        
        vc.arrForFriend = arrForFriend;
        vc.arrForGroup  = arrForGroup;
        
        [vc actionForHidenOrAppearFriend];
        
        
        //fid拼串。gid拼串
        NSMutableString *fidStr = [NSMutableString string];
        NSMutableString *gidStr = [NSMutableString string];
        if (!_shareHeadUrl) {
            _shareHeadUrl = [[NSMutableString alloc] init];
        }else{
            _shareHeadUrl = nil;
            _shareHeadUrl = [[NSMutableString alloc] init];
        }
        
        for (int i = 0; i < arrForFriend.count; i ++) {
            
            FriendModel *model = arrForFriend[i];
            
            NSString *idStr = @"";
            
            if (i == arrForFriend.count - 1) {
                
                idStr = [NSString stringWithFormat:@"%ld",(long)model.fid];
                
            }else{
                
                idStr = [NSString stringWithFormat:@"%ld,",(long)model.fid];
            }
            
            
            [_shareHeadUrl appendFormat:@"%@,",model.head_url];
            [fidStr appendString:idStr];
        }
        
        for (int i = 0; i < arrForGroup.count; i ++) {
            
            GroupModel *model = arrForGroup[i];
            
            NSString *idStr = @"";
            
            if (i == arrForGroup.count - 1) {
                
                idStr = [NSString stringWithFormat:@"%d",model.gid];
                
            }else{
                
                idStr = [NSString stringWithFormat:@"%d,",model.gid];
            }
            
            [_shareHeadUrl appendFormat:@"%@,",model.groupHeaderUrl];
            [gidStr appendString:idStr];
        }
        
        
    }];
    
    remindVc.title = @"添加联系人";
    remindVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:remindVc animated:YES];
    
    
}

//创建提醒列表
- (void)createAddPeopleView:(UIViewController *)vc
                    andType:(int )type
{

    if (type == 5) {
        return;
    }
    
    self.viewForSelectFriend = [[UIView alloc] initWithFrame:CGRectMake(0,44, kScreenWidth , 44)];
    [vc.view addSubview:self.viewForSelectFriend];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 0.5)];
    bottomView.backgroundColor = lineColor;
    [self.viewForSelectFriend addSubview:bottomView];
    
//    self.viewForSelectFriend.layer.cornerRadius = 3.0;
//    self.viewForSelectFriend.layer.masksToBounds = YES;
//    self.viewForSelectFriend.layer.borderColor = lineColor.CGColor;
//    self.viewForSelectFriend.layer.borderWidth = 0.5;
    
    _addFriendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.viewForSelectFriend.width, self.viewForSelectFriend.height)];
    [_addFriendBtn addTarget:self action:@selector(actionForAddFriend:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewForSelectFriend addSubview:_addFriendBtn];
    
    UILabel *labelForTitle = [UILabel new];
    labelForTitle.text = @"添加共享人:";
    [self.viewForSelectFriend addSubview:labelForTitle];
    [labelForTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.viewForSelectFriend.mas_left).offset(10.f);
        make.top.equalTo(self.viewForSelectFriend.mas_top);
        make.bottom.equalTo(self.viewForSelectFriend.mas_bottom);
        
        
    }];
    
    //1
    self.image1 = [UIImageView new];
    self.image1.image = [UIImage imageNamed:@"添加发送人.png"];
    [self.viewForSelectFriend addSubview:self.image1];
    [self.image1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(labelForTitle.mas_right).offset(10.f);
        make.top.equalTo(self.viewForSelectFriend.mas_top).offset(7.f);
        make.bottom.equalTo(self.viewForSelectFriend.mas_bottom).offset(-7.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(30.f);
    }];
    
    //2
    self.image2 = [UIImageView new];
    self.image2.layer.cornerRadius = 30 / 2.0;
    self.image2.layer.masksToBounds = YES;
    self.image2.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image2];
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image1.mas_right).offset(10.f);
        make.top.equalTo(self.viewForSelectFriend.mas_top).offset(7.f);
        make.bottom.equalTo(self.viewForSelectFriend.mas_bottom).offset(-7.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(30.f);
    }];
    
    //
    //3
    self.image3 = [UIImageView new];
    self.image3.layer.cornerRadius = 30 / 2.0;
    self.image3.layer.masksToBounds = YES;
    self.image3.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image3];
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image2.mas_right).offset(10.f);
        make.top.equalTo(self.viewForSelectFriend.mas_top).offset(7.f);
        make.bottom.equalTo(self.viewForSelectFriend.mas_bottom).offset(-7.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(30.f);
    }];
    
    //4
    self.image4 = [UIImageView new];
    self.image4.layer.cornerRadius = 30 / 2.0;
    self.image4.layer.masksToBounds = YES;
    self.image4.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image4];
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image3.mas_right).offset(10.f);
        make.top.equalTo(self.viewForSelectFriend.mas_top).offset(7.f);
        make.bottom.equalTo(self.viewForSelectFriend.mas_bottom).offset(-7.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(30.f);
    }];
    
    //5
    self.image5 = [UIImageView new];
    self.image5.layer.cornerRadius = 30 / 2.0;
    self.image5.layer.masksToBounds = YES;
    self.image5.hidden = YES;
    [self.viewForSelectFriend addSubview:self.image5];
    [self.image5 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.image4.mas_right).offset(10.f);
        make.top.equalTo(self.viewForSelectFriend.mas_top).offset(7.f);
        make.bottom.equalTo(self.viewForSelectFriend.mas_bottom).offset(-7.f);
        make.height.mas_equalTo(30.f);
        make.width.mas_equalTo(30.f);
    }];
    
    [self actionForHidenOrAppearFriend];
    
}

//显示或隐藏提醒人
- (void)actionForHidenOrAppearFriend
{
    
    //先全部置为隐藏
    self.image2.hidden = YES;
    self.image3.hidden = YES;
    self.image4.hidden = YES;
    self.image5.hidden = YES;
    
    NSInteger showMany = self.arrForFriend.count + self.arrForGroup.count;
    
    if (showMany > 3) {
        
        self.image2.image = [UIImage imageNamed:@"dian.png"];
        self.image2.hidden = NO;
        int countNumber = 0;
        for (int i = 0; i < self.arrForFriend.count; i++) {
            
            if (countNumber >= 3) {
                
                break;
            }
            
            FriendModel *model = self.arrForFriend[i];
           
            if (i == 0) {
                
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像.png"]];
                self.image3.hidden = NO;
                
            }else if(i == 1){
                
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像.png"]];
                self.image4.hidden = NO;
                
            }else if(i == 2){
                
                [self.image5 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像.png"]];
                self.image5.hidden = NO;
            }
            
            countNumber ++;
            
        }
        for (int i = 0 ; i < self.arrForGroup.count; i++) {
            
            if (countNumber >= 3) {
                
                break;
            }
            
             GroupModel *gModel = self.arrForGroup[i];
            if (countNumber == 0) {
                
//                self.image3.image = [UIImage imageNamed:@"默认群组头像.png.png"];
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image3.hidden = NO;
                
            }else if(countNumber == 1){
                
//                self.image4.image = [UIImage imageNamed:@"默认群组头像.png.png"];
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image4.hidden = NO;
                
            }else if(countNumber == 2){
                
//                self.image5.image = [UIImage imageNamed:@"默认群组头像.png.png"];
                [self.image5 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image5.hidden = NO;
            }
            
            countNumber ++;
            
        }
        
    }else{
        
        int countNumber = 0;
        for (int i = 0; i < self.arrForFriend.count; i ++) {
            
            FriendModel *model = self.arrForFriend[i];
            
            if (i == 0) {
                
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像.png"]];
                self.image2.hidden = NO;
                
            }else if(i == 1){
                
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像.png"]];
                self.image3.hidden = NO;
                
            }else{
                
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像.png"]];
                self.image4.hidden = NO;
                
            }
            
            countNumber ++;
            
            if (countNumber == 3) {
                
                break;
            }
            
        }
        
        
        
        for (int i = 0; i < self.arrForGroup.count; i++) {
             GroupModel *gModel = self.arrForGroup[i];
            if (countNumber == 0) {
                
//                self.image2.image = [UIImage imageNamed:@"默认群组头像.png"];
                [self.image2 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image2.hidden = NO;
                
            }else if(countNumber == 1){
                
//                self.image3.image = [UIImage imageNamed:@"默认群组头像.png"];
                [self.image3 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image3.hidden = NO;
                
            }else if(countNumber == 2){
                
//                self.image4.image = [UIImage imageNamed:@"默认群组头像.png"];
                [self.image4 sd_setImageWithURL:[NSURL URLWithString:gModel.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
                self.image4.hidden = NO;
            }
            
            countNumber ++;
            
        }
        
    }
    
}

- (void)_changeBtn:(UIButton *)sender
{
    //NSArray *picArr = @[@"all.png",@"delete.png",@"share.png",@"top.png"];
    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    
    UILabel *label = nil;
    for (id subView in sender.subviews) {
        
        if ([subView isKindOfClass:[UILabel class]]) {
            
            label = (UILabel *)subView;
            
            break;
        }
    }
    
    if (sender.selected) {
        
        label.textColor = skinManager.colorForDateBg;
        
    }else{
        
        label.textColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    }
    
    
    for (id subView in sender.subviews) {
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            
            UIImageView *imageV = (UIImageView *)subView;
            
            imageV.image = [UIImage imageNamed:skinManager.arrForListImage[sender.tag - 1000]];
  
            break;
        }
    }
    
}

//取消按钮
- (void)cancelAction:(UIButton *)sender
{

}

//选中全部
- (void)selectAllAction:(UIButton *)sender
{
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    _shareBtn.backgroundColor = [UIColor whiteColor];
    _topBtn.backgroundColor = [UIColor whiteColor];
    [self _changeBtn:sender];
    
    //NSLog(@"全选了");
    
}

//删除方法
- (void)deleteAction:(UIButton *)sender
{
    
    _selectAllBtn.backgroundColor = [UIColor whiteColor];
    _shareBtn.backgroundColor = [UIColor whiteColor];
    _topBtn.backgroundColor = [UIColor whiteColor];
    [self _changeBtn:sender];
    
    //NSLog(@"super删除了");
}

//分享方法
- (void)shareAction:(UIButton *)sender
{
    _selectAllBtn.backgroundColor = [UIColor whiteColor];
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    _topBtn.backgroundColor = [UIColor whiteColor];
    [self _changeBtn:sender];
  
    //NSLog(@"分享了");
}

//置顶方法
- (void)topAction:(UIButton *)sender
{
    _selectAllBtn.backgroundColor = [UIColor whiteColor];
    _deleteBtn.backgroundColor = [UIColor whiteColor];
    _shareBtn.backgroundColor = [UIColor whiteColor];
    [self _changeBtn:sender];
    //NSLog(@"置顶了");
}

- (NSString *)topTime:(NSInteger )time
{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddhhmmss"];
    NSInteger topTime =[[formatter stringFromDate:date] integerValue];
    topTime -= time;
    
    return [NSString stringWithFormat:@"%ld",topTime];
}

//置顶方法
- (void)topActionWithArr:(NSArray *)arrForModel
{
 
    LocalListManager *locManager = [LocalListManager shareLocalListManager];
    IncidentListManager *incManager = [IncidentListManager shareIncidentManager];
    JYShareList *shareList = [JYShareList shareList];
    
    NSMutableString *mAStr = [NSMutableString string];
    NSMutableString *mSStr = [NSMutableString string];
    NSMutableString *sAStr = [NSMutableString string];
    NSMutableString *sSStr = [NSMutableString string];
    NSMutableString *isTopStr = [NSMutableString string];

    NSInteger time = 0;
    for (int i = 0; i < arrForModel.count; i ++) {
        
        
        RemindModel *model = arrForModel[i];
        
        
        if (model.uid == 0) {
            
            model.isTop = [self topTime:time];
            [locManager upDataWithModel:model];
            
        }else{
            
            //我分享给他人的
            if (model.isOther == 0 && model.isShare == 1) {
                
                model.isTop = [self topTime:time];
                [shareList upDataWithModel:model];
                
                [sSStr appendFormat:@"%d,",model.uid];
                
                //别人分享给我的
            }else if(model.isOther != 0 && model.isShare == 1){
                
                model.isTop = [self topTime:time];
                [shareList upDataWithModel:model];
                [sAStr appendFormat:@"%d,",model.uid];
                
                
                //我发送给别人的
            }else if(model.isOther == 0 && model.isShare != 1){
                
                model.isTop = [self topTime:time];
                [incManager upDataWithModel:model];
                [mSStr appendFormat:@"%d,",model.uid];
                
                
            }else{
                
                model.isTop = [self topTime:time];
                [incManager upDataWithModel:model];
                [mAStr appendFormat:@"%d,",model.uid];
                
            }
            
        }
        [isTopStr appendFormat:@"%@,",model.isTop];

        time ++;
    }
    
    NSString *rmidStr = @"";
    if (mAStr.length > 0) {
        
        rmidStr = [mAStr substringWithRange:NSMakeRange(0, mAStr.length - 1)];
        
    }
    
    NSString *smidStr = @"";
    if (mSStr.length > 0) {
        
        smidStr = [mSStr substringWithRange:NSMakeRange(0, mSStr.length - 1)];
        
    }
    
    NSString *rsidStr = @"";
    if (sAStr.length > 0) {
        
        rsidStr = [sAStr substringWithRange:NSMakeRange(0, sAStr.length - 1)];
    }
    
    NSString *ssidStr = @"";
    if (sSStr.length > 0) {
        
        ssidStr = [sSStr substringWithRange:NSMakeRange(0, sSStr.length - 1)];
    }
    
    NSString *isTop = @"";
    if (isTopStr.length > 0) {
        
        isTop = [isTopStr substringWithRange:NSMakeRange(0, isTopStr.length - 1)];
    }
    
    [RequestManager actionForTopWithRmidStr:rmidStr andSmidStr:smidStr andRsidStr:rsidStr andSsidStr:ssidStr isTop:isTop];
    

    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForLoadData object:@""];
}

/******************************底部按钮及方法↑↑↑************************************/



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


