//
//  SearchMapViewController.m
//  JYCalendarNew
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SearchMapViewController.h"


@interface SearchMapViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UITableView *resultTableView;

@property (strong, nonatomic) NSMutableArray *allDataArray;
@property (strong, nonatomic) NSMutableArray *searchResultsArray;

@property (nonatomic,strong) BMKPoiSearch *poisearch;//poi搜索
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
@property (nonatomic) CLLocationCoordinate2D pinLocation; // 接收地理坐标
@property (nonatomic, copy) NSString *keyWords;
@property (nonatomic, strong) UILabel *noResultLabel;

@end

@implementation SearchMapViewController

@synthesize backButton;


-(void)dealloc
{
    NSLog(@"dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allDataArray = [[NSMutableArray alloc]init];
    self.searchResultsArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(2, 25, 45, 30);
    backButton.backgroundColor = [UIColor clearColor];
    backButton.contentMode = UIViewContentModeScaleAspectFit;
    [backButton setImage:[UIImage imageNamed:@"map_back"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(pressCloseButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(backButton.right + 1, 25, kScreenWidth-backButton.right - 15, 30)];
    _searchBar.placeholder = @"输入地址关键字";
    _searchBar.delegate = self;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.keyboardType = UIReturnKeyDone;
    
    UITextField *searchField = [_searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 5.0f;
        searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        searchField.layer.borderWidth = 0.5;
        searchField.layer.masksToBounds = YES;
    }
    [_searchBar fm_setCancelButtonTitle:@"取消"];
    _searchBar.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
    [_searchBar fm_setCancelButtonFont:[UIFont systemFontOfSize:16.0]];
    [searchField setTintColor:[UIColor blueColor]];
    [_searchBar fm_setTextColor:[UIColor blackColor]];
    [_searchBar fm_setTextFont:[UIFont systemFontOfSize:16.0]];
    [self.view addSubview:_searchBar];
    [_searchBar becomeFirstResponder];
    
    
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _searchBar.bottom + 7.5, kScreenWidth, 0.5)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLabel];
    
    
    _resultTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, lineLabel.bottom + 0.5, kScreenWidth, kScreenHeight - lineLabel.bottom + 0.5)];
    _resultTableView.delegate=self;
    _resultTableView.dataSource=self;
    _resultTableView.hidden = YES;
    _resultTableView.tableFooterView = [[UIView alloc]init];
    _resultTableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_resultTableView];
    
    
    _noResultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, (kScreenHeight/2.0)- 20, kScreenWidth, 40)];
    _noResultLabel.text = @"无结果";
    _noResultLabel.textAlignment = NSTextAlignmentCenter;
    _noResultLabel.font = [UIFont systemFontOfSize:22];
    _noResultLabel.textColor = [UIColor blackColor];
    _noResultLabel.hidden = YES;
    [self.view addSubview:_noResultLabel];

    // 获取附近的poi地址，先要发送一个地址给百度，然后才能返回检索数据。
    _pinLocation.latitude = 39.915;
    _pinLocation.longitude = 116.404;
    
    
    // 搜索过之后再次进入
    if (![self.keywordString isEqualToString:@""] && ![self.keywordString isEqualToString:@"搜地点"]) {
        self.searchBar.text = self.keywordString;
        self.keyWords = self.keywordString;
        [self searchWithKeyword:self.keywordString];
    }
    
}
- (void)pressCloseButton{
    // 暂时先这么写    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.f];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.numberOfLines = 0;
    BMKPoiInfo *info = self.searchResultsArray[indexPath.row];
    NSRange  range = [info.name rangeOfString:_keyWords];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:info.name];
        [str addAttribute:NSForegroundColorAttributeName value:[JYSkinManager shareSkinManager].colorForDateBg range:NSMakeRange(range.location,range.length)];       
        cell.textLabel.attributedText = str;
        
    }else{
        cell.textLabel.text = info.name;
        
    }
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.text = info.address;

    return cell;
    
}
// 计算label的高度                                                                                         
- (CGFloat)labelHeightWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth-10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return rect.size.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *info = self.searchResultsArray[indexPath.row];
    NSString *nameString = info.name;
    NSString *addressStr = info.address;
    CGFloat nameHeight = [self labelHeightWithText:nameString font:[UIFont systemFontOfSize:15.0]];
    CGFloat addHeight = [self labelHeightWithText:addressStr font:[UIFont systemFontOfSize:12.0]];
    
    return nameHeight + addHeight + 25;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BMKPoiInfo *info = self.searchResultsArray[indexPath.row];
    _actionForSelectedLoc(info);
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (BMKPoiSearch *)poisearch
{
    if(!_poisearch){
        _poisearch = [[BMKPoiSearch alloc]init];
        _poisearch.delegate = self;
    }
    return _poisearch;
}

- (void)searchWithKeyword:(NSString *)keyword
{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.keyword = keyword;
    option.location = self.pinLocation;
    [self.poisearch poiSearchNearBy:option];
}

#pragma mark BMKPoiSearchDelegate
//POI搜索结果
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
        
        if (errorCode == BMK_SEARCH_NO_ERROR) {
            
            [self.searchResultsArray removeAllObjects];

            for(int i = 0; i < poiResult.poiInfoList.count; i++) {
                BMKPoiInfo* poi = [poiResult.poiInfoList objectAtIndex:i];
                BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
                item.coordinate = poi.pt;
                item.title = poi.name;
                //            NSLog(@"%@",poi.name);
                [self.searchResultsArray addObject:poi];
            }
            if (self.searchResultsArray.count > 0) {
                self.resultTableView.hidden = NO;
                self.noResultLabel.hidden = YES;
                [self.resultTableView reloadData];   
            }
            
            // 判断删除关键字时，返回数据缓慢问题，会出现关键字为空，但是列表还有数据情况
            // 返回数据了，如果这时候关键字为空就删除数据，重置状态
            if ([_keyWords isEqualToString:@""]) {
                [self.searchResultsArray removeAllObjects];
                self.resultTableView.hidden = YES;
                self.noResultLabel.hidden = YES;
                [self.resultTableView reloadData];
            }
            
            
        } else {
            
            [self.searchResultsArray removeAllObjects];
            self.resultTableView.hidden = YES;
            self.noResultLabel.hidden = NO;
            [self.resultTableView reloadData];
            //        NSLog(@"onGetPoiResult 错误");
        }
    
}

#pragma mark -----
#pragma mark UISearchBarDelegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _keyWords = searchText;
    if ([searchText isEqualToString:@""]) {
        [self.searchResultsArray removeAllObjects];
        self.resultTableView.hidden = YES;
        [self.resultTableView reloadData];
        
    }else{
        [self searchWithKeyword:searchText];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _keyWords = searchBar.text;
    if ([searchBar.text isEqualToString:@""]) {
        [self.searchResultsArray removeAllObjects];
        self.resultTableView.hidden = YES;
        [self.resultTableView reloadData];
 
    }else{
        [self searchWithKeyword:searchBar.text];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar 
{
    if ([searchBar.text isEqualToString:@""]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }else{
        [self.searchBar resignFirstResponder];
        [searchBar setShowsCancelButton:NO animated:YES];
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO animated:YES];
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
