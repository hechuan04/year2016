//
//  BasePushViewController.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "BasePushViewController.h"

@interface BasePushViewController ()

@end

@implementation BasePushViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[JYSkinManager shareSkinManager].backImage forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 25, 25);
    leftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [leftBtn addTarget:self action:@selector(popAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
}

#pragma mark - go back
- (void)popAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
