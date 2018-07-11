//
//  NewFriendViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "NewFriendViewController.h"
#import "NewFriendTBCell.h"
#import "JYGroupViewController.h"
#import "BindPhoneView.h"
#import "NewAddFriend.h"
#import "MyWeiboListController.h"
#import "toBindWeiboController.h"
#import "SearchFriendCell.h"
#import "SearchFriendModel.h"
#import "ImageViewController.h"
#import "SearchFriendDetailViewController.h"
#import "CamerManager.h"


#define SCANVIEW_EdgeTop kScreenHeight/5
#define SCANVIEW_EdgeLeft 50.0
#define TINTCOLOR_ALPHA 0.7     //浅色透明度
#define DARKCOLOR_ALPHA 0.5     //深色透明度

#define kSearchBarHeight 44.f

#define kTagMergeDataQQ 10001
#define kTagMergeDataWeiXin 10002
#define kTagMergeDataWeiBo 10003

static NSString *kCellIdentifierForFilterFriends = @"kCellIdentifierForFilterFriends";

static NSString *strForNewFriendList = @"strForNewFriendList";

@interface NewFriendViewController ()<UIAlertViewDelegate> {
    BOOL isWeiboLogin;
    UILabel *_labelForMark;
    UIView *_scanView;
    UIView *_QrCodeline;
    NSTimer *_timer;
    BOOL   _isBack;
    UISearchDisplayController *_searchDisplayController;
    
    //搜索操作
    AFHTTPRequestOperation *_searchOperation;
    NSString *_searchString;
    
    UIBarButtonItem *_rightBarItem;
    TencentOAuth *tencentOAuth;
}
@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,assign) NSInteger otherAccountUid;
@end

@implementation NewFriendViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self stopTimer];
}

- (void)acceptAction {
    
    NSMutableArray *arr = [NSMutableArray array];
    DataArray *dataManager = [DataArray shareDateArray];
    //if (isWeiboLogin) {
        
    [arr addObject:@"同步手机通讯录"];
    [arr addObject:@"QQ"];
    [arr addObject:@"微信"];
    [arr addObject:@"微博"];
    [arr addObject:@"扫一扫"];
    [arr addObjectsFromArray:dataManager.arrForNewFreind];
    
        _arrForNewFriend = arr;
        
    /*}else{
        
        [Arr addObject:@"手机"];

        [Arr addObjectsFromArray:dataManager.arrForNewFreind];
        _arrForNewFriend = Arr;

    }*/
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //_labelForMark.origin = CGPointMake(0, 20 + _arrForNewFriend.count * 60);
        
        [_tableView reloadData];
        
    });
    
}

- (void)actionForLeft:(UIButton *)sender {
    //在点这个按钮的时候就已经知道了有多少个待接收好友
    
    if (_isBack) {
        
        [self.readerView stop];
        
        [self.readerView removeFromSuperview];
        
        [_timer invalidate];
        
        _isBack = NO;
        
        self.navigationItem.rightBarButtonItem = nil;
    }else{
     
     
        [self.navigationController popViewControllerAnimated:YES];
    }
    
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];

    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptAction) name:kNotificationForAcceptFriend object:@""];
    
    isWeiboLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:kWeiboLogin] boolValue];
    
    [self createSearchBar];
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  创建筛选搜索框和相应VC
 */
- (void)createSearchBar{
    [self.view addSubview:self.searchBar];
}
#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self searchNewFriendWithKeyword:searchString];
    _searchString = searchString;
    return YES;
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    _searchString = @"";
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationForAddNewFriend object:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    //监测搜索好友
    [RequestManager actionForHttp:@"new_friend_search"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadFriendStatus:) name:kNotificationForAddNewFriend object:nil];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}
