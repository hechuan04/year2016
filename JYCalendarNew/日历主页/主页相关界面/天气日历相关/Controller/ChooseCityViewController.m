//
//  ChooseCityViewController.m
//  JYCalendarNew
//
//  Created by Zhangjing on 2017/3/29.
//  Copyright © 2017年 北京金源互动科技有限公司. All rights reserved.
//

#import "ChooseCityViewController.h"
#import "WeatherUtil.h"

#define kNoResultViewHeight 100.f
#define kShowWeatherCount 5
static NSString *kIdentifierForSearchCell = @"kIdentifierForSearchCell";

@interface ChooseCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UITableView *cityTableView;
@property (nonatomic,strong) UISearchBar *citySearchBar;
@property (nonatomic,strong) NSMutableArray *searchResults;
@property (nonatomic,strong) UILabel *noResultLabel;
@property (nonatomic,strong) NSString *searchKeyWord;

@end

@implementation ChooseCityViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.citySearchBar becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self p_setupSubViews];
}
- (void)p_setupSubViews{
    
    UILabel *inputLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    inputLabel.backgroundColor = [UIColor clearColor];
    inputLabel.text = @"请输入城市名称";
    inputLabel.font = [UIFont systemFontOfSize:16.f];
    inputLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:inputLabel];
    
    [self.view addSubview:self.citySearchBar];
    [self.view addSubview:self.cityTableView];

}
#pragma mark - Custom Accessors

- (UISearchBar *)citySearchBar
{
    if(!_citySearchBar){
        _citySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(20, 64, kScreenWidth-40, 44)];
        _citySearchBar.delegate = self;
        _citySearchBar.showsCancelButton = YES;
        _citySearchBar.placeholder = @"城市名称(中文/拼音)";
        _citySearchBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
//        _citySearchBar.barTintColor = [UIColor greenColor];
        _citySearchBar.backgroundImage = [UIImage new];
        _citySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        UITextField *searchField = [_citySearchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
//            searchField.tintColor = [UIColor yellowColor];
//            searchField.textColor = [UIColor cyanColor];
        }
    }
    return _citySearchBar;
}
- (UITableView *)cityTableView
{
    if(!_cityTableView){
        _cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _citySearchBar.bottom, kScreenWidth, kScreenHeight-_citySearchBar.bottom) style:(UITableViewStylePlain)];
        _cityTableView.showsVerticalScrollIndicator = NO;
        _cityTableView.dataSource = self;
        _cityTableView.delegate = self;
        _cityTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _cityTableView.backgroundColor = [UIColor whiteColor];
        _cityTableView.rowHeight = 40.f;
        _cityTableView.tableFooterView = [[UIView alloc]init];
        
        _cityTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_cityTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentifierForSearchCell];
    }
    return _cityTableView;
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
//        _noResultLabel.textColor = [UIColor whiteColor];
        _noResultLabel.font = [UIFont systemFontOfSize:16.f];
    }
    return _noResultLabel;
}

#pragma mark EventHandle
- (void)keepSearchBarCancelButtonEnabled
{
    //键盘消失继续保持searchbar 取消按钮可点击
    for (UIView *view in self.citySearchBar.subviews)
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
    [self.cityTableView reloadData];
}

#pragma mark - Protocol

#pragma mark UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.citySearchBar resignFirstResponder];
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
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [UIColor clearColor];
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
    NSLog(@"11111111111%@",city.city);
    
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kChooseCityWeatherNotification object:nil userInfo:@{kChooseCityKey:city}];
    }];    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self keepSearchBarCancelButtonEnabled];
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
