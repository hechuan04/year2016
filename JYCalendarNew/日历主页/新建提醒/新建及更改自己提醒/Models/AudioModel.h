//
//  AudioModel.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/5/18.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioModel : NSObject

@property (nonatomic,strong) NSNumber *duration;

@property (nonatomic,copy) NSString *relativePath;//本地相对路径
@property (nonatomic,copy) NSString *absolutePath;//本地绝对路径
@property (nonatomic,copy) NSString *remoteUrlPath;//url地址

@end
