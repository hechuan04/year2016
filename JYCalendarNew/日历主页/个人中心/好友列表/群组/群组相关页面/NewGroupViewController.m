//
//  NewGroupViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/12/14.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "NewGroupViewController.h"
#import "GroupModelVC.h"
#import "GoupCell.h"
//#import "JYEmptyDatasourceAndDelegate.h"
static NSString *strForGroupCell = @"strForGroupCell";

@interface NewGroupViewController() {
    
    UIView *_line1;
    DataArray *dataManager;
    
}
//@property (nonatomic,strong) JYEmptyDatasourceAndDelegate *emptyDelegate;
@end

@implementation NewGroupViewController

- (void)rightAction {
  
    //监测新建群组
    [RequestManager actionForHttp:@"new_group"];
    
    GroupModelVC *group = [[GroupModelVC alloc] init];
    __block NewGroupViewController *newVc = self;
    [group setActionForReloadData:^{
        
        if (dataManager.arrForAllGroup.count == 0) {
            
            _imgForNoGroup.hidden = NO;
            
        }else{
            
            _imgForNoGroup.hidden = YES;
            
        }
        
        [newVc.tableView reloadData];
        
    }];
    
    [self.navigationController pushViewController:group animated:YES];

}

//接到通知刷新群组列表
- (void)notificationForReloadTb {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (dataManager.arrForAllGroup.count == 0) {
            
            _imgForNoGroup.hidden = NO;
            
        }else{
            
            _imgForNoGroup.hidden = YES;
            
        }
        
        [_tableView reloadData];
        
    });
    
}

- (void)actionForLeft:(UIButton *)sender {
 
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationForReloadTb) name:kNotificationForDeleteGroup object:@""];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationForReloadTb) name:kNotificationForCreateGroup object:@""];
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"新建" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    _line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenWidth, 0.5)];
    _line1.backgroundColor = [UIColor colorWithRed:150 / 255.0 green:150 / 255.0 blue:150 / 255.0 alpha:1];
    [self.view addSubview:_line1];
    
    dataManager = [DataArray shareDateArray];
 
    [self _creatTableView];

    if (IS_IPHONE_4_SCREEN) {
        
        
    }else{
     
        
    }
    CGFloat imgWidth = 487/750.0*kScreenWidth;
    CGFloat imgHeight = 311/1334.0*kScreenHeight;
    _imgForNoGroup = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无群组"]];
    _imgForNoGroup.frame = CGRectMake(kScreenWidth/2.0 - imgWidth/2.0, 240/1334.0*kScreenHeight, imgWidth, imgHeight);
    [self.view addSubview:_imgForNoGroup];
   
    if (dataManager.arrForAllGroup.count == 0) {
        
        _imgForNoGroup.hidden = NO;
        
    }else{
        
        _imgForNoGroup.hidden = YES;
        
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)_creatTableView {
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
 
    [_tableView registerNib:[UINib nibWithNibName:@"GoupCell" bundle:nil] forCellReuseIdentifier:strForGroupCell];
    
    UIView *bgView = [UIView new];
    
    bgView.backgroundColor = [UIColor whiteColor];
    
    [_tableView setTableFooterView:bgView];
    
//    self.emptyDelegate = [[JYEmptyDatasourceAndDelegate alloc]initWithControllerType:ControllerTypeGroupListVC];
//    _tableView.emptyDataSetSource = self.emptyDelegate;
//    _tableView.emptyDataSetDelegate = self.emptyDelegate;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataManager.arrForAllGroup.count;
}

//编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
    GroupModel *model = dataManager.arrForAllGroup[indexPath.row];
    
    [RequestManager actionForDeleteGroupId:model.gid];
    
    if (dataManager.arrForAllGroup.count == 0) {
        
        _imgForNoGroup.hidden = NO;
        [self.tableView reloadData];
        
    }
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoupCell *cell = [tableView dequeueReusableCellWithIdentifier:strForGroupCell];
    
    if (!cell) {
        
        cell = [[GoupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForGroupCell];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupModel *model = dataManager.arrForAllGroup[indexPath.row];
    
    cell.groupName.text = [NSString stringWithFormat:@"%@",model.group_name];
    //    cell.groupCell.image = [UIImage imageNamed:@"默认群组头像.png"];
    NSURL *headerUrl = [NSURL URLWithString:model.groupHeaderUrl];
    [cell.groupCell sd_setImageWithURL:headerUrl placeholderImage:[UIImage imageNamed:@"默认群组头像.png"]];
    cell.groupCell.layer.cornerRadius = cell.groupCell.width/2.f;
    cell.groupCell.layer.masksToBounds = YES;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GroupModel *model = dataManager.arrForAllGroup[indexPath.row];
    
    //朋友关系表
    FriendForGroupListManager *manager = [FriendForGroupListManager shareFriendGroup];
    
    //朋友表
    FriendListManager *fList = [FriendListManager shareFriend];
    NSArray *arrForFriend = [manager selectDataWithGid:model.gid];
    
    NSMutableArray *arrForFmodel = [NSMutableArray array];
    
    for (int i = 0; i < arrForFriend.count; i ++) {
        
        int fid = [arrForFriend[i] intValue];
        
        FriendModel *modelF = [fList selectDataWithFid:fid];
        [arrForFmodel addObject:modelF];
        
    }
    
    //监测点击组
    
    GroupModelVC *group = [[GroupModelVC alloc] init];
    
    group.arrForAllFriend = arrForFmodel;
    group.groupName = model.group_name;
    group.gid = model.gid;
    group.groupHeaderUrl = model.groupHeaderUrl;
    
    __weak NewGroupViewController *newVc = self;
    [group setActionForReloadData:^{
        
        [newVc.tableView reloadData];
        
    }];
    
    [self.navigationController pushViewController:group animated:YES];
    
}



@end