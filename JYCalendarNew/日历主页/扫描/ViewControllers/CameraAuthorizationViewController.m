//
//  CameraAuthorizationViewController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/23.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "CameraAuthorizationViewController.h"
#import "Masonry.h"

@interface CameraAuthorizationViewController ()

@property (nonatomic,strong) UILabel *descLabel;
@property (nonatomic,strong) UIButton *closeButton;

@end

@implementation CameraAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UILabel *label = [UILabel new];
    label.text = @"您尚未授权应用访问相机，如需使用此功能请到设置中进行相应授权！";
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    self.descLabel = label;

    
    
    UIButton *closeBtn = [UIButton new];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    self.closeButton = closeBtn;
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(30.f);
        make.right.equalTo(self.view).offset(-30.f);
        make.centerY.equalTo(self.view).offset(-50.f);
        make.centerX.equalTo(self.view);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(40.f);
        make.centerX.equalTo(self.view);
    }];
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)closeButtonClicked:(UIButton *)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
