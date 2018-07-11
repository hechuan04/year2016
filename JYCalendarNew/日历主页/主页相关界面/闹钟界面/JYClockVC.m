//
//  JYClockVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYClockVC.h"
#import "ClockCell.h"
#import "JYAddClockVC.h"



static NSString *clockStr = @"clockStr";

@interface JYClockVC ()
{
 
    UITableView *_clockTb;
    NSArray     *_arrForClock;
    UIButton    *_editBtn;

}
@property (nonatomic ,strong)UIImageView *imgForNoClock;


@end

@implementation JYClockVC


- (void)loadNotification
{
 
     dispatch_async(dispatch_get_main_queue(), ^{
         
         [_clockTb reloadData];

     });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNotification) name:kNotificationRefreshUnreadRemindLabel object:@""];
    
    self.title = @"闹钟";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self actionForRightBtn];
    
    JYClockList *list = [JYClockList shareClockList];
    
    _arrForClock = [list selectAllModel];
    
    [self _creatTableView];
    
    [self _createEditBtn];
    
    CGFloat imgWidth = 310/750.0*kScreenWidth;
    CGFloat imgHeight = 310/1334.0*kScreenHeight;
    _imgForNoClock = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无闹钟"]];
    _imgForNoClock.frame = CGRectMake(kScreenWidth/2.0 - imgWidth/2.0, 240/1334.0*kScreenHeight, imgWidth, imgHeight);
    [self.view addSubview:_imgForNoClock];
    
    if (_arrForClock.count == 0) {
        
        _imgForNoClock.hidden = NO;
        
    }else{
        
        _imgForNoClock.hidden = YES;
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:[UIApplication sharedApplication]];
}
- (void)applicationWillEnterForeground
{
    JYClockList *list = [JYClockList shareClockList];
    _arrForClock = [list selectAllModel];
    [_clockTb reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
 
    [super viewWillAppear:animated];
    
    //NSLog(@"%@",_editBtn);
    
    _editBtn.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
 
    [super viewWillDisappear:animated];
    
    
    //NSLog(@"%@",_editBtn);

    _editBtn.hidden = YES;
        
    
}

//编辑方法
- (void)_editAction:(UIButton *)sender
{
 
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        
        [_clockTb setEditing:YES animated:YES];
        
    }else{
     
        [_clockTb setEditing:NO animated:YES];
    }
    
}

//创建编辑按钮
- (void)_createEditBtn
{
    //编辑按钮
    CGFloat xForEditBtn = 0;
    CGFloat yForEditBtn = 0;
    CGFloat widthForEditBtn = 0;
    CGFloat heightForEditBtn = 0;
    
    
     UIFont *editFont = nil;
    
    if (IS_IPHONE_4_SCREEN) {
        
        xForEditBtn = 220;
        yForEditBtn = 26;
        widthForEditBtn = 50;
        heightForEditBtn = 30;
        
        
        editFont = [UIFont systemFontOfSize:18];
        
    }else if(IS_IPHONE_5_SCREEN){
        
        xForEditBtn = 230;
        yForEditBtn = 26;
        widthForEditBtn = 50;
        heightForEditBtn = 30;
    
        
        editFont = [UIFont systemFontOfSize:18];
        
    }else if(IS_IPHONE_6_SCREEN){
        
        xForEditBtn = 280;
        yForEditBtn = 26;
        widthForEditBtn = 50;
        heightForEditBtn = 30;

        editFont = [UIFont systemFontOfSize:18];
        
        
    }else if(IS_IPHONE_6P_SCREEN){
        
        xForEditBtn = 310;
        yForEditBtn = 26;
        widthForEditBtn = 50;
        heightForEditBtn = 30;
    
        
    }
    
 /*
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(xForEditBtn, yForEditBtn , widthForEditBtn, heightForEditBtn)];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"取消" forState:UIControlStateSelected];
    [_editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(_editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.view addSubview:_editBtn];
 */
    
}

