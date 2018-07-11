//
//  JYAddClockVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYAddClockVC.h"
#import "JYClockPickerView.h"
#import "SetCell.h"
#import "JYLabelVC.h"
#import "JYMusicViewController.h"
#import "JYRecurVC.h"

static NSString *clockIdentifier = @"clockIdentifier";

@interface JYAddClockVC ()
{
    JYClockPickerView *_pickerView;
    UITableView       *_clockTb;
    NSArray           *_titleArr;
    UIButton          *_deleteBtn;
    
    int               _hour;
    int               _minute;
    int               _music_id;
    int               _isOn;
    NSString          *_weekStr;
    NSString          *_timeDescribe;
    NSString          *_labelText;
    
}
@end

@implementation JYAddClockVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _hour = _model.hour;
    _minute = _model.minute;
    _music_id = _model.musicID;
    _isOn = _model.isOn;
    _labelText = _model.textStr;
    _weekStr = _model.week;
    _timeDescribe = _model.timeDescribe;
    self.title = @"添加闹钟";
    self.view.backgroundColor = bgColor;
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(_saveRemind:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"保存" forState:UIControlStateNormal];
    [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    [self.navigationItem setRightBarButtonItem:right];
    
    self.navigationItem.rightBarButtonItem = right;
    
    _titleArr = @[@"重复",@"标签",@"铃声"];
    
    [self _createPickerView];
    
    [self _creatTableView];
   
    //只有更新才刷新列表
    if (_model.upData) {
        
        [self _createDeleteBtn];

    }
    
    
}

- (void)_saveRemind:(UIButton *)sender
{
    //NSLog(@"%@",_model);
  
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
    _model.year = (int)components.year;
    _model.month = (int)components.month;
    
    int day = (int)components.day;
    //设置非重复提醒，时间早于现在时，将其转换为明日的提醒
    if((!_model.week||[_model.week isEqualToString:@""])&&[Tool compTime:_model.hour other:_model.minute]){
        day++;
    }
    _model.day = day;
    
    JYClockList *clockManager = [JYClockList shareClockList];

//    NSArray *arrForMusic = @[@"幻觉-长.mp3",@"科技-长.mp3",@"蓝调-长.mp3",@"女声-长.mp3",@"月光-长.mp3",@"别动-长.mp3",@"喂哎-长.mp3"];
    NSArray *arrForMusic = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3"];
    if (_model.upData) {
        
        //删除之前的
        if(kSystemVersion>=10){
            [JYRemindManager removeAlarmNotificationWithModel:_model];
        }else{
            [JYRemindManager deleteLocalNotificationForClock:_model];
        }
        
        [self _actionForIdentifier];

//        [JYRemindManager addNotificationWithClockModel:_model];
        if(kSystemVersion>=10){
            [JYRemindManager addAlarmNotificationsForiOS10WithClockModel:_model];
        }else{
            [JYRemindManager addNotificationWithClockModel:_model withMusicArr:arrForMusic];
        }
        [clockManager upDataWithClockModel:_model];

    }else{
     
        [self _actionForIdentifier];

//        [JYRemindManager addNotificationWithClockModel:_model];
       if(kSystemVersion>=10){
           [JYRemindManager addAlarmNotificationsForiOS10WithClockModel:_model];
       }else{
           [JYRemindManager addNotificationWithClockModel:_model withMusicArr:arrForMusic];
       }
        [clockManager insertClockWithClockModel:_model];

    }
    

    _reloadAction();
    
    [self.navigationController popViewControllerAnimated:YES];

    
}

//通知唯一标示符
- (void)_actionForIdentifier
{
 
    int year = [[Tool actionForNowYear:nil] intValue];
    int month = [[Tool actionForNowMonth:nil] intValue];
    int day = [[Tool actionForNowSingleDay:nil] intValue];
    int hour = [[Tool actionforNowHour] intValue];
    int minute = [[Tool actionforNowMinute] intValue];
    int second = [[Tool actionForNowSecond] intValue];
    
    NSString *yearS = [Tool actionForTenOrSingleWithNumber:year];
    NSString *monthS = [Tool actionForTenOrSingleWithNumber:month];
    NSString *dayS = [Tool actionForTenOrSingleWithNumber:day];
    NSString *hourS = [Tool actionForTenOrSingleWithNumber:hour];
    NSString *minuteS = [Tool actionForTenOrSingleWithNumber:minute];
    NSString *secondS = [Tool actionForTenOrSingleWithNumber:second];
    
    _model.timeOrder = [NSString stringWithFormat:@"%@%@%@%@%@%@",yearS,monthS,dayS,hourS,minuteS,secondS];

}

- (void)actionForLeft:(UIButton *)sender
{
    _model.hour = _hour;
    _model.minute = _minute ;
    _model.musicID = _music_id;
    _model.isOn =   _isOn;
    _model.textStr = _labelText ;
    _model.week = _weekStr;
    _model.timeDescribe = _timeDescribe;
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)_createPickerView
{
 
    _pickerView = [JYClockPickerView new];
    [self.view addSubview:_pickerView];
    
    _pickerView.backgroundColor = [UIColor whiteColor];
    
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(super.view.mas_top);
        make.left.equalTo(super.view.mas_left);
        make.right.equalTo(super.view.mas_right);
        
    }];
    
    [self hourAndMinute];
    
    [_pickerView selectRow:_model.hour   inComponent:1 animated:NO];
    [_pickerView selectRow:_model.minute inComponent:2 animated:NO];
  
}

