//
//  JYGroupViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/23.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYGroupViewController.h"
#import "PersonListCell.h"
#import "AddressBook.h"
#import "FriendModel.h"
#import "NewFriendViewController.h"

#define kSearchBarHeight 44.f

static JYGroupViewController *groupVC = nil;
static NSString *cellForPerson = @"cellForPerson";
static NSString *kCellIdentifierForFilterFriends = @"kCellIdentifierForFilterFriends";

@interface JYGroupViewController ()
{
   
    NSMutableArray *_arrForName;
    UITableView    *_peopleTb;
    NSDictionary   *_dicForAllName;
    NSArray *_arrForAllKey;
    
    NSArray *_group1;
    NSArray *_group2;
    NSArray *_group3;
    NSArray *_group4;

    NSDictionary *_group1Dic;
    NSDictionary *_group2Dic;
    NSDictionary *_group3Dic;
    NSDictionary *_group4Dic;
    
    NSInteger _oneGroup;
    NSInteger _twoGroup;
    NSInteger _threeGroup;
    NSInteger _fourGroup;
    
    NSMutableArray *_countForGroupArr;
    
    UIView    *_alertView;
    

    //筛选功能
    NSMutableArray *_filterFriends;//of FriendModel
    UISearchDisplayController *_searchDisplayController;

}
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIView *authorView;
@end

@interface JYGroupViewController (tableView)<UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>

- (void)_createTableView;

@end

@implementation JYGroupViewController


- (void)actionForLeft:(UIButton  *)sender
{
    
    NSArray *arr = self.navigationController.viewControllers;
    
    UIViewController *popVC = nil;
    for (int i = 0; i < arr.count; i ++) {
        
        UIViewController *vc = arr[i];
        
        if ([vc isKindOfClass:[NewFriendViewController class]]) {
            
            popVC = vc;
            
            break;
        }
        
    }
    
    [self.navigationController popToViewController:popVC animated:YES];
}

- (void)actionForReloadTb
{
    AddressBook *add = [AddressBook shareAddressBook];
 
    _countForGroupArr = [NSMutableArray array];
    
    NSDictionary *dic1 = add.arrForAddress[0];
    NSDictionary *dic2 = add.arrForAddress[1];
    NSDictionary *dic3 = add.arrForAddress[2];
    NSDictionary *dic4 = add.arrForAddress[3];
    
    //4个租的title
    _group1 = [Tool actionForReturnAllKey:dic1.allKeys];
    _group2 = [Tool actionForReturnAllKey:dic2.allKeys];
    _group3 = [Tool actionForReturnAllKey:dic3.allKeys];
    _group4 = [Tool actionForReturnAllKey:dic4.allKeys];
    
    NSMutableArray *arrForAllKey = [NSMutableArray array];

    [arrForAllKey addObjectsFromArray:_group1];
    [arrForAllKey addObjectsFromArray:_group2];
    [arrForAllKey addObjectsFromArray:_group3];
    [arrForAllKey addObjectsFromArray:_group4];
    
    _arrForAllKey = arrForAllKey;
    
    _oneGroup = _group1.count;
    _twoGroup = _group2.count;
    _threeGroup = _group3.count;
    _fourGroup = _group4.count;
    
    //4个租的cell数据
    _group1Dic = dic1;
    _group2Dic = dic2;
    _group3Dic = dic3;
    _group4Dic = dic4;
    
    
    [self actionForAddModel:dic1 andKeyArr:_group1];
    [self actionForAddModel:dic2 andKeyArr:_group2];
    [self actionForAddModel:dic3 andKeyArr:_group3];
    [self actionForAddModel:dic4 andKeyArr:_group4];
 
//    _dicForAllName = [Tool actionForReturnNameDic:_arrForName];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_peopleTb reloadData];

    });
    
    
}

- (void)actionForAddModel:(NSDictionary *)dic
                andKeyArr:(NSArray *)keyArr
{
 
    
    for (int i = 0; i < keyArr.count; i ++) {
        
        NSArray *arrForCell = [dic objectForKey:keyArr[i]];
        
        for (int j = 0; j < arrForCell.count; j ++) {
            
            FriendModel *model = arrForCell[j];
            [_countForGroupArr addObject:model];
            
        }
        
    }
    

    
}