#pragma mark - 搜索新朋友（手机、小秘id、昵称）
- (void)searchNewFriendWithKeyword:(NSString *)keyword{
    
    if(!keyword||[keyword isEqualToString:@""]){
        return;
    }
    [self.searchFriendResults removeAllObjects];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@searchEveryFriend",kXiaomiUrl];;
    NSURL *url = [NSURL URLWithString:urlStr];
    AFHTTPRequestOperationManager *manager =[[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    //参数
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:xiaomiID forKey:@"uid"];
    [params setObject:keyword forKey:@"validate"];
    if(_searchOperation){
        [_searchOperation cancel];
    }
    AFHTTPRequestOperation *operation = [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(![operation isCancelled]){
            
            if(responseObject&&[responseObject isKindOfClass:[NSDictionary class]]){
                
                if ([[responseObject objectForKey:@"flag"] isEqualToString:@"succ"]) {
                    
                    NSArray *results = [responseObject objectForKey:@"data"];
                    
                    for(int i=0;i<[results count];i++){
                        SearchFriendModel *m = [[SearchFriendModel alloc]initWithDictionary:results[i]];
                        [self.searchFriendResults addObject:m];
                    }
                    [self.searchDisplayController.searchResultsTableView reloadData];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(![operation isCancelled]){
            UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"网络异常，请重试!" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alterView show];
        }
    }];
    
    _searchOperation = operation;
}

- (void)addNewFriend:(SearchFriendModel *)friend{
    if(friend.status==2){//可添加
        [self addFriends:[NSString stringWithFormat:@"%ld",friend.uid]];
    }else if(friend.status==-1){//验证通过
        [self acceptFriendRequest:[NSString stringWithFormat:@"%ld",friend.uid]];
    }
}

//同RequestManager中 ：+ (void )actionForAcceptRequest:(int )fid type:(int )type
- (void)acceptFriendRequest:(NSString *)fid{
    [RequestManager actionForAcceptNewFriend:fid];
}

- (void)reloadFriendStatus:(NSNotification *)notice
{
    NSDictionary *dic = notice.userInfo;
    NSString *fid = [dic valueForKey:@"fid"];
    for(SearchFriendModel *model in self.searchFriendResults){
        if([fid isEqualToString:[NSString stringWithFormat:@"%ld",model.uid]]){
            if(model.status==-1){
                model.status = 1;
            }else if(model.status==2){
                model.status = 0;
            }
        }
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}
#pragma mark 创建tb
- (void)createTableView {
  
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kSearchBarHeight, kScreenWidth, kScreenHeight - kSearchBarHeight - 64) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"NewFriendTBCell" bundle:nil] forCellReuseIdentifier:strForNewFriendList];
    
    UIView *footV = [UIView new];
    
    [_tableView setTableFooterView:footV];

   
    _labelForMark = [[UILabel alloc] initWithFrame:CGRectMake(122, 60 * 4 + 17.5, 200, 25)];
    _labelForMark.text = @"扫描二维码名片";
    _labelForMark.textColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1];
    _labelForMark.textAlignment = NSTextAlignmentLeft;
    //_labelForMark.backgroundColor = [UIColor orangeColor];
    _labelForMark.font = [UIFont systemFontOfSize:12];
    [_tableView addSubview:_labelForMark];
}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView==self.tableView){
        return _arrForNewFriend.count;
    }else{
        return [self.searchFriendResults count];
    }
    
}

- (void)key:(NSString *)key cell:(NewFriendTBCell *)cell
{
 
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //NSLog(@"%@",[userDefaults objectForKey:key]);
    if ([[userDefaults objectForKey:key] isKindOfClass:[NSNull class]] || [userDefaults objectForKey:key] == nil || [[userDefaults objectForKey:key] isEqualToString:@""]) {
        
        [cell.addBtn setImage:[UIImage imageNamed:@"wbd.png"] forState:UIControlStateNormal];
        cell.canBind = YES;
        
    }else{
        
        if ([key isEqualToString:kWx_third_id]) {
            
            if (![self isBind:kWeibo_third_id] && ![self isBind:kQq_third_id] && ![self isBindIphone:kTiUpTel])
            {
                [cell.addBtn setImage:[UIImage imageNamed:@"bd.png"] forState:UIControlStateNormal];
                cell.canBind = NO;
                
            }else{
              
                [cell.addBtn setImage:[UIImage imageNamed:@"jcbd.png"] forState:UIControlStateNormal];
                cell.canBind = YES;
            }
            
        }else if([key isEqualToString:kWeibo_third_id]){
         
            if (![self isBind:kWx_third_id] && ![self isBind:kQq_third_id] && ![self isBindIphone:kTiUpTel])
            {
                [cell.addBtn setImage:[UIImage imageNamed:@"bd.png"] forState:UIControlStateNormal];
                cell.canBind = NO;
                
            }else{
                
                [cell.addBtn setImage:[UIImage imageNamed:@"jcbd.png"] forState:UIControlStateNormal];
                cell.canBind = YES;
            }
            
        }else if([key isEqualToString:kQq_third_id]){
         
            if (![self isBind:kWx_third_id] && ![self isBind:kWeibo_third_id] && ![self isBindIphone:kTiUpTel])
            {
                [cell.addBtn setImage:[UIImage imageNamed:@"bd.png"] forState:UIControlStateNormal];
                cell.canBind = NO;
                
            }else{
                
                [cell.addBtn setImage:[UIImage imageNamed:@"jcbd.png"] forState:UIControlStateNormal];
                cell.canBind = YES;
            }

        }
        
     
    }
    
}

- (BOOL)isBindIphone:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [[userDefaults objectForKey:key]boolValue];
}

