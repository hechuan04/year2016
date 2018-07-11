//
//  JYAlreadyTableView.m
//  JYCalendar
//
//  Created by 吴冬 on 15/10/13.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYAlreadyTableView.h"
#import "JYAlreadyTableViewCell.h"

static NSString *strForAlreadyCell = @"strForAlreadyCell";


@implementation JYAlreadyTableView
{
   
    
}


- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                andAlreadyArr:(NSArray *)alreadyArr
{
  
    if (self = [super initWithFrame:frame style:style]) {
        
        _skinManager = [JYSkinManager shareSkinManager];
        
        self.delegate = self;
        self.dataSource = self;
        _otherArr = alreadyArr;
        
        [self registerNib:[UINib nibWithNibName:@"JYAlreadyTableViewCell" bundle:nil] forCellReuseIdentifier:strForAlreadyCell];
  
    }
    
    
    return self;
}


//row高度
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 60;
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        
        return _otherArr.count;
 
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYAlreadyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strForAlreadyCell];
    if (!cell) {
        
        cell = [[JYAlreadyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForAlreadyCell];
        //cell.backgroundColor = [UIColor colorWithRed:0.449 green:0.446 blue:1.000 alpha:1.000];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_otherArr.count > 0) {
        
        RemindModel *model = _otherArr[indexPath.row];
        FriendModel *model1 = _friendArr[indexPath.row];
        
//        NSString *hour  = [self returnStrForDate:model.hour];
//        NSString *minute = [self returnStrForDate:model.minute];
    
        cell.selectTimeLabel.text = [Tool actionForListTimeZhuStr:model.createTime year:_year month:_month day:_day isAccept:YES];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",model.title];
        //cell.backgroundColor = [UIColor orangeColor];
        
        if (model1.head_url == nil) {
            
            cell.headView.image = [UIImage imageNamed:@"已删除头像.jpg"];
            cell.headView.backgroundColor = [UIColor grayColor];
            cell.userName.text = @"已删除该好友";
            
        }else{
            
            [cell.headView sd_setImageWithURL:[NSURL URLWithString:model1.head_url] placeholderImage:[UIImage imageNamed:@"默认用户头像"]];
            NSString *name = nil;
            if (model1.remarkName&&![model1.remarkName isEqualToString:@""]) {
                name = model1.remarkName;
            }else{
                name = model1.friend_name;
            }
            cell.userName.text = name;
        }
        
        
      
        
//        if (model.randomType != 0) {
//            
//            cell.everyDayLabel.hidden = NO;
//         
//        }else{
//          
//            cell.everyDayLabel.hidden = YES;
//        }
        
        if (model1.keystatus == 100) {
            
            cell.userName.origin = CGPointMake(65 + 14 + 6, 7);
            cell.imageForKey.hidden = NO;
            
        }else{
         
            cell.userName.origin = CGPointMake(65, 7);
            cell.imageForKey.hidden = YES;
        }
        
        
        if (model.isOn && model.musicName != 8) {
            
            cell.clockImage.hidden = NO;
            
        }else{
        
            cell.clockImage.hidden = YES;
        }
        
        
        
        if (model.isRemind) {
            
            cell.clockImage.image = [UIImage imageNamed:@"闹钟完成状态.png"];
            cell.timeLabel.textColor = grayTextColor;
            cell.userName.textColor = grayTextColor;
            cell.selectTimeLabel.textColor = grayTextColor;
            
        }else{
         
            
            cell.clockImage.image = _skinManager.clockImage;
            cell.timeLabel.textColor = [UIColor blackColor];
            cell.userName.textColor = nameTextColor;
            cell.selectTimeLabel.textColor = nameTextColor;
        }
        
        
        
        if (model.isLook == 0) {
            
            cell.isLookImage.hidden = YES;
            
        }else{
            
            cell.isLookImage.hidden = NO;
            cell.clockImage.image = _skinManager.clockImage;
            cell.timeLabel.textColor = [UIColor blackColor];
            cell.userName.textColor = nameTextColor;
        }

    }

    
    return cell;
    
}

- (NSString *)returnStrForDate:(int )time
{
    NSString *strForDate = @"";
    if (time < 10) {
        
        strForDate = [NSString stringWithFormat:@"0%d",time];
        
    }else{
        
        
        strForDate = [NSString stringWithFormat:@"%d",time];
    }
    
    return strForDate;
}

//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RemindModel *model = _otherArr[indexPath.row];
    FriendModel *model1 = _friendArr[indexPath.row];
    
    if (model1.remarkName&&![model1.remarkName isEqualToString:@""]) {
        model.friendName = model1.remarkName;
    }else{
        model.friendName = model1.friend_name;
    }

    _actionForModel(model);
    
    if (model.isLook == 1) {
        
        model.isLook = 0;
        
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        
        [manager upDataWithModel:model];
        
        NSString *midStr = [NSString stringWithFormat:@"%d",model.uid];
        [RequestManager actionForIsHaveLook:midStr];
        
        //如果之前没看过，刷新
        [self reloadData];
    }
     
}

