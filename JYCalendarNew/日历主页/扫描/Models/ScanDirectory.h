//
//  ScanDirectory.h
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScanDirectory : NSObject

@property (nonatomic,assign) NSInteger dirId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) NSDate *createdTime;

//tmp proterty
@property (nonatomic,assign) NSInteger userId;
@property (nonatomic,copy) NSString *thumbUrlStr;
@property (nonatomic,strong) NSArray *files;//of ScanFile
@property (nonatomic,assign) NSInteger fileCount;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
