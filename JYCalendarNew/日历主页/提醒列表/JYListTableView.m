//
//  JYListTableView.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/1.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYListTableView.h"
#import "JYListTCell.h"
#import "JYSystemList.h"

#import "JYListDataManager.h"

@implementation JYListTableView

{

    
    NSMutableDictionary *_boolDic;
  
    //数据管理
    JYListDataManager *_dataManager;
}


/**
 *  更新内容通知
 */
- (void)upDateNotification
{
    
    //数据
    _systemRemind = _dataManager.systemRemind;
    _sendRemind   = _dataManager.sendRemind;
    _acceptRemind = _dataManager.acceptRemind;
    _shareRemind  = _dataManager.shareRemind;
    
    
    //好友数据
    _system_FArr = @[];
    _send_FArr   = @[];
    _accept_FArr = @[];
    _share_FArr  = @[];
    
    
    //更新数据刷新列表
    [self selectTbWithType:_listType];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    
    if (self == [super initWithFrame:frame style:style]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upDateNotification) name:kNotificationForManagerUpDate object:nil];
        
        //编辑状态下选中的数组、字典
        _selectData = [NSMutableArray array];
        _boolDic    = [NSMutableDictionary dictionary];
        
        //换肤
        _skinManager = [JYSkinManager shareSkinManager];
        //数据管理
        _dataManager = [JYListDataManager manager];
       
        //好友数据
        _system_FArr = @[];
        _send_FArr   = @[];
        _accept_FArr = @[];
        _share_FArr  = @[];
        
        
        //需要展示的数据
        _showArr = _sendRemind;
        
        self.delegate = self;
        self.dataSource = self;
        
        CGFloat imgWidth = 298/750.0*kScreenWidth;
        CGFloat imgHeight = 310/1334.0*kScreenHeight;
        _imgForNoRemind = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无提醒"]];
        _imgForNoRemind.frame = CGRectMake(kScreenWidth/2.0 - imgWidth/2.0, 240/1334.0*kScreenHeight, imgWidth, imgHeight);
        _imgForNoRemind.hidden = YES;
        _imgForNoRemind.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgForNoRemind];
    }
    
    return self;
}

#pragma mark -切换列表方法
- (void)selectTbWithType:(TABLE_TYPE )type
{
    _listType = type;
    switch (type) {
        case table_system:
        {
            
            _systemRemind = _dataManager.systemRemind;
            _system_FArr = [self _showFriendArr:_systemRemind];
           
            [self _showArr:_systemRemind];
            [self _showFArr:_system_FArr];
            
        }
            break;
        case tabel_accept:
        {
            _acceptRemind = _dataManager.acceptRemind;
            
            if (_accept_FArr.count == 0) {
                _accept_FArr = [self _showFriendArr:_acceptRemind];
            }
      
            [self _showArr:_acceptRemind];
            [self _showFArr:_accept_FArr];
        
        }
            break;
        case table_send:
        {
            
            _sendRemind = _dataManager.sendRemind;
            
            if (_send_FArr.count == 0) {
                _send_FArr = [self _showFriendArr:_sendRemind];
            }
          
            [self _showArr:_sendRemind];
            [self _showFArr:_send_FArr];
            
        }
            break;
        case table_share:
        {
            
            _shareRemind = _dataManager.shareRemind;
            
            if (_share_FArr.count == 0) {
                _share_FArr = [self _showFriendArr:_shareRemind];
            }
            
            
            [self _showArr:_shareRemind];
            [self _showFArr:_share_FArr];
            
        }
            break;            
        default:
            break;
    }
    
    [self reloadData];

}

//好友
- (NSArray *)_showFriendArr:(NSArray *)arr
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userName = [defaults objectForKey:kUserName];
    NSString *userHead = [defaults objectForKey:kUserHead];

    FriendListManager *shareFriendList = [FriendListManager shareFriend];
    NSMutableArray *f_arr = [NSMutableArray array];
    //头像人名
    for (RemindModel *model in arr) {
        
        if (model.isOther == 0) {
            
            FriendModel *f_model = [[FriendModel alloc] init];
            f_model.head_url = userHead;
            f_model.friend_name = userName;
            [f_arr addObject:f_model];
            
        }else{
            
            FriendModel *f_model = [shareFriendList selectDataWithFid:model.isOther];
            if(f_model){
                [f_arr addObject:f_model];
            }else{
                f_model = [[FriendModel alloc] init];
                f_model.friend_name = @"已删除该好友";
                [f_arr addObject:f_model];
            }
            
        }
    }

    return f_arr;
}

