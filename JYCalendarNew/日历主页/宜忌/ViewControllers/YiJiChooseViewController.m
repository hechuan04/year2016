//
//  YijiChooseViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "YijiChooseViewController.h"
#import "ActivityCell.h"
#import "YiJiDetailViewController.h"
#import "YiJiDatePickerView.h"

#define kCellMargin 15.f
#define kCollectionMargin 15.f
#define kHorMargin 30.f
#define kCollectionHeight 230.f
#define kOptionBtnHeight 45.f
#define kVerMargin 15.f

#define kHeaderHeight 100.f
#define kTableCellHeight 70.f

static  NSString *kCellIdentifierForCollectionNormal = @"kCellIdentifierForCollectionNormal";
static  NSString *kCellIdentifierForTableNormal = @"kCellIdentifierForTableNormal";

@interface YijiChooseViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic,strong) NSArray *activities;
@property (nonatomic,strong) NSDictionary *activityDict;
@property (nonatomic,strong) UIView *describeView;
@property (nonatomic,strong) UIView *colorView;
@property (nonatomic,strong) UILabel *activityNameLabel;
@property (nonatomic,strong) UILabel *activityDescLabel;
@property (nonatomic,strong) UITableView *menuTableView;
@property (nonatomic,strong) UIButton *confirmBtn;
//@property (nonatomic,strong) NSIndexPath *selectedIndexPath;//单选
@property (nonatomic,strong) NSMutableArray *selectedActivities;
@property (nonatomic,strong) YiJiDatePickerView *datePicker;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSDate *startDate;
@property (nonatomic,strong) NSDate *endDate;

@end

