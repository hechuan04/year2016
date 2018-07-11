//
//  JYZhengdianTB.m
//  JYCalendarNew
//
//  Created by 吴冬 on 17/1/11.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYZhengdianTB.h"
#import "JYZhengdianCell.h"

static NSString *zhengdianIdentifier = @"zhengdianIdentifier";

@implementation JYZhengdianTB
{
    NSArray *_titleArr;
    NSArray *_times;
    NSInteger _aheadOfTime;
    bool flag[10];
    NSInteger _lastIndex;
    
}

- (void)setModel:(RemindModel *)model
{
    if (_model != model) {
        _model = model;
      
        for (int i = 0; i < _times.count; i++) {
            if (_model.offsetMinute * 60 == [_times[i]integerValue]) {
                flag[0] = NO;
                _lastIndex = i;
                flag[i] = YES;
            }
        }
     
        _aheadOfTime = _model.offsetMinute * 60;
        [self reloadData];
    }
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        //self.separatorStyle = UITableViewCellSeparatorStyleNone;
        _titleArr = @[@"正点提醒",@"5分钟前",@"15分钟前",@"30分钟前",@"1小时前",@"2小时前"];
        _times   = @[@(0),@(5 * 60),@(15 * 60),@(30 * 60),@(60 * 60),@(120 * 60)];
        [self registerClass:[JYZhengdianCell class] forCellReuseIdentifier:zhengdianIdentifier];
        
        
        
        flag[0] = YES;
        _lastIndex = 0;
        _aheadOfTime = _model.offsetMinute * 60;
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
//        line.backgroundColor = lineColor;
//        [self addSubview:line];
        
    }
    return self;
}

- (void)setBtn
{
    UIButton *cancel = [UIButton new];
    cancel.frame = CGRectMake(0, 6 * 45.f, kScreenWidth / 2.0, 45);
    [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:cancel];
    
    UIButton *confirm = [UIButton new];
    confirm.frame = CGRectMake(kScreenWidth / 2.0, 6 * 45.f, kScreenWidth / 2.0, 45);
    [confirm addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    [confirm setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self addSubview:confirm];
  
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(kScreenWidth / 2.0 - 0.25, 6 * 45.f, 0.5, 45.f);
    lineView.backgroundColor = lineColor;
    [self addSubview:lineView];
 
}

- (void)confirmAction:(UIButton *)sender
{
    if (_confirmBlock) {
        _confirmBlock();
    }
    _model.offsetMinute = _aheadOfTime / 60;
    [self removeFromSuperview];

}

- (void)cancelAction:(UIButton *)sender
{
    if (_cancelBlock) {
        _cancelBlock();
    }
    [self removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45.f;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYZhengdianCell *cell = [tableView dequeueReusableCellWithIdentifier:zhengdianIdentifier];
    if (!cell) {
        cell = [[JYZhengdianCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:zhengdianIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = _titleArr[indexPath.row];
    cell.selectImage.highlighted = flag[indexPath.row];
    
    if (flag[indexPath.row]) {
        cell.titleLabel.textColor = [UIColor redColor];
    }else{
        cell.titleLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row != _lastIndex) {
       
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *com = [[NSDateComponents alloc] init];
        [com setYear:_model.year];
        [com setMonth:_model.month];
        [com setDay:_model.day];
        [com setHour:_model.hour];
        [com setMinute:_model.minute];
        
        NSDate *selectDate = [calendar dateFromComponents:com];
        NSInteger selectTimes = [selectDate timeIntervalSinceNow];
        
        if (selectTimes < [_times[indexPath.row]integerValue]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"非常抱歉，提醒时间不在当前时间范围内，无法提醒" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert setTintColor:[UIColor redColor]];
            [alert show];

            return;
        }
        
        
        flag[indexPath.row] = YES;
        flag[_lastIndex] = NO;
        _lastIndex = indexPath.row;
        _aheadOfTime = [_times[indexPath.row]integerValue];
        _model.offsetMinute = _aheadOfTime / 60;
        [self reloadData];
    }
    
    
}

- (void)dealloc{
  
    NSLog(@"销毁");
}

@end