- (BOOL)isBind:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([[userDefaults objectForKey:key] isKindOfClass:[NSNull class]] || [userDefaults objectForKey:key] == nil || [[userDefaults objectForKey:key] isEqualToString:@""] ) {
        
        return NO;
    }else{
        
        return YES;
    }
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.tableView){
        NewFriendTBCell *cell = [tableView dequeueReusableCellWithIdentifier:strForNewFriendList];
        
        if (!cell) {
            
            cell = [[NewFriendTBCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForNewFriendList];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        //微博登录下
        //if (isWeiboLogin) {
        
        
        if (indexPath.row == 0) {
            
            cell.friendLabel.text = @"同步手机通讯录";
            cell.userHead.image = [UIImage imageNamed:@"手机通讯录.png"];
            cell.addBtn.hidden = YES;
            cell.addBtn.userInteractionEnabled = NO;

        }else if(indexPath.row == 1){
            
            
            cell.addBtn.hidden = NO;
            cell.addBtn.userInteractionEnabled = YES;
            cell.userHead.image = [UIImage imageNamed:@"qq_bind.png"];
            cell.friendLabel.text = _arrForNewFriend[indexPath.row];
            [self key:kQq_third_id cell:cell];
            
  
        }else if(indexPath.row == 2){
            cell.addBtn.hidden = NO;
            cell.addBtn.userInteractionEnabled = YES;
            cell.userHead.image = [UIImage imageNamed:@"wx_bind.png"];
            cell.friendLabel.text = _arrForNewFriend[indexPath.row];
            [self key:kWx_third_id cell:cell];


        }else if(indexPath.row == 3){
           
            cell.addBtn.hidden = NO;
            cell.addBtn.userInteractionEnabled = YES;
            cell.userHead.image = [UIImage imageNamed:@"wb_bind.png"];
            cell.friendLabel.text = _arrForNewFriend[indexPath.row];
            [self key:kWeibo_third_id cell:cell];

            
        }else if(indexPath.row == 4){
         
            
            cell.friendLabel.text = @"扫一扫";
            cell.userHead.image = [UIImage imageNamed:@"扫二维码.png"];
            cell.addBtn.hidden = YES;
            cell.addBtn.userInteractionEnabled = NO;

        }else{
         
            FriendModel *model = _arrForNewFriend[indexPath.row];
            
            if (![model.friend_name isKindOfClass:[NSNull class]] && ![model.head_url isKindOfClass:[NSNull class]]) {
                
                cell.friendLabel.text = model.friend_name;
                [cell.userHead sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
                cell.addBtn.hidden = NO;
                [cell.addBtn setImage:[UIImage imageNamed:@"添加朋友.png"] forState:UIControlStateNormal];
                cell.addBtn.userInteractionEnabled = YES;

            }
        }
        
        
        /*}else{
         
         if (indexPath.row == 0) {
         
         cell.friendLabel.text = @"同步手机通讯录";
         cell.userHead.image = [UIImage imageNamed:@"手机通讯录.png"];
         cell.addBtn.hidden = YES;
         
         }else{
         
         FriendModel *model = _arrForNewFriend[indexPath.row];
         cell.friendLabel.text = model.friend_name;
         [cell.userHead sd_setImageWithURL:[NSURL URLWithString:model.head_url]];
         cell.addBtn.hidden = NO;
         
         }
         
         
         }*/
        
        
        //直接添加好友
        [cell setActionForPassCell:^(NewFriendTBCell *selectCell) {
            
            NSIndexPath *indexPath = [_tableView indexPathForCell:selectCell];
            
            //绑定
            if (indexPath.row <= 3.0) {
                
                if (indexPath.row == 1) {
                    
                    if (selectCell.canBind) {
                        
                        if ([self isBind:kQq_third_id]) {
             
                            [RequestManager unbindWithStr:@"qq_third_id" complish:^(BOOL success, int mid) {
                                
                                if (success) {
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kQq_third_id];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [_tableView reloadData];
                                    });
                                }
                            }];
                            
                        }else{
                            
                            NSDictionary *dic = @{@"delegate":self};
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForChangeDelegate object:nil userInfo:dic];
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setBool:NO forKey:kWechatBind];
                            [defaults setBool:NO forKey:kWeiboBind];
                            [defaults setBool:YES forKey:kQQbind];
                            NSLog(@"QQ绑定");
                            [self actionForQQ];
                        }
                    }
                }else if(indexPath.row == 2){
                
                    if (selectCell.canBind) {
                        
                        if ([self isBind:kWx_third_id]) {
                            
                            [RequestManager unbindWithStr:@"wx_third_id" complish:^(BOOL success, int mid) {
                                
                                if (success) {
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kWx_third_id];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [_tableView reloadData];
                                    });
                                }
                            }];
                            
                        }else{
                            
                            NSDictionary *dic = @{@"delegate":self};
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForChangeDelegate object:nil userInfo:dic];
                            
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setBool:YES forKey:kWechatBind];
                            [defaults setBool:NO forKey:kWeiboBind];
                            [defaults setBool:NO forKey:kQQbind];
                            
                            [self wechatLogin];
                            NSLog(@"微信绑定");
                        }
                    }
                }else if(indexPath.row == 3){
                
                    if (selectCell.canBind) {
                        
                        if ([self isBind:kWeibo_third_id]) {
                            
                            [RequestManager unbindWithStr:@"weibo_third_id" complish:^(BOOL success, int mid) {
                                
                                if (success) {
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kWeibo_third_id];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                                        [_tableView reloadData];
                                    });
                                }
                                
                            }];
                            
                        }else{
                            
                            NSDictionary *dic = @{@"delegate":self};
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForChangeDelegate object:nil userInfo:dic];
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setBool:NO forKey:kWechatBind];
                            [defaults setBool:YES forKey:kWeiboBind];
                            [defaults setBool:NO forKey:kQQbind];
                            
                            [self actionForWeibo];
                            NSLog(@"微博绑定");
                        }
                    }
                }
                
            }else{
                FriendModel *model = _arrForNewFriend[indexPath.row];
                
                [RequestManager actionForAcceptRequest:(int )model.fid type:1];
            }
            
           
            
            //跳到好友列表
            //[self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        return cell;
    }
    else{ //搜索结果cell
        SearchFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierForFilterFriends];
        cell.friendModel = self.searchFriendResults[indexPath.row];
        __weak typeof(self) weakSelf = self;
        cell.actionBlock = ^(SearchFriendModel *model){
            [weakSelf addNewFriend:model];
        };
        return cell;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if(tableView==self.tableView){
        
        if (indexPath.row <= 4) {
            
            return NO;
            
        }else{
            
            return YES;
        }
    }
    else{//搜索结果
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    FriendModel *model = _arrForNewFriend[indexPath.row];
    [RequestManager actionForAcceptRequest:(int )model.fid type:0];
    [RequestManager actionForReloadData];
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==self.tableView){
        return 60;
    }else{
        return 75.f;
    }
}


