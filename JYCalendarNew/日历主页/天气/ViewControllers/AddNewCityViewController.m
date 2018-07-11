//
//  AddNewCityViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/20.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "AddNewCityViewController.h"
#import "WeatherUtil.h"

#define kNoResultViewHeight 100.f
static NSString *kIdentifierForSearchCell = @"kIdentifierForSearchCell";

@interface AddNewCityViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic,strong) UILabel *noResultLabel;
@property (nonatomic,strong) NSString *searchKeyWord;

@end

@implementation AddNewCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xD18787);
    self.navigationItem.title = @"请输入城市名称";
    
    [self setupSubviews];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //navigationBar透明
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}
#pragma mark - Private
#pragma mark UI
- (void)setupSubviews
{
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.view).offset(20.f);
        make.right.equalTo(self.view).offset(-20.f);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark EventHandle
- (void)keepSearchBarCancelButtonEnabled
{
    //键盘消失继续保持searchbar 取消按钮可点击
    for (UIView *view in self.searchBar.subviews)
    {
        for (id subview in view.subviews)
        {
            if ( [subview isKindOfClass:[UIButton class]] )
            {
                [subview setEnabled:YES];
                NSLog(@"enableCancelButton");
                return;
            }
        }
    }
}

#pragma mark Net/Data
- (void)searchCity:(NSString *)keyword
{
    self.searchKeyWord = keyword;
    [self.searchResults removeAllObjects];
    
    NSArray *arr = [[WeatherUtil sharedUtil] searchCitiesWithKeyword:keyword];
    [self.searchResults addObjectsFromArray:arr];
    [self.tableView reloadData];
}

#pragma mark - Protocol
#pragma mark UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchCity:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self keepSearchBarCancelButtonEnabled];
}
#pragma mark UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchResults count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifierForSearchCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JYCity *city = self.searchResults[indexPath.row];
    if(city.cityType==JYCityTypeInland){//国内城市
        cell.textLabel.text = [NSString stringWithFormat:@"%@-%@-%@",city.province,city.city,city.county];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@-%@(%@)",city.countryNameCN,city.city,city.cityNameEN];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16.f];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([self.searchResults count]==0 && [self.searchKeyWord length]>0){
        return kNoResultViewHeight;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if([self.searchResults count]==0 && [self.searchKeyWord length]>0){
        return self.noResultLabel;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JYCity *city = self.searchResults[indexPath.row];
    
    BOOL exist = NO;
    for(JYCity *c in [WeatherUtil sharedUtil].citiesManualAdded){
        if(c.cityType==JYCityTypeInland){
            if([c.county isEqualToString:city.county]){
                exist = YES;
                break;
            }
        }else if(c.cityType==JYCityTypeWorld){
            if([c.city isEqualToString:city.city]){
                exist = YES;
                break;
            }
        }
    }
    if(exist){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您已添加过该地点了!" message:@"" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationWeatherAddNewCity object:nil userInfo:@{kNewCityKey:city}];
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self keepSearchBarCancelButtonEnabled];
}
#pragma mark - Custom Accessors

- (UISearchBar *)searchBar
{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.showsCancelButton = YES;
        _searchBar.placeholder = @"城市名称(中文/拼音)";
        _searchBar.tintColor = [UIColor whiteColor];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.backgroundImage = [UIImage new];
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
            searchField.tintColor = [UIColor whiteColor];
            searchField.textColor = [UIColor whiteColor];
        }
    }
    return _searchBar;
}
- (UITableView *)tableView
{
    if(!_tableView){
        _tableView = [[UITableView alloc]init];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 40.f;

        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentifierForSearchCell];
    }
    return _tableView;
}
- (NSMutableArray *)searchResults
{
    if(!_searchResults){
        _searchResults = [NSMutableArray array];
    }
    return _searchResults;
}
- (UILabel *)noResultLabel
{
    if(!_noResultLabel){
        _noResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNoResultViewHeight)];
        _noResultLabel.text = @"未找到结果。";
        _noResultLabel.textAlignment = NSTextAlignmentCenter;
        _noResultLabel.textColor = [UIColor whiteColor];
        _noResultLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _noResultLabel;
}
- (UIImageView *)backgroundView
{
    if(!_backgroundView){
        _backgroundView = [UIImageView new];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *imageName = @"天气_背景";
        if(IS_IPHONE_4_SCREEN){
            imageName = [imageName stringByAppendingString:@"_4"];
        }else if(IS_IPHONE_5_SCREEN){
            imageName = [imageName stringByAppendingString:@"_5"];
        }else if(IS_IPHONE_6_SCREEN){
            imageName = [imageName stringByAppendingString:@"_6"];
        }else if(IS_IPHONE_6P_SCREEN){
            imageName = [imageName stringByAppendingString:@"_6p"];
        }
        _backgroundView.image = [UIImage imageNamed:imageName];
    }
    return _backgroundView;
}
@end
