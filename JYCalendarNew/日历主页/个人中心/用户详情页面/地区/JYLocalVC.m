//
//  JYLocalVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYLocalVC.h"

@interface JYLocalVC ()
{
 
    NSArray *_provinceArr;
}

@end

@implementation JYLocalVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _actionForProvinceArr];
    
    [self _creatTableView];
}

- (void)_actionForProvinceArr
{
 
    NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"Province" ofType:@"plist"];
    
    _provinceArr = [NSArray arrayWithContentsOfFile:pathStr];
    
}

- (void)actionForLeft:(UIButton *)sender
{
 
//    _actionForReloadTb();
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)_creatTableView
{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 66) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    

    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
 
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 49.0)];
    headView.backgroundColor =  [UIColor colorWithRed:240 / 255.0 green:240 / 255. blue:240 / 255. alpha:1];
    UILabel *labelForHead = [UILabel new];
    labelForHead.font = [UIFont systemFontOfSize:13];
    labelForHead.textColor = [UIColor grayColor];
    [headView addSubview:labelForHead];
    
    [labelForHead mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(headView.mas_left).offset(20.5f);
        make.bottom.equalTo(headView.mas_bottom).offset(-5.f);
        
        
    }];
    
    if (section == 0) {
        
        labelForHead.text = @"我的位置";
        
    }else{
     
        labelForHead.text = @"全部";
    }
    
    return headView;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
 
    return 49.f;
}

//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
 
    return 2;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    }else{
     
        return _provinceArr.count;

    }
    
    
}

//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *provinceIdentifier = @"provinceIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:provinceIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:provinceIdentifier];
        
    }
    

    if (indexPath.section == 0) {
        
        cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:kUserLocal];
        
    }else {
     
        cell.textLabel.text = _provinceArr[indexPath.row];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section == 1) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_provinceArr[indexPath.row] forKey:kUserLocal];
        
        [tableView reloadData];
        
        _actionForReloadTb();
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
