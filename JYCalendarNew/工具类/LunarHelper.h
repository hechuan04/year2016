//
//  LunarHelper.h
//  LunarCore
//
//  Created by Gaolichao on 2017/1/5.
//  Copyright © 2017年 cyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LunarHelper : NSObject

@property (nonatomic,strong) NSDictionary *solarTermsDic;
@property (nonatomic,strong) NSArray *heavenlyStems;
@property (nonatomic,strong) NSArray *earthlyBranches;

+ (instancetype)sharedInstance;

//计算年干支
- (NSString *)calculateYearGanZhiWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

//计算月干支
- (NSString *)calculateMonthGanZhiWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

//生肖
- (NSString *)getZodia:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end
