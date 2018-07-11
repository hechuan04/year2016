//
//  FunctionViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/6/13.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "FunctionViewController.h"
#import "NoteListViewController.h"
#import "PassWordVC.h"
#import "ScanMainViewController.h"
#import "FunctionCell.h"
#import "WeatherViewController.h"
#import "YijiChooseViewController.h"
#import "JYClockVC.h"
#import "JYHelpExplainVC.h"

#define kRowHeigth 60.f
static NSString *kIdentifierForCell = @"kIdentifierForCell";

@interface FunctionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *menuTitles;
@property (nonatomic,strong) NSArray *menuIcons;
@end

@implementation FunctionViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工具";
    [self.view addSubview:self.tableView];
    
    self.navigationItem.leftBarButtonItem = nil;
    
}

#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol
#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuTitles count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForCell];
    UIImage *icon = [UIImage imageNamed:self.menuIcons[indexPath.row]];
    NSString *title = self.menuTitles[indexPath.row];
    [cell setIcon:icon title:title];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = nil;
    switch (indexPath.row) {
        case 0:{
            PassWordTitleList *titleList = [PassWordTitleList sharePassWordTitleList];
            vc = [[PassWordVC alloc] init];
            ((PassWordVC *)vc).dataArr = [titleList selectData];
        }
            break;
//        case 1:{
//            vc = [[ScanMainViewController alloc]init];
//        }
//            break;
        case 1:{
            vc = [[NoteListViewController alloc]init];
        }
            break;
        case 2:{
            vc = [[WeatherViewController  alloc]init];
        }
            break;
        case 3:{
            vc = [[YijiChooseViewController alloc]init];
        }
            break;
        case 4:{
            vc = [[JYClockVC alloc]init];
            [RequestManager actionForHttp:@"local_alert"];
        }
            break;
        case 5:
        {
            vc = [[JYHelpExplainVC alloc] init];
        }
            break;
        default:
            break;
    }
    
    if(vc){
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - Custom Accessors
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight-kNavbarHeight-kStatusBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kRowHeigth;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[FunctionCell class] forCellReuseIdentifier:kIdentifierForCell];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (NSArray *)menuTitles
{
    if(!_menuTitles){
        _menuTitles = @[@"密码",@"记事",@"天气",@"择吉",@"闹钟",@"用户帮助"];
    }
    return _menuTitles;
}
- (NSArray *)menuIcons
{
    if(!_menuIcons){
//        _menuIcons = @[@"密码菜单",@"扫描菜单",@"记事本菜单",@"天气菜单",@"择吉菜单"];
        _menuIcons = @[@"密码菜单",@"记事本菜单",@"天气菜单",@"择吉菜单",@"闹钟菜单",@"用户说明"];
    }
    return _menuIcons;
}
@end
