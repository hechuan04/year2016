//
//  CameraNavigationController.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/23.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "CameraNavigationController.h"
#import "CameraAuthorizationViewController.h"
#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraNavigationController ()

@end

@implementation CameraNavigationController

- (instancetype)init
{
    self = [super init];
    
    if(self){
        
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationBar.translucent = NO;
        self.navigationBar.barTintColor = [UIColor blackColor];
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (status) {
            case AVAuthorizationStatusAuthorized:
                [self setupAuthorizedWithDelegate];
                break;
                
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:
                [self setupDenied];
                break;
                
            case AVAuthorizationStatusNotDetermined:
                [self setupNotDeterminedWithDelegate];
                break;
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}
#pragma mark -
#pragma mark - Private methods
- (void)goBack:(UIBarButtonItem *)sender
{
    if([self.viewControllers count]>1){
        [self popViewControllerAnimated:YES];
    }
}
- (void)setupAuthorizedWithDelegate
{
    CameraViewController *viewController = [CameraViewController new];
    
    self.viewControllers = @[viewController];
}

- (void)setupDenied
{
    UIViewController *viewController = [CameraAuthorizationViewController new];
    self.viewControllers = @[viewController];
}

- (void)setupNotDeterminedWithDelegate
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            [self setupAuthorizedWithDelegate];
        } else {
            [self setupDenied];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}


@end