//筛选过滤联系人 by gao
- (void)filterFriendsWithKeyword:(NSString *)keyword{
    
    if(!_filterFriends){
        _filterFriends = [NSMutableArray arrayWithCapacity:[_countForGroupArr count]];
    }else{
        [_filterFriends removeAllObjects];
    }
    
    for(FriendModel *model in _countForGroupArr){
        if([[model.friend_name lowercaseString] rangeOfString:[keyword lowercaseString]].location!= NSNotFound  || [[model.tel_phone lowercaseString] rangeOfString:[keyword lowercaseString]].location!= NSNotFound ){
            [_filterFriends addObject:model];
        }
    }

}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    _countForGroupArr = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForReloadTb) name:kNotificationForApplyFriden object:@""];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"同步通讯录";
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    _arrForName = [NSMutableArray array];

//    AddressBook *add = [AddressBook shareAddressBook];
   
//    if (add.arrForAddress.count == 0) {
//        
//        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"您当前无网络，请检查网络后重试" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alter show];
//        
//        return;
//    }
    
    [self createAllPeople];

    [self createSearchBar];
    [self _createTableView];
    
    
    //通讯录权限未开
    [self.view addSubview:self.authorView];
    self.authorView.center = CGPointMake(kScreenWidth/2.f,kScreenHeight/2.f-100);
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if(status==kABAuthorizationStatusDenied){
        self.authorView.hidden = NO;
        self.searchBar.hidden = YES;
        
    }else if(status==kABAuthorizationStatusAuthorized){
        
        AddressBook *add = [AddressBook shareAddressBook];
        [RequestManager actionForAddressBookWithArr:add.arrForBeforeA isNewFriend:NO];
    }
    
    
    //时候直接显示好友
    [self _createAlertView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createAlertView
{
    _alertView = [UIView new];
    //_alertView.backgroundColor = [UIColor bl]
    [self.view addSubview:_alertView];
}

/**
 *  创建筛选搜索框和相应VC
 */
- (void)createSearchBar{
    [self.view addSubview:self.searchBar];
}

#pragma mark 通讯录代理方法
- (void)createAllPeople
{
    
//#warning 判断通讯录时候有无网路的调用方法
    
    AddressBook *add = [AddressBook shareAddressBook];
 
    
    NSDictionary *dic1 = add.arrForAddress[0];
    NSDictionary *dic2 = add.arrForAddress[1];
    NSDictionary *dic3 = add.arrForAddress[2];
    NSDictionary *dic4 = add.arrForAddress[3];
    
    //4个租的title
    _group1 = [Tool actionForReturnAllKey:dic1.allKeys];
    _group2 = [Tool actionForReturnAllKey:dic2.allKeys];
    _group3 = [Tool actionForReturnAllKey:dic3.allKeys];
    _group4 = [Tool actionForReturnAllKey:dic4.allKeys];
    
    NSMutableArray *arrForAllKey = [NSMutableArray array];
    
    [arrForAllKey addObjectsFromArray:_group1];
    [arrForAllKey addObjectsFromArray:_group2];
    [arrForAllKey addObjectsFromArray:_group3];
    [arrForAllKey addObjectsFromArray:_group4];
    
    _arrForAllKey = arrForAllKey;
    
    _oneGroup = _group1.count;
    _twoGroup = _group2.count;
    _threeGroup = _group3.count;
    _fourGroup = _group4.count;
    
    //4个租的cell数据
    _group1Dic = dic1;
    _group2Dic = dic2;
    _group3Dic = dic3;
    _group4Dic = dic4;


}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
//    AddressBook *data = [AddressBook shareAddressBook];
//
//    [RequestManager actionForAddressBookWithArr:data.arrForBeforeA isNewFriend:NO];

}


@end

@implementation JYGroupViewController (tableView)


