//
//  YiJiDetailViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//



/*************************************************************
 *  特别注意！！！
 * “动土” 在后台数据库中为“動土”，接口参数，和返回数据需要单独对此字段处理。
 *  （客户端要求不能用“動土”要用“动土”）
 **************************************************************
 */
#import "YiJiDetailViewController.h"
#import "YiJiCalendarCell.h"
#import "JYCalendarModel.h"
#import "JYRemindViewController.h"

static NSString *kIdentifierForCalendarCell = @"kIdentifierForCalendarCell";
#define kFilterMenuHeight 50.f
#define kTableHeaderHeight 45.f

@interface YiJiDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UISegmentedControl *segmentControl;
@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *goodDays;
@property (nonatomic,strong) NSMutableArray *badDays;
@property (nonatomic,strong) NSMutableArray *filterGoodDays;
@property (nonatomic,strong) NSMutableArray *filterBadDays;
//@property (nonatomic,strong) UIImageView *emptyImageView;
@property (nonatomic,strong) UIView *filterMenu;
@property (nonatomic,assign) BOOL shouldFilter;

@property (nonatomic,strong) NSMutableDictionary *goodDaysDic;
@property (nonatomic,strong) NSMutableDictionary *badDaysDic;
@property (nonatomic,strong) NSMutableDictionary *filterGoodDaysDic;
@property (nonatomic,strong) NSMutableDictionary *filterBadDaysDic;

@property (nonatomic,assign) NSInteger goodCount;
@property (nonatomic,assign) NSInteger badCount;
@end

@implementation YiJiDetailViewController

#pragma mark - Life Cycle
- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate activities:(NSArray *)activities
{
    self = [super init];
    if(self){
        _startDate = startDate;
        _endDate = endDate;
        _activities = activities;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
    
    [self queryGoodBadDays];
}

#pragma mark - Public


#pragma mark - Private
- (void)setupSubviews
{
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.descLabel];
    [self.view addSubview:self.filterMenu];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.emptyImageView];
   
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15.f);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@120.f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentControl.mas_bottom).offset(20.f);
        make.height.equalTo(@30.f);
        make.centerX.equalTo(self.view);
    }];
    [self.filterMenu mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kFilterMenuHeight));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterMenu.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
//    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.equalTo(self.view);
//    }];
}
- (void)queryGoodBadDays
{
    __weak typeof(self) ws = self;
    NSString *str = [self.activities componentsJoinedByString:@","];
    [RequestManager queryGoodBadDaysWith:str from:self.startDate to:self.endDate completed:^(id data, NSError *error) {
        
        if(data){
            NSArray *yiArr = data[@"yi"];
            NSArray *jiArr = data[@"ji"];
            
            ws.goodCount = 0;
            ws.badCount = 0;
            //宜
            for(NSDictionary *dic in yiArr){
                NSArray *timeArr = [dic[@"time"] componentsSeparatedByString:@"-"];
                if([timeArr count]>=3){
                    JYCalendarModel *model = [[JYCalendarModel alloc]initWithYear:[timeArr[0] integerValue] month:[timeArr[1] integerValue] day:[timeArr[2] integerValue]];
                    
                    NSString *tag = dic[@"name"];
                    if(tag){
                        if(![ws.goodDaysDic objectForKey:tag]){
                            NSMutableArray *muArr = [NSMutableArray array];
                            [muArr addObject:model];
                            [ws.goodDaysDic setObject:muArr forKey:tag];
                        }else{
                            NSMutableArray *muArr = [ws.goodDaysDic objectForKey:tag];
                            [muArr addObject:model];
                        }
                    }
//                    [ws.goodDays addObject:model];
                    ws.goodCount ++;
                }
            }
            //忌
            for(NSDictionary *dic in jiArr){
                NSArray *timeArr = [dic[@"time"] componentsSeparatedByString:@"-"];
                if([timeArr count]>=3){
                    JYCalendarModel *model = [[JYCalendarModel alloc]initWithYear:[timeArr[0] integerValue] month:[timeArr[1] integerValue] day:[timeArr[2] integerValue]];
                    NSString *tag = dic[@"name"];
                    if(tag){
                        if(![ws.badDaysDic objectForKey:tag]){
                            NSMutableArray *muArr = [NSMutableArray array];
                            [muArr addObject:model];
                            [ws.badDaysDic setObject:muArr forKey:tag];
                        }else{
                            NSMutableArray *muArr = [ws.badDaysDic objectForKey:tag];
                            [muArr addObject:model];
                        }
                    }
//                    [ws.badDays addObject:model];
                    ws.badCount ++;
                }
            }
        }
        [ws.tableView reloadData];
        [ws calculateGoodDays];
    }];
}
- (void)calculateGoodDays
{

    NSString *count = [NSString stringWithFormat:@"%ld",self.goodCount];
    NSString *str = [self.activities componentsJoinedByString:@","];
    NSString *text = [NSString stringWithFormat:@"\"%@\"的吉日共有%@天",str,count];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[JYSkinManager shareSkinManager].colorForDateBg range:[text rangeOfString:count]];
    self.descLabel.attributedText = attStr;
    [self.tableView reloadData];