//在这里边做删除数据的调整
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        RemindModel *model = _otherArr[indexPath.row];
    
    
    
    /*本地删除
        IncidentListManager *manager = [IncidentListManager shareIncidentManager];
        [manager deleteDataWithUid:model.uid ownId:model.oid existUid:model.uid];
        
        NSArray *allArray = [manager selectAllData];
        DataArray *dataArr = [DataArray shareDateArray];
        dataArr.arrForAllData = allArray;
    */
    
    JYSelectManager *selectManager = [JYSelectManager shareSelectManager];
    
    selectManager.labelForBefore.backgroundColor = [UIColor clearColor];
    selectManager.labelForBefore = nil;
    selectManager.strForBeforeLabel = nil;
    selectManager.viewForPoint = nil;
    selectManager.isHiddenPoint = YES;
    
        NSString *passStr = [NSString stringWithFormat:@"%d",model.uid];
    [RequestManager actionForDeleteAccept:passStr isChangeMainView:YES];

    
        //更新UI
        //_actionForDeleteModel(model);
        
    //[self loadData:model.year month:model.month day:model.day isAwaysChange:NO];
    
  
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

/**
 *  根据是否为选中时间加载数据
 *
 *  @param year  年
 *  @param month 月
 *  @param day   日
 */
//加载数据
- (BOOL)loadData:(int )year
           month:(int )month
             day:(int )day
   isAwaysChange:(BOOL)isAwaysChange
{
    
    
    
    if (year == 0 && month == 0 && day == 0) {
        
        year = [[Tool actionForNowYear:nil] intValue];
        month = [[Tool actionForNowMonth:nil] intValue];
        day = [[Tool actionForNowSingleDay:nil] intValue];
        
        
    }else if(_year == year && _month == month && _day == day && isAwaysChange){
     
    
        if (_otherArr.count > 0) {
            
            return YES;
            
        }else{
            
            return NO;
        }
        
    }
    
    _countForNotLookNumber = 0;
    
    _year = year;
    _month = month;
    _day = day;
    
    DataArray *dataArr = [DataArray shareDateArray];
    
    NSArray *arr = dataArr.arrForAllData;
    
    NSMutableArray *alr = [NSMutableArray array];
    NSMutableArray *flr = [NSMutableArray array];
    int userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID] intValue];

    
    for (int m = 0; m < arr.count; m++) {
        
        RemindModel *model =  arr[m];
        
        //选中时间，是否为当前时间之后(硬性指标，必须为YES才可以)
        // BOOL isNextDay = [Tool isAlreadyNowYear:year month:month day:day hour:model.hour minute:model.minute];
        
        if (model.isOther == 0 || model.isOther == userID || model.isShare == 1) {
            
            continue;
        }
        
        //重复情况下判断是否是当天
        BOOL isNowDay = NO;
        
        if (model.randomType != 0) {
            
            
            BOOL isAlready = [Tool isAlreadyNowYear:year month:month day:day hour:model.hour minute:model.minute];
            
            if (isAlready) {
                
                model.isRemind = NO;
          
                
            }else{
                
                model.isRemind = YES;
            }
            
            isNowDay = [Tool actionForJudgementAndNotNotification:model year:year month:month day:day];
            
        }
        
        //没有选中重复的情况，是否超过提醒时间,且是否与选中天数相等
        BOOL isNotReapeat = NO;
        
        
        if (model.randomType == 0 && model.year == year && model.month == month && model.day == day) {
            
            //在没有重复的情况下判断是否超过当天时间
            BOOL isAlready = [Tool isAlreadyNowYear:model.year month:model.month day:model.day hour:model.hour minute:model.minute];
            if (isAlready) {
                
                model.isRemind = NO;
                
            }else{
                
                model.isRemind = YES;
            }
            
            isNotReapeat = YES;
            
        }
        
        //判断是否需要增加显示的cell
        if (isNotReapeat || isNowDay){
   
            [alr addObject:model];
            FriendListManager *shareFriendList = [FriendListManager shareFriend];
            
            FriendModel *model1 = [shareFriendList selectDataWithFid:model.isOther];
            
            if (model1 == nil) {
                model1 = [[FriendModel alloc] init];
            }
            
            [flr addObject:model1];
        }
        
    }
    
    
    
    _otherArr = alr;
    _friendArr = flr;
    
    int notLookNumber = 0;
    for (int i = 0; i < _otherArr.count; i++) {
        
        RemindModel *model = _otherArr[i];
        
        notLookNumber = notLookNumber + (int )model.isLook;
        
    }
    
    //没看信息条数
    _countForNotLookNumber = notLookNumber;
    
    //传递是否别人看过的数量
    _actionForChangeLookLabel(notLookNumber);
    
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForAcceptHiddenEditBtn object:@(_otherArr.count)];

    if (_otherArr.count > 0) {
        
        return YES;
        
    }else{
     
        return NO;
    }
     
}

//判断重复的记录是否过了提醒时间
- (BOOL)isAlreadyNowYear:(int )year
                 month:(int )month
                   day:(int )day
                  hour:(int )hour
                  minute:(int )minute
{

    //现在时间
    NSDate *dateNow = [NSDate date];
    NSTimeInterval _secondDate = [dateNow timeIntervalSince1970]*1;
    
    //选中时间
    NSDate *dateForRemind = [Tool actionForReturnSelectedDateWithDay:day Year:year month:month hour:hour minute:minute];
    NSTimeInterval _fitstDate = [dateForRemind timeIntervalSince1970]*1;
    
    if (_fitstDate - _secondDate > 0) {
        
        return NO;
        
    }else{
     
        return YES;
    }

}



@end
