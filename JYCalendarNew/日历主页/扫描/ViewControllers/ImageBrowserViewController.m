//
//  ImageBrowserViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "UIImageView+WebCache.h"

@interface ImageBrowserViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ImageBrowserViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self customNavView];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    self.navigationItem.title = self.imageFile.name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageFile.imageUrlStr] placeholderImage:[UIImage imageNamed:@"相册默认图片"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGSize size = image.size;
        CGFloat ratioW = self.view.bounds.size.width / size.width;
        CGFloat ratioH = self.view.bounds.size.height / size.height;
        CGFloat minScale = MIN(ratioW, ratioH);
        self.scrollView.zoomScale = minScale;
    }];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - Public


#pragma mark - Private
- (void)customNavView
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑 " style:UIBarButtonItemStylePlain target:self action:@selector(editButtonClicked:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}
- (void)editButtonClicked:(UIButton *)sender
{
    NSLog(@"===");
}
- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Protocol
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

#pragma mark - Custom Accessors

- (UIScrollView *)scrollView
{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 3.f;
//        _scrollView.minimumZoomScale = 1.f;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc]init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _imageView;
}
@end