//    if(self.goodCount ==0){
////        self.emptyImageView.hidden = NO;
//        self.filterMenu.hidden = YES;
//    }else{
////        self.emptyImageView.hidden = YES;
//        self.filterMenu.hidden = NO;
//    }
}

- (void)calculateBadDays
{
    NSString *count = [NSString stringWithFormat:@"%ld",self.badCount];
    NSString *str = [self.activities componentsJoinedByString:@","];
    NSString *text = [NSString stringWithFormat:@"\"%@\"的忌日共有%@天",str,count];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[JYSkinManager shareSkinManager].colorForDateBg range:[text rangeOfString:count]];
    self.descLabel.attributedText = attStr;
    [self.tableView reloadData];
//    if(self.badCount==0){
////        self.emptyImageView.hidden = NO;
//        self.filterMenu.hidden = YES;
//    }else{
////        self.emptyImageView.hidden = YES;
//        self.filterMenu.hidden = NO;
//    }

}
- (void)segmentControlClicked:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:{
            [self calculateGoodDays];
        }
            break;
        case 1:{
            [self calculateBadDays];
        }
            break;
        default:
            break;
    }
}
- (void)filterData:(UISwitch *)sender
{
    self.shouldFilter = sender.isOn;
//    [self segmentControlClicked:self.segmentControl];
    
    [self.tableView reloadData];
    
}
#pragma mark - Protocol
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.activities count];
//    if(self.segmentControl.selectedSegmentIndex==0){
//        if(self.shouldFilter){
//            return [self.filterGoodDaysDic count];
//        }
//        return [self.goodDaysDic count];
//    }else{
//        if(self.shouldFilter){
//            return [self.filterBadDaysDic count];
//        }
//        return [self.badDaysDic count];
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *tag = self.activities[section];
    if([tag isEqualToString:@"动土"]){
        tag = @"動土";
    }
    NSArray *arr;
    if(self.segmentControl.selectedSegmentIndex==0){
        if(self.shouldFilter){
            arr = [self.filterGoodDaysDic objectForKey:tag];
        }else{
            arr = [self.goodDaysDic objectForKey:tag];
        }
    }else{
        if(self.shouldFilter){
            arr = [self.filterBadDaysDic objectForKey:tag];
        }else{
            arr = [self.badDaysDic objectForKey:tag];
        }
    }
    return [arr count];
    
    //    if(self.segmentControl.selectedSegmentIndex==0){
    //        if(self.shouldFilter){
    //            return [self.filterGoodDays count];
    //        }
    //        return [self.goodDays count];
    //    }else{
    //        if(self.shouldFilter){
    //            return [self.filterBadDays count];
    //        }
    //        return [self.badDays count];
    //    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  
    /*
     NSString *tag = self.activities[section];
    if([tag isEqualToString:@"动土"]){
        tag = @"動土";
    }
    NSArray *arr;
    if(self.segmentControl.selectedSegmentIndex==0){
        if(self.shouldFilter){
            arr = [self.filterGoodDaysDic objectForKey:tag];
        }else{
            arr = [self.goodDaysDic objectForKey:tag];
        }
    }else{
        if(self.shouldFilter){
            arr = [self.filterBadDaysDic objectForKey:tag];
        }else{
            arr = [self.badDaysDic objectForKey:tag];
        }
    }
    if([arr count]>0){
        return kTableHeaderHeight;
    }else{
        return CGFLOAT_MIN;
    }
    */
    return kTableHeaderHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *arr;
    CGFloat headerHeight = CGFLOAT_MIN;
    NSString *tag = self.activities[section];
    if([tag isEqualToString:@"动土"]){
        tag = @"動土";
    }
    if(self.segmentControl.selectedSegmentIndex==0){
        if(self.shouldFilter){
            arr = [self.filterGoodDaysDic objectForKey:tag];
        }else{
            arr = [self.goodDaysDic objectForKey:tag];
        }
    }else{
        if(self.shouldFilter){
            arr = [self.filterBadDaysDic objectForKey:tag];
        }else{
            arr = [self.badDaysDic objectForKey:tag];
        }
    }
    if([arr count]>0){
        headerHeight = kTableHeaderHeight;
    }
    UILabel *header = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, headerHeight)];
    NSString *typeStr = self.segmentControl.selectedSegmentIndex==0?@"吉日":@"忌日";
    NSString *countStr = [NSString stringWithFormat:@"%ld",[arr count]];
    NSString *text = [NSString stringWithFormat:@"“%@”的%@有%@天",self.activities[section],typeStr,countStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:text];
    [attStr addAttribute:NSForegroundColorAttributeName value:[JYSkinManager shareSkinManager].colorForDateBg range:[text rangeOfString:countStr]];
    header.attributedText = attStr;
    header.textAlignment = NSTextAlignmentCenter;
