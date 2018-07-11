//
//  JYRepeatViewController.m
//  JYCalendar
//
//  Created by 吴冬 on 15/11/1.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import "JYRepeatViewController.h"
#import "TimeTableViewCell.h"
#import "RandomPickerView.h"

@interface JYRepeatViewController ()
{
   
    NSArray *_arrForWeek;
    RandomPickerView *_randomPicker;
    UIView           *_viewForBtn;
    CGFloat _widthForBtn;
    UIButton *_btnForSender;  //只为week的名字
    NSArray *_arrForAllBtn;
    
    BOOL _isHidden;
    BOOL _isEditing;
}
@end

static NSString *strForTime = @"strForTime";


@implementation JYRepeatViewController

- (void)actionForLeft:(UIButton *)sender
{
    
    
    //将之前绑定的cell置为Nil
    _manager.cell = nil;
    
    // 防止没有做任何修改，就点击完成按钮
    if (_isEditing) {
        _repeatAction(_model);
        
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

//- (void)saveAction:(UIButton *)sender
//{
//    
//    // 防止没有做任何修改，就点击完成按钮
//    if (_isEditing) {
//        _repeatAction(_model);
//        _manager.cell = nil;
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//
//    }
//   
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
//    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnView addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
//    btnView.frame = CGRectMake(0, 0, 50, 50);
//    [btnView setTitle:@"保存" forState:UIControlStateNormal];
    
//    JYSkinManager * manager = [JYSkinManager shareSkinManager];
//    [btnView setTitleColor:manager.colorForDateBg forState:UIControlStateNormal];
//    
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
//    self.navigationItem.rightBarButtonItem = right;
    
    _manager = [JYSelectManager shareSelectManager];
    
    UIButton *btnForLeft = [Tool actionForReturnLeftBtnWithTarget:self];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btnForLeft];
    
    self.navigationItem.leftBarButtonItem = item;
    
    _arrForWeek = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    
    //创建tableView
    [self _creatTableView];
    
    [self createBtn];
    
    _isEditing = NO;
    self.weekArray = [[NSMutableArray alloc]initWithCapacity:5];
    
    // 如果选择了 不规则 重复提醒日期
    if (self.model.randomType == selectSomeDays) {
        
        // 判断是否有重复周期
        if (![self.model.weekStr isEqualToString:@""] && ![self.model.weekStr isEqualToString:@"<null>"] && ![self.model.weekStr isKindOfClass:[NSNull class]] && ![self.model.weekStr isEqualToString:@"(null)"] && self.model.weekStr != nil) {
            
            NSArray * tmpArr = [self.model.weekStr componentsSeparatedByString:@","];
            [self.weekArray addObjectsFromArray:tmpArr];
            
        }
        
    }else if ((_model.randomType >= 1) && (_model.randomType <= 7)){
        
        // 选择 某周几 重复提醒
        [self.weekArray removeAllObjects];
        
        // 用户第一次进来此页面某一个星期几呈现选中状态，这时要进行记录，多选
        [self.weekArray addObject:[NSString stringWithFormat:@"%d",_model.randomType]];
        _model.randomType = selectSomeDays;
        
    }else if (_model.randomType == 8){
        
        // 选择 每天 重复提醒
        [self.weekArray removeAllObjects];
        for (int i = 0; i < 7; i ++) {
            [self.weekArray addObject:[NSString stringWithFormat:@"%d",i + 1]];                
        }
        
    }
    
    NSLog(@"当前选择的日期%@",self.weekArray);


   
}

//************************datePicker*************************//


- (void)createHidden:(BOOL )hidden
{
    
    if (hidden) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _viewForBtn.origin = CGPointMake(0, 0);
            
        }];
        
//        _model.randomType = selectDay;
//        _model.countNumber = 2;
        
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _viewForBtn.origin = CGPointMake(0, kScreenHeight);
            
        }];
        _model.countNumber = (int )_randomPicker.selectedRow;
        _model.randomType = (int )_randomPicker.countForRow;

        [_timeTableView reloadData];
        
        _model.strForRepeat = [NSString stringWithFormat:@"每%d%@",_model.countNumber,[self strForType:(int)(_btnForSender.tag)]];
        
        //[self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

#pragma mark 确定按钮，返回给remind页面model
- (void)corfimAction
{
    _isHidden = !_isHidden;
    
    [self createHidden:_isHidden];

}

- (void)actionForHiddenRandom
{
 
    _isHidden = !_isHidden;
   
    [UIView animateWithDuration:0.3 animations:^{
        
        _viewForBtn.origin = CGPointMake(0, kScreenHeight);
        
    }];
}

