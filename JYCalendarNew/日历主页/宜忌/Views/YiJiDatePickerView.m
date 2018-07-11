//
//  YiJiDatePickerView.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "YiJiDatePickerView.h"

#define kYearCompenentIndex 0
#define kMonthCompenentIndex 1
#define kDayCompenentIndex 2

#define kContentViewHeight 267

@interface YiJiDatePickerView()
@property (nonatomic,strong) NSDateFormatter *dateFromatter;
@property (nonatomic,strong) NSDateComponents *components;

@property (nonatomic,assign) NSInteger selectedYear;
@property (nonatomic,assign) NSInteger selectedMonth;
@property (nonatomic,assign) NSInteger selectedDay;

@end

@implementation YiJiDatePickerView

#pragma mark - Life Cycle
+ (YiJiDatePickerView*)sharedView {
    static dispatch_once_t once;
    
    static YiJiDatePickerView *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    });
    
    return sharedView;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupSubViews];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeSkin:) name:kNotificationForChangeSkin object:nil];
    }
    return self;
}
#pragma mark - Public
- (void)showWithDate:(NSDate *)date completed:(DateChooseCompletedBlock)block
{
    _completedBlock = [block copy];
    [self showWithDate:date];
}
- (void)showWithDate:(NSDate *)date
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self layoutIfNeeded];
    [UIView animateWithDuration:.25 animations:^{
        self.contentView.frame = CGRectMake(0,kScreenHeight-kContentViewHeight,kScreenWidth, kContentViewHeight);
        self.backgroundView.alpha = 1;
        [self setNeedsLayout];
    }];
    
    [self configPickerViewWithDate:date];
}
- (void)dismiss
{
    [UIView animateWithDuration:.25 animations:^{
        self.backgroundView.alpha = 0;
        self.contentView.frame = CGRectMake(0,kScreenHeight,kScreenWidth, kContentViewHeight);
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];

}
#pragma mark - Private
#pragma mark UI
- (void)setupSubViews
{
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _backgroundView.alpha = 0;
    [self addSubview:_backgroundView];
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackgroundView:)];
    [_backgroundView addGestureRecognizer:tap];
    
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0,kScreenHeight,kScreenWidth,kContentViewHeight)];
    [self addSubview:_contentView];
    
    _cancelButton = [UIButton new];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_cancelButton];
    
    _confirmButton = [UIButton new];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _confirmButton.backgroundColor = [UIColor whiteColor];
    [_contentView addSubview:_confirmButton];

    _pickerView = [UIPickerView new];
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.showsSelectionIndicator = YES;
    [_contentView addSubview:_pickerView];
    
    UIView *verLineView = [UIView new];
    verLineView.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:verLineView];
    
    UIView *horLineView = [UIView new];
    horLineView.backgroundColor = [UIColor lightGrayColor];
    [_contentView addSubview:horLineView];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView);
        make.height.equalTo(@50.f);
        make.right.equalTo(verLineView.mas_left);
    }];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.contentView);
        make.height.equalTo(_cancelButton);
        make.left.equalTo(verLineView.mas_right);
    }];
    [verLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@.5f);
        make.bottom.centerX.equalTo(self.contentView);
        make.height.equalTo(_cancelButton);
    }];
    [horLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.cancelButton.mas_top);
        make.height.equalTo(@.5f);
    }];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(horLineView.mas_top);