- (void)_createTableView
{
 
//    _peopleTb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66)];
    _peopleTb = [[UITableView alloc]initWithFrame:CGRectMake(0,kSearchBarHeight, kScreenWidth, kScreenHeight-kSearchBarHeight-66)];
    _peopleTb.delegate = self;
    _peopleTb.dataSource = self;
    [self.view addSubview:_peopleTb];
    
    UIView *viewForFoot = [UIView new];
    [_peopleTb setTableFooterView:viewForFoot];
    //注册单元格
    [_peopleTb registerNib:[UINib nibWithNibName:@"PersonListCell" bundle:nil] forCellReuseIdentifier:cellForPerson];
    

//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
//    line.backgroundColor = lineColor;
//    [self.view addSubview:line];
    
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterFriendsWithKeyword:searchString];
    return YES;
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}
/*
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    
    //return _arrForAllKey.count;
    
    
    
    return _arrForAllKey.count;
}
*/

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 
    return 30;
}
*/
 
 
/*
//头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UIView *viewForHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
    viewForHead.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 6.5, 200, 15)];
    UILabel *labelForTitleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 28)];
    labelForTitleText.font = [UIFont boldSystemFontOfSize:17];
    labelForTitleText.textAlignment = NSTextAlignmentCenter;
    
    if (section == 0 && _oneGroup != 0) {
        
        //labelForTitle.text = [NSString stringWithFormat:@"%@",_arrForAllKey[section]];
        labelForTitleText.text = @"已请求的好友";
        [viewForHead addSubview:labelForTitleText];

    }else if(section - _oneGroup == 0){
    
       // labelForTitle.text = [NSString stringWithFormat:@"%@",_arrForAllKey[section]];
        labelForTitleText.text = @"可直接添加的好友";
        [viewForHead addSubview:labelForTitleText];
        
    }else if(section - _twoGroup - _oneGroup  == 0){
    
        //labelForTitle.text = [NSString stringWithFormat:@"%@",_arrForAllKey[section]];
        labelForTitleText.text = @"待邀请的好友";
        [viewForHead addSubview:labelForTitleText];

        
    }else if(section - _threeGroup - _twoGroup - _oneGroup  == 0){
    
        
        //labelForTitle.text = [NSString stringWithFormat:@"%@",_arrForAllKey[section]];
        labelForTitleText.text = @"已添加的好友";
        [viewForHead addSubview:labelForTitleText];

    
    }else {
     
        //labelForTitle.text = _arrForAllKey[section];
    }
    
    
    [viewForHead addSubview:labelForTitle];
    
    
    return viewForHead;
}
*/
 
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==_peopleTb){
        
        return _countForGroupArr.count;
    }else{
        //过滤结果
        return [_filterFriends count];
    }
    
    
    //分组
    /*
    if (section < _oneGroup) {
        
        NSArray *arrForCount = [_group1Dic objectForKey:_arrForAllKey[section]];
        
        return arrForCount.count;
        
    }else if(section >= _oneGroup && section < _oneGroup + _twoGroup){
     
        NSArray *arrForCount = [_group2Dic objectForKey:_arrForAllKey[section]];
       
        return arrForCount.count;
        
    }else if(section >= _oneGroup + _twoGroup && section < _oneGroup + _twoGroup + _threeGroup){
    
        NSArray *arrForCount = [_group3Dic objectForKey:_arrForAllKey[section]];
        
        return arrForCount.count;
    
    }else{
    
        NSArray *arrForCount = [_group4Dic objectForKey:_arrForAllKey[section]];
        
        return arrForCount.count;
    
    }
    */
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    PersonListCell *cell;
    if(tableView==_peopleTb){
        cell = [tableView dequeueReusableCellWithIdentifier:cellForPerson];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierForFilterFriends];
    }
    
//    if (!cell) {
    
//        cell = [[PersonListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellForPerson];
    