@implementation YijiChooseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"择吉";
    [self setupSubviews];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//    self.selectedIndexPath = indexPath;
    [self.selectedActivities addObject:self.activities[0]];
    [self refreshDescView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
#pragma mark - Public


#pragma mark - Private
- (void)setupSubviews
{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.describeView];
    [self.view addSubview:self.menuTableView];
    [self.view addSubview:self.confirmBtn];
    
    NSInteger columnNum = 4;
    CGFloat itemWidth = floorf((kScreenWidth-kCellMargin*(columnNum-1)-kCollectionMargin*2)/columnNum);
    CGFloat itemHeight = itemWidth/2.f;
    CGFloat collectionHeight = itemHeight*4+kCellMargin*3+kCollectionMargin*2+5;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(collectionHeight));
    }];
    [self.describeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(10.f);
        make.left.right.equalTo(self.view);
        make.height.greaterThanOrEqualTo(@30.f);
    }];
    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.describeView.mas_bottom).offset(20.f);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@(kTableCellHeight*2+2));
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.menuTableView.mas_bottom).offset(20.f);
        make.left.equalTo(self.view).offset(20.f);
        make.right.equalTo(self.view).offset(-20.f);
        make.height.equalTo(@45.f);
    }];
}
//- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
//{
////    _selectedIndexPath = selectedIndexPath;
//    
//    NSInteger index = selectedIndexPath.row;
//    NSString *activity = self.activities[index];
//    self.activityNameLabel.text = activity;
//    self.activityDescLabel.text = self.activityDict[activity];
//}
- (void)refreshDescView
{
    if([self.selectedActivities count]==1){
       
        [_activityDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activityNameLabel.mas_bottom).offset(10);
            make.left.equalTo(_activityNameLabel);
            make.bottom.equalTo(_describeView);
            make.right.equalTo(_describeView).offset(-10);
        }];
        NSString *activity = self.selectedActivities[0];
        self.activityNameLabel.text = activity;
        self.activityDescLabel.text = self.activityDict[activity];
        [self.activityDescLabel setNeedsLayout];
        [self.activityDescLabel setNeedsDisplay];
        self.confirmBtn.enabled = YES;
    }else if([self.selectedActivities count]==0){
        
        [_activityDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activityNameLabel.mas_bottom);
            make.left.equalTo(_activityNameLabel);
            make.bottom.equalTo(_describeView);
            make.right.equalTo(_describeView).offset(-10);
            make.height.equalTo(@0);
        }];
        self.activityNameLabel.text = @"未选择";
        self.activityDescLabel.text = @"";
        self.confirmBtn.enabled = NO;
    }else{
        [_activityDescLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activityNameLabel.mas_bottom);
            make.left.equalTo(_activityNameLabel);
            make.bottom.equalTo(_describeView);
            make.right.equalTo(_describeView).offset(-10);
            make.height.equalTo(@0);
        }];
        self.activityNameLabel.text = @"全部";
        self.activityDescLabel.text = @"";
        self.confirmBtn.enabled = YES;
    }
}
- (void)beginDateCellClicked
{
    __weak typeof(self) ws = self;
    [self.datePicker showWithDate:self.startDate completed:^(NSDate *selectedDate) {
        ws.startDate = selectedDate;
        [ws.menuTableView reloadData];
    }];
    
}
- (void)endDateCellClicked
{
    __weak typeof(self) ws = self;
    [self.datePicker showWithDate:self.endDate completed:^(NSDate *selectedDate) {
        ws.endDate = selectedDate;
        [ws.menuTableView reloadData];
    }];
}
- (void)confirmBtnClicked:(UIButton *)sender
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* compStart = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.startDate];
    NSDateComponents* compEnd = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self.endDate];
    
    if([compStart year]>[compEnd year]||
       ([compStart year]==[compEnd year]&&[compStart month]>[compEnd month])||
       ([compStart year]==[compEnd year]&&[compStart month]==[compEnd month]&&[compStart day]>[compEnd day])){

        if([self.startDate compare:self.endDate]==NSOrderedDescending){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"结束时间不能早于开始时间!" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
    }
    
//    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMonth|NSCalendarUnitDay
//                                                        fromDate:self.startDate
//                                                          toDate:self.endDate
//                                                         options:0];
//
//    if([components month]>1){
//        
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"所选时间跨度不能多于一个月!" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    YiJiDetailViewController *detailVC = [[YiJiDetailViewController alloc]initWithStartDate:self.startDate endDate:self.endDate activities:self.selectedActivities];
    if([self.selectedActivities count]==1){
        detailVC.navigationItem.title = self.selectedActivities[0];
    }else{
        detailVC.navigationItem.title = @"全部";
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Protocol
#pragma mark UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.activities count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifierForCollectionNormal forIndexPath:indexPath];
    [cell setTitle:self.activities[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    self.selectedIndexPath = indexPath;
    
//    NSString *activity = self.activities[indexPath.row];
//    if(![self.selectedActivities containsObject:activity]){
//        if([self.selectedActivities count]<4){
//            [self.selectedActivities addObject:activity];
//        }else{
//            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"最多可以选择4个标签!" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alertView show];
//            return;
//        }
//    }else{
//        [self.selectedActivities removeObject:activity];
//    }

}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *activity = self.activities[indexPath.row];
    if(![self.selectedActivities containsObject:activity]){
        if([self.selectedActivities count]>=4){
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"最多可以选择4个标签!" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
            return NO;
        }
        [self.selectedActivities addObject:activity];
        [self refreshDescView];
    }

    return YES;;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *activity = self.activities[indexPath.row];
    if([self.selectedActivities containsObject:activity]){
        [self.selectedActivities removeObject:activity];
        [self refreshDescView];
    }
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifierForTableNormal];
    }
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"开始时间";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.startDate];
        }
            break;
        case 1:{
            cell.textLabel.text = @"结束时间";
            cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.endDate];
        }
            break;
        default:
            break;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            [self beginDateCellClicked];
        }
            break;
        case 1:{
            [self endDateCellClicked];
        }
            break;
        default:
            break;
    }

}
#pragma mark - Custom Accessors
- (UICollectionView *)collectionView
{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kCollectionHeight) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ActivityCell class] forCellWithReuseIdentifier:kCellIdentifierForCollectionNormal];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = kCellMargin;
        _flowLayout.minimumInteritemSpacing = kCellMargin;
        _flowLayout.sectionInset = UIEdgeInsetsMake(kCollectionMargin, kCollectionMargin, kCollectionMargin, kCollectionMargin);
        NSInteger columnNum = 4;
        
        CGFloat itemWidth = floorf((kScreenWidth-kCellMargin*(columnNum-1)-kCollectionMargin*2)/columnNum);
        _flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth/2);
    }
    return _flowLayout;
}
- (NSArray *)activities
{
    if(!_activities){
        _activities = @[@"嫁娶",@"开市",@"立券",@"动土",
                        @"破土",@"祈福",@"祭祀",@"安葬",
                        @"入宅",@"移徙",@"出行",@"置业",
                        @"词讼",@"栽种",@"求医",@"修造"];
    }
    return _activities;
}
- (NSDictionary *)activityDict
{
    if(!_activityDict){
        _activityDict = @{@"嫁娶":@"举办结婚典礼、迎亲之日。",
                           @"开市":@"新公司行号开业、开幕或年初头一天开张动工。",
                           @"立券":@"订立各种契约互相买卖之事。",
                           @"动土":@"阳宅建筑时第一次动起锄头挖土、起地基。",
                           @"破土":@"仅指埋葬用的阴宅墓地破土、与一般建筑房屋的“动土”不同。",
                           @"祈福":@"祈求神明降福或设醮还愿之事。",
                           @"祭祀":@"祠堂之祭祀、即拜祭祖先或庙寺的祭拜、神明等事。",
                           @"安葬":@"举行埋葬等仪式。",
                           @"入宅":@"迁入新宅。",
                           @"移徙":@"搬家迁移住所之意。",
                           @"出行":@"出远门。",
                           @"置业":@"购置土地、房屋,进行房地产交换。",
                           @"词讼":@"诉讼，打官司。",
                           @"栽种":@"栽种植物或接枝。",
                           @"求医":@"治疗慢性痼疾或动手术。",
                           @"修造":@"指阳宅之修造与修理。"};
    }
    return _activityDict;
}
- (UIView *)describeView
{
    if(!_describeView){
        _describeView = [UIView new];
        
        UIView *colorView = [UIView new];
        colorView.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_describeView addSubview:colorView];
        _colorView = colorView;
        [colorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_describeView).offset(15.f);
            make.top.equalTo(_describeView).offset(2.f);
            make.bottom.equalTo(_describeView).offset(-2.f);
            make.width.equalTo(@5);
        }];
        
        _activityNameLabel = [UILabel new];
        _activityNameLabel.font = [UIFont systemFontOfSize:18.f];
        [_describeView addSubview:_activityNameLabel];
        [_activityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_describeView);
            make.left.equalTo(colorView).offset(15.f);
            make.height.lessThanOrEqualTo(@25.f);
        }];
        
        _activityDescLabel = [UILabel new];
        _activityDescLabel.font = [UIFont systemFontOfSize:14.f];
        _activityDescLabel.textColor = [UIColor lightGrayColor];
        _activityDescLabel.numberOfLines = 0;
        [_describeView addSubview:_activityDescLabel];
        [_activityDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_activityNameLabel.mas_bottom).offset(10);
            make.left.equalTo(_activityNameLabel);
            make.bottom.equalTo(_describeView);
            make.right.equalTo(_describeView).offset(-10);
        }];
    }
    return _describeView;
}
- (UITableView *)menuTableView
{
    if(!_menuTableView){
        _menuTableView = [UITableView new];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        _menuTableView.rowHeight = kTableCellHeight;
        _menuTableView.showsVerticalScrollIndicator = NO;
        _menuTableView.bounces = NO;
        _menuTableView.tableHeaderView = ({UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1 / UIScreen.mainScreen.scale)];
            line.backgroundColor = [UIColor lightGrayColor];
            line;
        });
        _menuTableView.tableFooterView = ({UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 1 / UIScreen.mainScreen.scale)];
            line.backgroundColor = [UIColor lightGrayColor];
            line;
        });
    }
    return _menuTableView;
}

