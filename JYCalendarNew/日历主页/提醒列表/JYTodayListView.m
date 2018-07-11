//
//  JYTodayListView.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/8/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYTodayListView.h"
#import "JYTodayListCell.h"
#import "JYNotYetListCell.h"
#import "JYCountDownManager.h"
#import "JYTimerManager.h"

#import "JYListDataManager.h"

static NSString *notYetEmptyIdentifier = @"notYetEmptyIdentifier";
static NSString *todayListIndentifier = @"todayListIndentifier";
static NSString *notYetListIdentifier = @"notYetListIdentifier";

@implementation JYTodayListView

{

    JYListDataManager *_dataManager; //数据管理者
    JYTimerManager *_timerManager; //管理倒计时的类
  
    
    NSArray          *_todayList; //点击隐藏关闭时用到的数组
    NSArray          *_notyetList;
    
    UIView *todayHeadView;
    UIView *notYetHeadView;
    
    BOOL _hightLight1; //针对退出刷新的问题
    BOOL _hightLight2;
}

//内部点击头视图方法<today>
- (void)_reloadTodayData
{
    if (_todayList.count == 0) {
        _todayRemind = @[@""];
        _isTodayEmpty = YES;
    }else{
        _isTodayEmpty = NO;
        _todayRemind = _todayList;
    }
}

//内部点击头视图方法<notYet>
- (void)_reloadNotYetData
{
    if (_notyetList.count == 0) {
        _notYetRemind = @[@""];
        _isNotYetEmpty = YES;
    }else{
        _isNotYetEmpty = NO;
        _notYetRemind = _notyetList;
    }
}

//外部刷新方法
- (void)reloadArrData
{
    if (_todayList.count == 0) {
        _todayRemind = @[@""];
        _isTodayEmpty = YES;
    }else{
        _isTodayEmpty = NO;
    }
    
    if (_notyetList.count == 0) {
        _notYetRemind = @[@""];
        _isNotYetEmpty = YES;
    }else{
        _isNotYetEmpty = NO;
    }
}

/**
 *  更新内容通知
 */
- (void)upDateNotification
{
    //可能为nil是因为调用reloadData方法，没有在主界面
    UIImageView *image1 = [self viewWithTag:700];
    UIImageView *image2 = [self viewWithTag:701];

    
    //数据
    NSDictionary *dic = _dataManager.dataDic;
    _notyetList= dic[@"after"];
    _todayList  = dic[@"today"];
 
    
    self.contentOffset = CGPointMake(0, 0);
 
    if (!_hightLight1) {
        _todayRemind = @[];
    }else{
        [self _reloadTodayData];
    }
    
    if (!_hightLight2) {
        _notYetRemind = @[];
    }else{
        [self _reloadNotYetData];
    }
    
    //好友数据
    _notYet_Farr = @[];
    _today_Farr  = @[];
    
    for (NSTimer *timer in _timerManager.timerArr) {
        [timer invalidate];
    }
    
    [_timerManager.timerArr removeAllObjects];
    [_timerDic removeAllObjects];
    
    [self reloadData];
}


- (void)leaveReloadData
{
    NSDictionary *dic = _dataManager.dataDic;
    
    _notYetRemind = dic[@"after"];
    _todayRemind  = dic[@"today"];
    
    _todayList = _todayRemind;
    _notyetList = _notYetRemind;
    
    if (_todayList.count == 0) {
        _isTodayEmpty = YES;
    }else{
        _isTodayEmpty = NO;
    }
    
    if (_notyetList.count == 0) {
        _isNotYetEmpty = YES;
    }else{
        _isNotYetEmpty = NO;
    }
    
    [self reloadData];

}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
   
    if (self == [super initWithFrame:frame style:style]) {
       
        //数据库
        _dataManager = [JYListDataManager manager];

        //timer管理
        _timerManager = [JYTimerManager manager];
        
        //timer容器
        _timerManager.timerArr = [NSMutableArray array];
        
        //编辑状态下选中的数组、字典
        _selectData = [NSMutableArray array];
        _boolDic    = [NSMutableDictionary dictionary];
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upDateNotification) name:kNotificationForManagerUpDate object:nil];
        
        
        self.delegate = self;
        self.dataSource = self;
      
        NSDictionary *dic = _dataManager.dataDic;
       
        _notYetRemind = dic[@"after"];
        _todayRemind  = dic[@"today"];
        
        
        _todayList = _todayRemind;
        _notyetList = _notYetRemind;
        
        if (_todayList.count == 0) {
            _isTodayEmpty = YES;
        }else{
            _isTodayEmpty = NO;
        }
        
        if (_notyetList.count == 0) {
            _isNotYetEmpty = YES;
        }else{
            _isNotYetEmpty = NO;
        }
        
        
        
        //存储timer的字典
        _timerDic = [NSMutableDictionary dictionary];
    
        /*
        CGFloat imgWidth = 298/750.0*kScreenWidth;
        CGFloat imgHeight = 310/1334.0*kScreenHeight;
        _imgForNoRemind = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无提醒"]];
        _imgForNoRemind.frame = CGRectMake(kScreenWidth/2.0 - imgWidth/2.0, 240/1334.0*kScreenHeight, imgWidth, imgHeight);
        _imgForNoRemind.hidden = YES;
        _imgForNoRemind.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgForNoRemind];
         */
    }
    
    return self;
}