#pragma mark 选择自定义的方法时候获得的数据
- (void)createBtn
{
    _viewForBtn = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _viewForBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.navigationController.view addSubview:_viewForBtn];

    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 200)];
    [btn addTarget:self action:@selector(actionForHiddenRandom) forControlEvents:UIControlEventTouchUpInside];
    [_viewForBtn addSubview:btn];
    
    _randomPicker = [[RandomPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 200 - 25, kScreenWidth, 200)];
    _randomPicker.backgroundColor = [UIColor whiteColor];
    _randomPicker.countForRow = 11;
    [_viewForBtn addSubview:_randomPicker];
    
//*********************选择的时候获得的数据***********************************//
    __block RandomPickerView *random = _randomPicker;
    __block RemindModel *model = _model;
    [_randomPicker setActionForRow:^(NSInteger row) {
        
        model.countNumber = (int )row;
        model.randomType = (int )random.countForRow;
        
    }];
    
    
    // picker上方确定 取消按钮 横条
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 200 - 50, kScreenWidth, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_viewForBtn addSubview:bgView];
    
    UIButton *btnForCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnForCancel.frame = CGRectMake(20, 10, 100, 40);
    [btnForCancel setTitle:@"取消" forState:UIControlStateNormal];
    btnForCancel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnForCancel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnForCancel.backgroundColor = [UIColor whiteColor];
    [btnForCancel addTarget:self action:@selector(actionForHiddenRandom) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnForCancel];
    
    UIButton *btnForConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnForConfirm.frame = CGRectMake(kScreenWidth-20-100, 10, 100, 40);
    [btnForConfirm setTitle:@"确认" forState:UIControlStateNormal];
    btnForConfirm.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnForConfirm setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnForConfirm.backgroundColor = [UIColor whiteColor];
    [btnForConfirm addTarget:self action:@selector(corfimAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btnForConfirm];
 
    
    
    _widthForBtn = kScreenWidth / 4.0;
    
    _btnForDay = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnForDay.frame = CGRectMake(0,kScreenHeight - 40, _widthForBtn, 40);
    [_btnForDay addTarget:self action:@selector(actionForChangeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_btnForDay setTitle:@"日" forState:UIControlStateNormal];
    [_btnForDay setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _btnForDay.tag = selectDay;
    _btnForDay.backgroundColor = [UIColor whiteColor];
    [_viewForBtn addSubview:_btnForDay];
    
    _btnForWeek = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnForWeek.frame = CGRectMake(_widthForBtn, kScreenHeight - 40 , _widthForBtn, 40);
    [_btnForWeek addTarget:self action:@selector(actionForChangeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_btnForWeek setTitle:@"周" forState:UIControlStateNormal];
    [_btnForWeek setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnForWeek.tag = selectWeek;
    _btnForWeek.backgroundColor = [UIColor grayColor];
    [_viewForBtn addSubview:_btnForWeek];
    
    _btnForMonth = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnForMonth.frame = CGRectMake(_widthForBtn * 2, kScreenHeight - 40 , _widthForBtn, 40);
    [_btnForMonth addTarget:self action:@selector(actionForChangeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_btnForMonth setTitle:@"月" forState:UIControlStateNormal];
    [_btnForMonth setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnForMonth.tag = selectMonth;
    _btnForMonth.backgroundColor = [UIColor grayColor];
    [_viewForBtn addSubview:_btnForMonth];
    
    _btnForYear = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnForYear.frame = CGRectMake(_widthForBtn * 3, kScreenHeight - 40 , _widthForBtn, 40);
    [_btnForYear addTarget:self action:@selector(actionForChangeSelect:) forControlEvents:UIControlEventTouchUpInside];
    [_btnForYear setTitle:@"年" forState:UIControlStateNormal];
    [_btnForYear setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _btnForYear.tag = selectYear;
    _btnForYear.backgroundColor = [UIColor grayColor];
    [_viewForBtn addSubview:_btnForYear];
    
    _arrForAllBtn = @[_btnForDay,_btnForWeek,_btnForMonth,_btnForYear];
    
}

- (void)actionForChangeBg:(UIButton *)sender
{
    
    for (int i = 0; i < _arrForAllBtn.count ;i ++ ) {
        
        //指针指向那个数值
        UIButton *btn = _arrForAllBtn[i];
        
        if (btn.tag == sender.tag) {
            
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
        }else{
            
            btn.backgroundColor = [UIColor grayColor ];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    
}

#pragma mark 自定义选择type类型
- (void)actionForChangeSelect:(UIButton *)sender
{
    
    _btnForSender = sender;
    
    [self actionForChangeBg:sender];
    
    if (sender.tag == selectDay) {
        
        _randomPicker.labelForSelect.text = @"日";
        _randomPicker.countForRow = selectDay;
        
        [_randomPicker selectRow:99 * 5 inComponent:0 animated:NO];
        
        
    }else if(sender.tag == selectWeek){
        
        _randomPicker.labelForSelect.text = @"周";
        _randomPicker.countForRow = selectWeek;
        [_randomPicker selectRow:11 * 5 inComponent:0 animated:NO];
        
        
    }else if(sender.tag == selectMonth){
        
        _randomPicker.labelForSelect.text = @"月";
        _randomPicker.countForRow = selectMonth;
        [_randomPicker selectRow:47 * 5 inComponent:0 animated:NO];
        
        
    }else if(sender.tag == selectYear){
        
        _randomPicker.labelForSelect.text = @"年";
        _randomPicker.countForRow = selectYear;
        [_randomPicker selectRow:5 * 5 inComponent:0 animated:NO];
        
        
    }
    
    [_randomPicker numberOfRowsInComponent:0];
    [_randomPicker reloadAllComponents];
    
    _model.randomType = (int)sender.tag;
    _randomPicker.selectedRow = 2;
}

//********************************************************************//

#pragma mark 创建tb
- (void)_creatTableView
{
    
    _timeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, kScreenHeight - 66) style:UITableViewStylePlain];
    _timeTableView.delegate = self;
    _timeTableView.dataSource = self;
    [self.view addSubview:_timeTableView];
    
    UIView *viewForBg = [UIView new];
    viewForBg.backgroundColor = [UIColor clearColor];
    [_timeTableView setTableFooterView:viewForBg];
    
    [_timeTableView registerNib:[UINib nibWithNibName:@"TimeTableViewCell" bundle:nil] forCellReuseIdentifier:strForTime];
    
}


- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0.5;
        
    }else{
        
        return 15;
        
    }
   
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    if (section == 0) {
        
        
        UIView *viewForLine = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
        viewForLine.backgroundColor = lineColor;
        
        return viewForLine;
        
    }else{
     
        UIView *viewForHead = [[UIView alloc] initWithFrame:CGRectMake(-1, 0, kScreenWidth + 2, 20)];
        viewForHead.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1];
        viewForHead.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
        viewForHead.layer.borderWidth = 0.5;
        viewForHead.alpha = 0.5;
        
        return viewForHead;
    }
    


}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    return 44;
}

//组数
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
  
    return 5;

}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return _arrForWeek.count;
        
    }else{
    
        return 1;
        
    }

}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strForTime];
    
    if (!cell) {
        
        cell = [[TimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strForTime];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.timeLabel.textColor = [UIColor blackColor];
    [self isSelectImage:NO timeCell:cell];
    
    if (indexPath.section == 0) {
        
        if (_model.randomType == selectEveryDay) {
            
            [self isSelectImage:YES timeCell:cell];
            
            
        }else if((_model.randomType >= 1) && (_model.randomType <= 7)){
                        
            NSInteger isImage = [self actionForImage];
            
            if (isImage == indexPath.row) {
                
                [self isSelectImage:YES timeCell:cell];
                cell.timeLabel.textColor = [UIColor redColor];
                
            }else{
                
                [self isSelectImage:NO timeCell:cell];
                cell.timeLabel.textColor = [UIColor blackColor];
                
            }
            
        }else if(_model.randomType == selectSomeDays){
            
            if (self.weekArray.count != 0) {
                
                BOOL isExist = NO;

                for (int i = 0; i < self.weekArray.count; i ++) {
                    
                    NSInteger index = [self.weekArray[i] integerValue] - 1;
                    
                    if (indexPath.row == index) {
                        
                        isExist = YES;
                        break;
                        
                    }else{
                        
                        isExist = NO;
                        
                    }
                    
                }
                
                if (isExist) {
                    
                    [self isSelectImage:YES timeCell:cell];
                    cell.timeLabel.textColor = [UIColor redColor];
                    
                }else{
                    
                    [self isSelectImage:NO timeCell:cell];
                    cell.timeLabel.textColor = [UIColor blackColor];
                    
                }
            }
                        
            
            
        }else{
            
            [self isSelectImage:NO timeCell:cell];
            cell.timeLabel.textColor = [UIColor blackColor];

        }
        
        cell.timeLabel.text = _arrForWeek[indexPath.row];
        
    }else if(indexPath.section == 1){
    
       cell.timeLabel.text = @"每天";
        if (_model.randomType == selectEveryDay) {
            
            [self isSelectImage:YES timeCell:cell];
            cell.timeLabel.textColor = [UIColor redColor];
            
        }else{
        
            [self isSelectImage:NO timeCell:cell];
            cell.timeLabel.textColor = [UIColor blackColor];

        }
    
    }else if(indexPath.section == 2){
    
        cell.timeLabel.text = @"每月";
        if (_model.randomType == selectEveryMonth) {
        
            [self isSelectImage:YES timeCell:cell];
            cell.timeLabel.textColor = [UIColor redColor];

        }else {
        
            [self isSelectImage:NO timeCell:cell];
            cell.timeLabel.textColor = [UIColor blackColor];

        }

    }else if(indexPath.section == 3){
    
       cell.timeLabel.text = @"每年";
        if (_model.randomType == selectEveryYear) {
            
            [self isSelectImage:YES timeCell:cell];
            cell.timeLabel.textColor = [UIColor redColor];


        }else{
        
            [self isSelectImage:NO timeCell:cell];
            cell.timeLabel.textColor = [UIColor blackColor];


        }
        
    }else if(indexPath.section == 4){
    
        if (_model.randomType == selectDay) {
            
            [self actionForCellText:cell str:@"日"];
            [self isSelectImage:YES timeCell:cell];
            cell.timeLabel.textColor = [UIColor redColor];


        }else if(_model.randomType == selectMonth){
           
            [self actionForCellText:cell str:@"月"];
            [self isSelectImage:YES timeCell:cell];
            cell.timeLabel.textColor = [UIColor redColor];


        }else if(_model.randomType == selectWeek){
        
            [self actionForCellText:cell str:@"周"];
            [self isSelectImage:YES timeCell:cell];
            cell.timeLabel.textColor = [UIColor redColor];


        }else if(_model.randomType == selectYear){
        
            [self actionForCellText:cell str:@"年"];
            [self isSelectImage:YES timeCell:cell];
            cell.timeLabel.textColor = [UIColor redColor];


        }else{
        
            cell.timeLabel.text = @"自定义";
            
        }
        
    }
    
    return cell;
    
}

- (NSString *)strForType:(int )type
{
   
    if (type == selectWeek) {
        
        return @"周";
        
    }else if(type == selectDay){
    
    
        return @"日";
        
    }else if(type == selectMonth){
    
    
        return @"月";
        
    }else if(type == selectYear){
     
        return @"年";
        
    }else{
        return @"日";
    }

}

- (void)actionForCellText:(TimeTableViewCell *)cell str:(NSString *)str
{
  
        cell.timeLabel.text = [NSString stringWithFormat:@"每%d%@",_model.countNumber,str];

}

- (NSString *)actionForReturnWeek:(NSInteger )day
{
    
    NSArray *arr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    NSString *week = nil;
    for (int i = 0; i < 7; i++) {
        
        if (day == i + 1) {
            
            week = arr[i];
            
        }
    }

    return week;
}

#pragma mark 在这里更改randomType
//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _isEditing = YES;
    
//    TimeTableViewCell *nowCell = (TimeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//    
//    if ([(TimeTableViewCell *)_manager.cell isEqual:nowCell]) {
//        
//        _model.randomType = 0;
//        [self.timeTableView reloadData];
//        
//        _manager.cell = nil;
//        return;
//
//    }else{
//     
//        _manager.cell = nowCell;
//    }
   
    if (indexPath.section == 0) {
        

        self.weekString = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        
            
        // 判断是否选择过该日期 如果存在 再点击就删除；否则就添加
        BOOL isExist = NO;
        
        NSMutableArray * tmpArray1 = [NSMutableArray array];
        
        for (int i = 0; i < self.weekArray.count; i ++) {
            
            if (indexPath.row + 1 == [self.weekArray[i] integerValue]) {
                [tmpArray1 addObject:self.weekArray[i]];
                isExist = YES;
                break;
                
            }
        }
        
        if (isExist) {
            
            [self.weekArray removeObject:[tmpArray1 firstObject]];

        }else{
            [self.weekArray addObject:self.weekString];


        }

                        
        // 给数组重新排序 由小到大      
        NSComparator cmptr = ^(id obj1, id obj2){
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        };
        // 排序完成之后用逗号拼接String
        NSArray *array = [self.weekArray sortedArrayUsingComparator:cmptr];
        NSString * string = [array componentsJoinedByString:@","];
        
    
        // 拼接选择重复时间的上一个页面 显示的数据，
        NSMutableArray * tmpArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i ++) {
            NSString *week = [self actionForReturnWeek:[array[i] integerValue]];
            NSString *strForTime = [NSString stringWithFormat:@"每周%@",week];
            [tmpArray addObject:strForTime];
        }
        NSString * strForRepeat = [tmpArray componentsJoinedByString:@" "];
        if ([strForRepeat isEqualToString:@"每周一 每周二 每周三 每周四 每周五"]) {
            _model.strForRepeat = @"工作日";

        }else if ([strForRepeat isEqualToString:@"每周六 每周日"]){
            
            _model.strForRepeat = @"每周末";
            
        }else if (self.weekArray.count == 7){
            
            _model.strForRepeat = @"每天";

        }else{
            _model.strForRepeat = strForRepeat;

        }

        if (self.weekArray.count == 1) {
            
            switch ([self.weekArray.firstObject integerValue]) {
                case 1:
                    _model.randomType = selectMonday;
                    break;
                    
                case 2:
                    _model.randomType = selectTuesday;
                    break;
                case 3:
                    _model.randomType = selectWednesday;
                    break;
                case 4:
                    _model.randomType = selectThursday;
                    break;
                case 5:
                    _model.randomType = selectFriday;
                    break;
                case 6:
                    
                    _model.randomType = selectSaturday;
                    break;
                case 7:
                    
                    _model.randomType = selectSunday;
                    break;
                    
                default:
                    break;
            }
        }else if (self.weekArray.count == 7){
            
            _model.randomType = selectEveryDay;
            
        }else if (self.weekArray.count == 0){
            
            _model.randomType = 0;
            _model.strForRepeat = @"永不";
            
        } else{
            
            _model.randomType = selectSomeDays;

        }
        _model.weekStr = string;
        [self.timeTableView reloadData];
            
            
       
    
    }else if(indexPath.section == 1){
    
        //JYLog(@"每天");
        if (_model.randomType == selectEveryDay) {
            
            _model.randomType = 0;
            [self.weekArray removeAllObjects];
            [self.timeTableView reloadData];


        }else{
            _model.strForRepeat = @"每天";
            _model.randomType = selectEveryDay;
            [self.weekArray removeAllObjects];
            [self.timeTableView reloadData];

        }
        
    }else if(indexPath.section == 2){
        
        
        if (_model.randomType == selectEveryMonth) {
            
            _model.randomType = 0;
            [self.weekArray removeAllObjects];
            [self.timeTableView reloadData];

            
        }else{
            
            NSString *strForDay = [NSString stringWithFormat:@" 每月 %d号",_model.day];
            //JYLog(@"每月");
            _model.strForRepeat = strForDay;
            _model.randomType = selectEveryMonth;
            [self.weekArray removeAllObjects];
            [self.timeTableView reloadData];
        }
    
    }else if(indexPath.section == 3){
        
        
        if (_model.randomType == selectEveryYear) {
            
            _model.randomType = 0;
            [self.weekArray removeAllObjects];
            [self.timeTableView reloadData];

            
        }else{
            
            NSString *strForDay = [NSString stringWithFormat:@" 每年 %d月 %d号",_model.month,_model.day];
            //JYLog(@"每年");
            _model.strForRepeat = strForDay;
            _model.randomType = selectEveryYear;
            [self.weekArray removeAllObjects];
            [self.timeTableView reloadData];
        }      

    }else{
      

        [self corfimAction];
        
        //JYLog(@"自定义");
        //_repeatAction(@"自定义");
       // [self.navigationController popViewControllerAnimated:YES];

    }

}


- (void)isSelectImage:(BOOL )isSelect
             timeCell:(TimeTableViewCell *)cell
{
  
    if (isSelect) {
        
        cell.imageForCorfim.image = [UIImage imageNamed:@"重复选中.png"];
        
    }else{
    
        cell.imageForCorfim.image = [UIImage imageNamed:@"重复未选中"];
    }

}

- (NSInteger )actionForImage
{
 

    if (_model.randomType == 1) {
        
        return 0;
        
    }else if(_model.randomType == 2){
       
        return 1;
     
    }else if(_model.randomType == 3){
        
        return 2;

    }else if(_model.randomType == 4){
        
        return 3;

    }else if(_model.randomType == 5){
        
        return 4;

    }else if(_model.randomType == 6){
     
        return 5;
        
    }else if(_model.randomType == 7){
    
        return 6;
        
    }else{
     
        return 1000;
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