- (UIButton *)confirmBtn
{
    if(!_confirmBtn){
        _confirmBtn = [UIButton new];
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _confirmBtn.backgroundColor = [JYSkinManager shareSkinManager].colorForDateBg;
        [_confirmBtn setBackgroundImage:[UIImage imageFromColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [_confirmBtn setBackgroundImage:[UIImage imageFromColor:[JYSkinManager shareSkinManager].colorForDateBg] forState:UIControlStateNormal];
        _confirmBtn.layer.cornerRadius = 5.f;
        _confirmBtn.layer.masksToBounds = YES;
    }
    return _confirmBtn;
}
- (YiJiDatePickerView *)datePicker
{
    if(!_datePicker){
        _datePicker = [YiJiDatePickerView sharedView];
    }
    return _datePicker;
}
- (NSDate *)startDate
{
    if(!_startDate){
        _startDate = [NSDate date];
    }
    return _startDate;
}
- (NSDate *)endDate
{
    if(!_endDate){
        _endDate = [NSDate date];
    }
    return _endDate;
}
- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter){
        
        _dateFormatter = [[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日";
    }
    return _dateFormatter;
}
- (NSMutableArray *)selectedActivities
{
    if(!_selectedActivities){
        _selectedActivities = [NSMutableArray arrayWithCapacity:5];
    }
    return _selectedActivities;
}
@end
