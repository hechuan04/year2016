//
//  RemindListTB.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "RemindListTB.h"
#import "BaseCell.h"
#import "RemindTypeCell.h"

static NSString *baseCellIndentifier = @"baseCellIndentifier";
static NSString *remindTypeCellIndentifier = @"remindTypeCellIndentifier";

@implementation RemindListTB

- (void)actionForNotification
{
    
    
}

- (void)dealloc
{
    NSLog(@"RemindListTB------dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationForLoadData object:@""];
    
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    
    if (self = [super initWithFrame:frame style:style]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionForNotification) name:kNotificationForLoadData object:@""];
        
        _skinManager = [JYSkinManager shareSkinManager];
        
        _arrForModel = @[@"全部",@"已发送",@"已接收",@"共享",@"系统消息"];
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"BaseCell" bundle:nil] forCellReuseIdentifier:baseCellIndentifier];
        [self registerClass:[RemindTypeCell class] forCellReuseIdentifier:remindTypeCellIndentifier];
        
        [Tool actionForHiddenMuchTable:self];
        
        _emptyImageViewForSearch = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_提醒列表_搜索"]];
        _emptyImageViewForSearch.center = CGPointMake(kScreenWidth/2.f,100.f);
        _emptyImageViewForSearch.hidden = YES;
        [self addSubview:_emptyImageViewForSearch];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    
    return self;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    headView.backgroundColor = [UIColor colorWithRed:240 / 255.0 green:240 / 255.0 blue:240 / 255.0 alpha:1];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 
    if (section == 0) {
        return 0;
    }else{
        return 15;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(_isSearch){
        return 1;
    }
    return 2;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isSearch){
        return [_arrForModel count];
    }else{
        if (section == 0) {
            
            return 4;
            
        }else{
            
            return 1;
            
        }
    }
    
}

