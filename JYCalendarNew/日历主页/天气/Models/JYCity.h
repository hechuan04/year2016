//
//  JYCity.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/6/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JYCityType){
    JYCityTypeInland = 0,//国内城市
    JYCityTypeWorld = 1
};

@interface JYCity : NSObject<NSCoding>

@property (nonatomic,copy) NSString *countryNameCN;
@property (nonatomic,copy) NSString *countryNameEN;
@property (nonatomic,copy) NSString *countyId;
@property (nonatomic,copy) NSString *county;//市县
@property (nonatomic,copy) NSString *countyPinyin;//市县拼音
@property (nonatomic,copy) NSString *city;//市
@property (nonatomic,copy) NSString *cityNameEN;
@property (nonatomic,copy) NSString *province;//省
@property (nonatomic,assign) JYCityType cityType;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithWorldDictionary:(NSDictionary *)dic;
@end