//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NewFriendTBCell *cell = (NewFriendTBCell *)[tableView cellForRowAtIndexPath:indexPath];
  if(tableView==self.tableView){
      //  #warning 同步通讯录好友方法
      //微博登录情况下
      //if (isWeiboLogin) {
      NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
      
      //点击同步通讯录
      if (indexPath.row == 0) {
          
          if ([[def objectForKey:kTiUpTel] boolValue]) {
              
              //监测同步通讯录
              [RequestManager actionForHttp:@"sync_phone"];
              
              JYGroupViewController *grVC = [[JYGroupViewController alloc] init];
              
              AddressBook *add = [AddressBook shareAddressBook];
              [add actionForAddress];
                           
              [self.navigationController pushViewController:grVC animated:YES];
              
          }else{
              
              //监测同步通讯录
              [RequestManager actionForHttp:@"sync_phone"];

              BindPhoneView *bindView = [BindPhoneView new];
              [self.navigationController pushViewController:bindView animated:YES];
              
          }
          
      }else if(indexPath.row == 4){
          
          [[CamerManager shareInstance] showCameraWithBlock:^{
              //右上导航添加相册按钮
              UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
              [btn setTitle:@"相册" forState:UIControlStateNormal];
              [btn addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
              [btn setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
              self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
              
              //监测扫一扫点击
              
              [self setScanView];
              self.readerView = [[ZBarReaderView alloc] init];
              self.readerView.frame = CGRectMake ( 0 , 0 , self.view.frame.size.width, self.view.frame.size.height );
              self.readerView.tracksSymbols = NO;
              self.readerView.readerDelegate = self;
              [self.readerView addSubview:_scanView];
              //关闭闪光灯
              self.readerView.torchMode = 0;
              [self.view addSubview:self.readerView];
              //扫描区域
              [self.readerView start];
              [self createTimer];
              
              _isBack = YES;

          }];
                    //未绑定微博
          //            if([[def objectForKey:kTiUpWeiBo] isEqualToString:@"-1"]){
          //                toBindWeiboController *mwbVC = [toBindWeiboController new];
          //                [self.navigationController pushViewController:mwbVC animated:YES];
          //            //已绑定微博
          //            }else{
          //                NSArray *weiboArr = [[def objectForKey:kTiUpWeiBo] componentsSeparatedByString:@"|"];
          //
          //                MyWeiboListController *mwbVC = [MyWeiboListController new];
          //                mwbVC.weiboBindOpenId = weiboArr[0];
          //                mwbVC.weiboBindToken =weiboArr[1];
          //                [self.navigationController pushViewController:mwbVC animated:YES];
          //            }
          
      }else if(indexPath.row == 1){
          

          
      }else if(indexPath.row == 2){
      
          
          
      }else if(indexPath.row == 3){
      

          
      }else{
      
          //点击接收好友
          NewAddFriend *addFriend = [[NewAddFriend alloc] init];
          
          addFriend.model = _arrForNewFriend[indexPath.row];
          
          [addFriend setActionForRemove:^(NSArray *arrForNewFriend) {
              
              _arrForNewFriend = arrForNewFriend;
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  
                  [_tableView reloadData];
                  
              });
          }];
          [self.navigationController pushViewController:addFriend animated:YES];
      }
      
      /*}else{
       
       //点击同步通讯录
       if (indexPath.row == 0) {
       
       NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
       
       NSLog(@"%d",[[def objectForKey:kTiUpTel] boolValue]);
       if ([[def objectForKey:kTiUpTel] boolValue]) {
       
       JYGroupViewController *grVC = [[JYGroupViewController alloc] init];
       //没网络的情况下，从新加载
       AddressBook *add = [AddressBook shareAddressBook];
       
       [RequestManager actionForAddressBookWithArr:add.arrForBeforeA];
       
       [self.navigationController pushViewController:grVC animated:YES];
       
       }else{
       
       BindPhoneView *bindView = [BindPhoneView new];
       
       [self.navigationController pushViewController:bindView animated:YES];
       
       }
       
       }else{
       //点击接收好友
       NewAddFriend *addFriend = [[NewAddFriend alloc] init];
       
       addFriend.model = _arrForNewFriend[indexPath.row];
       addFriend.arrForNewFriend = [NSMutableArray array];
       [addFriend.arrForNewFriend addObjectsFromArray:_arrForNewFriend];
       
       //避免删除延迟问题
       [addFriend setActionForRemove:^(NSArray *arrForNewFriend) {
       
       _arrForNewFriend = arrForNewFriend;
       
       dispatch_async(dispatch_get_main_queue(), ^{
       
       [_tableView reloadData];
       
       });
       
       }];
       
       [self.navigationController pushViewController:addFriend animated:YES];
       
       }
       
       }*/
      
  }else{//搜索结果
      SearchFriendModel *model = self.searchFriendResults[indexPath.row];
      SearchFriendDetailViewController *detailVC = [SearchFriendDetailViewController new];
      detailVC.searchModel = model;
      [self.navigationController pushViewController:detailVC animated:YES];
  }
}

