//
//  JYPhotoVC.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/17.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYPhotoVC.h"
#import "JYPhotoCell.h"
#import "PhotoHeaderView.h"
#import "PhotoGroup.h"
#import "PhotoItem.h"
#import "SDPhotoBrowser.h"

#define kCellVerMargin 5.f
#define kCellHorMargin 5.f
#define kCollectionMargin 5.f
#define kSectionHeight 40.f
#define kColumnCount 3

#define kDeleteSureTag 10001

static NSString *kPhotoHeaderIdentifier = @"photoHeaderIdentifier";

@interface JYPhotoVC ()<UICollectionViewDataSource,UICollectionViewDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;//of PhotoGroup

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIButton *editButton;
@property (nonatomic,strong) UIButton *deleteButton;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) UIImageView *emptyView;
@property (nonatomic,strong) NSMutableArray *checkedPhotoItems;

//@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@end

@implementation JYPhotoVC

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [self.view addSubview:self.emptyView];

    
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc]initWithCustomView:self.editButton],[[UIBarButtonItem alloc]initWithCustomView:self.deleteButton]];
    [self requestPhotoData];
}
- (void)dealloc
{
    NSLog(@"====delloc");
}
#pragma mark - Public


#pragma mark - Private
- (void)editBtnClicked:(UIButton *)sender{
    [self changeEditStatus];
}
- (void)longPressToDo:(UIGestureRecognizer *)sender{
    if(sender.state==UIGestureRecognizerStateBegan){
        [self changeEditStatus];
    }
}
- (void)changeEditStatus{
    _isEditing = !_isEditing;
    self.editButton.selected = _isEditing;
    self.deleteButton.hidden = !_isEditing;
    
    for(PhotoGroup *group in self.dataArray){
        for(PhotoItem *item in group.photoItems){
            item.isSelected = NO;
        }
    }
    [self.checkedPhotoItems removeAllObjects];
    [self.collectionView reloadData];
}
- (void)deleteBtnClicked:(UIButton *)sender
{
    NSLog(@"%@",[self.checkedPhotoItems valueForKey:@"pId"]);
    if([self.checkedPhotoItems count]==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"未选中任何照片,请重新选择！" message:@"" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否确认删除?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = kDeleteSureTag;
        [alertView show];
    }
}
/**
 *  请求相册数据
 */
