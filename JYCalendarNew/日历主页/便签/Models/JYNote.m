//
//  JYNote.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "JYNote.h"

@implementation JYNote
@synthesize title = _title;
@synthesize content = _content;

- (NSMutableArray *)images
{
    if(!_images){
        _images = [NSMutableArray arrayWithCapacity:8];
    }
    return _images;
}

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        _tId = dic[@"tid"];
        _title = dic[@"title"];
        _content = dic[@"content"];
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.S";
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8*3600]];
        _syncTime = [formatter dateFromString:dic[@"updateTime"]];
        _updateTime = [formatter dateFromString:dic[@"updateTime"]];
        _createTime = [formatter dateFromString:dic[@"createTime"]];
        _imagePathRemote = dic[@"imagePath"];
        _imagePathLocal = @"";
    }
    return self;
}
@end