-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image {
    
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols.zbarSymbolSet );
    NSString *symbolStr = [NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    NSString *subString = @"";
    if(symbolStr.length > 6){
        
        subString = [symbolStr substringWithRange:NSMakeRange(0, 6)];
        
        if([subString isEqualToString:@"xiaomi"]){
            
            NSString *xiaomiID = [symbolStr substringWithRange:NSMakeRange(6, symbolStr.length - 6)];
            
            [self addFriends:xiaomiID];
            
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show ];
        }
        
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show ];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    __weak NewFriendViewController *ws = self;
    if(alertView.tag==kTagMergeDataQQ||alertView.tag==kTagMergeDataWeiXin||alertView.tag==kTagMergeDataWeiBo){
        if(buttonIndex==1){
            
            if(self.otherAccountUid>0){
                [RequestManager mergeDataFromOldId:self.otherAccountUid complete:^(id data, NSError *error) {
                    if(data){
                        //绑定第三方ID
                        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                        NSDictionary *dic = data[@"user"];
                        if (![dic[@"qq_third_id"] isKindOfClass:[NSNull class]]) {
                            [def setObject:dic[@"qq_third_id"] forKey:kQq_third_id];
                        }else{
                            [def setObject:@"" forKey:kQq_third_id];
                        }
                        if (![dic[@"weibo_third_id"] isKindOfClass:[NSNull class]]) {
                            [def setObject:dic[@"weibo_third_id"] forKey:kWeibo_third_id];
                        }else{
                            [def setObject:@"" forKey:kWeibo_third_id];
                        }
                        if (![dic[@"wx_third_id"] isKindOfClass:[NSNull class]]) {
                            [def setObject:dic[@"wx_third_id"] forKey:kWx_third_id];
                        }else{
                            [def setObject:@"" forKey:kWx_third_id];
                        }
                        NSString *tel = [NSString stringWithFormat:@"%@",dic[@"tel"]];
                        if(![tel isEqualToString:@"<null>"]&&![tel isKindOfClass:[NSNull class]] && tel.length>0){
                            [def setBool:YES forKey:kTiUpTel];
                            [def setObject:tel forKey:kuserTel];
                        }
                        [def synchronize];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"数据合并成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                            [alertView show];
                            [ws.tableView reloadData];
                        });

                        
                        ws.otherAccountUid = 0;
                        [RequestManager actionForReloadData];
                        [RequestManager actionForSelectFriendIsNewFriend:YES];
                        [RequestManager loadAllPassWordWithResult:^(id responseObject) {
                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationForChangeSecretList object:nil];
                        }];
                    }
                }];
            }
        }
    }else{
        [self.readerView stop];
        
        [self.readerView removeFromSuperview];
        
        [_timer invalidate];
        
        _isBack = NO;
        
        self.navigationItem.rightBarButtonItem = nil;
    }
}

//添加好友
- (void)addFriends:(NSString *)fid {
    [RequestManager actionForAddNewFriend:fid];
}