#pragma mark -tableView DataSource
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _todayRemind.count;
    }else{
        return _notYetRemind.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //根据分组不同加载不同的cell
    if (indexPath.section == 0) {
       
        if (_isTodayEmpty) {
            

            UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayListIndentifier];
         
            
            cell.textLabel.text = @"主人，今天没有任何提醒哦。";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 75)];
            cell.userInteractionEnabled = NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            return cell;
            
        }else{
        
            //倒计时
            NSString *timeKey = [NSString stringWithFormat:@"%ld_%ld_%@",indexPath.section,indexPath.row,todayListIndentifier];
            JYTodayListCell *cell = [tableView dequeueReusableCellWithIdentifier:timeKey];
            
            if (!cell) {
                cell = [[JYTodayListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:todayListIndentifier];
            }
            
            
            //竖线颜色,横线Hidden,timeLabel;
            RemindModel *remind_model = _todayRemind[indexPath.row];
            remind_model.index = (int )indexPath.row;
            cell.erectLine.backgroundColor = RGB_COLOR(215, 119, 128);
            cell.timeLabel.backgroundColor = RGB_COLOR(215, 119, 128);
            
            if (indexPath.row == _todayRemind.count - 1) {
                cell.horizontalLine.hidden = YES;
            }else{
                cell.horizontalLine.hidden = NO;
            }
            
            if (remind_model.isSave != 0) {
                [cell.collcetionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            }else {
                [cell.collcetionBtn setTitle:@"收藏" forState:UIControlStateNormal];
            }
            
            
            cell.clockImage.image = [UIImage imageNamed:@"today_red"];
            if (remind_model.isOn == 1 && remind_model.musicName != 0 && remind_model.musicName != 8) {
                
                cell.clockImage.hidden = NO;
            }else{
                cell.clockImage.hidden = YES;
            }
            
            
            cell.timeLabel.text = [Tool countDownStrWithModelTime:remind_model];
            //标题
            cell.titleLabel.text = remind_model.title;
            
            
            JYCountDownManager *countManager = [_timerDic objectForKey:timeKey];
            
            cell.countDownLabel.attributedText = countManager.attStr;
            
            //避免多次调用timer
            if (!countManager) {
                
                countManager = [[JYCountDownManager alloc] init];
                cell.countDownLabel.attributedText = [countManager beginTimerWithModel:remind_model];
                
                [_timerDic setObject:countManager forKey:timeKey];
                
            }
            
            countManager.cellLabel = cell.countDownLabel;
            
            [self clickAction:cell indexPath:indexPath];
            [self deleteAction:cell indexPath:indexPath];
            [self collectionAction:cell indexPath:indexPath];
            
            if (_isEdit) {
                
                cell.erectLine.origin = CGPointMake(30 + 35, 0);
                cell.timeLabel.origin = CGPointMake(10 + 35,  (75 - 20)/2.0);
                cell.countDownLabel.origin = CGPointMake(65 + 45, 45);
                cell.titleLabel.origin = CGPointMake(65 + 45, 15);
                cell.selectTypeImage.hidden = NO;
                cell.scrollView.scrollEnabled = NO;
                
            }else{
                
                cell.erectLine.origin = CGPointMake(30, 0);
                cell.timeLabel.origin = CGPointMake(10,  (75 - 20)/2.0);
                cell.countDownLabel.origin = CGPointMake(65, 45);
                cell.titleLabel.origin = CGPointMake(65, 15);
                cell.selectTypeImage.hidden = YES;
                cell.scrollView.scrollEnabled = YES;
                
            }
            
            NSString *key = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
            cell.selectTypeImage.highlighted = [[_boolDic objectForKey:key]boolValue];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;

        }
        
        
    }else{
        
        
        if (_isNotYetEmpty) {
            
           
            UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notYetEmptyIdentifier];
            
            
            cell.textLabel.text = @"新提醒，新生活。";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.userInteractionEnabled = NO;

            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            
        }else{
        
            JYNotYetListCell *cell = [tableView dequeueReusableCellWithIdentifier:notYetListIdentifier];
            
            if (!cell) {
                cell = [[JYNotYetListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notYetListIdentifier];
            }
            
            RemindModel *remind_model = _notYetRemind[indexPath.row];
            remind_model.index = (int )indexPath.row;
            
            
            if (remind_model.isSave != 0) {
                [cell.collcetionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
            }else {
                [cell.collcetionBtn setTitle:@"收藏" forState:UIControlStateNormal];
            }
            
            cell.clockImage.image = [UIImage imageNamed:@"today_yellow"];
            if (remind_model.isOn == 1  && remind_model.musicName != 0 && remind_model.musicName != 8) {
                cell.clockImage.hidden = NO;
            }else{
                cell.clockImage.hidden = YES;
            }
            
            //倒计时
            
            cell.erectLine.backgroundColor = RGB_COLOR(215, 167, 119);
            cell.timeLabel.backgroundColor = RGB_COLOR(215, 167, 119);
            
            //时间赋值
            NSString *timeLabelStr = [Tool countDownStrWithModelTime:remind_model];
            
            //时间显示
            cell.timeLabel.text = timeLabelStr;
            
            
            cell.titleLabel.text = remind_model.title;
            cell.countDownLabel.text = [Tool countDownStrWithModel:remind_model];
            
            [self clickAction:cell indexPath:indexPath];
            [self deleteAction:cell indexPath:indexPath];
            [self collectionAction:cell indexPath:indexPath];
            
            if (_isEdit) {
                
                cell.erectLine.origin = CGPointMake(30 + 35, 0);
                cell.timeLabel.origin = CGPointMake(10 + 35,  (75 - 20)/2.0);
                cell.countDownLabel.origin = CGPointMake(65 + 45, 45);
                cell.titleLabel.origin = CGPointMake(65 + 45, 15);
                cell.selectTypeImage.hidden = NO;
                cell.scrollView.scrollEnabled = NO;
                
            }else{
                
                cell.erectLine.origin = CGPointMake(30, 0);
                cell.timeLabel.origin = CGPointMake(10,  (75 - 20)/2.0);
                cell.countDownLabel.origin = CGPointMake(65, 45);
                cell.titleLabel.origin = CGPointMake(65, 15);
                cell.selectTypeImage.hidden = YES;
                cell.scrollView.scrollEnabled = YES;
                
            }
            
            NSString *key = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
            cell.selectTypeImage.highlighted = [[_boolDic objectForKey:key]boolValue];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            return cell;

        }
        
    }

    
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewIdentifier = @"headerViewIdentifier";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewIdentifier];
    if (!headerView) {
        if (section == 0) {
            headerView = (UITableViewHeaderFooterView *)[self _headerView:section arr:_todayRemind];

        }else{
            headerView = (UITableViewHeaderFooterView *)[self _headerView:section arr:_notYetRemind];

        }
    }
    
    return headerView;
}

