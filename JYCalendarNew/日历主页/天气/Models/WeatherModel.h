//
//  WeatherModel.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

//@property (nonatomic, copy) NSString *dateStr;
//@property (nonatomic, copy) NSString *weekStr;
@property (nonatomic, copy) NSString *weatherStr;
@property (nonatomic, copy) NSString *weatherCode;
@property (nonatomic, copy) NSString *weatherIconName;
@property (nonatomic, copy) NSString *feeling;
@property (nonatomic, assign) NSInteger maxTemp;
@property (nonatomic, assign) NSInteger minTemp;


- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