//二维码的扫描区域
- ( void )setScanView {
    
    _scanView =[[UIView alloc] initWithFrame : CGRectMake ( 0 , 0 , self.view.frame.size.width, self.view.frame.size.height )];
    _scanView.backgroundColor =[ UIColor clearColor ];
    //最上部view
    UIView * upView = [[UIView alloc] initWithFrame : CGRectMake ( 0 , 0 , self.view.frame.size.width , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :upView];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft )];
    scanCropView. layer.borderColor = [UIColor greenColor].CGColor ;
    scanCropView. layer.borderWidth = 2.0 ;
    scanCropView. backgroundColor =[UIColor clearColor];
    [ _scanView addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake ( self.view.frame.size.width - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA;
    rightView. backgroundColor = [UIColor blackColor];
    [_scanView addSubview:rightView];
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , self.view.frame.size.width , self.view.frame.size.height - ( self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop ) )];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA];
    [ _scanView addSubview :downView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , self.view.frame.size.width , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将二维码对准方框，即可自动扫描" ;
    [downView addSubview :labIntroudction];
    //画中间的基准线
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , self.view.frame.size.width - 2 * SCANVIEW_EdgeLeft , 2 )];
    _QrCodeline . backgroundColor = [ UIColor greenColor ];
    [ _scanView addSubview : _QrCodeline ];
}
- ( void )openLight {
    if ( _readerView . torchMode == 0 ) {
        _readerView . torchMode = 1 ;
    } else {
        _readerView . torchMode = 0 ;
    }
}
- ( void )viewWillDisappear:( BOOL )animated {
    [super viewWillDisappear :animated];
}

//二维码的横线移动
- ( void )moveUpAndDownLine {
    CGFloat Y= _QrCodeline.frame.origin.y;
    if (self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context:nil];
        [UIView setAnimationDuration:1];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, self.view.frame.size.width - 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    }
}
- ( void )createTimer {
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}
- ( void )stopTimer {
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)rightBarButtonClicked:(id)sender {
    ZBarReaderController *reader = [ZBarReaderController new];
    reader.readerDelegate = self;
    reader.navigationBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    reader.showsHelpOnFail = NO;
    if([ZBarReaderController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:reader animated:YES completion:nil];
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"打开相册失败！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show ];
    }
//    ImageViewController *imageVC = [[ImageViewController alloc] init];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:imageVC];
    
//    [imageVC setActionForPassPic:^(UIImage *image) {
//
//        ZBarReaderController* read = [ZBarReaderController new];
//        read.readerDelegate = self;
//        CGImageRef cgImageRef = image.CGImage;
//        
//        ZBarSymbol* symbol = nil;
//        NSString *qrResult;
//        NSString *subString;
//        for(symbol in [read scanImage:cgImageRef]) {
//            qrResult = symbol.data ;
//            NSLog(@"--------%@",qrResult);
//            break;
//        }
//        if(qrResult.length > 6){
//            
//            subString = [qrResult substringWithRange:NSMakeRange(0, 6)];
//            if([subString isEqualToString:@"xiaomi"]){
//                NSString *xiaomiID = [qrResult substringWithRange:NSMakeRange(6, qrResult.length - 6)];
//                [self addFriends:xiaomiID];
//            }else{
//                UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                [alertView show ];
//            }
//        }else{
//            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show ];
//        }
//        
//
//    }];
//    [self presentViewController:nav animated:YES completion:^{}];

}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol* symbol = nil;
    NSString *qrResult;
    NSString *subString;
    for(symbol in results) {
        qrResult = symbol.data ;
        NSLog(@"====%@",qrResult);
        break;
    }
    if(qrResult.length > 6){

        subString = [qrResult substringWithRange:NSMakeRange(0, 6)];
        if([subString isEqualToString:@"xiaomi"]){
            NSString *xiaomiID = [qrResult substringWithRange:NSMakeRange(6, qrResult.length - 6)];
            [self addFriends:xiaomiID];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show ];
        }
    }else{
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"这不是小秘的二维码哦！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show ];
    }

    [reader dismissViewControllerAnimated:YES completion:^{}];
}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle : @"" message:@"未能从该图片中识别到二维码！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [self.navigationController.topViewController dismissViewControllerAnimated:YES completion:nil];
    [alertView show ];
}
#pragma mark - Getters and Setters
- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width                                                          , kSearchBarHeight)];
        _searchBar.placeholder = @"搜索小秘用户（昵称/ID号/手机号）";
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
        [_searchDisplayController.searchResultsTableView registerClass:[SearchFriendCell class]forCellReuseIdentifier:kCellIdentifierForFilterFriends];
        _searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
    }
    return _searchBar;
}
- (NSMutableArray *)searchFriendResults{
    if(!_searchFriendResults){
        _searchFriendResults = [NSMutableArray array];
    }
    return _searchFriendResults;
}



