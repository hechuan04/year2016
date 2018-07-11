//
//  JYFriendListVC.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/8.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYFriendListVC.h"
#import "NewFriendViewController.h"
#import "NewGroupViewController.h"
#import "NewAddFriend.h"
#import "PushFriendViewC.h"
#import "JYPersonCentreViewController.h"
#import "FriendCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

static NSString *strForFriendList = @"strForFriendList";

@interface JYFriendListVC ()
{
 
    UITableView *_friendList;
    NSDictionary *_dicForAllName;
    NSArray     *_arrForAllKey;
    NSMutableArray *_newFriendArr;
    BOOL _isHaveNewFriend;
    
}
@property (nonatomic,strong) UIButton *btnForMe;
@property (nonatomic,strong) UIAlertView *deleteAlterView;
@end

@interface JYFriendListVC (tableView)<UITableViewDataSource,UITableViewDelegate>

- (void)createTableView;

@end

@implementation JYFriendListVC



- (void)actionForReloadTabeView:(id)isReload
{
    DataArray *dataArr = [DataArray shareDateArray];

    
    dispatch_async(dispatch_get_main_queue(), ^{
    
  
        _dicForAllName = [Tool actionForReturnNameDic:dataArr.arrForAllFriend];
        _arrForAllKey = [Tool actionForReturnAllKey:_dicForAllName.allKeys];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:newFriendCount] intValue] > 0) {
            
            _managerBtn.numberOfNewfriendLabel.hidden = NO;
            
        }else{
            
            _managerBtn.numberOfNewfriendLabel.hidden = YES;
        }
        
        _managerBtn.numberOfNewfriendLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:newFriendCount] stringValue];
        
        [_friendList reloadData];

    });
    
    [[JYNotReadList shareNotReadList] selectNotReadRemind];

}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)actionForLeft:(UIButton *)sender
{
 
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)rightAction
{
 
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)firstLogin
{
 
    UIImageView *imageForNew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    imageForNew.image = [UIImage imageNamed:@"新手引导页1.png"];
    imageForNew.tag = 789;
    [self.tabBarController.view addSubview:imageForNew];
    
    if (IS_IPHONE_4_SCREEN) {
        
        imageForNew.image = [UIImage imageNamed:@"引导页4-2.png"];
        
    }else if (IS_IPHONE_5_SCREEN){
        
        imageForNew.image = [UIImage imageNamed:@"引导页5-2.png"];
        
    }else if (IS_IPHONE_6_SCREEN){
        
        CGFloat scal = [[UIScreen mainScreen] scale];
        
        if (scal == 2) {
            
            imageForNew.image = [UIImage imageNamed:@"引导页6-2.png"];
            
        }else {
            
            imageForNew.image = [UIImage imageNamed:@"引导页6p-2d.png"];
        }
        
        
    }else if (IS_IPHONE_6P_SCREEN){
        
        imageForNew.image = [UIImage imageNamed:@"引导页6p-2.png"];
        
    }
    
   
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    [cancelBtn addTarget:self action:@selector(removeNewAction) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = 890;
    [self.tabBarController.view addSubview:cancelBtn];
}

- (void)removeNewAction
{
    UIImageView *iamgeV = (UIImageView *)[self.tabBarController.view viewWithTag:789];
    UIButton *btn = (UIButton *)[self.tabBarController.view viewWithTag:890];
    [iamgeV removeFromSuperview];
    [btn removeFromSuperview];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstLoginFriend];
}

- (void)actionForSetLeftBtn
{
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadAddressBook];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundMode) name:UIApplicationWillResignActiveNotification object:nil];
    
    [GuideView showGuideWithImageName:@"新手引导页6"];
    
//    BOOL isFirstLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kFirstLoginFriend];
//    
//    if (!isFirstLogin) {
//        
//        [self firstLogin];
//    }
    
    _managerBtn = [ManagerForButton shareManagerBtn];

    self.navigationItem.title = @"好友列表";
    
  
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForReloadTabeView:) name:kNotificationForNewFriend object:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForReloadTabeView:) name:kNotificationForAcceptFriend object:@""];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:kNotificationForReloadRemark object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSkin:) name:kNotificationForChangeSkin object:nil];
    
    DataArray *dataArr = [DataArray shareDateArray];
    
    _newFriendArr = [NSMutableArray array];
    _dicForAllName = [Tool actionForReturnNameDic:dataArr.arrForAllFriend];
    _arrForAllKey = [Tool actionForReturnAllKey:_dicForAllName.allKeys];
    
    [_newFriendArr addObject:@"新的朋友"];
    [_newFriendArr addObject:@"群组"];
    //[_newFriendArr addObjectsFromArray:dataArr.arrForNewFreind];
    
    [self createTableView];