//头视图
- (UIButton *)_headerView:(NSInteger )section arr:(NSArray *)arr
{
    
    UIButton *bgView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.f)];
    bgView.tag = section + 600;
    [bgView addTarget:self action:@selector(clickHeadAction:) forControlEvents:UIControlEventTouchUpInside];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    topLine.backgroundColor = lineColor;
    [bgView addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 , kScreenWidth, 0.5)];
    bottomLine.backgroundColor = lineColor;
    [bgView   addSubview:bottomLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth - 30, 44.f)];
    label.userInteractionEnabled = NO;
    [bgView addSubview:label];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((30 - 11)/2.0, (44 - 11)/2.0, 11, 11)];
    [imageView setImage:[UIImage imageNamed:@"左.png"]];
    imageView.tag = section + 700;
    imageView.userInteractionEnabled = NO;
    [imageView setHighlightedImage:[UIImage imageNamed:@"下.png"]];
    imageView.highlighted = YES;
    [bgView addSubview:imageView];
    
    if (section == 0) {
        
        if (arr.count == 0) {
            imageView.highlighted = NO;
        }
        label.text = @"今天";
        _hightLight1 = imageView.highlighted;
    }else{
        
        if (arr.count == 0) {
            imageView.highlighted = NO;
        }
        label.text = @"待办";
        _hightLight2 = imageView.highlighted;
    }
    
    return bgView;
}



