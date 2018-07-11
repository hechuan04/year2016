//
//  JYCollectionVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCollectionVC.h"
#import "CollectionCell.h"
#import "RemindCollectionModel.h"
#import "JYRemindNoPassPeopleVC.h"

#define kSearchBarHeight 44.f
#define kRowHeight 60.f
static NSString *kCellIdentifierForCollection = @"kCellIdentifierForCollection";
static NSString *kCellIdentifierForFilterData = @"kCellIdentifierForFilterData";

@interface JYCollectionVC ()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *collectionArray;//of RemindCollectionModel
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic,strong) UISearchBar *searchBarView;
@property (nonatomic,strong) NSMutableArray *filterArray;
@property (nonatomic,strong) NSIndexPath *deletedIndexPath;

@property (nonatomic,strong) UIImageView *emptyView;
@end

@implementation JYCollectionVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setAutomaticallyAdjustsScrollViewInsets:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];

    self.title = @"提醒事项";

    [self.view addSubview:self.searchBarView];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.emptyView];
    
    [self requestCollectionData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)dealloc
{
    NSLog(@"====delloc");
}
#pragma mark - Private
- (void)actionForLeft:(UIButton *)sender{
    NSLog(@"");
//    [self.tableView reloadData];
    self.tableView.editing = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  请求个人收藏数据
 */
- (void)requestCollectionData{
    
    [self.collectionArray removeAllObjects];
    
    __weak typeof(self) weakSelf = self;

    [RequestManager requestCollectionDataWithCompletedBlock:^(id data, NSError *error) {
        NSArray *array = (NSArray *)data;
        if(array){
            for(int i=0;i<[array count];i++){
                RemindCollectionModel *m = [[RemindCollectionModel alloc]initWithDictionary:array[i]];
                [weakSelf.collectionArray addObject:m];
            }
            [weakSelf.tableView reloadData];
            if([array count]>0){
                 weakSelf.emptyView.hidden = YES;
            }else{
                 weakSelf.emptyView.hidden = NO;
            }
        }else{
             weakSelf.emptyView.hidden = NO;
        }

    }];
}
/**
 *  过滤收藏数据
 *
 *  @param keyword 关键词
 */
- (void)filterRemindWithKeyword:(NSString *)keyword{
    [self.filterArray removeAllObjects];
    
    for(RemindCollectionModel *model in self.collectionArray){
        if([[model.senderName lowercaseString] rangeOfString:[keyword lowercaseString]].location!= NSNotFound || [[model.title lowercaseString] rangeOfString:[keyword lowercaseString]].location!= NSNotFound ){
            [self.filterArray addObject:model];
        }
    }
    
}
/**
 *  删除一条收藏
 *
 *  @param mId 资源id
 */
- (void)deleteCollectionDataWithId:(NSInteger)sId{
    __weak typeof(self) weakSelf = self;
    [RequestManager deleteCollectionDataWithId:sId completedBlock:^(id data, NSError *error) {
        [weakSelf.collectionArray removeObjectAtIndex:weakSelf.deletedIndexPath.row];
        if(self.collectionArray.count==0){
            [self.tableView reloadData];
            weakSelf.emptyView.hidden = NO;
        }else{
            [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:weakSelf.deletedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}
#pragma mark - Protocol
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView==self.tableView){
        return [self.collectionArray count];
    }
    
    return [self.filterArray count];//过滤后的数据
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==self.tableView){
        
        CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierForCollection];
        cell.remindModel = self.collectionArray[indexPath.row];
        return cell;
        
    }else{//过滤后的数据
        
        CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifierForFilterData];
        cell.remindModel = self.filterArray[indexPath.row];
        return cell;
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView==self.tableView){
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        self.deletedIndexPath = indexPath;
        RemindCollectionModel *model = self.collectionArray[indexPath.row];
        [self deleteCollectionDataWithId:model.sid];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JYRemindNoPassPeopleVC *detailVC = [[JYRemindNoPassPeopleVC alloc]init];
    RemindCollectionModel *model = self.collectionArray[indexPath.row];
    NSString *xiaomiID = [[NSUserDefaults standardUserDefaults] objectForKey:kUserXiaomiID];
    detailVC.isFromOther = ![model.senderUid isEqualToString:xiaomiID];
    detailVC.mid = model.mid;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    
    [self filterRemindWithKeyword:searchString];
    return YES;
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
}
-(void)searchDisplayController:(UISearchDisplayController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillHide:(NSNotification*)notification {
    CGFloat height = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    UIEdgeInsets inset;
    [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? (inset = UIEdgeInsetsMake(0, 0, height, 0)) : (inset = UIEdgeInsetsZero);
    [tableView setContentInset:inset];
    [tableView setScrollIndicatorInsets:inset];
}
#pragma mark - Custom Accessors
- (UISearchBar *)searchBarView{
    if(!_searchBarView){
        _searchBarView = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width                                                          , kSearchBarHeight)];
        _searchBarView.placeholder = @"搜索";
        _searchBarView.tintColor = [JYSkinManager shareSkinManager].colorForDateBg;
        _searchBarView.backgroundImage = [UIImage new];
        UITextField *searchField=[((UIView *)[_searchBarView.subviews objectAtIndex:0]).subviews lastObject];
        if(searchField){
            searchField.layer.borderColor = [UIColor lightGrayColor].CGColor;
            searchField.layer.borderWidth = 0.5f;
            searchField.layer.cornerRadius = 5.f;
            searchField.layer.masksToBounds = YES;
        }
        
        _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBarView contentsController:self];
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        _searchDisplayController.delegate = self;
        _searchDisplayController.searchResultsTableView.rowHeight = kRowHeight;
        [_searchDisplayController.searchResultsTableView registerClass:[CollectionCell class]forCellReuseIdentifier:kCellIdentifierForFilterData];
        _searchDisplayController.searchResultsTableView.tableFooterView = [UIView new];
    }
    return _searchBarView;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,kSearchBarHeight,kScreenWidth, kScreenHeight-kSearchBarHeight-66) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kRowHeight;
        _tableView.tableFooterView = [UIView new];
        
        [_tableView registerClass:[CollectionCell class] forCellReuseIdentifier:kCellIdentifierForCollection];
        
    }
    return _tableView;
}

- (NSMutableArray *)collectionArray{
    if(!_collectionArray){
        _collectionArray = [NSMutableArray array];
    }
    return _collectionArray;
}

- (NSMutableArray *)filterArray{
    if(!_filterArray){
        _filterArray = [NSMutableArray array];
    }
    return _filterArray;
}
- (UIImageView *)emptyView{
    if(!_emptyView){
        _emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无收藏"]];
        CGFloat imgWidth = 397/750.0*kScreenWidth;
        CGFloat imgHeight = 311/1334.0*kScreenHeight;
        _emptyView.frame = CGRectMake(kScreenWidth/2.0 - imgWidth/2.0, 240/1334.0*kScreenHeight, imgWidth, imgHeight);
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