//    [[AddressBook shareAddressBook] actionForAddress];
    
//    [self setupRightButtonItem];
}
//- (void)setupRightButtonItem
//{
//    self.btnForMe = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btnForMe.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
//    [self.btnForMe setImage:[[UIImage imageNamed:@"我"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]forState:UIControlStateNormal];
//    self.btnForMe.frame = CGRectMake(0, 0, 22, 22);
//    [self.btnForMe addTarget:self action:@selector(actionForMe:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.btnForMe];
//    self.navigationItem.rightBarButtonItem = item;
//}

//如果已授权，就加载通讯录，（为防止卡顿，第一次授权放在点击同步通讯录时)
- (void)loadAddressBook
{
//    if(kSystemVersion<9){
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if(authStatus ==kABAuthorizationStatusAuthorized){
            AddressBook *book = [AddressBook shareAddressBook];
            [book actionForAddress];
        }
//    }
    
}
//弹出我页面
- (void)actionForMe:(UIButton *)sender
{
    JYPersonCentreViewController *personVC = [[JYPersonCentreViewController alloc] init];
    personVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:personVC animated:YES];
}

//换皮肤
- (void)changeSkin:(NSNotification *)notice
{
    self.btnForMe.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
}

- (void)refreshTableView
{
    NSArray *allFriend = [[FriendListManager shareFriend] selectAllData]; //好友
    DataArray *dataArr = [DataArray shareDateArray];
    dataArr.arrForAllFriend = allFriend;
    
    //copy 旧逻辑
    _newFriendArr = [NSMutableArray array];
    _dicForAllName = [Tool actionForReturnNameDic:dataArr.arrForAllFriend];
    _arrForAllKey = [Tool actionForReturnAllKey:_dicForAllName.allKeys];
    [_newFriendArr addObject:@"新的朋友"];
    [_newFriendArr addObject:@"群组"];

    [_friendList reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

  
}

- (void)enterBackgroundMode
{
    if(self.deleteAlterView){
        [self.deleteAlterView dismissWithClickedButtonIndex:0 animated:NO];
        [_friendList endEditing:YES];
    }
    
}
@end

@implementation JYFriendListVC (tableView)

- (void)createTableView
{
    
    _friendList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66 - 52) style:UITableViewStylePlain];
    _friendList.delegate = self;
    _friendList.dataSource = self;
    _friendList.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_friendList.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    //改变索引的颜色
    _friendList.separatorInset = UIEdgeInsetsZero;
    _friendList.sectionIndexColor = [UIColor lightGrayColor];
    _friendList.sectionIndexBackgroundColor = [UIColor clearColor];
    _friendList.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    [self.view addSubview:_friendList];
    
    UIView *viewBG = [UIView new];
    
    viewBG.backgroundColor = [UIColor whiteColor];
    
    [_friendList setTableFooterView:viewBG];
//    [_friendList registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:strForFriendList];
    [_friendList registerClass:[FriendCell class] forCellReuseIdentifier:strForFriendList];
    

    _managerBtn.numberOfNewfriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 20, 20, 20)];
    _managerBtn.numberOfNewfriendLabel.text = [[[NSUserDefaults standardUserDefaults] objectForKey:newFriendCount] stringValue];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:newFriendCount] intValue] > 0) {
        
        _managerBtn.numberOfNewfriendLabel.hidden = NO;
        
    }else{
     
        _managerBtn.numberOfNewfriendLabel.hidden = YES;
    }
    
    _managerBtn.numberOfNewfriendLabel.textColor = [UIColor whiteColor];
    _managerBtn.numberOfNewfriendLabel.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:59 / 255.0 blue:48 / 255.0 alpha:1];
    _managerBtn.numberOfNewfriendLabel.textAlignment = NSTextAlignmentCenter;
    _managerBtn.numberOfNewfriendLabel.layer.cornerRadius = _managerBtn.numberOfNewfriendLabel.width / 2.;
    _managerBtn.numberOfNewfriendLabel.layer.masksToBounds = YES;
    _managerBtn.numberOfNewfriendLabel.font = [UIFont systemFontOfSize:13];

    [_friendList addSubview:_managerBtn.numberOfNewfriendLabel];
    
    
}