//        make.height.equalTo(@216);
        make.left.right.top.equalTo(self.contentView);
    }];
}
#pragma mark EventHandle
- (void)cancelButtonClicked:(UIButton *)sender
{
    [self dismiss];
}
- (void)confirmButtonClicked:(UIButton *)sender
{
    [self dismiss];
    if(self.completedBlock){
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setYear:self.selectedYear];
        [components setMonth:self.selectedMonth];
        [components setDay:self.selectedDay];
        [components setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [calendar dateFromComponents:components];
        self.completedBlock(date);
    }
}
- (void)tapBackgroundView:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}
- (void)changeSkin:(NSNotification *)notification
{
    [self.confirmButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
}
#pragma mark Net/Data
- (NSDateComponents *)getComponentsWithDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    return [calendar components:unitFlags fromDate:date];
}
- (void)configPickerViewWithDate:(NSDate *)date
{
    if(date){
        NSDateComponents *com = [self getComponentsWithDate:date];
        NSInteger year = com.year;
        NSInteger month = com.month;
        NSInteger day = com.day;
        
        self.selectedYear = year;
        self.selectedMonth = month;
        self.selectedDay = day;
        self.days = [self calculateDays];
        [self.pickerView reloadComponent:kDayCompenentIndex];

        NSInteger indexYear = [self.years indexOfObject:[NSString stringWithFormat:@"%ld",year]];
        NSInteger indexMonth = [self.months indexOfObject:[NSString stringWithFormat:@"%ld",month]];
        NSInteger indexDay = [self.days indexOfObject:[NSString stringWithFormat:@"%ld",day]];
        
        if(indexYear!=NSNotFound){
            [self.pickerView selectRow:indexYear inComponent:kYearCompenentIndex animated:NO];
        }
        if(indexMonth!=NSNotFound){
            [self.pickerView selectRow:indexMonth inComponent:kMonthCompenentIndex animated:NO];
        }
        if(indexDay!=NSNotFound){
            [self.pickerView selectRow:indexDay inComponent:kDayCompenentIndex animated:NO];
        }
    }
}
- (BOOL)isLeapYear:(NSInteger)year
{
    if ((year%4==0 && year%100!=0) || year%400==0) {
        return YES;
    }
    return NO;
}
- (NSArray *)calculateDays
{
    NSArray *days;
    if(self.selectedMonth==1||self.selectedMonth==3||self.selectedMonth==5||self.selectedMonth==7||self.selectedMonth==8||self.selectedMonth==10||self.selectedMonth==12){
        days = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    }else if(self.selectedMonth==4||self.selectedMonth==6||self.selectedMonth==9||self.selectedMonth==11){
        days = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30"];
        
    }else if(self.selectedMonth==2){
        BOOL flag = [self isLeapYear:self.selectedYear];
        if(flag){//闰年
            days = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29"];
        }else{
            days = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28"];
        }
    }
    return days;
}
#pragma mark - Protocol
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger row = 0;
    switch (component) {
        case kYearCompenentIndex:
            row = [self.years count];
            break;
        case kMonthCompenentIndex:
            row = [self.months count];
            break;
        case kDayCompenentIndex:
            row = [self.days count];
            break;
        default:
            break;
    }
    return row;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    switch (component) {
        case kYearCompenentIndex:
            title = [NSString stringWithFormat:@"%@年",self.years[row]];
            break;
        case kMonthCompenentIndex:
            title = [NSString stringWithFormat:@"%@月",self.months[row]];
            break;
        case kDayCompenentIndex:
            title = [NSString stringWithFormat:@"%@日",self.days[row]];
            break;
        default:
            break;
    }
    return title;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if(!label){
        label = [UILabel new];
        label.minimumScaleFactor = 8.0;
        label.adjustsFontSizeToFitWidth = YES;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:24]];
    }
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}
//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    CGFloat width = 0;
//    switch (component) {
//        case 0:
//            width = kScreenWidth/5*2;
//            break;
//        case 1:
//            width = kScreenWidth/5;
//            break;
//        case 2:
//            width = kScreenWidth/5*2;
//            break;
//        default:
//            break;
//    }
//    return width;
//}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50.f;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component) {
        case kYearCompenentIndex:{
            NSInteger year = [[self.years objectAtIndex:row] integerValue];
            self.selectedYear = year;
            self.days = [self calculateDays];
            [self.pickerView reloadComponent:kDayCompenentIndex];
            if(self.selectedDay>[self.days count]){
                self.selectedDay = [self.days count];
            }
        }
            break;
        case kMonthCompenentIndex:{
            NSInteger month = [[self.months objectAtIndex:row] integerValue];
            self.selectedMonth = month;
            self.days = [self calculateDays];
            [self.pickerView reloadComponent:kDayCompenentIndex];
            if(self.selectedDay>[self.days count]){
                self.selectedDay = [self.days count];
            }
        }
            break;
        case kDayCompenentIndex:{
            NSInteger day = [[self.days objectAtIndex:row] integerValue];
            self.selectedDay = day;
        }
            break;
        default:
            break;
    }
}
#pragma mark - Custom Accessors
- (NSArray *)years
{
    if(!_years){
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:50];
        for(int i=2016; i<2049; i++){
            [muArr addObject:[NSString stringWithFormat:@"%d",i]];
        }
        _years = [NSArray arrayWithArray:muArr];
    }
    return _years;
}
- (NSArray *)months
{
    if(!_months){
        _months = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12"];
    }
    return _months;
}
- (NSArray *)days
{
    if(!_days){
        _days = [self calculateDays];
    }
    return _days;
}
- (NSDateFormatter *)dateFromatter
{
    if(!_dateFromatter){
        _dateFromatter = [[NSDateFormatter alloc]init];
        _dateFromatter.dateFormat = @"yyyy年MM月dd日";
    }
    return _dateFromatter;
}
@end
