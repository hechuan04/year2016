//
//  JYFontManager.h
//  JYCalendar
//
//  Created by 吴冬 on 15/10/21.
//  Copyright (c) 2015年 玄机天地. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYFontManager : NSObject
typedef NS_ENUM(NSInteger, sys){
    
    Type_iPhone4  = 1,
    Type_iPhone5  = 2,
    Type_iPhone6  = 3,
    Type_iPhone6p = 4,
    Type_other    = 5,
    
    
};

+ (JYFontManager *)shareFontManager;

//返回型号
+ (NSString *)getCurrentDeviceModel;
+ (NSInteger )returnType:(NSString *)str;

@end
