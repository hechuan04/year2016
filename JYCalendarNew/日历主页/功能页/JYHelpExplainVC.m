//
//  JYHelpExplainVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/12/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYHelpExplainVC.h"
#import "HelpCell.h"
#import "HelpDetailVC.h"
#define kRowHeigth 60.f
static NSString *helpCellIdentifier = @"helpCellIdentifier";
@interface JYHelpExplainVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray     *titleArr;
@end

@implementation JYHelpExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"帮助说明";
    [self.view addSubview:self.tableView];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-kNavbarHeight-kStatusBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kRowHeigth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerNib:[UINib nibWithNibName:@"HelpCell" bundle:nil] forCellReuseIdentifier:helpCellIdentifier];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpDetailVC *vc = [[HelpDetailVC alloc] init];
    vc.index = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:helpCellIdentifier];
    cell.Title.text = self.titleArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArr.count;
}

- (NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@"1、提醒-共享功能",@"2、新建提醒功能",@"3、编辑按钮的作用",@"4、密码的用途",@"5、择吉",@"6、个人中心介绍",@"7、通话时间闹钟能否不发出声音",@"8、关机是否能正常响铃"];
    }
    
    return _titleArr;
}

@end
