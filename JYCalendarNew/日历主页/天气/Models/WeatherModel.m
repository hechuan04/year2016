//
//  WeatherModel.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/7/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "WeatherModel.h"
@interface WeatherModel()

@end
@implementation WeatherModel

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        if(!dic){
            return self;
        }
    
        /*old
        _weatherStr = [dic valueForKeyPath:@"cond.txt_d"];
        if([_weatherStr rangeOfString:@"/"].location != NSNotFound){
            NSArray *tmpArr = [_weatherStr componentsSeparatedByString:@"/"];
            _weatherStr = tmpArr[0];
        }
         _weatherStr = [_weatherStr stringByReplacingOccurrencesOfString:@"," withString:@" "];
         _weatherStr = [_weatherStr stringByReplacingOccurrencesOfString:@"，" withString:@" "];
        _weatherCode = [dic valueForKeyPath:@"cond.code_d"];
        _weatherIconName = [self weatherIconNameWithName:_weatherStr code:_weatherCode];
        _maxTemp = [[dic valueForKeyPath:@"tmp.max"] integerValue];
        _minTemp = [[dic valueForKeyPath:@"tmp.min"] integerValue];
         */
        
        _weatherStr = [dic valueForKey:@"type"];
        if([_weatherStr rangeOfString:@"/"].location != NSNotFound){
            NSArray *tmpArr = [_weatherStr componentsSeparatedByString:@"/"];
            _weatherStr = tmpArr[0];
        }
        _weatherStr = [_weatherStr stringByReplacingOccurrencesOfString:@"," withString:@" "];
        _weatherStr = [_weatherStr stringByReplacingOccurrencesOfString:@"，" withString:@" "];
        _weatherIconName = [self weatherIconNameWithName:_weatherStr code:_weatherCode];
        
        NSString *maxStr = [dic valueForKey:@"high"];
        if(maxStr.length>2){
            maxStr = [maxStr substringFromIndex:2];
        }
        NSString *minStr = [dic valueForKey:@"low"];
        if(minStr.length>2){
            minStr = [minStr substringFromIndex:2];
        }
        _maxTemp = [[maxStr substringToIndex:maxStr.length-1] integerValue];
        _minTemp = [[minStr substringToIndex:minStr.length-1] integerValue];
        
    }
    return self;
}
- (NSString *)weekCNStringWithComponets:(NSDateComponents *)components
{
    NSString *weekStr = nil;
    
    switch ([components weekday]) {
        case 1:
            weekStr = @"周日";
            break;
        case 2:
            weekStr = @"周一";
            break;
        case 3:
            weekStr = @"周二";
            break;
        case 4:
            weekStr = @"周三";
            break;
        case 5:
            weekStr = @"周四";
            break;
        case 6:
            weekStr = @"周五";
            break;
        case 7:
            weekStr = @"周六";
            break;
        default:
            break;
    }
    
    return weekStr;
}
- (NSString *)weatherIconNameWithName:(NSString *)name code:(NSString *)code
{
    NSString *iconName = nil;
    if([name isEqualToString: @"晴"]||[name rangeOfString: @"Sunny"].location != NSNotFound||[name rangeOfString: @"Calm"].location != NSNotFound){
        iconName = @"晴.png";
    }else if([name rangeOfString: @"阴"].location != NSNotFound||[name rangeOfString: @"Overcast"].location != NSNotFound){
        iconName = @"阴.png";
    }else if([name rangeOfString: @"雾"].location != NSNotFound||[name rangeOfString: @"Foggy"].location != NSNotFound||[name rangeOfString: @"Mist"].location != NSNotFound||[name rangeOfString: @"Haze"].location != NSNotFound||[name rangeOfString: @"霾"].location != NSNotFound){
        iconName = @"雾.png";
    }else if([name rangeOfString: @"雨夹雪"].location != NSNotFound||[name rangeOfString: @"Shower Snow"].location != NSNotFound||[name rangeOfString: @"Sleet"].location != NSNotFound){
        iconName = @"雨夹雪.png";
    }else if([name rangeOfString:@"冰雹"].location != NSNotFound||[name rangeOfString: @"Hail"].location != NSNotFound){
        iconName = @"冰雹.png";
    }else if([name rangeOfString:@"风"].location != NSNotFound||[name rangeOfString: @"Windy"].location != NSNotFound||[name rangeOfString: @"Breeze"].location != NSNotFound||[name rangeOfString: @"Gale"].location != NSNotFound||[name rangeOfString: @"Hurricane"].location != NSNotFound||[name rangeOfString: @"Tornado"].location != NSNotFound){
        iconName = @"暴风.png";
    }else if([name rangeOfString:@"雪"].location != NSNotFound||[name rangeOfString: @"Snow"].location != NSNotFound||[name rangeOfString: @"Snowstorm"].location != NSNotFound){
        iconName = @"暴雪.png";
    }else if([name rangeOfString:@"雨"].location != NSNotFound||[name rangeOfString: @"Rain"].location != NSNotFound||[name rangeOfString: @"rain"].location != NSNotFound){
        iconName = @"小雨.png";
    }else if([name rangeOfString:@"云"].location != NSNotFound||[name rangeOfString: @"Cloudy"].location != NSNotFound||[name rangeOfString: @"Clouds"].location != NSNotFound){
        iconName = @"多云.png";
    }else if([name rangeOfString:@"雷"].location != NSNotFound||[name rangeOfString: @"Thunder"].location != NSNotFound||[name rangeOfString: @"Storm"].location != NSNotFound){
        iconName = @"雷雨.png";
    }else if([name rangeOfString:@"沙"].location != NSNotFound || [name rangeOfString:@"尘"].location != NSNotFound||[name rangeOfString: @"Duststorm"].location != NSNotFound||[name rangeOfString: @"Dust"].location != NSNotFound||[name rangeOfString: @"Sand"].location != NSNotFound||[name rangeOfString: @"Sandstorm"].location != NSNotFound){
        iconName = @"沙尘暴.png";
    }else{
        iconName = [[NSString alloc] initWithFormat:@"%@%@.png", kWeatherPng,code];
    }
    return iconName;
}
@end
