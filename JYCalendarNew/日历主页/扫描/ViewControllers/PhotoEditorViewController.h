//
//  PhotoEditorViewController.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/24.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanFile.h"

@interface PhotoEditorViewController : UIViewController


@property (nonatomic,readonly) BOOL isFromCameraVC;


+ (instancetype)new __attribute__
((unavailable("[+new] is not allowed, use [initWithImage:] or [initWithScanFile:]")));

- (instancetype) init __attribute__
((unavailable("[-init] is not allowed, use [initWithImage:] or [initWithScanFile:]")));

- (id)initWithCoder:(NSCoder *)aDecoder __attribute__
((unavailable("[-initWithCoder:] is not allowed, use [initWithImage:] or [initWithScanFile:]")));

- (instancetype)initWithImage:(UIImage *)image;
- (instancetype)initWithScanFile:(ScanFile *)file;

@end
