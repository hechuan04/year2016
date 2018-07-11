//
//  JYNote.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/4/26.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYNoteImage.h"

@interface JYNote : NSObject

@property (nonatomic,assign) NSInteger nId;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,strong) NSDate *createTime;
@property (nonatomic,copy) NSString *imagePathLocal;
@property (nonatomic,copy) NSString *imagePathRemote;
@property (nonatomic,strong) NSDate *updateTime;
@property (nonatomic,strong) NSDate *syncTime;
@property (nonatomic,copy) NSString *tId;//同步过后才有值

@property (nonatomic,strong) NSMutableArray *images;//of JYNoteImage


- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
