//
//  JYRecurVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYRecurVC.h"
#import "WeekCell.h"

static NSString *weekIdentifier = @"weekIdentifier";

@interface JYRecurVC ()
{
 
    UITableView *_tb;
    NSArray     *_weekArr;
}
@end

@implementation JYRecurVC

- (void)saveAction:(UIButton *)sender
{
 
    NSMutableString *weekStr = [NSMutableString string];
    for (int i = 0; i < _arrForWeek.count ; i++) {
        
        NSString *index = _arrForWeek[i];
        
        NSString *weekS = [NSString stringWithFormat:@"%@,",index];
        
        
        [weekStr appendString:weekS];
        
    }
    
    if (weekStr.length != 0) {
        
        _model.week = [weekStr substringWithRange:NSMakeRange(0, weekStr.length - 1)];
    }else{
        
        _model.week = @"";
        
    }
    
    NSArray *arr = [_model.week componentsSeparatedByString:@","];
   
    //排序
    NSArray *arrForW = [Tool actionForAscending:arr];

    NSLog(@"%@",arrForW);
    
    NSMutableString *weekStrNow = [NSMutableString string];
    
    NSMutableString *nowStr     = [NSMutableString string];
    
    for (int i = 0; i < arrForW.count; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%@,",arrForW[i]];
        
        if (![str isEqualToString:@","]) {
            
            switch ([str intValue]) {
                case 0:
                {
                    
                    [nowStr appendString:@"每周一 "];
                    
                }
                    
                    break;
                case 1:
                {
                    [nowStr appendString:@"每周二 "];
                    
                }
                    break;
                case 2:
                {
                    [nowStr appendString:@"每周三 "];
                    
                }
                    break;
                case 3:
                {
                    
                    [nowStr appendString:@"每周四 "];
                }
                    break;
                case 4:
                {
                    
                    [nowStr appendString:@"每周五 "];
                }
                    break;
                case 5:
                {
                    [nowStr appendString:@"每周六 "];
                    
                }
                    break;
                case 6:
                {
                    [nowStr appendString:@"每周日"];
                }
                    break;
                default:
                    break;
            }
            
            [weekStrNow appendString:str];
        }
        
        
        
    }
    
    NSString *week = @"";
    if (weekStrNow.length != 0) {
        
        week = [weekStrNow substringWithRange:NSMakeRange(0, weekStrNow.length - 1)];
    }
    
    
    
    _model.week = week;
    if ([week isEqualToString:@""]) {
        
        _model.timeDescribe = @"永不";
        
    }else{
        
        _model.timeDescribe = [self _actionForReturnWeekStr:nowStr andArr:arrForW];
    }
    
    _actionForWeek(_model);
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"保存" forState:UIControlStateNormal];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = right;
    

    [self _creatTableView];
}

- (void)actionForLeft:(UIButton *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)_actionForReturnWeekStr:(NSString *)week
                               andArr:(NSArray *)weekArr
{
 
    if (weekArr.count == 7) {
        
        return @"每天";
        
    }else if([week isEqualToString:@"每周一 每周二 每周三 每周四 每周五 "]){
     
        return @"工作日";
        
    }else{
     
        return week;
    }
    
    
}

- (void)_creatTableView
{
    _weekArr = @[@"每周一",@"每周二",@"每周三",@"每周四",@"每周五",@"每周六",@"每周日"];
    
    NSArray *weekAr = [_model.week componentsSeparatedByString:@","];
    if(_model.week.length>0){
        _arrForWeek = [NSMutableArray arrayWithArray:weekAr];
    }else{
        _arrForWeek = [NSMutableArray arrayWithCapacity:7];
    }
    
    _tb = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    _tb.delegate = self;
    _tb.dataSource = self;
    [self.view addSubview:_tb];
    
    //注册单元格
    [_tb registerNib:[UINib nibWithNibName:@"WeekCell" bundle:nil] forCellReuseIdentifier:weekIdentifier];
    
    [Tool actionForHiddenMuchTable:_tb];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30.f;
//}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        
        return 7;
        
    }else if(section==1){
        
        return 1;
    }
    
    return 0;
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WeekCell *cell = [tableView dequeueReusableCellWithIdentifier:weekIdentifier];
    
    if (!cell) {
        
        cell = [[WeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:weekIdentifier];
    }
    
    
    return cell;
    
}

//出现
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell1 forRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    WeekCell *cell = (WeekCell *)cell1;
    NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    if(indexPath.section==0){
        
        cell.weekLabel.text = _weekArr[indexPath.row];
        
        if (_model.week) {
            
            if ([_model.week rangeOfString:index].location != NSNotFound) {
                
                cell.isSelect = YES;
                cell.SelectImage.image = [UIImage imageNamed:@"重复选中.png"];
                
                
            }else{
                
                cell.isSelect = NO;
                cell.SelectImage.image = [UIImage imageNamed:@"重复未选中.png"];
                
            }
            
        }
        
    }else if(indexPath.section==1){
        
        cell.weekLabel.text = @"每天";
        
        if([[_model.week componentsSeparatedByString:@","] count]==7){
            
            cell.isSelect = YES;
            cell.SelectImage.image = [UIImage imageNamed:@"重复选中.png"];
        }else{
            cell.isSelect = NO;
            cell.SelectImage.image = [UIImage imageNamed:@"重复未选中.png"];
        }
    }
    
    

    
}

//选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    WeekCell *cell = (WeekCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.isSelect = !cell.isSelect;
    
    if(indexPath.section==0){
        
        NSString *index = [NSString stringWithFormat:@"%ld",indexPath.row];
        if (!cell.isSelect) {
            
            for (int i = 0; i < _arrForWeek.count; i++) {
                
                NSString *indexNow = _arrForWeek[i];
                
                if ([indexNow isEqualToString:index]) {
                    
                    [_arrForWeek removeObject:indexNow];
                }
            }
            
        }else{
            [_arrForWeek addObject:index];
        }
//        
//        if (cell.isSelect) {
//            
//            cell.SelectImage.image = [UIImage imageNamed:@"重复选中.png"];
//            
//        }else{
//            
//            cell.SelectImage.image = [UIImage imageNamed:@"重复未选中.png"];
//            
//        }

    }else{
        
        if([_arrForWeek count]<7){
            [_arrForWeek removeAllObjects];
            for(int i=0;i<7;i++){
                [_arrForWeek addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }else{
            [_arrForWeek removeAllObjects];
        }
    }
    
    _model.week = [_arrForWeek componentsJoinedByString:@","];
    
    [tableView reloadData];
}



- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
 
    return 49.0;
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
