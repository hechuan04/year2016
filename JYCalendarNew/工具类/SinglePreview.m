//
//  SinglePreview.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "SinglePreview.h"
@interface SinglePreview()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation SinglePreview

+ (SinglePreview*)sharedView {
    static dispatch_once_t once;
    
    static SinglePreview *sharedView;
    dispatch_once(&once, ^{
        sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
    });
    
    return sharedView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor blackColor];
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 4.f;
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_scrollView addSubview:_imageView];
        
        //tap
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - Public
+ (void)showWithImageUrlString:(NSString *)urlString
{
    [[self sharedView]showWithImageUrlString:urlString];
}

#pragma mark - Private
- (void)showWithImageUrlString:(NSString *)urlString
{
    if(!urlString||[urlString isEqualToString:@""]){
        return;
    }
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"相册默认图片"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(image){
            self.imageView.image = image;
            
        }else{
            self.imageView.image = [UIImage imageNamed:@"相册默认图片"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initZoomScale];
        });
    }];
    [self initZoomScale];
}
- (void)hide
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    SinglePreview *preview = [SinglePreview sharedView];
    preview.imageView.image = nil;
    [preview removeFromSuperview];
}
- (void)initZoomScale
{
    self.scrollView.zoomScale = 1;
    
    CGFloat widthScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    CGFloat heightScale = self.scrollView.bounds.size.height / self.imageView.image.size.height;
//    CGFloat minScale = MIN(MIN(widthScale, heightScale),1);
    CGFloat minScale = MIN(widthScale, heightScale);
    
    self.scrollView.contentSize = self.imageView.image.size;
    self.imageView.frame = CGRectMake(0, 0, self.imageView.image.size.width, self.imageView.image.size.height);
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.zoomScale = minScale;
    
    [self adjustImageViewCenter];
}
- (void)adjustImageViewCenter
{
    CGFloat yOffset = MAX(0, (self.scrollView.bounds.size.height - self.imageView.image.size.height*self.scrollView.zoomScale) / 2);
    CGFloat xOffset = MAX(0, (self.scrollView.bounds.size.width - self.imageView.image.size.width*self.scrollView.zoomScale) / 2);
    self.imageView.frame = CGRectMake(xOffset, yOffset, self.imageView.image.size.width*self.scrollView.zoomScale, self.imageView.image.size.height*self.scrollView.zoomScale);
    
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self adjustImageViewCenter];
}

@end
