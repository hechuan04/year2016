//
//  ImageViewController.m
//  JYCalendarNew
//
//  Created by 吴冬 on 16/2/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "ImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageCollectionCell.h"

static NSString *imageTableViewCell = @"imageTableViewCell";

@interface ImageViewController ()
{
 
    ALAssetsLibrary  *_library;
    UICollectionView *_tableView;
    NSMutableArray   *_arrForAllImage;
    NSArray *_arrForAllImageSorted;
    NSMutableArray   *_groupArrImage;
    NSMutableArray   *_arrForFourImage;
    
}
@end

@implementation ImageViewController

- (void)rightAction
{
 
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"图片";
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    
    UIButton *btnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnView addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    btnView.frame = CGRectMake(0, 0, 50, 50);
    //btnView.backgroundColor = [UIColor orangeColor];
    [btnView setTitle:@"取消" forState:UIControlStateNormal];
    [btnView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnView setTitleColor:[JYSkinManager shareSkinManager].colorForDateBg forState:UIControlStateNormal];
    

    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btnView];
    
    self.navigationItem.rightBarButtonItem = right;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, 0.5)];
    lineView.backgroundColor = lineColor;
    [self.view addSubview:lineView];
    
    
    _arrForAllImage = [NSMutableArray array];
    
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
    
    [_tableView registerClass:[ImageCollectionCell class] forCellWithReuseIdentifier:imageTableViewCell];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    ImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageTableViewCell forIndexPath:indexPath];
   
    ImageCollectionCell *selectCell = (ImageCollectionCell *)cell;
    
    ALAsset *alasset = [_arrForAllImageSorted objectAtIndex:indexPath.row];
    
    CGImageRef cmimg = [alasset thumbnail];
    
    UIImage *img = [UIImage imageWithCGImage:cmimg];
    
    selectCell.imageV.image = img;
    
    return cell;

}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    ALAsset *alasset = [_arrForAllImageSorted objectAtIndex:indexPath.row];
    
    CGImageRef cmimg = [alasset thumbnail];
    
    UIImage *img = [UIImage imageWithCGImage:cmimg];
    
    UIImage *fullImg = [UIImage imageWithCGImage:alasset.defaultRepresentation.fullScreenImage];
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(_actionForPassPic){
            _actionForPassPic(img);
        }else if(_actionForPassFullPic){
            _actionForPassFullPic(fullImg);
        }
    }];
    
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

@end
