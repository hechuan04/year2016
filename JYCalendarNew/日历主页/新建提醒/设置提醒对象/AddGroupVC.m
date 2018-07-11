//
//  AddGroupVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/23.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "AddGroupVC.h"
#import "AddGroupCell.h"
#import "JYRemindViewController.h"
#import "JYListVC.h"

static NSString *strForGroupCell = @"strForGroupCell";

@interface AddGroupVC ()
{
 
    UITableView *_tableView;
    NSMutableString *_mutableStr;
}
@property (nonatomic,strong) UIImageView *emptyView;
@end

@implementation AddGroupVC

/**
 *  选中以后确定的方法
 */
- (void)rightAction
{
    
    NSArray *arr = self.navigationController.viewControllers;
    
    id vc = nil;
    for (NSInteger i = (arr.count-1); i >= 0; i--) {
        
         vc = arr[i];
        
        
        if ([vc isKindOfClass:[JYRemindViewController class]]) {
            
            
            break;
        }
        
        //从提醒列表进来的
        if ([vc isKindOfClass:[JYListVC class]]) {
            
            
            break;
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    _arrForGroup = _arrForSelectGroup;
    
    [dic setObject:_arrForGroup forKey:@"group"];
    [dic setObject:_arrForFriend forKey:@"friend"];
    
    NSNotification *notification;
    if([vc isKindOfClass:[JYRemindViewController class]]){
        
        notification = [NSNotification notificationWithName:kNotificationForGroupPassRemind object:@"" userInfo:dic];
        
    }else if([vc isKindOfClass:[JYListVC class]]){
        
        notification = [NSNotification notificationWithName:kNotificationForGroupJumpToRemindList object:@"" userInfo:dic];
    }
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popToViewController:vc animated:YES];
    
}

- (void)leftAction{
 
    _arrForGroup = _arrForSelectGroup;
    _actionForPassGroup(_arrForGroup);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    JYSkinManager *skinManager = [JYSkinManager shareSkinManager];
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnView setTitleColor:skinManager.colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    
    
    UIButton *btnView1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView1 addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    btnView1.frame = CGRectMake(0, 0, 50, 50);
    [btnView1 setTitle:@"确定" forState:UIControlStateNormal];
    
    [btnView1 setTitleColor:skinManager.colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:btnView1];
    
    self.navigationItem.leftBarButtonItem = left;
    

    
    self.title = @"群组";
    
    
    _dataArr = [DataArray shareDateArray];
    
    _arrForSelectGroup = [NSMutableArray arrayWithArray:_arrForGroup];
    
    _mutableStr = [NSMutableString string];
    for (int i = 0; i < _arrForSelectGroup.count; i++) {
        
        GroupModel *model = _arrForSelectGroup[i];
        
        NSString *strForGid = [NSString stringWithFormat:@"%d,",model.gid];
        [_mutableStr appendString:strForGid];
        
    }
    
    [self _creatTableView];

    [self.view addSubview:self.emptyView];
    self.emptyView.center = CGPointMake(kScreenWidth/2.f,kScreenHeight/2.f-100);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.emptyView.hidden = _dataArr.arrForAllGroup.count>0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_creatTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, kScreenHeight - 65)];
    _tableView.rowHeight = 30;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [_tableView registerNib:[UINib nibWithNibName:@"AddGroupCell" bundle:nil] forCellReuseIdentifier:strForGroupCell];
    
    [Tool actionForHiddenMuchTable:_tableView];
}


//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArr.arrForAllGroup.count;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:strForGroupCell];
    
    if (!cell) {
        
        cell = [[AddGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForGroupCell];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    GroupModel *model = _dataArr.arrForAllGroup[indexPath.row];
    
    cell.groupNameLabel.text = model.group_name;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.groupHeaderUrl] placeholderImage:[UIImage imageNamed:@"默认群组头像"]];
    cell.headImage.layer.cornerRadius = cell.headImage.height/2.f;
    cell.headImage.layer.masksToBounds = YES;
    
    NSString *gidStr = [NSString stringWithFormat:@"%d",model.gid];
    
    if ([_mutableStr rangeOfString:gidStr].location != NSNotFound) {
        
        cell.isSelect = YES;
        cell.selectImage.image = [UIImage imageNamed:@"选中状态.png"];

    }else{
     
        cell.isSelect = NO;
        cell.selectImage.image = [UIImage imageNamed:@"默认状态.png"];

    }
    
    
    return cell;
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    AddGroupCell *cell = (AddGroupCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.isSelect = !cell.isSelect;

    if (cell.isSelect) {
        
        GroupModel *model = _dataArr.arrForAllGroup[indexPath.row];
        
        [_arrForSelectGroup addObject:model];
        
        
        _mutableStr = [NSMutableString string];
        for (int i = 0; i < _arrForSelectGroup.count; i++) {
            
            GroupModel *model = _arrForSelectGroup[i];
            
            NSString *strForGid = [NSString stringWithFormat:@"%d,",model.gid];
            [_mutableStr appendString:strForGid];
            
        }
        
        cell.selectImage.image = [UIImage imageNamed:@"选中状态.png"];

        
    }else{
     
        GroupModel *model = _dataArr.arrForAllGroup[indexPath.row];

        //俩个model不在一个内存地址内
        for (int i = 0; i < _arrForSelectGroup.count; i ++) {
            
            GroupModel *seleModel = _arrForSelectGroup[i];
            
            if (model.gid == seleModel.gid) {
                
                [_arrForSelectGroup removeObject:seleModel];

                //每次添加或者删除都需要更新一下总的
                _mutableStr = [NSMutableString string];
                for (int i = 0; i < _arrForSelectGroup.count; i++) {
                    
                    GroupModel *model = _arrForSelectGroup[i];
                    
                    NSString *strForGid = [NSString stringWithFormat:@"%d,",model.gid];
                    [_mutableStr appendString:strForGid];
                    
                }
                
                break;
            }
        }
        
        
        cell.selectImage.image = [UIImage imageNamed:@"默认状态.png"];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//    
//        
//        UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
//        viewForLine.backgroundColor = lineColor;
//        
//        return viewForLine;
//        
// 
//    
//}
- (UIImageView *)emptyView
{
    if(!_emptyView){
        _emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无群组"]];
        _emptyView.contentMode = UIViewContentModeScaleAspectFit;
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
