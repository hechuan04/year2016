//
//  ScanUtil.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/25.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScanFile.h"
#import "ScanDirectory.h"

@interface ScanUtil : NSObject

@property (nonatomic,copy) NSString *workDirectory;
@property (nonatomic,strong) NSDateFormatter *dateFormatterForDirectoryCell;
@property (nonatomic,strong) NSDateFormatter *dateFormatterForStorage;

+ (instancetype)sharedInstance;

//- (ScanFile *)savePhotoData:(NSData *)photoData inDirectory:(ScanDirectory *)dir;
//- (ScanDirectory *)createNewScanDirectory;


- (NSString *)getIPAddress;
/**
 *  重置所有扫描数据
 *
 *  @param dataArray : @[ScanDirectory];
 *
 *  @return 成功?
 */
- (BOOL)resetAllData:(NSArray *)dataArray;

- (NSArray *)findAllDirsWithUserId:(NSInteger)userID;
- (NSArray *)findAllFilesWithDirId:(NSInteger)dirId;
- (BOOL)insertNewScanDirectory:(ScanDirectory *)dir;
- (BOOL)insertNewScanFile:(ScanFile *)item;
- (BOOL)deleteAllDirectoryData;
- (BOOL)deleteAllFiles;
- (BOOL)updateDirWithId:(NSInteger)did name:(NSString *)name;
- (BOOL)deleteDirectoriesWithDidStr:(NSString *)didStr;
- (BOOL)deleteFilesWithFidStr:(NSString *)fidStr;
@end