//查找刷新
- (void)loadDataWithArr:(NSArray *)arrForModel
{
    NSMutableArray *alr = [NSMutableArray array];
    NSMutableArray *flr = [NSMutableArray array];
    
    for (int m = 0; m < arrForModel.count; m++) {
        
        RemindModel *model =  arrForModel[m];
        
        
        BOOL isAlready = [Tool isAlreadyNowYear:model.year month:model.month day:model.day hour:model.hour minute:model.minute];
        
        if (isAlready) {
            
            model.isRemind = NO;
            
            
        }else{
            
            model.isRemind = YES;
        }
        
        
        
        [alr addObject:model];
        
        FriendListManager *shareFriendList = [FriendListManager shareFriend];
        FriendModel *model1 = [shareFriendList selectDataWithFid:model.isOther];
        
        if (model.isOther == 0) {
            
            model1.friend_name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
            model1.head_url = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
        }
        
        [flr addObject:model1];
        
        
    }
    
    
    _arrForModel = alr;
    _friendArr = flr;
    
    [self reloadData];
    
    if ([_arrForModel count] == 0&&[_friendArr count]==0) {
        if(!arrForModel){
            _emptyImageViewForSearch.hidden = YES;
        }else{
            _emptyImageViewForSearch.hidden = NO;
        }
        
    }else{
        _emptyImageViewForSearch.hidden = YES;
    }
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isSearch){
        
        BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCellIndentifier];
        
        
        if (!cell) {
            
            cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:baseCellIndentifier];
            
        }
        
        [cell setTapAction:^(BaseCell *cell) {
            
            NSLog(@"总表点击了");
            
            NSInteger index = [tableView indexPathForCell:cell].row;
            
            if (_isSearch) {
                
                RemindModel *model = _arrForModel[index];
                
                _pushModel(model);
                
            }else{
                
                _pushList(index);
                
            }
            
            
            
        }];
        
        [cell setDeleteAction:^(BaseCell *cell) {
            
            NSLog(@"总表删除了");
        }];
        
        [cell setCollectionAction:^(BaseCell *cell) {
            
            NSLog(@"总表收藏了");
        }];
        
        
        return cell;
        
    }else{
        
        RemindTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:remindTypeCellIndentifier];
        NSString *unreadStr = @"0";
    
        if (indexPath.section == 0) {
            //设置角标
            switch (indexPath.row) {
                case 0:{//全部
                    unreadStr = [NSString stringWithFormat:@"%@",[self.unreadDictionary objectForKey:kUnreadAllKey]];
                }
                    break;
                    
                    
                case 2:{//已接受
                    unreadStr = [NSString stringWithFormat:@"%@",[self.unreadDictionary objectForKey:kUnreadAcceptKey]];
                }
                    break;
                case 3:{//共享
                    unreadStr = [NSString stringWithFormat:@"%@",[self.unreadDictionary objectForKey:kUnreadShareKey]];
                }
                    break;
                default:
                    break;
            }

            [cell setTitle:_arrForModel[indexPath.row] unreadCount:unreadStr];
            cell.headImage.image = [UIImage imageNamed:_skinManager.arrForHListImage[indexPath.row]];
        }else{
             unreadStr = [NSString stringWithFormat:@"%@",[self.unreadDictionary objectForKey:kUnreadSystemKey]];
            [cell setTitle:@"系统消息" unreadCount:unreadStr];
            cell.headImage.image = [UIImage imageNamed:[_skinManager.arrForHListImage lastObject]];
        }
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
      if(!_isSearch){
        
          if (indexPath.section == 1) {
              
              _pushList(4);

          }else{
              _pushList(indexPath.row);

          }
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell1 forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    BaseCell *cell = (BaseCell *)cell1;
    
    if (_isSearch) {
        
        [cell appearAll];
        [cell hiddenTrigonometryImage];
        if (_arrForModel.count == 0) {
            
            return;
        }
        
        

        
        FriendModel *frModel = _friendArr[indexPath.row];
        
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:frModel.head_url]];
        if(frModel.remarkName&&![frModel.remarkName isEqualToString:@""]){
            cell.nameLabel.text = frModel.remarkName;
        }else{
            cell.nameLabel.text = frModel.friend_name;
        }
        
        
        RemindModel *reModel = _arrForModel[indexPath.row];
        cell.titleLabel.text = reModel.title;
        cell.dayLabel.text = [reModel.createTime substringWithRange:NSMakeRange(6, 2)];
        int year = [[reModel.createTime substringWithRange:NSMakeRange(0, 4)] intValue];
        int month = [[reModel.createTime substringWithRange:NSMakeRange(4, 2)] intValue];
        int day = [[reModel.createTime substringWithRange:NSMakeRange(6, 2)] intValue];
        cell.weekLabel.text = [Tool actionForWeekWithYearAll:year month:month day:day];
        //判断是否显示闹钟(1)
        if (reModel.isOn) {
            
            cell.clock.hidden = NO;
            
            //判断提醒他人情况下是否显示闹钟(2)①
            if (![reModel.fidStr isEqualToString:@""] || ![reModel.gidStr isEqualToString:@""]) {
                
                if (reModel.isOther != 0) {
                    
                    cell.clock.hidden = NO;
                    
                }else{
                    
                    cell.clock.hidden = YES;
                    
                }
                
            }else{
                
                //本地提醒显示闹钟(2)②
                cell.clock.hidden = NO;
            }
            
        }else{
            
            cell.clock.hidden = YES;
        }
        
        
        //判断显示的是发送还是接收还是设置
        //判断显示的是发送还是接收还是设置
        if (reModel.uid != 0) {
            
            //分享的
            if (reModel.isShare) {
                
                cell.createTime.text = [Tool actionForListTimeStr:reModel.createTime type:shareType];
                
            }else {
                
                //别人发送给我的
                if (reModel.isOther != 0) {
                    
                    cell.createTime.text = [Tool actionForListTimeStr:reModel.createTime type:acceptType];
                    
                }else {
                    //我发送给别人的
                    cell.createTime.text = [Tool actionForListTimeStr:reModel.createTime type:sendType];
                    
                }
                
            }
            
            
        }else {
            
            //自己给自己设置的
            cell.createTime.text = [Tool actionForListTimeStr:reModel.createTime type:selfType];
        }
        
        
        if (reModel.isRemind) {
            
            cell.clock.image = [UIImage imageNamed:@"闹钟完成状态.png"];
            cell.titleLabel.textColor = grayTextColor;
            cell.nameLabel.textColor = grayTextColor;
            
        }else{
            
            cell.clock.image = _skinManager.clockImage;
            cell.titleLabel.textColor = [UIColor blackColor];
            cell.nameLabel.textColor = [UIColor blackColor];
            
        }
        
        
        
        if (reModel.isLook == 0) {
            
            cell.pointImage.hidden = YES;
            
        }else{
            
            cell.pointImage.hidden = NO;
        }
        
        if (reModel.isOther != 0 || reModel.uid != 0) {
            
            cell.otherClock.hidden = NO;
            
        }else{
            
            cell.otherClock.hidden = YES;
        }
        
        if (reModel.isShare && reModel.isOther == 0) {
            
            NSLog(@"分享的哦");
            cell.headImage.hidden = YES;
            cell.headView.hidden = NO;
            
            
            cell.arrForHead = [cell loadHeadWithModel:reModel];
            
            if (cell.arrForHead.count > 0) {
                
                if (cell.arrForHead.count == 1) {
                    
                    
                    cell.headImage.hidden = NO;
                    cell.headView.hidden = YES;
                    
                    cell.headImage.image = cell.arrForHead[0];
                    
                    
                }else {
                    
                    
                    
                    [cell.headView removeFromSuperview];
                    
                    cell.headView = [[HeadView alloc] initWithFrame:CGRectMake(10, 8, 45, 45) andType:(int )cell.arrForHead.count andArr:cell.arrForHead];
                    cell.headView.backgroundColor = [UIColor colorWithRed:180 / 255.0 green:180 / 255.0 blue:180 / 255.0 alpha:1];
                    
                    cell.headView.layer.masksToBounds = YES;
                    cell.headView.layer.cornerRadius = 45.0 / 2.0;
                    [cell.topView addSubview:cell.headView];
                    
                    
                    
                }
                
            }
            
            
        }else {
            
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:frModel.head_url]];
            cell.headImage.hidden = NO;
            cell.headView.hidden = YES;
            
        }
       
        
        cell.textLabel.text = @"";
        
    }else{
//        
//        cell.headView.hidden = YES;
//        [cell hiddenAll];
//        [cell appearTrigonmetryImage];
//        cell.textLabel.text = _arrForModel[indexPath.row];
        
        
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    if(height>0){
        self.contentInset = UIEdgeInsetsMake(0, 0, height+30.f, 0);
    }
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
