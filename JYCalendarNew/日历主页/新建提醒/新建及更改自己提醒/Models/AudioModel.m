//
//  AudioModel.m
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import "AudioModel.h"

@implementation AudioModel

- (NSString *)absolutePath
{
    if(!_absolutePath){
        if(self.relativePath){
            NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            _absolutePath = [path stringByAppendingPathComponent:self.relativePath];
        }
    }
    return _absolutePath;
}
@end
