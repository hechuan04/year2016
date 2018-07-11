//
//  AddRemindVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/17.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "AddRemindVC.h"
#import "AddRemindCell.h"
#import "AddGroupVC.h"


static NSString *strForAddRemindCell = @"strForAddRemindCell";

@interface AddRemindVC ()
{
  
    UITableView *_tableView;
    NSArray *_arrForAllKey;
    NSMutableString *_mutableStr;
    
}

@end

@implementation AddRemindVC

/**
 *  选中以后确定的方法
 */
- (void)rightAction
{
    _actionForSendArr(_arrForSelectFriend,_arrForSelectGroup);
    
    [self.navigationController popViewControllerAnimated:YES];

}

/**
 *  放回方法
 */
- (void)actionForLeft:(UIButton *)sender
{


    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"确认" forState:UIControlStateNormal];
    
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    _dataArr = [DataArray shareDateArray];
    
    //选中的添加在这个里边
    _arrForSelectFriend = [NSMutableArray arrayWithArray:_arrForFriend];
    _arrForSelectGroup = [NSMutableArray arrayWithArray:_arrForGroup];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    if (_isShare) {
        
        for (int i = 0; i < _dataArr.arrForAllFriend.count; i++) {
            
            FriendModel *model = _dataArr.arrForAllFriend[i];
            int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
            if (model.fid != userID) {
                
                [arr addObject:model];
                
            }
            
        }
        
    }else{
     
        [arr addObjectsFromArray:_dataArr.arrForAllFriend];

    }
    
   
    
    _dicForAllName = [Tool actionForReturnNameDic:arr];
    _arrForAllKey = [Tool actionForReturnAllKey:_dicForAllName.allKeys];


 
    _mutableStr = [NSMutableString string];
    for (int i = 0 ; i < _arrForFriend.count; i++) {
        
        FriendModel *model = _arrForFriend[i];
        
        NSString *fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
        
        [_mutableStr appendString:fid];
        
    }
    
    
    [self _creatTableView];
    
    
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
    _tableView.tintColor = [UIColor lightGrayColor];
    [self.view addSubview:_tableView];

    [Tool actionForHiddenMuchTable:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AddRemindCell" bundle:nil] forCellReuseIdentifier:strForAddRemindCell];
 
}


//组数
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return _arrForAllKey.count + 1;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 
    if (section == 0) {
        
        return 0.5;
        
    }else{
        
        return 20;
    }
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0) {
        
      return 1;

        
    }else{
    
        NSArray *groupPeople = [_dicForAllName objectForKey:_arrForAllKey[section - 1]];
        
        return groupPeople.count;
    }
    


}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:strForAddRemindCell];
    
    if (!cell) {
        
        cell = [[AddRemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForAddRemindCell];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    if (indexPath.section == 0) {
        
        cell.headImage.hidden = YES;
        cell.nameLabel.hidden = YES;
        cell.selectImage.hidden = YES;
        cell.groupImage.hidden = NO;
        cell.groupLabel.hidden = NO;
        
    }else{
      
        cell.headImage.hidden = NO;
        cell.nameLabel.hidden = NO;
        cell.selectImage.hidden = NO;
        cell.groupImage.hidden = YES;
        cell.groupLabel.hidden = YES;
        
        NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
        
        FriendModel *model = arrForG[indexPath.row];
        
        int uid = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];
        NSString *headUrlStr = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
        if (model.fid == uid) {
            
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:headUrlStr] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        }else{
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
        }
        
        NSString *fidStr = [NSString stringWithFormat:@"%ld,",(long)model.fid];
        
        if ([_mutableStr rangeOfString:fidStr].location != NSNotFound) {
            
            cell.isSelect = YES;
            cell.selectImage.image = [UIImage imageNamed:@"选中状态.png"];

        }else{
          
            cell.isSelect = NO;
            cell.selectImage.image = [UIImage imageNamed:@"默认状态.png"];

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
        
        
        cell.nameLabel.text = nameStr;
    }
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    UIView *viewForHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    viewForHead.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 15)];
    if (section == 0) {
        
//        UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
//        viewForLine.backgroundColor = lineColor;
        
        return nil;
        
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


//点击选择人
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AddRemindCell *cell = (AddRemindCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.isSelect = !cell.isSelect;

    
    
    if (cell.isSelect) {
        
        //不同组
        if (indexPath.section == 0) {
            
      
            AddGroupVC *groupVC = [[AddGroupVC alloc] init];
            groupVC.arrForFriend = _arrForSelectFriend;
            groupVC.arrForGroup  = _arrForSelectGroup;
            
            [groupVC setActionForPassGroup:^(NSArray *arrForGroup) {
                
                _arrForSelectGroup = [NSMutableArray arrayWithArray:arrForGroup];
                
                
            }];
            
            [self.navigationController pushViewController:groupVC animated:YES];
            
            
        }else{
        
            NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
            FriendModel *model = arrForG[indexPath.row];
  
            [_arrForSelectFriend addObject:model];
            
            _mutableStr = [NSMutableString string];
            for (int i = 0 ; i < _arrForSelectFriend.count; i++) {
                
                FriendModel *model = _arrForSelectFriend[i];
                
                NSString *fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
                
                [_mutableStr appendString:fid];
                
            }
           
        }
        
        cell.selectImage.image = [UIImage imageNamed:@"选中状态.png"];
        
    }else{
        
        //不同组
        if (indexPath.section == 0) {
            
      
            AddGroupVC *groupVC = [[AddGroupVC alloc] init];
            groupVC.arrForFriend = _arrForSelectFriend;
            groupVC.arrForGroup  = _arrForSelectGroup;
            
            [groupVC setActionForPassGroup:^(NSArray *arrForGroup) {
                
                _arrForSelectGroup = [NSMutableArray arrayWithArray:arrForGroup];
                
                
            }];
            [self.navigationController pushViewController:groupVC animated:YES];
            
            
        }else{
            

            NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section - 1]];
            FriendModel *model = arrForG[indexPath.row];
            
            for (int i = 0; i < _arrForSelectFriend.count; i ++) {
                
                FriendModel *seleModel = _arrForSelectFriend[i];
                
                if (model.fid == seleModel.fid) {
                    
                    [_arrForSelectFriend removeObject:seleModel];
                    
                    _mutableStr = [NSMutableString string];
                   
                    for (int i = 0 ; i < _arrForSelectFriend.count; i++) {
                        
                        FriendModel *model = _arrForSelectFriend[i];
                        
                        NSString *fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
                        
                        [_mutableStr appendString:fid];
                        
                    }
                    
                    break;
                }
            }
            
            
        }
        
        cell.selectImage.image = [UIImage imageNamed:@"默认状态.png"];
    }
    
}
//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indexArr = [NSMutableArray arrayWithCapacity:_arrForAllKey.count+1];
    [indexArr addObject:@" "];
    [indexArr addObjectsFromArray:_arrForAllKey];
    return indexArr;
}
@end