- (void)_creatTableView
{
    
    _clockTb = [UITableView new];
    _clockTb.delegate = self;
    _clockTb.dataSource = self;
    [self.view addSubview:_clockTb];
    
    [_clockTb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_pickerView.mas_bottom).offset(40.f);
        make.left.equalTo(super.view.mas_left);
        make.right.equalTo(super.view.mas_right);
        make.height.mas_equalTo(44 * 3.0);
        
    }];
    
    //注册单元格
    [_clockTb registerNib:[UINib nibWithNibName:@"SetCell" bundle:nil] forCellReuseIdentifier:clockIdentifier];
    
    [Tool actionForHiddenMuchTable:_clockTb];
    
}

- (void)_createDeleteBtn
{
 
    _deleteBtn = [UIButton new];
    [_deleteBtn addTarget:self action:@selector(_deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deleteBtn];
    
    UILabel *label = [UILabel new];
    label.text = @"删除闹钟";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    [_deleteBtn addSubview:label];
    
    
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_clockTb.mas_bottom).offset(40.f);
        make.left.equalTo(_clockTb.mas_left);
        make.right.equalTo(_clockTb.mas_right);
        make.height.mas_equalTo(44.f);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_deleteBtn.mas_top);
        make.right.equalTo(_deleteBtn.mas_right);
        make.left.equalTo(_deleteBtn.mas_left);
        make.bottom.equalTo(_deleteBtn.mas_bottom);
        
    }];
    
    
}

- (void)_deleteAction:(UIButton *)sender
{
 
    JYClockList *clockList = [JYClockList shareClockList];
    
    [clockList deleteClockWithModel:_model];
    
//    [JYRemindManager deleteLocalNotificationForClock:_model];
    if(kSystemVersion>=10){
        [JYRemindManager removeAlarmNotificationWithModel:_model];
    }else{
        [JYRemindManager deleteLocalNotificationForClock:_model];
    }
    _reloadAction();
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3.0;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:clockIdentifier];
    
    if (!cell) {
        
        cell = [[SetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clockIdentifier];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setSwitchAction:^(int isOn) {
        
        _model.isOn = isOn;
        
    }];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell1 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetCell *cell = (SetCell *)cell1;
 
    cell.switchBtn.hidden = YES;
    cell.arrowHead.hidden = YES;
    cell.content.textColor = [UIColor blackColor];
    
    if (indexPath.row == 0) {
        
        cell.content.text = _model.timeDescribe;
        
    }else if(indexPath.row == 1){
     
        cell.content.text = _model.textStr;
        
    }else if(indexPath.row == 2){
     
        cell.content.text = [self _musicArr:_model.musicID];
    }
    

    cell.title.text = _titleArr[indexPath.row];
    
}

- (NSString *)_musicArr:(int )musicId
{
 
//    NSArray *musicArr = @[@"幻觉",@"科技",@"蓝调",@"女声",@"月光",@"别动",@"喂哎"];
    NSArray *musicArr = @[@"科技",@"月光",@"电动",@"古筝",@"铃铛",@"小号",@"洋琴"];
    if (musicId == 0) {
        
        musicId = 1;
    }
    
    return musicArr[musicId - 1];
    
}

- (void)hourAndMinute
{
 
    __block ClockModel *model = _model;
    [_pickerView setHourAction:^(int hour) {
        
        //NSLog(@"小时:%d",hour);
        model.hour = hour;
        
    }];
    
    [_pickerView setMinuteAction:^(int minute) {
        
        //NSLog(@"分钟:%d",minute);
        model.minute = minute;
        
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.row == 0) {
        
        JYRecurVC *recurVC = [[JYRecurVC alloc] init];
        
        recurVC.model = _model;
        
        __block JYAddClockVC *addVc = self;
        __block UITableView *clockTB = _clockTb;
        [recurVC setActionForWeek:^(ClockModel *model) {
            
            addVc.model = model;
            
            [clockTB reloadData];
            
        }];
        
        [self.navigationController pushViewController:recurVC animated:YES];
        
    }else if(indexPath.row == 1){
    
        JYLabelVC *labelVc = [[JYLabelVC alloc] init];
        labelVc.model = _model;
        
        __block JYAddClockVC *addVc = self;
        __block UITableView *clockTB = _clockTb;
        [labelVc setPassModel:^(ClockModel *model) {
            
            addVc.model = model;
            
            [clockTB reloadData];
            
        }];
        
        [self.navigationController pushViewController:labelVc animated:YES];
        
        
    }else if(indexPath.row == 2){
     
        JYMusicViewController *musicVC = [[JYMusicViewController alloc] init];
        musicVC.isClock = YES;
        RemindModel *model = [[RemindModel alloc] init];
        
        if (_model.musicID != 0) {
            
            model.musicName = _model.musicID;

        }else{
         
            model.musicName = 1;
        }
        
        musicVC.model = model;
        
        __block JYAddClockVC *addVc = self;
        __block UITableView *clockTB = _clockTb;
        [musicVC setActionForMusicName:^(int musicID) {
            
            addVc.model.musicID = musicID;
            [clockTB reloadData];
        }];
        
        [self.navigationController pushViewController:musicVC animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