#pragma mark 微信绑定
- (void)wechatLogin {
    //注册微信
    [WXApi registerApp:@"wx2b07116467d44615"];
    
    SendAuthReq* req =[[SendAuthReq alloc ] init] ;
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    //BOOL flag =  [WXApi sendReq:req];
    
//    [self.navigationItem setRightBarButtonItem:nil];
//    [self.navigationItem setLeftBarButtonItem:nil];
    
    
    BOOL flag = [WXApi sendAuthReq:req viewController:self delegate:self];
    
    
    
    if (flag == 1) {
        
    }
}



#pragma mark 微信代理方法
- (void)onReq:(BaseReq *)req {
    
}

#pragma mark 回调方法。转换rootViewController
- (void)onResp:(BaseResp *)resp {
    
    /*
     ErrCode ERR_OK = 0(用户同意)
     ERR_AUTH_DENIED = -4（用户拒绝授权）
     ERR_USER_CANCEL = -2（用户取消）
     code    用户换取access_token的code，仅在ErrCode为0时有效
     state   第三方程序发送时用来标识其请求的唯一性的标志，由第三方程序调用sendReq时传入，由微信终端回传，state字符串长度不能超过1K
     lang    微信客户端当前语言
     country 微信用户当前国家信息
     */
    
    SendAuthResp *aresp = (SendAuthResp *)resp;
    NSString *code = aresp.code;
    
    if (aresp.errCode == -2) {
        
        [ProgressHUD dismiss];
        
        return;
        
    }else if(aresp.errCode == -4){
        
        [ProgressHUD dismiss];
        
        return;
        
    }else {}
    
    if (aresp.errCode == 0) {
        //            NSString *code = aresp.code;
        //        NSDictionary *dic = @{@"code":code};
        //
        //第一步
        NSDictionary * oneDict = [self requestOne:code];
        
        //第二步
        NSString *REFRESH_TOKEN = oneDict[@"refresh_token"];
        NSDictionary * secondDict = [self requestSecond:REFRESH_TOKEN];
        
        //第三步
        NSString *ACCESS_TOKEN = secondDict[@"access_token"];
        NSString *OPENID = secondDict[@"openid"];
        NSDictionary  * thirdDict = [self requestThird:ACCESS_TOKEN AndOPENID:OPENID];
        if (thirdDict != nil) {
            //说明用户信息不为空说明登陆成功
            
            //第一次上传
            
        }
        
    }else {
        
        
    }
    
}

//第一步 获取code后，请求以下链接获取access_token,refresh_token
-(NSDictionary *)requestOne:(NSString * )code{
    NSString *URLString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx2b07116467d44615&secret=5440ea902c7b1fb02a5a7387499b5ec4&code=%@&grant_type=authorization_code",code];
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    return weatherDic;
}

//第二步refresh_token
-(NSDictionary *)requestSecond:(NSString *)REFRESH_TOKEN{
    
    NSString *URLString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=wx2b07116467d44615&grant_type=refresh_token&refresh_token=%@",REFRESH_TOKEN];
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    return weatherDic;
    
}

//第三部 获取个人信息
-(NSDictionary *)requestThird:(NSString *)ACCESS_TOKEN AndOPENID:(NSString*)OPENID{
    
    NSString *URLString =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",ACCESS_TOKEN,OPENID];
    NSError *error;
    
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    NSString *urlStr = [NSString stringWithFormat:@"%@binding",kXiaomiUrl];
    NSDictionary *dic = @{@"uid":userId,@"wx_third_id":[weatherDic objectForKey:@"openid"]};
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    __weak NewFriendViewController *vc = self;
    [manager POST:urlStr parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [ProgressHUD dismiss];
        
        if([[responseObject objectForKey:@"bind"] intValue] == 0){
         
            [[NSUserDefaults standardUserDefaults] setObject:[weatherDic objectForKey:@"openid"] forKey:kWx_third_id];
            [vc setNoValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];

            });
        }else{
            self.otherAccountUid = [[responseObject objectForKey:@"bind"] integerValue];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此微信账号已注册过小秘，是否将数据合并到此账号?" message:@"\n温馨提示:合并后的账号信息将被全部整理合并到当前账号，原账号信息将被注销，个人信息则以当前登陆账号为准。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag = kTagMergeDataWeiXin;
            [alert show];
            [vc setNoValue];
        }
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [vc setNoValue];
        NSLog(@"%@",error);
    }];
    
    
    return weatherDic;
    
}