- (void)requestPhotoData{
    [self.dataArray removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    [RequestManager requestPhotoDataWithCompletedBlock:^(id data, NSError *error) {
        NSArray *array = (NSArray *)data;
        if(array){
            for(int i=0;i<[array count];i++){
                PhotoGroup *group = [[PhotoGroup alloc]initWithDictionary:array[i]];
                [weakSelf.dataArray addObject:group];
            }
            
            if([weakSelf.dataArray count]==0){
                weakSelf.editButton.hidden = YES;
                weakSelf.emptyView.hidden = NO;
            }else{
                weakSelf.editButton.hidden = NO;
                weakSelf.emptyView.hidden = YES;
            }
            [weakSelf.collectionView reloadData];
        }else{
            weakSelf.emptyView.hidden = NO;
        }

    }];
    
}
/**
 *  删除相片/批量
 *
 *  @param hId 相片id
 */
- (void)deletePhotoWithIdStr:(NSString *)str{
    
    __weak typeof(self) weakSelf = self;
    
     NSLog(@"pid===%@",[self.checkedPhotoItems valueForKey:@"pId"]);
    [RequestManager deletePhotoWithIdStr:str completedBlock:^(id data, NSError *error) {
        
//        [weakSelf.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            
//            PhotoGroup *group = obj;
//            NSMutableArray *tmpArray = [NSMutableArray array];
//            for(PhotoItem *item in group.photoItems){
//                if([weakSelf.checkedPhotoItems containsObject:item]){
//                    [tmpArray addObject:item];
//                }
//            }
//            [group.photoItems removeObjectsInArray:tmpArray];
//            
//            if([group.photoItems count]==0){
//                [weakSelf.dataArray removeObjectAtIndex:idx];
//            }else{
//                [weakSelf.dataArray replaceObjectAtIndex:idx withObject:group];
//            }
//            
// 
//        }];
        
        
        [weakSelf changeEditStatus];
       
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf changeEditStatus];
//            //数组已空，编辑、删除按钮状态改变
//            if(weakSelf.dataArray.count==0){
//                weakSelf.emptyView.hidden = NO;
//            }else{
//                weakSelf.emptyView.hidden = YES;
//            }
//        });
        
        [weakSelf requestPhotoData];
        
    }];
}
#pragma mark - Protocol
#pragma mark - UICollectionViewDelegate/UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.dataArray count];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    PhotoGroup *group = self.dataArray[section];
    return [group.photoItems count];
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        PhotoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPhotoHeaderIdentifier forIndexPath:indexPath];
        
        PhotoGroup *group = self.dataArray[indexPath.section];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy年MM月dd日";
        headerView.dateLabel.text = [formatter stringFromDate:group.createdTime];

        reusableview = headerView;
    }
    return reusableview;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    PhotoGroup *group = self.dataArray[indexPath.section];
    PhotoItem *item = group.photoItems[indexPath.row];
    cell.photoItem = item;
    cell.isEditing = self.isEditing;
    cell.isSelected = item.isSelected;
    cell.containerVC = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    JYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([self class]) forIndexPath:indexPath];
    PhotoGroup *group = self.dataArray[indexPath.section];
    PhotoItem *item = group.photoItems[indexPath.row];
    
    if(self.isEditing){
        
        if([self.checkedPhotoItems containsObject:item]){
            [self.checkedPhotoItems removeObject:item];
            item.isSelected = NO;
        }else{
            [self.checkedPhotoItems addObject:item];
            item.isSelected = YES;
        }
        [self.collectionView reloadData];
    }else{
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.sourceImagesContainerView = self.collectionView;
        browser.imageCount = [group.photoItems count];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy年MM月dd日";
        browser.timeString = [formatter stringFromDate:group.createdTime];
        browser.currentImageIndex = indexPath.row;
        browser.indexPath = indexPath;
        browser.delegate = self;
        [browser show];
    }
}
#pragma mark - SDPhotoBrowserDelegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:browser.indexPath.section];
    JYPhotoCell *cell = (JYPhotoCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    if(cell){
        UIImage *image = cell.photoImageView.image;
        return image;
    }else{
        return [UIImage imageNamed:@"相册默认图片"];
    }
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    PhotoGroup *group = self.dataArray[browser.indexPath.section];
    PhotoItem *item = group.photoItems[index];
    NSURL *url = [NSURL URLWithString:item.photoUrl];
    return url;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == kDeleteSureTag){
        if(buttonIndex==1){
            NSArray *pids = [self.checkedPhotoItems valueForKey:@"pId"];
            NSString *strForDelete = [pids componentsJoinedByString:@","];
            [self deletePhotoWithIdStr:strForDelete];
        }
    }
}
#pragma mark - Custom Accessors
- (UICollectionView *)collectionView{
    
    if(!_collectionView){

        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[JYPhotoCell class] forCellWithReuseIdentifier:NSStringFromClass([self class])];
        [_collectionView registerClass:[PhotoHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kPhotoHeaderIdentifier];
        _collectionView.contentInset = UIEdgeInsetsMake(5.f, 0, 0, 0);
        UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
        [_collectionView addGestureRecognizer:longPressGr];
        
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = kCellVerMargin;
        _flowLayout.minimumInteritemSpacing = kCellHorMargin;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, kCollectionMargin,0, kCollectionMargin);
        _flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, kSectionHeight);
        
        NSInteger columnNum = kColumnCount;
        CGFloat itemWidth = (kScreenWidth-kCellHorMargin*(columnNum-1)-kCollectionMargin*2)/columnNum;
        _flowLayout.itemSize = CGSizeMake(itemWidth,itemWidth);

    }
    return _flowLayout;
}
- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UIButton *)editButton{
    
    if(!_editButton){
        _editButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f,0.f,40.f, 40.f)];
        [_editButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitle:@"完成" forState:UIControlStateSelected];
        [_editButton addTarget:self action:@selector(editBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}
- (UIButton *)deleteButton{
    
    if(!_deleteButton){
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f,0.f,40.f, 40.f)];
        [_deleteButton setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.hidden = YES;
    }
    return _deleteButton;
}
- (UIImageView *)emptyView{
    if(!_emptyView){
        CGFloat imgWidth = 577/750.0*kScreenWidth;
        CGFloat imgHeight = 312/1334.0*kScreenHeight;
        _emptyView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"空视图_无相片"]];
        _emptyView.hidden = YES;
        _emptyView.frame = CGRectMake(kScreenWidth/2.0 - imgWidth/2.0, 240/1334.0*kScreenHeight, imgWidth, imgHeight);
        
    }
    return _emptyView;
}
- (NSMutableArray *)checkedPhotoItems
{
    if(!_checkedPhotoItems){
        _checkedPhotoItems = [NSMutableArray array];
    }
    return _checkedPhotoItems;
}
@end
