//
//  TextViewController.h
//  ScanDemo
//
//  Created by Gaolichao on 16/6/3.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanFile.h"

@interface TextViewController : UIViewController

@property (nonatomic,weak) UIViewController *superViewController;

@property (nonatomic,strong) ScanFile *file;

@end