#pragma mark  微博绑定
- (void)actionForWeibo {
    
    WBAuthorizeRequest *weiboRequest = [WBAuthorizeRequest request];
    weiboRequest.redirectURI = kWeiboRedirectURI;
    weiboRequest.scope = @"all";
    weiboRequest.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                              @"Other_Info_1": [NSNumber numberWithInt:123],
                              @"Other_Info_2": @[@"obj1", @"obj2"],
                              @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};;
    
    [WeiboSDK sendRequest:weiboRequest];
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response123 {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = response123.userInfo[@"uid"];
    
    if(uid == 0){
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"绑定失败" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alterView show];
        
        [ProgressHUD dismiss];
        
        return;
    }
    
    
    NSString *urlStr1 = [NSString stringWithFormat:@"%@binding",kXiaomiUrl];
    
    NSDictionary *dic = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID],@"weibo_third_id":uid};
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr1]];
    __weak NewFriendViewController *vc = self;
    [manager POST:urlStr1 parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [ProgressHUD dismiss];
        
       if([[responseObject objectForKey:@"bind"] intValue] == 0){
            
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:kWeibo_third_id];
            [vc setNoValue];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
                
            });
       }else{
           self.otherAccountUid = [[responseObject objectForKey:@"bind"] integerValue];
           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此微博账号已注册过小秘，是否将数据合并到此账号?" message:@"\n温馨提示:合并后的账号信息将被全部整理合并到当前账号，原账号信息将被注销,个人信息则以当前登陆账号为准。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
           alert.tag = kTagMergeDataWeiBo;
           [alert show];
           [vc setNoValue];
       }
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [vc setNoValue];
        NSLog(@"%@",error);
    }];
    
    
    
    NSString *token = response123.userInfo[@"access_token"];
    [defaults setObject:token forKey:kWeiboToken];
    
    NSString *urlStr =[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",uid,token];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        /*
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        id dict=[NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
        
        NSDictionary *dic = dict;
        
        NSString *name = dic[@"name"];
        NSString *headUrl = dic[@"profile_image_url"];
        
        if (![[defaults objectForKey:kIsLogin] boolValue]) {
            
            [defaults setObject:name forKey:kUserName];
            [defaults setObject:headUrl forKey:kUserHead];
            [defaults setObject:uid forKey:kThirdOpenID];
            
            [defaults setBool:YES forKey:kUserFirstLogin];
            [defaults setBool:YES forKey:kIsLogin];
            
            [defaults synchronize];
            //第一次上传头像
            [RequestManager actionForUpNameAndHead:weiboLogin thirdId:uid validate:nil];
            
        }
         */
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
}




#pragma mark QQ绑定
//登陆完成调用
- (void)tencentDidLogin {
    if (tencentOAuth.accessToken && 0 != [tencentOAuth.accessToken length]) {
        //记录登录用户的OpenID、Token以及过期时间
        [tencentOAuth getUserInfo];
    }
    else {
        
    }
}

//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled {
    
    if (cancelled) {
        
        [ProgressHUD dismiss];
        
    }else{
        
        [ProgressHUD dismiss];
        
    }
    
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork {
    
    [ProgressHUD dismiss];
    
}

-(void)getUserInfoResponse:(APIResponse *)response {
    
    //    #warning 增加腾讯的名字等
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSDictionary *dic = response.jsonResponse;
    //NSString *name = [dic objectForKey:@"nickname"];
    NSString *uid = tencentOAuth.openId;
    //NSString *headUrl = [dic objectForKey:@"figureurl_qq_2"];
    
    NSString *urlStr1 = [NSString stringWithFormat:@"%@binding",kXiaomiUrl];
    
    NSDictionary *dic1 = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID],@"qq_third_id":uid};
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr1]];
    __weak NewFriendViewController *vc = self;
    [manager POST:urlStr1 parameters:dic1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [ProgressHUD dismiss];
            
        if([[responseObject objectForKey:@"bind"] intValue] == 0){
            
            [[NSUserDefaults standardUserDefaults] setObject:uid forKey:kQq_third_id];
            [vc setNoValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [_tableView reloadData];
                
            });
        }else{
            self.otherAccountUid = [[responseObject objectForKey:@"bind"] integerValue];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此QQ账号已注册过小秘，是否将数据合并到此账号?" message:@"\n温馨提示:合并后的账号信息将被全部整理合并到当前账号，原账号信息将被注销，个人信息则以当前登陆账号为准。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            alert.tag = kTagMergeDataQQ;
            [alert show];
            [vc setNoValue];
        }
        
        NSLog(@"%@",responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [vc setNoValue];
        NSLog(@"%@",error);
    }];
    
    /*
    if (![[defaults objectForKey:kIsLogin] boolValue]) {
        
        [defaults setObject:name forKey:kUserName];
        [defaults setObject:headUrl forKey:kUserHead];
        [defaults setObject:uid forKey:kThirdOpenID];
        
        //[defaults setBool:YES forKey:kUserFirstLogin];
        //[defaults setBool:YES forKey:kIsLogin];
        [defaults synchronize];
        
        //第一次上传头像
        [RequestManager actionForUpNameAndHead:qqLogin thirdId:uid validate:nil];
        
    }
    */
}

- (void)actionForQQ {
    tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104941751" andDelegate:self];
    [self loginAct];
}

-(void)loginAct {
    
    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo",nil];
    [tencentOAuth authorize:permissions inSafari:NO];
    
}


- (void)setNoValue
{
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:kWechatBind];
    [defaults setBool:NO forKey:kWeiboBind];
    [defaults setBool:NO forKey:kQQbind];
}
@end
