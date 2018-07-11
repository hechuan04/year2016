//
//  CamerManager.m
//  FunnyBrowser
//
//  Created by Leo Gao on 15/12/3.
//  Copyright © 2015年 LeoGao. All rights reserved.
//

#import "CamerManager.h"

@implementation CamerManager

+ (instancetype)shareInstance{
    static CamerManager *instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

#pragma mark camera utility
- (void)showPhotoLibraryWithBlock:(void (^)())block{
    if ([self isPhotoLibraryAvailable]) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        switch (status) {
            case ALAuthorizationStatusNotDetermined:{
                ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
                
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    if (*stop) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(block){
                                block();
                            }
                        });
                    }
                    *stop = TRUE;
                } failureBlock:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请您在\"系统设置->隐私->照片\"中开启\"小秘\"的相机权限" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alter show];
                    });
                }];
                break;
            }
            case ALAuthorizationStatusRestricted:
            case ALAuthorizationStatusDenied:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请您在\"系统设置->隐私->照片\"中开启\"小秘\"的相机权限" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alter show];
                });
                break;
            }
            default:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block();
                    }
                });
                break;
            }
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"相册不可用" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)showCameraWithBlock:(void (^)())block{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (authStatus) {
            case AVAuthorizationStatusNotDetermined:{
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if(block){
                                block();
                            }
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                           
                            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请打开系统设置中\"隐私->相机\",允许\"小秘\"使用相机" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [alter show];
                        });
                    }
                }];
                break;
            }
            case AVAuthorizationStatusRestricted:
            case AVAuthorizationStatusDenied:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请打开系统设置中\"隐私->相机\",允许\"小秘\"使用相机" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alter show];
                });
                break;
            }
            default:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(block){
                        block();
                    }
                });
                break;
            }
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"相机不可用" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }

}

- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL)canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL)canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
@end
