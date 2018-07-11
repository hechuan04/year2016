//
//  JYBatchSelectionVC.m
//  JYCalendarNew
//
//  Created by mac on 16/3/21.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYBatchSelectionVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JYBatchSelectionCell.h"

static NSString *batchSelectionCell = @"JYBatchSelectionCell";


@interface JYBatchSelectionVC ()
{
    
    ALAssetsLibrary  *_library;
    UICollectionView *_tableView;
    NSMutableArray   *_arrForAllImage;
    NSArray   *_arrForAllImageSorted;
    NSMutableArray   *_groupArrImage;
    NSMutableArray   *_arrForFourImage;
    NSMutableDictionary *_imageDic;
    
}
@property (nonatomic,strong) NSMutableArray *checkedIndexPathArray;
@end

@implementation JYBatchSelectionVC

- (void)rightAction
{
    
    NSArray * tmpArr = [_imageDic allValues];
    
    _actionBatchSelection(tmpArr);
    
//    NSLog(@"回传的照片:%@",tmpArr);
    
    [_imageDic removeAllObjects];
    
    _imageCount = 0;

    
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
- (void)leftAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    self.navigationItem.title = @"图片";

    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    
    
    UIButton *leftBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtnView addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtnView.frame = CGRectMake(0, 0, 50, 50);
    [leftBtnView setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:leftBtnView];
    self.navigationItem.leftBarButtonItem = left;
    
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    [btnView setTitle:@"保存" forState:UIControlStateNormal];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    self.navigationItem.rightBarButtonItem = right;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
    lineView.backgroundColor = lineColor;
    [self.view addSubview:lineView];
    
    
    _arrForAllImage = [NSMutableArray array];
    _imageDic = [NSMutableDictionary dictionary];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _library = [[ALAssetsLibrary alloc] init];
    
    [_library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group != nil) {
            
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                
                if (result != nil) {
                    
                    [_arrForAllImage addObject:result];
                    
                }
                
            }];
            
            
        }
        
        if (stop) {
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            _arrForAllImageSorted = [_arrForAllImage sortedArrayUsingDescriptors:@[sort]];
            [_tableView reloadData];
            
        }
        
    } failureBlock:^(NSError *error) {
        
        
        
    }];
    
    [self _creatTableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)_creatTableView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 4.f;
    flowLayout.minimumInteritemSpacing = 4.f;
    CGFloat width = (kScreenWidth - 4*3) / 4.0;
    flowLayout.itemSize = CGSizeMake(width, width);
    
    _tableView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 70, kScreenWidth, kScreenHeight - 70) collectionViewLayout:flowLayout];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[JYBatchSelectionCell class] forCellWithReuseIdentifier:batchSelectionCell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JYBatchSelectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:batchSelectionCell forIndexPath:indexPath];
    
    JYBatchSelectionCell *selectCell = (JYBatchSelectionCell *)cell;
    
    ALAsset *alasset = [_arrForAllImageSorted objectAtIndex:indexPath.row];
    
    CGImageRef cmimg = [alasset thumbnail];
    
    UIImage *img = [UIImage imageWithCGImage:cmimg];
    
    selectCell.imageV.image = img;
    
    if([self.checkedIndexPathArray containsObject:@(indexPath.row)]){
        selectCell.selectedBtn.selected = YES;
    }else{
        selectCell.selectedBtn.selected = NO;
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    
//    获得的ALAsset对象就是相片对象：其中有相片的缩略图，全屏图，高清图，url等属性。
//    
//    ALAsset *result = [assets objectAtIndex:index];
//    
//    获取url：
//    
//    String类型：
//    
//    NSString *url = [[[result defaultRepresentation]url]description];                     
//    
//    URL类型：
//    
//    NSURL *url = [[result defaultRepresentation]url];
//    
//    获取缩略图：
//    
//    CGImageRef  ref = [result thumbnail];
//    
//    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
//    
//    获取全屏相片：
//    
//    CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
//    
//    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
//    
//    获取高清相片：
//    
//    CGImageRef ref = [[result  defaultRepresentation]fullResolutionImage];
//    
//    UIImage *img = [[UIImage alloc]initWithCGImage:ref];
    
    
    
//    JYBatchSelectionCell * cell1 = (JYBatchSelectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    ALAsset *alasset = [_arrForAllImageSorted objectAtIndex:indexPath.row];
    
    CGImageRef cmimg = [[alasset  defaultRepresentation]fullScreenImage];
    
    UIImage *img = [UIImage imageWithCGImage:cmimg];
    
    
    if([self.checkedIndexPathArray containsObject:@(indexPath.row)]){
        [self.checkedIndexPathArray removeObject:@(indexPath.row)];
        NSArray * tmpArr = [_imageDic allKeys];
        NSString * tmpStr = [NSString stringWithFormat:@"%ld",indexPath.row];
        if (tmpStr&&[tmpArr containsObject:tmpStr]) {
            [_imageDic removeObjectForKey:tmpStr];
            
        }
        
    }else{
        if ([self.checkedIndexPathArray count] >= self.limitCount) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"照片最多可选8张" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            return;
        }
        [self.checkedIndexPathArray addObject:@(indexPath.row)];
        [_imageDic setValue:img forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];

    }
    
    [collectionView reloadData];
//    if (cell1.selectedBtn.selected) {
//        
//        NSArray * tmpArr = [_imageDic allKeys];
//        NSString * tmpStr = [NSString stringWithFormat:@"%ld",indexPath.row];
//        if (tmpStr&&[tmpArr containsObject:tmpStr]) {
//            [_imageDic removeObjectForKey:tmpStr];
//
//        }
//        _imageCount --;
//        
//    }else{
    
//        _imageCount ++;
//        
//        if (_imageCount > 8) {
//            
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"照片最多可选8张" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
//            return;
//        }
//        [_imageDic setValue:img forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];
//
//    }
//    cell1.selectedBtn.selected = !cell1.selectedBtn.selected;
    
    
}

- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return _arrForAllImageSorted.count;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
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
- (NSMutableArray *)checkedIndexPathArray
{
    if(!_checkedIndexPathArray){
        _checkedIndexPathArray = [NSMutableArray array];
    }
    return _checkedIndexPathArray;
}
@end
