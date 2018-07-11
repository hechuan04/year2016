//
//  CameraViewController.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/23.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CameraDelegate<NSObject>

@end


@interface CameraViewController : UIViewController

@property (nonatomic,weak) id<CameraDelegate> delegate;

@end