//    }
    
    //NSArray *arrForOneGroup = nil;
    
    
    //之前的逻辑，现在不分abcd
    /*
    if (indexPath.section <_oneGroup) {
        
        arrForOneGroup = [_group1Dic objectForKey:_arrForAllKey[indexPath.section]];
        
    }else if(indexPath.section >= _oneGroup && indexPath.section < _oneGroup + _twoGroup){
      
        arrForOneGroup = [_group2Dic objectForKey:_arrForAllKey[indexPath.section]];
    
    }else if(indexPath.section >= _oneGroup + _twoGroup && indexPath.section < _oneGroup + _twoGroup + _threeGroup){
    
        arrForOneGroup = [_group3Dic objectForKey:_arrForAllKey[indexPath.section]];
        
    }else{
     
         arrForOneGroup = [_group4Dic objectForKey:_arrForAllKey[indexPath.section]];
    }
    */
    
    FriendModel *model;
    
    if(tableView==_peopleTb){
        model = _countForGroupArr[indexPath.row];
    }else{//过滤结果
        model = _filterFriends[indexPath.row];
    }
    cell.personName.text = model.friend_name;
    cell.number.text = [NSString stringWithFormat:@"%@",model.tel_phone];
    cell.Status.hidden = YES;
    
    if (model.status == 0) {
        
        cell.statusImage.image = [UIImage imageNamed:@"邀请"];
        
    }else if(model.status == 1){
        
        cell.statusImage.image = [UIImage imageNamed:@"添加朋友"];
        
    }else if(model.status == 2){
        
        cell.statusImage.image = [UIImage imageNamed:@"已添加"];
        
    }else if(model.status == 3){
        
        cell.statusImage.image = [UIImage imageNamed:@"等待验证"];
        
    }

    /*
    if (arrForOneGroup.count > 0) {
        
        //0邀请、1可添加、2已添加
        FriendModel *model = arrForOneGroup[indexPath.row];
        cell.personName.text = model.friend_name;
        cell.number.text = [NSString stringWithFormat:@"%@",model.tel_phone];
        cell.Status.hidden = YES;
        
     
        if (model.status == 0) {
            
            cell.statusImage.image = [UIImage imageNamed:@"邀请"];
            
        }else if(model.status == 1){
        
            cell.statusImage.image = [UIImage imageNamed:@"添加朋友"];
            
        }else if(model.status == 2){
        
            cell.statusImage.image = [UIImage imageNamed:@"已添加"];
            
        }else if(model.status == 3){
        
            cell.statusImage.image = [UIImage imageNamed:@"等待验证"];
            
        }
        
    }
    */
    
    
    return cell;
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    return 75;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FriendModel *model;
    
    if(tableView==_peopleTb){
        model = _countForGroupArr[indexPath.row];
    }else{//过滤结果
        model = _filterFriends[indexPath.row];
    }
    
    //0邀请、1可添加、2已添加、3等待验证
    if (model.status == 0) {
        
        
        //跳转微信分享
        [self shareToWeiXin];
        
//        NSArray *arrForTel = [model.tel_phone componentsSeparatedByString:@" "];
//        NSString *telStr = @"";
//        
//        if (arrForTel.count > 1) {
//            
//            telStr = arrForTel[1];
//            
//        }else{
//            
//            telStr = model.tel_phone;
//        }
//        
        
//        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
//        
//        picker.messageComposeDelegate = self;
//        
//        picker.navigationBar.tintColor = [UIColor blackColor];
//        
//        picker.body = @"我在使用#小秘#，全球首款时间提醒交互软件！让我给你当小秘吧~下载地址：http://itunes.apple.com/us/app/id1073540859";
//        
//        picker.recipients = [NSArray arrayWithObject:telStr];
//        
//        [self presentViewController:picker animated:YES completion:^{
//            
//            
//        }];
        
        
          
    }else if(model.status == 1){
    
        NSArray *arrForTel = [model.tel_phone componentsSeparatedByString:@" "];
        NSString *telStr = @"";
        
        if (arrForTel.count > 1) {
            
            telStr = arrForTel[1];
            
        }else{
            
            telStr = model.tel_phone;
        }
        
        model.status = 3;
        
        [tableView reloadData];
        
        [RequestManager actionForAddFriendWithTel:telStr];
        
    }else if(model.status == 2){
    
 
        
    }else if(model.status == 3){
    
      
    }

}
- (void)shareToWeiXin
{
    // 检查微信是否已被用户安装
    if ([WXApi isWXAppInstalled]) {
       
        WXMediaMessage *message = [WXMediaMessage message];
      
        UIImage *img = [UIImage imageNamed:@"xm_icon"]; 
        message.description = [NSString stringWithFormat:@"我在使用#小秘#，全球首款时间提醒交互软件！让我给你当小秘吧~"];
        message.title = @"推荐一款时间管理的应用";
        [message setThumbImage:img];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"xm_icon" ofType:@"png"];
        message.thumbData = [NSData dataWithContentsOfFile:filePath];
        
        // 多媒体消息中包含的网页数据对象
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = @"https://itunes.apple.com/us/app/id1073540859";
        message.mediaObject = ext;
        
  
        
        // 第三方程序发送消息至微信终端程序的消息结构体
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
        
    } else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"尚未安装微信客户端" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
 
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}

- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width                                                          , kSearchBarHeight)];
        _searchBar.placeholder = @"搜索";
        _searchBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        _searchBar.backgroundImage = [UIImage new];
        UITextField *searchField=[((UIView *)[_searchBar.subviews objectAtIndex:0]).subviews lastObject];
        if(searchField){
            searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            searchField.layer.borderWidth = 0.5f;
            searchField.layer.cornerRadius = 5.f;
            searchField.layer.masksToBounds = YES;
        }
        
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        _searchDisplayController.delegate = self;
        [_searchDisplayController.searchResultsTableView registerNib:[UINib nibWithNibName:@"PersonListCell" bundle:nil] forCellReuseIdentifier:kCellIdentifierForFilterFriends];
        _searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
    }
    return _searchBar;
}

- (UIView *)authorView
{
    if(!_authorView){
        _authorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _authorView.hidden = YES;
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,30)];
        titleLabel.text = @"小秘没有权限访问您的通讯录";
        titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_authorView addSubview:titleLabel];
        
        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,30, kScreenWidth-80,60)];
        descLabel.numberOfLines = 0;
        descLabel.text = @"您可以进入系统\"设置>隐私>通讯录\"，允许\"小秘\"访问您的手机通讯录。";
        descLabel.textColor = [UIColor lightGrayColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.font = [UIFont systemFontOfSize:14.f];
        [_authorView addSubview:descLabel];
    }
    return _authorView;
}
@end


