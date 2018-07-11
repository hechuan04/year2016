//
//  NSString+Common.m
//  JYCalendarNew
//
//  Created by Leo Gao on 16/4/2.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "NSString+Common.h"

@implementation NSString (Common)

- (NSString *)trimWhitespace
{
    NSMutableString *str = [self mutableCopy];
    CFStringTrimWhitespace((__bridge CFMutableStringRef)str);
    return str;
}

- (BOOL)isEmpty
{
    return [self isEqualToString:@""];
}

- (BOOL)isPureInt
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

- (NSString *)transformToPinyin {
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *)[mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [mutableString stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

//含有emoji表情是截取字符可能不全
-(NSString *)subEmojiStringToIndex:(NSInteger)index{
    
    if (index>=0) {
        const char *res = [self substringToIndex:index].UTF8String;
        if(res == NULL){
            return [self subEmojiStringToIndex:index - 1];
        }else{
            return [self substringToIndex:index];
        }
    }else{
        return @"";
    }
}
- (NSString *)transformToSqlString
{
    return [self stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
}
@end