#pragma mark -tableView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat y = scrollView.contentOffset.y;
    CGFloat section1_height = _todayRemind.count * 75.0;
    if (_scrollViewDidScrollBlock) {
        _scrollViewDidScrollBlock(y,section1_height);
    }
   
     
}

//外部,点击头视图方法
- (void)clickHeadAction:(UIButton *)sender
               isSelect:(BOOL)select
{
    UIImageView *arrowHead = [self viewWithTag:sender.tag + 100];
    arrowHead.highlighted = select;
    
    if (sender.tag == 600) {
    
        //高亮为选中状态
        if (select) {
            
            _hightLight1 = YES;
            _todayRemind = _todayList;
            [self _reloadTodayData];
            NSLog(@"选中列表1");
        }else{
           
            _hightLight1 = NO;
            _todayRemind = @[];
            NSLog(@"关闭列表1");
        }
  
    }else{
    
        if (select) {
            
            _hightLight2 = YES;
            _notYetRemind = _notyetList;
            [self _reloadNotYetData];
            NSLog(@"选中列表2");
        }else{
            
            _hightLight2 = NO;
            _notYetRemind = @[];
            NSLog(@"关闭列表2");
        }

    }
    
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    [self reloadData];

}

//内部，点击头视图方法
- (void)clickHeadAction:(UIButton *)sender
{
    UIImageView *image = [self viewWithTag:sender.tag + 100];
    image.highlighted = !image.highlighted;
    if (sender.tag == 600) {
        
        //高亮为选中状态
        if (image.highlighted) {
            
            [self _reloadTodayData];
            NSLog(@"选中列表1");
        }else{
            
            _todayRemind = @[];
            NSLog(@"关闭列表1");
        }
        
        _hightLight1 = image.highlighted;
        
        if (_clickHeadBlock) {
            _clickHeadBlock(image.highlighted,0);
        }

    }else{
        
        if (image.highlighted) {
            
            [self _reloadNotYetData];
            NSLog(@"选中列表2");
        }else{
            
            _notYetRemind = @[];
            NSLog(@"关闭列表2");
        }
    
        _hightLight2 = image.highlighted;
        if (_clickHeadBlock) {
            _clickHeadBlock(image.highlighted,1);
        }
        
    }
    
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
    [self reloadData];
   
}

//编辑状态下选中方法
- (void)selecetWithModel:(RemindModel *)model
                   index:(NSIndexPath *)indexPath
                    cell:(JYListTCell *)cell
{
    
    NSString *key = [NSString stringWithFormat:@"%ld_%ld",indexPath.section,indexPath.row];
    BOOL value = [[_boolDic objectForKey:key]boolValue];
    value = !value;
    [_boolDic setObject:@(value) forKey:key];
    
    cell.selectTypeImage.highlighted = value;
    
    //存储Model
    value ? [_selectData addObject:model] : [_selectData removeObject:model];
    
    NSInteger count1;NSInteger count2;
    if (_todayRemind.count == 1 && [_todayRemind[0] isKindOfClass:[NSString class]]) {
        count1 = 0;
    }else{
        count1 = _todayRemind.count;
    }
    
    if (_notYetRemind.count == 1 && [_notYetRemind[0] isKindOfClass:[NSString class]]) {
        count2 = 0;
    }else{
        count2 = _notYetRemind.count;
    }
    
    
    
    if (_selectData.count == (count1 + count2)) {
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
            
            RemindModel *model ;
            
            if (indexPath.section == 0) {
                model = _todayRemind[indexPath.row];
            }else{
                model = _notYetRemind[indexPath.row];
            }
            
            [weekSelf selecetWithModel:model index:indexPath cell:selectCell];
            
        }else{
            if (_clickBlock) {
                indexPath.section == 0 ? _clickBlock(_todayRemind[indexPath.row]) :
                _clickBlock(_notYetRemind[indexPath.row]);
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
            indexPath.section == 0 ? _deleteBlock(_todayRemind[indexPath.row]) : _deleteBlock(_notYetRemind[indexPath.row]);
        }

    }];
}

//左划收藏方法
- (void)collectionAction:(JYListTCell *)cell
               indexPath:(NSIndexPath *)indexPath
{
    [cell setCollectionBlock:^(JYListTCell *selectCell) {
        
        if (_collectionBlock) {
            indexPath.section == 0 ? _collectionBlock(_todayRemind[indexPath.row]) : _collectionBlock(_notYetRemind[indexPath.row]);
        }
        
    }];
}


@end
