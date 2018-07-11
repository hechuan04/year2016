//
//  JYNoteImage.h
//  JYCalendarNew
//
//  Created by Gaolichao on 16/8/30.
//  Copyright © 2016年 北京金源互动科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,JYImageType){
    JYImageTypeLocal = 1,
    JYImageTypeRemote
};

@interface JYNoteImage : NSObject

@property (nonatomic,assign) JYImageType imageType;
@property (nonatomic,copy) NSString *path;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) BOOL hasSaved;//local type

@end
