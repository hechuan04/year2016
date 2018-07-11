//
//  PhotoGroup.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/3/14.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "PhotoGroup.h"
#import "PhotoItem.h"

@implementation PhotoGroup

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    
    if(self){
        
        NSString *dateStr = [dic valueForKey:@"create_time"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        _createdTime = [formatter dateFromString:dateStr];
        
        NSArray *idAry = [[dic objectForKey:@"img_id"] componentsSeparatedByString:@","];
        NSArray *urlAry = [[dic objectForKey:@"head_url"] componentsSeparatedByString:@","];
        _photoItems = [NSMutableArray arrayWithCapacity:[idAry count]];
        for(int i=0;i<[idAry count];i++){
            PhotoItem *item = [[PhotoItem alloc]initWithId:idAry[i] url:urlAry[i]];
            [_photoItems addObject:item];
        }

    }
    return self;
}
@end
