//
//  ScanFile.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/24.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
//
//typedef NS_ENUM(NSInteger,ScanFileType){
//    ScanFileTypeImage = 0,
//    ScanFileTypeText
//};

@interface ScanFile : NSObject<NSCopying,UIActivityItemSource>

@property (nonatomic,assign) NSInteger fileId;
@property (nonatomic,assign) NSInteger dirId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *imageUrlStr;
@property (nonatomic,copy) NSString *textContent;
@property (nonatomic,copy) NSString *fileSize;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) NSDate *createdTime;

@property (nonatomic,strong) NSData *imageData;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

- (NSString *)pathForImageCache;

@end
