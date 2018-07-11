//
//  PhotoItem.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PhotoItem.h"

@implementation PhotoItem

//废弃了
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    
    if(self){
        self.photoUrl = [dic valueForKey:@"head_url"];
        self.pId = [[dic valueForKey:@"img_id"] integerValue];
    }
    return self;
}

- (instancetype)initWithId:(NSString *)pid url:(NSString *)url
{
    self = [super init];
    
    if(self){
        self.photoUrl = [url copy];
        self.pId = [pid integerValue];
    }
    return self;
}

- (BOOL)isEqual:(id)object
{
    if(object==self){
        return YES;
    }
    if(![object isKindOfClass:[PhotoItem class]]){
        return NO;
    }
    
    PhotoItem *item = (PhotoItem *)object;
    if(item.pId == self.pId){
        return YES;
    }
    
    return NO;
}
@end
