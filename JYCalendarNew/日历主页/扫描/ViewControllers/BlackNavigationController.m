//
//  BlackNavigationController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/27.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "BlackNavigationController.h"

@interface BlackNavigationController ()

@end

@implementation BlackNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor blackColor];
    
}

@end
