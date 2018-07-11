//
//  AddFriendVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 15/12/16.
//  Copyright (c) 2015年 北京金源互动科技有限公司. All rights reserved.
//

#import "AddFriendVC.h"
#import "SelectFriendCell.h"

static NSString *strForSelectFriendCell = @"strForSelectFriendCell";

@interface AddFriendVC ()
{
  
    UITableView *_tableView;
    NSMutableString *fidStr;
    
}

@end

@implementation AddFriendVC

- (void)rightAction{
 
    NSArray *arrForPass = _arrForSelect;
    _actionForSelect(arrForPass);
    
    [self.navigationController popViewControllerAnimated:YES];
  
}

- (void)actionForLeft:(UIButton *)sender
{
 
//    NSArray *arrForPass = _arrForSelect;
//    _actionForSelect(arrForPass);
    _actionForSelect(self.arrForModel);
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.title = @"选择好友";
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 40,40);
    [btnView setTitle:@"完成" forState:UIControlStateNormal];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = right;
    
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    
    _arrForSelect = [NSMutableArray arrayWithArray:_arrForModel];
    
 
        
    _arrForAllKey = [Tool actionForReturnAllKey:_dicForAllName.allKeys];
    
    fidStr = [NSMutableString string];
    for (int i = 0; i < _arrForSelect.count; i ++) {
            
         
            FriendModel *model = _arrForSelect[i];
            NSString *fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
            
            [fidStr appendString:fid];
            
        }
    
    
    
    
    _arrForAllKey = [Tool actionForReturnAllKey:_dicForAllName.allKeys];

    
    [self _creatTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_creatTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _tableView.rowHeight = 30;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    [_tableView registerNib:[UINib nibWithNibName:@"SelectFriendCell" bundle:nil] forCellReuseIdentifier:strForSelectFriendCell];
    
    [Tool actionForHiddenMuchTable:_tableView];
}

- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _arrForAllKey.count;
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
        return 25;

}

//头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *viewForHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
    viewForHead.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
    UILabel *labelForTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 15)];

    labelForTitle.text = _arrForAllKey[section];

    [viewForHead addSubview:labelForTitle];
    
    
    return viewForHead;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *arrForSection = [_dicForAllName objectForKey:_arrForAllKey[section]];
    
    return arrForSection.count;
    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SelectFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:strForSelectFriendCell];
    
    if (!cell) {
        
        cell = [[SelectFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForSelectFriendCell];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section]];
    FriendModel *model = arrForG[indexPath.row];
    
    NSString *fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
    
    if ([fidStr rangeOfString:fid].location != NSNotFound) {
        
        cell.isSelect = YES;
        cell.selectView.image = [UIImage imageNamed:@"选中状态.png"];

    }else{
      
        cell.isSelect = NO;
        cell.selectView.image = [UIImage imageNamed:@"默认状态.png"];

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
    [cell.headView sd_setImageWithURL:[NSURL URLWithString:model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像.png"]];
    
    
    
    return cell;
    
}

//点击选择人
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SelectFriendCell *cell = (SelectFriendCell *)[tableView cellForRowAtIndexPath:indexPath];

    cell.isSelect = !cell.isSelect;
    
    NSArray *arrForG = [_dicForAllName objectForKey:_arrForAllKey[indexPath.section]];
    FriendModel *model = arrForG[indexPath.row];
    
    if (cell.isSelect) {
        
        [_arrForSelect addObject:model];
        
        fidStr = [NSMutableString string];
        
        for (int i = 0; i < _arrForSelect.count; i ++) {
            
            FriendModel *model = _arrForSelect[i];
            NSString *fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
            
            [fidStr appendString:fid];
            
        }
        
        cell.selectView.image = [UIImage imageNamed:@"选中状态.png"];
        
    }else{
      
        for (int i = 0; i < _arrForSelect.count; i ++) {
            
            FriendModel *modelSelect = _arrForSelect[i];
            
            if (modelSelect.fid == model.fid) {
                
                [_arrForSelect removeObject:modelSelect];
                
                fidStr = [NSMutableString string];
                
                for (int i = 0; i < _arrForSelect.count; i ++) {
     
                    FriendModel *model = _arrForSelect[i];
                    NSString *fid = [NSString stringWithFormat:@"%ld,",(long)model.fid];
                    
                    [fidStr appendString:fid];
                    
                }
 
                break;
            }
            
        }
        
        cell.selectView.image = [UIImage imageNamed:@"默认状态.png"];
    }
    
}


@end
