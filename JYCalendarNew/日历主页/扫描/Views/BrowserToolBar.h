//
//  BrowserToolBar.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/19.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrowserToolBar;

@protocol BrowserToolBarDelegate<NSObject>

- (void)browserTollBar:(BrowserToolBar *)toolBar shareButtonClicked:(UIButton *)sender;
- (void)browserTollBar:(BrowserToolBar *)toolBar deleteButtonClicked:(UIButton *)sender;
- (void)browserTollBar:(BrowserToolBar *)toolBar takePhotoButtonClicked:(UIButton *)sender;

@end

@interface BrowserToolBar : UIView

@property (nonatomic,strong) UIImageView *backgroundView;
@property (nonatomic,strong) UIButton *takePhotoButton;
@property (nonatomic,strong) UIView *toolBar;

@property (nonatomic,strong) UIButton *shareButton;
@property (nonatomic,strong) UIButton *deleteButton;

@property (nonatomic,weak) id<BrowserToolBarDelegate> delegate;

@end
