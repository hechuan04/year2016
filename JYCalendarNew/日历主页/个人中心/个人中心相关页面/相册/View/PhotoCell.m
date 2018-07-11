//
//  PhotoCell.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PhotoCell.h"
#import "PhotoItem.h"

#define kDeleteBtnWidth 25.f
#define kImageViewInitMargin 5.f
@implementation PhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kImageViewInitMargin,kImageViewInitMargin,width-kImageViewInitMargin*2,height-kImageViewInitMargin*2)];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        _photoImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_photoImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPhoto:)];
        [_photoImageView addGestureRecognizer:tap];
        
        
        _deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,kDeleteBtnWidth,kDeleteBtnWidth)];
        _deleteButton.contentMode = UIViewContentModeScaleAspectFill;
        [_deleteButton setImage:[UIImage imageNamed:@"相册删除"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.alpha = 0;
        
    }
    return self;
}
- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGRect fullFrame = CGRectMake(kImageViewInitMargin,kImageViewInitMargin,width-kImageViewInitMargin*2,height-kImageViewInitMargin*2);
    CGRect scaledFrame = CGRectMake(kDeleteBtnWidth/2.f,kDeleteBtnWidth/2.f,width-kDeleteBtnWidth,height-kDeleteBtnWidth);
    
    [UIView animateWithDuration:.25 animations:^{
        _deleteButton.alpha = isEditing?1:0;
        _photoImageView.frame = isEditing?scaledFrame:fullFrame;
    }];
}

- (void)tapPhoto:(UIGestureRecognizer *)sender{
    if(self.isEditing){
//        [self showAlertActionWithBlock:self.deleteActionBlock];
        return;
    }
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = self.contentView;
    browser.imageCount = 1;
    browser.currentImageIndex = 0;
    browser.delegate = self;
    [browser show];
}

- (void)setPhotoItem:(PhotoItem *)photoItem{
    _photoItem = photoItem;
    
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:photoItem.photoUrl] placeholderImage:[UIImage imageNamed:@"相册默认图片"]];
    
}
- (void)deletePhoto:(UIButton *)sender{
//    if(self.deleteActionBlock){
//        self.deleteActionBlock();
//    }
    if([[UIDevice currentDevice].systemVersion floatValue]<8.0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"是否确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
        
    }else{
        [self showAlertActionWithBlock:self.deleteActionBlock];
    }
}

- (void)showAlertActionWithBlock:(void(^)())block{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确认删除?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(block){
            block();
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    
    [self.containerVC presentViewController:alertController animated:YES completion:nil];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(self.deleteActionBlock){
            self.deleteActionBlock();
        }
    }
}
#pragma mark - SDPhotoBrowserDelegate
// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    UIImage *image = self.photoImageView.image;
    return image;
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    NSURL *url = [NSURL URLWithString:self.photoItem.photoUrl];
    return url;
}

@end
