//
//  PhotoEditorTitleView.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/31.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoEditorTitleView;

@protocol PhotoEditorTitleViewDelegate<NSObject>

- (void)titleButtonClicked:(PhotoEditorTitleView *)titleView;
- (void)pullDownButtonClicked:(PhotoEditorTitleView *)titleView;

@end

@interface PhotoEditorTitleView : UIView

@property (nonatomic,strong) UIButton *titleButton;
@property (nonatomic,strong) UIButton *pullDownButton;

@property (nonatomic,weak) id<PhotoEditorTitleViewDelegate> delegate;

//定制属性
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIImage *image;

@end
