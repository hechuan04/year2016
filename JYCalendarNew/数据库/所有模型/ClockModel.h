//
//  ClockModel.h
//  JYCalendarNew
//
//  Created by 吴冬 on 16/3/4.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClockModel : NSObject

@property (nonatomic,assign) int year;
@property (nonatomic,assign) int month;
@property (nonatomic,assign) int day;
@property (nonatomic ,assign)int hour;
@property (nonatomic ,assign)int minute;
@property (nonatomic ,assign)int mid;
@property (nonatomic ,assign)int isOn;
@property (nonatomic ,assign)int musicID;

@property (nonatomic ,copy)NSString *textStr;
@property (nonatomic ,copy)NSString *timeDescribe;
@property (nonatomic ,copy)NSString *week;

@property (nonatomic ,copy)NSString *timeOrder;
@property (nonatomic ,assign)BOOL upData;

- (void)convertTimeToGMT;
- (void)convertTimeToLocal;

@end
