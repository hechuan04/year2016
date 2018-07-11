//
//  ScanUploadModel.h
//  ScanDemo
//
//  Created by Gaolichao on 16/6/1.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanUploadModel : NSObject

@property (nonatomic,assign) BOOL isSingle;
@property (nonatomic,strong) NSArray *photoDataArray;
@property (nonatomic,copy) NSString *fileSize;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *textContent;
@property (nonatomic,assign) NSInteger fileType;
@property (nonatomic,assign) NSInteger dirId;

@end