//    header.hidden = [arr count]==0;
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YiJiCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForCalendarCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *tag = self.activities[indexPath.section];
    if([tag isEqualToString:@"动土"]){
        tag = @"動土";
    }
    NSArray *arr;
    if(self.segmentControl.selectedSegmentIndex==0){
        if(self.shouldFilter){
            arr = self.filterGoodDaysDic[tag];
            
        }else{
            arr = self.goodDaysDic[tag];
        }
    }else{
        if(self.shouldFilter){
            arr = self.filterBadDaysDic[tag];
        }else{
            arr = self.badDaysDic[tag];
        }
    }
    if(arr&&[arr count]>indexPath.row){
        cell.calendarModel = arr[indexPath.row];
    }
    return cell;
    
//    YiJiCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForCalendarCell];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if(self.segmentControl.selectedSegmentIndex==0){
//        if(self.shouldFilter){
//            cell.calendarModel = self.filterGoodDays[indexPath.row];
//        }else{
//            cell.calendarModel = self.goodDays[indexPath.row];
//        }
//    }else{
//        if(self.shouldFilter){
//            cell.calendarModel = self.filterBadDays[indexPath.row];
//        }else{
//            cell.calendarModel = self.badDays[indexPath.row];
//        }
//    }
//    return cell;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.tableHeaderView;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return kTableHeaderViewHeight;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tag = self.activities[indexPath.section];
    NSArray *arr;
    if(self.segmentControl.selectedSegmentIndex==0){
        if(self.shouldFilter){
            arr = self.filterGoodDaysDic[tag];
            
        }else{
            arr = self.goodDaysDic[tag];
        }
    }else{
        if(self.shouldFilter){
            arr = self.filterBadDaysDic[tag];
        }else{
            arr = self.badDaysDic[tag];
        }
    }
    JYCalendarModel *cModel = arr[indexPath.row];
    
    JYRemindViewController *vc = [[JYRemindViewController alloc] init];
    
    vc.delegate = self;
    vc.isCreate = YES;
    RemindModel *model = [[RemindModel alloc] init];
    
    model.year = (int)cModel.year;
    model.month = (int)cModel.month;
    model.day = (int)cModel.day;
    model.hour = [[Tool actionforNowHour] intValue];
    model.minute = [[Tool actionforNowMinute] intValue];
    model.musicName = (int)[[NSUserDefaults standardUserDefaults]integerForKey:kDefaultMusic];
    model.upData = NO;
    model.fidStr = @"";   //避免出现Nil情况
    model.gidStr = @"";
    model.isOn = YES;
    FriendModel *model1 = [[FriendModel alloc] init];
    model1.head_url = [[NSUserDefaults standardUserDefaults] objectForKey:kUserHead];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - Custom Accessors

