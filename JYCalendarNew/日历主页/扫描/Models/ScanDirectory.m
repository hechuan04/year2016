//
//  ScanDirectory.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/26.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ScanDirectory.h"
#import "ScanFile.h"

@implementation ScanDirectory

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    
    self = [super init];
    
    if(self){
        
        _dirId = [[dic objectForKey:@"did"] integerValue];
        _name = [dic objectForKey:@"name"];
        _userId = [[dic objectForKey:@"uid"] integerValue];
        NSString *dateStr = [dic objectForKey:@"createtime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.S";
        _createdTime = [formatter dateFromString:dateStr];
        
        NSArray *saoFile = [dic objectForKey:@"scSaoFile"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[saoFile count]];
        for(int i=0;i<[saoFile count];i++){
            ScanFile *file = [[ScanFile alloc]initWithDictionary:saoFile[i]];
            file.dirId = _dirId;
            [arr addObject:file];
        }
        _files = [NSArray arrayWithArray:arr];
    }
    return self;
}

@end
