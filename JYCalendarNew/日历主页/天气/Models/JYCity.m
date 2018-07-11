//
//  JYCity.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/6/7.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYCity.h"

@implementation JYCity

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        if(!dic){
            return self;
        }
        _countyId = [dic valueForKey:@"countyId"];
        _city = [dic valueForKey:@"city"];
        _county = [dic valueForKey:@"county"];
        _countyPinyin = [dic valueForKey:@"countyPinYin"];
        _province = [dic valueForKey:@"province"];
        _cityType = JYCityTypeInland;
        _countryNameCN = @"中国";
        _countryNameEN = @"China";
    }
    return self;
}
- (instancetype)initWithWorldDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        if(!dic){
            return self;
        }
        _countryNameCN = [dic valueForKey:@"countryNameCN"];
        _countryNameEN = [dic valueForKey:@"countryNameEN"];
        _cityNameEN = [dic valueForKey:@"cityNameEN"];
        _city = [dic valueForKey:@"cityNameCN"];
        _cityType = JYCityTypeWorld;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        self.countyId =  [aDecoder decodeObjectForKey:@"countyId"];
        self.county =  [aDecoder decodeObjectForKey:@"county"];
        self.countyPinyin =  [aDecoder decodeObjectForKey:@"countyPinyin"];
        self.city =  [aDecoder decodeObjectForKey:@"city"];
        self.province =  [aDecoder decodeObjectForKey:@"province"];
        self.countryNameCN =  [aDecoder decodeObjectForKey:@"countryNameCN"];
        self.countryNameEN =  [aDecoder decodeObjectForKey:@"countryNameEN"];
        self.cityNameEN = [aDecoder decodeObjectForKey:@"cityNameEN"];
        self.cityType = [aDecoder decodeIntegerForKey:@"cityType"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.countyId forKey:@"countyId"];
    [aCoder encodeObject:self.county forKey:@"county"];
    [aCoder encodeObject:self.countyPinyin forKey:@"countyPinyin"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.countryNameCN forKey:@"countryNameCN"];
    [aCoder encodeObject:self.countryNameEN forKey:@"countryNameEN"];
    [aCoder encodeObject:self.cityNameEN forKey:@"cityNameEN"];
    [aCoder encodeInteger:self.cityType forKey:@"cityType"];
}

- (NSString *)description
{
    NSString *des = [NSString stringWithFormat:@"\n{%@,%@,%@}",_countyId,_city,_countyPinyin];
    return des;
}
@end