- (UISegmentedControl *)segmentControl
{
    if(!_segmentControl){
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"吉",@"忌"]];
        _segmentControl.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_segmentControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[JYSkinManager shareSkinManager].colorForDateBg} forState:UIControlStateNormal];
        [_segmentControl addTarget:self action:@selector(segmentControlClicked:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.selectedSegmentIndex = 0;
        
    }
    return _segmentControl;
}
- (UILabel *)descLabel
{
    if(!_descLabel){
        _descLabel = [UILabel new];
        _descLabel.font = [UIFont systemFontOfSize:16.f];
        NSString *str = [self.activities componentsJoinedByString:@","];
        _descLabel.text = [NSString stringWithFormat:@"\"%@\"的吉日共有0天",str];
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 90.f;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        [_tableView registerClass:[YiJiCalendarCell class] forCellReuseIdentifier:kIdentifierForCalendarCell];
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableView;
}
//- (UIImageView *)emptyImageView
//{
//    if(!_emptyImageView){
//        _emptyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_择吉_无日期"]];
////        _emptyImageView.hidden = YES;
//        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
//    return _emptyImageView;
//}
- (NSMutableArray *)goodDays
{
    if(!_goodDays){
        _goodDays = [NSMutableArray array];
    }
    return _goodDays;
}
- (NSMutableArray *)badDays
{
    if(!_badDays){
        _badDays = [NSMutableArray array];
    }
    return _badDays;
}
- (NSMutableDictionary *)goodDaysDic
{
    if(!_goodDaysDic){
        _goodDaysDic = [NSMutableDictionary dictionary];
    }
    return _goodDaysDic;
}
- (NSMutableDictionary *)badDaysDic
{
    if(!_badDaysDic){
        _badDaysDic = [NSMutableDictionary dictionary];
    }
    return _badDaysDic;
}
- (NSMutableArray *)filterGoodDays
{
    if(!_filterGoodDays){
        _filterGoodDays = [NSMutableArray array];
        [self.goodDays enumerateObjectsUsingBlock:^(JYCalendarModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.weekCNString isEqualToString:@"星期六"]||[obj.weekCNString isEqualToString:@"星期日"]){
                [_filterGoodDays addObject:obj];
            }
        }];
    }
    return _filterGoodDays;
}
- (NSMutableArray *)filterBadDays
{
    if(!_filterBadDays){
        _filterBadDays = [NSMutableArray array];
        [self.badDays enumerateObjectsUsingBlock:^(JYCalendarModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj.weekCNString isEqualToString:@"星期六"]||[obj.weekCNString isEqualToString:@"星期日"]){
                [_filterBadDays addObject:obj];
            }
        }];
    }
    return _filterBadDays;
}
- (NSMutableDictionary *)filterGoodDaysDic
{
    if(!_filterGoodDaysDic){
        _filterGoodDaysDic = [NSMutableDictionary dictionary];
        
        for(NSString *key in self.goodDaysDic.allKeys){
            NSArray *arr = self.goodDaysDic[key];
            NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:[arr count]];
            [arr enumerateObjectsUsingBlock:^(JYCalendarModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.weekCNString isEqualToString:@"星期六"]||[obj.weekCNString isEqualToString:@"星期日"]){
                    [muArr addObject:obj];
                }
            }];
            [_filterGoodDaysDic setObject:muArr forKey:key];
        }
    }
    return _filterGoodDaysDic;
}
- (NSMutableDictionary *)filterBadDaysDic
{
    if(!_filterBadDaysDic){
        _filterBadDaysDic = [NSMutableDictionary dictionary];
        
        for(NSString *key in self.badDaysDic.allKeys){
            NSArray *arr = self.badDaysDic[key];
            NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:[arr count]];
            [arr enumerateObjectsUsingBlock:^(JYCalendarModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if([obj.weekCNString isEqualToString:@"星期六"]||[obj.weekCNString isEqualToString:@"星期日"]){
                    [muArr addObject:obj];
                }
            }];
            [_filterBadDaysDic setObject:muArr forKey:key];
        }
    }
    return _filterBadDaysDic;
}
- (UIView *)filterMenu
{
    if(!_filterMenu){
        _filterMenu = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kFilterMenuHeight)];
        _filterMenu.backgroundColor = [UIColor whiteColor];
        
        UIView *upperLine = [[UIView alloc]init];
        upperLine.backgroundColor = [UIColor lightGrayColor];
        [_filterMenu addSubview:upperLine];
        
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [_filterMenu addSubview:bottomLine];
        
        
        UILabel *lbl = [[UILabel alloc]init];
        lbl.font = [UIFont systemFontOfSize:16.f];
        lbl.text = @"仅查看属于周末的日期";
        [_filterMenu addSubview:lbl];
        
        UISwitch *switchBtn = [[UISwitch alloc]init];
        switchBtn.onTintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [switchBtn addTarget:self action:@selector(filterData:) forControlEvents:UIControlEventValueChanged];
        [_filterMenu addSubview:switchBtn];
        
        CGFloat horMargin = 10.f;
        [upperLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_filterMenu).offset(horMargin);
            make.right.equalTo(_filterMenu).offset(-horMargin);
            make.top.equalTo(_filterMenu);
            make.height.equalTo(@.5f);
        }];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_filterMenu);
            make.bottom.equalTo(_filterMenu.mas_bottom);
            make.height.equalTo(@.5f);
        }];
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_filterMenu).offset(horMargin);
            make.top.equalTo(upperLine.mas_bottom);
            make.bottom.equalTo(bottomLine.mas_top);
            make.right.equalTo(switchBtn.mas_left).offset(-horMargin);
        }];
        [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_filterMenu).offset(-horMargin);
            make.centerY.equalTo(lbl);
        }];
        
    }
    return _filterMenu;
}
@end
