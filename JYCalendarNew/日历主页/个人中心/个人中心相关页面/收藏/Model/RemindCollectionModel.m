//
//  RemindCollectionModel.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/11.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "RemindCollectionModel.h"

@implementation RemindCollectionModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    
    if(self){
        
        self.mid = [[dic valueForKey:@"mid"] integerValue];
        self.sid = [[dic valueForKey:@"sid"] integerValue];
        
        if([[dic valueForKey:@"sendUhead"] isKindOfClass:[NSNull class]]){
            self.avatarUrl = @"";
        }else{
            self.avatarUrl = [dic valueForKey:@"sendUhead"];
        }
        if(![[dic valueForKey:@"sendUname"] isKindOfClass:[NSNull class]]){
            self.senderName = [dic valueForKey:@"sendUname"];
        }
        if(![[dic valueForKey:@"sendUid"] isKindOfClass:[NSNull class]]){
            self.senderUid = [dic valueForKey:@"sendUid"];
        }
        if([[dic valueForKey:@"title"] isKindOfClass:[NSNull class]]){
            self.title = @"";
        }else{
            self.title = [dic valueForKey:@"title"];
        }
        if([[dic valueForKey:@"createTime"] isKindOfClass:[NSNull class]]){
            self.createTime = nil;
        }else{
            NSString *dateStr = [dic valueForKey:@"createTime"];
            if(dateStr.length>2){
                dateStr = [dateStr substringToIndex:dateStr.length-2];
                NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8*3600];
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                self.createTime = [formatter dateFromString:dateStr];
            }
        }
    }
    return self;
}
@end
