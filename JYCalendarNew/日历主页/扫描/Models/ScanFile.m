//
//  ScanFile.m
//  ScanDemo
//
//  Created by Gaolichao on 16/5/24.
//  Copyright © 2016年 Test. All rights reserved.
//

#import "ScanFile.h"
#import "PaddingLabel.h"

@implementation ScanFile

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if(self){
        _fileId = [[dic objectForKey:@"fid"] integerValue];
        NSString *name = [dic objectForKey:@"name"];
        if(name&&![name isKindOfClass:[NSNull class]]&&![name isEqualToString:@"<null>"]){
            _name = [dic objectForKey:@"name"];
        }
        _fileSize = [dic objectForKey:@"fsize"];
        _imageUrlStr = [dic objectForKey:@"imgUrl"];
        _type = [[dic objectForKey:@"ftype"] integerValue];
        _textContent = [dic objectForKey:@"wordContent"];
        NSString *dateStr = [dic objectForKey:@"createtime"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.S";
        _createdTime = [formatter dateFromString:dateStr];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ScanFile *file = [ScanFile new];
    file.fileId = self.fileId;
    file.dirId = self.dirId;
    file.name = [self.name copy];
    file.fileSize = [self.fileSize copy];
    file.imageUrlStr = [self.imageUrlStr copy];
    file.textContent = [self.textContent copy];
    file.createdTime = [self.createdTime copy];
    file.type = self.type;
    file.status = self.status;
    file.imageData = [self.imageData copy];
    
    return file;
}
- (NSString *)pathForImageCache
{
    NSString *path = [[SDImageCache sharedImageCache] defaultCachePathForKey:self.imageUrlStr];
    return path;
}

#pragma mark UIActivityItemSource
- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
   
    if(self.type==1){//文本
        PaddingLabel *lbl = [[PaddingLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-12,100)];
        lbl.numberOfLines = 0;
        lbl.text = self.textContent;
        [lbl sizeToFit];
        
        return [UIImage imageForView:lbl];
    }
    //图片
    NSString *path = [self pathForImageCache];
    if(!path){
        path = [[NSBundle mainBundle]pathForResource:@"相册默认图片" ofType:@"png"];
    }
//    NSLog(@"path:%@====%f",path,[[[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil] fileSize]/1024.f);
    return [NSURL fileURLWithPath:path];
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return [UIImage new];
}


@end