//展示的数组
- (void)_showArr:(NSArray *)arr
{
    _showArr = arr;
    if (_showArr.count == 0) {
        _imgForNoRemind.hidden = NO;
    }else{
        _imgForNoRemind.hidden = YES;
    }
}

//展示的好友
- (void)_showFArr:(NSArray *)arr
{
    _showFriendArr = arr;
}


#pragma mark -tableView dataSource
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return _showArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellIndetifier = @"cellIndetifier";
    
    JYListTCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (!cell) {
        cell = [[JYListTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    //删除、收藏、点击
    [self clickAction:cell indexPath:indexPath];
    [self deleteAction:cell indexPath:indexPath];
    [self collectionAction:cell indexPath:indexPath];
    
    
    RemindModel *model = _showArr[indexPath.row]; //事件Model
    FriendModel *f_model = _showFriendArr[indexPath.row]; //人Model
    
    //是否收藏过
    if (model.isSave != 0) {
        [cell.collcetionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
    }else {
        [cell.collcetionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    
//    [cell.shareHeadImage removeFromSuperview];
//    cell.shareHeadImage = nil;
    [cell.avatarView removeFromSuperview];
    cell.avatarView = nil;
    
    if (model.isShare && model.isOther == 0) {

        cell.headImage.hidden = YES;
        
        //分享头像
        [cell createShareHeadView:model];
        
    }else{
    
        cell.headImage.hidden = NO;
     
        //头像
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:f_model.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
    }
  
    //人名
    if (f_model.remarkName&&![f_model.remarkName isEqualToString:@""]) {
        cell.nameLabel.text = f_model.remarkName;
    }else{
        cell.nameLabel.text = f_model.friend_name;
    }

    //内容
    cell.titleLabel.text = model.title;
    
    //创建时间
    if (model.isShare) {
        
        cell.createTime.text = [Tool actionForListTimeStr:model.createTime type:shareType];
        
    }else {
        
        //别人发送给我的
        if (model.isOther != 0) {
            
            cell.createTime.text = [Tool actionForListTimeStr:model.createTime type:acceptType];
            
        }else {
            //我发送给别人的
            cell.createTime.text = [Tool actionForListTimeStr:model.createTime type:sendType];
            
        }
        
    }
   
    //日
    cell.dayLabel.text = [model.createTime substringWithRange:NSMakeRange(6, 2)];
    
    //星期
    cell.weekLabel.text = [Tool actionForWeekWithYearAll:model.year month:model.month day:model.day];
    
    //闹钟
    cell.clock.image = [UIImage imageNamed:@"闹钟完成状态.png"];
    
    
    //是否超过提醒时间
    if (model.isRemind) {
        
        cell.clock.image = [UIImage imageNamed:@"闹钟完成状态.png"];
        cell.titleLabel.textColor = grayTextColor;
        cell.nameLabel.textColor = grayTextColor;
        cell.dayLabel.textColor = grayTextColor;
        cell.weekLabel.textColor = grayTextColor;
        cell.createTime.textColor = grayTextColor;
        
    }else{
        
        cell.dayLabel.textColor = _skinManager.colorForDateBg;
        cell.clock.image = _skinManager.clockImage;
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.nameLabel.textColor = nameTextColor;
        cell.weekLabel.textColor = nameTextColor;
        cell.createTime.textColor = nameTextColor;
        cell.dayLabel.textColor = _skinManager.colorForDateBg;
    }
    
    //是否查看过
    if (model.isLook == 0) {
        
        cell.pointImage.hidden = YES;
        
    }else{
        
        cell.pointImage.hidden = NO;
    }
    
    if (model.isOn == 1 && model.musicName != 0 && model.musicName != 8) {
        
        cell.clock.hidden = NO;
    }else{
        cell.clock.hidden = YES;
    }
    
    if (_listType == table_system) {
        cell.scrollView.contentSize = CGSizeMake(kScreenWidth + 55, 0);
        cell.page = 55;
    }else{
        cell.scrollView.contentSize = CGSizeMake(kScreenWidth + 110, 0);
        cell.page = 110;
    }
    
    //编辑状态改变frame
    [self _editState:cell];
  
    cell.selectTypeImage.highlighted = [[_boolDic objectForKey:@(indexPath.row)]boolValue];
    
    return cell;

}

//编辑状态
- (void)_editState:(JYListTCell *)cell
{
    if (_isEdit) {
        
        cell.pointImage.origin = CGPointMake(50 + 35, 10);
        cell.headImage.origin = CGPointMake(10 + 35, 12.5);
        cell.nameLabel.frame = CGRectMake(69 + 45, 12.5, 149 - 45, 18);
        cell.titleLabel.frame = CGRectMake(69 + 45, 41, kScreenWidth  - 48 - 48 - 67 - 10 - 45, 21);
        cell.selectTypeImage.hidden = NO;
        cell.scrollView.scrollEnabled = NO;
        //cell.shareHeadImage.origin = CGPointMake(10 + 35, 12.5);
        cell.avatarView.origin = CGPointMake(10 + 35, 12.5);
        
    }else{
        
        cell.pointImage.origin = CGPointMake(50, 10);
        cell.headImage.origin = CGPointMake(10, 12.5);
        cell.nameLabel.frame = CGRectMake(69, 12.5, 149 , 18);
        cell.titleLabel.frame = CGRectMake(69, 41, kScreenWidth  - 48 - 48 - 67 - 10 , 21);
        cell.selectTypeImage.hidden = YES;
        cell.scrollView.scrollEnabled = YES;
        //cell.shareHeadImage.origin = CGPointMake(10, 12.5);
        cell.avatarView.origin = CGPointMake(10, 12.5);
        
    }
}


- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 75.f;
}


#pragma mark tableView delegate
//编辑状态下选中方法
- (void)selecetWithModel:(RemindModel *)model
                   index:(NSIndexPath *)indexPath
                    cell:(JYListTCell *)cell
{

    BOOL value = [[_boolDic objectForKey:@(indexPath.row)]boolValue];
    value = !value;
    [_boolDic setObject:@(value) forKey:@(indexPath.row)];
    
    cell.selectTypeImage.highlighted = value;
   
    //存储Model
    value ? [_selectData addObject:model] : [_selectData removeObject:model];
    
    if (_selectData.count == _showArr.count) {
        if (_selectAllBlock) {
            _selectAllBlock(YES);
        }
    }else{
        if (_selectAllBlock) {
            _selectAllBlock(NO);
        }
    }
    
    NSLog(@"%@",_selectData);
}

//点击方法
- (void)clickAction:(JYListTCell *)cell
          indexPath:(NSIndexPath *)indexPath
{
    //点击方法
    __weak typeof(self) weekSelf = self;
    [cell setClickBlock:^(JYListTCell *selectCell) {
        
        if (_isEdit) {
            
            RemindModel *model = _showArr[indexPath.row];
            [weekSelf selecetWithModel:model index:indexPath cell:selectCell];
            
        }else{
            
            if (_clickBlock) {
                 FriendModel *f_model = _showFriendArr[indexPath.row]; //人Model
                //人名
                NSString *name = nil;
                if (f_model.remarkName&&![f_model.remarkName isEqualToString:@""]) {
                    name = f_model.remarkName;
                }else{
                    name = f_model.friend_name;
                }
                RemindModel *model = _showArr[indexPath.row];
                model.friendName = name;
                _clickBlock(model);
            }
        }
        
       
    }];
}

//左划删除方法
- (void)deleteAction:(JYListTCell *)cell
           indexPath:(NSIndexPath *)indexPath
{
    [cell setDeleteBlock:^(JYListTCell *selectCell) {
        
        if (_deleteBlock) {
            _deleteBlock(_showArr[indexPath.row]);
        }
    }];
}

//左划收藏方法
- (void)collectionAction:(JYListTCell *)cell
               indexPath:(NSIndexPath *)indexPath
{
     [cell setCollectionBlock:^(JYListTCell *selectCell) {
         
         if (_collectionBlock) {
             _collectionBlock(_showArr[indexPath.row]);
         }
     }];
}


@end
