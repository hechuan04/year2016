//
//  PhotoPreviewViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/24.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "PhotoPreviewViewController.h"
#import "Masonry.h"
#import "PhotoEditorViewController.h"
#import "ScanFile.h"
#import "ScanUtil.h"

#define kToolBarHeight 80.f

@interface PhotoPreviewViewController ()

@property (nonatomic,strong) UIImageView *photoView;
@property (nonatomic,strong) UIView *toolBarView;

@end

@implementation PhotoPreviewViewController


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupSubview];
    [self refreshData];
//    if(self.applyBlackWhiteFilter){
//        [self applyFilter];
//    }else{
//        [self refreshData];
//    }
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
#pragma mark - Public

#pragma mark - Private
- (void)setupSubview
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.view addSubview:self.photoView];
    [self.view addSubview:self.toolBarView];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
    }];
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.photoView.mas_bottom);
        make.height.equalTo(@(kToolBarHeight));
        make.left.right.bottom.equalTo(self.view);
    }];
}
- (void)refreshData
{
    if(self.photoData){
        UIImage *image = [UIImage imageWithData:self.photoData];
        if(image){
            self.photoView.image = image;
        }
    }
}
- (void)leftButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightButtonClicked:(UIButton *)sender
{
    
    UIImage *image = [UIImage imageWithData:self.photoData];
    PhotoEditorViewController *editorVC = [[PhotoEditorViewController alloc]initWithImage:image];
    
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:editorVC];
//    [self.navigationController presentViewController:nav animated:YES completion:nil];
    [self.navigationController pushViewController:editorVC animated:YES];
}

- (void)applyFilter
{
    
    CIImage *inputImage = [CIImage imageWithData:self.photoData];
    // 2、构建一个滤镜图表
    CIColor *sepiaColor = [CIColor colorWithRed:0 green:0 blue:0];
    // 2.1 先构建一个 CIColorMonochrome 滤镜，并配置输入图像与滤镜参数
    CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome" withInputParameters:@{@"inputColor" : sepiaColor,
                                                                                                     @"inputIntensity":@1.0}];
    [monochromeFilter setValue:inputImage forKey:@"inputImage"];// 通过KVC来设置输入图像
     //2.2 先构建一个 CIVignette 滤镜
    CIFilter *vignetteFilter   = [CIFilter filterWithName:@"CIVignette" withInputParameters:@{@"inputRadius" : @2.0,                                                                  @"inputIntensity" : @1.0}];
    [vignetteFilter setValue:monochromeFilter.outputImage forKey:@"inputImage"];// 以monochromeFilter的输出来作为输入
    
    // 3、得到一个滤镜处理后的图片，并转换至 UIImage
    // 创建一个 CIContext
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    // 将 CIImage 过渡到 CGImageRef 类型
    CGImageRef cgImage = [ciContext createCGImage:vignetteFilter.outputImage fromRect:inputImage.extent];
    // 最后转换为 UIImage 类型
    UIImage *uiImage = [UIImage imageWithCGImage:cgImage];
    
    self.photoView.image = uiImage;
    
    CGImageRelease(cgImage);
}
#pragma mark - Protocol


#pragma mark - Custom Accessors
- (UIImageView *)photoView
{
    if(!_photoView){
        _photoView = [UIImageView new];
        _photoView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photoView;
}
- (UIView *)toolBarView
{
    if(!_toolBarView){
        _toolBarView = [UIView new];
        
        //重拍按钮
        UIButton *leftButton = [UIButton new];
        [leftButton setTitle:@"重拍" forState:UIControlStateNormal];
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        UIImage *img = [UIImage imageNamed:@"扫描_重拍"];
        [leftButton setImage:img forState:UIControlStateNormal];
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(0,-img.size.width,-img.size.height, 0);
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(-leftButton.titleLabel.intrinsicContentSize.height-10, 0, 0, -leftButton.titleLabel.intrinsicContentSize.width);
        leftButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:leftButton];
       
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_toolBarView).offset(20.f);
            make.centerY.equalTo(_toolBarView);
            make.height.equalTo(@(50.f));
        }];
        
        //右边按钮（保存）
        UIButton *rightButton = [UIButton new];
        [rightButton setTitle:@"确认" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        img = [UIImage imageNamed:@"扫描_保存"];
        [rightButton setImage:img forState:UIControlStateNormal];
        rightButton.titleEdgeInsets = UIEdgeInsetsMake(0,-img.size.width,-img.size.height, 0);
        rightButton.imageEdgeInsets = UIEdgeInsetsMake(-rightButton.titleLabel.intrinsicContentSize.height-10, 0, 0, -rightButton.titleLabel.intrinsicContentSize.width);
        rightButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:rightButton];
       
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_toolBarView.mas_right).offset(-20.f);
            make.centerY.equalTo(_toolBarView);
            make.height.equalTo(@(50.f));
        }];

    }
    return _toolBarView;
}


@end
