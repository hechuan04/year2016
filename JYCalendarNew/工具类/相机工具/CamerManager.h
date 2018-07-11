//
//  CamerManager.h
//  FunnyBrowser
//
//  Created by Leo Gao on 15/12/3.
//  Copyright © 2015年 LeoGao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface CamerManager : NSObject

+ (instancetype)shareInstance;

- (void)showPhotoLibraryWithBlock:(void (^)())block;
- (void)showCameraWithBlock:(void (^)())block;
- (BOOL)isCameraAvailable;
- (BOOL)isRearCameraAvailable;
- (BOOL)isFrontCameraAvailable;
- (BOOL)doesCameraSupportTakingPhotos;
- (BOOL)isPhotoLibraryAvailable;
- (BOOL)canUserPickVideosFromPhotoLibrary;
- (BOOL)canUserPickPhotosFromPhotoLibrary;
- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;
@end