#pragma mark tableView代理方法
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger index = section;
    NSArray *groupPeople = nil;
    
    if (section >= 1) {
        
        index = section - 1;
        groupPeople = [_dicForAllName objectForKey:_arrForAllKey[index]];

    }else{
     
        index = section;
        groupPeople = _newFriendArr;
    }
    

    return groupPeople.count;
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _arrForAllKey.count + 1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if(section==0&&[_arrForAllKey count]==0){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200.f)];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 0.5)];
        lineView.backgroundColor = [UIColor  colorWithRGBHex:0xcccccc];
        [view addSubview:lineView];
        
        
//        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, kScreenWidth,200.f)];
//        label.text = @"主人您还没有好友啊,快去添加好友吧";
//        label.numberOfLines = 0;
//        label.font = [UIFont systemFontOfSize:17.f];
//        label.textColor = [UIColor lightGrayColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        [view addSubview:label];
        
        UIImageView *emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无好友"]];
        emptyView.center = view.center;
        [view addSubview:emptyView];
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section==0&&[_arrForAllKey count]==0){
        return 200.f;
    }
    return 0;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    if (section == 0) {
        
        return 0.;
        
    }else{
    
        return 17.5;

    }
    

}

//头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *viewForHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 17.5)];
    viewForHead.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 17.5)];
   // labelForTitle.backgroundColor = [UIColor orangeColor];
   // labelForTitle.font = [UIFont systemFontOfSize:20];
    if (section == 0) {
        
        UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
        viewForLine.backgroundColor = lineColor;
        
        return viewForLine;
        
    }else{
       
        labelForTitle.text = _arrForAllKey[section - 1];

    }
    
    [viewForHead addSubview:labelForTitle];
    
    
    return viewForHead;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:strForFriendList];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section==0){
        if(indexPath.row==0){//新的朋友
            [cell setImage:[UIImage imageNamed:@"新的朋友"] title:@"新的朋友"];
            
        }else if(indexPath.row==1){
            [cell setImage:[UIImage imageNamed:@"群组"] title:@"群组"];
        }
    }else{
        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
        FriendModel *model = arrForG[indexPath.row];
        
        NSString *nameStr = @"";
        
        AddressBook *addbook = [AddressBook shareAddressBook];
        NSString *telNameStr = [addbook.dicForAllTelAndName objectForKey:model.tel_phone];
        if (model.remarkName&&![model.remarkName isEqualToString:@""]){//有备注优先显示备注
            nameStr = model.remarkName;
        }else if (telNameStr != nil) {
            nameStr = [NSString stringWithFormat:@"%@ (%@)",model.friend_name,telNameStr];
        }else{
            nameStr = [NSString stringWithFormat:@"%@",model.friend_name];
        }
        
        int uid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        if (model.fid == uid) {
            NSString *headUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
            [cell setHeadUrl:headUrlStr name:@"俺自己"];
        }else{
            [cell setHeadUrl:model.head_url name:nameStr];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){
        if(indexPath.row==0){//点击新的朋友
            [RequestManager actionForSelectLoginFriendIsNew:YES];
            
            NewFriendViewController *newF = [[NewFriendViewController alloc] init];
            newF.title = @"新的朋友";
            
            newF.hidesBottomBarWhenPushed = YES;
            
            NSMutableArray *arr = [NSMutableArray array];
            
            
            [arr addObject:@"同步手机通讯录"];
            [arr addObject:@"QQ"];
            [arr addObject:@"微信"];
            [arr addObject:@"微博"];
            [arr addObject:@"扫一扫"];
            
            
            //如果微博登录同步微博好友
            
            DataArray *data = [DataArray shareDateArray];
            
            [arr addObjectsFromArray:data.arrForNewFreind];
            
            newF.arrForNewFriend = arr;
            
            //_isHaveNewFriend = NO;
            
            [_friendList reloadData];
            
            //_managerBtn.numberLabelForPerson.hidden = YES;
            
            
            [self.navigationController pushViewController:newF animated:YES];
        }else if(indexPath.row==1){//点击群组
            //监测群组
            [RequestManager actionForHttp:@"query_group"];
            
            //查询群组
            [RequestManager actionForGroup];
            
            NewGroupViewController *newG = [[NewGroupViewController alloc] init];
            newG.hidesBottomBarWhenPushed = YES;
            newG.title = @"群组";
            newG.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:newG animated:YES];

        }
    }else{
        
        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
        FriendModel *model = arrForG[indexPath.row];
        
        //好友
        PushFriendViewC *friendVC = [[PushFriendViewC alloc] init];
        
        friendVC.model = model;
        
        if (model.fid != [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]integerValue]) {
            friendVC.showRemarkView = YES;
        }
        friendVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:friendVC animated:YES];
        

    }
}
/*
//创建单元格
- (UITableViewCell *)tableView_old:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strForFriendList];
    
    if (!cell) {
        
        cell = [[FriendTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForFriendList];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.lineBreakMode = UITableViewCellSeparatorStyleSingleLine;
    
    if (indexPath.section == 0) {
        
        cell.userHead.layer.masksToBounds = NO;
        cell.userHead.layer.cornerRadius = cell.userHead.width / 2.0;
        
        if (indexPath.row == 0) {
            
            cell.friendLabel.text = @"新的朋友";
            cell.userHead.image = [UIImage imageNamed:@"新的朋友.png"];
            
            
        }else if(indexPath.row == 1){
            
            cell.friendLabel.text = @"群组";
            cell.userHead.image = [UIImage imageNamed:@"群组.png"];
            
        }
        
    }else{
        
        
        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
        cell.userHead.layer.cornerRadius = cell.userHead.width / 2.0;
        cell.userHead.layer.masksToBounds = YES;
        FriendModel *model = arrForG[indexPath.row];
        
        if (model.fid == [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]integerValue]) {
            
            cell.bgScroll.scrollEnabled = NO;

        }else{
            
            cell.bgScroll.scrollEnabled = YES;
        }
        
        NSString *nameStr = @"";
     
        AddressBook *addbook = [AddressBook shareAddressBook];
        NSString *telNameStr = [addbook.dicForAllTelAndName objectForKey:model.tel_phone];
        
        if (model.remarkName&&![model.remarkName isEqualToString:@""]){//有备注优先显示备注
            
            nameStr = model.remarkName;
            
        }else if (telNameStr != nil) {
            
            nameStr = [NSString stringWithFormat:@"%@ (%@)",model.friend_name,telNameStr];
            
        }else{
         
            nameStr = [NSString stringWithFormat:@"%@",model.friend_name];
        }
  
        
        cell.friendLabel.text = nameStr;
        int uid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        if (model.fid == uid) {
            NSString *headUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
            [cell.userHead sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];

        }else{
        
            [cell.userHead sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        }
        
        if (model.keystatus == 1) {
            
            [cell.keyBtn setTitle:@"取消关键人" forState:UIControlStateNormal];
            
        }else{
         
             [cell.keyBtn setTitle:@"设置关键人" forState:UIControlStateNormal];
        }
        
    }
    
    if (indexPath.section == 0) {
        
        cell.bgScroll.scrollEnabled = NO;
        
    }
    
   
    
    //单纯点中
    [cell setActionForPushIndex:^(NSIndexPath *indexPath) {
        
        //新建组和朋友
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                [RequestManager actionForSelectLoginFriendIsNew:YES];
                
                
                NewFriendViewController *newF = [[NewFriendViewController alloc] init];
                newF.title = @"新的朋友";
                
                newF.hidesBottomBarWhenPushed = YES;
                
                NSMutableArray *arr = [NSMutableArray array];
                
                
                [arr addObject:@"同步手机通讯录"];
                [arr addObject:@"QQ"];
                [arr addObject:@"微信"];
                [arr addObject:@"微博"];
                [arr addObject:@"扫一扫"];
                
                
                //如果微博登录同步微博好友
                
                DataArray *data = [DataArray shareDateArray];
                
                [arr addObjectsFromArray:data.arrForNewFreind];
                
                newF.arrForNewFriend = arr;
                
                //_isHaveNewFriend = NO;
                
                [_friendList reloadData];
                
                //_managerBtn.numberLabelForPerson.hidden = YES;

                
                [self.navigationController pushViewController:newF animated:YES];
                
            }else if(indexPath.row == 1){
                
                //监测群组
                [RequestManager actionForHttp:@"query_group"];
                
                //查询群组
                [RequestManager actionForGroup];
                
                NewGroupViewController *newG = [[NewGroupViewController alloc] init];
                newG.hidesBottomBarWhenPushed = YES;
                newG.title = @"群组";
                newG.view.backgroundColor = [UIColor whiteColor];
                [self.navigationController pushViewController:newG animated:YES];
                
            }
            
        }
        //好友push
        else
        {
            NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
            FriendModel *model = arrForG[indexPath.row];
            
            //好友
            PushFriendViewC *friendVC = [[PushFriendViewC alloc] init];
            
            friendVC.model = model;
            
            if (model.fid != [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]integerValue]) {
                friendVC.showRemarkView = YES;
            }
            friendVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:friendVC animated:YES];
      
        }
        
        
    }];
    
    //删除
    [cell setActionForDelete:^(FriendTableViewCell *selectCell) {
        
        
        
        NSIndexPath *indexPath = [_friendList indexPathForCell:selectCell];
        
        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
        
        FriendModel *model = arrForG[indexPath.row];
        
        NSString *strForTitle = [NSString stringWithFormat:@"您确定要删除%@?",model.friend_name];
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:strForTitle message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alterView show];
        
        _friend_model = model;
        [selectCell.bgScroll setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }];
    
    //设为关键人
    [cell setActionForKeyPath:^(FriendTableViewCell *selectCell) {
        
        [selectCell.bgScroll setContentOffset:CGPointMake(0, 0) animated:NO];
        NSIndexPath *indexPath = [_friendList indexPathForCell:selectCell];
        
        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
        
        FriendModel *model = arrForG[indexPath.row];
        int keyStatus = 0;
        if (model.keystatus == 1) {
         
            keyStatus = 0;

        }else{
        
            keyStatus = 1;
        
        }
        
        __block JYFriendListVC *weekSelf = self;
        [RequestManager actionForKeyStatus:model type:keyStatus keyBlock:^(BOOL success) {
            
            if (success) {
                
                [Tool showAlter:weekSelf title:@"设置成功"];

                
            }else{
             
//                __sheetWindow = [WKAlertView showAlertViewWithStyle:WKAlertViewStyleFail title:@"温馨提示" detail:@"网络异常！" canleButtonTitle:nil okButtonTitle:@"确定" callBlock:^(MyWindowClick buttonIndex) {
//                    
//                    //Window隐藏，并置为nil，释放内存 不能少
//                    __sheetWindow.hidden = YES;
//                    __sheetWindow = nil;
//                    
//                }];
                [Tool showAlter:weekSelf title:@"网络异常，请检查您的网络"];

            }
            
        }];
   
    }];
    
    return cell;
    
}
*/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
 
    if (buttonIndex == 0) {
        
        NSLog(@"取消删除好友");
        [_friendList setEditing:NO];
        
    }else {
     
        NSLog(@"确定删除好友");
        [RequestManager actionForDeleteFriendWithFid:(int )_friend_model.fid];
        _friend_model = nil;
        [_friendList reloadData];
        
    }
    
}

 
- (BOOL )tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0){ //新的朋友，群组
        return NO;
    }else if(indexPath.section==1&&indexPath.row==0){
        return NO;
//        //俺自己不能编辑
//        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
//        FriendModel *model = arrForG[indexPath.row];
//        if (model.fid == [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID]integerValue]) {
//            return NO;
//        }
    }
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indexArr = [NSMutableArray arrayWithCapacity:_arrForAllKey.count+1];
    [indexArr addObject:@" "];
    [indexArr addObjectsFromArray:_arrForAllKey];
    return indexArr;
}
#pragma mark 可编辑状态
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (editingStyle == UITableViewCellEditingStyleDelete) {
      
        
        
        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
        
        FriendModel *model = arrForG[indexPath.row];
        
        NSString *strForTitle = [NSString stringWithFormat:@"您确定要删除%@?",model.friend_name];
        self.deleteAlterView = [[UIAlertView alloc] initWithTitle:strForTitle message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [self.deleteAlterView show];
        
        _friend_model = model;
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
     
    }
}


@end