- (void)addAction:(UIButton *)sender
{
    
    ClockModel *model = [[ClockModel alloc] init];
    
    model.timeDescribe = @"永不";
    
    model.textStr = @"标签";
    
    model.musicID = 1;
    
    model.week = @"";
    
    model.hour = [[Tool actionforNowHour] intValue];
    
    model.minute = [[Tool actionforNowMinute] intValue];
    
    model.isOn = 1;
    
    JYAddClockVC *vc = [[JYAddClockVC alloc] init];
    
    vc.model = model;
    
    __block UITableView *tb = _clockTb;
    [vc setReloadAction:^{
        
        JYClockList *list = [JYClockList shareClockList];

        _arrForClock = [list selectAllModel];
        
        if (_arrForClock.count == 0) {
            
            _imgForNoClock.hidden = NO;
            
        }else{
            
            _imgForNoClock.hidden = YES;
            
        }
        
        [tb reloadData];
        
    }];
    
    _editBtn.selected = NO;
    [_clockTb setEditing:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)_creatTableView
{
    
    _clockTb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66)];
    _clockTb.delegate = self;
    _clockTb.dataSource = self;
    [self.view addSubview:_clockTb];
    
    //注册单元格
    [_clockTb registerNib:[UINib nibWithNibName:@"ClockCell" bundle:nil] forCellReuseIdentifier:clockStr];
    
    [Tool actionForHiddenMuchTable:_clockTb];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ClockModel *model = _arrForClock[indexPath.row];
    
    JYAddClockVC *vc = [[JYAddClockVC alloc] init];
   
    model.upData = YES;
    vc.model = model;
    
    
    __block UITableView *tb = _clockTb;
    [vc setReloadAction:^{
        
        JYClockList *list = [JYClockList shareClockList];
        
        _arrForClock = [list selectAllModel];
        
        if (_arrForClock.count == 0) {
            
            _imgForNoClock.hidden = NO;
            
        }else{
            
            _imgForNoClock.hidden = YES;
            
        }
        
        [tb reloadData];
        
    }];
    
    _editBtn.selected = NO;
    [tableView setEditing:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    ClockModel *model = _arrForClock[indexPath.row];
    
    JYClockList *clockList = [JYClockList shareClockList];
    
    [clockList deleteClockWithModel:model];

    JYClockList *list = [JYClockList shareClockList];
    
    _arrForClock = [list selectAllModel];
    
    if (_arrForClock.count == 0) {
        
        _imgForNoClock.hidden = NO;
        
    }else{
        
        _imgForNoClock.hidden = YES;
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationForLoadData object:@""];
    [_clockTb reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return YES;
}

//行高
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 93.0;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _arrForClock.count;
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClockCell *cell = [tableView dequeueReusableCellWithIdentifier:clockStr];
    
//    if (!cell) {
//        
//        cell = [[ClockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:clockStr];
//        
//    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmm";
//    NSString *nowDate = [formatter stringFromDate:today];

    
    ClockModel *model = _arrForClock[indexPath.row];
    NSString *hour = [Tool actionForTenOrSingleWithNumber:model.hour];
    NSString *minute = [Tool actionForTenOrSingleWithNumber:model.minute];
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@",hour,minute];
    cell.time.text = timeStr;
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",model.textStr];
    if (model.isOn == 1) {
        [cell.switchBtn setOn:YES animated:NO];
//        cell.switchBtn.on = YES;
        cell.timeLabel.textColor = [UIColor blackColor];
        cell.time.textColor = [UIColor blackColor];
        
        NSString *selectDateStr = [NSString stringWithFormat:@"%d-%d-%d %d:%d",model.year,model.month,model.day,model.hour,model.minute];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSDate *selectDate = [df dateFromString:selectDateStr];
        
        NSComparisonResult result = [today compare:selectDate];
        if(result==NSOrderedDescending){
            if(!model.week||[model.week isEqualToString:@""]){
                cell.timeLabel.textColor = nameTextColor;
                cell.time.textColor = nameTextColor;
                cell.switchBtn.on = NO;
            }
        }
        
    }else{
        [cell.switchBtn setOn:NO animated:NO];
//        cell.switchBtn.on = NO;
        cell.timeLabel.textColor = nameTextColor;
        cell.time.textColor = nameTextColor;
    }
    
    
    
//    __block UITableView *tb = _clockTb;
    //删除或添加提醒
    [cell setPassModel:^(ClockCell *selectCell ,BOOL isOn) {
        
        JYClockList *manager = [JYClockList shareClockList];
        if (isOn) {
            ClockModel *model = [_arrForClock objectAtIndex:indexPath.row];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
            NSDateComponents *components = [calendar components:unitFlags fromDate:[NSDate date]];
            model.year = (int)components.year;
            model.month = (int)components.month;
            
            int day = (int)components.day;
            //设置非重复提醒，时间早于现在时，将其转换为明日的提醒
            if((!model.week||[model.week isEqualToString:@""])&&[Tool compTime:model.hour other:model.minute]){
                day++;
            }
            model.day = day;
            model.isOn = 1;
            [manager upDataWithClockModel:model];
//            NSArray *arrForMusic = @[@"幻觉-长.mp3",@"科技-长.mp3",@"蓝调-长.mp3",@"女声-长.mp3",@"月光-长.mp3",@"别动-长.mp3",@"喂哎-长.mp3"];
            NSArray *arrForMusic = @[@"科技-长.mp3",@"月光-长.mp3",@"电动-长.mp3",@"古筝-长.mp3",@"铃铛-长.mp3",@"小号-长.mp3",@"洋琴-长.mp3"];
//            [JYRemindManager addNotificationWithClockModel:model withMusicArr:arrForMusic];
            if(kSystemVersion>=10){
                [JYRemindManager addAlarmNotificationsForiOS10WithClockModel:model];
            }else{
                [JYRemindManager addNotificationWithClockModel:model withMusicArr:arrForMusic];
            }
            
//            int hour = [[Tool actionforNowHour] intValue];
//            int minute = [[Tool actionforNowMinute] intValue];
            
//            NSString *nowDate = [NSString stringWithFormat:@"%02d%02d",hour,minute];
//            NSString *selectDate = [NSString stringWithFormat:@"%02d%02d",model.hour,model.minute];
            
//             NSString *selectDate = [NSString stringWithFormat:@"%d%02d%02d%02d%02d",model.year,model.month,model.day,model.hour,model.minute];
            
//            if ([nowDate integerValue] >= [selectDate integerValue]) {
//                
//                selectCell.timeLabel.textColor = nameTextColor;
//                selectCell.time.textColor = nameTextColor;
//                
//            }else{
                selectCell.timeLabel.textColor = [UIColor blackColor];
                selectCell.time.textColor = [UIColor blackColor];
//            }
            
        }else{
         
//            NSIndexPath *indexPath = [tb indexPathForCell:selectCell];
            
            ClockModel *model = [_arrForClock objectAtIndex:indexPath.row];
            model.isOn = 0;
            [manager upDataWithClockModel:model];

//            [JYRemindManager deleteLocalNotificationForClock:model];
            
            if(kSystemVersion>=10){
                [JYRemindManager removeAlarmNotificationWithModel:model];
            }else{
                [JYRemindManager deleteLocalNotificationForClock:model];
            }
        }
        
    }];
    
    return cell;
    
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
